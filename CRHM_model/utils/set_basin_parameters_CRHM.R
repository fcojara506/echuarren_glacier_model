library(CRHMr)
library(dplyr)

prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj"
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")

set_new_parameters <- function(prj_filename,
                               parameter_name,
                               column_df_name,
                               basin_df,
                               round_decimals = 3,
                               verbose = T) {
  new_values = basin_df[, column_df_name] %>%
    unlist() %>%
    round(digits = round_decimals)
  
  success = CRHMr::setPrjParameters(inputPrjFile = prj_filename,
                                    paramName = parameter_name,
                                    paramVals = new_values)
  
  if (verbose) {
    message(prj_filename)
    message(parameter_name)
    
    CRHMr::readPrjParameters(prjFile = prj_filename,
                             paramName = parameter_name) %>%
      print()
  }
  return(success)
}

list_parameter_colum =  list(
  "hru_area" = "area_km2",
  "hru_lat" = "lat_y",
  "hru_elev" = "elevacion_msnm",
  "hru_GSL" = "pendiente_grados",
  "hru_ASL" = "orientacion_grados"
)

#set basin CRHM parameters based on GIS properties
for (parameter in names(list_parameter_colum)) {
  set_new_parameters(
    prj_filename = prj_filename,
    parameter_name = parameter,
    column_df_name = list_parameter_colum[[parameter]],
    basin_df = basin_df,
    verbose = T,
    round_decimals = ifelse(parameter == "hru_lat", 5, 3)
  )
}

#set basin area as the sum of the HRU areas
CRHMr::setPrjParameters(
  inputPrjFile = prj_filename,
  paramName = " basin_area ",
  paramVals = sum(basin_df$area_km2)
)

#set station elevation
CRHMr::setPrjParameters(
  inputPrjFile = prj_filename,
  paramName = "obs_elev",
  paramVals = rep(basin_df[, "elevacion_msnm"] + 2, 2)
)

#set "order" routing
index = arrange(basin_df, -elevacion_msnm)$HRU

orden = seq(length(index))
orden[index] = orden
CRHMr::setPrjParameters(inputPrjFile = prj_filename,
                        paramName = " order ",
                        paramVals = orden)
# routing order
whereto_surface = c(
  4,
  3,
  5,
  8,
  4,
  7,
  11,
  12,
  15,
  7,
  21,
  16,
  23,
  15,
  22,
  28,
  14,
  20,
  18,
  7,
  24,
  35,
  24,
  29,
  27,
  39,
  39,
  26,
  30,
  32,
  33,
  31,
  37,
  29,
  39,
  31,
  41,
  34,
  0,
  38,
  26,
  36,
  31,
  43,
  31,
  31,
  37,
  47
)

CRHMr::setPrjParameters(inputPrjFile = prj_filename,
                        paramName = " whereto ",
                        paramVals = whereto_surface)

CRHMr::setPrjParameters(inputPrjFile = prj_filename,
                        paramName = " gwwhereto ",
                        paramVals = -whereto_surface)

#set station elevation
CRHMr::setPrjParameters(
  inputPrjFile = prj_filename,
  paramName = "route_S0",
  paramVals = basin_df$pendiente_grados/90
)


