# Cargar librerías
library(readxl)
library(dplyr)
library(stringr)
library(ggplot2)
library(writexl)
library(forcats)

# Leer archivo de anotaciones
trinotate <- read_excel("C:/Users/danie/OneDrive/Escritorio/protocolo de tesis/Secuencias de transcriptoma/Trancriptoma C.chiapanensis/Anotaciones/anotaciones_trinotate2.0.xlsx")

# Palabras clave relacionadas con veneno (ampliadas)
keywords <- c("venom", "toxin", "protease", "phospholipase", "hyaluronidase", "metalloproteinase")

# Columnas a buscar
relevantes <- c("sprot_Top_BLASTX_hit", "sprot_Top_BLASTP_hit", "Pfam", "gene_ontology_blast", "gene_ontology_pfam")

# Filtrar transcritos relevantes - VERSIÓN CORREGIDA
trinotate_filtered <- trinotate %>%
  filter(if_any(all_of(relevantes), ~ grepl(paste(keywords, collapse = "|"), ., ignore.case = TRUE)))
         
         # Función inferida - VERSIÓN COMPLETAMENTE CORREGIDA
         trinotate_filtered <- trinotate_filtered %>%
           mutate(
             funcion_inferida = case_when(
               !is.na(sprot_Top_BLASTX_hit) ~ sprot_Top_BLASTX_hit,
               !is.na(sprot_Top_BLASTP_hit) ~ sprot_Top_BLASTP_hit,
               !is.na(Pfam) ~ Pfam,
               !is.na(gene_ontology_blast) ~ gene_ontology_blast,
               TRUE ~ gene_ontology_pfam
             )
           )
         
         # CLASIFICACIÓN FUNCIONAL MEJORADA
         clasificar_funcion_refinada <- function(funcion) {
           if(is.na(funcion)) return("Función desconocida")
           
           funcion <- tolower(funcion)
           
           case_when(
             str_detect(funcion, "toxin|neurotoxin|venom") ~ "Toxina o toxina putativa",
             str_detect(funcion, "hyaluronidase") ~ "Hialuronidasa",
             str_detect(funcion, "metalloproteinase|metalloprotease") ~ "Metaloproteasa",
             str_detect(funcion, "serine protease|serine proteinase") ~ "Serina proteasa",
             str_detect(funcion, "cysteine protease|cysteine proteinase") ~ "Cisteína proteasa",
             str_detect(funcion, "protease|proteinase") ~ "Otra proteasa",
             str_detect(funcion, "phospholipase|pla2") ~ "Fosfolipasa",
             str_detect(funcion, "kunitz|serpin|inhibitor") ~ "Inhibidor de proteasa",
             str_detect(funcion, "transferase") ~ "Transferasa",
             str_detect(funcion, "receptor") ~ "Receptor",
             str_detect(funcion, "binding protein|igfbp|lectin") ~ "Proteína de unión",
             str_detect(funcion, "translocase|transport|channel|ion") ~ "Proteína de transporte o canal",
             str_detect(funcion, "chromosome|histone|structure") ~ "Proteína estructural",
             str_detect(funcion, "hypothetical|uncharacterized|unknown") ~ "Función desconocida",
             TRUE ~ "Otras funciones celulares"
           )
         }
         
         # Aplicar la función mejorada
         trinotate_filtered <- trinotate_filtered %>%
           mutate(funcion_general = sapply(funcion_inferida, clasificar_funcion_refinada))
         
         # Contar y calcular porcentaje
         conteo <- trinotate_filtered %>%
           count(funcion_general, sort = TRUE) %>%
           mutate(
             porcentaje = round(100 * n / sum(n), 2),
             funcion_general = fct_reorder(funcion_general, porcentaje, .desc = TRUE)
           )
         
         # Graficar
         grafico <- ggplot(conteo, aes(x = funcion_general, y = porcentaje, fill = funcion_general)) +
           geom_col(color = "black", alpha = 0.8) +
           geom_text(aes(label = paste0(porcentaje, "%")), hjust = -0.1, size = 3.5, color = "black") +
           coord_flip() +
           scale_fill_viridis_d(option = "plasma") +
           scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
           theme_minimal(base_size = 12) +
           theme(
             plot.background = element_rect(fill = "white", color = NA),
             panel.background = element_rect(fill = "white", color = NA),
             panel.grid.major.y = element_blank(),
             panel.grid.minor = element_blank(),
             axis.text = element_text(color = "black"),
             plot.title = element_text(face = "bold", hjust = 0.5),
             legend.position = "none"
           ) +
           labs(
             x = "Categoría funcional",
             y = "Porcentaje de transcritos (%)",
             title = "Clasificación funcional de las palabras clave",
           )
         
         # Mostrar y guardar resultados
         print(grafico)
         ggsave("componentes_veneno_final.png", plot = grafico, width = 10, height = 7, dpi = 600, bg = "white")
         write_xlsx(list("Transcritos" = trinotate_filtered, "Resumen" = conteo), "componentes_veneno_final.xlsx")
         