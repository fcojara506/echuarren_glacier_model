library(CRHMr)
rm(list = ls())
prj_filename_in = "modelo_crhm_glaciar_echaurren.prj"
num_hru = 48

set_unique_parameter <- function(parameter_name = "Ht",
                                 unique_value = 0,
                                 num_hru = num_hru,
                                 prj_filename_in = prj_filename_in) {
  
  parameter_value = rep(unique_value,num_hru)
  CRHMr::readPrjParameters(prjFile = prj_filename_in,
                           paramName = parameter_name)
  
  CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
                          paramName = parameter_name,
                          paramVals = parameter_value)
}
##---------------------------------------------------------------
##                            basin                             -
##---------------------------------------------------------------
source("utils/set_basin_parameters_CRHM.R")

##----------------------------------------------------------------
##                            global                             -
##----------------------------------------------------------------
par_name_value = list(
  "Ht"=0
)

for (parameter in names(par_name_value)) {
  
set_unique_parameter(parameter_name = parameter,
                     unique_value = par_name_value[[parameter]],
                     num_hru =num_hru,
                      prj_filename_in = prj_filename_in)
}




##---------------------------------------------------------------
##                              obs                             -
##---------------------------------------------------------------

a=CRHMr::readPrjParameters(prjFile = prj_filename_in,
                           paramName = "HRU_OBS")

obs_order =c(
  seq(1,48),
  rep(1,48),
  rep(1,48),
  seq(1,48),
  seq(1,48))

CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
                        paramName = "HRU_OBS",
                        paramVals = obs_order)


##----------------------------------------------------------------
##                          K_Estimate                           -
##----------------------------------------------------------------




##---------------------------------------------------------------
##                            calcsun                           -
##---------------------------------------------------------------




##---------------------------------------------------------------
##                          Slope_Qsi                           -
##---------------------------------------------------------------




##----------------------------------------------------------------
##                            longVt                             -
##----------------------------------------------------------------



##----------------------------------------------------------------
##                            netall                             -
##----------------------------------------------------------------




##---------------------------------------------------------------
##                            glacier                           -
##---------------------------------------------------------------




##----------------------------------------------------------------
##                              evap                             -
##----------------------------------------------------------------



##----------------------------------------------------------------
##                            SWESlope                           -
##----------------------------------------------------------------




##----------------------------------------------------------------
##                        CanopyClearing                         -
##----------------------------------------------------------------




##----------------------------------------------------------------
##                        albedo_Richard                         -
##----------------------------------------------------------------
par_name_value = list(
  "Albedo_Snow"= 0.9,
  "amax" = 0.9
)

for (parameter in names(par_name_value)) {
  
  set_unique_parameter(parameter_name = parameter,
                       unique_value = par_name_value[[parameter]],
                       num_hru =num_hru,
                       prj_filename_in = prj_filename_in)
}
#CRHMr::readPrjParameters(prjFile = prj_filename_in,
#                         paramName = "Albedo_Snow")



##----------------------------------------------------------------
##                          pbsmSnobal                           -
##----------------------------------------------------------------




##----------------------------------------------------------------
##                          SnobalCRHM                           -
##----------------------------------------------------------------




##---------------------------------------------------------------
##                      PrairieInfiltration                     -
##---------------------------------------------------------------




##----------------------------------------------------------------
##                              Soil                             -
##----------------------------------------------------------------


##----------------------------------------------------------------
##                          Netroute_M                           -
##----------------------------------------------------------------

#modules = CRHMr::readPrjModuleNames(prjFile = prj_filename_in)$module
#lapply(modules,function(x) bannerCommenter::boxup(x))


