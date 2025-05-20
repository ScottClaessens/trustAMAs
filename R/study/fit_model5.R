# function to fit model 5 to data from the main study
fit_model5 <- function(data, resp) {
  # calculate agreement variable from initial judgement
  # initial judgement is a slider from 0 to 1:
  #    0 = deontological
  #    1 = utilitarian
  # to calculate agreement with the advice, we leave the initial judgement
  # unchanged if the advice is utilitarian and reverse it if the advice is
  # deontological
  data <- 
    data %>%
    mutate(
      agreement = ifelse(
        advice == "Utilitarian",
        judgement_pre,
        1 - judgement_pre
        )
      )
  # set up the brms formula
  formula <- bf(
    paste(
      resp,
      "~ 1 + treatment * advice * agreement + (1 | id) + 
      (1 + treatment * advice * agreement | country)"
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
