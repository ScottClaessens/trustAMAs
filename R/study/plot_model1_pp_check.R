# function to plot posterior predictive check for model 1
plot_model1_pp_check <- function(model1, resp) {
  # titles
  xlabs <- c(
    "trustworthy" = "Trustworthy",
    "blame" = "Blame",
    "trust_other_issues" = "Trust on other issues",
    "surprise" = "Surprise",
    "humanlike" = "Human-like"
  )
  # plot pp check
  out <- 
    pp_check(
      object = model1,
      type = "bars",
      ndraws = 20,
      fatten = 1
    ) +
    xlab(as.character(xlabs[resp])) +
    theme_classic()
  # clean up
  rm(model1)
  return(out)
}
