# plot results from model 3
plot_model3 <- function(model3, resp, dilemma) {
  # extract fixed and random effects
  post <-
    model3 %>%
    spread_draws(
      # fixed effects
      b_treatmentHuman,
      b_adviceUtilitarian,
      b_dilemmaBike,
      `b_treatmentHuman:adviceUtilitarian`,
      `b_treatmentHuman:dilemmaBike`,
      `b_adviceUtilitarian:dilemmaBike`,
      `b_treatmentHuman:adviceUtilitarian:dilemmaBike`,
      # random effects
      r_country[country, parameter]
      ) %>%
    filter(parameter != "Intercept") %>%
    pivot_wider(
      names_from = parameter,
      values_from = r_country
    ) %>%
    # add "overall" rows for plotting
    bind_rows(
      spread_draws(
        model3,
        b_treatmentHuman,
        b_adviceUtilitarian,
        b_dilemmaBike,
        `b_treatmentHuman:adviceUtilitarian`,
        `b_treatmentHuman:dilemmaBike`,
        `b_adviceUtilitarian:dilemmaBike`,
        `b_treatmentHuman:adviceUtilitarian:dilemmaBike`,
        ) %>%
        mutate(
          country = "Overall",
          treatmentHuman = 0,
          adviceUtilitarian = 0,
          dilemmaBike = 0,
          `treatmentHuman:adviceUtilitarian` = 0,
          `treatmentHuman:dilemmaBike` = 0,
          `adviceUtilitarian:dilemmaBike` = 0,
          `treatmentHuman:adviceUtilitarian:dilemmaBike` = 0
          )
      )
  # combine fixed and random effects, depending on dilemma
  if (dilemma == "Baby") {
    post <-
      post %>%
      mutate(
        adviceUtilitarian = 
          b_adviceUtilitarian + 
          adviceUtilitarian,
        treatmentHuman = 
          b_treatmentHuman + 
          treatmentHuman,
        `treatmentHuman:adviceUtilitarian` =
          `b_treatmentHuman:adviceUtilitarian` +
          `treatmentHuman:adviceUtilitarian`
      )
  } else if (dilemma == "Bike") {
    post <-
      post %>%
      mutate(
        adviceUtilitarian = 
          b_adviceUtilitarian + 
          `b_adviceUtilitarian:dilemmaBike` + 
          adviceUtilitarian +
          `adviceUtilitarian:dilemmaBike`,
        treatmentHuman = 
          b_treatmentHuman +
          `b_treatmentHuman:dilemmaBike` +
          treatmentHuman +
          `treatmentHuman:dilemmaBike`,
        `treatmentHuman:adviceUtilitarian` =
          `b_treatmentHuman:adviceUtilitarian` +
          `b_treatmentHuman:adviceUtilitarian:dilemmaBike` +
          `treatmentHuman:adviceUtilitarian` +
          `treatmentHuman:adviceUtilitarian:dilemmaBike`
      )
  }
  # function for plotting results
  plot_fun <- function(post, par) {
    # reorder countries
    country_order <-
      post %>%
      filter(country != "Overall") %>%
      group_by(country) %>%
      summarise(mean = mean(!!sym(par))) %>%
      arrange(mean) %>%
      pull(country) %>%
      str_replace(fixed("."), " ")
    # construct x-axis labels
    xlabs <- c(
      "adviceUtilitarian" = "Main effect of utilitarian advice",
      "treatmentHuman" = "Main effect of human advisor",
      "treatmentHuman:adviceUtilitarian" = "Interaction effect"
    )
    # plot
    suppressWarnings(
      post %>%
        mutate(
          country = str_replace(country, fixed("."), " "),
          country = factor(country, levels = c("Overall", country_order))
        ) %>%
        ggplot(
          mapping = aes(
            x = !!sym(par),
            y = country,
            colour = country == "Overall",
            fill = country == "Overall"
          )
        ) +
        stat_halfeye(
          height = 0.85,
          size = 2,
          .width = 0.95
          ) +
        geom_vline(
          xintercept = 0,
          linetype = "dashed",
          linewidth = 0.4
        ) +
        scale_color_manual(
          values = c("black", "red")
        ) +
        scale_fill_manual(
          values = c("#cccccc", "#ffcccc")
        ) +
        ylab(NULL) +
        scale_x_continuous(
          name = xlabs[par],
          limits = c(-2.5, 2.5)
        ) +
        theme_classic() +
        theme(
          legend.position = "none",
          axis.text.y = element_text(
            colour = c("red", rep("black", 12))
          )
        )
    )
  }
  # get plots
  pA <- plot_fun(post, par = "treatmentHuman")
  pB <- plot_fun(post, par = "adviceUtilitarian")
  pC <- plot_fun(post, par = "treatmentHuman:adviceUtilitarian")
  # titles for combined plot
  titles <- c(
    "trustworthy" = "How trustworthy do you think this advisor is?",
    "blame" = paste0("How much would you blame someone if ",
                     "they followed the advisor's recommendation?"),
    "trust_other_issues" = paste0("How willing would you be to trust ",
                                  "the advisor on other issues?"),
    "surprise" = "How surprised were you at the advisor's recommendation?",
    "humanlike" = "How humanlike do you think the advisor is?"
  )
  # put together
  out <-
    (pA + pB + pC) + 
    plot_annotation(
      title = paste0(titles[resp], " - ", dilemma, " dilemma only")
      )
  # save
  ggsave(
    plot = out,
    file = paste0("plots/model3_", resp, "_", dilemma, ".pdf"),
    width = 9,
    height = 4
  )
  return(out)
}
