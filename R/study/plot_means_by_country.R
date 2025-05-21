# function to plot means by country
plot_means_by_country <- function(data, means, response) {
  # rename advice column
  data <- rename(data, Advice = advice)
  means <- rename(means, Advice = advice)
  # y-axis labels
  ylabs <- c(
    "trustworthy" = "Trustworthy",
    "blame" = "Blame",
    "trust_other_issues" = "Trust on other issues",
    "surprise" = "Surprise"
  )
  # plot
  out <-
    ggplot() +
    # add boxplots
    geom_boxplot(
      data = data,
      aes(x = treatment, y = !!sym(response), colour = Advice, fill = Advice),
      show.legend = FALSE
    ) +
    # full opaque colours: orange = #E69F00, blue = #56B4E9
    scale_colour_manual(values = c("#FFE5AB", "#CCE8F8")) +
    scale_fill_manual(values = c("#FFF6E3", "#EEF7FD")) +
    new_scale_colour() +
    # add model estimated means
    geom_pointrange(
      data = filter(means, resp == response & country != "Overall"),
      aes(x = treatment, y = Estimate, ymin = Q2.5, ymax = Q97.5,
          colour = Advice),
      position = position_dodge(width = 0.75),
      size = 0.1
    ) +
    scale_colour_manual(values = c("#E69F00", "#56B4E9")) +
    scale_y_continuous(
      name = ifelse(response == "humanlike", 
                    expression("Machine-like" %<->% "Human-like"), 
                    ylabs[response]),
      limits = c(1, 7),
      breaks = 1:7
    ) +
    facet_wrap(. ~ country) +
    xlab("Advisor") +
    theme_classic() +
    theme(strip.background = element_blank())
  # save and return
  ggsave(
    plot = out,
    file = paste0("plots/means_by_country_", response, ".pdf"),
    height = 5,
    width = 6.5
  )
  return(out)
}
