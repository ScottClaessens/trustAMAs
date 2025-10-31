# function to create table of pairwise contrasts across models, split by order
create_table_pairwise_contrasts_by_order <- function(model6_trustworthy,
                                                     model6_blame,
                                                     model6_trust_other_issues,
                                                     model6_surprise,
                                                     model6_humanlike) {
  # internal function to get pairwise contrasts on log-odds scale
  get_contrasts <- function(model, resp) {
    # get posterior samples
    post <- posterior_samples(model)
    # get pairwise contrasts
    tibble(
      
      # block 1
      
      # differences between advice type
      `1 - AI Utilitarian vs. AI Deontological` = 
        post$b_adviceUtilitarian,
      `1 - Human Utilitarian vs. Human Deontological` = 
        post$b_adviceUtilitarian +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # differences between advisors
      `1 - Human Deontological vs. AI Deontological` =
        post$b_treatmentHuman,
      `1 - Human Utilitarian vs. AI Utilitarian` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # interaction effect
      `1 - Interaction effect` =
        post$`b_treatmentHuman:adviceUtilitarian`,
      
      # bike dilemma
      
      # differences between advice type
      `2 - AI Utilitarian vs. AI Deontological` = 
        post$b_adviceUtilitarian +
        post$`b_adviceUtilitarian:order2`,
      `2 - Human Utilitarian vs. Human Deontological` =
        post$b_adviceUtilitarian +
        post$`b_adviceUtilitarian:order2` +
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:order2`,
      # differences between advisors
      `2 - Human Deontological vs. AI Deontological` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:order2`,
      `2 - Human Utilitarian vs. AI Utilitarian` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:order2` +
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:order2`,
      # interaction effect
      `2 - Interaction effect` =
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:order2`
      
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
  get_contrasts(model6_trustworthy, "Trustworthy") %>%
  left_join(get_contrasts(model6_blame, "Blame")) %>%
  left_join(get_contrasts(model6_trust_other_issues, "Trust other issues")) %>%
  left_join(get_contrasts(model6_surprise, "Surprise")) %>%
  left_join(get_contrasts(model6_humanlike, "Human-like")) %>%
  mutate(Contrast = str_sub(as.character(Contrast), start = 5L))
}
