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
    String? sample_id
    File index_tgz
    Boolean paired = true
    Int threads = 1
    Int? read_len
  }

  String output_prefix = select_first([sample_id, basename(vcf, ".vcf.gz")])

  if (!defined(read_len)) {
    call params_from_fq {
      input:
        fq_gz=fq_gzs[0]
    }
  }

  Int actual_read_len = select_first([read_len, params_from_fq.max_read_len])

  if (defined(sample_id)) {
    call align.filter_vcf {
      input:
        vcf=vcf,
        sample_id=sample_id
    }
    File filtered_vcf = filter_vcf.vcf
  }

  File actual_vcf = select_first([filtered_vcf, vcf])

  call align.align_fq {
    input:
      fq_gzs=fq_gzs,
      vcf=actual_vcf,
      index_tgz=index_tgz,
      paired=paired,
      threads=threads,
      read_len=actual_read_len,
      output_prefix=output_prefix
  }

  output {
    File allele_counts = align_fq.allele_counts
  }
}