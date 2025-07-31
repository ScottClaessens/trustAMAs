# Trust in Artificial Moral Advisors Across Cultures

## Getting Started

### System requirements

This software has been tested on Windows 11 Enterprise (version 24H2).

### Installation

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

The code was run using the package versions listed in `sessionInfo.txt`. If
issues arise, try installing the specific package versions listed there.

The installation process should take no longer than five minutes on a standard
laptop.

### Demo

To run a short demo:

1. Clone this repository to your local machine
2. Open the R Project file `trustAMAs.Rproj`
4. In the console, run `targets::tar_make(table_sample)`
5. Once the pipeline has finished, run `targets::tar_read(table_sample)`

This demo should take no longer than one minute to run one a standard laptop.
The code should print a table of sample characteristics to the console.

### Execute code in full

To reproduce the analyses and figures from the paper in full:

1. Clone this repository to your local machine
2. Open the R Project file `trustAMAs.Rproj`
4. In the console, run the full analysis pipeline with `targets::tar_make()`

The full analysis pipeline may take over 24 hours to run on a standard laptop.
This runtime can be sped up by running the pipeline in parallel (see 
[here](https://books.ropensci.org/targets/crew.html) for more details).

## Help

Any issues, please email scott.claessens@gmail.com.

## Authors

Scott Claessens, scott.claessens@gmail.com
