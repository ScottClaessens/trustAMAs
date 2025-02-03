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
  # get pilot data in longer format
  tar_target(pilot_data_long, pivot_pilot_data_longer(pilot_data)),
  # fit models
  tar_target(pilot_model1, fit_pilot_model1(pilot_data)),
  tar_target(pilot_model2, fit_pilot_model2(pilot_data_long)),
  # estimated means
  tar_target(pilot_means1, extract_means_pilot_model1(pilot_model1)),
  tar_target(pilot_means2, extract_means_pilot_model2(pilot_model2)),
  # plot model results
  tar_target(pilot_plot1a, plot_pilot_model1a(pilot_data, pilot_means1)),
  tar_target(pilot_plot1b, plot_pilot_model1b(pilot_data, pilot_means1)),
  tar_target(pilot_plot2a, plot_pilot_model2a(pilot_data_long, pilot_means2)),
  tar_target(pilot_plot2b, plot_pilot_model2b(pilot_data_long, pilot_means2))
)
