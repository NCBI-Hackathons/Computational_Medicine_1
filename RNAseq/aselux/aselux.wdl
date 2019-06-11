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

task paired_bam_to_fastq {
  input {
    File bam
    String output_prefix = basename(bam, ".bam")
  }

  command <<<
  samtools fastq -n -1 ~{output_prefix}.1.fq.gz -2 ~{output_prefix}.2.fq.gz ~{bam}
  >>>

  runtime {
    docker: "compmed/samtools:latest"
  }

  output {
    Array[File] fq_gzs = ["${output_prefix}.1.fq.gz", "${output_prefix}.2.fq.gz"]
  }
}

task single_bam_to_fastq {
  input {
    File bam
    String output_prefix = basename(bam, ".bam")
  }

  command <<<
  samtools fastq -n -s ~{output_prefix}.1.fq.gz ~{bam}
  >>>

  runtime {
    docker: "compmed/samtools:latest"
  }

  output {
    File fq_gz = "${output_prefix}.fq.gz"
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

task params_from_fq {
  input {
    File fq_gz
    Int num_rec = 1000
  }

  command <<<
  zcat ~{fq_gz} | head -~{num_rec * 4} | \
    awk '{if (NR % 4 == 2 and length($0) > max) max = length($0)} END {print max}'
  >>>

  runtime {
    docker: "debian:stretch-slim"
  }

  output {
    Int max_read_len = read_int(stdout())
  }
}

task params_from_bam {
  input {
    File bam
    Int num_rec = 1000
  }

  command <<<
  samtools view bam | \
    cut -f 2,10 | \
    awk '$1 % 2 == 1 {paired = 1} length($2) > max {max = length($2)} {print max"\t"paired}'
  >>>

  runtime {
    docker: "compmed/samtools:latest"
  }

  Array[Array[String]] result = read_tsv(stdout())

  output {
    Int max_read_len = read_int(result[0][0])
    Boolean paired = read_boolean(result[0][1])
  }
}

workflow align_fq_wf {
  input {
    Array[File] fq_gzs
    File vcf
    File index_tgz
    Boolean paired = true
    Int threads = 1
    Int? read_len
  }

  if (!defined(read_len)) {
    call params_from_fq {
      input:
        fq_gz=fq_gzs[0]
    }
  }

  Int actual_read_len = select_first([read_len, params_from_fq.max_read_len])

  call align_fq {
    input:
      fq_gzs=fq_gzs,
      vcf=vcf,
      index_tgz=index_tgz,
      paired=paired,
      threads=threads,
      read_len=actual_read_len
  }

  output {
    File = align_fq.
  }
}

workflow align_bam_wf {
  input {
    Array[File] bams
    File vcf
    File index_tgz
    Int threads = 1
    Boolean? paired
    Int? read_len
  }

  if (!defined(read_len) || !defined(paired)) {
    call params_from_bam {
      input:
        bam=bams[0]
    }
  }

  Int actual_read_len = select_first([read_len, params_from_bam.max_read_len])
  Int actual_paired = select_first([paired, params_from_bam.paired])

  if (actual_paired) {
    scatter (bam in bams) {
      call paired_bam_to_fastq {
        input:
          bam=bam
      }
    }
    Array[File] fq_gzs = flatten(paired_bam_to_fastq.fq_gzs)
  }

  if (!actual_paired) {
    scatter (bam in bams) {
      call single_bam_to_fastq {
        input:
          bam=bam
      }
    }
    Array[File] fq_gzs = single_bam_to_fastq.fq_gz
  }

  call align_fq {
    input:
      fq_gzs=fq_gzs,
      vcf=vcf,
      index_tgz=index_tgz,
      threads=threads,
      read_len=actual_read_len,
      paired=actual_paired
  }

  output {
    File = align_fq.
  }
}
