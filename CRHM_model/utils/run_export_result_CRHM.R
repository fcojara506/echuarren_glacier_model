rm(list = ls())
source("base/run_CRHM_model.R")


prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj"
# run

set_output_variables(prj_filename = prj_filename,
                     new_variable = c("SnobalCRHM","SWE",as.character(seq(1,48))))
run_CRHM_output(output_filename = "snobal_SWE.txt")

source("base/read_output_file.R")
CRHMr::readExportFile(exportFile = "CRHM_model_output/snobal_SWE.txt",
                        timezone = 'etc/GMT+4')
