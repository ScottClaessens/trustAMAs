# load packages
options(tidyverse.quiet = TRUE)
library(crew)
library(targets)
library(tarchetypes)
library(tidyverse)

# set targets options
tar_option_set(
  packages = c("brms", "forcats", "ggnewscale", "ggrepel", "kableExtra", 
               "knitr", "magick", "maps", "ordinal", "patchwork", "pdftools", 
               "readxl", "rethinking", "tidybayes", "tidyverse")
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
  # plot study overview
  tar_target(plot_overview, plot_study_overview()),
  # create table of sample characteristics
  tar_target(table_sample, create_table_sample_characteristics(data)),
  # plot sample and representativeness
  tar_target(plot_sample, plot_sample_overall(data)),
  tar_target(quotas_file, "data/quotas/quotas.csv", format = "file"),
  tar_target(quotas, read_csv(quotas_file, show_col_types = FALSE)),
  tar_target(
    plot_sample_representative,
    plot_sample_representativeness(data, quotas)
    ),
  # plot overall likerts
  tar_target(plot_likerts, plot_likerts_overall(data)),
  # plot initial judgements for each dilemma
  tar_target(plot_judgements_bike, plot_judgements_by_dilemma(data, "Bike")),
  tar_target(plot_judgements_baby, plot_judgements_by_dilemma(data, "Baby")),
  
  
  ##### Primary analyses #####
  
  
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
  tar_target(absolute_diffs2, calculate_absolute_diffs_model2(means2)),
  tar_target(plot2_judgement, plot_model2_judgement(means2)),
  tar_target(plot2_judgement_shift, plot_model2_judgement_shift(means2)),
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
  # create table of pairwise contrasts
  tar_target(
    table_pairwise_contrasts,
    create_table_pairwise_contrasts(model1_trustworthy, model1_blame, 
                                    model1_trust_other_issues, model1_surprise,
                                    model1_humanlike)
    ),
  
  
  ##### Analyses split by dilemma #####
  
  
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
    plot_means_by_dilemma,
    plot_means_overall(
      data,
      bind_rows(means3_trustworthy, means3_blame, means3_trust_other_issues, 
                means3_surprise, means3_humanlike),
      split_dilemma = TRUE
      )
    ),
  # create table of pairwise contrasts split by dilemma
  tar_target(
    table_pairwise_contrasts_by_dilemma,
    create_table_pairwise_contrasts_by_dilemma(
      model3_trustworthy, model3_blame, model3_trust_other_issues, 
      model3_surprise, model3_humanlike
      )
  ),
  # combine pre-post judgement plots
  tar_target(
    plot_judgement_combined,
    plot_judgements_combined(plot2_judgement_shift,
                             plot4_judgement_shift,
                             plot2_judgement)
    ),
  
  
  ##### Analyses controlling for own judgements #####
  
  
  # model 5 - trustworthiness controlling for own judgements
  tar_map(
    values = tibble(resp = c("trustworthy", "blame", "trust_other_issues",
                             "surprise", "humanlike")),
    tar_target(model5, fit_model5(data, resp)),
    tar_target(means5, extract_means_model5(model5, resp))
  ),
  # plot overall distributions and model means
  tar_target(
    plot_means_control_judgement,
    plot_means_overall(
      data, bind_rows(means5_trustworthy, means5_blame, 
                      means5_trust_other_issues, means5_surprise,
                      means5_humanlike),
      control_judgements = TRUE
    )
  ),
  # create table of pairwise contrasts
  tar_target(
    table_pairwise_contrasts_control_judgement,
    create_table_pairwise_contrasts(model5_trustworthy, model5_blame, 
                                    model5_trust_other_issues, model5_surprise,
                                    model5_humanlike)
  ),
  
  
  ##### Analyses testing for order effects #####
  
  
  # model 6 - trustworthiness, etc. split by order
  tar_map(
    values = tibble(resp = c("trustworthy", "blame", "trust_other_issues",
                             "surprise", "humanlike")),
    tar_target(model6, fit_model6(data, resp)),
    tar_target(loo6, loo(model6)),
    tar_target(means6, extract_means_model6(model6, resp))
  ),
  # plot overall distributions and model means split by order
  tar_target(
    plot_means_by_order,
    plot_means_overall(
      data,
      bind_rows(means6_trustworthy, means6_blame, means6_trust_other_issues, 
                means6_surprise, means6_humanlike),
      split_order = TRUE
    )
  ),
  # create table of pairwise contrasts split by order
  tar_target(
    table_pairwise_contrasts_by_order,
    create_table_pairwise_contrasts_by_order(
      model6_trustworthy, model6_blame, model6_trust_other_issues, 
      model6_surprise, model6_humanlike
    )
  ),
  
  
  ##### Individual differences in experimental effects #####
  
  
  # model 7 - trustworthiness split by demographics and AI variables
  tar_map(
    values = tibble(
      pred1 = c("advice", "advice", "treatment", "treatment"),
      pred2 = c("religiosity", "political_ideology", 
                "AI_familiarity", "AI_frequency")
      ),
    names = pred2,
    tar_target(model7, fit_model7(data, pred1, pred2)),
    tar_target(means7, extract_means_model7(model7, pred1, pred2)),
    tar_target(plot7, plot_model7(means7, pred1, pred2)),
    tar_target(
      interaction_effect,
      extract_interaction_effect_model7(model7, pred1, pred2)
      )
  ),
  tar_target(
    plot7_combined,
    plot_model7_combined(plot7_religiosity, plot7_political_ideology,
                         plot7_AI_familiarity, plot7_AI_frequency)
    ),
  
  
  ##### Cross-cultural differences in experimental effects #####
  
  
  # load cultural data
  tar_target(
    cultural_data_file,
    "data/cultural/cultural.csv",
    format = "file"
  ),
  tar_target(
    cultural_data,
    read_csv(cultural_data_file, show_col_types = FALSE)
  ),
  # load country networks
  tar_target(
    spatial_file,
    "data/country_networks/1F Population Distance.xlsx",
    format = "file"
    ),
  tar_target(
    linguistic_file,
    "data/country_networks/2F Country Distance 1pml adj.xlsx",
    format = "file"
  ),
  tar_target(spatial_network, load_country_network(spatial_file, log = TRUE)),
  tar_target(linguistic_network, load_country_network(linguistic_file)),
  # model 8 - trustworthiness split by cross-cultural variables
  tar_map(
    values = tibble(
      pred1 = c("advice", "advice", "advice", "treatment", "treatment"),
      pred2 = c("relational_mobility_latent", "tightness",
                "individualism", "AI_readiness", "AI_index")
      ),
    names = pred2,
    tar_target(model8, fit_model8(data, cultural_data, spatial_network, 
                                  linguistic_network, pred1, pred2)),
    tar_target(plot8, plot_model8(model8, data, cultural_data, pred1, pred2)),
    tar_target(
      interaction_effect,
      extract_interaction_effect_model8(model8, pred1, pred2)
    )
  ),
  tar_target(
    plot8_combined,
    plot_model8_combined(plot8_relational_mobility_latent,
                         plot8_tightness,
                         plot8_individualism,
                         plot8_AI_readiness,
                         plot8_AI_index)
    ),
  
  
  ##### Intention-to-treat analyses #####
  
  
  # model 9 - intention-to-treat analyses including comp failures
  tar_map(
    values = tibble(resp = c("trustworthy", "blame", "trust_other_issues",
                             "surprise", "humanlike")),
    tar_target(model9, fit_model1(data_full, resp)),
    tar_target(means9, extract_means_model1(model9, resp))
  ),
  # plot overall distributions and model means
  tar_target(
    plot_means_itt,
    plot_means_overall(
      data_full, bind_rows(means9_trustworthy, means9_blame, 
                           means9_trust_other_issues, means9_surprise,
                           means9_humanlike),
      itt = TRUE
    )
  ),
  # create table of pairwise contrasts
  tar_target(
    table_pairwise_contrasts_itt,
    create_table_pairwise_contrasts(model9_trustworthy, model9_blame, 
                                    model9_trust_other_issues, model9_surprise,
                                    model9_humanlike)
  ),
  
  
  ##### Judgements and confidence in first block only #####
  
  
  # model 10 - judgements and confidence, pre-post advice, first block only
  tar_target(model10, fit_model2(filter(data, order == 1))),
  tar_target(means10, extract_means_model2(model10)),
  tar_target(
    plot10_judgement_shift,
    plot_model2_judgement_shift(
      means10,
      first_block_only = TRUE
      )
    ),
  
  
  ##### Cross-cultural differences in judgement updating #####
  
  
  # model 11 - judgement updating moderated by cross-cultural variables
  tar_map(
    values = tibble(pred = c("relational_mobility_latent", "tightness",
                             "individualism", "AI_readiness", "AI_index")),
    tar_target(model11, fit_model11(data, cultural_data, spatial_network, 
                                    linguistic_network, pred)),
    tar_target(plot11, plot_model11(data, cultural_data, model11, pred)),
    tar_target(table11, extract_interaction_effects_model11(model11, pred))
  ),
  tar_target(
    table11,
    bind_rows(
      table11_relational_mobility_latent,
      table11_tightness,
      table11_individualism,
      table11_AI_readiness,
      table11_AI_index
    )
  ),
  
  
  ##### Differences in judgement updating by trustworthiness #####
  
  
  # model 12 - judgement updating moderator by trustworthiness
  tar_target(model12, fit_model12(data)),
  tar_target(plot12, plot_model12(model12)),
  
  
  ##### Prior sensitivity analysis for primary models #####
  
  
  # model 13 - main models with wider slope prior
  tar_map(
    values = tibble(resp = c("trustworthy", "blame", "trust_other_issues",
                             "surprise", "humanlike")),
    tar_target(model13, fit_model13(data, resp)),
    tar_target(means13, extract_means_model1(model13, resp))
  ),
  # plot overall distributions and model means
  tar_target(
    plot_means_prior_sensitivity,
    plot_means_overall(
      data, bind_rows(means13_trustworthy, means13_blame, 
                      means13_trust_other_issues, means13_surprise,
                      means13_humanlike),
      prior_sensitivity = TRUE
    )
  ),
  # create table of pairwise contrasts
  tar_target(
    table_pairwise_contrasts_prior_sensitivity,
    create_table_pairwise_contrasts(model13_trustworthy, model13_blame, 
                                    model13_trust_other_issues,
                                    model13_surprise,
                                    model13_humanlike)
  ),
  
  
  #### Manuscript ####
  
  
  # render manuscript
  #tar_quarto(manuscript, "quarto/manuscript/manuscript.qmd", quiet = FALSE),
  
  
  #### Session info ####
  
  
  # print session info for reproducibility
  tar_target(
    sessionInfo,
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
  
)
