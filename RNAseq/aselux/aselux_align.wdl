version 1.0

task filter_vcf {
  input {
    File vcf
    String sample_id
  }

  String output_filename = basename(vcf, "vcf.gz") + "-filtered.vcf.gz"

  command <<<
  bcftools -a -s ~{sample_id} -U -e 'GT="ref"' -Oz -o ~{output_filename}
  >>>

  runtime {
    docker: "compmed/samtools:latest"
  }

  output {
    File filtered_vcf = "${output_filename}"
  }
}

task align_fq {
  input {
    Array[File] fq_gzs
    File vcf
    File index_tgz
    Int read_len
    Int threads = 1
    Boolean paired = true
    String output_prefix = basename(vcf, ".vcf.gz")
  }

  command <<<
  mkdir index
  tar -C index -xzf ~{index_tgz}
  ASElux align --fq \
    ~{if paired then "--pe" else "--se"} \
    --readLen ~{read_len} \
    --index index/~{basename(index_tgz, ".index.tgz")} \
    --vcf ~{vcf} \
    --seqFiles ~{sep=" " fq_gzs} \
    --nthread ~{threads} \
    --out ~{output_prefix}
  >>>

  runtime {
    docker: "compmed/aselux:latest"
    cpu: threads
  }

  output {
    File allele_counts = "${output_prefix}.counts"
  }
}
