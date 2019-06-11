suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(readr))

optlist <- list(
    make_option("--G100ref_table", default = "please.txt", dest = "ref",
                help = "The reference SNP array for 1000 genome according to your selected phenotype"),
    make_option("--ROI", default = "damien.rsList.txt", dest = "roi",
                help = "your rs ids of interests, the first column should be rs numbers and the fourth column should be effect size"),
    make_option("--ind_table", default = "test_ind.txt", dest="ind",
                help = "indiviudal SNP genotype table"),
    make_option("--out_pdf", default = "indrisk_dist.pdf", dest="out_pdf",
                help = "the position of individual against populational riskscores"))


optlist <- parse_args(OptionParser(option_list=optlist, usage = "Rscript %prog [options]"), print_help_and_exit=FALSE)


if (FALSE){
    optlist <- list()
    optlist$roi <- "damien.rsList.txt"
    optlist$ref <- "please.txt"
    optlist$ind <- "test_ind.txt"
    optlist$out_pdf <- "indrisk_dist.pdf"
}

population <- suppressWarnings(read_delim(optlist$ref, delim = "\t", col_names = F ))
population <-population[-1, ]
pop_rs <- unlist(strsplit(readLines(optlist$ref, 1), split = "\t"))
colnames(population) <- pop_rs
#population <- read_tsv(optlist$ref, col_names = F)
population$filename <- NULL

rslist <- read_tsv(optlist$roi, col_names = F)
common_rsids <- intersect(rslist$X1, colnames(population))
rslist <- rslist[!duplicated(rslist$X1),]
rslist <- rslist[rslist$X1 %in% common_rsids, ]
population <- population[,common_rsids]



pop<- as.matrix(population)
pop[is.na(pop)] <- 0
suppressWarnings(storage.mode(pop) <- "numeric")
beta_vec <- rslist$X4
beta_mat <- matrix(beta_vec, ncol = 1)
riskscore <- pop %*% beta_mat
risk_std <- sd(riskscore)
risk_mean <- mean(riskscore)


# calculate individual riskscore
ind <- read_tsv(optlist$ind)[[1]]
#ind <- pop[1,]
ind_riskscore <- ind %*% beta_mat
dim(riskscore)  <- NULL
dim(ind_riskscore) <- NULL
ind_pos <- mean(riskscore < ind_riskscore)


print(optlist$out_pdf)


cat(optlist$out_pdf)
pdf(optlist$out_pdf,width=6,height=4,paper='special') 
hist(riskscore, breaks = 100, main = "risk score distribution", 
     sub=paste0("mean=",round(risk_mean,3), ", std=", round(risk_std, 3)))
abline(v = ind_riskscore, col = "red") 
text(ind_riskscore,68,paste0("higher than \n", round(ind_pos*100, 3), "% \npopulation"), cex=1,col="red",pos = 4 )
dev.off()
