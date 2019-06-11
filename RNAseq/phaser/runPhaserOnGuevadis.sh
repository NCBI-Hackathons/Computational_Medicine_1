#!/bin/bash -ex 

# download genotype from https://www.ebi.ac.uk/arrayexpress/experiments/E-GEUV-1/files/genotypes/
# e.g. chr11 
wget https://www.ebi.ac.uk/arrayexpress/experiments/E-GEUV-1/files/genotypes/GEUVADIS.chr11.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.vcf.gz

# change identifer from integer to chr[0-9x]
gunzip GEUVADIS.chr11.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.vcf.gz 
awk '/^#/{print;next} {print "chr"$0}' GEUVADIS.chr11.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.vcf > GEUVADIS.chr11.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.chr.vcf

# zip vcf again 
bgzip GEUVADIS.chr11.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.chr.vcf
tabix -p vcf GEUVADIS.chr11.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.chr.vcf

# download RNA-seq BAM files and run phaser.py
# https://www.ebi.ac.uk/arrayexpress/experiments/E-GEUV-1/files/processed/ 
for i in $(cat rna_seq_list_rnd); do
	if [ ! -f $i ]; then
		wget https://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/$i
	fi	
	sampleName=$(echo $i| awk -F'[_.]' '{print $1}')
	samtools index $i
	python2.7 phaser/phaser.py --vcf GEUVADIS.chr11.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.chr.vcf.gz --bam $i --paired_end 1 --mapq 255 --baseq 10 --sample $sampleName --o $sampleName --threads 12
done	

