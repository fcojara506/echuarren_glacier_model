rm(list = ls())
library(CRHMr)
library(dplyr)
library(data.table)
source("base/mass_balance.R")
# basin properties
basin_df = read.csv2(file = "basin_data/HRU_basin_properties.csv")
basin_area = sum(basin_df$area_km2)
df_filename = "CRHM_model_output/balance_masa.txt"
df_units = CRHMr::readOutputUnits(df_filename)

df = readOutputFile(df_filename,timezone = "etc/GMT+4") %>%
  data.frame() 

df = df[,c(1,c("hru_rain","snowmelt_int","icemelt") %>% list_index)] %>% 
  sep_col %>%
  areal_avg%>%
  group_by(datetime,var) %>%
  summarise(var_sum=sum(var_hour)) %>% 
  mutate(date = as.Date(datetime)) %>% 
  select(date,var,var_sum) %>% 
  group_by(var,date)

df_daily_1 = df %>%
  subset(var %in% c("hru_rain","snowmelt_int")) %>% 
  summarize(var_daily= sum(var_sum))

df_daily_2 = df %>%
  subset(var %in% c("icemelt")) %>% 
  summarize(var_daily= mean(var_sum))

df_daily = rbind(df_daily_1,df_daily_2) %>% 
  rename(datetime = date) 


by_YM <- function(df) {
  library(lubridate)
  df = df %>% 
  mutate(date = as.Date(format(datetime,"%Y-%m-01"))) %>%
    group_by(var,date) %>% 
    summarize(var_sum = mean(var_daily))
  return(df)
}

by_month <- function(df) {
  library(lubridate)
  df = df %>% 
    mutate(date = month(datetime)) %>%
    group_by(var,date) %>% 
    summarize(var_sum = mean(var_daily))
  return(df)
}


plot_aporte_glaciar <- function(date_range = c(as.Date("2022-04-01"),as.Date("2022-10-31")),
                                by_group,
                                tag_name
) {

  
df1 = df_daily %>%
  subset(datetime %between% date_range) %>% 
  by_group %>% 
  reshape2::dcast(formula = date ~ var, value.var = "var_sum" )
  
cols = names(df1)[-1]

df_norm= cbind(date=df1$date,
               df1[cols]/rowSums(df1[cols])*100) %>% 
  reshape2::melt(id.vars = c("date"))

df_norm$variable = as.factor(df_norm$variable)
levels(df_norm$variable) = c("Pp Líquida","Hielo","Nieve")


meses <- c("ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic")
df_norm$date <- as.factor(df_norm$date)
print(levels(df_norm$date))
levels(df_norm$date) = meses[as.numeric(levels(df_norm$date))]

library(ggplot2)
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

plot(p2)
ggsave(filename = paste0("CRHM_model_output/figuras/Aporte_glaciar",tag_name,".png"),
       plot = p2,
       width = 6,
       height = 3.5)

return(df_norm)
}
###### by month
# date_range = c(as.Date("2016-04-01"),as.Date("2022-10-31"))
# by_group = by_month
# tag_name = "2016_2022_mon"
df1=plot_aporte_glaciar(date_range = c(as.Date("2016-04-01"),
                                   as.Date("2022-10-31")),
                    by_group = by_month,
                    tag_name = "2016_2022_mon")

df2=plot_aporte_glaciar(date_range = c(as.Date("2022-04-01"),
                                   as.Date("2022-10-31")),
                    by_group = by_month,
                    tag_name = "WY2022_mon")
a=df2 %>% reshape2::acast(date ~ variable,value.var = "value") %>% round(1) 
b=df2 %>% reshape2::acast(date ~ variable,value.var = "value") %>% round(1)
