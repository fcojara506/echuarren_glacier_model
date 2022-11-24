read_filename <- function(filename,column_names) {
  # get parameters id from filename
  parameter_id = filename %>%
    stringr::str_split(string = .,
                       pattern = "/",
                       simplify = T) %>%
    .[, ncol(.)] %>%
    gsub(".csv", "", .)
  
  #match name using column names
  parameter_name = subset(column_names, id == parameter_id)
  
  #read file
  df = read.csv(filename) %>%
    rename(datetime = fecmed) %>%
    rename(!!parameter_name$nombre := medici) 
  
  
  return(df)
  
}

merge_files_to_columns <- function(meteo_file_list,column_names) {
  
  #merge all the files based on datetime (time stamps)
  df = Reduce(
    f = function(df1, df2)
      merge(df1, df2, by = "datetime",all = T),
    x = lapply(X = meteo_file_list,
               FUN = function(x)  read_filename(filename = x,column_names=column_names)
    )
  ) %>% 
    #change datetime format
    mutate(datetime =  as.POSIXct(datetime,
                                  format="%d/%m/%Y %H:%M:%S",
                                  tz="etc/GMT+4")) %>% 
    arrange(datetime)

  
  
  return(df)
}

read_filename_10m_to_hourly <- function(filename = "meteo_data/VALLE ECHAURREN/Valle Echaurren Histórico/Valle_Echaurren_historico_2014_2020.csv") {
  
  df = read.csv(file = filename,sep = ",") %>% 
    #change datetime format
    mutate(datetime =  as.POSIXct(datetime,
                                  format="%Y/%m/%d %H:%M",
                                  tz="etc/GMT+4")) %>% 
    arrange(datetime)
  df = df[!duplicated(df), ]
  df = df[lubridate::year(df$datetime)>2013,]
  df$datetime =  lubridate::ceiling_date(x = df$datetime, unit="hour")
  
    df_hourly = aggregate(
      x = df,
      by = list(df$datetime),
      FUN = mean) %>% 
      select(-datetime) %>% 
    rename(datetime = Group.1) %>%
      mutate(datetime = as.POSIXct(datetime))
  return(df_hourly)
  }

