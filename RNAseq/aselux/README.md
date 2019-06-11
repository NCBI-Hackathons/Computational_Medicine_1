# ASElux

[ASElux](https://github.com/abl0719/ASElux) is a tool for allele-specific read counting in RNA-Seq. It takes as input FASTQ file(s) and a VCF file with phased genotypes. It maps the reads to the genome in a manner that minimzes reference bias. Then, for each heterozygous variant in the VCF, it generates allele-specific read counts.

Allele-specific read counts have a variety of uses. For example, they can be used in to identify allele-specific eQTL (aseQTL) - variants in which different alleles have different effects on expression of nearby genes - or to identify imprinted genes (such as in [Jadhav et al.](https://www.biorxiv.org/content/10.1101/269449v3.full)).

## Docker image

The Docker image can be built using the following command:

`docker build -t compmed/aselux .`

## Workflow

We provide three WDL workflows for using ASElux:

* Index (aselux_index.wdl): this workflow must be run once for each combination of reference genome and gene annotation you want to use, to create the index ASElux uses for mapping.
* Align FASTQs (aselux_fq.wdl): use this workflow to align FASTQ files.
* Align BAMs (aselux_bam.wdl): use this workflow to align BAM files.

To run these workflows using [Cromwell](https://cromwell.readthedocs.io/en/stable/), the general form of the command is:

`java -jar Cromwell.jar run -inputs workflow_inputs.json workflow.wdl`

For each workflow, we provide an example inputs JSON file that you can customize with your specific parameters.

Note: if you have trouble running these commands, try adding the `-Ddocker.hash-lookup.enabled=false` java option, which will prevent Cromwell from trying to look up Docker images in public repositories.
