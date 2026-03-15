# function to extract means from followup model 1
extract_means_followup_model1 <- function(followup_model1, resp) {
  # new data
  newdata <- expand_grid(
    treatment = c("AI", "Human"),
    advice = c("Deontological", "Utilitarian"),
    wording = c("Original", "Revised")
  )
  # get fitted values
  f <- fitted(
    object = followup_model1,
    newdata = newdata,
    re_formula = NA,
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
