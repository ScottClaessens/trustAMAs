# function to extract posterior samples for interaction effects in model 11
extract_interaction_effects_model11 <- function(model11, pred) {
  # predictor labels
  preds <- c(
    "relational_mobility_latent" = "Relational mobility",
    "tightness" = "Cultural tightness",
    "individualism" = "Individualism",
    "AI_readiness" = "Government AI Readiness Index",
    "AI_index" = "Global AI Index"
  )
  # get posterior samples
  post <- posterior_samples(model11)
  # get interaction effects
  int_ai_deon <- 
    post[[paste0("b_timepost:", pred)]]
  int_ai_util <- 
    post[[paste0("b_timepost:", pred)]] + 
    post[[paste0("b_timepost:adviceUtilitarian:", pred)]]
  int_human_deon <-
    post[[paste0("b_timepost:", pred)]] + 
    post[[paste0("b_timepost:treatmentHuman:", pred)]]
  int_human_util <-
    post[[paste0("b_timepost:", pred)]] + 
    post[[paste0("b_timepost:adviceUtilitarian:", pred)]] +
    post[[paste0("b_timepost:treatmentHuman:", pred)]] +
    post[[paste0("b_timepost:treatmentHuman:adviceUtilitarian:", pred)]]
  # function to produce text
  print_int <- function(int) {
    paste0(
      format(round(median(int), digits = 2), nsmall = 2),
      " [",
      format(round(quantile(int, 0.025), digits = 2), nsmall = 2),
      ", ",
      format(round(quantile(int, 0.975), digits = 2), nsmall = 2),
      "]"
    )
  }
  # put into table row
  tibble(
    Moderator             = preds[pred],
    `AI Deontological`    = print_int(int_ai_deon),
    `AI Utilitarian`      = print_int(int_ai_util),
    `Human Deontological` = print_int(int_human_deon),
    `Human Utilitarian`   = print_int(int_human_util)
  )
}
