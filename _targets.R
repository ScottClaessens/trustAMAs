library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("brms", "ordinal", "rethinking", "tidyverse")
)
tar_source()

list(
  
  #### Pilot study ####
  
  # power analysis ids
  tar_target(power_id, 1:100),
  # power with mixed design
  tar_target(power_mixed, run_power_analysis_mixed(power_id, n = 400),
             pattern = map(power_id)),
  # power with fully-between design
  tar_target(power_between, run_power_analysis_between(power_id, n = 400),
             pattern = map(power_id)),
  # load pilot data
  tar_target(pilot_data_file, "data/pilot/pilot_data_clean.csv",
             format = "file"),
  tar_target(pilot_data, load_pilot_data(pilot_data_file)),
  # fit models
  tar_target(pilot_model1, fit_pilot_model1(pilot_data)),
  # estimated means
  tar_target(pilot_means1, extract_means_pilot_model1(pilot_model1)),
  # plot model results
  tar_target(pilot_plot1, plot_pilot_model1a(pilot_data, pilot_means1))
)
