# Packages
library(tidyverse)
library(patchwork)
library(knitr)
library(kableExtra)
library(lingStuff)
library(broom)
library(viridis)
library(untidydata)
library(academicWriteR)

# set seed for reproducibility
set.seed(12345)

# Plot helpers
my_theme <- function(...) {
  list(
    theme_minimal(base_family = 'Times', base_size = 20), 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank())
  )
}
