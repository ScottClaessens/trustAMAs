# function to run power analysis for mixed design
run_power_analysis_mixed <- function(id = 1, n = 500) {
  # create data structure with participant-specific errors
  d <- data.frame(
    id = rep(1:n, each = 2),
    advisor = rep(sample(c("AI", "Human"), size = n, replace = TRUE), each = 2),
    advice = rep(c("Utilitarian", "Deontological"), times = n),
    error = rep(rnorm(n, 0, 1.14), each = 2)
  )
  # simulate likert responses
  # values from clmm model fitted to Myers & Everett (2024)
  thresholds <- c(-2.89, -1.90, -1.01, 0.43, 2.00, 3.85)
  d$response <-
    ifelse(
      d$advisor == "AI",
      ifelse(
        d$advice == "Utilitarian",
        rordlogit(n*2, a = thresholds, phi = d$error),
        rordlogit(n*2, a = thresholds, phi = d$error + 0.79)
      ),
      ifelse(
        d$advice == "Utilitarian",
        rordlogit(n*2, a = thresholds, phi = d$error + 0.62),
        rordlogit(n*2, a = thresholds, phi = d$error + 0.62 + 0.79 + 0.28)
      )
    )
  # variables as factors
  d <-
    d %>%
    mutate(
      response = factor(response, levels = 1:7, ordered = TRUE),
      advisor = factor(advisor, levels = c("AI", "Human")),
      advice = factor(advice, levels = c("Utilitarian", "Deontological"))
    )
  # fit clmm model
  m <- clmm(
    formula = response ~ advisor*advice + (1 | id),
    data = d
  )
  # return result
  summary(m)$coefficients[-c(1:6), ] %>% 
    as_tibble(rownames = "Parameter") %>%
    mutate(
      ID = id,
      sig = Estimate > 0 & `Pr(>|z|)` < 0.05
      ) %>%
    dplyr::select(ID, everything(), sig)
}
