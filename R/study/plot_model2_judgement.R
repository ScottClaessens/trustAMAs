# plot results from model 2 - judgements
plot_model2_judgement <- function(means2) {
  means2 <-
    means2 %>%
    # judgement means only
    filter(resp == "judgement") %>%
    # group by pre-post pair
    mutate(group = as.integer(factor(paste0(country, treatment, advice)))) %>%
    # rename advice
    rename(Advice = advice) %>%
    # edit treatment label
    mutate(treatment = paste(treatment, "Advisor"))
  # plot
  out <-
    ggplot(
      mapping = aes(
        y = Estimate,
        x = fct_relevel(fct_reorder(country, Estimate), "Overall", after = 0),
        colour = Advice,
        group = group
      )
    ) +
    geom_hline(
      yintercept = 0.5,
      linetype = "dashed",
      colour = "lightgrey",
      linewidth = 0.25
    ) +
    geom_point(
      data = filter(means2, time == "pre"),
      mapping = aes(colour = Advice),
      position = position_dodge(width = 0.6),
      size = 1,
      show.legend = FALSE
      ) +
    geom_line(
      data = means2,
      mapping = aes(colour = Advice),
      position = position_dodge(width = 0.6),
      arrow = arrow(length = unit(0.15, "cm")),
      linewidth = 0.5
      ) +
    facet_wrap(. ~ treatment) +
    xlab("Country") +
    scale_x_discrete(
      name = NULL,
      labels = function(x) ifelse(x == "Overall", "**Overall**", x)
    ) +
    scale_y_continuous(
      name = expression("Deontological Judgement" %<->% "Utilitarian Judgement"),
      limits = c(0, 1)
    ) +
    scale_colour_manual(values = c("#E69F00", "#56B4E9")) +
    coord_flip() +
    theme_classic() +
    theme(
      axis.text.x = element_text(size = 8),
      axis.text.y = ggtext::element_markdown(),
      legend.position = "bottom"
      )
  # save and return
  ggsave(
    plot = out,
    file = "plots/model2_judgement.pdf",
    width = 6,
    height = 4
  )
  return(out)
}
