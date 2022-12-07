library(raster)
library(ggplot2)
library(ggpubr)
library(dplyr)

rm(list = ls())
## para histogramas HRU

df_hru <- read.csv2(file = "../CRHM_model/basin_data/HRU_basin_properties.csv")

## para histogramas pixeles

pix_elev <- "GIS/outputs/rasters/cuenca_DEM.tif" %>% raster %>% as.matrix %>% c
pix_asp  <- "GIS/outputs/rasters/cuenca_aspect.tif" %>% raster %>% as.matrix %>% c
pix_slo <- "GIS/outputs/rasters/cuenca_slope.tif" %>% raster %>% as.matrix %>% c

####
## crea histogramas

df <- rbind(data.frame(data = "URH", elev = df_hru$elevacion_msnm, asp = df_hru$orientacion_grados, slo = df_hru$pendiente_grados),
            data.frame(data = "grilla 12.5 m", elev = pix_elev, asp = pix_asp, slo = pix_slo))
df$data <- factor(df$data, levels = c("grilla 12.5 m", "URH"))

gg1 <- ggplot(data = df, aes(x = elev, fill = data)) +
  geom_histogram(alpha = 0.4, position = 'identity', bins = 7, aes(y = 100 * stat(density * width))) +
  theme_bw() + labs(x = "Elevación media (m.s.n.m)", y = "Frecuencia relativa (%)", fill = "Datos")

gg2 <- ggplot(data = df, aes(x = asp, fill = data)) +
  geom_histogram(alpha = 0.4, position = 'identity', bins = 7, aes(y = 100 * stat(density * width))) +
  theme_bw() + labs(x = "Orientacion (°N)", y = "Frecuencia relativa (%)", fill = "Datos")

gg3 <- ggplot(data = df, aes(x = slo, fill = data)) +
  geom_histogram(alpha = 0.4, position = 'identity', bins = 7, aes(y = 100 * stat(density * width))) +
  theme_bw() + labs(x = "Pendiente (°)", y = "Frecuencia relativa (%)", fill = "Datos")

ggarrange(gg1, gg2, gg3, ncol = 3, nrow = 1, common.legend = T, legend = "bottom") %>%
  ggsave("GIS/outputs/pixel_vs_HRU.png", ., units = "in", width = 8, height = 4,dpi = 400)
