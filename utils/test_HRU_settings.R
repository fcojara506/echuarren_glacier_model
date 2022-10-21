# testing HRU configurations
remove_pattern(pattern = "HRU_v*",type = "raster,vector")

create_hru(
  mask = "cuenca_echaurren",
  category_rasters = c("bandas_orientacion","bandas_elevacion"),
  keep_intact = "glaciers_echaurren",
  output = "HRU_v1",
  remove_tmp = TRUE,
  raster_to_vector = TRUE,
  threshold_min_areas = 5,
  threshold_min_areas_intact = 0.01
)

# create_hru(
#   mask = "cuenca_echaurren",
#   category_rasters = c("bandas_orientacion","bandas_elevacion","subcuencas"),
#   keep_intact = "glaciers_echaurren",
#   output = "HRU_v2",
#   remove_tmp = TRUE,
#   raster_to_vector = TRUE,
#   threshold_min_areas = 5,
#   threshold_min_areas_intact = 0.01
# )
# 
# create_hru(
#   mask = "cuenca_echaurren",
#   category_rasters = c("bandas_orientacion","bandas_elevacion"),
#   keep_intact = "glaciers_echaurren",
#   output = "HRU_v3",
#   remove_tmp = TRUE,
#   raster_to_vector = TRUE,
#   threshold_min_areas = 5,
#   threshold_min_areas_intact = 0.01
# )
# 
# create_hru(
#   mask = "cuenca_echaurren",
#   category_rasters = c("bandas_orientacion","bandas_elevacion","streams_buffer"),
#   keep_intact = NULL,
#   output = "HRU_v4",
#   remove_tmp = TRUE,
#   raster_to_vector = TRUE,
#   threshold_min_areas = 5,
#   threshold_min_areas_intact = 0.01
# )
# 
# create_hru(
#   mask = "cuenca_echaurren",
#   category_rasters = c("bandas_orientacion","bandas_elevacion","streams_buffer"),
#   keep_intact = "glaciers_echaurren",
#   output = "HRU_v5",
#   remove_tmp = TRUE,
#   raster_to_vector = TRUE,
#   threshold_min_areas = 5,
#   threshold_min_areas_intact = 0.01
# )
# 
# create_hru(
#   mask = "cuenca_echaurren",
#   category_rasters = c("drainage","subcuencas"),
#   keep_intact = "glaciers_echaurren",
#   output = "HRU_v6",
#   remove_tmp = TRUE,
#   raster_to_vector = TRUE,
#   threshold_min_areas = 5,
#   threshold_min_areas_intact = 0.01
# )
# 
# create_hru(
#   mask = "cuenca_echaurren",
#   category_rasters = c("drainage","bandas_elevacion"),
#   keep_intact = "glaciers_echaurren",
#   output = "HRU_v7",
#   remove_tmp = TRUE,
#   raster_to_vector = TRUE,
#   threshold_min_areas = 5,
#   threshold_min_areas_intact = 0.01
# )

# raster_stats(base = "HRU_v7",cover = "drainage")
# raster_stats(base = "HRU_v7",cover = "stream_distance")
# raster_stats(base = "HRU_v7",cover = "stream_elevation_dif")
