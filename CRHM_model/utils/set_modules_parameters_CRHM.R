library(CRHMr)
prj_filename_in = "modelo_crhm_glaciar_echaurren.prj"



a=CRHMr::readPrjParameters(prjFile = prj_filename_in,
                           paramName = "HRU_OBS")
obs_order = c(seq(1,48),
        rep(1,48),
        rep(1,48),
        seq(1,48),
        seq(1,48))

CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
                        paramName = "HRU_OBS",
                        paramVals = obs_order)
