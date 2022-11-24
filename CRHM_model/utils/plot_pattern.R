
rm(list = ls())

library(dplyr)
library(data.table)

vars = c("SWE","Albedo")

observaciones =
  list.files(
    path = "CRHM_model_output/archivos/",
    pattern = paste(vars,collapse = "|"),
    full.names = T
    )

basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")

df=lapply(observaciones , readRDS) %>% rbindlist() %>% 
  mutate(HRU = as.integer(HRU)) %>% 
  merge(basin_df,by = "HRU")

library(ggplot2)
library(scales)
p = ggplot(data = df)+
  geom_line(aes(x = datetime,
                y = value,
                col=elevacion_msnm,
                group=HRU))+
  facet_wrap(~var,ncol=1,scales = "free_y")+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 months")+
  labs(x = "fecha (2022)",
       col = "elevación (m)",
       y = "")

ggsave(filename = paste0("CRHM_model_output/figuras/",paste(vars,collapse = "_"),".png"),
       plot = p,
       width = 10,
       height = 8,
       dpi = 600)


