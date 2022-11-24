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
new_tem=new_tem-273.15

return(new_tem)
}


# read meteorological station info
info_meteo = read.csv(file = "meteo_data/info_estaciones_DGA_echaurren.csv")

# temperature lapse rates
#load data
obs_pe = "meteo_data/obs_pe_20221123.RDS" %>%
  readRDS() %>% 
  mutate(codigo_DGA = "05703013-5") %>%
  select(datetime,temperatura_aire_celsius,codigo_DGA) %>% 
  mutate(temperatura_aire_kelvin = temperatura_aire_celsius + 273.15) %>% 
  select(datetime,temperatura_aire_kelvin)

obs_ve = "meteo_data/obs_ve_20221123.RDS" %>%
  readRDS() %>%
  mutate(codigo_DGA = "05703012-7") %>%
  select(datetime,temperatura_aire_celsius,codigo_DGA) %>% 
    mutate(temperatura_aire_kelvin = temperatura_aire_celsius + 273.15) %>% 
  select(datetime,temperatura_aire_kelvin)



Q <- quantile(obs_pe$temperatura_aire_kelvin, probs=c(.25, .75), na.rm = T)
iqr <- IQR(obs_pe$temperatura_aire_kelvin,na.rm = T)  
obs_pe_selected<- subset(obs_pe, obs_pe$temperatura_aire_kelvin > (Q[1] - 1.5*iqr) & obs_pe$temperatura_aire_kelvin< (Q[2]+1.5*iqr))


#define mutal dates
common_df = merge(obs_pe_selected,
                  obs_ve,
                  by="datetime",
                  all.x = T)

lm_R=lm(formula = temperatura_aire_kelvin.y ~temperatura_aire_kelvin.x,
   data = common_df)$coeff

common_df2 = common_df %>% 
  mutate(temperatura_aire_kelvin.y = ifelse(is.na(temperatura_aire_kelvin.y),
           temperatura_aire_kelvin.x*lm_R[[2]]+lm_R[[1]],
           temperatura_aire_kelvin.y)
  )
# ggplot(data  = common_df,
#        aes(x = temperatura_aire_kelvin.x,
#            y = temperatura_aire_kelvin.y))+
#   geom_point()+
#   geom_smooth(method='lm')

common_dates = common_df2$datetime

obs_pe2 = select(common_df2,
                 c(datetime,temperatura_aire_kelvin.x)
) %>% mutate(codigo_DGA = "05703013-5")
obs_ve2 = select(common_df2,
                 c(datetime,temperatura_aire_kelvin.y)
) %>% mutate(codigo_DGA = "05703012-7")

names(obs_pe2) = c("datetime","temperatura_aire_kelvin","codigo_DGA")
names(obs_ve2) = c("datetime","temperatura_aire_kelvin","codigo_DGA")


rm(obs_pe,obs_ve)
# read HRU elevation
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")

tem_HRU = sapply(common_dates, 
                 function(x) lapse_rate_tem(date = x,
                                            obs_pe = obs_pe2,
                                            obs_ve = obs_ve2,
                                            new_z = basin_df$elevacion_msnm)
                
                 ) %>% 
  round(digits= 3) %>%
  t %>% 
  as.data.frame() %>% 
  cbind(datetime = common_dates,.)

#remove duplicated rows
tem_HRU = tem_HRU[!duplicated(tem_HRU), ]

saveRDS(object = tem_HRU,
        file = "meteo_data/tem_20221123.RDS")
