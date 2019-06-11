version 1.0

import "aselux_align.wdl" as align


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

  call align.align_fq {
    input:
      fq_gzs=fq_gzs,
      vcf=vcf,
      index_tgz=index_tgz,
      paired=paired,
      threads=threads,
      read_len=actual_read_len
  }

  output {
    File allele_counts = align_fq.allele_counts
  }
}