# plot
library(CRHMr)
library(data.table)
library(dplyr)
library(ggplot2)

rm(list = ls())

basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")[,c("HRU","area_km2")]

stat_box_data <- function(y,  upper_limit = max(basin_df$area_km2)*100 * 1.15) {
  
  return( 
    data.frame(
      y = 0.95* upper_limit,label = paste(
        'n =', length(y), '\n',
        'Promedio =', round(mean(y),2), 'ha \n',
        'Mediana =', round(median(y),2), 'ha'
      )
    )
  )
}

ggplot(data = fortify(basin_df),aes(x ="", y=area_km2*100))+
  geom_boxplot()+
  geom_jitter(width=0.15)+
  labs(x = "Unidades de Respuesta Hidrológica",
       y = "Superficie (ha)")+
  stat_summary(fun.data = stat_box_data,
               geom = "text", 
               hjust = 0.5,
               vjust = 1.9)
ggsave(filename = "CRHM_model_output/figuras/superficie_HRU.png",
       height = 5,
       width = 4.5,
       dpi = 500)
