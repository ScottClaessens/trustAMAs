# function to fit model 3 to data from the main study
fit_model3 <- function(data, resp) {
  # set up the brms formula
  formula <- bf(
    paste(
      resp,
      "~ 1 + treatment * advice * dilemma + (1 | id)",
      "+ (1 + treatment * advice * dilemma | country)"
      )
    )
  # set up priors
  priors <- c(
    prior(normal(0, 2), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd),
    prior(lkj(2), class = cor)
  )
  # fit model
  brm(
    formula = formula,
    data = data,
    family = cumulative,
    prior = priors,
    cores = 4,
    control = list(adapt_delta = 0.95),
    seed = 2113
  )
}
