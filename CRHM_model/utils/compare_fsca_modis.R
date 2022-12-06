# Calcular fSCA de Echaurren obtenido de CRHM y compararlo con MODIS

library(CRHMr)
library(data.table)
library(dplyr)
library(lubridate)

source("base/mass_balance.R")
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")[,c("HRU","area_km2")]


date_range = c(as.Date("2016-04-01"),
               as.Date("2022-11-01"))
df_filename = "CRHM_model_output/balance_masa.txt"

df = readOutputFile(df_filename,timezone = "etc/GMT+4") %>%
  data.frame() %>%
  subset(datetime %between% date_range)

df_units = CRHMr::readOutputUnits(df_filename)

sc_hru_index  <-  'snowcover' %>% list_index


sc = df[,c(1,sc_hru_index)] %>% 
  sep_col %>%
  areal_avg

df_sc  <-  as.data.frame(sc)

rm(df)
rm(sc)
rm(basin_df)

df_sc['date_trunc']  <-  as.Date(df_sc$datetime)

date_unique  <-  unique(df_sc$date_trunc)
sc_diario  <-  NULL


for (i in 1:length(date_unique)){
  idx  <-  which(df_sc$date_trunc==date_unique[i])
  sc_diario[i]  <-  mean(df_sc$var_hour[idx])
}

plot(date_unique,sc_diario,type='l',xlab='',ylab='fSCA (-)')
lines(sca_modis$date,sca_modis$value/100,col='red')


sca_modis  <-  read.csv("basin_data/TimeSeries_fsca_ECHAURREN_2022_12_01_1446.csv")
sca_modis$date <-  as.Date(sca_modis$date)

plot(date_unique,sc_diario,type='l',xlab='',ylab='fSCA (-)',ylim=c(0,1.1),las=1,
     col='navyblue',lwd=2,xlim=as.Date(c("2016-04-01", "2022-11-01")))
grid()
lines(sca_modis$date,sca_modis$value/100,col='lightskyblue',lwd=2)
legend('top',
       c('Simulado CRHM','MODIS'),
       col=c('navyblue','lightskyblue'),
       lwd=2,
       lty=1,
       horiz=T,
       bty='n',
       cex=0.9)

