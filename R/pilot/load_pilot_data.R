# function to load and clean pilot data
load_pilot_data <- function(pilot_data_file) {
  # load csv
  read_csv(pilot_data_file) %>%
    # exclude participants who failed the attention check
    filter(attention == "TikTok")
}
