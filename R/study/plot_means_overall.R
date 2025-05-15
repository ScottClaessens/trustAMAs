# function to plot overall distributions and model means
plot_means_overall <- function(data, means, split_dilemma = NULL) {
  # split by dilemma if specified
  if (!is.null(split_dilemma)) {
    data <- filter(data, dilemma == split_dilemma)
    means <- filter(means, dilemma == split_dilemma)
  }
  # internal plotting function
  plot_fun <- function(response) {
    # rename advice column
    data <- rename(data, Advice = advice)
    means <- rename(means, Advice = advice)
    # y-axis labels
    ylabs <- c(
      "trustworthy" = "Trustworthy",
      "blame" = "Blame",
      "trust_other_issues" = "Trust on other issues",
      "surprise" = "Surprise",
      "humanlike" = "Human-like"
    )
    # return plot
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
        data = filter(means, resp == response & country == "Overall"),
        aes(x = treatment, y = Estimate, ymin = Q2.5, ymax = Q97.5,
            colour = Advice),
        position = position_dodge(width = 0.75),
        size = 0.35
      ) +
      scale_colour_manual(values = c("#E69F00", "#56B4E9")) +
      scale_y_continuous(
        name = ylabs[response],
        limits = c(1, 7),
        breaks = 1:7
      ) +
      xlab("Advisor") +
      theme_classic()
  }
  # get plots
  pA <- plot_fun("trustworthy")
  pB <- plot_fun("blame")
  pC <- plot_fun("trust_other_issues")
  pD <- plot_fun("surprise")
  pE <- plot_fun("humanlike")
  # put together
  out <- 
    pA + pB + pC + pD + pE + guide_area() +
    plot_layout(
      guides = "collect", 
      axis_titles = "collect",
      nrow = 2
      )
  # if split by dilemma, add explanatory title
  if (!is.null(split_dilemma)) {
    out <- out + plot_annotation(title = paste0(split_dilemma, " dilemma only"))
  }
  # save and return
  ggsave(
    plot = out,
    file = paste0(
      "plots/overall_means",
      ifelse(is.null(split_dilemma), "", "_"),
      split_dilemma,
      ".pdf"
      ),
    height = 5,
    width = 7
  )
  return(out)
}
