# function to extract means from pilot model 2
extract_means_pilot_model2 <- function(pilot_model2) {
  # tibble with new data
  d <- expand_grid(
    treatment = c("Human", "AI"),
    advice = c("Deontological", "Utilitarian"),
    time = c("pre", "post")
  )
  # function to loop over outcome variables
  fun <- function(resp) {
    # get fitted values from the model
    f <- fitted(
      object = pilot_model2,
      newdata = d,
      re_formula = NA,
      resp = resp,
      scale = "response",
      summary = FALSE
    )
    if (resp == "confidence") {
      # convert from probabilities of each level to estimated means
      means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
      for (i in 1:7) means <- means + (f[, , i] * i)
    } else {
      means <- f
    }
    # add means to data
    d <- 
      d %>%
      mutate(
        resp = resp,
        post = lapply(
          seq_len(ncol(means)), function(i) as.numeric(means[,i])
        )
      ) %>%
      rowwise() %>%
      mutate(
        estimate = median(post),
        lower50 = rethinking::HPDI(post, prob = 0.50)[[1]],
        lower95 = rethinking::HPDI(post, prob = 0.95)[[1]],
        upper50 = rethinking::HPDI(post, prob = 0.50)[[2]],
        upper95 = rethinking::HPDI(post, prob = 0.95)[[2]]
      ) %>%
      ungroup() %>%
      dplyr::select(resp, everything())
  }
  # repeat for each outcome variable and bind results
  bind_rows(
    fun(resp = "judgement"),
    fun(resp = "confidence")
  )
}
