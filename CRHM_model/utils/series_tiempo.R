rm(list = ls())
library(dplyr)
library(CRHMr)
library(data.table)
#series de tiempo
source("base/mass_balance.R")
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")#[,c("HRU","area_km2",)]

tag = "WY2022"
date_range = c(as.Date("2016-04-01"),
               as.Date("2022-11-01"))

df_filename = "CRHM_model_output/balance_masa.txt"
df = readOutputFile(df_filename,timezone = "etc/GMT+4") %>%
  data.frame() %>%
  subset(datetime %between% date_range)
df_units = CRHMr::readOutputUnits(df_filename)
# seleccionar variables

library(ggplot2)
library(scales)
df1 = df[,c(1,"SWE" %>% list_index)] %>%
  sep_col %>%
  merge(basin_df[,c("HRU","elevacion_msnm","area_km2")])

p1 = 
  ggplot(data = df1,
         aes(x=datetime,
             y=value,
             col=elevacion_msnm,
             group=elevacion_msnm))+
  geom_line()+
  labs(x="",
       y = "Equivalente de agua nieve (mm)",
       col = "Elevación (msnm)")+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 month")

plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/SWE.png"),plot=p1,width = 10,height = 3)

# ice time series
info_glaciares = read.csv("basin_data/info_glaciares_echaurren_general.csv")
info_glaciares_HRU = read.csv("basin_data/info_glaciares_echaurren_HRU.csv")
info_glaciares_HRU = info_glaciares_HRU[info_glaciares_HRU$IceInit_mm>0,]
  

df2= df[,c(1,"ice[.]" %>% list_index)]%>%
  sep_col %>% 
  merge(info_glaciares_HRU) %>%
  merge(basin_df[,c("HRU","area_km2")]) %>% 
  group_by(datetime,id_DGA) %>% 
  summarise(value = sum(value*area_km2/sum(area_km2))) %>% 
  merge(info_glaciares)

# ice
p1 = 
  ggplot(data =  df2,
         aes(x=datetime,
             y=value/1000,
             col = id_DGA,
             group = id_DGA
             ))+
  geom_line()+
  scale_color_brewer(palette = "Set1")+
  labs(x="",
       y = "Hielo Equivalente de agua (m)",
       col = "ID\n(Inventario DGA, 2022)")+
  theme(legend.position = "bottom")+
  guides(col=guide_legend(nrow=2,byrow=TRUE))+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 month")

#plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/ice.png"),
       plot=p1,
       width = 8,
       height = 4)


df3=df[,c(1,"gw[.]" %>% list_index)] %>% sep_col
p1 = 
  ggplot(data = df3,
         aes(x=datetime,
             y=value,
             col=HRU,
             group=HRU))+
  geom_line()+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 month")

#plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/gw.png"),
       plot=p1,
       width = 8,
       height = 5)

df2 = df[,c(1,"basinflow" %>% list_index)] %>% 
mutate(basinflow.1=basinflow.1*1e9/(1e12*sum(basin_df$area_km2)))

p1 = 
  ggplot(data = df2 %>% sep_col,
         aes(x=datetime,
             y=value))+
  geom_line()+
  ylim(0,0.4)+
  labs(x = "",
             y = "Escorrentía superficial (mm/h)")+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 month")

#plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/basinflow.png"),
       plot=p1,
       width = 8,
       height = 2.7)



# df2 = df[,c(1,"basingw" %>% list_index)] %>% 
#   mutate(basingw.1=basingw.1*1e9/(1e12*sum(basin_df$area_km2)))
# 
# p1 = 
#   ggplot(data = df2 %>% sep_col,
#          aes(x=datetime,
#              y=value,
#              col=HRU,
#              group=HRU))+
#   geom_line()
# 
# plot(p1)
# ggsave(filename = "CRHM_model_output/figuras/basingw.png",plot=p1,width = 8,height = 5)


p1 = 
  ggplot(data = df[,c(1,"soil_moist" %>% list_index)] %>% sep_col,
         aes(x=datetime,
             y=value,
             col=HRU,
             group=HRU))+
  geom_line()

#plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/soil_moist.png"),
       plot=p1,width = 8,height = 5)

library(ggplot2)
df1 = df[,c(1,"hru_snow" %>% list_index)] %>%
  sep_col %>%
  merge(basin_df[,c("HRU","elevacion_msnm","area_km2")])

p1 = 
  ggplot(data = df1,
         aes(x=datetime,
             y=value,
             col=elevacion_msnm,
             group=elevacion_msnm
             ))+
  geom_line()+
  labs(x="",
       y = "Precipitación sólida (mm)",
       col = "Elevación (msnm)")+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 month")

#plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/p_snow.png"),
       plot=p1,
       width = 10,
       height = 3)

df1 = df[,c(1,"hru_rain" %>% list_index)] %>%
  sep_col %>%
  merge(basin_df[,c("HRU","elevacion_msnm","area_km2")])

p1 = 
  ggplot(data = df1,
         aes(x=datetime,
             y=value,
             col=elevacion_msnm,
             group=elevacion_msnm
         ))+
  geom_line()+
  labs(x="",
       y = "Precipitación líquida (mm)",
       col = "Elevación (msnm)")+
  scale_x_datetime(labels = date_format("%b"),
                   date_breaks = "1 month")

#plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/p_rain.png"),
       plot=p1,
       width = 10,
       height = 3)





df1 = df[,c(1,"hru_actet" %>% list_index)] %>%
  sep_col %>%
  merge(basin_df[,c("HRU","elevacion_msnm","area_km2")])

p1 = 
  ggplot(data = df1,
         aes(x=datetime,
             y=value,
             col=elevacion_msnm,
             group=elevacion_msnm
         ))+
  geom_line()+
  labs(x="",
       y = "Evaporación real (mm)",
       col = "Elevación (msnm)")

plot(p1)
ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/hru_actet.png"),
       plot=p1,
       width = 10,
       height = 3)


