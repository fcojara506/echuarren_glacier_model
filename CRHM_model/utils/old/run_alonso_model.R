library(CRHMr)


f1 <- function() {
  
crhm_path = "/Users/fco/Documents/GitHub/crhmcode/crhmcode/build/crhm"
prj_filename = "MODELO_ALONSO/Caso8.prj"
obs_filename = "MODELO_ALONSO/obsUniversidadgradientesv2.obs"

automatePrj(prj_filename)

setPrjObs(prj_filename, obsFiles = obs_filename )

runCRHM(
  CRHMfile = crhm_path ,
  prjFile = prj_filename
)

}

#run
f1()

