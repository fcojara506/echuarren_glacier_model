library(CRHMr)
prj_filename_in = "MODELO_CRHM_YL/YL.prj"
prj_filename_out = "MODELO_CRHM_YL/YL2.prj"

modules = CRHMr::readPrjModuleNames(prjFile = prj_filename_in)
output_var = CRHMr::readPrjOutputVariables(prjFile = prj_filename_in, asDataframe=FALSE)

setPrjOutputVariables(inputPrjFile = prj_filename_in,
                      variables = output_var,
                      outputPrjFile = "MODELO_CRHM_YL/YL2.prj")

runCRHM(CRHMfile = "/Users/fco/Documents/GitHub/crhmcode/crhmcode/build/crhm",
        prjFile = prj_filename_in,
        obsFiles = "MODELO_CRHM_YL/obs_8016.obs",
        useWine = F
        )
