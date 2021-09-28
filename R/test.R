#
#
# library(navR)
# library(lubridate)
# library(tidyverse)
#
# # Data og forutsetninger
# regnskap_feb <- navR::regnskap %>% filter( dato < lubridate::ymd("2021-10-01")) %>% arrange( desc(dato))
# mottakere_feb <- navR::mottakere %>% filter( dato < lubridate::ymd("2021-10-01"))%>% arrange( desc(dato))
#
# # Pris
# g_20 <- 100853
# g_21 <- 104716
# g_22 <- 108287
#
#
#
# # Budsjettet
# bud <- navR::Budsjett$new( name = "Kap. 2020 Enslig mor eller far",
#                                name_nytt_anslag = "Oktober 2021",
#                                periode = 202108,
#                                dfRegnskap = regnskap_feb %>% rename( pris = g),
#                                dfMottakere =  mottakere_feb %>% mutate(kategori = "post70"),
#                                pris_gjeldende = g_21,
#                                PRIS_VEKST = (g_21/g_20)
# )
#
# nytt_iar <-
#     navR::Anslag$new(
#         name = "NAVs nye anslag",
#         ar = 2021, #(bud$giAr()+1)
#         regnskap_ifjor = bud$giRegnskapstallIfjor(),
#         volumvekst = (1 + 0.015),
#         vekst_ytelse = (1-0.026),
#         prisvekst = 1.0383,
#         tiltak = (1 - 0.0222)
#     )
#
# nytt_neste_ar <-
#     navR::Anslag$new(
#         name = "NAVs nye anslag 2022",
#         ar = 2022,
#         regnskap_ifjor = nytt_iar$giSumAnslag(),
#         volumvekst = (1 - 0.005),
#         vekst_ytelse = (1-0.00),
#         prisvekst = 1.0341,
#         tiltak = (1 - 0.0145)
#     )
#
#
# bud$lagRegnskapTabell()
#
# test <- RegnskapTabell$new(dfRegnskap = regnskap_feb %>% rename( pris = g),  pris_gjeldende = g_21, anslag_mnd_periode = 08, anslag_ar = 2021)
#
# test$lagRegnskapTabell()
#
# test$lagRegnskapTabell2(anslag1 =  nytt_iar, nytt_neste_ar , printversjon = F, celing_date = T )
#
#
# test2 <- MndUtvikling$new(df_data = regnskap_feb %>% rename( pris = g), anslag_ar = 2021, anslag_mnd_periode = 08, REGNSKAP_ARET_FOR = 1669*10^6, PRIS_VEKST = 1.028, pris_gjeldende = g_21)
#
#
# test2$tabellMndUtvikling()
#
#
#
