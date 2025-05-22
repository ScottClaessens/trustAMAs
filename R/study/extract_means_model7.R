# function to extract means from model 7
extract_means_model7 <- function(model7, pred1, pred2) {
  # internal function
  extract_fun <- function(country = "Overall") {
    # new data
    newdata <- expand_grid(
      country = country,
      !!sym(pred1) := if (pred1 == "treatment") c("AI", "Human") else 
        c("Deontological", "Utilitarian"),
      !!sym(pred2) := if (pred2 == "AI_frequency") 1:5 else 1:7
    )
    # get fitted values
    f <- fitted(
      object = model7,
      newdata = newdata,
      re_formula = as.formula(
        ifelse(
          country == "Overall",
          "~0", 
          paste0("~(1 + ", pred1, " * mo(", pred2, ") | country)")
          )
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
        pred1 = pred1,
        pred2 = pred2,
        post = list(post),
        Estimate = mean(post),
        Est.Error = sd(post),
        Q2.5 = quantile(post, 0.025),
        Q97.5 = quantile(post, 0.975)
      ) %>%
      ungroup() %>%
      dplyr::select(pred1, pred2, everything())
  }
  # get means overall and by country
  out <- extract_fun()
  for (country in unique(model7$data$country)) {
    out <- bind_rows(out, extract_fun(country))
  }
  return(out)
}
