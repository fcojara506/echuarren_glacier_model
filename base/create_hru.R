create_hru <- function(mask = "cuenca_echaurren",
                       category_rasters = c("landcover", "glaciers_chile", "subcuencas"),
                       keep_intact = "streams_buffer",
                       output = "HRU",
                       threshold_min_areas = 1,
                       threshold_min_areas_intact = 1,
                       remove_tmp = TRUE,
                       raster_to_vector = TRUE) {
  execGRASS(
    "r.mask",
    flags = c("overwrite", "quiet"),
    raster = mask,
    intern = T
  )
  
  # merge svc and eha
  execGRASS(
    cmd = "r.cross",
    flags = "overwrite",
    input = paste(category_rasters, sep = ","),
    output = "HRU_t1",
    intern = T
  )
  # into numeric
  execGRASS(
    cmd = "r.mapcalc",
    flags = "overwrite",
    expression = paste0("HRU_t2 = abs( HRU_t1 )"),
    intern = T
  )
  
  # remove small areas
  execGRASS(
    cmd = "r.reclass.area",
    flags = "overwrite",
    input = "HRU_t2",
    output = "HRU_t3",
    value = threshold_min_areas,
    mode = "lesser",
    method = "rmarea",
    intern = T
  )
  
  if (!is.null(keep_intact)) {
    # add river areas
    execGRASS(
      cmd = "r.patch",
      flags = "overwrite",
      input = paste(keep_intact, "HRU_t3", sep = ","),
      #order matters
      output = "HRU_t4",
      intern = T
    )
    #remove small areas
    # assign output raster to HRU_t4
    execGRASS(
      cmd = "r.reclass.area",
      flags = "overwrite",
      input = "HRU_t4",
      output = output,
      value = threshold_min_areas_intact,
      mode = "lesser",
      method = "rmarea",
      intern = T
    )
  } else{
    # assign output raster to HRU_t3
    execGRASS(
      cmd = "r.mapcalc",
      flags = "overwrite",
      expression = paste0(output, "=HRU_t3"),
      intern = T
    )
  }
  
  if (remove_tmp) {
    execGRASS(
      cmd = "g.remove",
      flags = "f",
      type = "raster",
      pattern = "HRU_t*",
      intern = T
    )
  }
  
  if (raster_to_vector) {
  
    execGRASS(cmd = "r.to.vect",
              input = output,
              output = output,
              intern = T,
              type = "area",
              flags = "overwrite")
    
  }
  #remove mask
  execGRASS("r.mask", flags = c("r", "quiet"), intern = T)
  
  #cat_HRU = execGRASS("r.category", map = output, intern = T)
  #print(length(cat_HRU))
  
  return(TRUE)
  
}
