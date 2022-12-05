rm(list = ls())
library(CRHMr)
library(dplyr)


# index matrix identifying HRU position of glaciers
set_soil_type_HRU <- function() {
  
  num_hru = 48
  index_hru_humedal    = c(22,25,28,41,26,27,35,39)
  index_hru_no_humedal = setdiff(seq(1,num_hru),
                                 c(index_hru_humedal))
  
  index_matrix_type = matrix(data = 0,
                             nrow = 2,
                             ncol = num_hru)
  
  #assign "one" to index based on glacier type
  index_matrix_type[1,index_hru_no_humedal] = 1
  index_matrix_type[2,index_hru_humedal] = 1 
  
  rownames(index_matrix_type) = c("no_humedal","humedal")
  return(index_matrix_type)
}

apply_par_suelo <- function(
    parameter_name,
    parameters = c(0,1),
    index_matrix_type = index_matrix_type,
    prj_filename_in
) {
  
  parameter_value = parameters %*% index_matrix_type
  
  CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
                          paramName = parameter_name,
                          paramVals = parameter_value,
                          quiet = F)
  
}



par_name_value = list(
  #parameters in order:
  #(1) NO humedal/suelo
  #(2) humedal
    ##----------------------------------------------------------------
    ##                              evap                             -
    ##----------------------------------------------------------------
    " rs " = c(0, 0.00081), #water :0,#0.00081 grass
    " Ht " = c(0.001,0.1),
    ##---------------------------------------------------------------
    ##                      PrairieInfiltration                     -
    ##---------------------------------------------------------------
    "groundcover" = c(1,3),#1:baresoil
    "texture" = c(1,4), ##########3 revisar c(4,2),
    ##--------------------  --------------------------------------------
    ##                              Soil                             -
    ##----------------------------------------------------------------
    "cov_type" = c(0,2), #0: no vegetation, 1:crop, 2: grasses
    "soil_moist_init" = c(0,250),
    "soil_rechr_init" = c(100,100),
    "soil_moist_max" = c(100,1200), 
    "soil_rechr_max" = c(100,100),#c(100,200),
    "gw_max" = c(0,1000),
    "gw_init"= c(0,500),
    ##----------------------------------------------------------------
    ##                          Netroute_M                           -
    ##----------------------------------------------------------------
    "gwKstorage"= c(1,1),#c(100,100),# 0 days
    "runKstorage" = c(0,4),
    "runLag" = c(0,2),
    "ssrLag" = c(0,0),
    "soil_rechr_ByPass" = c(1,1),#
    ##----------------------------------------------------------------
    ##                          K_Estimate                           -
    ##----------------------------------------------------------------
    "Inhibit_K_set" = c(1,1), #c(0,1)
    ##----------------------------------------------------------------
    ##                        CanopyClearing                         -
    ##----------------------------------------------------------------
    
    " CanopyClearing " = c(1,1),#c(1,0)
    "Sbar" = c(6.6,6.6),
    ##----------------------------------------------------------------
    ##                          pbsmSnobal                           -
    ##----------------------------------------------------------------
    "N_S " = c(1,1)
)


#set a unique value for each HRU
prj_filename_in = "modelo_crhm_glaciar_echaurren_v2.prj"
num_layers = 3
index_matrix_type = set_soil_type_HRU()
# set all the values in the list
for (parameter in names(par_name_value)) {
  message(parameter)
  
  layered_parameters = c("firn_dens_init","firn_h_init")
  num_rep = ifelse(parameter %in% layered_parameters,num_layers,1)
  index_matrix_type_rep = matrix(rep(index_matrix_type,num_rep),nrow=2)
  
  apply_par_suelo(
    parameter_name = parameter,
    parameters = par_name_value[[parameter]],
    index_matrix_type = index_matrix_type_rep,
    prj_filename_in = prj_filename_in
  )
  
}







