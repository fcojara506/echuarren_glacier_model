rm(list = ls())
library(CRHMr)
library(dplyr)


# index matrix identifying HRU position of glaciers
set_glacier_type_HRU <- function() {
  
num_hru = 48
index_hru_glaciar    = c(2,3,5,7,11,18,19,20,21)
index_hru_rocoso     = c(36,43,14)
index_hru_no_glaciar = setdiff(seq(1,num_hru),
                         c(index_hru_glaciar,
                           index_hru_rocoso))

index_matrix_type = matrix(data = 0,
                  nrow = 3,
                  ncol = num_hru)

#assign "one" to index based on glacier type
index_matrix_type[1,index_hru_no_glaciar] = 1
index_matrix_type[2,index_hru_glaciar] = 1 
index_matrix_type[3,index_hru_rocoso] = 1

rownames(index_matrix_type) = c("no_glacier",
                       "white_glacier",
                       "covered_glacier")
return(index_matrix_type)
}
apply_par_glaciers <- function(
    parameter_name,
    parameters = c(0,1,2),
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
  #(1) NO glacier
  #(2) white glacier (debris-free glacier)
  #(3) debris covered or rock glacier
  
##---------------------------------------------------------------
##                            glacier                           -
##---------------------------------------------------------------
"Elev_Adj_glacier_surf" = c(0,1,1),
"firnstorage" = c(0,0.5,0.5),
"firn_Albedo" = c(0.75,0.6,0.6), # Maria 0.75 white
"firn_dens_init" = c(0,450,450),
"firn_h_init" = c(0,0,0),
"inhibit_firnmelt" = c(0,0,0),
"inhibit_icenmelt" = c(0,0,0),
"iceLag" = c(0,0,0),
"icestorage" = c(0,3,4), #Maria 2.2, 3.9 default 0.1
"ice_Albedo" = c(0,0.92,0.2),
"ice_dens" = c(950,950,950),
"SWEAA" = c(0.3,0.5,0.5),
"TKMA" = c(5,-1,-1),
"use_debris" = c(0,0,1),
"debris_h" = c(0,0,0.4),
"ice_init" = c(0,0,0)
)




#set a unique value for each HRU
prj_filename_in = "modelo_crhm_glaciar_echaurren_v2.prj"
num_layers = 3
index_matrix_type = set_glacier_type_HRU()
# set all the values in the list
for (parameter in names(par_name_value)) {
  message(parameter)
  
  layered_parameters = c("firn_dens_init","firn_h_init")
  num_rep = ifelse(parameter %in% layered_parameters,num_layers,1)
  index_matrix_type_rep = matrix(rep(index_matrix_type,num_rep),nrow=3)
  
  apply_par_glaciers(
    parameter_name = parameter,
    parameters = par_name_value[[parameter]],
    index_matrix_type = index_matrix_type_rep,
    prj_filename_in = prj_filename_in
  )
  
}
# 
# ######### ice init in mm #################
# IceInit_HRU = read.csv2(
#   file = "basin_data/info_glaciares_echaurren_HRU.csv",
#   sep = ",") %>% arrange(HRU)
# 
# CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
#                         paramName = "ice_init",
#                         paramVals = IceInit_HRU$IceInit_mm,
#                         quiet = F)
