# mask a raster
raster_with_mask <- function(raster,mask,output) {
  # add mask
  execGRASS(cmd = "r.mask",
            raster = mask,
            flags = "overwrite",
            intern = T)
  # cut raster given the mask
  execGRASS(cmd = "r.mapcalc",
            expression = paste0(output,"=",raster),
            flags = "overwrite",
            intern = T)
  #remove mask
  execGRASS(cmd = "r.mask",
            flags = "r",
            intern = T)
}

raster_to_vector <- function(input,output=input,...) {
  
  execGRASS(cmd = "r.to.vect",
            input = input,
            output = output,
            intern = T,
            ...)
  
}

raster_stats <- function(base = "HRU",
                         cover = "dem_rect",
                         method = "average",
                         output = paste0(base,"_",cover)) {
  print(output)
  execGRASS( cmd = "r.stats.zonal",
             flags = "overwrite",
             base = base,
             cover = cover,
             method = method,
             output = output,
             intern = T)
}

remove_pattern <- function(pattern="*",type = paste0("vector","raster")) {

#delete all vectors and raster files
execGRASS(
  cmd = "g.remove",
  flags = "f",
  type = type,
  pattern = pattern
)
  
}
