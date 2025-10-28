# function to plot differences in judgement updating by trust
plot_model12 <- function(model12) {
  # get fitted values
  newdata <- expand_grid(
    time = c("pre", "post"),
    treatment = c("AI", "Human"),
    advice = c("Deontological", "Utilitarian"),
    trustworthy = 1:7
  )
  f <- fitted(
    object = model12,
    newdata = newdata,
    re_formula = NA,
    summary = FALSE
  )
  # remove model to save space
  rm(model12)
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
      colour = "grey20",
      linetype = "dashed",
      linewidth = 0.2
    ) +
    geom_pointrange(
      data = post,
      mapping = aes(
        x = trustworthy,
        y = Estimate,
        ymin = Q2.5,
        ymax = Q97.5
      )
    ) +
    facet_grid(advice ~ treatment) +
    scale_x_continuous(
      name = "Perceived trustworthiness of advisor",
      breaks = 1:7
    ) +
    scale_y_continuous(
      name = expression(
        atop(
          "Pre-post shift in judgement (0-1 scale)",
          paste("Deontological" %<->% "Utilitarian")
        )
      ),
      limits = c(-0.22, 0.22)
    ) +
    theme_bw() +
    theme(panel.grid = element_blank())
  # save
  ggsave(
    plot = p,
    filename = "plots/model12.pdf",
    width = 4.5,
    height = 4
  )
  return(p)
}
