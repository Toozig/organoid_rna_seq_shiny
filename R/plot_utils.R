# Plotting utility functions
library(ggplot2)

COMMON_THEME <- theme_classic() +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 1, size = 10),
    axis.text.y = element_text(size = 10, margin = margin(r = 5, l = 5)),
    axis.title.x = element_text(size = 14, margin = margin(t = 10)),
    axis.title.y = element_text(size = 14, margin = margin(r = 10)),
    # axis.line = element_line(colour = "black"),
    # axis.ticks = element_line(colour = "black"),
    panel.grid.major = element_line(color = "gray90"),
    panel.border = element_rect(color = "black", fill = NA),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 60),
    strip.text = element_text(size = 20),
    # strip.background = element_rect(fill = "white")
  )

get_color_palette <- function() {
  return(unlist(GROUP_COLORS))
}

# Helper function to create the base plot
create_base_plot <- function(gene_data, y_title, show_samples = FALSE) {
  # Format gene names with HTML tags
  gene_data$gene_name <- paste0("<b><i>", gene_data$gene_name, "</i></b>")

  p <- ggplot(gene_data, aes(x = group, y = expression_mean, fill = group)) +
    theme(legend.position = "none") # Always hide legend

  if (!show_samples) {
    # Mean bar plot specific elements
    p <- p +
      geom_bar(stat = "identity", position = "dodge", width = 0.8) +
      geom_errorbar(
        aes(
          ymin = expression_mean - expression_sd,
          ymax = expression_mean + expression_sd
        ),
        width = 0.2, color = "black"
      )
  } else {
    # Individual bar plot specific elements
    p <- p +
      geom_bar(aes(group = sample),
        stat = "identity",
        position = position_dodge(width = 0.9),
        width = 0.8
      )
  }

  # Common elements
  p <- p +
    scale_fill_manual(values = get_color_palette(), name = NULL) +
    labs(x = "", y = y_title) +
    COMMON_THEME

  return(p)
}

facet_by_source <- function(p, facet_by_source = TRUE, share_y = FALSE) {
  if (facet_by_source) {
    scales_option <- if (share_y) "free_x" else "free"
    p <- p + facet_grid(
      gene_name ~ source,
      scales = scales_option,
      space = "free_x",
      switch = "both"
    ) +
      theme(
        strip.placement = "outside",
        axis.text.y = element_text(
          size = 10,
          margin = margin(r = 10)
        ), # Add right margin
        axis.title.y = element_text(size = 14, angle = 90),
        panel.spacing = unit(1, "lines"),
        # Ensure axis lines and ticks are visible
        axis.line.y = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        # Ensure the axis text doesn't get clipped
        plot.margin = margin(t = 20, r = 20, b = 20, l = 50)
      )
  } else {
    p <- p + facet_wrap(
      ~gene_name,
      scales = "free_y",
      strip.position = "top"
    ) +
      theme(
        strip.placement = "outside",
        axis.text.y = element_text(size = 10, margin = margin(r = 10)),
        axis.line.y = element_line(color = "black"),
        axis.ticks.y = element_line(color = "black"),
        plot.margin = margin(t = 20, r = 20, b = 20, l = 50)
      )
  }
  return(p)
}

# Main plotting functions remain the same
create_mean_bar_plot <- function(gene_data,
                                 log_scale = FALSE,
                                 facet_by_source = TRUE,
                                 share_y = FALSE) {
  y_title <- if (log_scale) "Expression level (log₂(TPM + 1))" else "Expression level (TPM)"

  p <- create_base_plot(gene_data, y_title, show_samples = FALSE) %>%
    facet_by_source(facet_by_source, share_y) %>%
    ggplotly(tooltip = c("x", "y", "fill")) %>%
    layout(
      showlegend = F,
      xaxis = list(fixedrange = FALSE),
      yaxis = list(fixedrange = FALSE)
    ) %>%
    config(mathjax = "cdn")

  return(p)
}

create_individual_bar_plot <- function(gene_data,
                                       log_scale,
                                       facet_by_source = TRUE,
                                       share_y = FALSE) {
  y_title <- if (log_scale) "Expression level (log₂(TPM + 1))" else "Expression level (TPM)"

  p <- create_base_plot(gene_data, y_title, show_samples = TRUE) %>%
    facet_by_source(facet_by_source, share_y)

  ggplotly(p, tooltip = c("x", "y", "fill", "sample")) %>%
    layout(
      showlegend = F,
      xaxis = list(fixedrange = FALSE),
      yaxis = list(fixedrange = FALSE)
    ) %>%
    config(mathjax = "cdn")
}

create_scatter_plot <- function(gene_data,
                                show_samples = FALSE,
                                log_scale = FALSE,
                                facet_by_source = TRUE,
                                share_y = FALSE) {
  if (!show_samples) {
    create_mean_bar_plot(gene_data, log_scale, facet_by_source, share_y)
  } else {
    create_individual_bar_plot(gene_data, log_scale, facet_by_source, share_y)
  }
}
