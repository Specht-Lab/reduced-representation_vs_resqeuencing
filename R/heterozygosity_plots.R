library(ggplot2)
library(tidyverse)
library(rstatix)
library(lme4)
library(emmeans)
library(ggpubr)
library(writexl)

setwd("/Users/joshfelton/Library/CloudStorage/Box-Box/Specht Lab/Lab Members/Josh_Felton/manuscript/Dryad_supplamental_material/data/heterozygosity_csv")

# create list the file names and sort
file_names <- list.files(pattern="*.csv")
file_names <- sort(file_names, decreasing = TRUE)


# read and combine data from csvs
combined_data <- lapply(file_names, function(file) {
  species <- gsub(".csv", "", file)
  data <- read.csv(file, header=TRUE)
  data$Species <- species
  return(data)
}) |> bind_rows()

combined_data$Sample <- factor(combined_data$Sample, levels = unique(combined_data$Sample))

#clean names
name_map <- c(
  "UCE" = "UCE",
  "UCE_super" = "UCE + supercontigs",
  "BUSCO" = "BUSCO", 
  "BUSCOsuper" = "BUSCO + supercontigs", 
  "singlecopy" = "single copy",
  "SCsuper" = "single copy + supercontigs",
  "genome" = "genome"
)


# filter if any missing het values
combined_data <- combined_data |>
  filter(!is.na(adjusted_het))
combined_data <- combined_data |>
  mutate(Sample = recode(Sample, !!!name_map))

# # **Convert heterozygosity to per Mb scale**
# combined_data <- combined_data |>
#   mutate(het_per_mb = adjusted_het * 1e6)  # Heterozygosity per megabase

# calculate medians for each species and group based on genome size
medians <- combined_data |>
  group_by(Species, Sample, genome_size) |>
  summarize(adjusted_het = median(adjusted_het, na.rm = TRUE), .groups = 'drop')


medians <- medians |>
  mutate(Sample = recode(Sample, !!!name_map))


#use below if want to calculate medians but not grouped by genome size
  overall_medians <- combined_data |>
  group_by(Sample) |>
  summarize(adjusted_het = median(adjusted_het))

  
combined_data$Sample <- factor(combined_data$Sample, levels = name_map)


# stats and saving table -------------------------------------------------------------------


summary_stats <- combined_data %>%
  group_by(Sample) %>%
  summarise(
    mean_het = mean(adjusted_het, na.rm = TRUE),
    sd_het = sd(adjusted_het, na.rm = TRUE),
    n = n()
  )

print(summary_stats)


kruskal_test <- kruskal.test(adjusted_het ~ Sample, data = combined_data)
print(kruskal_test)


pairwise_wilcox <- combined_data |>
  pairwise_wilcox_test(adjusted_het ~ Sample, p.adjust.method = "bonferroni")

print(pairwise_wilcox, n = 21)

kruskal_test_df <- data.frame(
  Test = "Kruskal-Wallis",
  Statistic = kruskal_test$statistic,
  p_value = kruskal_test$p.value
)

write_xlsx(
  list("Kruskal-Wallis" = kruskal_test_df, "Pairwise Wilcoxon" = pairwise_wilcox),
  "Heterozygosity_stats_TABLE.xlsx"
)


# below to be used for presentation ---------------------------------------
plot_levels <- c(
    "UCE", "spacer1", "UCE + supercontigs", "spacer2",
    "BUSCO","spacer3", "BUSCO + supercontigs", "spacer4",
    "single copy", "spacer5", "single copy + supercontigs", "spacer6",
    "genome"
  )
  
combined_data$Sample <- factor(combined_data$Sample, levels = plot_levels)
  
medians$Sample <- factor(medians$Sample, levels = plot_levels)

spacers <- data.frame(
  Sample = factor(c("spacer1", "spacer2", "spacer3","spacer4","spacer5","spacer6"), levels = plot_levels),
  adjusted_het = NA,
  Species = NA,
  genome_size = NA
)

combined_data <- bind_rows(combined_data, spacers)

# presentation boxplot -----------------------------------------------------------------
ggplot(combined_data, aes(x = Sample, y = adjusted_het)) +
geom_boxplot(outlier.shape = NA, fill = "grey") +
scale_y_log10() +
  stat_compare_means(
    symnum.args = list(
      cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, Inf),
      symbols = c("*", "*", "*", "*", "ns")
    ), comparisons = list(
    c("UCE", "UCE + supercontigs"),
    c("BUSCO", "BUSCO + supercontigs"),
    c("single copy", "single copy + supercontigs"),
    c("genome", "UCE + supercontigs"),
    c("genome", "BUSCO + supercontigs"),
    c("genome", "single copy + supercontigs")
  )) +
 geom_jitter(data = medians, aes(x = Sample, y = adjusted_het), color = "black", size = .5, alpha = .5, width = .2) +
  labs(x = "", y = "Heterozygosity standardized by reference file size") +
  scale_x_discrete(
    labels = c(
      "UCE", "", "UCE + supercontigs", "",
      "BUSCO", "","BUSCO + supercontigs", "",
      "single copy","", "single copy + supercontigs", "",
      "genome"
    ),
    drop = FALSE  # keep spacer levels for x axis label room
  ) +
  theme_minimal(base_size = 17) +
  theme(legend.position = "none", axis.text.x = element_text(face="bold"))

ggsave("adjusted_het_boxplot_presentation.svg", width=15, height=10)


# manuscript version ------------------------------------------------------


ggplot(combined_data, aes(x = Sample, y = adjusted_het)) +
  geom_boxplot(outlier.shape = NA, fill = "grey") +
  scale_y_log10() +
  stat_compare_means(
    method = "wilcox.test",
    symnum.args = list(
      cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, Inf),
      symbols = c("*", "*", "*", "*", "ns")
    ), comparisons = list(
      c("UCE", "UCE + supercontigs"),
      c("BUSCO", "BUSCO + supercontigs"),
      c("single copy", "single copy + supercontigs"),
      c("genome", "UCE + supercontigs"),
      c("genome", "BUSCO + supercontigs"),
      c("genome", "single copy + supercontigs")
    )) +
  geom_jitter(data = medians, aes(x = Sample, y = adjusted_het), color = "black", size = .5, alpha = .5, width = .2) +
  labs(
    x = "",
    y = "Heterozygosity standardized by reference file size") +
  theme_minimal(base_size = 17) +
  theme(legend.position = "none", axis.text.x = element_text(face="bold"))

ggsave("adjusted_het_boxplot_manuscript.svg", width=15, height=10)


