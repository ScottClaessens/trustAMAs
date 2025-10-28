# function to fit model 12 to judgement updating data from the main study
fit_model12 <- function(data) {
  # data in long format
  data <-
    pivot_longer(
      data = data,
      cols = judgement_pre:confidence_post,
      names_sep = "_",
      names_to = c(".value", "time")
    ) %>%
    # convert pre/post to factor for modelling
    mutate(time = factor(time, levels = c("pre", "post")))
  # model formulas
  bf <- bf(
    judgement ~ 1 + time * treatment * advice * mo(trustworthy) + (1 | id) +
      (1 + time * treatment * advice * mo(trustworthy) | country),
    phi ~ 1 + time * treatment * advice + (1 | id) + (1 | country),
    zoi ~ 1 + time * treatment * advice + (1 | id) + (1 | country),
    coi ~ 1 + time * treatment * advice + (1 | id) + (1 | country),
    family = zero_one_inflated_beta
  )
  # set up priors
  priors <- c(
    prior(normal(0, 1), class = Intercept),
    prior(normal(0, 1), class = Intercept, dpar = phi),
    prior(normal(0, 1), class = Intercept, dpar = zoi),
    prior(normal(0, 1), class = Intercept, dpar = coi),
    prior(normal(0, 1), class = b),
    prior(normal(0, 1), class = b, dpar = phi),
    prior(normal(0, 1), class = b, dpar = zoi),
    prior(normal(0, 1), class = b, dpar = coi),
    prior(exponential(2), class = sd),
    prior(exponential(2), class = sd, dpar = phi),
    prior(exponential(2), class = sd, dpar = zoi),
    prior(exponential(2), class = sd, dpar = coi),
    prior(lkj(3), class = cor)
  )
  # fit model
  brm(
    formula = bf,
    data = data,
    prior = priors,
    cores = 4,
    control = list(adapt_delta = 0.95),
    seed = 2113
  )
}
