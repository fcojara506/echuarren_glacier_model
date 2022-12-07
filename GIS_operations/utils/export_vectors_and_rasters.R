vector_list =
  execGRASS(cmd = "g.list",
            type = "vector",
            intern = T)

raster_list = 
  execGRASS(cmd = "g.list",
            type = "raster",
            intern = T)

sapply(vector_list, function(x) export_file(input = x,type ="vector",directory = paste0(getwd(),"/GIS/outputs/vectores")))
sapply(raster_list, function(x) export_file(input = x,type ="raster",directory = paste0(getwd(),"/GIS/outputs/rasters")))

       