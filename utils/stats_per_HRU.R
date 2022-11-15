rm(list = ls())
library(dplyr)
source("base/raster_functions.R")
source("base/HRU_stats.R")

#list with raster and output HRU property (e.g average elevation per HRU)
input_rasters =
  list(
    "dem_rect" = "elevacion_msnm",
    "slope_degree" = "pendiente_grados",
    "aspect_degreeN" = "orientacion_grados"
  )
#compute properties and save in dataframe
df = HRU_stats(input_raster =  input_rasters,
               base_HRU = "HRU_v2_1")

#compute gravity center ("centroid") for each HRU
df[["xy"]] =
  get_HRU_centroids(
  input_vector = "HRU_v2_1",
  addon_path = "/Users/fco/Library/GRASS/8.2/Addons/bin/",
  latlon = T
  )

#compute area in km2 of each HRU
df[["area_km2"]] = 
  get_HRU_area(input_vector = "HRU_v2_1")

# merge all properties in columns 
df = Reduce(f = merge, x = df)
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####

df$pendiente_grados = 0

#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
#####
# export data
write.csv2(x = df,
           file = "CRHM_model/basin_data/HRU_basin_properties.csv",row.names = F)

  