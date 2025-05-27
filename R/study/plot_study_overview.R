# function to plot general overview of study
plot_study_overview <- function() {
  # experiment flow
  pA <-
    image_read_pdf("images/experiment_flow.pdf") %>%
    image_ggplot()
  # moral advice
  pB <-
    image_read_pdf("images/moral_advice.pdf") %>%
    image_ggplot()
  # countries in the study
  countries <- c("Brazil", "Chile", "China", "France", "Germany", "India",
                 "Mexico", "Poland", "South Africa", "Turkey", "UK", "USA")
  world_map <- 
    map_data("world") %>%
    filter(region != "Antarctica") %>%
    mutate(in_study = region %in% countries)
  labels <-
    world_map %>%
    filter(in_study) %>%
    group_by(region) %>%
    summarise(
      long = mean(long),
      lat = mean(lat)
    )
  pC <-
    ggplot(
      mapping = aes(x = long, y = lat)
    ) +
    geom_polygon(
      data = world_map,
      mapping = aes(group = group, fill = in_study)
    ) +
    geom_text_repel(
      data = labels,
      mapping = aes(label = region),
      size = 3,
      seed = 2113
      ) +
    scale_fill_manual(values = c("grey90", "#ffcccc")) +
    theme_void() +
    theme(legend.position = "none")
  # put together
  top <- pA
  bottom <- (pB | pC) + plot_layout(widths = c(0.5, 1))
  out <- 
    (top / bottom) + 
    plot_layout(heights = c(0.55, 1)) +
    plot_annotation(tag_levels = "a")
  # save and return
  ggsave(
    filename = "plots/study_overview.pdf",
    plot = out,
    height = 4,
    width = 7
  )
  return(out)
}
