# NCBI Computational Medicine Hackathon - Whatshap bash script
# Author: Yuchen Ge
# Date: 06/11/2019

# Usage: bash whatshap.sh genome.fa input.bam
# Output: input.mpileup input.vcf phased.vcf

PREFIX=${2%.*}
PREFIX=${PREFIX##*/}

# 1. Pileup the bam file
samtools mpileup -f $1 $2 > ${PREFIX}.mpileup

# 2. Generate VCF file
java -jar tools/VarScan.v2.3.9.jar mpileup2snp ${PREFIX}.mpileup --output-vcf 1 > ${PREFIX}.vcf

# 3. Resolve the haplotypes using whatshap. Output phased.vcf
whatshap phase -o ${PREFIX}_phased.vcf ${PREFIX}.vcf $2
