# plot results from model 4 - confidence
plot_model4_confidence <- function(means4, split_dilemma) {
  out <-
    means4 %>%
    # get confidence estimates
    filter(resp == "confidence" & dilemma == split_dilemma) %>%
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
      q2.5 = quantile(diff, 0.025),
      q97.5 = quantile(diff, 0.975)
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
      position = position_dodge(width = 0.5)
    ) +
    facet_wrap(. ~ treatment) +
    scale_colour_manual(values = c("#E69F00", "#56B4E9")) +
    scale_y_discrete(
      name = NULL,
      labels = function(x) ifelse(x == "Overall", "**Overall**", x)
    ) +
    xlab(
      paste0("Increase in confidence after seeing advice\n",
             "(on a 7-point Likert scale)")
      ) +
    ggtitle(paste0(split_dilemma, " dilemma only")) +
    theme_classic() +
    theme(
      axis.text.y = ggtext::element_markdown(),
      legend.position = "bottom"
      )
  # save and return
  ggsave(
    plot = out,
    file = paste0("plots/model4_confidence_", split_dilemma, ".pdf"),
    width = 6,
    height = 4.5
  )
  return(out)
}
