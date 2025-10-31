# function to create table of pairwise contrasts across models
create_table_pairwise_contrasts <- function(model1_trustworthy,
                                            model1_blame,
                                            model1_trust_other_issues,
                                            model1_surprise,
                                            model1_humanlike) {
  # internal function to get pairwise contrasts on log-odds scale
  get_contrasts <- function(model, resp) {
    # get posterior samples
    post <- posterior_samples(model)
    # get pairwise contrasts
    tibble(
      # differences between advice type
      `AI Utilitarian vs. AI Deontological` = 
        post$b_adviceUtilitarian,
      `Human Utilitarian vs. Human Deontological` = 
        post$b_adviceUtilitarian +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # differences between advisors
      `Human Deontological vs. AI Deontological` =
        post$b_treatmentHuman,
      `Human Utilitarian vs. AI Utilitarian` =
        post$b_treatmentHuman +
        post$`b_treatmentHuman:adviceUtilitarian`,
      # interaction effect
      `Interaction effect` =
        post$`b_treatmentHuman:adviceUtilitarian`
      ) %>%
      pivot_longer(
        cols = everything(),
        names_to = "Contrast"
        ) %>%
      mutate(Contrast = factor(Contrast, levels = unique(Contrast))) %>%
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
  get_contrasts(model1_trustworthy, "Trustworthy") %>%
  left_join(get_contrasts(model1_blame, "Blame")) %>%
  left_join(get_contrasts(model1_trust_other_issues, "Trust other issues")) %>%
  left_join(get_contrasts(model1_surprise, "Surprise")) %>%
  left_join(get_contrasts(model1_humanlike, "Human-like"))
}
