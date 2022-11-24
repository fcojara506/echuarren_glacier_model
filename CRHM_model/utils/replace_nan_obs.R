rm(list = ls())
require(CRHMr)
require(lubridate)
require(glue)

replace_t <- function() {
filename = "meteo_data/CRHM_obs_data/obs_test_t.obs"

df = readObsFile(obsFile = filename, timezone = 'etc/GMT+4')
nan_values1 = which(is.na(df[,2]))

if (length(nan_values1>0)) {
nan_ym = unique(format(as.Date(df[nan_values1,1]), "%Y-%m"))

# 2016
range_dates_out = c(as.Date("2016-07-10"),as.Date("2016-09-29"))
range_dates_in1 = c(as.Date("2022-07-10"),as.Date("2022-09-29"))
range_dates_in2 = c(as.Date("2021-07-10"),as.Date("2021-09-29"))

index_out = which(df$datetime %between% range_dates_out)
df_out = df[index_out,]             
#df_out= subset(df, datetime %between% range_dates_out)
df_in1 = subset(df, datetime %between% range_dates_in1)
df_in2 = subset(df, datetime %between% range_dates_in2)
df_in = (df_in1[,-1]*0.4+df_in2[,-1]*0.6)
df_in_end = cbind(datetime=df_out$datetime,df_in)

df[index_out,] = df_in_end
nan_values2 = which(is.na(df[,2]))
nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))

## 2017
range_dates_out = c(as.Date("2017-04-26"),as.Date("2017-09-29"))
range_dates_in1 = c(as.Date("2022-04-26"),as.Date("2022-09-29"))
range_dates_in2 = c(as.Date("2021-04-26"),as.Date("2021-09-29"))

index_out = which(df$datetime %between% range_dates_out)
df_out = df[index_out,]             
#df_out= subset(df, datetime %between% range_dates_out)
df_in1 = subset(df, datetime %between% range_dates_in1)
df_in2 = subset(df, datetime %between% range_dates_in2)

df_in_end = cbind(datetime=df_out$datetime,
                  df_in1[,-1]*0.5+df_in2[,-1]*0.5)

df[index_out,] = df_in_end
nan_values2 = which(is.na(df[,2]))
nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))

# 2019
range_dates_out = c(as.Date("2019-05-20"),as.Date("2019-10-31"))
range_dates_in1 = c(as.Date("2022-05-20"),as.Date("2022-10-31"))
range_dates_in2 = c(as.Date("2021-05-20"),as.Date("2021-10-31"))

index_out = which(df$datetime %between% range_dates_out)
df_out = df[index_out,]             
#df_out= subset(df, datetime %between% range_dates_out)
df_in1 = subset(df, datetime %between% range_dates_in1)
df_in2 = subset(df, datetime %between% range_dates_in2)

df_in_end = cbind(datetime=df_out$datetime,
                  df_in1[,-1]*0.4+df_in2[,-1]*0.6)

df[index_out,] = df_in_end
nan_values2 = which(is.na(df[,2]))
nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
CRHMr::writeObsFile(obs = df,
                    obsfile = filename)

return(df)
}
}

replace_u <- function() {
  filename = "meteo_data/CRHM_obs_data/obs_test_u.obs"
  
  df = readObsFile(obsFile = filename, timezone = 'etc/GMT+4')
  nan_values1 = which(is.na(df[,2]))
  if (length(nan_values1>0)) {
    
  
  nan_ym = unique(format(as.Date(df[nan_values1,1]), "%Y-%m"))
  
  # 2019
  range_dates_out = c(as.Date("2019-03-28"),as.Date("2019-12-31"))
  range_dates_in1 = c(as.Date("2020-03-28"),as.Date("2020-12-31"))
  range_dates_in2 = c(as.Date("2018-03-28"),as.Date("2018-12-31"))
  
  index_out = which(df$datetime %between% range_dates_out)
  df_out = df[index_out,]             
  #df_out= subset(df, datetime %between% range_dates_out)
  df_in1 = subset(df, datetime %between% range_dates_in1)
  df_in2 = subset(df, datetime %between% range_dates_in2)
  df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
  df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
  
  df[index_out,] = df_in_end
  nan_values2 = which(is.na(df[,2]))
  nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
  
  ## 2021
  range_dates_out = c(as.Date("2021-04-09"),as.Date("2022-03-01"))
  range_dates_in1 = c(as.Date("2016-04-09"),as.Date("2017-03-01"))
  range_dates_in2 = c(as.Date("2017-04-09"),as.Date("2018-03-01"))
  
  index_out = which(df$datetime %between% range_dates_out)
  df_out = df[index_out,]             
  #df_out= subset(df, datetime %between% range_dates_out)
  df_in1 = subset(df, datetime %between% range_dates_in1)
  df_in2 = subset(df, datetime %between% range_dates_in2)
  
  df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
  df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
  names(df_in_end) = names(df)
  
  df[index_out,] = df_in_end
  nan_values2 = which(is.na(df[,2]))
  nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
  
  CRHMr::writeObsFile(obs = df,obsfile = filename)
  return(df)
  }
  
}

