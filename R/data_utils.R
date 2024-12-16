# Data processing utility functions


process_melted_data <- function(group_means_melted) {
  # Process stage and source information
  group_means_melted$stage <- sub("_rep.*", "", group_means_melted$sample)
  group_means_melted$source <- sub(".*_", "", group_means_melted$stage)
  group_means_melted$stage <- sub("_.*", "", group_means_melted$stage)
  group_means_melted$cell_type <- ifelse(grepl(TESTIS_PATTERN, group_means_melted$sample),
    CELL_TYPE_TESTIS, CELL_TYPE_ORGANOID
  )

  return(group_means_melted)
}

# Create melted data function
create_melted_data <- function(tpm_matrix) {
  # Create melted data for plotting
  melted_data <- melt(tpm_matrix,
    id.vars = GENE_NAME_COL,
    variable.name = "sample",
    value.name = "expression"
  )

  # Process the melted data
  processed_data <- process_melted_data(melted_data)

  return(processed_data)
}

clean_matrix <- function(tpm_matrix) {
  # Remove unwanted columns (transcript_id)
  tpm_matrix <- tpm_matrix[, -COLS_TO_REMOVE]

  # No need for column name processing as they are already in the correct format
  return(tpm_matrix)
}

sort_data <- function(data, genes_names, show_samples = FALSE, log_scale = FALSE) {
  # First filter and process the data
  data <- data %>%
    filter(!!sym(GENE_NAME_COL) %in% genes_names) %>%
    mutate(
      stage = sub("_rep.*", "", sample),
      source = sub(".*_", "", stage),
      stage = sub("_.*", "", stage),
      group = paste0(stage, "_", source),
      group = factor(group, levels = GROUP_ORDER),
      # Add small value before log to handle zeros
      expression = if(log_scale) log2(expression + 1) else expression
    )
  
  if (!show_samples) {
    data <- data %>%
      group_by(!!sym(GENE_NAME_COL), group) %>%
      summarise(
        expression_mean = mean(expression, na.rm = TRUE),
        expression_sd = sd(expression, na.rm = TRUE),
        n = n(),
        .groups = 'drop'
      ) %>%
      mutate(
        group = factor(group, levels = GROUP_ORDER),
        expression_sd = ifelse(n > 1, expression_sd, NA)
      )
  } else {
    data <- data %>%
      mutate(
        expression_mean = expression,
        sample = factor(sample)
      )
  }
  
  return(data)
}

get_pval <- function(data) {
  p_df <- data.frame(
    gene_name = character(),
    p_value = numeric(),
    group = character(),
    stringsAsFactors = FALSE
  )

  # Calculate p-values for each group
  for (grp in unique(data$group)) {
    p_values <- data %>%
      filter(group == grp) %>%
      group_by(!!sym(GENE_NAME_COL)) %>%
      summarize(p_value = t.test(expression)$p.value) %>%
      mutate(group = grp)
    p_df <- rbind(p_df, p_values)
  }

  p_df <- p_df[order(match(p_df$group, GROUP_ORDER)), ]
  p_df$label <- ifelse(p_df$p_value >= ALPHA_LEVELS[1], "-ns-",
    ifelse(p_df$p_value >= ALPHA_LEVELS[2], "-*-", "-**-")
  )
  return(p_df)
}
