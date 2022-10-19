# initialise GRASS in your computer

initialise_grass <- function(location = "GRASS_GLACIAR_ECHAURREN",
                             mapset = "PERMANENT",
                             gisDbase = paste0(getwd(), "/GRASS_DB"),
                             home = getwd(),
                             gisBase = "/Applications/GRASS-8.2.app/Contents/Resources",
                             empty_mapset = TRUE
                             ) {
# initialisation of session
initGRASS(
  # path to GRASS installation (use / instead of \ under windows, e.g. "d:/programme/GRASS7.0" )
  gisBase = gisBase,
  # The directory in which to create the .gisrc file
  home = home,
  # GRASS location
  location = location,
  # corresp. mapset
  mapset = mapset,
  # path to 'grassdata' directory containing the location specified above and all corresp. data
  gisDbase = gisDbase ,
  override = TRUE
)
if (empty_mapset) {
#delete all vectors and raster files
execGRASS(
  cmd = "g.remove",
  flags = "f",
  type = "vector,raster",
  pattern = "*"
)
  
}
  
return(TRUE)
}