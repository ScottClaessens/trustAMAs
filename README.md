# Trust in Artificial Moral Advisors Across Cultures

## Getting Started

### Installing

To run this code, you will need to [install R](https://www.r-project.org/) and 
the following R packages:

```r
install.packages(
  c("brms", "crew", "forcats", "ggnewscale", "ggrepel", "kableExtra",
    "knitr", "magick", "maps", "ordinal", "patchwork", "pdftools",
    "readxl", "tarchetypes", "targets", "tidybayes", "tidyverse")
)
```

You must also install the `rethinking` package following the instructions 
[here](https://github.com/rmcelreath/rethinking).

### Executing code

1. Clone this repository to your local machine
2. Open the R Project file `trustAMAs.Rproj`
4. In the console, run the analysis pipeline with `targets::tar_make()`
5. To load individual targets into your environment, run 
`targets::tar_load(targetName)`

## Help

Any issues, please email scott.claessens@gmail.com.

## Authors

Scott Claessens, scott.claessens@gmail.com
