# testing HRU configurations
remove_pattern(pattern = "HRU_v*",
               type = "raster,vector")

#mix aspect and elevation in categories
create_hru(
  mask = "cuenca_echaurren",
  category_rasters = c("bandas_orientacion","bandas_elevacion_200m"),
  threshold_min_areas = 4,
  keep_intact = NULL,
  threshold_min_areas_intact = 0,
  output = "HRU_v0",
  remove_tmp = TRUE,
  raster_to_vector = TRUE
)

# add stream HRU
patch_HRU_rasters(input_rasters = c("stream_buffer","HRU_v0"),
                  output = "HRU_v1",
                  raster_to_vector = T,
                  threshold_clean = 0.5)

#add glaciers
patch_HRU_rasters(input_rasters = c("glaciers_echaurren","HRU_v1"),
                  output = "HRU_v2_0",
                  raster_to_vector = T,
                  threshold_clean = 0.5)

#add glaciers with bands on "GLACIARETE"
patch_HRU_rasters(input_rasters = c("HRU_GLACIAR","HRU_v1"),
                  output = "HRU_v2_1",
                  raster_to_vector = T,
                  threshold_clean = 0.5)
