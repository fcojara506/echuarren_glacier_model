create_streams <- function(input_dem = "dem_rect",
                           output_stream = "streams",
                           watershed_threshold = 500,
                           mask = NULL) {

  # derive streams and drainage to define watershed
  execGRASS(
    cmd = "r.watershed",
    flags = "overwrite",
    elevation = input_dem,
    threshold = watershed_threshold,
    stream = output_stream,
    intern = T
  )
  
  if (!is.null(mask)) {
    source("base/raster_functions.R")
    raster_with_mask(raster = output_stream, mask = mask, output = output_stream)
  }
  
  return(TRUE)
}

buffer_streams <- function(buffer_distance = 50,
                           input = "streams",
                           output = "streams_buffer") {
  # create river buffer
  execGRASS(
    cmd = "r.thin",
    flags = "overwrite",
    input = input,
    output = "streams_thin",
    intern = T
  )
  
  execGRASS(
    cmd = "r.to.vect",
    flags = "overwrite",
    input = "streams_thin",
    output = "streams",
    type = "line",
    intern = T
  )
  execGRASS(
    cmd = "v.buffer",
    flags = "overwrite",
    input = "streams",
    output = output,
    distance = buffer_distance,
    intern = T
  )
  
  execGRASS(
    cmd = "v.to.rast",
    flags = "overwrite",
    input = output,
    use = "cat",
    output = output,
    intern = T
  )
  #remove temporal rasters
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "raster",
    name = c("streams_thin"),
    intern = T
  )
  #remove temporal vectors
  execGRASS(
    cmd = "g.remove",
    flags = "f",
    type = "vector",
    name = c("streams", "streams_buffer"),
    intern = T
  )
  
  return(TRUE)
}

stream_distance <- function(input_stream="streams",
                            input_drenaige = "drenaige",
                            input_elevation = "dem_rect",
                            method_updown="downstream",
                            output_distance = "stream_distance",
                            output_elevation_difference = "stream_elevation_dif",
                            addon_path ="/Users/fco/Library/GRASS/8.2/Addons/bin/"
) {
  
  execGRASS(cmd = paste0(addon_path, "r.stream.distance"),
            flags = c("overwrite"),
            stream_rast = input_stream,
            direction = input_drenaige,
            method = method_updown,
            elevation = input_elevation,
            distance = output_distance,
            difference = output_elevation_difference,
            intern = T
  )
  
}

stream_order <- function(input_stream="streams",
                         input_drainage = "drainage",
                         input_elevation = "dem_rect",
                         addon_path ="/Users/fco/Library/GRASS/8.2/Addons/bin/",
                         ...
) {
  
  execGRASS(cmd = paste0(addon_path, "r.stream.order"),
            flags = "overwrite",
            stream_rast=input_stream,
            direction=input_drainage,
            elevation=input_elevation,
            ...,
            intern = T)
 
}

stream_segments <- function(input_stream="streams",
                            input_drainage = "drainage",
                            input_elevation = "dem_rect",
                            stream_segment = "stream_segments",
                            stream_sectors = "stream_sectors",
                            addon_path ="/Users/fco/Library/GRASS/8.2/Addons/bin/") {


  execGRASS(cmd = paste0(addon_path, "r.stream.segment"),
            flags = "overwrite",
            stream_rast=input_stream,
            direction=input_drainage,
            elevation=input_elevation,
            segments=stream_segment,
            sectors =stream_sectors,
            intern = T)
  
  return(T)
  
}

buffer_per_segment <- function(
    stream_input = "stream_segments",
    output = "stream_buffer",
    distance = 10,
    vector_to_raster = F) {
  
 cats = execGRASS(cmd = "v.category",
                  input = stream_input,
                  option= "print",
                  intern = TRUE
                  )
 remove_pattern(pattern = "stream_buffe*",type = "raster,vector")
 
 for (cat in cats) {
   
   execGRASS(cmd = "v.buffer",
             flags = c("t","overwrite"),
             input = stream_input,
             cats = cat,
             distance = distance,
             output= paste0(output,"_t",cat),
             intern = TRUE
             )
   
 }
 
   execGRASS(cmd = "v.patch",
             input = paste0(output,"_t",cats),
             output = output,
             intern = T
             )
   if (vector_to_raster) {
     
     execGRASS("v.to.rast",
               flags = "overwrite",
               use = "cat",
               input = output,
               output = output)
     
     execGRASS("r.grow",
               flags = "overwrite",
               input = output,
               output = output,

               metric = "maximum")
   }
   #delete all vectors and raster files
   execGRASS(
     cmd = "g.remove",
     flags = "f",
     type = "vector",
     pattern = paste0(output,"_t*")
   )
   
   
   return(TRUE)
}

buffer_to_segments <- function(input = "stream_buffer", output = "stream_buffer") {
  
    
    execGRASS("v.to.rast",
              flags = "overwrite",
              use = "cat",
              input = input,
              output = output,
              intern = T)
    
    execGRASS("r.grow",
              flags = "overwrite",
              input = output,
              output = output,
              intern = T)
  
}
