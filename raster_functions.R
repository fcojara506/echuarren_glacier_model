# mask a raster
raster_with_mask <- function(raster,mask,output) {
  # add mask
  execGRASS(cmd = "r.mask",raster = mask)
  # cut raster given the mask
  execGRASS(cmd = "r.mapcalc",expression = paste0(output,"=",raster))
  #remove mask
  execGRASS("r.mask", flags = "r")
}