# **NAME OF PIPELINE** -- A Template For Producing A Polygenic Risk Score For The Masses
#### *insert link to doi or citation*
##  Significance of a Polygenic Risk Score 
### Assuming there is a family in which most individuals display a particular phenotypic trait derived from a specific disease diagnosis (**add any specifications of which disease(s) we will be focusing on**), our pipeline aims to target the unresolved and provide those who are inquiring with a polygenic risk score which would demonstrate how well "protected" the individual(s) in question are from acquiring the phenotypic trait.
##   What's the problem and Why should we solve it?
### When multiple individuals in a family have acquired the same phenotypic trait from a disease they have been previously diagnosed with, the situation pursues a more efficient form of notifying interested individuals "protected" they are from inhabiting this phenotypic trait or how susceptible they are to it. This output from our pipeline is in the form of a penetrance estimate. 





## Software Workflow Diagram
***Input:** penetrance estimate and snp chip data → 

   processing of GWAS odds ratios → 
   3000 random snp collections from people without the phenotypic trait of the disease → 
   
 **Output:** the polygenic score and how it compares to the 3000 random snp collections* 









## software(s) used: 
- *alternative (link to GWAS database)*, 
- *ziptools (for unzipping the files) (zipfile)* (Python 3.7.3 documentation)
   + *The ZIP file format is a common archive and compresssion standard.*
   + *This updated module provides tools to create, read, write, append and list a ZIP file.*
   + **_implemention of ziptools in our pipeline_**: 
- python code used to filter results under the 23andme and ancestry categorical information. 
- *opensnp*
- *import click* (a library with necessary software utilized in this pipeline)
- *import json*
- *import pdb*
- *import sys*
- *possibly dbsnip*???




