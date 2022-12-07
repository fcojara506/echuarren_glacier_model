library(rgrass)

# create elevation bands from dem
contour_bands(input = "dem_rect",
              output = "bandas_elevacion_50m",
              by = 50)

remove_pattern(pattern = "HRU_glaciers*",
               type = "raster,vector")

#create HRU based on category raster masked for the glaciers
create_hru(
  mask = "glaciers_echaurren_GLACIARETE",
  category_rasters = c("bandas_orientacion","cuenca_echaurren"),
  threshold_min_areas = 0.3,
  keep_intact = "bandas_elevacion_50m",
  threshold_min_areas_intact = 0.1,
  output = "HRU_GLACIARETE"
)

create_hru(
  mask = "glaciers_echaurren",
  category_rasters = c("HRU_GLACIARETE","cuenca_echaurren"),
  threshold_min_areas = 0.5,
  keep_intact = "glaciers_echaurren_ROCOSO",
  threshold_min_areas_intact = 0.1,
  output = "HRU_GLACIAR"
)
