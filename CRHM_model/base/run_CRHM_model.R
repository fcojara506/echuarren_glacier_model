library(CRHMr)


empty_output_variable <- function(prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj") {
  CRHMr::setPrjOutputVariables(prj_filename, 'null')
}
set_output_variables <- function(prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj",
                                 new_variable) {

df = df <- data.frame(matrix(ncol = 3, nrow = 0))
names(df) = c("module","variable","HRUs") 

success = CRHMr::setPrjOutputVariables(inputPrjFile = prj_filename,
                             variables = new_variable)
return(success)

}

get_output_variables <- function(prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj") {
df = CRHMr::readPrjOutputVariables(prjFile = prj_filename,
                                   asDataframe = T)
return(df)
  
}

add_output_variable <- function(prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj",
                                new_variable) {
  df = get_output_variables(prj_filename = prj_filename)
  df2 = rbind(df,new_variable)
  success = set_output_variables(prj_filename = prj_filename,new_variable = df2)
  return(success)
}

run_CRHM_output <- function(
crhm_path = "/Users/fco/Documents/GitHub/crhmcode/crhmcode/build/crhm",
prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj",
obs_filenames = c(
    "meteo_data/CRHM_obs_data/obs_test_u.obs",
    "meteo_data/CRHM_obs_data/obs_test_t.obs",
    "meteo_data/CRHM_obs_data/obs_test_rh.obs",
    "meteo_data/CRHM_obs_data/obs_test_Qsi.obs",
    "meteo_data/CRHM_obs_data/obs_test_Qli.obs",
    "meteo_data/CRHM_obs_data/obs_test_p.obs"
    ),
output_filename = "output.txt") {

  
    #automate
    automatePrj(prj_filename)
    
    # set observation list
    setPrjObs(prj_filename,
              obsFiles = obs_filenames)
    
    runCRHM(CRHMfile = crhm_path ,
            prjFile = prj_filename,
            outFile = paste0("CRHM_model_output/",output_filename)
            )
file.remove("CRHMr.log")
#file.remove("crhmRun.log")
return(T)
}

