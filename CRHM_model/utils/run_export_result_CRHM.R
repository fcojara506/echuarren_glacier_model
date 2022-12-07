rm(list = ls())
library(dplyr)

source("base/run_CRHM_model.R")

export_obs <- function(variable_modulo,modulo = "obs") {
  
prj_filename = "modelo_crhm_glaciar_echaurren_v21.prj"
# run
setPrjDates(inputPrjFile = prj_filename,
            startDate = '2016 4 1', endDate = '2022 11 5')  

output_name = paste(modulo,variable_modulo,sep="_")
set_output_variables(prj_filename = prj_filename,
                     new_variable = c(modulo,variable_modulo,as.character(seq(1,48))))
  run_CRHM_output(output_filename = paste0(output_name,".txt"),
                  prj_filename = prj_filename)

a=CRHMr::readOutputFile(outputFile = paste0("CRHM_model_output/",output_name,".txt"),
                        timezone = 'etc/GMT+4')
library(tidyr)
#b = head(a,-24)

c = reshape2::melt(a,id.vars = "datetime") %>% 
  separate(variable,c("var","HRU"),
           sep = paste0(variable_modulo,".")) %>% 
  mutate(var = variable_modulo)

saveRDS(object = c,
        file = paste0("CRHM_model_output/archivos/",output_name,".RDS")
        )
return(c)
}

# #soil
# variables = c("soil_moist","gw")
# sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "Soil"))

variables = c("hru_t",
              "hru_p",
              "hru_snow",
              "hru_rain",
              "hru_rh",
              "hru_u"
              )
sapply(variables, function(x) export_obs(x,modulo = "obs"))
# #variables = c("Albedo")
# #sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "albedo_Richard"))
# 
# #CanopyClearing
# variables=c("net_p","net_snow","net_rain")
# sapply(variables, function(x) export_obs(variable_modulo = x,
#                                          modulo = "CanopyClearing"))
# # some mass balance variables
# variables = c("E_s_int","SWE","rho","snowmelt_int")
# sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "SnobalCRHM"))
# #more mass balance variables
# variables = c("hru_subl","hru_drift")
# sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "pbsmSnobal"))
# 
# # routing
# variables = c("runoutflow","ssroutflow","gwoutflow")
# sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "Netroute_M"))
# 
# #energy balance
# variables = c("G","H","L_v_E","M","R_n","delta_Q")
# sapply(variables, function(x) export_obs(variable_modulo = x,modulo = "SnobalCRHM"))
# 
# ## evap
# variables = c("hru_actet")
# sapply(variables, function(x) export_obs(variable_modulo = x,
#                                          modulo = "evap"))
# #glacier
# variables = c("glacier_Albedo","glacier_Surf","ice","firn")
# sapply(variables, function(x) export_obs(variable_modulo = x,
#                                          modulo = "glacier"))
# variables = c("ice")
# sapply(variables, function(x) export_obs(variable_modulo = x,
#                                          modulo = "glacier"))
