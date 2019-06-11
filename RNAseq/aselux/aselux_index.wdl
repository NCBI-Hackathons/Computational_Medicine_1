version 1.0

task build_index {
  input {
    File reference_gz
    File gtf_gz
    String? output_prefix
  }

  String reference_base = basename(reference_gz, ".gz")
  String gtf_base = basename(gtf_gz, ".gz")
  String actual_output_prefix = select_first([
    output_prefix,
    basename(reference_base, ".fasta") + "_" + basename(gtf_base, ".annotation.gtf")
  ])

  command <<<
  gunzip -c ~{reference_gz} | perl -pe 's/^(>[^ ]+).*/$1/' > ~{reference_base}
  gunzip -c ~{gtf_gz} | perl -pe 's/^chr//' > ~{gtf_base}
  ASElux build --gtf ~{gtf_base} \
    --ref ~{reference_base} \
    --out ~{output_prefix}
  tar -czf ~{output_prefix}.index.tgz ~{output_prefix}.*
  >>>

  runtime {
    docker: "compmed/aselux:latest"
  }

  output {
    File index_tgz = "${output_prefix}.index.tgz"
  }
}

workflow build_index_wf {
  input {
    File reference_gz
    File gtf_gz
  }

  call build_index {
    input:
      reference_gz=reference_gz,
      gtf_gz=gtf_gz
  }

  output {
    File index_tgz = build_index.index_tgz
  }
}
