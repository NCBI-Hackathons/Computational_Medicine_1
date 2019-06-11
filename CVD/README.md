


## [Pipeline Overview](https://www.lucidchart.com/documents/edit/df51958b-9ec2-4a0f-8094-d7a3d794cebb/0?shared=true&)




----


# **INSERT TEAM NAME** -- A Template For Producing A Polygenic Risk Score For The Masses

#### *hackathon team:*

#### *insert link to doi or citation*

#### [Link to Presentation](https://docs.google.com/presentation/d/1QgcN_QEQccpOUKctkwVCtzaE_Z_UvFrr50JRNkq9eJc/edit#slide=id.g5971a2130c_0_17)

#### *Objectives(s)*: 
      + Workstream 1: Get All GWAS-Identified Variants Related to a Particular ClinVar Variant 
      + Workstream 2: Build a Platform for Mathematical Analysis of These Variants




##  Significance of a Polygenic Risk Score:
Assuming there is a family in which most individuals display a particular phenotypic trait derived from a specific disease diagnosis **(add any specifications of which disease(s) we will be focusing on)**, our pipeline aims to target the unresolved and provide those who are inquiring with a polygenic risk score which would demonstrate how well "protected" the individual(s) in question are from acquiring the phenotypic trait.


##   What's the problem and Why should we solve it?
When multiple individuals in a family have acquired the same phenotypic trait from a disease they have been previously diagnosed with, the situation pursues a more efficient form of notifying interested individuals how protected they are from obtaining this phenotypic trait or how susceptible they are to it. Our pipeline focuses on [hypertrophic cardiomyopathy](https://www.heart.org/en/health-topics/cardiomyopathy/what-is-cardiomyopathy-in-adults/hypertrophic-cardiomyopathy) as the phenotypic trait in question and the output is in the form of a penetrance estimate. 




## Software Workflow Diagram:
**Input:** penetrance estimate and data from the gwas catalog  

   → obtain SNP's pertaining to cardiomyopathy →
   opening of SNP arrays →
   processing of GWAS odds ratios → 
   3000 random snp collections from people without display of hypertrophic cardiomyopathy →
   gather data, bring to R and compute the risk score
   
 **Output:** the polygenic risk score and how it compares to the 3000 random snp collections









## Dependencies: 
- [Alternative](https://www.ebi.ac.uk/gwas/api/search/downloads/alternative): for gathering data from the gwas catalog database.
   + [source citation](https://www.ebi.ac.uk/gwas/docs/file-downloads)
   + **_implementation of alternative gwas catalog database_**:
- [Ziptools](https://docs.python.org/3.7/library/zipfile.html): for unzipping zipfile file types.
   + *Python 3.7.3 documentation*
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


## Installation Options:
We provide two options for installing: Docker or directly from Github

### Docker:

### Installing from GitHub:

## Additional Functionality:



#### This project was part of the [NCBI Computational Medicine in the Cloud Hackathon.](https://biohackathons.github.io/index.html)





