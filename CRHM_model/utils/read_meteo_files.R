library(dplyr)
library(lubridate)

rm(list = ls())

read_filename <- function(filename) {
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

# read all the "number".csv file in the station folder
meteo_file_list = list.files(path = "CRHM_model/meteo_data/Portezuelo Echaurren/",
                             pattern = "*[0-9].csv",
                             full.names = T)

#read the parameters name related to csv names
column_names = read.csv("CRHM_model/meteo_data/Portezuelo Echaurren/nombre_columnas.csv")


#merge all the files based on datetime (time stamps)
df = Reduce(
  f = function(df1, df2)
    merge(df1, df2, by = "datetime",all = T),
  x = lapply(meteo_file_list, read_filename)
) %>% 
#change datetime format
mutate(datetime =  as.POSIXct(datetime,
                              format="%d/%m/%Y %H:%M:%S",
                              tz="Etc/GMT+4")) %>% 
  arrange(datetime)


       
