
library(CRHMr)
library(dplyr)

df = CRHMr::readObsFile("MODELO_CRHM_YL/obs_8016.obs",timezone = "America/Santiago")
datetime = df$datetime
df = df %>% select(-datetime) %>% round(digits = 3) %>% cbind(datetime,.)


writeObsFile(df,obsfile='obs_FINAL_v2.obs')
