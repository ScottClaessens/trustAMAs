# function to plot cross-cultural differences in judgement updating
plot_model11 <- function(data, cultural_data, model11, pred) {
  # x-axis labels
  xlabs <- c(
    "relational_mobility_latent" = "Relational mobility",
    "tightness" = "Cultural tightness",
    "individualism" = "Individualism",
    "AI_readiness" = "Government AI Readiness Index",
    "AI_index" = "Global AI Index"
  )
  # standardise cultural data
  cultural_data <- mutate(
    cultural_data,
    across(
      where(is.numeric),
      function(x) as.numeric(scale(x))
    )
  )
  # get country averages
  data <-
    data %>%
    mutate(judgement_diff = judgement_post - judgement_pre) %>%
    group_by(country, treatment, advice) %>%
    summarise(judgement_diff = mean(judgement_diff, na.rm = TRUE)) %>%
    ungroup() %>%
    left_join(cultural_data, by = "country") %>%
    mutate(
      treatment = paste0("Advisor = ", treatment),
      advice = paste0("Advice = ", advice)
    )
  # get fitted values
  newdata <- expand_grid(
    time = c("pre", "post"),
    treatment = c("AI", "Human"),
    advice = c("Deontological", "Utilitarian"),
    !!sym(pred) := seq(-1.5, 2.75, length.out = 100)
  )
  f <- fitted(
    object = model11,
    newdata = newdata,
    re_formula = NA,
    summary = FALSE
  )
  # remove model to save space
  rm(model11)
  # get pre-post differences
  post <- 
    newdata %>%
    mutate(f = lapply(seq_len(ncol(f)), function(i) as.numeric(f[,i]))) %>%
    pivot_wider(
      names_from = time,
      values_from = f
    ) %>%
    rowwise() %>%
    mutate(
      diff = list(post - pre),
      Estimate = mean(diff),
      Est.Error = sd(diff),
      Q2.5 = quantile(diff, 0.025),
      Q97.5 = quantile(diff, 0.975),
      treatment = paste0("Advisor = ", treatment),
      advice = paste0("Advice = ", advice)
    ) %>%
    ungroup()
  # plot
  p <-
    ggplot() +
    geom_hline(
      yintercept = 0,
      colour = "white"
    ) +
    geom_point(
      data = data,
      mapping = aes(
        x = !!sym(pred),
        y = judgement_diff
      )
    ) +
    geom_text_repel(
      data = data,
      mapping = aes(
        x = !!sym(pred),
        y = judgement_diff,
        label = ISO
      ),
      size = 1.5,
      seed = 1
    ) +
    geom_ribbon(
      data = post,
      mapping = aes(
        x = !!sym(pred),
        ymin = Q2.5,
        ymax = Q97.5
      ),
      alpha = 0.2,
      fill = "grey50",
      colour = NA
    ) +
    geom_line(
      data = post,
      mapping = aes(
        x = !!sym(pred),
        y = Estimate
      )
    ) +
    facet_grid(advice ~ treatment) +
    scale_x_continuous(name = as.character(xlabs[pred])) +
    scale_y_continuous(
      name = expression(
        atop(
          "Pre-post shift in judgement (0-1 scale)",
          paste("Deontological" %<->% "Utilitarian")
        )
      ),
      limits = c(-0.22, 0.22)
    ) +
    theme(panel.grid = element_blank())
  # save
  ggsave(
    plot = p,
    filename = paste0("plots/model11_", pred, ".pdf"),
    width = 6,
    height = 5
  )
  return(p)
}
