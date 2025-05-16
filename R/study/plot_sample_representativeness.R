# function to plot sample representativeness
plot_sample_representativeness <- function(data_full, quotas) {
  #plot
  out <-
    data_full %>%
    group_by(id) %>%
    summarise(across(c(country, age:gender), unique)) %>%
    filter(gender %in% c("Male", "Female")) %>%
    mutate(
      age_group = "",
      age_group = ifelse(age >= 18 & age <= 24, "18-24", age_group),
      age_group = ifelse(age >= 25 & age <= 34, "25-34", age_group),
      age_group = ifelse(age >= 35 & age <= 44, "35-44", age_group),
      age_group = ifelse(age >= 45 & age <= 54, "45-54", age_group),
      age_group = ifelse(age >= 55 & age <= 64, "55-64", age_group),
      age_group = ifelse(age >= 65,             "65+",   age_group),
      # as factors
      age_group = factor(age_group, levels = c("18-24", "25-34", "35-44",
                                               "45-54", "55-64", "65+")),
      gender = factor(gender, levels = c("Female", "Male"))
    ) %>%
    group_by(country, age_group, gender, .drop = FALSE) %>%
    summarise(n = n(), .groups = "drop") %>%
    group_by(country) %>%
    mutate(prop = n / sum(n)) %>%
    left_join(quotas, by = c("country", "age_group", "gender")) %>%
    rename(Gender = gender) %>%
    ggplot(aes(x = age_group)) +
    geom_col(
      aes(y = prop, fill = Gender),
      position = position_dodge(width = 0.8),
      alpha = 0.4,
      width = 0.7
      ) +
    geom_line(
      aes(y = quota_prop, colour = Gender,
          group = paste0(country, Gender)),
      position = position_dodge(width = 0.8),
      linewidth = 0.75
      ) +
    facet_wrap( ~ country, nrow = 4) +
    xlab("Age group") +
    scale_y_continuous(
      name = "Proportion",
      expand = c(0, 0)
    ) +
    theme_classic() +
    theme(
      strip.background = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1)
      )
  # save and return
  ggsave(
    plot = out,
    filename = "plots/sample_representativeness.pdf",
    height = 5,
    width = 6
  )
  return(out)
}
