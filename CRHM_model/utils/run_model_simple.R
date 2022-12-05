rm(list = ls())
library(dplyr)

library(beepr)

setwd("/Users/fco/Documents/GitHub/echuarren_glacier_model/CRHM_model")
source("base/run_CRHM_model.R")

# run_CRHM_output(crhm_path = "/Users/fco/Documents/GitHub/crhmcode/crhmcode/build/crhm",
#                 prj_filename = "modelo_crhm_glaciar_echaurren_v2singlaciar.prj",
#                 output_filename = "balance_masa_singlaciar.txt")
# gc()
run_CRHM_output(crhm_path = "/Users/fco/Documents/GitHub/crhmcode/crhmcode/build/crhm",
                  prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj",
                output_filename = "balance_masa.txt")

# beep(2)
# beep(1)
# beep(1)
source("utils/series_tiempo.R")

