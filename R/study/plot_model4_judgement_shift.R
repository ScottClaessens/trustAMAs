# function to plot estimated shifts in judgement from model 4
plot_model4_judgement_shift <- function(means4) {
  # plot
  out <- 
    means4 %>%
    # judgements across all countries
    filter(resp == "judgement" & country == "Overall") %>%
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
    mutate(dilemma = paste0(dilemma, " dilemma")) %>%
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
    facet_grid(dilemma ~ .) +
    scale_x_continuous(
      name = expression(
        atop(
          "Pre-post shift in judgement (0-1 scale)",
          paste("Deontological" %<->% "Utilitarian")
        )
      ),
      limits = c(-0.2, 0.2)
    ) +
    scale_fill_manual(values = c("#E69F00", "#56B4E9")) +
    ylab("Advisor") +
    ggtitle("Split by dilemma") +
    theme_classic() +
    theme(
      panel.grid = element_blank(),
      legend.position = "bottom",
      strip.text = element_text(size = 8),
      strip.background = element_blank()
      )
  # save and return
  ggsave(
    plot = out,
    file = "plots/model4_judgement_shift.pdf",
    width = 6,
    height = 4
  )
  return(out)
}
