#set wd, load packages, read files
setwd("/Users/joshfelton/Desktop/mpileup_vs_GATK/")

library(tidyverse)
library(ggvenn) #install.packages("ggvenn")

bcf_snps <- readLines("bcf_snps_duckweed.txt")
gatk_snps <- readLines("gatk_snps_duckweed.txt")

# create table
snp_data <- tibble(
  snp = unique(c(bcf_snps, gatk_snps)),  # Combine all SNPs
  mpileup = snp %in% bcf_snps,
  GATK = snp %in% gatk_snps
)

#plotting
ggvenn(
  snp_data,
  columns = c("mpileup", "GATK"),
  fill_color = c("lightblue", "lightgreen")
)

ggsave("duckweed_snp_comparison.pdf")