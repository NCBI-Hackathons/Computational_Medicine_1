
# **SNAPPY RISK** -- A Template For Producing A Polygenic Risk Score For The Masses

#### *hackathon team:*

#### *insert link to doi or citation*

#### [Link to Presentation](https://docs.google.com/presentation/d/1QgcN_QEQccpOUKctkwVCtzaE_Z_UvFrr50JRNkq9eJc/edit#slide=id.g5971a2130c_0_17)

## What is **SNAPPY RISK?**
A [model](https://www.lucidchart.com/invitations/accept/4f6b4edf-c7cd-4302-a349-bc40e1a4c9b2) which can be used to predict an individual's Polygenic Risk Score (PRS) for Hypertrophic Cardiomyopathy using the results of a genotype array. It also includes the necessary code to extract data from public sources and prepare into into a format suitable for the PRS calculation.

##  Significance of a Polygenic Risk Score:
Assuming there is a family in which most individuals display a particular phenotypic trait derived from a specific disease diagnosis, the aim is to target the unresolved and provide with a polygenic risk score which would demonstrate how well "protected" the individual(s) in question are from acquiring the phenotypic trait.


##   What's the problem and why should we solve it?
When multiple individuals in a family have acquired the same phenotypic trait from a disease they have been previously diagnosed with, the situation pursues a more efficient form of notifying interested individuals how protected they are from obtaining this phenotypic trait or how susceptible they are to it. The output is in the form of a penetrance estimate. 


## Software Workflow Diagram:
**Input:** penetrance estimate and snp chip data 
  1. 2500 samples from the https://en.wikipedia.org/wiki/1000_Genomes_Project acquired from ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/
  2. the GWAS Catalog from https://www.ebi.ac.uk/gwas/
  + The gwas catalog was:
    - parsed for specific variants related to self reported cases of Hypertrophic Cardiomyopathy (HCM) using a filtered search using key-phrase "*cardiomyop.*" 
    - calculated filtered variants' minor allelic counts for each individual in the sample cohort. These measures were then used to populate a matrix, with variants as columns and individuals as rows.        
    
  2. A filter was then applied in the allelic count matrix to variants which had a Odds Ratio (OR) of association with a particular phenotype. 
  
*With the use of these approaches, we aim to prioritize genes in a genomic interval of interest according to their predicted strength-of-association with a given disease (in this case HCM).* 

  4. The genotypes were then used to fit a model which can be used to provide a polygenic risk score for an individual who may or may not be at risk for HCM. 
  
*This can act as a tool to clinicians in the diagnosis and characterization of HCM. These methods can also be used to create models for other diseases which have a genetic cause and broaden the range of diseases we can assess through genotyping data.*
   
   
 **Output:** the polygenic score and a histogram of the population risk across the 2500+ samples of the 1000 Genomes Project.


## Dependencies: 

 GWAS Catalog "All associations" file v1.0.2 from [https://www.ebi.ac.uk/gwas/api/search/downloads/alternative](https://www.ebi.ac.uk/gwas/api/search/downloads/alternative) as provided by [https://www.ebi.ac.uk/gwas/docs/file-downloads](https://www.ebi.ac.uk/gwas/docs/file-downloads)
 
1000 Genomes project as downloaded from ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/

Python 3.5 (or later) https://www.python.org/

R 3.5 (or later) https://www.r-project.org/ 


**Citations:**

Machiela MJ, Chanock SJ. LDlink a web-based application for exploring population-specific haplotype structure and linking correlated alleles of possible functional variants. Bioinformatics. 2015 Jul 2. PMID: 26139635. 

Vanunu O, Magger O, Ruppin E, Shlomi T, Sharan R. Associating genes and protein complexes with disease via network propagation. PLoS Comput Biol. 2010;6(1):e1000641






