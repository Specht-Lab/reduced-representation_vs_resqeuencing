library(ape)
library(phytools)
library(ggplot2)
library(readr) #install.packages("readr")

setwd("")

#read genome tree
genome <- read.tree("_pruned_snps.raxml.support.rooted.treefile.tre")

# create list of subset tree files
subset_files <- list.files(pattern = "_.*\\.min4\\.raxml\\.support\\.rooted\\.treefile\\.tre")

# loop to read tree and compare tree to the genome
for (subset_file in subset_files) {
  subset_tree <- read.tree(subset_file)

  comparison_output <- capture.output(comparePhylo(genome, subset_tree, plot = TRUE, force.rooted = TRUE))

  output_file <- paste0("comparePhylo_", gsub("\\.tre", "_output.txt", subset_file))
  
  writeLines(comparison_output, output_file)
}

########################
###RUN IN TERMINAL######
########################

# set directory
cd /Users/

# extract splits in common from txt files
for file in comparePhylo_*.txt; do

  grep "splits in common" "$file" | awk -v fname="$file" '{print fname ": " $0}'

done