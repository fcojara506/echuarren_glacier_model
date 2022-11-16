rm(list = ls())
library(dplyr)
library(CRHMr)
# read meteorological station info
info_meteo = read.csv(file = "meteo_data/info_estaciones_DGA_echaurren.csv")

# temperature lapse rates
#load data
obs_pe = readRDS("meteo_data/obs_pe_20221115.RDS") %>%
  mutate(codigo_DGA = "05703013-5") %>% 
  select(datetime,velocidad_viento_ms,codigo_DGA)

obs_ve = readRDS("meteo_data/obs_ve_20221115.RDS") %>%
  mutate(codigo_DGA = "05703012-7") %>%
  select(datetime,velocidad_viento_ms,codigo_DGA)

#define mutal dates
common_df = merge(obs_pe,obs_ve,by="datetime") %>% 
  select(-codigo_DGA.x,-codigo_DGA.y)
plot(common_df$velocidad_viento_ms.x,
     common_df$velocidad_viento_ms.y)

df = reshape2::melt(data = common_df,
                    id.vars = "datetime")


library(ggplot2)
ggplot(data = df)+
  geom_line(aes(x = datetime,
                y = value,
                col = variable),
            alpha=0.5)
