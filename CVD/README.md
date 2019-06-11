


## Pipeline overview




----


# **NAME OF PIPELINE** -- A Template For Producing A Polygenic Risk Score For The Masses

#### *hackathon team:*

#### *insert link to doi or citation*

#### [Link to Presentation](https://docs.google.com/presentation/d/1QgcN_QEQccpOUKctkwVCtzaE_Z_UvFrr50JRNkq9eJc/edit#slide=id.g5971a2130c_0_17)




##  Significance of a Polygenic Risk Score:
Assuming there is a family in which most individuals display a particular phenotypic trait derived from a specific disease diagnosis. The aim is to target the unresolved and provide those who are inquiring with a polygenic risk score which would demonstrate how well "protected" the individual(s) in question are from acquiring the phenotypic trait.


##   What's the problem and Why should we solve it?
When multiple individuals in a family have acquired the same phenotypic trait from a disease they have been previously diagnosed with, the situation pursues a more efficient form of notifying interested individuals how protected they are from obtaining this phenotypic trait or how susceptible they are to it. This output is in the form of a penetrance estimate. 


## Software Workflow Diagram:
**Input:** penetrance estimate and snp chip data 
  1. A collection of ~3000 voluntarily released genotype data from [Ancestry.com](https://www.ancestry.com/) & [23&Me](https://www.23andme.com/?mygf=true) services with self reported phenotypes
  + This data was:
    - parsed for specific variants related to self reported cases of hypertrophic cardiomyopathy (HCM) using a filtered search using key-phrase "*cardiomyop*". 
    - calculated filtered variants' minor allelic counts for each individual in the sample cohort. These measures were then used to populate a matrix, with variants as columns and individuals as rows. 
           
           
  2. A filter was then applied in the allelic count matrix to variants which had a representation >30% and an Odds Ratio (OR) of association with a particular phenotype. This left 3 SNVs for represenation of this phenotype after filtering. 
  
  
  Given that there is likely more than 3 SNV that are contributing to this phenotype, we explored methods of predicting those variants and their genotypes. The LDlink, LDproxy tool was then used to identify other variants that are in Linkage Disequilibrium (LD) with these three and the genotypes for these variants were imputed for the sample set using the PRINCE algorithm designed by Vanunu et al (2010). Such approaches aim to prioritize genes in a genomic interval of interest according to their predicted strength-of-association with a given disease, HCM. These imputed genotypes were then used to fit a model which can be used to provide a polygenic risk score for an individual who may or may not be at risk for HCM. This can act as a tool to clinicians in the diagnosis and characterization of HCM. These methods can be used to create models for other diseases which have a genetic cause and broaden the range of diseases we can assess through genotyping data.
   
   
 **Output:** the polygenic score and how it compares to the 3000 random snp collections* 
 
   A model which can be used to predict an individuals Polygenic Risk Score (PRS) for HCM using the results of a genotype array. 

## Dependencies: 
- [Alternative](https://www.ebi.ac.uk/gwas/api/search/downloads/alternative): for gathering data from the gwas catalog database.
   + [source citation](https://www.ebi.ac.uk/gwas/docs/file-downloads)
   + **_implementation of alternative gwas catalog database_**:
- [Ziptools](https://docs.python.org/3.7/library/zipfile.html): for unzipping zipfile file types.
   + *Python 3.5.3 documentation*
   + *The ZIP file format is a common archive and compresssion standard.*
   + *This updated module provides tools to create, read, write, append and list a ZIP file.* 
   + **_implementation of ziptools in our pipeline_**:
- [Opensnp](https://opensnp.org/): for gathering data from families with particular phenotypes.
   + *allows for customers to view/share their phenotypes from a vast openSNP database.*
   + *opensnp works by having customers upload their raw genotyping or exome data (from 23andMe, ancestry.com, FamilyTreeDNA)*
   + [github documentation](https://github.com/openSNP/snpr)
   + **_implementation of opensnp in our pipeline_**:
   
- [Dbsnp](https://www.ncbi.nlm.nih.gov/snp/): A public-domain archive for human single nucleotide variations, microsatellites, and small-scale insertions and deletion. 

- [Docker](https://www.docker.com/): leading software container platform.


- **python code used to filter results under the 23andme and ancestry categorical information.**
- **modules imported in code**
    + **import click**: a library with necessary software utilized in this pipeline
    + **import** [json](https://docs.python.org/3/library/json.html): JSON handles data flow in a file by converting Python object(s) to respective JSON object files.
    + **import** [pdb](https://docs.python.org/3/library/pdb.html): an interactive source code debugger for Python programs.
    + **import** [sys](https://github.com/naidura/Computational_Medicine_1/edit/master/CVD/README.md): sets system-specific parameters and functions. 



Citations: 

Vanunu O, Magger O, Ruppin E, Shlomi T, Sharan R. Associating genes and protein complexes with disease via network propagation. PLoS Comput Biol. 2010;6(1):e1000641






