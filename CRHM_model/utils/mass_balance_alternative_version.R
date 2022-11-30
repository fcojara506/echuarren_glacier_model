library(CRHMr)
library(data.table)
library(dplyr)

rm(list = ls())


list_index <- function(lista) {sapply(lista, function(x) grep(paste0("^",x), df_units$time,fixed = F))}

sep_col <- function(df) {
  library(data.table)
  library(dplyr)
  
  df = data.table(df) %>% 
    melt.data.table(id.vars = "datetime") %>%
    .[, c("var", "HRU") := tstrsplit(variable, ".", fixed=TRUE)] %>% 
    .[, HRU:= as.integer(HRU)] %>% 
    .[, value:= as.double(value)] %>% 
    select(-variable)
  
  return(df)
}

areal_avg <- function(df) {
  area_basin = sum(basin_df$area_km2)
  
  df = data.table(df) %>% 
  merge.data.table(basin_df,by="HRU") %>% 
    mutate(value_areaavg = value * area_km2/area_basin) %>% 
    select(datetime,var,value_areaavg,value) %>% 
    group_by(datetime,var) %>% 
    summarise(var_hour=sum(value_areaavg))
  
  return(df)
}
date_YM <- function(df) {
  ## hourly to monthly
  df$date = df$datetime %>% format("%Y-%m-01") %>% as.Date()
  return(df)
  
}

basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")[,c("HRU","area_km2")]



df_filename = "CRHM_output_2.txt"
df = readOutputFile(df_filename,timezone = "etc/GMT+4")
df_units =CRHMr::readOutputUnits(df_filename)

flujos_hru_index = c("hru_rain","hru_snow","hru_actet","hru_subl","intcp_evap","Subl_Cpy","E_s_int") %>% list_index
almacen_hru_index = c("firn","ice","gw","soil_moist","Sd") %>% list_index
caudales_cuenca_index = c("basinflow","basingw")%>% list_index
snowloss_cuenca_index = c("BasinSnowLoss")%>% list_index

##### from HRU to URH
## mm/int
cuenca_flujos = df[,c(1,flujos_hru_index)] %>% 
  sep_col %>% 
  areal_avg %>% 
  #date_YM %>% 
  group_by(var) %>% 
  summarise(var_total=sum(var_hour))

## mm
cuenca_almacen = df[,c(1,almacen_hru_index)]%>%
  sep_col %>%
  areal_avg%>% 
  #date_YM%>% 
  group_by(var) %>% 
  summarise(var_total=first(var_hour)-last(var_hour))

## m3/int to mm/int
cuenca_caudales = df[,c(1,caudales_cuenca_index)]%>%
  sep_col %>% 
  mutate(var_hour = value*1e9/(1e12*sum(basin_df$area_km2))) %>% 
  select(datetime,var,var_hour)%>% 
  #date_YM%>% 
  group_by(var) %>% 
  summarise(var_total=sum(var_hour))

## mm/int
cuenca_snowloss = df[,c(1,snowloss_cuenca_index)] %>%
  sep_col%>% 
  #date_YM %>% 
  select(-HRU) %>% 
  rename(var_hour = value)%>% 
  group_by(var) %>% 
  summarise(var_total=sum(var_hour))

var_in= c("hru_rain","hru_snow","firn","gw","ice","Sd","soil_moist")

df2 = rbind(cuenca_almacen,
            cuenca_caudales,
            cuenca_flujos,
            cuenca_snowloss) %>% 
  mutate(in_or_out = ifelse(var %in% var_in, "in","out")) %>% 
  mutate(var_total = ifelse(var %in% c("E_s_int"), -var_total,var_total))


df_inout = df2 %>%
  group_by(in_or_out) %>% 
  summarise(var_sum = sum(var_total))
  
  



