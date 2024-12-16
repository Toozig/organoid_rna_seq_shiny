# Load required packages
library(shiny)
library(readr)
library(stringr)
library(tidyr)
library(dplyr)
library(reshape2)
library(coin)
library(plotly)
library(bslib)
library(shinyjs)
library(htmlwidgets)
library(ggplot2)

# Source utility functions and constants
source("R/constants.R")
source("R/data_utils.R")

# Load and process data
tpm_matrix <- read.table(TPM_FILE_PATH, sep = "\t", header = TRUE)
filtered_df <- tpm_matrix[!grepl("Rik$", tpm_matrix[[GENE_NAME_COL]]), ]

# Create melted data for plotting using the new function
group_means_melted <- create_melted_data(tpm_matrix)

# Create ordered matrix for gene selection
ord_mtx <- tpm_matrix[order(tpm_matrix[[GENE_NAME_COL]]), ]
