
library(navR)

gj_ytelse_test <-
    AvgMottakereYtelse$new(
        name = "test",
        dfMottakere = mottakere,
        dfRegnskap = regnskap,
        gj_pris = 104716,
        ANSLAG_AR = 2021,
        ANSLAG_MND_PERIODE = 8
    )

gj_ytelse_test$lagTabell()
gj_ytelse_anslag(tabell = gj_ytelse_test$lagTabell(), gj_ar = 2021, anslag = c(nyttAnslag2021, nyttAnslag2022), gi_navn =  "Test" )


gj_ytelse_test$lagTabell2( nested_liste_anslag =  list( nyttAnslag = c(nyttAnslag2021, nyttAnslag2022),
                                                        forrige = c(nyttAnslag2021, nyttAnslag2022),
                                                        vedtatt = c(nyttAnslag2021, nyttAnslag2022)
                                                        )
                           )


l <- list( nyttAnslag = c(nyttAnslag2021, nyttAnslag2022) )

names(l)[1]

length(l)

df <- gj_ytelse_test$lagTabell() %>% filter( ar == as.character(2020))







lag_df_gj_ytelse(tabell = gj_ytelse_test$lagTabell(), gj_ar = "2020", anslag =  c(nyttAnslag2021, nyttAnslag2022) , gi_navn = "nytt anslag")
