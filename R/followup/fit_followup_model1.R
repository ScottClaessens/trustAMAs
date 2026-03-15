# function to fit the first model to data from the followup study
fit_followup_model1 <- function(data, resp) {
  # set up the brms formula
  formula <- bf(paste(resp, "~ 1 + treatment * advice * wording + (1 | id)"))
  # set up priors
  priors <- c(
    prior(normal(0, 2), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd)
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
