version 1.0

import "aselux_align.wdl" as align

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
    call aselux.params_from_bam {
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

  call align.align_fq {
    input:
      fq_gzs=fq_gzs,
      vcf=vcf,
      index_tgz=index_tgz,
      threads=threads,
      read_len=actual_read_len,
      paired=actual_paired
  }

  output {
    File allele_counts = align_fq.allele_counts
  }
}
