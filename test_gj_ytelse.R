# #
# # library(navR)
# #
# gj_ytelse_test <-
#     AvgMottakereYtelse$new(
#         name = "test",
#         dfMottakere = mottakere,
#         dfRegnskap = regnskap,
#         gj_pris = 104716,
#         ANSLAG_AR = 2021,
#         ANSLAG_MND_PERIODE = 8
#     )
# #
# gj_ytelse_test$lagTabell()
# gj_ytelse_anslag(tabell = gj_ytelse_test$lagTabell(), gj_ar = 2021, anslag = c(nytt_iar,nytt_neste_ar), gi_navn =  "Test" )
#
# #
# #
# l <- list( nyttAnslag = c(nytt_iar, nytt_neste_ar) )
# #
# names(l)[1]
# gj_ytelse_test$lagTabell2(l)
#
#
# lag_df_gj_ytelse(tabell = gj_ytelse_test$lagTabell(), gj_ar = "2020", anslag =  c(nyttAnslag2021, nyttAnslag2022) , gi_navn = "nytt anslag")
