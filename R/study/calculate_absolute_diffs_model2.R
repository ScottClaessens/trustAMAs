# function to calculate absolute pre-post differences in judgements from model 2
calculate_absolute_diffs_model2 <- function(means2) {
  # get pre-post differences in judgements
  means2 %>%
    filter(resp == "judgement") %>%
    dplyr::select(!c(Estimate:Q97.5)) %>%
    pivot_wider(
      names_from = time,
      values_from = post
    ) %>%
    rowwise() %>%
    mutate(
      diff = list(post - pre),
      absolute_diff = if (median(diff) < 0) list(-diff) else list(diff)
      ) %>%
    dplyr::select(!c(pre, post))
}
