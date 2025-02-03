# function to pivot pilot data longer
pivot_pilot_data_longer <- function(pilot_data) {
  pilot_data %>%
    pivot_longer(
      cols = judgement_pre:confidence_post,
      names_pattern = "(.*)_(.*)",
      names_to = c(".value", "time")
    )
}
