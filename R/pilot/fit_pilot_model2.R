# function to fit model 2 to pilot data
fit_pilot_model2 <- function(pilot_data_long) {
  # set up bf formulas
  bf1 <- bf(
    judgement ~ treatment*advice*time + (1 |i| id),
    phi ~ treatment*advice*time + (1 |i| id),
    zoi ~ treatment*advice*time + (1 |i| id),
    coi ~ treatment*advice*time + (1 |i| id),
    family = zero_one_inflated_beta()
    )
  bf2 <- bf(
    confidence ~ treatment*advice*time + (1 |i| id),
    family = cumulative()
    )
  # set priors
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
    prior(exponential(2), class = sd, resp = confidence),
    prior(lkj(3), class = cor)
  )
  # fit model
  brm(
    formula = bf1 + bf2 + set_rescor(FALSE),
    data = pilot_data_long,
    prior = priors,
    iter = 4000,
    cores = 4,
    seed = 2113
  )
}
