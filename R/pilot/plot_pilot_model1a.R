# function to plot results from pilot model 1
plot_pilot_model1a <- function(pilot_data, pilot_means1) {
  # response variables in order
  resps <- c(
    "trustworthy"      = "Trustworthy",
    "blame"            = "Blame",
    "trustotherissues" = "Trust other issues",
    "surprise"         = "Surprise"
  )
  # wrangle data
  pilot_means1 <- 
    filter(pilot_means1, resp %in% names(resps)) %>%
    mutate(resp = factor(resps[resp], levels = resps))
  pilot_data <-
    pilot_data %>%
    dplyr::select(treatment, advice, trustworthy:surprise) %>%
    rename(trustotherissues = trust_other_issues) %>%
    pivot_longer(cols = trustworthy:surprise, names_to = "resp") %>%
    mutate(resp = factor(resps[resp], levels = resps))
  # plot
  p <-
    ggplot() +
    geom_point(
      data = pilot_data,
      mapping = aes(
        x = fct_rev(treatment),
        y = value,
        colour = paste(advice, "advice")
      ),
      position = position_jitterdodge(
        jitter.height = 0.4,
        jitter.width = 0.3,
        dodge.width = 0.8
        ),
      alpha = 0.1,
      size = 0.2,
      show.legend = FALSE
    ) +
    geom_pointrange(
      data = pilot_means1,
      mapping = aes(
        x = fct_rev(treatment),
        y = estimate,
        ymin = lower,
        ymax = upper,
        colour = paste(advice, "advice")
      ),
      position = position_dodge(width = 0.8),
      size = 0.3,
      show.legend = TRUE
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
    guides(colour = guide_legend(byrow = TRUE)) +
    theme_classic() +
    theme(
      strip.background = element_blank(),
      strip.placement = "outside",
      legend.title = element_blank(),
      legend.position = "bottom"
      )
  # save
  ggsave(
    plot = p,
    filename = "plots/pilot_results1a.pdf",
    width = 4,
    height = 4
  )
  return(p)
}
