# function to extract means from model 4
extract_means_model4 <- function(model4, resp) {
  # internal function
  extract_fun <- function(response, country = "Overall") {
    # new data
    newdata <- expand_grid(
      country = country,
      time = c("pre", "post"),
      treatment = c("AI", "Human"),
      advice = c("Deontological", "Utilitarian"),
      dilemma = c("Bike", "Baby")
    )
    # get fitted values
    f <- fitted(
      object = model4,
      newdata = newdata,
      re_formula = as.formula(
        ifelse(country == "Overall", "~0", "~(1 + treatment*advice | country)")
      ),
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
        Q2.5 = quantile(post, 0.025),
        Q97.5 = quantile(post, 0.975)
      ) %>%
      ungroup() %>%
      dplyr::select(resp, everything())
  }
  # get means overall and by country for each response
  out <- extract_fun(response = "judgement")
  out <- bind_rows(out, extract_fun(response = "confidence"))
  for (country in unique(model4$data$country)) {
    out <- bind_rows(out, extract_fun(response = "judgement", country))
    out <- bind_rows(out, extract_fun(response = "confidence", country))
  }
  out <- arrange(out, resp)
  return(out)
}
