rm(list = ls())

library(dplyr)
library(data.table)

basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")

observaciones =
  list.files(
  path = "CRHM_model_output/archivos/",
  pattern = "obs_",
  full.names = T)

a=lapply(observaciones , readRDS) %>% rbindlist() %>% 
  mutate(HRU = as.integer(HRU)) %>% 
  merge(basin_df,by = "HRU")

library(ggplot2)
library(scales)
p = ggplot(data = a)+
  geom_line(aes(x = datetime,
                y = value,
                col = elevacion_msnm,
                group= elevacion_msnm ))+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 months")+
  facet_wrap(~var,scales = "free_y",ncol=1)+
  labs(x = "fecha (2022)",
       col = "elevación (m)")

ggsave(filename = paste0("CRHM_model_output/figuras/","obs_hru",".png"),
       plot = p,
       width = 10,
       height = 8,
       dpi = 600)


