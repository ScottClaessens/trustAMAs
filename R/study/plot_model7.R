# function to plot results of model 7
plot_model7 <- function(means, pred1, pred2) {
  # x-axis labels
  xlabs <- c(
    "religiosity" = "Religiosity",
    "political_ideology" = "Political ideology (conservatism)",
    "AI_frequency" = "Frequency of AI use",
    "AI_familiarity" = "Familiarity with AI"
  )
  # get differences and plot
  means %>%
    filter(country == "Overall") %>%
    dplyr::select(!c(Estimate:Q97.5)) %>%
    pivot_wider(
      names_from = !!sym(pred1),
      values_from = post
    ) %>%
    rowwise() %>%
    mutate(
      diff = if (pred1 == "advice") list(Deontological - Utilitarian) else
        list(Human - AI)
      ) %>%
    dplyr::select(pred1, pred2, country, !!sym(pred2), diff) %>%
    mutate(
      Estimate = median(diff),
      Q2.5     = rethinking::HPDI(diff, prob = 0.95)[[1]],
      Q25      = rethinking::HPDI(diff, prob = 0.50)[[1]],
      Q75      = rethinking::HPDI(diff, prob = 0.50)[[2]],
      Q97.5    = rethinking::HPDI(diff, prob = 0.95)[[2]]
    ) %>%
    ggplot(mapping = aes(x = !!sym(pred2))) +
    geom_hline(
      yintercept = 0,
      linetype = "dashed",
      linewidth = 0.3
    ) +
    geom_ribbon(
      mapping = aes(ymin = Q2.5, ymax = Q97.5),
      fill = "#D3D3D3",
      alpha = 0.5
      ) +
    geom_ribbon(
      mapping = aes(ymin = Q25, ymax = Q75),
      fill = "#D3D3D3",
      alpha = 0.5
    ) +
    geom_line(mapping = aes(y = Estimate)) +
    scale_x_continuous(
      name = xlabs[pred2],
      breaks = if (pred2 == "AI_frequency") 1:5 else 1:7
      ) +
    scale_y_continuous(
      name = ifelse(
        pred1 == "advice",
        "Trust in deontological advisor\ncompared to utilitarian advisor",
        "Trust in human advisor\ncompared to AI advisor"
        ),
      limits = if (str_starts(pred2, fixed("AI"))) c(-0.1, 0.6) else c(-0.1, 1.2)
    ) +
    theme_classic() +
    theme(legend.position = "none")
}
