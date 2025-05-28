# function to plot results of model 8
plot_model8 <- function(model8, data, cultural_data, pred1, pred2) {
  # x-axis labels
  xlabs <- c(
    "relational_mobility_latent" = "Relational mobility",
    "tightness" = "Cultural tightness",
    "individualism" = "Individualism",
    "AI_readiness" = "Government AI Readiness Index",
    "AI_index" = "Global AI Index"
  )
  # standardise cultural data
  cultural_data <- mutate(
    cultural_data,
    across(
      where(is.numeric),
      function(x) as.numeric(scale(x))
    )
  )
  # wrangle data for plot
  d <- 
    data %>%
    left_join(cultural_data, by = "country") %>%
    group_by(ISO, !!sym(pred1)) %>%
    summarise(
      trustworthy = mean(trustworthy, na.rm = TRUE),
      !!sym(pred2) := unique(!!sym(pred2))
      ) %>%
    pivot_wider(
      names_from = !!sym(pred1),
      values_from = trustworthy
    ) %>%
    mutate(
      diff = if (pred1 == "treatment") Human - AI else 
        Deontological - Utilitarian
    ) %>%
    dplyr::select(ISO, !!sym(pred2), diff)
  # new data
  newdata <- expand_grid(
    !!sym(pred1) := if (pred1 == "treatment") c("AI", "Human") else 
      c("Deontological", "Utilitarian"),
    !!sym(pred2) := seq(-1.5, 2.75, length.out = 100)
  )
  # get fitted values
  f <- fitted(
    object = model8,
    newdata = newdata,
    re_formula = NA,
    summary = FALSE
  )
  # calculate posterior means
  post <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:7) post <- post + (f[, , i] * i)
  # add posterior means to data
  newdata %>%
    mutate(
      post = lapply(seq_len(ncol(post)), function(i) as.numeric(post[,i]))
    ) %>%
    # get differences
    pivot_wider(
      names_from = !!sym(pred1),
      values_from = post
    ) %>%
    rowwise() %>%
    mutate(
      diff = if (pred1 == "treatment") list(Human - AI) else 
        list(Deontological - Utilitarian)
    ) %>%
    dplyr::select(!!sym(pred2), diff) %>%
    mutate(
      Estimate = mean(diff),
      Q2.5  = quantile(diff, 0.025),
      Q25   = quantile(diff, 0.25),
      Q75   = quantile(diff, 0.75),
      Q97.5 = quantile(diff, 0.975)
    ) %>%
    # plot
    ggplot(mapping = aes(x = !!sym(pred2))) +
    geom_point(
      data = d,
      mapping = aes(y = diff)
    ) +
    geom_text_repel(
      data = d,
      mapping = aes(y = diff, label = ISO),
      size = 2
    ) +
    geom_hline(
      yintercept = 0,
      linetype = "dashed",
      linewidth = 0.3
    ) +
    geom_ribbon(
      mapping = aes(ymin = Q2.5, ymax = Q97.5),
      fill = "#D3D3D3",
      alpha = 0.4
    ) +
    geom_ribbon(
      mapping = aes(ymin = Q25, ymax = Q75),
      fill = "#D3D3D3",
      alpha = 0.4
    ) +
    geom_line(mapping = aes(y = Estimate)) +
    scale_x_continuous(
      name = xlabs[pred2]
      ) +
    scale_y_continuous(
      name = ifelse(
        pred1 == "advice",
        "Trust in deontological advisor\ncompared to utilitarian advisor",
        "Trust in human advisor\ncompared to AI advisor"
      ),
      limits = if (pred1 == "advice") c(-1.5, 2.5) else c(-0.25, 0.8)
    ) +
    theme_classic() +
    theme(legend.position = "none")
}
