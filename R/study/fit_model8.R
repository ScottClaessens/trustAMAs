# function to fit model 8 to data from the main study
fit_model8 <- function(data, cultural_data, pred1, pred2) {
  # standardise cultural data for modelling
  cultural_data <- mutate(
    cultural_data,
    across(
      where(is.numeric),
      function(x) as.numeric(scale(x))
    )
  )
  # join datasets
  data <- left_join(data, cultural_data, by = "country")
  # set up the brms formula
  formula <- bf(
    paste(
      "trustworthy ~ 1 + ", pred1, " * ", pred2, " + (1 | id)",
      "+ (1 + ", pred1, " | country)"
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
