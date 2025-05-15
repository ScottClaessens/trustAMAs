# function to plot likerts overall
plot_likerts_overall <- function(data) {
  # internal plotting function
  plot_fun <- function(resp, title) {
    # get percentages for each likert level
    d <-
      data %>%
      group_by(treatment, advice, !!sym(resp)) %>%
      summarise(n = n(), .groups = "drop_last") %>%
      drop_na() %>%
      mutate(percent = n / sum(n))
    # plot diverging stack bar chart
    ggplot(
      data = d,
      aes(x = advice, y = percent, fill = ordered(!!sym(resp)))
      ) +
      geom_col(
        data = filter(d, !!sym(resp) %in% 1:4),
        aes(y = ifelse(!!sym(resp) == 4, -percent / 2, -percent))
      ) +
      geom_col(
        data = filter(d, !!sym(resp) %in% 4:7),
        aes(y = ifelse(!!sym(resp) == 4, percent / 2, percent)),
        position = position_stack(reverse = TRUE)
      ) +
      geom_hline(
        yintercept = 0,
        colour = "white",
        linewidth = 0.5
      ) +
      coord_flip() +
      scale_y_continuous(
        name = NULL,
        limits = c(-0.75, 0.75),
        labels = function(x) paste0(round(abs(x) * 100), "%")
      ) +
      facet_grid(
        treatment ~ .,
        switch = "y"
      ) +
      labs(subtitle = title) +
      theme_minimal() +
      theme(
        axis.title.y = element_blank(),
        legend.title = element_blank(),
        strip.placement = "outside"
      )
  }
  # plot for each outcome
  pA <- plot_fun("trustworthy", "\nHow trustworthy do you\nthink the advisor is?")
  pB <- plot_fun("blame", paste0("How much would you blame\nsomeone if they ",
                                 "followed\nthe advisor's recommendation?"))
  pC <- plot_fun("trust_other_issues", paste0("How willing would you be to ",
                                              "trust\nthe advisor on other ",
                                              "issues?"))
  pD <- plot_fun("surprise", paste0("How surprised were you at\nthe advisor's ",
                                    "recommendation?"))
  # put together
  out <- 
    (pA + pB) / (pC + pD) + 
    plot_layout(guides = "collect") &
    theme(
      legend.key.size = unit(0.4, "cm"),
      legend.box.margin = margin(c(0, 0, 0, 20))
      )
  # save and return
  ggsave(
    plot = out,
    file = "plots/overall_likerts.pdf",
    width = 7.5,
    height = 5
  )
  return(out)
}
