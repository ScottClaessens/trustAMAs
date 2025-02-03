# function to plot results from pilot model 2
plot_pilot_model2b <- function(pilot_data_long, pilot_means2) {
  # plot
  p <-
    ggplot() +
    geom_line(
      data = pilot_data_long,
      mapping = aes(
        x = fct_rev(str_to_title(time)),
        y = confidence,
        colour = advice,
        group = interaction(id, advice)
        ),
      alpha = 0.05,
      linewidth = 0.25,
      position = position_jitter(height = 0.35, width = 0, seed = 1)
      ) +
    geom_ribbon(
      data = filter(pilot_means2, resp == "confidence"),
      mapping = aes(
        x = fct_rev(str_to_title(time)),
        fill = advice,
        ymin = lower95,
        ymax = upper95,
        group = advice
      ),
      alpha = 0.5
    ) +
    geom_ribbon(
      data = filter(pilot_means2, resp == "confidence"),
      mapping = aes(
        x = fct_rev(str_to_title(time)),
        fill = advice,
        ymin = lower50,
        ymax = upper50,
        group = advice
      ),
      alpha = 0.7
    ) +
    facet_grid(
      fct_rev(paste(treatment, "advisor")) ~ paste(advice, "\nadvice")
      ) +
    scale_y_continuous(
      name = "Confidence in judgement",
      breaks = 1:7,
      limits = c(1, 7),
      oob = scales::squish
    ) +
    xlab(NULL) +
    theme_classic() +
    theme(
      panel.spacing.y = unit(1, "lines"),
      legend.position = "none",
      axis.ticks.x = element_line()
      )
  # save
  ggsave(
    plot = p,
    filename = "plots/pilot_results2b.pdf",
    width = 4,
    height = 3.5
  )
  return(p)
}
