library(tidyverse)
library(lubridate)
library(navR)
library(kableExtra)

## Forutsetninger. Skal inngå i budsjett-objektet og de ulike anslagene.

g_ifjor    <- 100853
g_iar      <- 104716
g_neste_ar <- 108287



bud_post1 <- Budsjett$new(name = "Kap. 2020 Enslig mor eller far",
                          kapittelpost = "2620.70",
                          name_nytt_anslag = "Oktober 2021",
                          periode = 202108,
                          dfRegnskap = regnskap %>% rename( pris = g),
                          dfMottakere =  mottakere %>% mutate(kategori = "post70"),
                          pris_gjeldende = g_iar,
                          PRIS_VEKST = (g_iar/g_ifjor)
)



bud_post1$lagMottakerTabell()


tabell_regnskap <- RegnskapTabell$new(dfRegnskap = regnskap %>% rename( pris = g), anslag_ar = 2020, anslag_mnd_periode = 10, post = 70, pris_gjeldende = 100000)

tabell_mottakere <- Mottakere$new( "test", dfMottakere = mottakere %>% mutate(kategori = "post70"), ANSLAG_AR = 2020, ANSLAG_MND_PERIODE = 10)

tabell_regnskap$lagRegnskapTabell()

tabell_mottakere$lagTabell(ceiling_date = T)


if( celing_date == T ) {tabell_regnskap_del2 <- tabell_regnskap_del2 %>%
    dplyr::mutate( ar = (lubridate::ceiling_date(ymd(ar), unit = "month") -1) %>% as.character()  )  }


#
# library(navR)
#
gj_ytelse_test <-
    AvgMottakereYtelse$new(
        name = "test",
        dfMottakere = mottakere,
        dfRegnskap = regnskap,
        gj_pris = 104716,
        ANSLAG_AR = 2021,
        ANSLAG_MND_PERIODE = 8
    )
#
gj_ytelse_test$lagTabell()
gj_ytelse_anslag(tabell = gj_ytelse_test$lagTabell(), gj_ar = 2021, anslag = c(nytt_iar,nytt_neste_ar), gi_navn =  "Test" )

#
#
l <- list( nyttAnslag = c(nytt_iar, nytt_neste_ar) )
#
names(l)[1]
gj_ytelse_test$lagTabell2(l)


lag_df_gj_ytelse(tabell = gj_ytelse_test$lagTabell(), gj_ar = "2020", anslag =  c(nyttAnslag2021, nyttAnslag2022) , gi_navn = "nytt anslag")


library(lubridate)


rs <- navR::regnskap %>% rename(pris = g)


tabell <- MndUtvikling$new( df_data = rs, anslag_ar = 2021, anslag_mnd_periode = 10, REGNSKAP_ARET_FOR = 1000*10^6, pris_gjeldende = 100000, PRIS_VEKST = 1)



mutate( lengde =  stringr::str_c( periode_for( self$giPeriode(), lengde, ar = 1), " til ",periode_for(self$giPeriode(), lengde, ar = 0)  ) )


periode_for(periode = bud_post1$giPeriode(), x = tabell$tabellMndUtvikling()$lengde, ar = 1  )

tabell$tabellMndUtvikling() %>%
    group_by(lengde) %>%
    mutate( lengde =  stringr::str_c( periode_for( bud_post1$giPeriode()  , lengde, ar = 1), " til ",periode_for(bud_post1$giPeriode(), lengde, ar = 0)  ) )

