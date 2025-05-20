# function to plot estimated shifts in judgement from model 2
plot_model2_judgement_shift <- function(means2) {
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
    geom_vline(xintercept = 0, colour = "white", linetype = "dashed") +
    stat_halfeye() +
    scale_x_continuous(
      name = expression(
        atop(
          "Pre-post shift in judgement after seeing advice (0-1 scale)",
          paste("Deontological" %<->% "Utilitarian")
        )
      ),
      limits = c(-0.2, 0.2)
    ) +
    scale_fill_manual(values = c("#E69F00", "#56B4E9")) +
    ylab("Advisor") +
    theme(
      panel.grid = element_blank(),
      axis.ticks = element_blank()
      )
  # save and return
  ggsave(
    plot = out,
    file = "plots/model2_judgement_shift.pdf",
    width = 7,
    height = 2.5
  )
  return(out)
}
