import_landcover <- function(
    input_path_landcover = "GIS/LandCover CHILE 2014/LC_CHILE_2014_b.tif",
    output_name = "landcover",
    mask = NULL) {
  
  if (!is.null(mask)) {
    
    execGRASS(
      "r.mask",
      flags = c("overwrite", "quiet"),
      raster = mask,
      intern = T
    )
    
  }
  # land use from ZHAO 2016
  #https://www.sciencedirect.com/science/article/abs/pii/S0034425716302188?via%3Dihub
  #http://www.gep.uchile.cl/Landcover/Landcover%20de%20Chile%20-%20Descripción%20del%20Producto%20-%20GEP%20UCHILE%202016.pdf
  execGRASS(
    cmd = "r.in.gdal",
    flags = c("overwrite", "r"),
    input = input_path_landcover,
    output = "landcover_chile"
  )
  
  # simplify categories within landcover chile
  execGRASS(cmd = "r.mapcalc",
            flags = "overwrite",
            expression = paste0(output_name,"= round(landcover_chile/100)*100")
            )
  #remove landcover_chile
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "raster",
    name = "landcover_chile"
  )
  
  if (!is.null(mask)) {
  #remove mask
  execGRASS("r.mask", flags = c("r", "quiet"), intern = T)
  }
  
  return(TRUE)
}





import_glaciers <- function(
    input_path_glaciers = "GIS/IPG2022_v1/IPG_2022_v1.shp",
    output_name = "glaciers_chile",
    sql_query = "1=1",
    min_area_m2 = 0.0001,
    mask = NULL) {
  

    

  
  # glaciers from inventary
  execGRASS(
    cmd = "v.in.ogr",
    flags = c("overwrite", "r"),
    input = input_path_glaciers,
    where = sql_query,
    output = output_name,
    min_area = min_area_m2
  )
  
  # create glacier raster
  execGRASS(
    cmd = "v.to.rast",
    flags = c("overwrite", "quiet"),
    input = output_name,
    output = output_name,
    use = "cat"
  )
  
  #remove glaciers_chile_vector
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "vector",
    name = output_name
  )
  
  #remove mask
  if (!is.null(mask)) {
    
    execGRASS(
      cmd = "r.mask",
      flags = c("overwrite", "quiet"),
      raster = mask,
      intern = T
    )
    
    execGRASS(cmd = "r.mapcalc",
              flags = "overwrite",
              expression = paste0(output_name, "=", output_name),
              intern = T
              )
    
    execGRASS("r.mask", flags = c("r", "quiet"), intern = T)
    
    }
  
  return(T)
}
