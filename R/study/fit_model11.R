# function to fit the model 11 to judgement updating data from the main study
fit_model11 <- function(data, cultural_data, spatial_network, 
                        linguistic_network, pred) {
  # standardise cultural data for modelling
  cultural_data <- mutate(
    cultural_data,
    across(
      where(is.numeric),
      function(x) as.numeric(scale(x))
    )
  )
  # data in long format
  data <-
    pivot_longer(
      data = data,
      cols = judgement_pre:confidence_post,
      names_sep = "_",
      names_to = c(".value", "time")
    ) %>%
    # convert pre/post to factor for modelling
    mutate(time = factor(time, levels = c("pre", "post"))) %>%
    # join cultural data
    left_join(cultural_data, by = "country") %>%
    # create duplicate iso column for modelling
    mutate(ISO2 = ISO)
  # set up the main model formula
  formula <- as.formula(
    paste0(
      "judgement ~ 1 + time * treatment * advice * ", pred, " + ",
      "(1 | id) + ",
      "(1 + time * treatment * advice | gr(ISO, cov = spatial_network)) + ",
      "(1 + time * treatment * advice | gr(ISO2, cov = linguistic_network)) + ",
      "(1 + time * treatment * advice | country)"
    )
  )
  # additional formulas for phi, coi, and zoi
  bf <- bf(
    formula,
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
    data2 = list(
      spatial_network = spatial_network,
      linguistic_network = linguistic_network
    ),
    prior = priors,
    cores = 4,
    control = list(adapt_delta = 0.95),
    seed = 2113
  )
}
