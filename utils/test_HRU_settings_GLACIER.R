library(rgrass)

# create elevation bands from dem
contour_bands(input = "dem_rect", output = "bandas_elevacion_25m", by = 25)

#source("utils/preprocess_HRU.R")
#source("utils/test_HRU_settings.R")
remove_pattern(pattern = "HRU_glaciers*",type = "raster,vector")

# create_hru(
#   mask = "glaciers_echaurren",
#   category_rasters = c("bandas_orientacion","bandas_elevacion_25m"),
#   keep_intact = NULL,
#   output = "HRU_glaciers_v1",
#   threshold_min_areas = 0.1,
#   threshold_min_areas_intact = 0.01
# )

create_hru(
  mask = "glaciers_echaurren",
  category_rasters = c("bandas_orientacion","cuenca_echaurren"),
  keep_intact = "bandas_elevacion_25m",
  output = "HRU_glaciers_v2",
  threshold_min_areas = 0.1,
  threshold_min_areas_intact = 0.3
)

#create HRU for glacialised areas
# create_hru(
#   mask = "glaciers_echaurren",
#   category_rasters = c("bandas_orientacion","bandas_elevacion_25m","subcuencas"),
#   keep_intact = NULL,
#   output = "HRU_glaciers_v2",
#   threshold_min_areas = 0.4,
#   threshold_min_areas_intact = 0.01
# )

# create_hru(
#   mask = "glaciers_echaurren",
#   category_rasters =c("drainage","bandas_elevacion_25m"),
#   keep_intact = NULL,
#   output = "HRU_glaciers_v3",
#   threshold_min_areas = 0.4,
#   threshold_min_areas_intact = 0.01
# )

