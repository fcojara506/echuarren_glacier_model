
list_index <- function(lista) {sapply(lista, function(x) grep(paste0("^",x), df_units$time,fixed = F))}

sep_col <- function(df) {
  library(data.table)
  library(dplyr)
  
  df = data.table(df) %>% 
    melt.data.table(id.vars = "datetime") %>%
    .[, c("var", "HRU") := tstrsplit(variable, ".", fixed=TRUE)] %>% 
    .[, HRU:= as.integer(HRU)] %>% 
    .[, value:= as.double(value)] %>% 
    select(-variable)
  
  return(df)
}

areal_avg <- function(df) {
  area_basin = sum(basin_df$area_km2)
  
  df = data.table(df) %>% 
    merge.data.table(basin_df,by="HRU") %>% 
    mutate(value_areaavg = value * area_km2/area_basin) %>% 
    select(datetime,var,value_areaavg,value) %>% 
    group_by(datetime,var) %>% 
    summarise(var_hour=sum(value_areaavg))
  
  return(df)
}
date_YM <- function(df) {
  ## hourly to monthly
  df$date = df$datetime %>% format("%Y-%m-01") %>% as.Date()
  return(df)
  
}
