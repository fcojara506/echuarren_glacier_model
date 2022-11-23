rm(list = ls())
source("base/run_CRHM_model.R")


prj_filename = "modelo_crhm_glaciar_echaurren_v2.prj"
# run
setPrjDates(inputPrjFile = prj_filename,
            startDate = '2022 3 1',
            endDate = '2022 11 1')  

set_output_variables(prj_filename = prj_filename,
                     new_variable = c("SnobalCRHM","SWE",as.character(seq(1,48))))
run_CRHM_output(output_filename = "snobal_SWE.txt")

a=CRHMr::readOutputFile(outputFile = "CRHM_model_output/snobal_SWE.txt",
                        timezone = 'etc/GMT+4')

b = head(a,-24)
c = reshape2::melt(b,id.vars = "datetime")

library(ggplot2)
ggplot(data = c)+
  geom_line(aes(x = datetime, y = value, col = variable))
