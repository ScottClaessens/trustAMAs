# function to fit model 1 to pilot data
fit_pilot_model1 <- function(pilot_data) {
  # create subset variable for AI-only responses
  pilot_data$sub <- pilot_data$treatment == "AI"
  # set up bf formulas
  bf1 <- bf(trustworthy        ~ treatment*advice + (1 |i| id))
  bf2 <- bf(blame              ~ treatment*advice + (1 |i| id))
  bf3 <- bf(trust_other_issues ~ treatment*advice + (1 |i| id))
  bf4 <- bf(surprise           ~ treatment*advice + (1 |i| id))
  bf5 <- bf(humanlike | subset(sub) ~ advice + (1 |i| id))
  bf6 <- bf(cold      | subset(sub) ~ advice + (1 |i| id))
  bf7 <- bf(illogical | subset(sub) ~ advice + (1 |i| id))
  # set priors
  priors <- c(
    prior(normal(0, 2), class = Intercept, resp = trustworthy),
    prior(normal(0, 2), class = Intercept, resp = blame),
    prior(normal(0, 2), class = Intercept, resp = trustotherissues),
    prior(normal(0, 2), class = Intercept, resp = surprise),
    prior(normal(0, 2), class = Intercept, resp = humanlike),
    prior(normal(0, 2), class = Intercept, resp = cold),
    prior(normal(0, 2), class = Intercept, resp = illogical),
    prior(normal(0, 1), class = b, resp = trustworthy),
    prior(normal(0, 1), class = b, resp = blame),
    prior(normal(0, 1), class = b, resp = trustotherissues),
    prior(normal(0, 1), class = b, resp = surprise),
    prior(normal(0, 1), class = b, resp = humanlike),
    prior(normal(0, 1), class = b, resp = cold),
    prior(normal(0, 1), class = b, resp = illogical),
    prior(exponential(2), class = sd, resp = trustworthy),
    prior(exponential(2), class = sd, resp = blame),
    prior(exponential(2), class = sd, resp = trustotherissues),
    prior(exponential(2), class = sd, resp = surprise),
    prior(exponential(2), class = sd, resp = humanlike),
    prior(exponential(2), class = sd, resp = cold),
    prior(exponential(2), class = sd, resp = illogical),
    prior(lkj(2), class = cor)
  )
  # fit model
  brm(
    formula = bf1 + bf2 + bf3 + bf4 + bf5 + bf6 + bf7 + set_rescor(FALSE),
    data = pilot_data,
    family = "cumulative",
    prior = priors,
    cores = 4,
    seed = 2113
  )
}
