library(CRHMr)



crhm_path = "/Users/fco/Documents/GitHub/crhmcode/crhmcode/build/crhm"
prj_filename = "modelo_crhm_glaciar_echaurren.prj"
obs_filenames = c(
    "meteo_data/CRHM_obs_data/obs_test_u.obs",
    "meteo_data/CRHM_obs_data/obs_test_t.obs",
    "meteo_data/CRHM_obs_data/obs_test_rh.obs",
    "meteo_data/CRHM_obs_data/obs_test_Qsi.obs",
    "meteo_data/CRHM_obs_data/obs_test_Qli.obs",
    "meteo_data/CRHM_obs_data/obs_test_p.obs",
    "meteo_data/CRHM_obs_data/obs_test_h_snow.obs")
  
    #automate
    automatePrj(prj_filename,quiet = F,logfile = "")
    setPrjObs(prj_filename,
              obsFiles = obs_filenames)
    
    runCRHM(CRHMfile = crhm_path ,
            prjFile = prj_filename
            )
            #logfile = "",
            #outFile = "CRHM_model_output/output.txt",


