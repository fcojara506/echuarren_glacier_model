rm(list = ls())
library(dplyr)
source("base/run_CRHM_model.R")




export_obs <- function(variable_modulo,modulo = "obs") {
  
prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj"
# run
setPrjDates(inputPrjFile = prj_filename,
            startDate = '2016 4 1', endDate = '2022 11 5')  

output_name = paste(modulo,variable_modulo,sep="_")
set_output_variables(prj_filename = prj_filename,
                     new_variable = c(modulo,variable_modulo,as.character(seq(1,48))))
run_CRHM_output(output_filename = paste0(output_name,".txt"))

a=CRHMr::readOutputFile(outputFile = paste0("CRHM_model_output/",output_name,".txt"),
                        timezone = 'etc/GMT+4')
library(tidyr)
b = head(a,-24)

c = reshape2::melt(b,id.vars = "datetime") %>% 
  separate(variable,c("var","HRU"),
           sep = paste0(variable_modulo,".")) %>% 
  mutate(var = variable_modulo)

saveRDS(object = c,
        file = paste0("CRHM_model_output/archivos/",output_name,".RDS")
        )
return(c)
}

variables = c("hru_t",
              "hru_ea",
              "hru_p",
              "hru_snow",
              "hru_rain",
              "hru_rh",
              "hru_u")

#sapply(variables, function(x) export_obs(x,modulo = "obs"))

variables = c("SWE")
sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "SnobalCRHM"))

variables = c("Albedo")
sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "albedo_Richard"))

#label_y= "temperatura del aire (°C)"

#basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")
#d = merge(c,basin_df,by = "HRU")

# library(ggplot2)
# library(scales)
# ggplot(data = d)+
#   geom_line(aes(x = datetime,
#                 y = value,
#                 col = elevacion_msnm,
#                 group= elevacion_msnm ))+
#   scale_x_datetime(labels = date_format("%b"),
#                    date_breaks = "1 months")+
#   labs(x = "fecha (2022)",
#        y = label_y,
#        col = "elevación (m)")
# 
# ggsave(filename = paste0("CRHM_model_output/figuras/",output_name,".png"),
#        width = 7,
#        height = 2,
#        dpi = 400)

