# load libraries ----------------------------------------------------------
library(car)  # install.packages("car")
library(tidyverse) # install.packages("tidyverse")
library(FSA)  # install.packages("FSA")
library(ggpubr) # install.packages("ggpubr")
library(writexl)  # install.packages("writexl")

setwd("/Users/joshfelton/Library/CloudStorage/Box-Box/Specht Lab/Lab Members/Josh_Felton/manuscript/Dryad_supplamental_material/data")
df <- read_csv("SNPS_after_filtering.csv")

kruskal_result <- kruskal.test(snps_after_filtering ~ dataset, data = df)
dunn_result <- dunnTest(snps_after_filtering ~ dataset, data = df, method = "bonferroni")  

# show results
kruskal_result

dunn_result

options(scipen = 0) 

# export to table  -----------------------------------------------------------

kruskal_df <- data.frame(
  Test = "Kruskal-Wallis",
  Statistic = kruskal_result$statistic,
  p_value = kruskal_result$p.value
)

dunn_df <- as.data.frame(dunn_result$res)

write_xlsx(list("Kruskal-Wallis" = kruskal_df, "DunnTest" = dunn_df), "SNP_generation_filtering_stats.xlsx")


# clean labels ------------------------------------------------------------


df$dataset <- factor(df$dataset, 
                     levels = c("A353_gene", "A353_super", "BUSCO", "BUSCOsuper", "singlecopy", "SC_super", "genome"),
                     labels = c("UCE", "UCE + supercontigs", "BUSCO", "BUSCO + supercontigs", 
                                "single copy", "single copy + supercontigs", "genome"))

# spacers for presentation ------------------------------------------------

plot_levels <- c(
  "UCE", "spacer1", "UCE + supercontigs", "spacer2",
  "BUSCO","spacer3", "BUSCO + supercontigs", "spacer4",
  "single copy", "spacer5", "single copy + supercontigs", "spacer6",
  "genome"
)

df$dataset<- factor(df$dataset, levels = plot_levels)

spacers <- data.frame(
  dataset = factor(c("spacer1", "spacer2", "spacer3","spacer4","spacer5","spacer6"), levels = plot_levels),
  organism = NA,
  fasta_charachters = NA,
  snps_after_filtering = NA,
  life_history = NA,
  breeding_system = NA,
  genome_size = NA, 
  genome_number = NA
)

df <- bind_rows(df, spacers)


# viz of results for presentation  -----------------------------------------------------------
ggplot(df, aes(x = dataset, y = snps_after_filtering)) +
  geom_boxplot(outlier.shape = NA, fill ="grey") +
  geom_jitter(
    color = "black",
    size = .5,
    alpha = .5,
    width = 0.2
  ) +
  scale_y_log10(expand = expansion(mult = c(0.01, 0.05))) +
  labs(x = "", y = "Median SNPs Retained (log scale)") +
  stat_compare_means(
    step.increase = 0.03,   # tighten vertical spacing
    tip.length    = 0.01,   # shorter bracket tips
    symnum.args = list(
      cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, Inf),
      symbols = c("*", "*", "*", "*", "ns")
    ),
    method = "wilcox.test",
    comparisons = list(
      c("UCE", "UCE + supercontigs"),
      c("BUSCO", "BUSCO + supercontigs"),
      c("single copy", "single copy + supercontigs"),
      c("genome", "UCE"),
      c("genome", "BUSCO + supercontigs"),
      c("genome", "single copy + supercontigs"),
      c("UCE + supercontigs", "single copy + supercontigs")
    )
  ) +
  scale_x_discrete(
    labels = c(
      "UCE", "", "UCE + supercontigs", "",
      "BUSCO", "","BUSCO + supercontigs", "",
      "single copy","", "single copy + supercontigs", "",
      "genome"
    ),
    drop = FALSE  # keep spacer for x axis label
  ) +
  theme_minimal(base_size = 17) +
  theme(legend.position = "none", axis.text.x = element_text(face="bold"))

ggsave("median_snp_retention_FINAL_presentation_boxplot_half_2.svg", width = 16.5, height = 6.5)


# plot to edit in illustrator ---------------------------------------------

ggplot(df, aes(x = dataset, y = snps_after_filtering)) +
  geom_boxplot(outlier.shape = NA, fill ="grey") +
  geom_jitter(
    color = "black",
    size = .5,
    alpha = .5,
    width = 0.2
  ) +
  scale_y_log10(expand = expansion(mult = c(0.01, 0.05))) +
  labs(x = "", y = "Median SNPs Retained (log scale)") +
  scale_x_discrete(
    labels = c(
      "UCE", "", "UCE + supercontigs", "",
      "BUSCO", "","BUSCO + supercontigs", "",
      "single copy","", "single copy + supercontigs", "",
      "genome"
    ),
    drop = FALSE  # keep spacer levels to give room for x axis names
  ) +
  theme_minimal(base_size = 17) +
  theme(legend.position = "none", axis.text.x = element_text(face="bold"))

ggsave("median_snp_retention_illustrator.svg", width = 16.5, height = 8.5)
