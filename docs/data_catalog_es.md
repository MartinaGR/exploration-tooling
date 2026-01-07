# Catálogo de datos y unidades

Esta lista resume qué datos se consumen en los pipelines de hospitalizaciones de COVID y de influenza, indicando la medida (unidad) usada en cada caso. Úsala como checklist para reproducir el flujo de datos manualmente.

## Hospitalizaciones objetivo
- **NHSN hospitalizaciones por influenza (`hhs` en `hhs_archive`):** tasas semanales por **100.000 habitantes**, derivadas de las admisiones diarias descargadas de healthdata.gov y reescaladas con población estatal/HHS/nacional. 【F:R/targets/flu_data_targets.R†L25-L40】
- **NHSN hospitalizaciones por COVID (`hhs` en `hhs_archive`):** conteos semanales (no reescalados) agregados desde admisiones diarias de healthdata.gov. 【F:R/targets/covid_data_targets.R†L11-L30】

## Series de vigilancia de influenza (covariables)
- **FluSurv-NET (`flusurv`):** tasa semanal ajustada de hospitalizaciones por influenza, ya en unidades por **100.000** (columna `adj_hosp_rate`). 【F:R/targets/flu_data_targets.R†L43-L54】
- **ILI+ (`ili_plus`):** tasa semanal derivada de consultas por influenza/ILI; se filtran valores pequeños y se alinea por versión semanal. 【F:R/targets/flu_data_targets.R†L56-L78】
- **Veterans Affairs (`veteran_state_archive`):** pacientes únicos con influenza en VA, convertidos a tasas **por 100.000** y semanalizados. 【F:R/targets/flu_data_targets.R†L330-L388】

## Series de vigilancia respiratoria generales
- **NSSP (visitas a urgencias):** porcentaje de visitas a urgencias con diagnóstico de influenza (`pct_ed_visits_influenza`) o COVID (`pct_ed_visits_covid`), en unidades de **porcentaje del total de visitas**. 【F:R/targets/flu_data_targets.R†L106-L150】【F:R/targets/covid_data_targets.R†L31-L73】
- **Google Symptoms:** índice normalizado de búsqueda de síntomas (tos, fiebre, bronquitis para influenza; bronquitis y ageusia para COVID), agregado semanalmente; es una medida adimensional de intensidad de búsqueda. 【F:R/targets/flu_data_targets.R†L152-L221】【F:R/targets/covid_data_targets.R†L75-L134】
- **NWSS (aguas residuales):** concentración viral normalizada por población de SARS-CoV-2/Influenza en aguas residuales (`value`) y sus promedios regional/nacional (`nwss_region`, `nwss_national`); mantenidas como valores continuos (unidad definida por NWSS, típicamente copias genómicas normalizadas). 【F:R/targets/flu_data_targets.R†L223-L283】【F:R/targets/covid_data_targets.R†L136-L192】

## Datos auxiliares
- **Población y densidad:** se añaden para reescalar tasas o construir agregados ponderados. 【F:R/targets/flu_data_targets.R†L25-L40】【F:R/targets/flu_data_targets.R†L223-L280】
- **Tablas de regiones HHS:** mapas de códigos estado→región para producir agregados regionales. 【F:R/targets/flu_data_targets.R†L285-L297】
- **Pronósticos externos del COVID Forecast Hub:** archivos Parquet con predicciones de otros equipos, en unidades de conteos semanales; se reescala por 7 si venían en conteos diarios. 【F:R/targets/covid_external_targets.R†L1-L35】

Con esta tabla tienes las fuentes y unidades necesarias para reconstruir manualmente las entradas de los modelos de COVID e influenza.
