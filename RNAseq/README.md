
# Workstream 1: Reproduce Jadhav et al. Pipeline

[Jadhav et al.](https://www.biorxiv.org/content/biorxiv/early/2018/10/15/269449.full.pdf) developed a pipeline for phasing trios and associating haplotypes with gene expression, using samples from 1000 Genomes and Genome of the Netherlands. This workstream will create a reproducible pipeline in [WDL 1.0](https://github.com/openwdl/wdl/blob/master/versions/1.0/SPEC.md), which can be executed locally, on HPC, or on the cloud using [Cromwell](https://cromwell.readthedocs.io/en/stable/).

## Pipeline overview

The pipeline is divided into two parts: 1) genotype phasing and imputation, and 2) RNA-Seq analysis.

### Phasing and imputation

This part of the pipeline is quite complex and time-consuming. To make this project tractable for a two-day hackathon, we utilize the [1000 Genomes Phase 3 Release VCFs](ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/).

Parental origin of alleles in heterozygous SNVs are assigned using the [custom R script from Jadhav et al.](https://github.com/SharpLabMSSM/PofOAssignment).

#### Workstream 0 (optional): This part of the pipeline can be prepended by [WhatsHap](https://whatshap.readthedocs.io/en/latest/) read-backed phasing and/or [phASER](https://github.com/secastel/phaser) for long-range variant phasing from the RNA-Seq data.  

``` 
Scripts for Workstream 0:
* https://github.com/NCBI-Hackathons/Computational_Medicine_1/blob/master/RNAseq/whatshap.sh
* <phASER script>
```

### RNA-Seq analysis

```
* QC (FastQC)
* Trimming - they use Trimmomatic, Cutadapt, or Sickle; we can use Atropos
  * Remove adapters and other over-repesented sequences
  * Filter reads < 30 bp
* Align with STAR
  * Reference genomes must match between genotypes and RNA-Seq. For this dataset we will use GRCh37.
  * GENCODE transcripts.
* Correct for reference bias - they use WASP
* Quantify read counts associated with each allele at heterozygous SNVs using [AlleleCounter](https://github.com/secastel/allelecounter)
* Assign read counts to parental haplotypes
  * Discard multi-mapping reads
  * Discard reads with (mean?) base quality <= 10
* Remove het SNVs that
  * Have mappability < 1 (based on UCSC genome browser mappability track)
  * Overlap CNVs with MAF ≥5% identified in [1000 Genomes](ftp://ftp.1000genomes.ebi.ac.uk/vol1/withdrawn/phase3/integrated_sv_map/) and common CNVs from Conrad et al. 2010.
  * Overlap SegDups or simple repeats from UCSC
* Assign SNVs to unique gene fragments (UGFs) and sum their read counts.
* Apply statistical test (Wilcox, ShrinkBayes) to test for PoO-specific expression.
```

### We're awesome!
