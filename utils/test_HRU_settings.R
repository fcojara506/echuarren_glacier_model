# testing HRU configurations
remove_pattern(pattern = "HRU_v*",type = "raster,vector")

create_hru(
  mask = "cuenca_echaurren",
  category_rasters = c("bandas_orientacion","bandas_elevacion_100m"),
  keep_intact = "glaciers_echaurren",
  output = "HRU_v1",
  remove_tmp = TRUE,
  raster_to_vector = TRUE,
  threshold_min_areas = 5,
  threshold_min_areas_intact = 0
)

create_hru(
  mask = "cuenca_echaurren",
  category_rasters = c("bandas_orientacion","bandas_elevacion_100m"),
  keep_intact = "HRU_glaciers_v2",
  output = "HRU_v2",
  remove_tmp = TRUE,
  raster_to_vector = TRUE,
  threshold_min_areas = 5,
  threshold_min_areas_intact = 0.01
)

create_hru(
  mask = "cuenca_echaurren",
  category_rasters = c("bandas_orientacion","bandas_elevacion_100m"),
  keep_intact = c("HRU_glaciers_v2","stream_buffer"),
  output = "HRU_v3",
  remove_tmp = TRUE,
  raster_to_vector = TRUE,
  threshold_min_areas = 5,
  threshold_min_areas_intact = 0.01
)

