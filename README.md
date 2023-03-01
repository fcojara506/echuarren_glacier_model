# GRASS GIS Workflow for Hydrological Modeling

This repository contains a workflow for delineation of Hydrologic Response Units (HRU) using GRASS GIS and R. 
A GRASS-Gis project is provided to test the codes.

The workflow includes the following steps:
1. Initialise GRASS GIS environment
2. Define region extension
3. Create sub-basins
4. Delineate watershed based on outlet coordinate
5. Compute slope and aspect
6. Create elevation bands from DEM
7. Create slope bands from slope raster
8. Create aspect categories
9. Import landcover raster
10. Import glacier vector to raster
11. Compute stream buffers
12. Test HRU settings for glacier and non-glacier areas
13. Export vectors and rasters
14. Calculate statistics per HRU


The following software and packages are required to run the workflow:GRASS GIS (version 7 or higher)R (version 3.5 or higher)rgrass7 packageUsageClone the repository or download the files.Open R and set the working directory to the root of the repository.Execute the following code to load local functions:


Requirements
To run this code, you will MUST have the following software installed:

+ R (version 4.2 or later)
+ GRASS GIS (version 7.0 or later)

and R packages:
+ rgrass package (version 0.3-6 or later)

Note: The versions specified above are the minimum versions that have been tested with this code. It is possible that earlier versions of some packages may work, but this has not been tested.


```R
source("base/initialise_grass.R")
source("base/define_region_extension.R")
source("base/dem_operations.R")
source("base/import_landcover.R")
source("base/create_hru.R")
source("base/raster_functions.R")
source("base/export.R")
```
Execute the following code to initialise GRASS GIS environment:

```R
initialise_grass(empty_mapset = TRUE)
```
Execute the following code to define region extension:

```R
region_extension(
  n = "6287000",
  s = "6280000",
  e = "400000",
  w = "392000",
  res = "12.5"
)
```
Execute the following code to create sub-basins:


```R
create_subbasin(
  input_path_dem = "GIS/DEM/AP_27001_FBS_F6500_RT1.dem.tif",
  watershed_threshold = 2000,
  subbasin_name = "subcuencas"
)
```
Execute the following code to delineate watershed based on outlet coordinate
```R
delineate_watershed(watershed_name = "cuenca_echaurren",
                    outlet_coordinate = c(396350, 6282680))
```
Execute the following code to compute slope and aspect
```R
compute_slope_aspect(
  input_dem = "dem_rect",
  slope = "slope_degree",
  aspect = "aspect_degreeN",
  slope_format = "degree"
)
```
Execute the following code to create elevation bands from DEM
```R
contour_bands(input = "dem_rect",
              output = "bandas_elevacion_100m",
              by = 100)
```
Execute the following code to create slope bands from slope raster
```R
contour_bands(input = "slope_degree",
              output = "bandas_pendiente",
              by = 12.5)
```
Execute the following code to create aspect categories
```R
aspect_to_categories(input = "aspect_degreeN",
                     output = "bandas_orientacion",
                     rules_path = "GIS/rules_aspect_categories")
```
Execute the following code to import landcover raster
```R
import_landcover(input_path_landcover = "GIS/LandCover CHILE 2014/LC_CHILE_2014_b.tif",
                 output_name = "landcover")
```
Execute the following code to import glacier vector to raster
```R

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
                
```



