# function to combine model 8 plots with patchwork
plot_model8_combined <- function(plot8_relational_mobility_latent,
                                 plot8_tightness,
                                 plot8_individualism,
                                 plot8_AI_readiness,
                                 plot8_AI_index) {
  # combine plots
  top <-
    (plot8_relational_mobility_latent | plot8_tightness | plot8_individualism) + 
    plot_layout(
      axes = "collect",
      guides = "collect"
      )
  bottom <-
    (plot8_AI_readiness | plot8_AI_index) + 
    plot_layout(
      axes = "collect",
      guides = "collect"
    )
  out <- top / bottom
  # save and return
  ggsave(
    plot = out,
    filename = "plots/model8.pdf",
    width = 6,
    height = 5
  )
  return(out)
}
