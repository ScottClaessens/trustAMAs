# function to plot prior means
plot_means_prior_only <- function(means) {
  # rename advice column
  means <- rename(means, Advice = advice)
  # plot
  out <-
    ggplot() +
    # add model estimated means
    geom_pointrange(
      data = filter(means, country == "Overall"),
      aes(x = treatment, y = Estimate, ymin = Q2.5, ymax = Q97.5,
          colour = Advice),
      position = position_dodge(width = 0.75),
      size = 0.35
    ) +
    scale_colour_manual(values = c("#E69F00", "#56B4E9")) +
    scale_y_continuous(
      name = "Response",
      limits = c(1, 7),
      breaks = 1:7
    ) +
    xlab("Advisor") +
    ggtitle("Prior predictive check") +
    theme_classic()
  # save
  ggsave(
    plot = out,
    file = "plots/prior_check_ordinal.pdf",
    height = 4,
    width = 4
  )
  return(out)
}
