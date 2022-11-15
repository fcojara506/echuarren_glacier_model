rm(list = ls())
require(CRHMr)
require(lubridate)
require(glue)


rep.col<-function(x,n){matrix(rep(x,each=n), ncol=n, byrow=TRUE)}

create_obs_file_per_variable <- function(meteo_CRHM_variable = "t",
                                         num_obs = 1,
                                         obs_matrix = obs,
                                         date_init = as.character(as.Date(head(obs_matrix$datetime, 1))),
                                         date_end = as.character(as.Date(tail(obs_matrix$datetime, 1))),
                                         output_filename=glue('meteo_data/CRHM_obs_data/obs_test_{meteo_CRHM_variable}.obs')
                                         ) {
  ## date clearing
  asdates_obs = as.Date(obs_matrix$datetime)
  # initial date
  if (date_init != as.character(head(asdates_obs, 1)) ) {
    date_init = max(date_init, as.character(head(asdates_obs, 1)))
  }
  # end date
  if (date_end != as.character(tail(asdates_obs, 1)) ) {
    date_end = min(date_init, as.character(tail(asdates_obs, 1)))
  }
  
  #empty dataframe
  obs_crhm  <-  createObsDataframe(
    start.date = date_init,
    end.date = date_end,
    timestep = 1,
    variables = meteo_CRHM_variable, #c('t','p','rh','u'),
    reps = ncol(obs_matrix)-1,
    timezone = 'etc/GMT+4'
  )

 df = merge(x = obs_crhm,
            y = obs_matrix,
            by="datetime",
            all.x = T)
 
 #remove na columns
 df = df[,colSums(is.na(df)) < nrow(df)]
 
 # interpolate na values
 df = CRHMr::interpolate(obs = df,
                         varcols = seq(1,ncol(df)-1),
                         methods = "spline",
                         maxlength = 24*5,
                         quiet = T,
                         logfile = "")
 
 #define column names
 names(df) = names(obs_crhm)
 
 # format dates to CRHM
 df = trimObs(obs = df)
 
  exec =
    writeObsFile(
      comment = "observaciones glaciar echaurren",
      obs = df,
      obsfile = output_filename
    )
  
  return(df)
}

#read observation data
obs = readRDS(file = "meteo_data/obs_20221115.RDS")

CRHM_var_OBS_col = list(
  "t" = c("temperatura_aire_celsius"),
  "p" = c("precipitacion_invervalo_mm"),
  "u" = c("velocidad_viento_ms"),
  "Qsi"= c("SW_incidente_wattm2"),
  "Qli"= c("LW_incidente_wattm2"),
  "rh" = c("humedad_relativa_porcentaje")
)

CRHM_var_OBS_num = list(
  "t" = 48,
  "p" = 1,
  "u" = 1,
  "Qsi"= 48,
  "Qli"= 48,
  "rh" = 48
)

for (var_CRHM in names(CRHM_var_OBS_col)) {
  

df = create_obs_file_per_variable(
  date_init = "2022-03-01",
  meteo_CRHM_variable = var_CRHM,
  obs_matrix = obs[,c("datetime",rep(CRHM_var_OBS_col[[var_CRHM]],
                                     CRHM_var_OBS_num[[var_CRHM]]))]
  )

}

#CRHMr::trimObs()