# function to combine pp check plots
plot_model1_pp_check_combined <- function(plot1_pp_check_trustworthy,
                                          plot1_pp_check_blame,
                                          plot1_pp_check_trust_other_issues,
                                          plot1_pp_check_surprise,
                                          plot1_pp_check_humanlike) {
  # put together plots
  out <- 
    plot1_pp_check_trustworthy + 
    plot1_pp_check_blame + 
    plot1_pp_check_trust_other_issues + 
    plot1_pp_check_surprise + 
    plot1_pp_check_humanlike + 
    guide_area() +
    plot_layout(
      guides = "collect", 
      axis_titles = "collect",
      nrow = 2
    )
  # save
  ggsave(
    plot = out,
    file = "plots/posterior_check_ordinal.pdf",
    height = 4,
    width = 6
  )
  return(out)
}
