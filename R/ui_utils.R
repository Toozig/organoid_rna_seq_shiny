# UI helper functions

create_plot_annotations <- function(plots, subtitles) {
  num_plots <- length(plots)
  num_cols <- 2
  num_rows <- ceiling(num_plots / num_cols)
  title_y <- rev(seq(0, 1, length.out = num_rows + 1)[-1])

  annotations <- lapply(seq_along(plots), function(i) {
    list(
      x = ifelse(length(plots) == 1, 0.5, ifelse(i %% 2 == 0, 0.75, 0.25)),
      y = ifelse(i <= 2, 1, title_y[ceiling(i / 2)] - 0.075),
      text = subtitles[i],
      xref = "paper",
      yref = "paper",
      xanchor = "center",
      yanchor = "bottom",
      font = list(size = 22),
      showarrow = FALSE
    )
  })

  return(annotations)
}
