# #
# #
# # navR::regnskap
# # navR::mottakere
# #
# #
# # regnskap <- readxl::read_excel("../2021-09-06 262070_budsjett_data.xlsx") %>%mutate( dato = lubridate::ymd(dato))
# #
# # mottakere <- readxl::read_excel("../2021-09-06 262070_budsjett_data.xlsx", sheet = 2) %>% mutate( dato = lubridate::ymd(dato), mottakere = as.integer(mottakere))
# #
# # usethis::use_data(regnskap)
# # usethis::use_data(mottakere)
#
# #
# test_mnd <- navR::MndUtvikling$new( df_data = regnskap_feb,
#                         anslag_ar = 2021,
#                         anslag_mnd_periode = 02,
#                         REGNSKAP_ARET_FOR = bud$giRegnskapstallIfjor(),
#                         PRIS_VEKST = 1.0363,
#                         g_gjeldende = 100000
#                         )
#
#
# test_mnd$tabellMndUtvikling( tiltak_kost_ar1 = -38*10^6, tiltak_kost_ar2 = -25*10^6 )
# test_mnd$tabellMndUtvikling(  )
# #
# #
# #
# # # Avg. antall og mottakere  -----------------------------------------------
# #
# # regnskap_feb <- navR::regnskap   %>% mutate( dato = ymd(dato)) %>% filter( dato < lubridate::ymd("2021-03-01")) %>% arrange( desc(dato))
# # mottakere_feb <- navR::mottakere %>% mutate( dato = ymd(dato)) %>% filter( dato < lubridate::ymd("2021-03-01"))%>% arrange( desc(dato))
# #
# # a <-
# #     navR::AvgMottakereYtelse$new(
# #         name = "test",
# #         dfMottakere = mottakere_feb,
# #         regnskap_feb,
# #         gj_pris = 100000,
# #         ANSLAG_AR = 2021,
# #         ANSLAG_MND_PERIODE = 2
# #     )
# #
# # a$lagTabell()
# #
# #
# # b <- AvgMottakereYtelseMedAnslag$new(
# #     name = "test",
# #     dfMottakere = mottakere_feb,
# #     regnskap_feb,
# #     gj_pris = 100000,
# #     ANSLAG_AR = 2021,
# #     ANSLAG_MND_PERIODE = 2
# # )
# #
# # df_test = tibble( ar  = "Anslag 2021", antall = 10700, antall_endring = 0.03, ytelse = 160000, ytelse_endring = -0.007)
# #
# # a$lagTabell()
# # b$lagTabell( df_test)
# #
# #
# #
# #
# #
