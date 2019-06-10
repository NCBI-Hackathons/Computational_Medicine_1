# Structural Variants and Disease Group
## Ideas for Topics (feel free to comment or to add to list)

- define/design a bioinformatics product that is of general interest and that could be helpful to many; then write software that: 
  - fetches the latest data from multiple resources [provide examples]
  - cross-references and assembles the desired product from the new data
  - packages it in a format that is suitable for use in a variety of common workflows

- possibly the same as above:
  - collect latest SV data (from dbVar, ClinVar, gnomAD, et al)
  - run an annotation pipeline (to include AnnotSV, VCFanno, others
  - produce formatted product from annotated assembly of source data [provide examples]

- provide a product that:
  - takes as input a phenotype, disease, preferably as a dbxref from a medical vocabulary such as HPO, MedGen, MeSH, etc)
  - queries multiple sources of data on SVs and disease
  - provides as output a formatted report containing all available info about SV wrt that phenotype, and a list of PMIDs for further investigation

- when evaulating SVs for a particular gene or disease, oftentimes a query will include large SVs that affect not only the gene of interest, but neighboring genes as well; determine a heuristic for deciding when an SV is too large to be causative of a particular phenotype because it is likely to not be specific for that phenotype


