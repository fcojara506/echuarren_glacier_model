library(dplyr)
library(lubridate)
rm(list = ls())

source("base/read_obs_hourly_DGA.R")

 
 
## Portezuelo Echaurren
# read all the "number".csv file in the station folder
meteo_file_list = list.files(path = "meteo_data/Portezuelo Echaurren/",
                             pattern = "*[0-9].csv",
                             full.names = T)
#read the parameters name related to csv names
column_names = read.csv("meteo_data/Portezuelo Echaurren/nombre_columnas.csv")

df_portezuelo_echaurren = merge_files_to_columns(meteo_file_list,column_names)

# negative to zero
df_portezuelo_echaurren = df_portezuelo_echaurren %>%
  mutate(SW_incidente_wattm2 = (abs(SW_incidente_wattm2)+SW_incidente_wattm2)/2) %>% 
  mutate(LW_incidente_wattm2 = (abs(LW_incidente_wattm2)+LW_incidente_wattm2)/2) %>%
  mutate(velocidad_viento_ms = (abs(velocidad_viento_ms)+velocidad_viento_ms)/2) %>% 
  mutate(datetime = lubridate::round_date(datetime,unit="hour"))


# Valle Echaurren
# read all the "number".csv file in the station folder
meteo_file_list = list.files(path = "meteo_data/VALLE ECHAURREN/",
                             pattern = "*[0-9].csv",
                             full.names = T)
#read the parameters name related to csv names
column_names = read.csv("meteo_data/VALLE ECHAURREN/nombre_columnas.csv")

df_valle_echaurren_historico = read_filename_10m_to_hourly() %>%
  subset(year(datetime)>2015) %>% 
  rename(profundidad_nieve_cm = profundidad_nieve_m)

df_valle_echaurren = 
  merge_files_to_columns(meteo_file_list,column_names) %>% 
  merge.data.frame(all = T,df_valle_echaurren_historico) %>% 
  cbind(precipitacion_invervalo_mm=c(0,diff(.$precipitacion_acum_mm))) %>% 
  mutate(profundidad_nieve_m = profundidad_nieve_cm/10)

rm(df_valle_echaurren_historico)

# negative to zero
df_valle_echaurren = df_valle_echaurren %>%
  mutate(precipitacion_invervalo_mm = (abs(precipitacion_invervalo_mm)+precipitacion_invervalo_mm)/2) %>% 
  mutate(SW_incidente_wattm2 = (abs(SW_incidente_wattm2)+SW_incidente_wattm2)/2) %>% 
  mutate(LW_incidente_wattm2 = (abs(LW_incidente_wattm2)+LW_incidente_wattm2)/2) %>%
  mutate(velocidad_viento_ms = (abs(velocidad_viento_ms)+velocidad_viento_ms)/2) %>% 
  mutate(datetime = lubridate::round_date(datetime,unit="hour"))




######################
#TEST
#TEST
#TEST
#####################

#define observation file
obs = df_valle_echaurren
saveRDS(object = obs,file = "meteo_data/obs_20221123.RDS")
saveRDS(object = df_portezuelo_echaurren,file = "meteo_data/obs_pe_20221123.RDS")
saveRDS(object = df_valle_echaurren,file = "meteo_data/obs_ve_20221123.RDS")

