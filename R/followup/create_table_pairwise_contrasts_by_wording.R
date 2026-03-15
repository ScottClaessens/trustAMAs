# function to create table of pairwise contrasts across models, split by wording
create_table_pairwise_contrasts_by_wording <- 
  function(followup_model1_trustworthy,
           followup_model1_blame,
           followup_model1_trust_other_issues,
           followup_model1_surprise,
           followup_model1_humanlike) {
  # internal function to get pairwise contrasts on log-odds scale
  get_contrasts <- function(model, resp) {
    # get posterior samples
    post <- posterior_samples(model)
    # get pairwise contrasts
    tibble(
      
      # original wording
      
      # differences between advice type
      `Original - AI Utilitarian vs. AI Deontological` = 
        post$b_adviceUtilitarian,
      `Original - Human Utilitarian vs. Human Deontological` = 
        post$b_adviceUtilitarian +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # differences between advisors
      `Original - Human Deontological vs. AI Deontological` =
        post$b_treatmentHuman,
      `Original - Human Utilitarian vs. AI Utilitarian` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # interaction effect
      `Original - Interaction effect` =
        post$`b_treatmentHuman:adviceUtilitarian`,
      
      # revised wording
      
      # differences between advice type
      `Revised - AI Utilitarian vs. AI Deontological` = 
        post$b_adviceUtilitarian +
        post$`b_adviceUtilitarian:wordingRevised`,
      `Revised - Human Utilitarian vs. Human Deontological` =
        post$b_adviceUtilitarian +
        post$`b_adviceUtilitarian:wordingRevised` +
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:wordingRevised`,
      # differences between advisors
      `Revised - Human Deontological vs. AI Deontological` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:wordingRevised`,
      `Revised - Human Utilitarian vs. AI Utilitarian` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:wordingRevised` +
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:wordingRevised`,
      # interaction effect
      `Revised - Interaction effect` =
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:wordingRevised`
      
      ) %>%
      pivot_longer(
        cols = everything(),
        names_to = "Contrast"
        ) %>%
      mutate(
        Contrast = factor(Contrast, levels = unique(Contrast))
        ) %>%
      group_by(Contrast) %>%
      summarise(
        {{resp}} := paste0(
          format(round(median(value), 2), nsmall = 2),
          " [",
          format(
            round(rethinking::HPDI(value, prob = 0.95)[[1]], 2),
            nsmall = 2
          ),
          ", ",
          format(
            round(rethinking::HPDI(value, prob = 0.95)[[2]], 2),
            nsmall = 2
          ),
          "]"
          )
        )
  }
  # put together
  get_contrasts(followup_model1_trustworthy, "Trustworthy") %>%
  left_join(get_contrasts(followup_model1_blame, "Blame")) %>%
  left_join(get_contrasts(followup_model1_trust_other_issues, 
                          "Trust other issues")) %>%
  left_join(get_contrasts(followup_model1_surprise, "Surprise")) %>%
  left_join(get_contrasts(followup_model1_humanlike, "Human-like"))
}
