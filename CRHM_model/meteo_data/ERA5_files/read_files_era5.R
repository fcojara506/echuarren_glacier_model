library(ncdf4)
library(lubridate)
library(dplyr)

fname <- "meteo_data/ERA5_files/input_data/era5_precip_jan2016-oct2022_-4.nc"
nc        <- nc_open(fname)
var       <- ncvar_get(nc, "tp") 
date     <- as.POSIXct(ncvar_get(nc, "time")*3600,
                       tz = "GMT",origin = "1900-01-01 00:00:00.0")
nc_close(nc)

tabla    <- cbind.data.frame(datetime = date,
                             p1 = var[1, ]*1000,
                             p2 = var[2, ]*1000) %>% 
  mutate(p1 = ifelse(p1<1e-3,0,p1)) %>% 
  mutate(p2 = ifelse(p2<1e-3,0,p2))



obs_DGA = readRDS(file = "meteo_data/obs_20221123.RDS") %>% 
  select(datetime,precipitacion_invervalo_mm)

df = merge(tabla,obs_DGA,by="datetime") %>%
  #subset(datetime>"2022-03-01") %>% 
  reshape2::melt(id.vars = "datetime")
  

library(ggplot2)
ggplot(data = df)+
  geom_point(aes(x = datetime, y = value, col = variable))

p_test = tabla %>%
  select(datetime,p1) #%>% 
  #subset(datetime>"2022-03-01")

obs_DGA =  saveRDS(object = p_test,
  file = "meteo_data/p_ERA5_20221123.RDS")
