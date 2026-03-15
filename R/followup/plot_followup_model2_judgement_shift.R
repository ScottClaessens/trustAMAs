# function to plot shifts in judgement in follow-up study, split by wording
plot_followup_model2_judgement_shift <- function(followup_means2) {
  # plot
  out <- 
    followup_means2 %>%
    # judgements across all countries
    filter(resp == "judgement") %>%
    # get pre-post differences
    dplyr::select(!c(Estimate, Est.Error, Q2.5, Q97.5)) %>%
    pivot_wider(
      names_from = time,
      values_from = post
    ) %>%
    rowwise() %>%
    mutate(diff = list(post - pre)) %>%
    dplyr::select(!c(pre, post)) %>%
    unnest(diff) %>%
    rename(Advice = advice) %>%
    mutate(wording = paste0(wording, " wording")) %>%
    # plot
    ggplot(mapping = aes(x = diff, y = treatment, fill = Advice)) +
    geom_vline(
      xintercept = 0,
      colour = "lightgrey",
      linetype = "dashed",
      linewidth = 0.4
      ) +
    stat_halfeye(
      size = 1,
      point_interval = "median_hdi"
    ) +
    facet_grid(wording ~ .) +
    scale_x_continuous(
      name = expression(
        atop(
          "Pre-post shift in judgement (0-1 scale)",
          paste("Deontological" %<->% "Utilitarian")
        )
      ),
      limits = c(-0.15, 0.15)
    ) +
    scale_fill_manual(values = c("#E69F00", "#56B4E9")) +
    ylab("Advisor") +
    theme_classic() +
    theme(
      panel.grid = element_blank(),
      legend.position = "bottom",
      strip.background = element_blank()
      )
  # save and return
  ggsave(
    plot = out,
    file = "plots/followup_model2_judgement_shift.pdf",
    width = 6,
    height = 4
  )
  return(out)
}
