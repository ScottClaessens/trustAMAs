# load packages
options(tidyverse.quiet = TRUE)
library(targets)
library(tarchetypes)
library(tidyverse)

# set targets options
tar_option_set(
  packages = c("brms", "ggnewscale", "ordinal", "patchwork", "rethinking", 
               "tidybayes", "tidyverse")
  )
tar_source()

# pipeline
list(
  
  #### Pilot study ####
  
  # power analysis ids
  tar_target(power_id, 1:100),
  # power with mixed design
  tar_target(power_mixed, run_power_analysis_mixed(power_id, n = 500),
             pattern = map(power_id)),
  # power with fully-between design
  tar_target(power_between, run_power_analysis_between(power_id, n = 500),
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
  tar_target(pilot_plot2b, plot_pilot_model2b(pilot_data_long, pilot_means2)),
  
  #### Main study ####
  
  # load full dataset
  tar_target(data_file, "data/study/trustAMAs_data_clean.csv",
             format = "file"),
  tar_target(data_full, load_data(data_file)),
  # exclude comprehension failures
  tar_target(data, filter(data_full, comprehension_check == "Correct")),
  # plot overall likerts
  tar_target(plot_likerts, plot_likerts_overall(data)),
  # plot initial judgements for each dilemma
  tar_target(plot_judgements_bike, plot_judgements_by_dilemma(data, "Bike")),
  tar_target(plot_judgements_baby, plot_judgements_by_dilemma(data, "Baby")),
  
  ### primary analyses
  
  # model 1 - trustworthiness, etc.
  tar_map(
    values = tibble(resp = c("trustworthy", "blame", "trust_other_issues",
                             "surprise", "humanlike")),
    tar_target(model1, fit_model1(data, resp)),
    tar_target(loo1, loo(model1)),
    tar_target(means1, extract_means_model1(model1, resp)),
    tar_target(plot1, plot_model1(model1, resp)),
    tar_target(plot1_by_country, plot_means_by_country(data, means1, resp))
    ),
  # model 2 - judgements and confidence, pre-post advice
  tar_target(model2, fit_model2(data)),
  tar_target(loo2, loo(model2)),
  tar_target(means2, extract_means_model2(model2)),
  tar_target(plot2_judgement, plot_model2_judgement(means2)),
  tar_target(plot2_confidence, plot_model2_confidence(means2)),
  # plot overall distributions and model means
  tar_target(
    plot_means,
    plot_means_overall(
      data, bind_rows(means1_trustworthy, means1_blame, 
                      means1_trust_other_issues, means1_surprise,
                      means1_humanlike)
      )
    ),
  
  ### analyses split by dilemma
  
  # model 3 - trustworthiness, etc. split by dilemma
  tar_map(
    values = tibble(resp = c("trustworthy", "blame", "trust_other_issues",
                             "surprise", "humanlike")),
    tar_target(model3, fit_model3(data, resp)),
    tar_target(loo3, loo(model3)),
    tar_target(means3, extract_means_model3(model3, resp)),
    tar_target(plot3_bike, plot_model3(model3, resp, "Bike")),
    tar_target(plot3_baby, plot_model3(model3, resp, "Baby"))
  ),
  # model 4 - judgements and confidence, pre-post advice, split by dilemma
  tar_target(model4, fit_model4(data)),
  tar_target(loo4, loo(model4)),
  tar_target(means4, extract_means_model4(model4)),
  tar_target(plot4_judgement_bike, plot_model4_judgement(means4, "Bike")),
  tar_target(plot4_judgement_baby, plot_model4_judgement(means4, "Baby")),
  tar_target(plot4_judgement_shift, plot_model4_judgement_shift(means4)),
  tar_target(plot4_confidence_bike, plot_model4_confidence(means4, "Bike")),
  tar_target(plot4_confidence_baby, plot_model4_confidence(means4, "Baby")),
  # table of loo model comparisons when splitting by dilemma
  tar_target(
    table_model_comparison_dilemma,
    create_table_model_comparison_dilemma(
      loo1_trustworthy, loo1_blame, loo1_trust_other_issues, loo1_surprise,
      loo1_humanlike, loo2, loo3_trustworthy, loo3_blame, 
      loo3_trust_other_issues, loo3_surprise, loo3_humanlike, loo4
      )
    ),
  # plot overall distributions and model means split by dilemma
  tar_target(
    plot_means_bike,
    plot_means_overall(
      data,
      bind_rows(means3_trustworthy, means3_blame, means3_trust_other_issues, 
                means3_surprise, means3_humanlike),
      split_dilemma = "Bike"
      )
    ),
  tar_target(
    plot_means_baby,
    plot_means_overall(
      data,
      bind_rows(means3_trustworthy, means3_blame, means3_trust_other_issues,
                means3_surprise, means3_humanlike),
      split_dilemma = "Baby"
      )
    )
)
