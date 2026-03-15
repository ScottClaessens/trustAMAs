# function to extract means from second model fit to follow-up data
extract_means_followup_model2 <- function(followup_model2) {
  # internal function
  extract_fun <- function(response) {
    # new data
    newdata <- expand_grid(
      time = c("pre", "post"),
      treatment = c("AI", "Human"),
      advice = c("Deontological", "Utilitarian"),
      wording = c("Original", "Revised")
    )
    # get fitted values
    f <- fitted(
      object = followup_model2,
      newdata = newdata,
      re_formula = NA,
      resp = response,
      summary = FALSE
    )
    # if confidence, calculate posterior means
    if (response == "confidence") {
      post <- matrix(0, nrow = nrow(f), ncol = ncol(f))
      for (i in 1:7) post <- post + (f[, , i] * i)
    } else {
      post <- f
    }
    # add posterior means to data and return
    newdata %>%
      mutate(
        post = lapply(seq_len(ncol(post)), function(i) as.numeric(post[,i]))
      ) %>%
      rowwise() %>%
      mutate(
        resp = response,
        post = list(post),
        Estimate = mean(post),
        Est.Error = sd(post),
        Q2.5 = rethinking::HPDI(post, prob = 0.95)[[1]],
        Q97.5 = rethinking::HPDI(post, prob = 0.95)[[2]]
      ) %>%
      ungroup() %>%
      dplyr::select(resp, everything())
  }
  # get means overall and by country for each response
  out <- extract_fun(response = "judgement")
  out <- bind_rows(out, extract_fun(response = "confidence"))
  arrange(out, resp)
}
