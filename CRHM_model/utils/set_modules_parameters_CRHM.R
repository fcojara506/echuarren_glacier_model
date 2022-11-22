library(CRHMr)
rm(list = ls())


set_unique_parameter <- function(parameter_name = "Ht",
                                 unique_value = 0,
                                 num_hru = num_hru,
                                 prj_filename_in = prj_filename_in) {
  parameter_value = rep(unique_value, num_hru)
  CRHMr::readPrjParameters(prjFile = prj_filename_in,
                           paramName = parameter_name)
  
  CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
                          paramName = parameter_name,
                          paramVals = parameter_value,
                          quiet = F)
}
##---------------------------------------------------------------
##                            basin                             -
##---------------------------------------------------------------
source("utils/set_basin_parameters_CRHM.R")

#set a unique value for each HRU
prj_filename_in = "modelo_crhm_glaciar_echaurren.prj"
num_hru = 48

##---------------------------------------------------------------
##                              obs                             -
##---------------------------------------------------------------


a = CRHMr::readPrjParameters(prjFile = prj_filename_in,
                             paramName = "HRU_OBS")

obs_order = c(seq(1, num_hru),
              rep(1, num_hru),
              rep(1, num_hru),
              seq(1, num_hru),
              seq(1, num_hru))

CRHMr::setPrjParameters(inputPrjFile = prj_filename_in,
                        paramName = "HRU_OBS",
                        paramVals = obs_order)



