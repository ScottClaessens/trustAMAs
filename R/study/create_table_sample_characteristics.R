# function to create table of sample characteristics
create_table_sample_characteristics <- function(data) {
  tar_read(data) %>%
    group_by(id) %>%
    summarise(across(country:AI_trustworthy, unique), .groups = "drop") %>%
    group_by(country) %>%
    summarise(
      N                             = n(),
      Female                        = sum(gender == "Female"),
      Male                          = sum(gender == "Male"),
      Other                         = sum(!(gender %in% c("Female", "Male"))),
      `Age (mean)`                  = mean(age),
      `Education level (mean, 1-8)` = mean(education),
      `Subjective SES (mean, 1-10)` = mean(subjective_SES, na.rm = TRUE)
    ) %>%
    rename(Country = country)
}
