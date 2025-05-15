# function to plot initial judgements by dilemma
plot_judgements_by_dilemma <- function(data, split_dilemma) {
  # plot
  out <-
    data %>%
    filter(dilemma == split_dilemma) %>%
    ggplot(
      mapping = aes(x = judgement_pre),
      alpha = 0.5
      ) +
    geom_histogram(bins = 11) +
    facet_wrap(. ~ country) +
    scale_x_continuous(
      name = expression("Deontological Judgement" %<->% "Utilitarian Judgement"),
      breaks = c(0, 0.5, 1)
    ) +
    ylab("Count") +
    ggtitle(paste0("Initial judgements for the ", split_dilemma, " dilemma")) +
    theme(panel.grid = element_blank())
  # save and return
  ggsave(
    plot = out,
    filename = paste0("plots/initial_judgements_", split_dilemma, ".pdf"),
    width = 7,
    height = 5
  )
  return(out)
}
