# function to create table of sample characteristics
create_table_sample_characteristics <- function(data) {
  # internal function to format counts and percentages
  print_percent <- function(variable, overall_n) {
    paste0(
      variable,
      " (",
      format(round((variable / overall_n) * 100, 0), nsmall = 0),
      "%)"
    )
  }
  # internal function to format mean and sd
  print_mean_sd <- function(variable, ndigits = 1) {
    if (is.na(mean(variable, na.rm = TRUE))) {
      "-"
    } else {
      paste0(
        format(round(mean(variable, na.rm = TRUE), ndigits), nsmall = ndigits),
        " (",
        format(round(sd(variable, na.rm = TRUE), ndigits), nsmall = ndigits),
        ")"
      )
    }
  }
  # create table
  data %>%
    group_by(id) %>%
    summarise(across(country:AI_trustworthy, unique), .groups = "drop") %>%
    group_by(country) %>%
    summarise(
      `Overall N`                = as.character(n()),
      Female                     = print_percent(sum(gender == "Female"), n()),
      Male                       = print_percent(sum(gender == "Male"), n()),
      Age                        = print_mean_sd(age),
      `Education (1-8)`          = print_mean_sd(education),
      `SES (1-10)`               = print_mean_sd(subjective_SES),
      `Religiosity (1-7)`        = print_mean_sd(religiosity),
      `Political ideology (1-7)` = print_mean_sd(political_ideology)
    ) %>%
    rename(Country = country)
}
