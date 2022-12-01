rm(list = ls())
library(dplyr)
library(data.table)
# basin properties
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")
basin_area = sum(basin_df$area_km2)

area_avg <- function(df,
                     date_range = c(
                       as.Date("2016-04-02"),
                       as.Date("2022-10-31")
                         ),
                     fx = mean
                     ) {
  df = df %>% 
  mutate(HRU = as.integer(HRU)) %>% 
    merge(basin_df,by = "HRU") %>% 
    select(c(datetime,var,value,area_km2)) %>% 
    subset(datetime %between% date_range) %>% 
    mutate(var_avg = value * area_km2/basin_area) %>% 
    select(-value,-area_km2) %>% 
    group_by(var,datetime) %>% 
    summarize(var_sum = fx(var_avg)) %>% 
    select(datetime, var, var_sum)
  return(df)
}

by_YM <- function(df) {
  df = df %>% 
  mutate(date = as.Date(format(datetime,"%Y-%m-01"))) %>%
    group_by(var,date) %>% 
    summarize(var_sum = mean(var_sum))
  return(df)
}

by_month <- function(df) {
  df = df %>% 
    mutate(date = month(datetime)) %>%
    group_by(var,date) %>% 
    summarize(var_sum = mean(var_sum))
  return(df)
}


plot_aporte_glaciar <- function(date_range = c(as.Date("2016-04-02"),as.Date("2022-10-31")),
                                by_group,
                                tag_name
) {
  
  # aporte glaciar
  df = list(
    "p_liquida" = readRDS("CRHM_model_output/archivos/obs_hru_rain.RDS") %>% area_avg(fx=sum,date_range = date_range),
    "snowmelt" = readRDS("CRHM_model_output/archivos/SnobalCRHM_snowmeltD.RDS")%>% area_avg(date_range = date_range),
    "icemelt" = readRDS("CRHM_model_output/archivos/glacier_icemelt.RDS")%>% area_avg(date_range = date_range)
    #"firnmelt" = readRDS("CRHM_model_output/archivos/glacier_firnmelt.RDS")%>% area_avg()
  ) %>% rbindlist()
  

df1 = df %>% 
  by_group %>%
  reshape2::dcast(formula = date ~ var,
                  value.var = "var_sum" )
cols = names(df1)[-1]

df_norm= cbind(date=df1$date,
               df1[cols]/rowSums(df1[cols])*100) %>% 
  reshape2::melt(id.vars = c("date"))

df_norm$variable = as.factor(df_norm$variable)
levels(df_norm$variable) = c("Pp Líquida","Hielo","Nieve")



df_norm$date <- factor(df_norm$date,
                       levels=as.character(seq(1,12)))


p2=ggplot(data = df_norm,
          aes(x = date,
              y = value,
              fill = variable,
              label = round(value,1))
          )+
  geom_col()+
  scale_fill_brewer()+
  #geom_text(size = 1, position = position_stack(vjust = 0.1))+
  labs(
    x = "",
    y = "Contribución total (%)",
    col = "",
    fill = ""
  )+
  theme(legend.position = "bottom")


ggsave(filename = paste0("CRHM_model_output/figuras/Aporte_glaciar",tag_name,".png"),
       plot = p2,
       width = 6,
       height = 3.5)

return(df_norm)
}
###### by month
df1=plot_aporte_glaciar(date_range = c(as.Date("2016-04-02"),
                                   as.Date("2022-10-31")),
                    by_group = by_month,
                    tag_name = "2016_2022_mon")

df2=plot_aporte_glaciar(date_range = c(as.Date("2022-08-01"),
                                   as.Date("2022-10-31")),
                    by_group = by_month,
                    tag_name = "ASO2022_mon")
#### by Y-M

df3=plot_aporte_glaciar(date_range = c(as.Date("2016-04-02"),
                                   as.Date("2022-10-31")),
                    by_group = by_YM,
                    tag_name = "2016_2022_YM")

df4=plot_aporte_glaciar(date_range = c(as.Date("2022-08-01"),
                                   as.Date("2022-10-31")),
                    by_group = by_YM,
                    tag_name = "ASO2022_YM")