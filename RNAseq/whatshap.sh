# NCBI Computational Medicine Hackathon - Whatshap bash script
# Author: Yuchen Ge
# Date: 06/11/2019

# Usage: bash whatshap.sh input_bam_file
# Output: input.mpileup input.vcf phased.vcf

PREFIX=${1%.*}
PREFIX=${PREFIX##*/}

# 1. Pileup the bam file
samtools mpileup -f genome/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna $1 > ${PREFIX}.mpileup

# 2. Generate VCF file
java -jar tools/VarScan.v2.3.9.jar mpileup2snp ${PREFIX}.mpileup --output-vcf 1 > ${PREFIX}.vcf

# 3. Resolve the haplotypes using whatshap. Output phased.vcf
whatshap phase -o ${PREFIX}_phased.vcf ${PREFIX}.vcf $1
