library(lme4)
library(lmerTest) 
library(emmeans)
library(car)
library(ape)
library(tidyverse)
library(ggpubr)


setwd("/Users/joshfelton/Library/CloudStorage/Box-Box/Specht Lab/Lab Members/Josh_Felton/manuscript/Dryad_supplamental_material/data")
nodes <- read.csv("nodes_supported.csv")


head(nodes)

#clean and reoder
name_map <- c(
  "353_gene" = "UCE",
  "353_super" = "UCE + supercontigs",
  "BUSCO" = "BUSCO", 
  "BUSCOsuper" = "BUSCO + supercontigs", 
  "singlecopy" = "single copy",
  "Scsuper" = "single copy + supercontigs",
  "genome" = "genome"
)

factor_order <- c(
  "UCE", 
  "UCE + supercontigs", 
  "BUSCO", 
  "BUSCO + supercontigs", 
  "single copy", 
  "single copy + supercontigs", 
  "genome"
)

nodes_names <- nodes |>
  mutate(dataset = recode(dataset, !!!name_map)) |>
  mutate(dataset = factor(dataset, levels = factor_order))


# for spacing -------------------------------------------------------------

head(nodes_names)

plot_levels <- c(
  "UCE", "spacer1", "UCE + supercontigs", "spacer2",
  "BUSCO","spacer3", "BUSCO + supercontigs", "spacer4",
  "single copy", "spacer5", "single copy + supercontigs", "spacer6",
  "genome"
)

nodes_names$dataset <- factor(nodes_names$dataset, levels = plot_levels)

spacers <- data.frame(
  dataset = factor(c("spacer1", "spacer2", "spacer3","spacer4","spacer5","spacer6"), levels = plot_levels),
  species = NA,
  supported_nodes = NA,
  total_nodes = NA,
  prop_supported_nodes = NA,
  splits_in_common = NA,
  prop_in_common = NA
)

nodes_names <- bind_rows(nodes_names, spacers)

View(nodes_names)
# plotting ----------------------------------------------------------------


node_plot <- ggplot(nodes_names, aes(x = dataset, y = prop_supported_nodes)) + 
  geom_boxplot(fill = "grey") +
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
  geom_jitter(alpha = 0.5, width = 0.2, color = "black") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "", y = "proportion of nodes > 70% BS",) +
  scale_x_discrete(
    labels = c(
      "UCE", "", "UCE + supercontigs", "",
      "BUSCO", "","BUSCO + supercontigs", "",
      "single copy","", "single copy + supercontigs", "",
      "genome"
    ),
    drop = FALSE
  ) +
  theme_minimal(base_size = 17) +
  theme(legend.position = "none", axis.text.x = element_text(face="bold"))


ggsave("supported_nodes.svg", height = 10.08, width = 17, units = "in")


# stats 

# mixed model
lmm_model <- lmer(prop_supported_nodes ~ dataset + (1 | species), data = nodes)
summary(lmm_model)

anova_model <- anova(lmm_model)

# testing if assumptions are met
plot(anova_model)
qqnorm(residuals(lmm_model)); qqline(residuals(lmm_model))

leveneTest(prop_supported_nodes ~ dataset, data = nodes) 

# comparisons
posthoc <- emmeans(lmm_model, pairwise ~ dataset, adjust = "bonferroni")
summary(posthoc)


# getting_node_numbers ----------------------------------------------------
#where you are storing the tree files you want to read
tree_dir <- "" 

tree_files <- list.files(tree_dir, pattern = "\\.tre$", full.names = TRUE)

results <- data.frame(file = character(), num_tips = numeric(), 
                      num_internal_nodes = numeric(), total_nodes = numeric(), 
                      stringsAsFactors = FALSE)

for (tree_file in tree_files) {
  tree <- read.tree(tree_file)  
  
  num_tips <- length(tree$tip.label)
  num_internal_nodes <- tree$Nnode
  total_nodes <- num_tips + num_internal_nodes
  
  results <- rbind(results, data.frame(file = tree_file, 
                                       num_tips = num_tips, 
                                       num_internal_nodes = num_internal_nodes, 
                                       total_nodes = total_nodes))
}

print(results)
write.csv(results, "tree_node_counts.csv", row.names = FALSE)

# compare_phylo node ------------------------------------------------------

nodes_compare_phylo <- na.omit(nodes_names)
nodes_compare_phylo <- filter(nodes_compare_phylo, dataset != "genome")
  
compare_phylo_nodes_plot <- ggplot(nodes_compare_phylo, aes(x = dataset, y = prop_in_common)) + 
  geom_boxplot(fill = "grey") +
  # stat_compare_means(
  #   symnum.args = list(
  #     cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, Inf),
  #     symbols = c("****", "***", "**", "*", "ns")
  #   ), comparisons = list(
  #     c("UCE", "UCE + supercontigs"),
  #     c("BUSCO", "BUSCO + supercontigs"),
  #     c("single copy", "single copy + supercontigs"),
  #     c("UCE + supercontigs", "BUSCO + supercontigs"),
  #     c("UCE + supercontigs", "single copy + supercontigs"),
  #     c("single copy + supercontigs", "BUSCO + supercontigs")
  #   )) +
  geom_jitter(alpha = 0.5, width = 0.2, color = "black") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "", y = "proportion of nodes shared with genome",) +
  theme_minimal(base_size = 17) +
scale_x_discrete(
  labels = c(
    "UCE", "", "UCE + supercontigs", "",
    "BUSCO", "","BUSCO + supercontigs", "",
    "single copy","", "single copy + supercontigs", "",
    "genome"
  ),
  drop = FALSE
) +
  theme(legend.position = "none", axis.text.x = element_text(face="bold"))

ggsave("SHARED_nodes_prop.svg", height = 10.08, width = 17, units = "in")


# mixed model
lmm_model <- lmer(prop_in_common ~ dataset + (1 | species), data = nodes_compare_phylo)
summary(lmm_model)

anova_model <- anova(lmm_model)

# testing if assumptions are met
plot(anova_model)
qqnorm(residuals(lmm_model)); qqline(residuals(lmm_model))

leveneTest(prop_in_common ~ dataset, data = nodes_compare_phylo) 

# comparisons
posthoc <- emmeans(lmm_model, pairwise ~ dataset, adjust = "bonferroni")
summary(posthoc)

