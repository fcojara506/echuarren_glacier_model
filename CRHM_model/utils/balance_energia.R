rm(list = ls())
library(dplyr)
library(data.table)

# basin properties
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")
basin_area = sum(basin_df$area_km2)
# energy balance
files_folder = "CRHM_model_output/archivos/"



#function
read_variable  <- function(variable_crhm) {
df = readRDS(file = paste0(files_folder,variable_crhm,".RDS"))
return(df)
}

balance_energia <- function(date_range = c(as.Date("2016-04-02"),
                                as.Date("2022-11-01")),
                            tag_name = "2016_2022",
                            plot_monthly = T
                            ) {
  list_variables = c(
    "SnobalCRHM_delta_Q",
    "SnobalCRHM_G",
    "SnobalCRHM_H",
    "SnobalCRHM_L_v_E",
    "SnobalCRHM_M",
    "SnobalCRHM_R_n"
  )
df = lapply( list_variables , read_variable) %>%
  rbindlist() %>% 
  mutate(HRU = as.integer(HRU)) %>% 
  merge(basin_df,by = "HRU") %>% 
  select(c(datetime,var,value,area_km2)) %>% 
  subset(datetime %between% date_range)

df2 = df %>% 
  mutate(var_avg = value * area_km2/basin_area) %>% 
  select(-value,-area_km2)

library(stats)
df3 = df2 %>%
  group_by(var,datetime) %>% 
  summarize(var_sum = sum(var_avg))
df3$var <- factor(df3$var)
# New facet label names for supp variable
la <- c("Delta Q", "G","H","LvE","M","Rn")
names(la) <- c("delta_Q","G","H","L_v_E","M","R_n")


library(ggplot2)
p=ggplot(data = df3,
       aes(x = datetime,
           y = var_sum)
)+
  geom_line()+
  facet_wrap(~var, 
             labeller = labeller(var = la))+
  labs(
    x = "",
    y = "Flujo energético (W/m2)"
  )

ggsave(filename = paste0("CRHM_model_output/figuras/",tag_name,"/","Balance_energia_cuenca_horario",tag_name,".png"),
       plot = p,
       width = 8,
       height = 5)

if (plot_monthly) {
  
  df1 = df3 %>% 
    mutate(date = as.Date(format(datetime,"%Y-%m-01"))) %>%
    group_by(var,date) %>% 
    summarize(var_sum = mean(var_sum))
  
  df1_1 = subset(df1,var == "delta_Q") %>% ungroup() %>% select(-var)
  df1_2 = subset(df1,var != "delta_Q") %>% ungroup()
  
  df1_2$var = as.factor(df1_2$var)
  levels(df1_2$var) = c("Delta Q", "G","H","LvE","M","Rn")
  
  p2=ggplot()+
    geom_col(data = df1_2,
             aes(x = date,
                 y = var_sum,
                 fill = var))+
    geom_point(data = df1_1,aes(x = date,
                                y = var_sum,
                                col="dQ"),
               size = 1
    )+
    labs(
      x = "",
      y = "Flujo energético (W/m2)",
      col = "",
      fill = ""
    )+
    scale_fill_brewer()+
    theme(legend.position = "bottom")
  
  ggsave(filename = paste0("CRHM_model_output/figuras/",tag_name,"/","Balance_energia_cuenca_mensual",tag_name,".png"),
    plot = p2,
    width = 6,
    height = 3.5)
}

return(df3)
}

df_hist = balance_energia(date_range = c(as.Date("2016-04-02"),
                               as.Date("2022-10-31")),
                tag_name = "2016_2022")

df_2022 = balance_energia(date_range = 
                            c(as.Date("2022-08-01"),
                               as.Date("2022-10-31")
                              ),
                tag_name = "ASO2022")







