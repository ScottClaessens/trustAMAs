# function to create table of pairwise contrasts across models, split by dilemma
create_table_pairwise_contrasts_by_dilemma <- function(model3_trustworthy,
                                                       model3_blame,
                                                       model3_trust_other_issues,
                                                       model3_surprise,
                                                       model3_humanlike) {
  # internal function to get pairwise contrasts on log-odds scale
  get_contrasts <- function(model, resp) {
    # get posterior samples
    post <- posterior_samples(model)
    # get pairwise contrasts
    tibble(
      
      # baby dilemma
      
      # differences between advice type
      `Baby - AI Utilitarian vs. AI Deontological` = 
        post$b_adviceUtilitarian,
      `Baby - Human Utilitarian vs. Human Deontological` = 
        post$b_adviceUtilitarian +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # differences between advisors
      `Baby - Human Deontological vs. AI Deontological` =
        post$b_treatmentHuman,
      `Baby - Human Utilitarian vs. AI Utilitarian` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # interaction effect
      `Baby - Interaction effect` =
        post$`b_treatmentHuman:adviceUtilitarian`,
      
      # bike dilemma
      
      # differences between advice type
      `Bike - AI Utilitarian vs. AI Deontological` = 
        post$b_adviceUtilitarian +
        post$`b_adviceUtilitarian:dilemmaBike`,
      `Bike - Human Utilitarian vs. Human Deontological` =
        post$b_adviceUtilitarian +
        post$`b_adviceUtilitarian:dilemmaBike` +
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:dilemmaBike`,
      # differences between advisors
      `Bike - Human Deontological vs. AI Deontological` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:dilemmaBike`,
      `Bike - Human Utilitarian vs. AI Utilitarian` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:dilemmaBike` +
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:dilemmaBike`,
      # interaction effect
      `Bike - Interaction effect` =
        post$`b_treatmentHuman:adviceUtilitarian` +
        post$`b_treatmentHuman:adviceUtilitarian:dilemmaBike`
      
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
          format(round(quantile(value, 0.025), 2), nsmall = 2),
          ", ",
          format(round(quantile(value, 0.975), 2), nsmall = 2),
          "]"
          )
        )
  }
  # put together
  get_contrasts(model3_trustworthy, "Trustworthy") %>%
  left_join(get_contrasts(model3_blame, "Blame")) %>%
  left_join(get_contrasts(model3_trust_other_issues, "Trust other issues")) %>%
  left_join(get_contrasts(model3_surprise, "Surprise")) %>%
  left_join(get_contrasts(model3_humanlike, "Human-like")) %>%
  mutate(Contrast = str_sub(as.character(Contrast), start = 8L))
}