replace_rh <- function() {
  filename = "meteo_data/CRHM_obs_data/obs_test_rh.obs"
  
  df = readObsFile(obsFile = filename, timezone = 'etc/GMT+4')
  nan_values1 = which(is.na(df[,2]))
  if (length(nan_values1>0)) {

    nan_ym = unique(format(as.Date(df[nan_values1,1]), "%Y-%m"))
    
    # 2019
    range_dates_out = c(as.Date("2019-03-28"),as.Date("2019-12-31"))
    range_dates_in1 = c(as.Date("2020-03-28"),as.Date("2020-12-31"))
    range_dates_in2 = c(as.Date("2018-03-28"),as.Date("2018-12-31"))
    
    index_out = which(df$datetime %between% range_dates_out)
    df_out = df[index_out,]             
    #df_out= subset(df, datetime %between% range_dates_out)
    df_in1 = subset(df, datetime %between% range_dates_in1)
    df_in2 = subset(df, datetime %between% range_dates_in2)
    df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
    df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
    
    df[index_out,] = df_in_end
    nan_values2 = which(is.na(df[,2]))
    nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
    
    ## 2021
    range_dates_out = c(as.Date("2021-04-09"),as.Date("2022-03-01"))
    range_dates_in1 = c(as.Date("2016-04-09"),as.Date("2017-03-01"))
    range_dates_in2 = c(as.Date("2017-04-09"),as.Date("2018-03-01"))
    
    index_out = which(df$datetime %between% range_dates_out)
    df_out = df[index_out,]             
    #df_out= subset(df, datetime %between% range_dates_out)
    df_in1 = subset(df, datetime %between% range_dates_in1)
    df_in2 = subset(df, datetime %between% range_dates_in2)
    
    df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
    df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
    names(df_in_end) = names(df)
    
    df[index_out,] = df_in_end
    nan_values2 = which(is.na(df[,2]))
    nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
    
    CRHMr::writeObsFile(obs = df,obsfile = filename)
    return(df)
  }
}

replace_qsi <- function() {
  
    filename = "meteo_data/CRHM_obs_data/obs_test_Qsi.obs"
    
    df = readObsFile(obsFile = filename, timezone = 'etc/GMT+4')
    nan_values1 = which(is.na(df[,2]))
    if (length(nan_values1>0)) {
      
      nan_ym = unique(format(as.Date(df[nan_values1,1]), "%Y-%m"))
      
      # 2019
      range_dates_out = c(as.Date("2019-03-28"),as.Date("2019-12-31"))
      range_dates_in1 = c(as.Date("2020-03-28"),as.Date("2020-12-31"))
      range_dates_in2 = c(as.Date("2018-03-28"),as.Date("2018-12-31"))
      
      index_out = which(df$datetime %between% range_dates_out)
      df_out = df[index_out,]             
      #df_out= subset(df, datetime %between% range_dates_out)
      df_in1 = subset(df, datetime %between% range_dates_in1)
      df_in2 = subset(df, datetime %between% range_dates_in2)
      df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
      df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
      
      df[index_out,] = df_in_end
      nan_values2 = which(is.na(df[,2]))
      nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
      
      ## 2021
      range_dates_out = c(as.Date("2021-04-09"),as.Date("2022-03-01"))
      range_dates_in1 = c(as.Date("2016-04-09"),as.Date("2017-03-01"))
      range_dates_in2 = c(as.Date("2017-04-09"),as.Date("2018-03-01"))
      
      index_out = which(df$datetime %between% range_dates_out)
      df_out = df[index_out,]             
      #df_out= subset(df, datetime %between% range_dates_out)
      df_in1 = subset(df, datetime %between% range_dates_in1)
      df_in2 = subset(df, datetime %between% range_dates_in2)
      
      df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
      df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
      names(df_in_end) = names(df)
      
      df[index_out,] = df_in_end
      nan_values2 = which(is.na(df[,2]))
      nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
      
      CRHMr::writeObsFile(obs = df,obsfile = filename)
      return(df)
    }
  }

replace_qli <- function() {
  
  filename = "meteo_data/CRHM_obs_data/obs_test_Qli.obs"
  
  df = readObsFile(obsFile = filename, timezone = 'etc/GMT+4')
  nan_values1 = which(is.na(df[,2]))
  if (length(nan_values1>0)) {
    
    nan_ym = unique(format(as.Date(df[nan_values1,1]), "%Y-%m"))
    
    # 2019
    range_dates_out = c(as.Date("2019-03-28"),as.Date("2019-12-31"))
    range_dates_in1 = c(as.Date("2020-03-28"),as.Date("2020-12-31"))
    range_dates_in2 = c(as.Date("2018-03-28"),as.Date("2018-12-31"))
    
    index_out = which(df$datetime %between% range_dates_out)
    df_out = df[index_out,]             
    #df_out= subset(df, datetime %between% range_dates_out)
    df_in1 = subset(df, datetime %between% range_dates_in1)
    df_in2 = subset(df, datetime %between% range_dates_in2)
    df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
    df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
    
    df[index_out,] = df_in_end
    nan_values2 = which(is.na(df[,2]))
    nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
    
    ## 2021
    range_dates_out = c(as.Date("2021-04-09"),as.Date("2022-03-01"))
    range_dates_in1 = c(as.Date("2016-04-09"),as.Date("2017-03-01"))
    range_dates_in2 = c(as.Date("2017-04-09"),as.Date("2018-03-01"))
    
    index_out = which(df$datetime %between% range_dates_out)
    df_out = df[index_out,]             
    #df_out= subset(df, datetime %between% range_dates_out)
    df_in1 = subset(df, datetime %between% range_dates_in1)
    df_in2 = subset(df, datetime %between% range_dates_in2)
    
    df_in = (df_in1[,-1]*0.8+df_in2[,-1]*0.2)
    df_in_end = cbind(data.frame(datetime = df_out$datetime),df_in)
    names(df_in_end) = names(df)
    
    df[index_out,] = df_in_end
    nan_values2 = which(is.na(df[,2]))
    nan_ym = unique(format(as.Date(df[nan_values2,1]), "%Y-%m"))
    
    CRHMr::writeObsFile(obs = df,obsfile = filename)
    return(df)
  }
}

replace_t()
replace_u()
replace_rh()
replace_qsi()
replace_qli()
