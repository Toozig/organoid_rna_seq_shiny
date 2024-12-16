# Load required packages
library(plotly)
library(dplyr)
library(reshape2)
library(htmlwidgets)

# Source necessary files
source("R/constants.R")
source("R/data_utils.R")
source("R/plot_utils.R")

# Create debug directory if it doesn't exist
dir.create("tmp", showWarnings = FALSE)

# Load and process data
tpm_matrix <- read.table("data/tpm_df.tsv", sep = "\t", header = TRUE)
group_means_melted <- create_melted_data(tpm_matrix)

# Filter for Amh gene
debug_gene <- "Amh"

# Create data for both mean and individual plots
mean_data <- sort_data(
    group_means_melted,
    debug_gene,
    show_samples = FALSE,
    log_scale = FALSE
)

individual_data <- sort_data(
    group_means_melted,
    debug_gene,
    show_samples = TRUE,
    log_scale = FALSE
)

# Create both types of plots
mean_plot <- create_scatter_plot(
    mean_data,
    is_first_plot = TRUE,
    show_samples = FALSE,
    log_scale = FALSE
)

individual_plot <- create_scatter_plot(
    individual_data,
    is_first_plot = TRUE,
    show_samples = TRUE,
    log_scale = FALSE
)

# Create a subplot combining both plots
combined_plot <- subplot(
    mean_plot, individual_plot,
    nrows = 2,
    heights = c(0.5, 0.5),
    shareX = TRUE,
    titleY = TRUE
) %>%
    layout(
        title = "Amh Expression: Mean vs Individual Samples",
        showlegend = TRUE
    )

# Save plots
saveWidget(mean_plot, "tmp/amh_mean_plot.html", selfcontained = TRUE)
saveWidget(individual_plot, "tmp/amh_individual_plot.html", selfcontained = TRUE)
saveWidget(combined_plot, "tmp/amh_combined_plot.html", selfcontained = TRUE)

# Print data summaries for debugging
cat("\nMean data summary:\n")
print(mean_data)

cat("\nIndividual data summary:\n")
print(individual_data)