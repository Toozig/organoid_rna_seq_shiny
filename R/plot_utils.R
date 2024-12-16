# Plotting utility functions
library(ggplot2)

get_color_palette <- function() {
  return(unlist(GROUP_COLORS))
}

create_mean_bar_plot <- function(gene_data, is_first_plot, log_scale = FALSE, facet_ncol = 1) {
  y_title <- if (log_scale) {
    "Expression level (log₂(TPM + 1))"
  } else {
    "Expression level (TPM)"
  }
  
  # Calculate height based on number of genes and layout
  n_genes <- length(unique(gene_data$gene_name))
  n_rows <- ceiling(n_genes/facet_ncol)
  plot_height <- max(500 * n_rows, 600)  # Increased from 300/400 to 500/600
  
  p <- ggplot(gene_data, aes(x = group, y = expression_mean, fill = group)) +
    geom_bar(stat = "identity", position = "dodge", width = 0.8) +
    geom_errorbar(aes(ymin = expression_mean - expression_sd, 
                     ymax = expression_mean + expression_sd),
                 width = 0.2, color = "black") +
    scale_fill_manual(values = get_color_palette()) +
    labs(x = "Sample", 
         y = y_title) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
      axis.title.x = element_text(size = 14, margin = margin(t = 20)),
      axis.title.y = element_text(size = 14),
      legend.title = element_blank(),
      legend.text = element_text(size = 10),
      panel.grid.major = element_line(color = "gray90"),
      panel.grid.minor = element_blank(),
      plot.margin = margin(b = 70, l = 50, r = 50, t = 30)
    ) +
    facet_wrap(~gene_name, scales = "free_y", ncol = facet_ncol)
    
  if (!is_first_plot) {
    p <- p + theme(legend.position = "none")
  }
  
  ggplotly(p, tooltip = c("x", "y", "fill"), height = plot_height) %>%
    layout(showlegend = is_first_plot)
}

create_individual_bar_plot <- function(gene_data, is_first_plot, log_scale, facet_ncol = 1) {
  y_title <- if (log_scale) {
    "Expression level (log₂(TPM + 1))"
  } else {
    "Expression level (TPM)"
  }
  
  # Calculate height based on number of genes and layout
  n_genes <- length(unique(gene_data$gene_name))
  n_rows <- ceiling(n_genes/facet_ncol)
  plot_height <- max(500 * n_rows, 600)  # Increased from 300/400 to 500/600
  
  p <- ggplot(gene_data, aes(x = group, y = expression_mean, fill = group)) +
    geom_bar(aes(group = sample),
             stat = "identity", 
             position = position_dodge(width = 0.9),
             width = 0.8) +
    scale_fill_manual(values = get_color_palette()) +
    labs(x = "Sample",
         y = y_title) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
      axis.title.x = element_text(size = 14, margin = margin(t = 20)),
      axis.title.y = element_text(size = 14),
      legend.title = element_blank(),
      legend.text = element_text(size = 10),
      panel.grid.major = element_line(color = "gray90"),
      panel.grid.minor = element_blank(),
      plot.margin = margin(b = 70, l = 50, r = 50, t = 30)
    ) +
    facet_wrap(~gene_name, scales = "free_y", ncol = facet_ncol)
    
  if (!is_first_plot) {
    p <- p + theme(legend.position = "none")
  }
  
  ggplotly(p, tooltip = c("x", "y", "fill", "sample")) %>%
    layout(
      showlegend = is_first_plot,
      barmode = "group"
    )
}

create_scatter_plot <- function(gene_data,
                              is_first_plot,
                              show_samples = FALSE,
                              log_scale = FALSE,
                              facet_ncol = 1) {
  # Use the appropriate plotting function based on show_samples
  if (!show_samples) {
    create_mean_bar_plot(gene_data, is_first_plot, log_scale, facet_ncol)
  } else {
    create_individual_bar_plot(gene_data, is_first_plot, log_scale, facet_ncol)
  }
}

# Remove or comment out the create_box_plot function as it's not being used
