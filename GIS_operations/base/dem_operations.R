create_subbasin <-
  function(input_path_dem = "GIS/DEM/AP_27001_FBS_F6500_RT1.dem.tif",
           watershed_threshold = 2000,
           subbasin_name = "eha") {
    # import file DEM 12.5m
    execGRASS(
      cmd = "r.in.gdal",
      flags = c("overwrite", "r"),
      input = input_path_dem,
      output = "dem_rect",
      intern = T
    )
    
    # derive streams and drainage direction to define watershed
    execGRASS(
      cmd = "r.watershed",
      elevation = "dem_rect",
      threshold = watershed_threshold,
      half_basin = "eha_t1",
      drainage = "drainage",
      intern = T
    )
    
    #remove fragments
    execGRASS(
      cmd = "r.reclass.area",
      input = "eha_t1",
      mode = "greater",
      value = 1,
      output = "eha_t2",
      intern = T
    )
    # grow EHA map to fill gaps resulted from remove of fragments
    execGRASS(
      cmd = "r.grow",
      input = "eha_t2",
      output = "eha_t3",
      radius = 25,
      flags = "overwrite",
      intern = T
    )
    # r.grow converts type CELL to type DCELL; convert back to CELL
    execGRASS(
      cmd = "r.mapcalc",
      flags = "overwrite",
      expression = paste0(subbasin_name, "= int(eha_t3)"),
      intern = T
    )
    
    # remove temporal rasters
    execGRASS(
      cmd = "g.remove",
      flags = "f",
      type = "raster",
      name = c("eha_t1", "eha_t2", "eha_t3"),
      intern = T
    )
    return(TRUE)
  }


delineate_watershed <- function(watershed_name = "cuenca_echaurren",
                                outlet_coordinate = c(396350, 6282680)) {
  # delineate watershed
  execGRASS(
    cmd = "r.water.outlet",
    flags = "overwrite",
    input = "drainage",
    output = watershed_name,
    coordinates = outlet_coordinate,#c(396343,6282693)# c(3963438,6282679),
    intern = T
  )
  return(TRUE)
}



compute_slope_aspect <- function(input_dem = "dem_rect",
                                 slope = "slope",
                                 aspect = "aspect",
                                 slope_format = "degree") {
  execGRASS(
    cmd = "r.slope.aspect",
    flags = c("overwrite","n"),
    elevation = input_dem,
    slope = slope,
    aspect = aspect,
    format = slope_format,
    intern = T
  )
  
}

aspect_to_categories <- function(
    input="aspect_degreeN",
    output="aspect_4_directions",
    rules_path = "GIS/rules_aspect_categories"
    ) {
  
  #create 4 categories
    execGRASS(
      cmd = "r.mapcalc",
      expression =
        glue::glue(
          "{output} = eval( \\
     if({input} >=0. && {input} < 45., 1)  \\
   + if({input} >=45. && {input} < 135., 2) \\
   + if({input} >=135. && {input} < 225., 3) \\
   + if({input} >=225. && {input} < 315., 4) \\
   + if({input} >=315., 1) \\
)"
        ),
      intern = T
    )
  
    # assign words to each numerical category
    execGRASS(
      cmd = "r.category",
      map = output,
      separator = "comma",
      rules = rules_path,
      intern = T
    )
    
  }
  
contour_bands <- function(input = "dem_rect",
                          output = "dem_contour",
                          by = 500) {
  
  execGRASS(
    cmd = "r.mapcalc",
    flags = "overwrite",
    expression = paste0(
      output,
      "=round(",
      input,
      "/",
      by,
      ")*",
      by
    ),
    intern = T
  )
  
}
