# produce a table of model comparison statistics when splitting by dilemma
create_table_model_comparison_dilemma <- 
  function(loo1_trustworthy, loo1_blame, loo1_trust_other_issues, loo1_surprise,
           loo1_humanlike, loo2, loo3_trustworthy, loo3_blame,
           loo3_trust_other_issues, loo3_surprise, loo3_humanlike, loo4) {
    # model comparisons
    trustworthy <- loo_compare(loo1_trustworthy,        loo3_trustworthy)
    blame       <- loo_compare(loo1_blame,              loo3_blame)
    trust_other <- loo_compare(loo1_trust_other_issues, loo3_trust_other_issues)
    surprise    <- loo_compare(loo1_surprise,           loo3_surprise)
    humanlike   <- loo_compare(loo1_humanlike,          loo3_humanlike)
    judgement   <- loo_compare(loo2, loo4)
    # create table
    tribble(
      ~Model,                     ~`ELPD difference`, ~`Standard error`,
      "Trustworthy",              trustworthy[2,1],   trustworthy[2,2],
      "Blame",                    blame[2,1],         blame[2,2],
      "Trust other issues",       trust_other[2,1],   trust_other[2,2],
      "Surprise",                 surprise[2,1],      surprise[2,2],
      "Humanlike",                humanlike[2,1],     humanlike[2,2],
      "Judgement and confidence", judgement[2,1],     judgement[2,2]
    )
  }
