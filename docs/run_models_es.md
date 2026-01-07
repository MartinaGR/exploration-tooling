# Cómo ejecutar manualmente los modelos

Este repositorio usa [`targets`](https://docs.ropensci.org/targets/) para orquestar los pipelines de predicción. A continuación tienes código listo para correr tanto los modelos de COVID como de influenza desde la línea de comandos o dentro de R.

## Requisitos previos
- Tener las dependencias instaladas (usa `make renv` o `renv::restore()` en R).
- Exportar las variables de entorno necesarias, por ejemplo `DELPHI_EPIDATA_KEY` para fuentes que lo requieran.

## Ejecutar todo el pipeline desde la terminal
Usa el script de conveniencia `scripts/run_forecasts.R`.

```bash
# COVID (proyecto por defecto)
./scripts/run_forecasts.R

# Influenza hospitalaria
./scripts/run_forecasts.R flu_hosp_explore

# Solo un target concreto para depuración (sin procesos en segundo plano)
./scripts/run_forecasts.R flu_hosp_explore flu_forecasts
```

### Excluir los datos de Veterans Affairs
Si quieres cargar **todos los datos excepto los de VA**, define la variable de entorno `SKIP_VETERAN_DATA=1` al ejecutar el script (funciona tanto para COVID como para influenza):

```bash
SKIP_VETERAN_DATA=1 ./scripts/run_forecasts.R flu_hosp_explore
```

Esto evita descargar y fusionar el target `veteran_state_archive` y continúa el resto del pipeline sin esos datos.

## Ejecutar dentro de una sesión interactiva de R
Si prefieres inspeccionar objetos mientras corre el pipeline:

```r
suppressPackageStartupMessages(source("R/load_all.R"))
Sys.setenv(TAR_PROJECT = "covid_hosp_explore")  # o "flu_hosp_explore"

# Ejecutar todo
targets::tar_make()

# Solo un target (evita callr/crew para poder depurar)
targets::tar_make(names = "flu_forecasts", callr_function = NULL, use_crew = FALSE)
```

## Dónde ajustar el modelo
- Los envoltorios de forecasters viven en `R/forecasters_*`. Por ejemplo, `R/forecasters_covidhosp.R` y `R/forecasters_flu.R` contienen las configuraciones usadas en producción.
- La receta del pipeline de influenza (preprocesamiento, lags y cuantiles) está en `R/targets/flu_recipe.R`.
- El pipeline de datos de influenza se define en `_targets.yaml` y en los archivos de `R/targets/`, donde puedes modificar la lista de covariables, horizontes y otras opciones.

Con estas piezas puedes reproducir y modificar los modelos según tus necesidades.
