# function to plot posterior predictive check for model 2
plot_model2_pp_check <- function(model2) {
  # plot pp check
  out <- 
    pp_check(
      object = model2,
      resp = "judgement",
      ndraws = 20
    ) +
    labs(
      x = "Moral judgement (0-1 sliding scale)",
      y = "Density"
    ) +
    theme_classic()
  # clean up to save space
  rm(model2)
  # save
  ggsave(
    plot = out,
    file = "plots/posterior_check_judgements.pdf",
    height = 4,
    width = 4.5
  )
  return(out)
}
