library(pophelper)
library(fields)
library(LEA)
library(tidyr)
library(dplyr)
library(readr)


setwd("/Users/joshfelton/Desktop/structure_offline/warbler/pop_helper/")

#additional files needed - in data directory
source("Conversion.R")
source("POPSutilities.R")


# creating Q file --------------------------------------------------------
struct2geno(file = "Populus_singlecopy_LD_pruned_SNPs.recode.p.structure", TESS = FALSE, diploid = TRUE, FORMAT = 2,extra.row = 0, extra.col = 0, output = "singlecopy.geno")


#test for best K
obj.snmf = snmf("Camellia_genome.geno", K = 1:25,  ploidy = 2, entropy = T, alpha = 100, project = "new")
pdf(file="delta_K_genome.pdf")
plot(obj.snmf, col = "blue4", cex = 2.0, pch = 19,cex.axis=1.4,cex.lab=1.4)
dev.off()


obj.snmf = snmf("singlecopy.geno", K = 3, alpha = 100, project = "new", iterations=500)
qmatrix = Q(obj.snmf, K = 3)

# reading in structure files ----------------------------------------------
# read one structure plot
qlist  <- readQ("1_duckweed_UCEgene_LD_pruned_SNPs.recode.p_r1.6.Q")              # or a vector of files


# read multiple structure plots -------------------------------------------
file_vec <- list.files(path = ".", 
                       pattern = "\\.Q$", 
                       full.names = TRUE)
qlist <- readQ(file_vec)


# align K !!!! -----------------------------------------------------------------
qlist  <- alignK(qlist)                    

# adding names to q matrix -------------------------------------------------------

# if have names already ---------------------------------------------------
names_plotting <- read_csv("names.csv", col_names = FALSE)
labvec          <- as.character(names_plotting[1, ])
labvec <- colnames(names_plotting)

qlist_named <- lapply(qlist, function(mat) {
  rownames(mat) <- labvec
  mat
})


# pulling names from structure file ---------------------------------------
test <- read_table("Warbler_UCEsuper_LD_pruned_SNPs.recode.p.structure")


labvec <- test[[1]]            # this pulls out the column as a character vector
labvec <- unique(labvec)      # now a length-21 character vector
length(labvec)   

nrow(qlist[[1]])  

qlist_named <- lapply(qlist, function(mat){
  rownames(mat) <- labvec
  mat
})

# plotting ----------------------------------------------------------------
plotQ(qlist_named,
      sortind     = "all",
      useindlab   = TRUE,
      showindlab  = TRUE,
      sharedindlab= FALSE,
      exportpath=getwd(),
      imgoutput   = "join",
      height = 12,
      width = 25,
      units = "cm",
      imgtype = "pdf")