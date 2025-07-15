setwd("/Users/joshfelton/Library/CloudStorage/Box-Box/Specht Lab/Lab Members/Josh_Felton/manuscript/Dryad_supplamental_material/data")

PC_values <- read_csv("combined_PC.csv")

PC_values_subset <- PC_values |> 
  filter(PC %in% paste0("PC", 1:4)) |> 
  mutate(percent_prop = Variance_Percentage/4)

# nested anova -------------------------------------------------------------------
nested_anova <- aov(percent_prop ~ Species/dataset, data = PC_values_subset)

summary(nested_anova)

# Post-hoc test
TukeyHSD(nested_anova)

# Check residuals for normality
plot(residuals(nested_anova))

#check and remove outliers
outlierTest(nested_anova)

PC_values_subset[c(261, 217), ]

#mixed model
simplified_model <- lmer(Variance_Percentage ~ dataset + Species + (1 | Species), 
                         data = PC_values_subset[-c(261, 217), ])

pairwise_results <- emmeans(simplified_model, pairwise ~ dataset | Species)
summary(pairwise_results)


#estimated marginal means to df
emm_data <- as.data.frame(pairwise_results$emmeans)

#factor and clean names
emm_data$dataset <- factor(emm_data$dataset, 
                           levels = c("353_gene", "353_super", "BUSCO", "BUSCOsuper", "singlecopy", "SCsuper", "genome"),
                           labels = c("UCE", "UCE + supercontigs", "BUSCO", "BUSCO + supercontigs", "single copy", "single copy + supercontigs", "genome"))


# plotting ----------------------------------------------------------------
ggplot(emm_data, aes(x = dataset, y = emmean, color = dataset, group = dataset)) +
  geom_point(position = position_dodge(0.5), size = 4) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), width = 0.2, position = position_dodge(0.5)) +
  facet_wrap(~ Species, scales = "free_y") +
  theme_minimal() +
  labs(
    title = "adjusted means of variance explained by PC 1-4",
    y = "percent of variance explained ",
    x = "",
    color = "Dataset"
  ) +
  theme_minimal(base_size = 17) +
  theme(legend.position = "none", axis.text.x = element_text(face="bold", angle = 45, hjust = 1))


ggsave("adjusted meansl_means_PCA_variance.pdf_5-28.svg", width = 25,
       height = 20,
       units = "in")


# facets for each variance prop -------------------------------------------

## set up to run all macro datasets - change object to micro or mix_macro_micro if want those plots

macro <- c("Acer", "Geospiza", "Fragaria", "Aquilegia", "Atriplex", "Begonia", "Camellia", "Cannabis", "Citrus", "Coffea", "Coix", "Corylus", "Costus", "Diprion")
micro <- c("Spirodela", "Aquilegia", "Fragaria", "Juglans", "Linum", "Liriodendron", "Lotus", "Malania", "Medicago", "Plectropomus", "Populus", "Primula", "Sorghum")
mix_macro_micro <- c("Thlapsi", "warbler", "Prunus", "Salix", "Sesamum", "Solanum", "Ursus", "Vigna", "Vitis")


PC_subset <- PC_values_subset %>%
    filter(Species %in% macro)
  
PC_subset <- PC_subset %>% 
    mutate(
      dataset = factor(
        dataset,
        levels = c("353_gene", "353_super", "BUSCO", "BUSCOsuper",
                   "singlecopy", "SCsuper", "genome"),
        labels = c("UCE", "UCE + supercontigs", "BUSCO",
                   "BUSCO + supercontigs", "single copy",
                   "single copy + supercontigs", "genome")
      )
    )
  
  
  ggplot(PC_subset, aes(x = dataset, y = Variance_Percentage, fill = Species)) +
    geom_boxplot() +
    facet_wrap(~ Species, scales = "free_x") +
    theme_minimal() +
    labs(title = paste("Variance Percentage by Dataset -", "macro"),
         x = "Dataset", y = "Variance Percentage") +
    theme(legend.position = "none", axis.text.x = element_text(angle = 90, hjust = 1))

  
  
ggsave("Variance_pct_facet_macro.svg", width = 25,
       height = 20,
       units = "in")