par_name_value = list(
  ##---------------------------------------------------------------
  ##                              obs                             -
  ##---------------------------------------------------------------
  "tmax_allsnow" = 3.4, #default 0
  "tmax_allrain" = 4.5,#default 4
  "lapse_rate" = 0, #temperature, 0: already defined through obs
  "ClimChng_precip" = 1, #default 1 #########
  "ClimChng_t" = 0,#default 0 ##########
  ##----------------------------------------------------------------
  ##                            global                             -
  ##----------------------------------------------------------------
  "Time_Offset" = 0,
  ##----------------------------------------------------------------
  ##                          K_Estimate                           -
  ##----------------------------------------------------------------
  "Ks_gw" = 6.9E-6,
  "Ks_lower" = 6.9E-6,
  "Ks_upper" = 6.9E-6,
  "PSD" = 0.252,
  ##---------------------------------------------------------------
  ##                            calcsun                           -
  ##---------------------------------------------------------------
  #NAN
  ##---------------------------------------------------------------
  ##                          Slope_Qsi                           -
  ##---------------------------------------------------------------
  #NAN
  ##----------------------------------------------------------------
  ##                            longVt                             -
  ##----------------------------------------------------------------
  "epsilon_s" = 0.98,
  " Vt " = 0.3,
  ##----------------------------------------------------------------
  ##                            netall                             -
  ##----------------------------------------------------------------
  #NAN

  ##----------------------------------------------------------------
  ##                              evap                             -
  ##----------------------------------------------------------------
  "evap_type" = 2,# 0:Granger, 1:Priestley-Taylor, 2:Penman-Monteith
  "F_Qg" = 0,#default 0.1,
  " rs " = 0, #water :0
  "Zwind" = 2.5,
  ##----------------------------------------------------------------
  ##                            SWESlope                           -
  ##----------------------------------------------------------------
  "Disable_SWEslope"= 1, # 1 disable
  "Hd_min" = 50,
  "snow_density" = 200,
  "use_rho" = 1, #0: user defined density, 1: use Snobal
  ##---------------------------------------------------------------
  ##                            glacier                           -
  ##---------------------------------------------------------------
  " Densification " = 0,
  " Densification_550 " = 100,
  " Densification_above_550 " = 100,
  "firnLag" = 0,
  "inhibit_firnmelt" = 0,
  "inhibit_icenmelt" = 0,
  "nfactor" = 0,
  "SWELag" = 0,
  "SWEstorage" = 0,
  "SWE_to_firn_Julian" = 91,
  "tfactor" = 0,
  "topo_elev_init" = 0,
  "Use_QnD" = 0,
  "T_threshold" = 1,
  ##----------------------------------------------------------------
  ##                        CanopyClearing                         -
  ##----------------------------------------------------------------
  "Alpha_c" = 0.1,
  "B_canopy" = 0.038,
  " CanopyClearing " = 0,
  "LAI" = 2.2,
  "Ht" = 0.001,
  "Sbar" = 6.6,
  " unload_t " = 1,
  " unload_t_water "= 4,
  "Z0snow" = 0.001,
  "Zref" = 2,
  "Zvent" = 0.75,
  ##----------------------------------------------------------------
  ##                        albedo_Richard                         -
  ##----------------------------------------------------------------
  "a1" = 1.2E6,#default 1.08E7
  "a2" = 7.2E5,
  "Albedo_Bare" = 0.17,#0.17,
  "Albedo_Snow" = 0.9,
  "amax" = 0.9,
  "amin" = 0.5,
  "smin" = 1,
  ##----------------------------------------------------------------
  ##                          pbsmSnobal                           -
  ##----------------------------------------------------------------
  "A_S" = 0.003,
  "inhibit_bs" = 0 , #1 inhibit
  "inhibit_subl" = 0, #1 inhibit
  " distrib "  = 1, #default 0
  "fetch" = 1000,
  "N_S " = 1,
  ##----------------------------------------------------------------
  ##                          SnobalCRHM                           -
  ##----------------------------------------------------------------
  "hru_F_g" = 0, #fixed   
  "hru_rho_snow" = 200,
  "hru_T_g" = -4, #0.4 Michelle, -1.3, -4.7 Maria,
  "KT_sand" = 1.65, # default 0.08,
  "max_h2o_vol" = 0.001,# default 0.0001, 0.01 Michelle, 0.0015 Maria,
  "max_z_s_0" = 0.1,
  "rain_soil_snow" = 0,# 1 Maria in some HRUs
  "relative_hts" = 0,
  "T_g_or_G_flux" = 1, #0:Tg, 1:G_flux
  "z_0"= 0.001,
  "z_g" = 0.1,
  "z_T" = 2,
  "z_u" = 2.5,# 10m or 2m
  ##---------------------------------------------------------------
  ##                      PrairieInfiltration                     -
  ##---------------------------------------------------------------
  "fallstat"=50,
  "groundcover" = 1,#1:baresoil
  "infDays" = 6,
  "Major" = 5, #threshold for major melt (mm/d)
  "PriorInfiltration"=1,
  "texture" = 4, ##########3 revisar
  ##----------------------------------------------------------------
  ##                              Soil                             -
  ##----------------------------------------------------------------
  "cov_type" = 0, #0: no vegetation, 1:crop, 2: grasses
  "gw_init" = 100,
  "gw_max" = 2000,
  "Sdinit" = 0,
  "soil_moist_init" = 250,
  "soil_rechr_init" = 10,
  "soil_ssr_runoff" = 0,
  "soil_withdrawal" = 3,
  "Wetlands_scaling_factor" = 1,
  ##----------------------------------------------------------------
  ##                          Netroute_M                           -
  ##----------------------------------------------------------------
  "Channel_shp" = 1,
  "gwKstorage"= 90,# 0 days
  "gwLag" = 0,
  " Lag " = 0,
  "preferential_flow" = 0,
  "route_L" = 200,#metros ###REVISAR
  "route_n" = 0.025,
  "route_R" = 0.5,
  "route_X_M" = 0.25,
  "runKstorage" = 0,
  "runLag" = 0,
  "Sd_ByPass" = 0,
  "ssrKstorage" = 20, #default 5
  "ssrLag" = 0
)

# set all the values in the list
for (parameter in names(par_name_value)) {
  message(parameter)
  message("Procesando...")
  set_unique_parameter(
    parameter_name = parameter,
    unique_value = par_name_value[[parameter]],
    num_hru = num_hru,
    prj_filename_in = prj_filename_in
  )
}

