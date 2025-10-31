# function to extract means from model 3
extract_means_model3 <- function(model3, resp) {
  # internal function
  extract_fun <- function(country = "Overall") {
    # new data
    newdata <- expand_grid(
      country = country,
      treatment = c("AI", "Human"),
      advice = c("Deontological", "Utilitarian"),
      dilemma = c("Bike", "Baby")
    )
    # get fitted values
    f <- fitted(
      object = model3,
      newdata = newdata,
      re_formula = as.formula(
        ifelse(country == "Overall", "~0", "~(1 + treatment*advice*dilemma | country)")
      ),
      summary = FALSE
    )
    # calculate posterior means
    post <- matrix(0, nrow = nrow(f), ncol = ncol(f))
    for (i in 1:7) post <- post + (f[, , i] * i)
    # add posterior means to data and return
    newdata %>%
      mutate(
        post = lapply(seq_len(ncol(post)), function(i) as.numeric(post[,i]))
      ) %>%
      rowwise() %>%
      mutate(
        resp = resp,
        post = list(post),
        Estimate = mean(post),
        Est.Error = sd(post),
        Q2.5 = rethinking::HPDI(post, prob = 0.95)[[1]],
        Q97.5 = rethinking::HPDI(post, prob = 0.95)[[2]]
      ) %>%
      ungroup() %>%
      dplyr::select(resp, everything())
  }
  # get means overall and by country
  out <- extract_fun()
  for (country in unique(model3$data$country)) {
    out <- bind_rows(out, extract_fun(country))
  }
  return(out)
}
