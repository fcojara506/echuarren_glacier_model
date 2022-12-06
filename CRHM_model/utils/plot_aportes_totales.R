library(ggplot2)
library(shadowtext)

tag = "WY2022"
## Diagrama de todos los elementos del balance
var_names = read.csv(file = "CRHM_model_output/balance_masa_varnames.csv")
df_mod  <-  read.csv(file = paste0("CRHM_model_output/balance_de_masa_total",tag,".csv")) %>% 
  merge(var_names)

# cambiar signo de elementos negativos en las entradas -> salidas
id_neg  <-  as.vector(df_mod[,'var_total']<0)
df_mod[id_neg,]['in_or_out']  <-  'out'
df_mod[id_neg,]['var_total']  <-  -df_mod[id_neg,]['var_total']

id_cero  <-  !as.vector(df_mod[,'var_total']==0)
df_mod  <-  df_mod[id_cero,]


# colores  <-  c(colorspace::sequential_hcl(4),
#                colorspace::sequential_hcl(11))

# p1 = ggplot(df_mod,
#             aes(x=in_or_out,y=var_total,fill=var))+
#   geom_bar(stat = "identity",color='white') +
#   geom_shadowtext(aes(label=var),position=position_stack(vjust=0.5),
#                   check_overlap = TRUE,
#                   size = 4) +
#   ylab('Valor (mm)') +
#   xlab('') +
#   scale_fill_manual(values=colores) +
#   scale_x_discrete(limit = c('in','out'), labels = c('Entradas','Salidas')) +
#   theme_minimal()
# library(plotly)


library(ggrepel)
library(dplyr)

data = df_mod %>%
  group_by(in_or_out) %>% 
  # Compute percentages
  mutate(fraction=prop.table(var_total)) %>%
  #order
  arrange(in_or_out,fraction) %>% 
# Compute a good label
mutate(label = paste0(var_name, ": \n", round(var_total,1),"mm  (",round(fraction*100,1),"%)")) %>% 
  mutate(csum = rev(cumsum(rev(fraction))), 
         pos = fraction/2 + lead(csum, 1),
         pos = if_else(is.na(pos), fraction/2, pos))

data$in_or_out = as.factor(data$in_or_out)
levels(data$in_or_out) = c("entradas","salidas")
library(RColorBrewer)
library(forcats)
mycolors = c(brewer.pal(name="Pastel1", n = 4), 
             brewer.pal(name="Pastel2", n = 8))


ggplot(data,
            aes(x = "" ,
                y = fraction,
                fill = fct_inorder(var_name))) +
  facet_wrap(~in_or_out,ncol=2)+
  geom_col(width = 5)+
  scale_fill_manual(values = mycolors)+
  geom_label_repel(data = data,
                   aes(y = pos, 
                       label = label),
                   size = 3,
                   nudge_x = 5,
                   show.legend = F,
                   label.size = NA,
                   max.overlaps = 20
                    ) +
  coord_polar(theta = "y")+
  theme_void()+
  theme(legend.position = "bottom")+
  labs(fill="")

ggsave(filename = paste0("CRHM_model_output/figuras/",tag,"/balance_masa_inout",tag,".png"),
       dpi=500,
       width = 9,
       height = 6
       )
