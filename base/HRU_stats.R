HRU_stats <- function(input_raster = list(),
                      base_HRU="HRU_v2_1") {
  #initialise blank list with properties per HRU
  df = list()

  if(typeof(input_raster)=="list"){
#loop through properties
for (input_raster in names(input_rasters)) {
  
  output = input_rasters[input_raster][[1]]
  
  #average property by HRU
  raster_stats(
    base = base_HRU,
    cover = input_raster,
    method = "average",
    output = output
  )
  # transform to vector for more readable format
  raster_to_vector(input = output,
                   type = "area",
                   flags = "overwrite")
  # table with data per HRU
  df[[output]] =
    execGRASS(
    cmd = "v.db.select",
    map = output,
    format = "plain",
    intern = T
  ) %>%
    data.frame(data = .) %>%
    tidyr::separate(
      col = "data",
      into = c("HRU", as.character(output)),
      sep = "\\|"
    ) %>%
    .[-1,] %>% 
    sapply( as.numeric ) %>% 
    as.data.frame() %>% 
    arrange(HRU)
  
  #remove_pattern(pattern = output,type = "raster,vector")
}
  }else{
  errorCondition("input needs to be a list")
  }
  

return(df)
}

get_HRU_centroids <- function(input_vector = "HRU_v2_1",
                              addon_path = "/Users/fco/Library/GRASS/8.2/Addons/bin/",
                              latlon = F) {
  
  # center of gravity
  execGRASS(
    cmd = paste0(addon_path, "v.centerpoint"),
    flags = "overwrite",
    input = input_vector,
    output = "centroide",
    intern = T)
  
 execGRASS(
    cmd = "v.out.ascii",
    flags = "overwrite",
    input = "centroide",
    output = "xy",
    format = "point",
    intern = T)
 
 xy =  execGRASS(
   cmd = "v.out.ascii",
   flags = "overwrite",
   input = "centroide",
   format = "point",
   intern = T)
  
  if (latlon) {
    xy = execGRASS(cmd = "m.proj",
              flags = c("o","d"),
              separator = "pipe",
              input = "xy",
              intern = T)
  }else{
    
  }
  
 xy= data.frame(data = xy) %>%
   tidyr::separate(
     col = "data",
     into = c("lon_x","lat_y","HRU"),
     sep = "\\|"
   ) %>% 
   sapply(as.numeric ) %>% 
   as.data.frame() %>% 
   arrange(HRU)
 
 if (file.exists("xy")) {
   #Delete file if it exists
   file.remove("xy")
 }
 
  return(xy)
}

get_HRU_area <- function(input_vector = "HRU_v2_1") {
  
  area = execGRASS(
    cmd = "v.to.db",
    flags = "p",
    map = input_vector,
    option = "area",
    units = "kilometers",
    intern = T)
  
  area = data.frame(data = area) %>%
    tidyr::separate(
      col = "data",
      into = c("HRU","area_km2"),
      sep = "\\|"
    ) %>% 
    .[-1,] %>% 
    sapply(as.numeric ) %>% 
    as.data.frame() %>% 
    arrange(HRU)
    

  return(area)
  
}