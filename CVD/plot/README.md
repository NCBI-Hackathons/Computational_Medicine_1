# Where are you on population risk score distribution?

Here we present a simple tool for visualization of individual's risk position at population level. 

To run this script, we need the following input - 

* `--G1000ref_table`: this field is for `G1000_snps.txt`, generated from tool1.py as previously described. It is a matrix where columns are RSids and rows are individuals from 1000 genomes project.
* `--ROI`: stands for "RS ids of interest". Please check for `rsList.txt`. It is a table of four columns - rs numbers, two p values (which are not used in this script) and an effect size estimate.
* `--ind_table`: is the SNP genotyping table of an individual, which assembles one row of the `G1000ref_table`. `individual_snps.txt` is an example.
* `--out_pdf`: provides the name of the output pdf. An eligible name should end with ".pdf".

Run this script by

`Rscript riskscore_dist_viz.R --G1000ref_table G1000_snps.txt --ROI rsList.txt --ind_table individual_snps.txt --out_pdf indrisk_dist.pdf`