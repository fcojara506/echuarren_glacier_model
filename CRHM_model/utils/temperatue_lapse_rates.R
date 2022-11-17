rm(list = ls())
library(dplyr)
library(CRHMr)


lapse_rate_tem <- function(date="2022-01-14 13:00:00",
                 obs_pe,
                 obs_ve,
                 new_z,
                 log_t = F) {
  print(date)
  
df1 = obs_pe %>%
  subset(datetime==date) %>% 
  merge(info_meteo,by="codigo_DGA")

df2 = obs_ve %>%
  subset(datetime==date)%>% 
  merge(info_meteo,by="codigo_DGA")

df = rbind(df1,df2)

if (log_t) {
reg_lm = lm(formula = log(temperatura_aire_kelvin) ~ z_m,data = df)
new_tem = predict.lm(reg_lm, newdata = data.frame(z_m = new_z)) %>% exp()
}else{
  reg_lm = lm(formula = temperatura_aire_kelvin ~ z_m,data = df)
  new_tem = predict.lm(reg_lm, newdata = data.frame(z_m = new_z))
}

#back to Celsius
new_tem=new_tem-265.15

return(new_tem)
}


# read meteorological station info
info_meteo = read.csv(file = "meteo_data/info_estaciones_DGA_echaurren.csv")

# temperature lapse rates
#load data
obs_pe = readRDS("meteo_data/obs_pe_20221115.RDS") %>%
  mutate(codigo_DGA = "05703013-5") %>% 
  select(datetime,temperatura_aire_celsius,codigo_DGA)%>% 
    mutate(temperatura_aire_kelvin = temperatura_aire_celsius + 265.15)

obs_ve = readRDS("meteo_data/obs_ve_20221115.RDS") %>%
  mutate(codigo_DGA = "05703012-7") %>%
  select(datetime,temperatura_aire_celsius,codigo_DGA) %>% 
    mutate(temperatura_aire_kelvin = temperatura_aire_celsius + 265.15)

#define mutal dates
common_df = merge(obs_pe,obs_ve,by="datetime") #%>% interpolate(varcols = c(1,3))
common_dates = common_df$datetime
# read HRU elevation
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")

tem_HRU = sapply(common_dates, 
                 function(x) lapse_rate_tem(date = x,
                                            obs_pe = obs_pe,
                                            obs_ve = obs_ve,
                                            new_z = basin_df$elevacion_msnm)
                
                 ) %>% 
  round(digits= 3) %>%
  t %>% 
  as.data.frame() %>% 
  cbind(datetime = common_dates,.)

#remove duplicated rows
tem_HRU = tem_HRU[!duplicated(tem_HRU), ]

saveRDS(object = tem_HRU,
        file = "meteo_data/tem_20221115.RDS")
