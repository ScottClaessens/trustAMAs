# function to load data from main study
load_data <- function(data_file) {
  read_csv(
    file = data_file,
    col_types = cols(
      gender_text = col_character()
      )
    )
}
