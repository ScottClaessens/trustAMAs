# function to plot results of model 5
plot_model5 <- function(model5_trustworthy) {
  # get fitted values
  d <-
    expand_grid(
      treatment = c("AI", "Human"),
      advice = c("Deontological", "Utilitarian"),
      agreement = seq(0, 1, length.out = 100)
    )
  f <-
    fitted(
      object = model5_trustworthy,
      newdata = d,
      re_formula = NA,
      summary = FALSE
    )
  # calculate posterior means
  post <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:7) post <- post + (f[, , i] * i)
  # save memory
  rm(f)
  # add to data
  d <-
    d %>%
    mutate(
      post = lapply(seq_len(ncol(post)), function(i) as.numeric(post[,i]))
    ) %>%
    rowwise() %>%
    mutate(post = list(post)) %>%
    pivot_wider(
      names_from = advice,
      values_from = post
    ) %>%
    rowwise() %>%
    mutate(diff = list(Deontological - Utilitarian)) %>%
    dplyr::select(!c(Deontological, Utilitarian)) %>%
    mutate(
      Difference = mean(diff),
      Est.Error = sd(diff),
      Q2.5 = quantile(diff, 0.025),
      Q97.5 = quantile(diff, 0.975),
      sig = (Difference > 0 & Q2.5 > 0) | (Difference < 0 & Q97.5 < 0)
    )
  # save memory
  rm(post)
  # plot difference between advice types
  out <-
    ggplot(
      data = d,
      mapping = aes(x = agreement, y = Difference, ymin = Q2.5, ymax = Q97.5)
      ) +
    geom_hline(
      yintercept = 0,
      linetype = "dashed",
      linewidth = 0.3
      ) +
    geom_vline(
      xintercept = 0.5,
      linetype = "dashed",
      linewidth = 0.3
    ) +
    geom_ribbon(data = d, fill = "#F8F8F8", alpha = 0.5) +
    geom_ribbon(data = filter(d, sig), fill = "#D3D3D3", alpha = 0.5) +
    geom_line() +
    facet_wrap(. ~ treatment) +
    scale_fill_manual(values = c("#f8f8f8", "")) +
    labs(
      x = "Agreement with the advisor",
      y = paste0(
        "Trust in deontological advisor\n",
        "compared to utilitarian advisor"
        )
    ) +
    theme_classic() +
    theme(legend.position = "none")
  # save and return
  ggsave(
    plot = out,
    filename = "plots/model5_trustworthy.pdf",
    width = 6,
    height = 3
  )
  return(out)
}
