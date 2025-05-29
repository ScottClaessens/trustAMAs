# function to plot pre-post judgements overall and split by dilemma
plot_judgements_combined <- function(plot2_judgement_shift,
                                     plot4_judgement_shift,
                                     plot2_judgement) {
  # create left-hand side 
  left <- 
    (plot2_judgement_shift / plot4_judgement_shift) +
    plot_layout(
      heights = c(0.5, 1),
      guides = "collect",
      axes = "collect_x"
      ) & 
    theme(
      legend.position = "bottom",
      axis.text.x = element_text(size = 8),
      axis.title.y = element_text(margin = margin(r = 5))
      )
  # create right-hand side
  right <- 
    plot2_judgement +
    theme(axis.title.y = element_text(margin = margin(r = 7)))
  # combine plots
  out <-
    (free(left, type = "space", side = "t") | right) +
    plot_layout(widths = c(0.6, 1)) +
    plot_annotation(tag_levels = "a")
  # save and return
  ggsave(
    plot = out,
    filename = "plots/judgement_shift_combined.pdf",
    width = 9.5,
    height = 5
  )
  return(out)
}
