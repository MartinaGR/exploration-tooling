# Mapa de código para rehacer el análisis

Esta guía agrupa los archivos clave del repositorio según su rol en el pipeline: **carga de datos**, **manejo y preprocesamiento**, **funciones/modelos**, y **análisis/ejecución**. Úsala como índice rápido para abrir los scripts relevantes cuando quieras replicar o modificar el flujo de influenza o covid.

## 1) Carga de datos
- **R/targets/covid_data_targets.R**: define los targets que descargan y archivan los datos de hospitalizaciones de COVID (`get_health_data(..., disease = "covid")`), convirtiéndolos a archivos semanales y añadiendo población/densidad.
- **R/targets/flu_data_targets.R**: construye los targets principales para influenza (NHSN como objetivo `hhs_archive`, ajuste de `flusurv`, `ILI+`, y combinación en `flusion_data_archive` con población y densidad).
- **R/targets/covid_external_targets.R** y **R/targets/flu_external_targets.R**: crean targets para predictores externos (NSSP, síntomas de Google, aguas residuales, etc.) y gestionan combinaciones con revisiones "as-of".
- **R/aux_data_utils.R** (en la carpeta `R/` de la raíz del repo): utilidades de apoyo para etiquetar temporada/semana epidémica, añadir población/densidad interpolada y construir cruzas de códigos (usa archivos en `aux_data/`, p. ej. `aux_data/flusion_data/apportionment.csv`). Si no lo ves, ejecuta `ls R/aux_data_utils.R` desde la raíz del repositorio.

## 2) Manejo y preprocesamiento de datos
- **R/forecasters/data_validation.R**: validaciones previas al modelado (chequeos de rangos, suficiencia de lags, fuentes disponibles, etc.).
- **R/forecasters/data_transforms.R**: transformaciones reutilizables (`rolling_mean`, `rolling_sd`, eliminación de NA, extensión de horizonte) aplicadas antes de enviar datos a los modelos.
- **R/new_epipredict_steps/**: pasos de receta y frosting personalizados usados dentro de `epipredict` para normalizar o postprocesar predicciones.
- **R/forecasters/formatters.R** y **R/forecasters/epipredict_utilities.R**: formateo de entradas/salidas y utilidades que encapsulan detalles de `epipredict`.

## 3) Funciones y modelos de pronóstico
- **R/forecasters/**: carpeta de modelos; los más usados en influenza están en:
  - `forecaster_scaled_pop_seasonal.R`: envoltorio con sazonalidad y escalado por población (predeterminado para influenza).
  - `forecaster_flusion.R`: implementación específica del modelo Flusion.
  - Otros modelos base/ensemble (`forecaster_flatline.R`, `forecaster_baseline_linear.R`, `ensemble_average.R`, etc.) se pueden intercambiar en configuraciones.
- **R/default_epipredict_args.R**: hiperparámetros por defecto (lags, horizontes, cuantiles) pasados a los forecasters.
- **R/forecasters/data_transforms.R** y **R/forecasters/data_validation.R** (citados arriba) actúan como pasos previos integrados a los modelos.

## 4) Análisis, scoring y ejecución
- **_targets.yaml** y **R/targets/**: definen los proyectos `covid_*` y `flu_*`; ejecuta `tar_make()` tras `source("R/load_all.R")` para correr un proyecto completo.
- **R/targets/score_targets.R**: descarga pronósticos externos desde S3, formatea y calcula métricas (WIS, AE, coberturas) con `hubEvals`, y renderiza reportes Markdown.
- **reports/**: plantillas y estilos de reportes (`template.md`, `style.css`).
- **R/plotting.R** y **R/scoring.R**: funciones auxiliares para visualización y evaluación usadas por los reportes.
- **scripts/**: scripts CLI de soporte (por ejemplo, invocación de targets o utilidades puntuales).

### ¿Qué es un YAML y para qué sirve `_targets.yaml`?
- **YAML** es un formato de texto estructurado (similar a JSON pero más legible) que se usa para definir configuraciones con pares clave-valor, listas y bloques anidados.
- En este repo, `_targets.yaml` define matrices de ejecución y configuraciones compartidas para los proyectos de `targets` (por ejemplo, `covid_hosp_explore`, `flu_hosp_prod`). Cada entrada debajo de `tar_projects` indica:
  - `script`: archivo R con los targets a ejecutar.
  - `store`: carpeta donde se guarda el caché del proyecto.
  - `use_crew`: si se usan trabajadores paralelos gestionados por `crew`.
  - `reporter_make`: estilo del reporter que imprime avances al correr `tar_make()`.
- Para ver el contenido directamente desde la raíz del repo: `cat _targets.yaml`.

### Cómo ejecutar manualmente
1. Inicia R en la raíz del repo y carga el código:
   ```r
   suppressPackageStartupMessages(source("R/load_all.R"))
   ```
2. Selecciona el proyecto (ej. influenza exploratorio) y ejecuta targets:
   ```r
   Sys.setenv(TAR_PROJECT = "flu_hosp_explore")
   tar_make()
   ```
3. Para depurar un paso concreto, ejecuta solo el target que te interesa:
   ```r
   tar_make(flu_forecasts, callr_function = NULL, use_crew = FALSE)
   ```
   Sustituye `flu_forecasts` por el nombre del target definido en `R/targets/`.

Con estas referencias puedes abrir directamente los archivos relevantes para replicar o ajustar el flujo de datos y modelos.
