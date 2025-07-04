# function to plot estimated shifts in judgement from model 2
plot_model2_judgement_shift <- function(means2, first_block_only = FALSE) {
  # plot
  out <- 
    means2 %>%
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
    # plot
    ggplot(mapping = aes(x = diff, y = treatment, fill = Advice)) +
    geom_vline(
      xintercept = 0,
      colour = "lightgrey",
      linetype = "dashed",
      linewidth = 0.4
      ) +
    stat_halfeye(size = 1) +
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
    ggtitle("Overall") +
    theme_classic() +
    theme(
      panel.grid = element_blank(),
      legend.position = "bottom"
      )
  # save and return
  ggsave(
    plot = out,
    file = paste0(
      "plots/model",
      ifelse(first_block_only, "10", "2"),
      "_judgement_shift.pdf"
      ),
    width = 6,
    height = 3
  )
  return(out)
}
