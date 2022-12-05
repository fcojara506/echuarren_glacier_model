rm(list = ls())
library(dplyr)
library(CRHMr)
library(data.table)
#series de tiempo
source("base/mass_balance.R")
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")[,c("HRU","area_km2")]


date_range = c(as.Date("2016-04-01"),
               as.Date("2022-11-01"))

df_filename = "CRHM_model_output/balance_masa.txt"
df = readOutputFile(df_filename,timezone = "etc/GMT+4") %>%
  data.frame() %>%
  subset(datetime %between% date_range)
df_units = CRHMr::readOutputUnits(df_filename)
# seleccionar variables


library(ggplot2)

p1 = 
  ggplot(data = df[,c(1,"SWE" %>% list_index)] %>% sep_col,
         aes(x=datetime,
             y=value,
             col=HRU,
             group=HRU))+
  geom_line()


ggsave(filename = "CRHM_model_output/figuras/SWE.png",plot=p1,width = 8,height = 5)


# ice time series
df2= df[,c(1,"ice[.]" %>% list_index)]%>% sep_col
df2.1 = df2[df2$HRU %in% c(2,3,5,7,11,18,19,20,21),] %>% mutate(tipo="Glaciarete")
df2.2 = df2[df2$HRU %in% c(36,43,14),] %>% mutate(tipo="Glaciar Rocoso")
df2 = rbind(df2.1,df2.2)
# ice
p1 = 
  ggplot(data =  df2,
         aes(x=datetime,
             y=value,
             col = tipo,
             group = HRU
             ))+
  geom_line()

ggsave(filename = "CRHM_model_output/figuras/ice.png",plot=p1,width = 8,height = 5)


df3=df[,c(1,"gw[.]" %>% list_index)] %>% sep_col
p1 = 
  ggplot(data = df3,
         aes(x=datetime,
             y=value,
             col=HRU,
             group=HRU))+
  geom_line()

plot(p1)
ggsave(filename = "CRHM_model_output/figuras/gw.png",plot=p1,width = 8,height = 5)

df2 = df[,c(1,"basinflow" %>% list_index)] %>% 
mutate(basinflow.1=basinflow.1*1e9/(1e12*sum(basin_df$area_km2)))

p1 = 
  ggplot(data = df2 %>% sep_col,
         aes(x=datetime,
             y=value,
             col=HRU,
             group=HRU))+
  geom_line()

plot(p1)
ggsave(filename = "CRHM_model_output/figuras/basinflow.png",plot=p1,width = 8,height = 5)



df2 = df[,c(1,"basingw" %>% list_index)] %>% 
  mutate(basingw.1=basingw.1*1e9/(1e12*sum(basin_df$area_km2)))

p1 = 
  ggplot(data = df2 %>% sep_col,
         aes(x=datetime,
             y=value,
             col=HRU,
             group=HRU))+
  geom_line()

plot(p1)
ggsave(filename = "CRHM_model_output/figuras/basingw.png",plot=p1,width = 8,height = 5)


p1 = 
  ggplot(data = df[,c(1,"soil_moist" %>% list_index)] %>% sep_col,
         aes(x=datetime,
             y=value,
             col=HRU,
             group=HRU))+
  geom_line()


ggsave(filename = "CRHM_model_output/figuras/soil_moist.png",plot=p1,width = 8,height = 5)


