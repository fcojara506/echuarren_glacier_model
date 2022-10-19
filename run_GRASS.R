rm(list = ls())
library(rgrass)

source("initialise_grass.R")
source("region_extension.R")
source("dem_operations.R")
source("import_landcover.R")
source("create_hru.R")

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
  watershed_threshold = 1000,
  subbasin_name = "subcuencas"
)
#define watershed based on outlet coordinate
delineate_watershed(watershed_name = "cuenca_echaurren",
                    outlet_coordinate = c(396350, 6282680))

# compute slope and aspect (azimuth with respect N)
compute_slope_aspect()

# create raster with buffer around streams
buffer_streams(buffer_distance = 25,
               output = "streams_buffer")

#import glacier vector to raster
import_glaciers(input_path_glaciers = "GIS/IPG2022_v1/IPG_2022_v1.shp",
                output_name = "glaciers_chile")
#import landcover raster
import_landcover(input_path_landcover = "GIS/LandCover CHILE 2014/LC_CHILE_2014_b.tif",
                 output_name = "landcover")

# add elevation bands to glaciers




create_hru(
  mask = "cuenca_echaurren",
  category_rasters = c("landcover", "glaciers_chile", "subcuencas","aspect_4_directions"),
  keep_raster = "streams_buffer",
  output = "HRU"
)

create_hru(
  mask = "cuenca_echaurren",
  category_rasters = c("landcover", "glaciers_chile", "subcuencas"),
  keep_raster = "streams_buffer",
  output = "HRU_noaspect"
)

raster_to_vector(hru_name = "HRU")
raster_to_vector(hru_name = "HRU_noaspect")

