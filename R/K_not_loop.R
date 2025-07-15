# written by Jacob b. Landis

#you will need to install this packages if its the first time on a new computer
#if (!requireNamespace("BiocManager", quietly = TRUE))
#        install.packages("BiocManager")
#BiocManager::install("LEA")

#install.packages(c("fields","mapplots"))
#source("http://bioconductor.org/biocLite.R")
#biocLite("LEA")

setwd("/Users/joshfelton/Desktop/tests/costus_no_LD")

library(fields)
library(LEA)

#additional files need from the structure format
source("Conversion.R")
source("POPSutilities.R")

#import input file, if this is coming directly from Stacks you will need to delete the first two rows of the file. Should be left with just the data, no other information
struct2geno(file = "Costus_genome_thinned_noLD.p.structure", TESS = FALSE, diploid = TRUE, FORMAT = 2,extra.row = 0, extra.col = 0, output = "Costus_genome_noLD.geno")


#test for best K
obj.snmf = snmf("Costus_genome_noLD.geno", K = 1:25,  ploidy = 2, entropy = T, alpha = 100, project = "new")
pdf(file="genome_noLD_delta_K.pdf")
plot(obj.snmf, col = "blue4", cex = 2.0, pch = 19,cex.axis=1.4,cex.lab=1.4)
dev.off()

