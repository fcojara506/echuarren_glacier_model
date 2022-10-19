region_extension <- function(n = "6287000",
                             s = "6280000",
                             e = "400000",
                             w = "392000",
                             res = "12.5"
) {
  # define extension of grass-gis region
  execGRASS(
    cmd = "g.region",
    n = n,
    s = s,
    e = e,
    w = w,
    res = res,
    flags = "a"
  )
  return(TRUE)
}