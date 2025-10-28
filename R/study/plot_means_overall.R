# function to plot overall distributions and model means
plot_means_overall <- function(data, means, split_dilemma = FALSE,
                               split_order = FALSE, itt = FALSE,
                               control_judgements = FALSE,
                               prior_sensitivity = FALSE) {
  # internal plotting function
  plot_fun <- function(response) {
    # rename advice column
    data <- rename(data, Advice = advice)
    means <- rename(means, Advice = advice)
    # if splitting by order, edit order variable
    if (split_order) {
      data <- mutate(data, order = paste0("Block ", order))
      means <- mutate(means, order = paste0("Block ", order))
    }
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
        data = filter(means, resp == response & country == "Overall"),
        aes(x = treatment, y = Estimate, ymin = Q2.5, ymax = Q97.5,
            colour = Advice),
        position = position_dodge(width = 0.75),
        size = 0.35
      ) +
      scale_colour_manual(values = c("#E69F00", "#56B4E9")) +
      scale_y_continuous(
        name = ifelse(response == "humanlike", 
                      expression("Machine-like" %<->% "Human-like"), 
                      ylabs[response]),
        limits = c(1, 7),
        breaks = 1:7
      ) +
      xlab("Advisor") +
      theme_classic()
    # split by dilemma or order?
    if (split_dilemma) {
      out <- 
        out + 
        facet_wrap(. ~ dilemma) +
        theme(strip.background = element_blank())
    } else if (split_order) {
      out <- 
        out + 
        facet_wrap(. ~ order) +
        theme(strip.background = element_blank())
    }
    # if human-like
    if (response == "humanlike") {
      out <- out + theme(axis.title.y = element_text(size = 9))
    }
    return(out)
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
  # save and return
  ggsave(
    plot = out,
    file = paste0(
      "plots/overall_means",
      ifelse(split_dilemma, "_by_dilemma", ""),
      ifelse(split_order, "_by_order", ""),
      ifelse(itt, "_itt", ""),
      ifelse(control_judgements, "_control_judgements", ""),
      ifelse(prior_sensitivity, "_prior_sensitivity", ""),
      ".pdf"
      ),
    height = 5,
    width = 7
  )
  return(out)
}
