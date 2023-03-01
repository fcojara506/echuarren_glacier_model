
#GRASS GIS Workflow for Hydrological Modeling

This repository contains a workflow for hydrological modeling using GRASS GIS and R. The workflow includes the following steps:Initialise GRASS GIS environmentDefine region extensionCreate sub-basinsDelineate watershed based on outlet coordinateCompute slope and aspectCreate elevation bands from DEMCreate slope bands from slope rasterCreate aspect categoriesImport landcover rasterImport glacier vector to rasterCompute stream buffersTest HRU settings for glacier and non-glacier areasExport vectors and rastersCalculate statistics per HRUPrerequisites

The following software and packages are required to run the workflow:GRASS GIS (version 7 or higher)R (version 3.5 or higher)rgrass7 packageUsageClone the repository or download the files.Open R and set the working directory to the root of the repository.Execute the following code to load local functions:R



```R
source("base/initialise_grass.R")
source("base/define_region_extension.R")
source("base/dem_operations.R")
source("base/import_landcover.R")
source("base/create_hru.R")
source("base/raster_functions.R")
source("base/export.R")
```Execute the following code to initialise GRASS GIS environment:R
```R
initialise_grass(empty_mapset = TRUE)
```Execute the following code to define region extension:R
```R
region_extension(
  n = "6287000",
  s = "6280000",
  e = "400000",
  w = "392000",
  res = "12.5"
)
```Execute the following code to create sub-basins:R
```R
create_subbasin(
  input_path_dem = "GIS/DEM/AP_27001_FBS_F6500_RT1.dem.tif",
  watershed_threshold = 2000,
  subbasin_name = "subcuencas"
)
```Execute the following code to delineate watershed based on outlet coordinate:R
```R
delineate_watershed(watershed_name = "cuenca_echaurren",
                    outlet_coordinate = c(396350, 6282680))
```Execute the following code to compute slope and aspect:R
```R
compute_slope_aspect(
  input_dem = "dem_rect",
  slope = "slope_degree",
  aspect = "aspect_degreeN",
  slope_format = "degree"
)
```Execute the following code to create elevation bands from DEM:R
```R
contour_bands(input = "dem_rect",
              output = "bandas_elevacion_100m",
              by = 100)
```Execute the following code to create slope bands from slope raster:R
```R
contour_bands(input = "slope_degree",
              output = "bandas_pendiente",
              by = 12.5)
```Execute the following code to create aspect categories:R
```R
aspect_to_categories(input = "aspect_degreeN",
                     output = "bandas_orientacion",
                     rules_path = "GIS/rules_aspect_categories")
```Execute the following code to import landcover raster:R
```R
import_landcover(input_path_landcover = "GIS/LandCover CHILE 2014/LC_CHILE_2014_b.tif",
                 output_name = "landcover")
```Execute the following code to import glacier vector to raster:R
```R
import_glaciers(input_path
```



