rm(list = ls())

library(dplyr)
library(data.table)



plot_obs_var <- function(filename,
                         var_CRHM,
                         y_label,
                         date_range = c(as.Date("2016-04-02"),
                                        as.Date("2022-11-01")),
                         tag_name = "2016_2022"
                         ){
df = readRDS(file = filename) %>% 
  mutate(HRU = as.integer(HRU)) %>% 
  merge(basin_df,by = "HRU") %>% 
  subset(datetime %between% date_range)

library(ggplot2)
library(scales)

p = ggplot(data = df)+
  geom_line(aes(x = datetime,
                y = value,
                col = elevacion_msnm,
                group= elevacion_msnm ))+
  labs(col = "elevación (m)",
       x = "",
       y = y_label)

ggsave(filename = paste0("CRHM_model_output/figuras/",tag_name,"/",var_CRHM,tag_name,".png"),
       plot = p,
       width = 10,
       height = 3,
       dpi = 400)

}

basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")

obs_filenames =
  list.files(
    path = "CRHM_model_output/archivos/",
    #pattern = ".RDS",
    full.names = T)

y_labels = list(
  "obs_hru_p" = "Precipitación (mm)",
  "obs_hru_rain" = "Precipitación líquida (mm)",
  "obs_hru_snow" = "Precipitación sólida (mm)",
  "obs_hru_rh" = "Humedad relativa (%)",
  "obs_hru_t" = "Temperatura de aire 2m (°C)",
  "obs_hru_u" = "Velocidad del viento (m/s)",
  "albedo_Richard_Albedo" = "Albedo (-)",
  "albedo_Richard_Albedo" = "Albedo (-)",
  "SnobalCRHM_SWE" = "SWE (mm/h)",
  "SnobalCRHM_E_s_int" = "Sublimación estática E (mm/h)",
  "CanopyClearing_net_snow" = "Precipitación sólida (mm/h)",
  "CanopyClearing_net_p" = "Precipitación (mm/h)",
  "CanopyClearing_net_rain" = "Precipitación líquida (mm/h)",
  "SnobalCRHM_rho" = "Densidad de la nieve (kg/m3)",
  "SnobalCRHM_delta_Q" = "Variación de energía nival (W/m2)",
  "SnobalCRHM_M" = "Calor advectivo (W/m2)",
  "SnobalCRHM_G" = "Calor conductivo (W/m2)",
  "SnobalCRHM_H" = "Calor sensible (W/m2)",
  "SnobalCRHM_L_v_E" = "Calor Latente (W/m2)",
  "SnobalCRHM_R_n" = "Radiación neta (W/m2)",
  "SnobalCRHM_snowmelt_int" = "Derretimiento nieve (mm)"
)

for (filename in obs_filenames) {
  
var_CRHM = filename %>% 
  sub(".*//", "", .) %>% 
  sub(".RDS.*", "", .)

plot_obs_var(filename = filename,
             var_CRHM = var_CRHM,
             y_label = y_labels[var_CRHM],
             date_range = c(as.Date("2016-04-02"),
                            as.Date("2022-11-01"))
)
}

for (filename in obs_filenames) {
  
  var_CRHM = filename %>% 
    sub(".*//", "", .) %>% 
    sub(".RDS.*", "", .)
  
  plot_obs_var(filename = filename,
               y_label = y_labels[var_CRHM],
               var_CRHM = var_CRHM,
               date_range = c(as.Date("2022-08-01"),
                              as.Date("2022-11-01")),
               tag_name = "ASO2022"
  )
}

