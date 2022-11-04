rm(list = ls())
library(rgrass)

#load local functions
source("base/initialise_grass.R")
source("base/define_region_extension.R")
source("base/dem_operations.R")
source("base/import_landcover.R")
source("base/create_hru.R")
source("base/raster_functions.R")

#setting paths to start grass gis using R
initialise_grass(empty_mapset = TRUE)

#define region extension
region_extension(
  n = "6287000",
  s = "6280000",
  e = "400000",
  w = "392000",
  res = "12.5"
)

# create sub-basins
create_subbasin(
  input_path_dem = "GIS/DEM/AP_27001_FBS_F6500_RT1.dem.tif",
  watershed_threshold = 2000,
  subbasin_name = "subcuencas"
)

#define watershed based on outlet coordinate
delineate_watershed(watershed_name = "cuenca_echaurren",
                    outlet_coordinate = c(396350, 6282680))

# compute slope and aspect (azimuth with respect N)
compute_slope_aspect(
  input_dem = "dem_rect",
  slope = "slope_degree",
  aspect = "aspect_degreeN",
  slope_format = "degree"
)

# create elevation bands from dem
contour_bands(input = "dem_rect",
              output = "bandas_elevacion_100m",
              by = 100)

# create elevation bands from dem
contour_bands(input = "dem_rect",
              output = "bandas_elevacion_200m",
              by = 200)

#create slope bands from slope raster
contour_bands(input = "slope_degree",
              output = "bandas_pendiente",
              by = 12.5)
# create
aspect_to_categories(input = "aspect_degreeN",
                     output = "bandas_orientacion",
                     rules_path = "GIS/rules_aspect_categories")
#import landcover raster
import_landcover(input_path_landcover = "GIS/LandCover CHILE 2014/LC_CHILE_2014_b.tif",
                 output_name = "landcover")

# #import glacier vector to raster
# import_glaciers(input_path_glaciers = "GIS/IPG2022_v1/IPG_2022_v1.shp",
#                 output_name = "glaciers_chile")

#import glacier vector to raster type "GLACIARETE"
import_glaciers(input_path_glaciers = "GIS/IPG2022_v1/IPG_2022_v1.shp",
                output_name = "glaciers_echaurren_GLACIARETE",
                sql_query = paste0("CLASIFICA = 'GLACIARETE'"),
                mask = "cuenca_echaurren")

#import glacier vector to raster type ROCOSO
import_glaciers(input_path_glaciers = "GIS/IPG2022_v1/IPG_2022_v1.shp",
                output_name = "glaciers_echaurren_ROCOSO",
                sql_query = paste0("CLASIFICA = 'GLACIAR ROCOSO'"),
                mask = "cuenca_echaurren")

#import glacier vector to raster
import_glaciers(input_path_glaciers = "GIS/IPG2022_v1/IPG_2022_v1.shp",
                output_name = "glaciers_echaurren",
                mask = "cuenca_echaurren")

source("utils/stream_buffer.R")
source("utils/test_HRU_settings_GLACIER.R")

source("utils/test_HRU_settings.R")
