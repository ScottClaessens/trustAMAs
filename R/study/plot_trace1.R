# function to create trace plots for main models
plot_trace1 <- function(model1, resp) {
  # get trace plots
  out <-
    mcmc_plot(
      object = model1,
      type = "trace",
      variable = "^b_",
      regex = TRUE
    ) +
    theme(
      text = element_text(size = 8),
      legend.text = element_text(size = 8),
      legend.position = "bottom"
    )
  # clean up to save space
  rm(model1)
  # save
  ggsave(
    plot = out,
    file = paste0("plots/trace_", resp, ".pdf"),
    height = 5,
    width = 6
  )
  return(out)
}
