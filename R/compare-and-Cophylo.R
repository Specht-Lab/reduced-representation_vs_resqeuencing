# Modified by joshua m felton from orginal script from jacob b. landis

# setup -------------------------------------------------------------------
library(ape)
library(phytools)
# for main datasets -------------------------------------------------------

# Set working directory - where all of your tree files are
setwd("")

# Read the genome-wide tree
genome <- read.tree("Geospiza_genome.raxml.support.rooted.treefile.tre")

# List of datasets to compare against the genome tree
datasets <- c("Geospiza_BUSCO.raxml.support.rooted.treefile.tre",
              "Geospiza_BUSCOsuper.raxml.support.rooted.treefile.tre",
              "Geospiza_SCsuper.raxml.support.rooted.treefile.tre",
              "Geospiza_UCEgene.raxml.support.rooted.treefile.tre",
              "Geospiza_UCEsuper.raxml.support.rooted.treefile.tre",
              "Geospiza_singlecopy.raxml.support.rooted.treefile.tre")
# Loop through each dataset
for (dataset in datasets) {
  
  # Read the tree file
  dataset_tree <- read.tree(dataset)
  
  # Extract dataset name for file naming
  dataset_name <- gsub(".raxml.support.rooted.treefile.tre", "", dataset)
  
  # Generate file names
  svg_filename <- paste0("comparePhylo_genome_", dataset_name, ".svg")
  txt_filename <- paste0("comparePhylo_genome_", dataset_name, "_output.txt")
  
  # Save plot to PDF
  svg(svg_filename, width = 15, height = 15)
  par(mar = c(5, 5, 5, 5), cex = 1.5, lwd = 3)  # Set plot parameters
  
  # Compare trees and capture text output
  comparison_output <- capture.output(
    comparePhylo(
      genome, 
      dataset_tree, 
      plot = TRUE, 
      force.rooted = TRUE,
      no.margin = FALSE  
    )
  )
  
  dev.off()  # Close PDF file
  
  # Save text output
  writeLines(comparison_output, txt_filename)
}



# just cophylo (no compare_phylo_) ------------------------------------------------------------

genome <- read.tree("Geospiza_genome.raxml.support.rooted.treefile.tre")


library(ape)

svg(svg_filename, width = 50, height = 50)
# par(mar = c(5, 5, 5, 5), cex = 1.5, lwd = 3)

# Loop through each dataset
for (dataset in datasets) 
  {
  
  # Read the tree file
  dataset_tree <- read.tree(dataset)
  
  # Extract dataset name for file naming
  dataset_name <- gsub(".raxml.support.rooted.treefile.tre", "", dataset)
  
  

# build an association matrix between identical tip labels
assoc <- cbind(genome$tip.label, genome$tip.label)

# draw only the tanglegram
cophyloplot(genome,
            dataset_tree,
            assoc,
            use.edge.length = TRUE,
            length.line     = 10,
            space           = 5,
            gap             = 0.1)

dev.off()

}
