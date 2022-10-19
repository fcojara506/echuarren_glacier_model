create_hru <- function(
    mask = "cuenca_echaurren",
    category_rasters = c("landcover", "glaciers_chile","subcuencas"),
    keep_raster = "streams_buffer",
    output = "HRU") {
  
  execGRASS("r.mask",
            flags = "overwrite",
            raster = mask)
  # merge svc and eha
  execGRASS(
    cmd = "r.cross",
    flags = "overwrite",
    input = paste(category_rasters,sep = ","),
    output = "HRU_t1"
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
    value = 1,
    mode = "lesser",
    method = "rmarea"
  )
  
  # add river areas
  execGRASS(
    cmd = "r.patch",
    flags = "overwrite",
    input = paste(keep_raster,"HRU_t3",sep = ","),
    #order matters
    output = "HRU_t4"
  )
  
  execGRASS(
    cmd = "r.reclass.area",
    flags = "overwrite",
    input = "HRU_t4",
    output = output,
    value = 1,
    mode = "lesser",
    method = "rmarea"
  )
  
  execGRASS(cmd = "g.remove",
            flags = "f",
            type = "raster",
            pattern = "HRU_t*")
  
  cat_HRU = execGRASS("r.category", map = output, intern = T)
  #remove mask
  execGRASS("r.mask", flags = "r")
  
  return(cat_HRU)
  
}

raster_to_vector <- function(hru_name) {
  
  execGRASS(cmd = "r.to.vect",
            input = hru_name,
            output = hru_name,
            type = "area")
  
}
