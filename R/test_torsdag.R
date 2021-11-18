

library(tidyverse)
library(lubridate)

# Regnskap
regnskap <- navR::regnskap %>%
  filter( dato < lubridate::ymd("2021-10-01")) %>%
  arrange( desc(dato)) %>%
  dplyr::rename( pris = g)


# Mottakere
mottakere <- navR::mottakere %>%
  filter( dato < lubridate::ymd("2021-10-01")) %>%
  arrange( desc(dato))

g_ifjor    <- 100853
g_iar      <- 104716
g_neste_ar <- 108287


bud_post1 <- navR::Budsjett$new(name = "Kap.2620, post 70",
                                kapittelpost =    "2620.70",
                                name_nytt_anslag =  "Oktober 2021",
                                    periode = 202108,
                                    dfRegnskap = regnskap,
                                    dfMottakere =  mottakere %>% mutate(kategori = "post70"),
                                    pris_gjeldende = g_iar,
                                    PRIS_VEKST = (g_iar/g_ifjor)
)


gj_ytelse <-
    AvgMottakereYtelse$new(
        name = "test",
        dfMottakere = mottakere,
        dfRegnskap = regnskap ,
        gj_pris = g_iar,
        ANSLAG_AR = bud_post1$giPeriode() %>% lubridate::year(),
        ANSLAG_MND_PERIODE = bud_post1$giPeriode() %>% lubridate::month()
    )


#
gj_ytelse$lagTabell()

l <- list(anslag = c(nytt_iar, nytt_neste_ar) )

gj_ytelse$lagTabell2( nested_liste_anslag = l)





