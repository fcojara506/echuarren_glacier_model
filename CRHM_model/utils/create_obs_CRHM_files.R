rm(list = ls())
require(CRHMr)
require(lubridate)
require(glue)

rep.col<-function(x,n){matrix(rep(x,each=n), ncol=n, byrow=TRUE)}

create_obs_file_per_variable <- function(meteo_CRHM_variable = "t",
                                         num_obs = 1,
                                         obs_matrix = obs,
                                         remove_negatives = T,
                                         date_init = as.character(as.Date(head(obs_matrix$datetime, 1))),
                                         date_end = as.character(as.Date(tail(obs_matrix$datetime, 1))),
                                         output_filename=glue('meteo_data/CRHM_obs_data/obs_test_{meteo_CRHM_variable}.obs'),
                                         interpolate_na = T
                                         ) {
  ## date clearing
  asdates_obs = as.Date(obs_matrix$datetime)
  # initial date
  if (date_init != as.character(head(asdates_obs, 1)) ) {
    date_init = max(date_init, as.character(head(asdates_obs, 1)))
  }
  # end date
  if (date_end != as.character(tail(asdates_obs, 1)) ) {
    date_end = date_end#min(date_end, as.character(tail(asdates_obs, 1)))
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
 
 if (interpolate_na) {
   
   if (meteo_CRHM_variable == "p") {
     df[is.na(df)] <- 0
   }else{
 # interpolate na values
 df = CRHMr::interpolate(obs = df,
                         varcols = seq(1,ncol(df)-1),
                         methods = "linear",
                         maxlength = 24*10,
                         quiet = T,
                         logfile = "")
   }
 }
 #remove negatives after interpolation
 if (remove_negatives) {
   df[df<0]=0
 }
 
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
obs = readRDS(file = "meteo_data/obs_20221123.RDS")

CRHM_var_OBS_col = list(
  #"p" = c("precipitacion_invervalo_mm"),
  "u" = c("velocidad_viento_ms"),
  "Qli"= c("LW_incidente_wattm2"),
  "rh" = c("humedad_relativa_porcentaje"),
  "Qsi"= c("SW_incidente_wattm2")
  #"h_snow" = c("profundidad_nieve_m")
)

CRHM_var_OBS_num = list(
  #"p" = 1,
  "u" = 1,
  "Qsi"= 48,
  "Qli"= 48,
  "rh" = 48
)

for (var_CRHM in names(CRHM_var_OBS_col)) {
  
df = create_obs_file_per_variable(
  date_init = "2016-04-01",
  date_end = "2022-11-05",
  meteo_CRHM_variable = var_CRHM,
  remove_negatives = ifelse(var_CRHM=="t",F,T),
  obs_matrix = obs[,c("datetime",rep(CRHM_var_OBS_col[[var_CRHM]],
                                     CRHM_var_OBS_num[[var_CRHM]]))]
  )

}

#temperature
tem = readRDS(file = "meteo_data/tem_20221123.RDS")

df1 = create_obs_file_per_variable(
  date_init = "2016-04-01",
  date_end = "2022-11-05",
  meteo_CRHM_variable = "t",
  remove_negatives = F,
  obs_matrix = tem
)

# ERA5 precipitation
#temperature
pERA5 = readRDS(file = "meteo_data/p_ERA5_20221123.RDS")

df2 = create_obs_file_per_variable(
  date_init = "2016-04-01",
  date_end = "2022-11-05",
  meteo_CRHM_variable = "p",
  remove_negatives = T,
  obs_matrix = pERA5,
  interpolate_na = T
)

###
library(CRHMr)
#project filename 
prj_filename_in = "modelo_crhm_glaciar_echaurren_v2.prj"
#path to meteorological data CRHM .obs objects
data_path = "meteo_data/CRHM_obs_data/"

setPrjObs(inputPrjFile = prj_filename_in,
          obsFiles = paste0(data_path,list.files(path = data_path,pattern = ".obs") %>%
                              sort(decreasing = T))
)
#summary csv
CRHMr::summariseObsFiles(
  file.dir = data_path,
  timezone = "etc/GMT+4")

