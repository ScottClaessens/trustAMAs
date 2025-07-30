# function to extract posterior samples for interaction effect in model 8
extract_interaction_effect_model8 <- function(model8, pred1, pred2) {
  # get posterior samples
  post <- posterior_samples(model8)
  # return interaction effect
  post[[
    paste0(
      "b_",
      ifelse(
        pred1 == "advice",
        "adviceUtilitarian:",
        "treatmentHuman:"
        ),
      pred2
      )
    ]]
}
