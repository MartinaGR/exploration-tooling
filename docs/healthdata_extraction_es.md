# Extracción de hospitalizaciones desde healthdata.gov (Socrata)

Este proyecto baja las hospitalizaciones diarias de COVID e influenza directamente de la API Socrata de **healthdata.gov** y las convierte en archivos de archivo (`epi_archive`) usados por los pipelines. La descarga se hace para cada fecha de corte (`as_of`) y **solo cubre EE. UU.** (estados + agregado nacional), no hay soporte para Perú.

## Pasos del código
La función central es `get_health_data()` en `R/aux_data_utils.R`:

1. Crea/usa un caché local en `cache/healthdata/` para evitar descargas repetidas.
2. Consulta el dataset de metadatos `qqte-vkut` vía Socrata para obtener el enlace `archive_link` del archivo más reciente disponible para la fecha `as_of`.
3. Descarga ese CSV (o usa la copia en caché) y calcula la métrica `hhs`:
   - COVID: `previous_day_admission_adult_covid_confirmed + previous_day_admission_pediatric_covid_confirmed`.
   - Influenza: `previous_day_admission_influenza_confirmed`.
4. Ajusta columnas y fechas (`time_value = date - 1L`), normaliza `geo_value` a abreviaturas de estado en minúsculas y agrega el total de EE. UU. con `append_us_aggregate("hhs")`.

El código completo vive aquí:
```
R/aux_data_utils.R:get_health_data()
```

## Ejecución manual
En una sesión de R dentro del repo:

```r
suppressPackageStartupMessages(source("R/load_all.R"))

# Descarga hospitalizaciones de influenza más recientes
flu_hhs <- get_health_data(as_of = Sys.Date(), disease = "flu")

# Descarga hospitalizaciones de COVID para una fecha pasada
covid_hhs <- get_health_data(as_of = as.Date("2024-12-31"), disease = "covid")

# Ve la cabecera
head(flu_hhs)
```

Esto creará/leerá archivos CSV cacheados en `cache/healthdata/` y devolverá un `tibble`/`epi_archive` listo para usarse en los modelos. No es necesario configurar credenciales: la API de Socrata usada es pública.
