#' Packages
packages_cran <-
  c(
    "data.table",
    "dplyr",
    "forcats",
    "ggalluvial",
    "ggfittext",
    "ggplot2",
    "ggnewscale",
    "parallel",
    "pbmcapply",
    "philentropy",
    "plotly",
    "readr",
    "rotl",
    "splitstackshape",
    "tidyr",
    "UpSetR"
  )
packages_bioconductor <- c("ggtree", "ggtreeExtra", "ggstar")
packages_github <- NULL # c("KarstensLab/microshades")

source("R/check_and_load_packages.R")
check_and_load_packages_1()
check_and_load_packages_2()
