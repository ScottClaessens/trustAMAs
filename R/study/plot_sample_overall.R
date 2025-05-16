# function to plot overall sample characteristics
plot_sample_overall <- function(data_full) {
  # dataset by participant
  data_full <-
    data_full %>%
    group_by(id) %>%
    summarise(across(c(age:subjective_SES), unique))
  # age
  pA <-
    ggplot(data = data_full, mapping = aes(x = age)) +
    geom_histogram(binwidth = 1, fill = "#c3e6f5") +
    labs(x = "Age", y = "Count") +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    theme_classic()
  # gender
  pB <-
    ggplot(
      data = mutate(
        data_full,
        gender = ifelse(gender %in% c("Male", "Female"), gender, "Other")
        ),
      mapping = aes(x = gender)
      ) +
    geom_bar(fill = "#c3e6f5") +
    labs(x = "Gender", y = "Count") +
    scale_y_continuous(expand = c(0, 0)) +
    theme_classic()
  # education
  pC <-
    ggplot(data = data_full, mapping = aes(x = education)) +
    geom_bar(fill = "#c3e6f5") +
    labs(x = "Education level", y = "Count") +
    scale_x_continuous(breaks = 1:8) +
    scale_y_continuous(expand = c(0, 0)) +
    theme_classic()
  # subjective SES
  pD <-
    ggplot(data = data_full, mapping = aes(x = subjective_SES)) +
    geom_bar(fill = "#c3e6f5") +
    labs(x = "Subjective SES", y = "Count") +
    scale_x_continuous(breaks = 1:10) +
    scale_y_continuous(expand = c(0, 0)) +
    theme_classic()
  # religiosity
  pE <-
    ggplot(data = data_full, mapping = aes(x = religiosity)) +
    geom_bar(fill = "#c3e6f5") +
    labs(x = "Religiosity", y = "Count") +
    scale_x_continuous(breaks = 1:7) +
    scale_y_continuous(expand = c(0, 0)) +
    theme_classic()
  # political ideology
  pF <-
    ggplot(data = data_full, mapping = aes(x = political_ideology)) +
    geom_bar(fill = "#c3e6f5") +
    labs(x = "Political ideology", y = "Count") +
    scale_x_continuous(breaks = 1:7) +
    scale_y_continuous(expand = c(0, 0)) +
    theme_classic()
  # put together
  out <- 
    (pA + pB + pC + pD + pE + pF) +
    plot_layout(axis_titles = "collect")
  ggsave(
    plot = out,
    filename = "plots/sample_overall.pdf",
    width = 6,
    height = 4
    )
  return(out)
}
