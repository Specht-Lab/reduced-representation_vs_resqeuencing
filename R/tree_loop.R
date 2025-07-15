library(ggtree)
library(ape)
library(tidyverse)

#set your wd to where you will have all of the rooted trees
setwd("")

# get species name from directory name
species_name <- basename(getwd())

tree_files <- list.files(pattern = "\\.raxml.support.rooted.treefile.tre$")
trees <- lapply(tree_files, read.tree)
names(trees) <- gsub("\\.raxml.support.rooted.treefile.tre$", "", tree_files)
class(trees) <- "multiPhylo"


# put accession names here from names_for_phylogeny.R ---------------------

#set up right now for Primula

group1 <- c(
  "P_elatior_subsp_elatior", "P_elatior_subsp_intricata", 
  "P_elatior_subsp_lofthousei", "P_elatior_subsp_meyeri", 
  "P_elatior_subsp_pallasii", "P_grandis", "P_megaseifolia", 
  "P_renifolia"
)


group2 <- c(
  "P_elatior_subsp_cordifolia", "P_elatior_subsp_leucophylla", 
  "P_elatior_subsp_pseudoelatior", "P_veris_subsp_canescens", 
  "P_veris_subsp_columnae", "P_veris_subsp_macrocalyx", 
  "P_veris_subsp_veris", "P_vulgaris_subsp_heterochroma", "P_juliae"
)


group3 <- c(
  "P_halleri", "P_mistassinica", "P_nutans", "P_siamensis", 
  "P_souliei", "P_verticillata", "P_vulgaris_subsp_balearica", 
  "P_vulgaris_subsp_sibthorpii", "P_vulgaris_subsp_vulgaris"
)

# colors for clustering (from names_for_phylogeny.R) ----------------------
## three groups
group_colors <- c(
  group1 = "#F8766D",
  group2 = "#00BA38",
  group3 = "#619CFF"
)


group_list <- list(
  group1 = group1,
  group2 = group2,
  group3 = group3
)


for (i in seq_along(trees)) {
  tree_name <- names(trees)[i]
  
  # assign groups to the tree from list
  grouped_tree <- groupOTU(trees[[i]], group_list)
  
  # set up plot to take into account tree depth
  max_depth <- max(branching.times(trees[[i]])) 
  
  # plot
  tree_plot <- ggtree(grouped_tree, aes(color = group)) +
    geom_tiplab(aes(label = label)) +
    geom_text2(aes(subset = !isTip, label = label), hjust = -0.3) +
    ggtitle(str_c(species_name, " - ", tree_name)) +
    scale_color_manual(values = group_colors) +
    theme(legend.position = "none") +
    xlim(0, max_depth + 1)
  
  # for vitis tree i made it 14 hight wise
  ggsave(str_c(species_name, "_", tree_name, "_tree.pdf"), tree_plot, width = 12, height = 12, units = "in")
}
