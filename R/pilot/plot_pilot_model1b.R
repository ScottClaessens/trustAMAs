# function to plot results from pilot model 1
plot_pilot_model1b <- function(pilot_data, pilot_means1) {
  # response variables in order
  resps <- c(
    "humanlike" = "Machine-like <-----> Human-like",
    "cold"      = "Warm <-----> Cold",
    "illogical" = "Rational <-----> Illogical"
  )
  # wrangle data
  pilot_means1 <- 
    filter(pilot_means1, resp %in% names(resps)) %>%
    mutate(resp = factor(resps[resp], levels = resps)) %>%
    dplyr::select(!c(treatment))
  pilot_data <-
    pilot_data %>%
    dplyr::select(advice, humanlike:illogical) %>%
    drop_na() %>%
    pivot_longer(cols = humanlike:illogical, names_to = "resp") %>%
    mutate(resp = factor(resps[resp], levels = resps))
  # plot
  p <-
    ggplot() +
    geom_point(
      data = pilot_data,
      mapping = aes(
        x = advice,
        y = value,
        colour = advice
      ),
      position = position_jitter(
        height = 0.4,
        width = 0.3
        ),
      alpha = 0.1,
      size = 0.2
    ) +
    geom_pointrange(
      data = pilot_means1,
      mapping = aes(
        x = advice,
        y = estimate,
        ymin = lower,
        ymax = upper,
        colour = advice
      ),
      size = 0.3
    ) +
    facet_wrap(
      . ~ resp,
      scales = "free",
      strip.position = "left"
      ) +
    scale_y_continuous(
      name = NULL,
      limits = c(1, 7),
      breaks = 1:7,
      oob = scales::squish
    ) +
    xlab(NULL) +
    ggtitle("AI condition only (n = 189)") +
    theme_classic() +
    theme(
      strip.background = element_blank(),
      strip.placement = "outside",
      legend.position = "none"
      )
  # save
  ggsave(
    plot = p,
    filename = "plots/pilot_results1b.pdf",
    width = 6.5,
    height = 3
  )
  return(p)
}
