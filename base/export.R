
export_file <- function(input,type,directory = getwd()) {
  
  if (type == "vector") {
    
    execGRASS(cmd = "v.out.ogr",
              flags = "overwrite",
              input = input,
              output = paste0(directory,"/",input,".gpkg"),
              format = "GPKG")
  }
  
  if (type == "raster") {
    
    execGRASS(cmd = "r.out.gdal",
              flags = "overwrite",
              input = input,
              output = paste0(directory,"/",input,".tif"),
              format = "GTiff")
  }
  message(paste0("Exportando: ",input))
  return(TRUE)
  
}

