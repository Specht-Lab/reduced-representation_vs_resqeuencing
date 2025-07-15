library(phytools)
library(geiger) #install.packages("geiger")
library(ape)

setwd("/Users/joshfelton/Library/CloudStorage/Box-Box/Specht Lab/Lab Members/Josh_Felton/manuscript/Dryad_supplamental_material/data")

tree <- read.newick("taxon.nwk")

writeLines(tree$tip.label )

traits <- read.csv("charachter_matrix.csv")

# index and reorder traits to match phylogeny order
idx <- match(tree$tip.label, traits$taxon)

traits_ordered <- traits[idx, , drop = FALSE]

# trait matrix
trait.matrix <- cbind(
  mating       = traits_ordered$mating.system,
  genome_size  = traits_ordered$genome_size,
  life_history = traits_ordered$life_history
)
rownames(trait.matrix) <- traits_ordered$taxon 


# color palette
my_colors <- list(
  mating       = c("cadetblue","indianred"),
  genome_size  = colorRampPalette(c("ivory3","black"))(100),
  life_history = c("gold","darkgreen")
)


# scale branch length
epsilon             <- 1e-8
tree$edge.length    <- log10(tree$edge.length + epsilon)


svg("fig_1.svg", width = 10, height = 10)

par(font=2)
# plotting phylogeny and traits
cols_list <- plotFanTree.wTraits(
  ladderize(tree, right = FALSE),
  X          = trait.matrix,
  part       = .5,   # fraction of radius devoted to trait bars
  arc_height = 0,     # how far the fan arcs extend 
  colors     = my_colors, 
  spacer     = 0.15,   #gap b/w tips
  fsize      = 0.9,    # tip‐label font size
  font       = 2
)

dev.off()

