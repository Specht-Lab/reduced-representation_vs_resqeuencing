# The power to resolve relationships: identifying incongruence and precision of reduced representation and genome-wide data in phylogenomics and population genomics

[doi here](https://doi.org/)

###### Corresponding Authors

If you run into problems with the code, please open an issue on github here: https://github.com/Specht-Lab/reduced-representation_vs_resqeuencing


```         
Name: Joshua Felton
Email: jmf425@cornell.edu
```

<br>

```         
Name: Jacob Landis
Email: jbl256@cornell.edu
```

## Dataset Overview

This dataset contains the sample and reference genomes accession numbers and code required to replicate analyses in Felton et al., testing the congruence of reduced representation markers vs a genome resequencing approach *in silico*

## Sharing/Access information

### Sharing/Access

This work is licensed under a CC0 1.0 Universal (CC0 1.0) Public Domain
Dedication license. 


### Data Sources

Resequenced reads were derived from publically available nucleotide archives. 

### Recommended Citation

Joshua M. Felton, Chloe M Jelley, Julianna J Harden, Justin Scholten, Leland Carl Graber, Michelle Heeney, Yana Rizzieri, Chelsea D Specht, Jacob Landis
bioRxiv 2025.07.09.663802; doi: https://doi.org/10.1101/2025.07.09.663802


## Description of the data and file structure

Multiple files in this repository require Linux to generate. Users are
provided with the appropriate scripts to do so if they wish; however,
users can be provided file outputs from the corresponding authors so that obtaining access
to a machine with a Linux operating system is not a requirement to
replicate our analyses. 

## Files and Folders

### Table of contents
1. [table information](#table_information)
2. [figures](#figures)
3. [code](#code)
  1. [shell](#shell_scripts)
  2. [R](#R_scripts)
4. [assoc. files (data)](#data)

## table information <a name="table_information"></a>

##### combined_supplamental_tables.xlsx

Table S1. Summary of taxa included in the comparative genomic analysis. For each taxon, we provide the number of samples, genome size, reference genome used, UCE set, BUSCO library, LD pruning threshold (r²), divergence time (in millions of years ago, MYA), species used to identify single-copy orthologs, reproductive mode (outcrossing vs. selfing), life history (annual vs. perennial), and the original publication from which the data were sourced.

Table S2: Results of Dunn’s post hoc tests comparing SNP retention across marker types. Comparisons are based on pairwise Z-scores, unadjusted p-values (P.unadj), and Bonferri corrected p-values (P.adj).

Table S3: Pairwise Wilcoxon rank-sum tests comparing heterozygosity across dataset types. Comparisons of dataset types, test statistics, raw p-values, and bonferri corrected p-values.

## figures <a name="figures"></a>

##### figures/fig_S1_duckweed_SNPcaller_comparison.pdf

S1: Comparison of SNP retention between GATK HaplotypeCaller and BCFtools mpileup following strict filtering. While GATK initially identified more SNPs, BCFtools retained more SNPs after applying equivalent filtering thresholds. Filtering included retaining only biallelic SNPs with a minor allele count (MAC) ≥ 3, minor allele frequency (MAF) ≥ 0.05, depth between 5 and 200, and no more than 30% missing data per site. Individuals with >50% missing data were excluded. The number of SNPs retained, including shared and unique variants for each caller, is shown.

##### figures/fig_S2_downsampling.pdf

S2: Co-phylo plots from 5 most common topologies from downsampled replicates in *Populus* and *Costus*. Pruning the genome-wide SNP dataset to match the number of SNPs in the UCE + supercontigs dataset led to topological incongruence in both taxonomic datasets. 


##### figures/fig_S3_trees_support.pdf

S3: Maximum likelihood phylogenies for each taxonomic and marker dataset. Each panel (e.g., S5a, S5b) shows the best ML tree inferred from one of the seven datasets (UCE, UCE + supercontigs, BUSCO, BUSCO + supercontigs, single-copy, single-copy + supercontigs, and genome-wide SNPs). Trees were inferred using RAxML-NG with 100 bootstrap replicates. Tip and branch colors reflect individual cluster assignments from principal component analysis. 


##### figures/fig_S4_PCA_summary.pdf

S4: Estimated marginal means of the percentage of variance explained by principal components 1–4 across dataset types. Error bars represent 95% confidence intervals.


##### figures/fig_S5_PCA_plots.pdf

S5: Principal component analysis (PCA) plots across all taxon–dataset combinations. Plots display PC1 and PC2 from PCA of SNP datasets representing different marker types for each taxonomic group. Individual samples are colored by their genome-wide cluster assignment, derived from k-means clustering based on the genome-wide dataset. Local clustering was applied to each dataset independently to generate 95% confidence ellipses, shown as dashed lines. 


##### figures/fig_S6_best_K.pdf

S6: Best K value determination for each dataset based on sparse non-negative matrix factorization (sNMF). Each panel (e.g., S4a, S4b) corresponds to a different taxon. Cross-entropy values were calculated across a range of clusters (K = 1 to 25). Lower cross-entropy values indicate better model fit. The best K (red dot) was selected based on the point at which cross-entropy stabilized or reached a minimum.


##### figures/fig_S7_structure_plots.pdf

S7: STRUCTURE plots for all taxon–dataset combinations. Barplots represent individual ancestry coefficients (Q-values) inferred from STRUCTURE-like analyses across marker types for each taxonomic group. The number of ancestral clusters (K) contributing to the current genetic material was fixed at the genome-wide optimum for each taxonomic group. 

## code <a name="code"></a>

### shell_scripts <a name="shell_scripts"></a>

##### bash/BLAST_comparison_single_and_BUSCO.sh

reciprocal blast between BUSCO and single copy reference to remove BUSCO hits from single copy reference. Use fasta files generated from VCFs using `VCFtools_filtering.sh`

##### bash/BWA_and_Haplotype.sh

mapping, heterozgosity and snp calling pipeline. Use for each reference generated. Do not forget to index and create a dictonary for your reference. 

##### bash/collapse_nodes.sh

collapse and count nodes above 70 % bootstrap - final output used for `supported_nodes.R`

##### bash/Combine_gvcfs_and_genotype.sh

combine gVCFs from `BWA_and_Haplotype.sh` **note tmp option to select location of files (there can be many)** 

##### bash/extract_longest_supercontig.sh

extracts longest supercontig (or contig) and then creates a concatinated reference. 

##### bash/fastp_universal.sh

clean reads after downloading from a nucelotide archive

##### bash/genome_thinning.sh

script used to thin genome VCFs randomly to 100,000 SNPs for better computational performance

##### bash/HybPiper_steps.sh

extracts longest supercontig (or contig) and then creates a concatinated reference. 

##### bash/mpileup_snp_calling.sh

mPileup snp calling steps 

##### bash/orthofinder.sh

orthofinder settings

##### bash/rax-ml.sh

raxml settings

##### bash/report_heterozygosity.sh

calculates from `est.ml` files the proportion of heterozygous sites

##### bash/rooting.sh

roots trees either with midpoint or an outgroup.

##### bash/Trinity.sh

script and settings to run Trinity for single copy pipeline

##### bash/VCFtools_filtering.sh

intial filtering with a LD pruning step before summary and downstream files (final VCF, fasta & STRUCTURE file) 

##### bash/VCFtools_thin_filtering.sh

script for thinning genome VCF files randomly down to 100,000 SNPs. Useful if running into computional problems with genome-wide datasets

### R_scripts <a name="R_scripts"></a>

##### R/compare-and-Cophylo.R.R

loop to run compare phylo across genome vs reduced representation datasets 
section at the bottom to do specific cophylo plots

##### R/downsample_compare-phylo.R

loop to run compare phylo across downsampled replicates

##### R/fig_1_phylomaker.R

script to reproduce the phylogeny in figure 1. 

##### R/heterozygosity_plots.R

script to reproduce figure 5

##### R/K_not_loop.R

script to produce best K plots 

##### R/names_for_phylogeny.R

samples named commented with sections for use with `tree_loop.R`

##### R/pc_stats.R

script to reproduce figure S4. 

##### R/PCA_loop.R

loop to reproduce figure S5.

##### R/SNP_generation_filtering.R

script to reproduce figure 2 and table S2

##### R/supported_nodes.R

script to reproduce figure 3 and table S3

##### R/structure.R

script to reproduce figure 7 and table S7

##### R/tree_loop.R

script to reproduce figure S3

##### R/venn_diagram_snp_filtering.R

script to reproduce figure S1

## assoc. files (data) <a name="data"></a>

##### data/bcf_snps_duckweed.txt

for plotting `venn_diagram_snp_filtering.R`

##### data/charachter_matrix.csv

charachter matrix for `fig_1_phylomaker.R` 

##### data/combined_PC.csv

data for `pc_stats.R`

##### data/Conversion.R

required for PCA plotting in `PCA_loop.R`

##### data/gatk_snps_duckweed.txt

for plotting `venn_diagram_snp_filtering.R`

##### data/heterozygosity_csv/

taxonomic dataset heterozygosity information for `heterozygosity_plots.R`

##### data/input_bams.txt

required bam names for mPileup

##### data/interval.list

required to generate for `Combine_gvcfs_and_genotype.sh` - include interval that SNPs were called for - use indexed reference file

##### data/nodes_supported.csv

data for `supported_nodes.R`

##### data/POPSutilities.R

required for PCA plotting

##### data/samples.list

required to generate for `Combine_gvcfs_and_genotype.sh` - include all samples that SNPs were called for

##### data/SNPS_after_filtering.csv

filtering data for `SNP_generation_filtering.R`

##### data/structure_names.txt

sample names for structure plots - used in `structure.R`

##### data/taxon.nwk

newick file for figure 1 - used in `fig_1_phylomaker.R`