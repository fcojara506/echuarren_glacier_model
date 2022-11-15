library(dplyr)
library(lubridate)

rm(list = ls())

read_filename <- function(filename,column_names) {
  # get parameters id from filename
  parameter_id = filename %>%
    stringr::str_split(string = .,
                       pattern = "/",
                       simplify = T) %>%
    .[, ncol(.)] %>%
    gsub(".csv", "", .)
  
  #match name using column names
  parameter_name = subset(column_names, id == parameter_id)
  
  #read file
  df = read.csv(filename) %>%
    rename(datetime = fecmed) %>%
    rename(!!parameter_name$nombre := medici) 

  
  return(df)
  
}

 merge_files_to_columns <- function(meteo_file_list,column_names) {
   
   #merge all the files based on datetime (time stamps)
   df = Reduce(
     f = function(df1, df2)
       merge(df1, df2, by = "datetime",all = T),
     x = lapply(X = meteo_file_list,
                FUN = function(x)  read_filename(filename = x,column_names=column_names)
                )
     ) %>% 
     #change datetime format
     mutate(datetime =  as.POSIXct(datetime,
                                   format="%d/%m/%Y %H:%M:%S",
                                   tz="etc/GMT+4")) %>% 
     arrange(datetime)
   
   return(df)
 }
 
 
 # Portezuelo Echaurren
 
# read all the "number".csv file in the station folder
meteo_file_list = list.files(path = "meteo_data/Portezuelo Echaurren/",
                             pattern = "*[0-9].csv",
                             full.names = T)
#read the parameters name related to csv names
column_names = read.csv("meteo_data/Portezuelo Echaurren/nombre_columnas.csv")

df_portezuelo_echaurren = merge_files_to_columns(meteo_file_list,column_names)

# Valle Echaurren
# read all the "number".csv file in the station folder
meteo_file_list = list.files(path = "meteo_data/VALLE ECHAURREN/",
                             pattern = "*[0-9].csv",
                             full.names = T)
#read the parameters name related to csv names
column_names = read.csv("meteo_data/VALLE ECHAURREN/nombre_columnas.csv")

df_valle_echaurren = merge_files_to_columns(meteo_file_list,column_names) %>% 
  cbind(precipitacion_invervalo_mm=c(0,diff(.$precipitacion_acum_mm))) %>% 
  mutate(precipitacion_invervalo_mm = (abs(precipitacion_invervalo_mm)+precipitacion_invervalo_mm)/2)





######################
#TEST
#TEST
#TEST
#####################

#define observation file
obs = df_valle_echaurren

#remove unnecessary meteorological variables
obs = subset(obs, select = -c(
  precipitacion_instantanea_mm,
  precipitacion_acum_mm,
  direccion_viento_grados,
  Rad_solar_wattm2,
  presion_atm_mb
  ))

# round dates
obs$datetime = lubridate::round_date(obs$datetime,unit="hour")

saveRDS(object = obs,
        file = "meteo_data/obs_20221115.RDS")

