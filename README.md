# trinotate-venomics

Script en R para filtrado y clasificación del venoma de *Cupiennius chiapanensis* usando tidyverse y anotaciones de Trinotate.

## Descripción

Este repositorio contiene el script que utilizo en el seminario:

“Minería del veneno de *Cupiennius chiapanensis*: filtrado y clasificación funcional del transcriptoma con tidyverse aplicado a anotaciones con Trinotate”.

El script toma como entrada un archivo `trinotate_annotation_report.csv` (reporte de Trinotate con BLASTX, BLASTP, Pfam, SignalP, TmHMM, eggNOG) y:

- Filtra el secretoma clásico usando las predicciones de SignalP y TmHMM.
- Define firmas de toxinas mediante expresiones regulares (regex) sobre las anotaciones.
- Clasifica los transcritos en categorías funcionales de veneno (`venom_category`), como:
  - Neurotoxinas ICK/knottin
  - Inhibidores Kunitz
  - Proteasas (metalo-, serina-, cisteína-)
  - Fosfolipasas (PLA2)
  - CRISP / CAP
  - Péptidos antimicrobianos (AMPs)
  - Proteínas secretadas novedosas (“huérfanos”)
- Genera tablas de resumen y archivos CSV separados por categoría.

## Archivos principales

- `asignacion-funcional-2.0.R`: script principal con todo el pipeline de filtrado y clasificación.

## Requisitos

- R (>= 4.0 recomendado)
- Paquetes de R:
  - `tidyverse`
  - `readr`
  - `dplyr`
  - `stringr`

Instalación de paquetes:

```r
install.packages("tidyverse")
install.packages("readr")
install.packages("dplyr")
install.packages("stringr")
```

## Uso

1. Coloca tu archivo `trinotate_annotation_report.csv` en el mismo directorio que el script o ajusta la ruta en el código.
2. Abre `asignacion-funcional-2.0.R` en RStudio.
3. Ejecuta las secciones del script en orden (carga de datos, definición de regex, Tubería 1, Tubería 2, resúmenes y exportación de CSVs).
4. Revisa los archivos de salida:
   - Tabla de resumen de número de transcritos por categoría.
   - CSVs separados por tipo de componente de veneno.

## Cita sugerida

Si reutilizas o adaptas este pipeline, por favor cita:

Daniel Velasco, (2025). *trinotate-venomics: pipeline en R para filtrado y clasificación del venoma de Cupiennius chiapanensis*. GitHub. https://github.com/velher9997-hash/trinotate-venomics
