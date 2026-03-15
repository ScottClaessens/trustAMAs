# function to load and clean data from follow-up study
load_followup_data <- function(followup_data_file) {
  # load csv
  read_csv(followup_data_file) %>%
    # exclude participants who failed the attention checks
    filter(attention1 == "TikTok" & attention2 == "No")
}
