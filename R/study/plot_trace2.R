# function to create trace plots for judgement updating model
plot_trace2 <- function(model2) {
  # get trace plots
  out <-
    mcmc_plot(
      object = model2,
      type = "trace",
      variable = "^b_judgement",
      regex = TRUE,
      facet_args = list(ncol = 2)
    ) +
    theme(
      text = element_text(size = 8),
      legend.text = element_text(size = 8),
      legend.position = "bottom"
    )
  # clean up to save space
  rm(model2)
  # save
  ggsave(
    plot = out,
    file = "plots/trace_judgements.pdf",
    height = 6,
    width = 6
  )
  return(out)
}
