


# Oppsett budsjettanslag.
# Eksempelet er basert på budsjettanslaget kapittel 2620 mars 2020.
library(tidyverse)
library(navR)


# Data og forutsetninger
regnskap_juni <- navR::regnskap %>% filter( dato < lubridate::ymd("2020-07-01"))
mottakere_juni <- navR::mottakere %>% filter( dato < lubridate::ymd("2020-07-01"))

# Pris
g_20 <- 100853
g_21 <- 102870



# Budsjettet
bud <- navR::Budsjett$new(     name = "Test 1 for kap 2620, juni 2020",
                               name_nytt_anslag = "aug2020",
                               periode = 202006,
                               dfRegnskap = regnskap_juni,
                               dfMottakere =  mottakere_juni %>% mutate(kategori = "post70"),
                               g_gjeldende = g_20,
                               PRIS_VEKST = (100853/98866)
                          )
bud %>% str()

# Vis anslag innenværende år (år = 0).
bud$giAnslag()


# Denne kan være giRegnskapstallHistorie( ar == ) -> skal være rett fram.
bud$giRegnskapstallIfjor()


# Ny klasse anslag
nyttAnslag2020 <-
    navR::Anslag$new(
        name = "aug2020",
        ar = 2020,
        regnskap_ifjor = bud$giRegnskapstallIfjor(),
        volumvekst = (1 - 0.034),
        vekst_ytelse = 1,
        prisvekst = 1.02,
        tiltak = (1 - 0.0000)
    )

nyttAnslag2020$setVolum( volumvekst = 1.02)

nyttAnslag2021 <-
    Anslag$new(
        name = "aug2021",
        ar = 2021,
        regnskap_ifjor = nyttAnslag2020$giSumAnslag(),
        volumvekst = 1,
        vekst_ytelse = 1,
        prisvekst = 1,
        tiltak = (1 - 0.0219)
    )

nyttAnslag2021

nyttAnslag2021$giDfAnslag()

# Mars anslaget
forrige2020 <-
    navR::Anslag$new(
        name = "mars2020",
        ar = 2020,
        regnskap_ifjor = bud$giRegnskapstallIfjor(),
        volumvekst = (1),
        vekst_ytelse = 1,
        prisvekst = 1.018,
        tiltak = (1 - 0.0011)
    )

forrige2020

#
bud$leggTilNyttAnslag( nyttAnslag2020, rekkefolge = 1 )
bud$leggTilNyttAnslag( nyttAnslag2021, rekkefolge = 2 )

bud$leggTilHistoriskAnslag( forrige2020, rekkefolge = 1)

bud$giHistoriskeAnslag()

bud$giAnslag()[[3]]

bud$giHistoriskeAnslag()[[1]]

#bud$dekomponer( anslag1 = nytt, anslag2 = forrige )

# Vis historie:
# lag class: dekomponering: denne må testes opp og ned.


# Set anslag (+2, +3, +4); Dette gjelder kun desember og juli.

# Tabeller som viser statistikk.
bud$lagRegnskapTabell( )
bud$lagMottakerTabell()

bud$lagRegnskapTabell2( anslag1 = bud$giAnslag()[[1]] ,
                        anslag2 = bud$giAnslag()[[2]]  ) %>%
    mutate_at( vars( regnskap , endring_regnskap, regnskap_fast, endring_regnskap_f ), function(x) {x/10^6}
               )

## Korrigere for antall i tiltak
bud$lagTabellMndUtviklingMottakere()

# Denne er i prisjusterte utgifter.
bud$lagTabellMndUtviklingRegnskap( )

# Historisk regnskap
## Må tilføye anslag
bud$lagMottakerTabell()

b <- bud$lagMottakerTabell()


# Mottakere
## Må tilføye mottakere

# Gjennomsnittlig ytelse
## Må tilføye historisk sum


# Oppsummeringstabeller: Til forsiden.
## Tabeller til forssiden
