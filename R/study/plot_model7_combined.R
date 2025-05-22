# function to combine model 7 plots with patchwork
plot_model7_combined <- function(plot7_religiosity, plot7_political_ideology,
                                 plot7_AI_familiarity, plot7_AI_frequency) {
  # combine plots
  top <-
    (plot7_religiosity | plot7_political_ideology) + 
    plot_layout(
      axes = "collect",
      guides = "collect"
      )
  bottom <-
    (plot7_AI_familiarity | plot7_AI_frequency) + 
    plot_layout(
      axes = "collect",
      guides = "collect"
    )
  out <- top / bottom
  # save and return
  ggsave(
    plot = out,
    filename = "plots/model7.pdf",
    width = 5,
    height = 5
  )
  return(out)
}
