create_subbasin <- function(input_path_dem = "GIS/DEM/AP_27001_FBS_F6500_RT1.dem.tif",
                            watershed_threshold = 2000,
                            subbasin_name = "eha") {
  # import file DEM 12.5m
  execGRASS(
    cmd = "r.in.gdal",
    flags = c("overwrite", "r"),
    input = input_path_dem,
    output = "dem_rect"
  )
  
  # derive streams and drainage to define watershed
  execGRASS(
    cmd = "r.watershed",
    elevation = "dem_rect",
    threshold = watershed_threshold,
    half_basin = "eha_t1",
    stream = "streams",
    drainage = "drainage"
  )
  
  #remove fragments
  execGRASS(
    cmd = "r.reclass.area",
    input = "eha_t1",
    mode = "greater",
    value = 1,
    output = "eha_t2"
  )
  # grow EHA map to fill gaps resulted from remove of fragments
  execGRASS(
    cmd = "r.grow",
    input = "eha_t2",
    output = "eha_t3",
    radius = 25,
    flags = "overwrite"
  )
  # r.grow converts type CELL to type DCELL; convert back to CELL
  execGRASS(
    cmd = "r.mapcalc",
    flags = "overwrite",
    expression = paste0(subbasin_name, "= int(eha_t3)")
  )
  
  # remove temporal rasters
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "raster",
    name = c("eha_t1", "eha_t2", "eha_t3")
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
    coordinates = outlet_coordinate#c(396343,6282693)# c(3963438,6282679)
  )
  return(TRUE)
}

buffer_streams <- function(buffer_distance = 50,
                           output = "streams_buffer") {
  # create river buffer
  execGRASS(
    cmd = "r.thin",
    flags = "overwrite",
    input = "streams",
    output = "streams_thin"
  )
  
  execGRASS(
    cmd = "r.to.vect",
    flags = "overwrite",
    input = "streams_thin",
    output = "streams",
    type = "line"
  )
  execGRASS(
    cmd = "v.buffer",
    flags = "overwrite",
    input = "streams",
    output = output,
    distance = buffer_distance
  )
  
  execGRASS(
    cmd = "v.to.rast",
    flags = "overwrite",
    input = output,
    use = "cat",
    output = output
  )
  #remove temporal rasters
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "raster",
    name = c("streams_thin")
  )
  #remove temporal vectors
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "vector",
    name = c("streams", "streams_buffer")
  )
  
  return(TRUE)
}

compute_slope_aspect <- function(input_dem = "dem_rect",
                                 slope = "slope",
                                 aspect = "aspect",
                                 aspect_4_directions = TRUE) {
  execGRASS(
    cmd = "r.slope.aspect",
    elevation = input_dem,
    slope = slope,
    aspect = "ccw_aspect"
  )
  
  # convert angles from CCW from East to CW from North
  # modulus (%) can not be used with floating point aspect values
  #https://grass.osgeo.org/grass82/manuals/r.slope.aspect.html
  execGRASS(cmd = "r.mapcalc",
            expression = paste0(aspect, "=(450 - ccw_aspect ) % 360"))
  
  if (aspect_4_directions) {
    execGRASS(
      cmd = "r.mapcalc",
      expression =
        glue::glue(
          "aspect_4_directions = eval( \\
     if({aspect} >=0. && {aspect} < 45., 1)  \\
   + if({aspect} >=45. && {aspect} < 135., 2) \\
   + if({aspect} >=135. && {aspect} < 225., 3) \\
   + if({aspect} >=225. && {aspect} < 315., 4) \\
   + if({aspect} >=315., 1) \\
)"
        )
    )
    # assign words to each category
    execGRASS(
      cmd = "r.category",
      map = "aspect_4_directions",
      separator = "comma",
      rules = "GIS/rules_aspect_categories"
    )
  }
  
  #remove temporal rasters
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "raster",
    name = c("ccw_aspect")
  )
  
  
}

elevation_bands <- function(input_dem = "dem_rect",
                            output_raster = "dem_contour",
                            elevation_step = 500,
                            minlevel = 0) {
  # create vector contour lines
  execGRASS(
    cmd = "r.contour",
    flags = c("overwrite"),
    input = input_dem,
    output = "contours_vector",
    step = elevation_step,
    minlevel = minlevel
  )
  
  execGRASS(
    cmd = "r.mapcalc",
    expression = paste0(output_raster,"=round(dem_rect@PERMANENT/",elevation_step,")*",elevation_step,")")
  )
  
}
