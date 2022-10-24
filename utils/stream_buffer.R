source("base/stream_functions.R")

remove_pattern(pattern = "strea*", type = "raster,vector")

# create streams
create_streams(
  input_dem = "dem_rect",
  output_stream = "streams",
  watershed_threshold = 500,
  mask = "cuenca_echaurren"
)

# stream order to create buffer
stream_segments(
  input_stream = "streams",
  input_drainage = "drainage",
  stream_segment = "stream_segments",
  addon_path = "/Users/fco/Library/GRASS/8.2/Addons/bin/"
)

buffer_to_segments(input = "stream_segments",
                   output = "stream_buffer")

# buffer_per_segment(
#   stream_input = "stream_segments",
#   output = "stream_buffer",
#   distance = 15,
#   vector_to_raster = T
# )



# # create raster with distance to nearest river and elevation difference
# stream_distance(
#   input_stream = "streams",
#   input_drenaige = "drainage",
#   input_elevation = "dem_rect",
#   method_updown = "downstream",
#   output_distance = "stream_distance",
#   output_elevation_difference = "stream_elevation_dif",
#   addon_path = "/Users/fco/Library/GRASS/8.2/Addons/bin/"
# )


#create raster with buffer around streams
#buffer_streams(buffer_distance = 10,output = "streams_buffer")