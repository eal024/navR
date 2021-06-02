

# library(tidyverse)
#
# regnskap <- readxl::read_excel("../2021-03-23 data_2620.xlsx", sheet = "regnskap")  %>% mutate( dato = lubridate::ymd(dato))
# mottakere <- readxl::read_excel("../2021-03-23 data_2620.xlsx", sheet = "mottakere") %>%  mutate( dato = lubridate::ymd(dato))
#
# usethis::use_data(regnskap, overwrite = T)
# usethis::use_data(mottakere, overwrite = T)
#
# usethis::use_package("lubridate")
#
# devtools::install()
#
# library(navR)
#
# # Tabell, object 1.
# tabell <- RegnskapTabell$new( dfRegnskap = navR::regnskap, g_gjeldende = 104817, anslag_ar = 2021, anslag_mnd_periode = 2, post = "post70" )
# tabell
# tabell$lagRegnskapTabell()
#
# # Mnd utvikling 3 til 12 mnd utvikling.
#
#
#
# # Se dokumentasjonen
# ?RegnskapTabell
# roxygen2::roxygenise()
