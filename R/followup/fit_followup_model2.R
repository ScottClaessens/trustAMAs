# function to fit the second model to data from the follow-up study
fit_followup_model2 <- function(followup_data) {
  # data in long format
  data <-
    pivot_longer(
      data = followup_data,
      cols = judgement_pre:confidence_post,
      names_sep = "_",
      names_to = c(".value", "time")
    ) %>%
    # convert pre/post to factor for modelling
    mutate(time = factor(time, levels = c("pre", "post")))
  # set up the model formulas
  bf1 <- bf(
    judgement ~ 1 + time * treatment * advice * wording + (1 | id),
    phi ~ 1 + time * treatment * advice * wording + (1 | id),
    zoi ~ 1 + time * treatment * advice * wording + (1 | id),
    coi ~ 1 + time * treatment * advice * wording + (1 | id),
    family = zero_one_inflated_beta
  )
  bf2 <- bf(
    confidence ~ 1 + time * treatment * advice * wording + (1 | id),
    family = cumulative
  )
  # set up priors
  priors <- c(
    prior(normal(0, 1), class = Intercept, resp = judgement),
    prior(normal(0, 1), class = Intercept, resp = judgement, dpar = phi),
    prior(normal(0, 1), class = Intercept, resp = judgement, dpar = zoi),
    prior(normal(0, 1), class = Intercept, resp = judgement, dpar = coi),
    prior(normal(0, 1), class = b, resp = judgement),
    prior(normal(0, 1), class = b, resp = judgement, dpar = phi),
    prior(normal(0, 1), class = b, resp = judgement, dpar = zoi),
    prior(normal(0, 1), class = b, resp = judgement, dpar = coi),
    prior(exponential(2), class = sd, resp = judgement),
    prior(exponential(2), class = sd, resp = judgement, dpar = phi),
    prior(exponential(2), class = sd, resp = judgement, dpar = zoi),
    prior(exponential(2), class = sd, resp = judgement, dpar = coi),
    prior(normal(0, 2), class = Intercept, resp = confidence),
    prior(normal(0, 1), class = b, resp = confidence),
    prior(exponential(2), class = sd, resp = confidence)
  )
  # fit model
  brm(
    formula = bf1 + bf2 + set_rescor(FALSE),
    data = data,
    prior = priors,
    cores = 4,
    control = list(adapt_delta = 0.95),
    seed = 2113
  )
}
