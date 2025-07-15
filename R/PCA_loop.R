#PCA plotting script originally written by Jacob B. Landis. Modifed by Joshua M. Felton to loop through plotting based on kmeans clustering for a taxonomic dataset. 
# Load necessary libraries
library(gdsfmt)
library(SNPRelate)
library(ggplot2)
library(ggrepel)
library(tidyverse)

setwd("/Users/joshfelton/Desktop/PCA/Sesamum")

#specify based on k means plot on genome vcf
centers_num <- 5

species_name <- basename(getwd())


# list vcf files
vcf_files <- list.files(pattern = "\\.vcf$")

# create an empty list to store PCA results from all datasets
pca_results_list <- list()

#put genome vcf file name here
genome_vcf <- "Sesamum_genome.vcf"

  # create a GDS file name for each VCF
  gds.fn <- sub(".vcf$", ".gds", genome_vcf)

 # Convert VCF to GDS format for SNPRelate analysis
  snpgdsVCF2GDS(genome_vcf, gds.fn, method="biallelic.only", ignore.chr.prefix = "CM")
  
  # Summarize data and open the GDS file
  snpgdsSummary(gds.fn)
  genofile <- snpgdsOpen(gds.fn, readonly = FALSE)
  
  # LD pruning
  set.seed(1000)
  snpset <- snpgdsLDpruning(genofile, ld.threshold = 10, maf = NaN, missing.rate = NaN, slide.max.n = 5000, start.pos = "random", autosome.only = FALSE)
  snpset.id <- unlist(snpset)
  
  # Run PCA
  pca <- snpgdsPCA(genofile, snp.id = snpset.id, num.thread = 2, autosome.only = FALSE)
  
  # Extract the proportion of explained variance
  pc.percent <- pca$varprop * 100
  
  # Combine PC1 and PC2 vectors into a data frame
  genome_tab <- data.frame(Sample = pca$sample.id,
                    PC1 = pca$eigenvect[, 1],
                    PC2 = pca$eigenvect[, 2])
  

set.seed(123)
genome_km <- kmeans(genome_tab[,c("PC1","PC2")], centers=centers_num)
genome_tab$genomeCluster <- factor(genome_km$cluster)


snpgdsClose(genofile)

# define a palette for genome clusters (same colours every time)
# genome_cols <- c("1" = "#F8766D", "2" = "#00BA38", "3" = "#619CFF")

# genome_cols <- c("1" = "#F8766D", "2" = "#7CAE00", "3" = "#00BFC4" , "4" = "#C77CFF")

genome_cols <- c("1" = "#F8766D", "2" = "#7CAE00",  "3" = "#00BFC4", "4" = "#C77CFF", "5" = "#FF61CC")



vcf_files <- list.files(pattern = "\\.vcf$")


for (vcf.file in vcf_files) {
  gds.fn <- sub("\\.vcf$", ".gds", vcf.file)
  snpgdsVCF2GDS(vcf.file, gds.fn, method="biallelic.only", ignore.chr.prefix="CM")
  
  genofile <- snpgdsOpen(gds.fn)
  set.seed(1000)
  snpset.id <- unlist(
    snpgdsLDpruning(genofile, ld.threshold=10, autosome.only=FALSE)
  )
  pca <- snpgdsPCA(genofile, snp.id=snpset.id, autosome.only=FALSE)
  snpgdsClose(genofile)
  
  pc.percent <- pca$varprop * 100
  tab <- tibble(
    Sample = pca$sample.id,
    PC1    = pca$eigenvect[,1],
    PC2    = pca$eigenvect[,2]
  )
  
  # base population on genome clusters
  tab <- left_join(tab, genome_tab %>% select(Sample, genomeCluster), by="Sample")
  
  # local kmeans solely for ellipse grouping
  set.seed(123)
  local_km <- kmeans(tab[,c("PC1","PC2")], centers=centers_num)
  tab$localCluster <- factor(local_km$cluster)
  
pca_plot <- ggplot(tab, aes(x = PC1, y = PC2)) +
  stat_ellipse(
    aes(group = localCluster),
    level    = 0.95,
    linetype = "dashed",
    color    = "black"
  ) +
  geom_point(aes(color = genomeCluster), size = 2) +
  scale_color_manual(values = genome_cols, name = "Genome cluster") +
  #geom_text_repel(aes(label = Sample), size = 3, max.overlaps = 20) + #adds sample names to points
  xlab(sprintf("PC1 (%.1f%%)", pc.percent[1])) +
  ylab(sprintf("PC2 (%.1f%%)", pc.percent[2])) +
  ggtitle(sprintf( vcf.file)) +
  theme_classic()

  ggsave(
    filename = paste0("PCA_", sub("\\.vcf$","",vcf.file),
                      "_genome-colored_NONAMES.svg"),
    plot     = pca_plot,
    width    = 8.5, height = 6, units = "in"
  )
}



# cluster_colors <- c("1" = "#F8766D", "2" = "#00BA38", "3" = "#619CFF")

# cluster_colors <- c("1" = "#F8766D", "2" = "#7CAE00", "3" = "#00BFC4" , "4" = "#C77CFF")

# cluster_colors <- c("1" = "#F8766D", "2" = "#A3A500", "3" = "#00BF7D", "4" = "#00B0F6", "5" = "#E76BF3")



