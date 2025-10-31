# plot results from model 2 - confidence
plot_model2_confidence <- function(means2) {
  out <-
    means2 %>%
    # get confidence estimates
    filter(resp == "confidence") %>%
    # get pre-post differences
    dplyr::select(country, treatment, advice, time, post) %>%
    pivot_wider(
      names_from = "time",
      values_from = "post"
    ) %>%
    rowwise() %>%
    mutate(
      diff = list(post - pre),
      med = median(diff),
      q2.5 = rethinking::HPDI(diff, prob = 0.95)[[1]],
      q97.5 = rethinking::HPDI(diff, prob = 0.95)[[2]]
      ) %>%
    dplyr::select(!c(pre, post)) %>%
    unnest(diff) %>%
    rename(Advice = advice) %>%
    mutate(treatment = paste(treatment, "Advisor")) %>%
    # plot
    ggplot(
      aes(
        x = diff,
        y = fct_relevel(fct_reorder(country, med), "Overall", after = 0),
        colour = Advice
        )
      ) +
    geom_vline(
      xintercept = 0,
      linetype = "dashed",
      colour = "lightgrey"
    ) +
    stat_pointinterval(
      position = position_dodge(width = 0.5),
      point_interval = "median_hdi"
    ) +
    facet_wrap(. ~ treatment) +
    scale_colour_manual(values = c("#E69F00", "#56B4E9")) +
    ylab(NULL) +
    xlab(
      paste0("Increase in confidence after seeing advice\n",
             "(on a 7-point Likert scale)")
      ) +
    theme_classic() +
    theme(legend.position = "bottom")
  # save and return
  ggsave(
    plot = out,
    file = "plots/model2_confidence.pdf",
    width = 6,
    height = 4.5
  )
  return(out)
}
