# function to extract posterior samples for interaction effect in model 7
extract_interaction_effect_model7 <- function(model7, pred1, pred2) {
  # get posterior samples
  post <- posterior_samples(model7)
  # return interaction effect
  post[[
    paste0(
      "bsp_mo",
      pred2,
      ifelse(
        pred1 == "advice",
        ":adviceUtilitarian",
        ":treatmentHuman"
        )
      )
    ]]
}
