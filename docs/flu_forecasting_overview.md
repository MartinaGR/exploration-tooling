# Flu hospitalization forecasting overview

This repository trains and scores several flu hospitalization forecasters. The production and exploration pipelines both target the `value` column from the weekly NHSN flu hospitalization archive; COVID data are not used as a target and are only pulled for limited preprocessing tasks (for example, filling zeros in the VA auxiliary data). The main covariates are flu-related surveillance series such as NSSP emergency department visits, Google symptom searches, wastewater indicators, and VA flu hospitalizations.

## Where flu data and covariates are prepared
- `R/targets/flu_data_targets.R` builds the flu-specific data archives consumed by all flu forecasters. It downloads weekly NHSN flu hospitalizations as the outcome and flu-relevant covariates such as NSSP `pct_ed_visits_influenza`, Google symptoms searches, wastewater (`nwss`/`nwss_region`), and VA flu hospitalizations; COVID series only appear when filling missing VA data and are not used as model predictors.

## Flu forecaster implementations
- `R/forecasters/forecaster_flusion.R` defines the **flusion** model used in exploration. It trains a quantile random forest (Generalized Random Forest engine) with lags and smoothed/whitened predictors to emit quantile forecasts for the flu hospitalization outcome.
- Production flu forecasts are assembled in `scripts/flu_hosp_prod.R` using helper wrappers (`g_windowed_seasonal`, `g_windowed_seasonal_extra_sources`, etc.) around the `scaled_pop_seasonal` forecaster. These wrappers train quantile regression (ARX-style) models that include flu covariates like NSSP when provided and add seasonal windowing appropriate for flu.

## Running the flu models manually
1. Start an R session and load the package helpers:
   ```r
   suppressPackageStartupMessages(source("R/load_all.R"))
   ```
2. Choose the flu project and run the pipeline. For production-style forecasts set `TAR_PROJECT="flu_hosp_prod"`; for exploration runs use `"flu_hosp_explore"`:
   ```r
   Sys.setenv(TAR_PROJECT = "flu_hosp_prod")
   tar_make()
   ```
3. To debug or replicate a specific target/forecaster, add `browser()` inside the relevant function (e.g., in `forecaster_flusion` or the `g_windowed_seasonal` wrapper) and run:
   ```r
   tar_make(target_name, callr_function = NULL, use_crew = FALSE)
   ```
