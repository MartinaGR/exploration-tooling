#!/usr/bin/env Rscript

# Script de conveniencia para ejecutar los pipelines de targets sin abrir R
# de forma interactiva. Permite escoger el proyecto (covid o flu) y, si se
# desea, un target concreto para depuración.

suppressPackageStartupMessages({
  source("R/load_all.R")
  library(targets)
})

args <- commandArgs(trailingOnly = TRUE)
project <- if (length(args) >= 1) args[[1]] else "covid_hosp_explore"
target_name <- if (length(args) >= 2) args[[2]] else NULL

Sys.setenv(TAR_PROJECT = project)
message("Ejecutando proyecto targets: ", project)

if (is.null(target_name)) {
  tar_make()
} else {
  message("Ejecutando solo el target: ", target_name)
  tar_make(names = target_name, callr_function = NULL, use_crew = FALSE)
}
