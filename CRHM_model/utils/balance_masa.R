rm(list = ls())
library(dplyr)
library(data.table)

# basin properties
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")
basin_area = sum(basin_df$area_km2)
# energy balance
files_folder = "CRHM_model_output/archivos/"

#function
read_variable  <- function(variable_crhm) {
  df = readRDS(file = paste0(files_folder,variable_crhm,".RDS"))
  return(df)
}

hourly_data <- function(
date_range = c(as.Date("2016-04-02"),
               as.Date("2022-10-31"))
) {
  
  list_snow = c(
    "obs_hru_snow",
    "obs_hru_rain",
    "evap_hru_actet",
    "SnobalCRHM_E_s_int",
    "pbsmSnobal_hru_subl",
    "pbsmSnobal_hru_drift"
  )
  
  list_soil = c(
    "Soil_soil_moist",
    "Soil_gw",
    "SnobalCRHM_SWE",
    "glacier_ice" #,"fern"
  )
  
  list_flows = c(
    "Netroute_M_runoutflow",
    "Netroute_M_ssroutflow",
    "Netroute_M_gwoutflow"
  )
  
  df_snow = 
    lapply( list_snow , read_variable) %>%
    rbindlist() %>% 
    mutate(HRU = as.integer(HRU)) %>% 
    merge(basin_df,by = "HRU") %>% 
    select(c(datetime,var,value,area_km2)) %>% 
    subset(datetime %between% date_range)
  
  df_routing = 
    lapply( list_flows , read_variable) %>%
    rbindlist() %>% 
    mutate(HRU = as.integer(HRU)) %>%
    subset(datetime %between% date_range)
  
  df_soil =     
    lapply( list_soil , read_variable) %>%
    rbindlist() %>% 
    mutate(HRU = as.integer(HRU)) %>% 
    merge(basin_df,by = "HRU") %>% 
    select(c(datetime,var,value,area_km2)) %>% 
    subset(datetime %between% date_range) %>% 
    mutate(var_avg = value * area_km2/basin_area) %>% 
    select(datetime, var, var_avg,value)
  
# aggregate by basin
  df_snow_hourly = df_snow %>% 
    mutate(var_avg = value * area_km2/basin_area) %>% 
    select(-value,-area_km2) %>% 
    group_by(var,datetime) %>% 
    summarize(var_sum = sum(var_avg)) %>% 
    select(datetime, var, var_sum)
  
  df_routing_hourly = df_routing %>%
    subset(HRU==39) %>%
    mutate(var_sum = value/basin_area) %>% 
    select(datetime, var, var_sum)

  df_soil_hourly = df_soil %>% 
    group_by(var,datetime) %>% 
    summarize(var_sum = sum(var_avg)) %>% 
    select(datetime, var, var_sum)
  
  df = list(
    df_snow_hourly = df_snow_hourly,
    df_routing_hourly = df_routing_hourly,
    df_soil_hourly = df_soil_hourly
  )
return(df)
}

# ls_hist = 
# hourly_data(date_range = c(
#   as.Date("2016-04-02"),
#   as.Date("2022-10-31")
#   ))

ls_2022 = 
  hourly_data(date_range = 
    c(as.Date("2022-08-01"),
      as.Date("2022-10-31")
  )) %>% rbindlist() 

library(ggplot2)
p=ggplot(data = ls_2022,
       aes(x = datetime,
           y = var_sum))+
  geom_line()+
  facet_wrap(~var,
             scales = "free_y",
             ncol=1)

ggsave(filename = "balance_masa.png",
       plot = p,
       width = 5,
       height = 10,
       dpi = 500)

