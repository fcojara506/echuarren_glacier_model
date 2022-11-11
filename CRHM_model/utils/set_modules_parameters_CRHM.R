library(CRHMr)
prj_filename_in = "modelo_crhm_glaciar_echaurren.prj"

modules = CRHMr::readPrjModuleNames(prjFile = prj_filename_in)

a=CRHMr::readPrjParameters(prjFile = prj_filename_in,paramName = "hru_area")
CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
                        paramName = "hru_area",
                        paramVals = a*2,
                        outputPrjFile = "parameters_echaurren.par")
