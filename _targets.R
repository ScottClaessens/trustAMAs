library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("ordinal", "rethinking", "tidyverse")
)
tar_source()

list(
  
  #### Power analysis ####
  
  # power ids
  tar_target(power_id, 1:100),
  # power with mixed design
  tar_target(power_mixed, run_power_analysis_mixed(power_id, n = 400),
             pattern = map(power_id)),
  # power with fully-between design
  tar_target(power_between, run_power_analysis_between(power_id, n = 400),
             pattern = map(power_id))
  
)
