# function to extract means from pilot model 1
extract_means_pilot_model1 <- function(pilot_model1) {
  # function to loop over outcome variables
  fun <- function(resp) {
    # tibble with new data
    if (resp %in% c("humanlike", "cold", "illogical")) {
      d <- tibble(
        treatment = "AI",
        advice = c("Utilitarian", "Deontological"),
        sub = TRUE
        )
    } else {
      d <- expand_grid(
        treatment = c("Human", "AI"),
        advice = c("Utilitarian", "Deontological")
      )
    }
    # get fitted values from the model
    f <- fitted(
      object = pilot_model1,
      newdata = d,
      re_formula = NA,
      resp = resp,
      scale = "response",
      summary = FALSE
    )
    # convert from probabilities of each level to estimated means
    means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
    for (i in 1:7) means <- means + (f[, , i] * i)
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
        lower = rethinking::HPDI(post, prob = 0.95)[[1]],
        upper = rethinking::HPDI(post, prob = 0.95)[[2]]
      ) %>%
      ungroup() %>%
      dplyr::select(resp, everything())
    # remove columns
    if (resp %in% c("humanlike", "cold", "illogical")) {
      dplyr::select(d, !c(post, sub))
    } else {
      dplyr::select(d, !c(post))
    }
  }
  # repeat for each outcome variable and bind results
  bind_rows(
    fun(resp = "trustworthy"),
    fun(resp = "blame"),
    fun(resp = "trustotherissues"),
    fun(resp = "surprise"),
    fun(resp = "humanlike"),
    fun(resp = "cold"),
    fun(resp = "illogical")
  )
}
