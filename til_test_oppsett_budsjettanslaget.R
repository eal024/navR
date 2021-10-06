


# Oppsett budsjettanslag.
# Eksempelet er basert på budsjettanslaget kapittel 2620 mars 2020.
library(tidyverse)
library(navR)
library(lubridate)

# Data og forutsetninger.
# Februar er siste måned med regnskap og mottakere
regnskap <- navR::regnskap   %>% mutate( dato = ymd(dato)) %>% rename( pris = g) %>% filter( dato < ymd("2021-08-01"))
mottakere <- navR::mottakere %>% mutate( dato = ymd(dato))%>% filter( dato < ymd("2021-08-01"))


# Priser
g_20 <- 100853
g_21 <- 104514



# Budsjettet objektet
bud <- navR::Budsjett$new(     name = "Test for kap 2620 enslig mor eller far, februar 2021",
                               name_nytt_anslag = "februar 2021",
                               periode = 202108, # Periode er siste måned med observasjoner.
                               dfRegnskap = regnskap %>% mutate(regnskap = ifelse( dato == ymd("2021-02-01"), 140247590,regnskap )),
                               dfMottakere =  mottakere %>% mutate(kategori = "post70"),
                               pris_gjeldende = g_21, # Anslaget skal være i 2021-priser.
                               PRIS_VEKST = (104514/100853)
                          )


bud$giPeriode()





# Tabeller som viser statistikk.
bud$lagRegnskapTabell( )
bud$lagMottakerTabell()

bud$lagTabellMndUtviklingRegnskap()
bud$lagTabellMndUtviklingRegnskap( tiltak_kost_ar1 = -38*10^6, tiltak_kost_ar2 = -25*10^6 ) # Endre
bud$lagTabellMndUtviklingMottakere()

# Denne kan være giRegnskapstallHistorie( ar == )

## Må forbedres. Gi regnskapstall for et gitt år.
bud$giRegnskapstallIfjor( )

## Denne må må med.
navR::AvgMottakereYtelse$new(name = "test", dfMottakere = mottakere_feb, regnskap_feb, gj_pris = 100000, ANSLAG_AR = 2021, ANSLAG_MND_PERIODE = 2)$lagTabell()


# Vis anslag: Skal gi NULL
bud$giAnslag()

# Ny klasse anslag
nyttAnslag2021 <-
    navR::Anslag$new(
        name = "mars2021",
        ar = 2021,
        regnskap_ifjor = bud$giRegnskapstallIfjor(),
        volumvekst = (1 + 0.0069),
        vekst_ytelse = (1-0.005),
        prisvekst = 1.0393,
        tiltak = (1 - 0.02187)
    )


nyttAnslag2021$giDfAnslag()

# Legger til nye anslag
bud$leggTilNyttAnslag( nyttAnslag2021, rekkefolge = 1 )

# Trenger anslaget for 2021
nyttAnslag2021$giSumAnslag()

nyttAnslag2022 <-
    navR::Anslag$new(
        name = "mars2022",
        ar = 2022,
        # To måter å hente 2021-anslaget
        regnskap_ifjor = nyttAnslag2021$giSumAnslag(),
        volumvekst = (1 - 0.0000),
        vekst_ytelse = (1 - 0.000),
        prisvekst = 1.00,
        tiltak = (1 - 0.0147)
    )


bud$leggTilNyttAnslag( nyttAnslag2022, rekkefolge = 2 )


# Kan justeres etterhvert.
#nyttAnslag2020$setVolum( volumvekst = 1.02)

# Historiske anslag
forrige2021 <-
    navR::Anslag$new(
        name = "2021,des2020",
        ar = 2021,
        regnskap_ifjor = bud$giRegnskapstallIfjor(),
        volumvekst = (1-0.0048),
        vekst_ytelse = (1+0.000),
        prisvekst = 1.0271,
        tiltak = (1 - 0.0223)
    )

aug2020_anslag2021 <-
    navR::Anslag$new(
        name = "vedtatt bud2021, prop1 Augst2021",
        ar = 2021,
        regnskap_ifjor = (1684.14730721829)*10^6,
        volumvekst = (1-0.017),
        vekst_ytelse = (1+0.000),
        prisvekst = 1.0225,
        tiltak = (1 - 0.0225)
    )

#
forrige2021
bud$leggTilHistoriskAnslag( forrige2021, rekkefolge = 1)
bud$leggTilHistoriskAnslag( aug2020_anslag2021, rekkefolge = 2)

# Se anslagene
bud$giAnslag()
bud$giAnslag()[[2]]
bud$giHistoriskeAnslag()

bud$giHistoriskeAnslag()[[1]]


# Oppdater regnskapstabell, med anslag
bud$lagRegnskapTabell2( anslag1 = bud$giAnslag()[[1]] ,
                        anslag2 = bud$giAnslag()[[2]] ) %>%
    mutate_at( vars( regnskap , endring_regnskap, regnskap_fast, endring_regnskap_f ), function(x) {x/10^6}
               ) %>%
    mutate_at( vars(regnskap,  regnskap_fast) , function(x) ifelse(.$kategori == "Anslag", round(x, -1), x))



# Dekomponer, analyse mellom anslagene ------------------------------------

# Beholder denne som egen
bud$giAnslag()[[1]]$setPris( pris =  104514)
bud$giHistoriskeAnslag()[[1]]$setPris( pris =  103586)
bud$giHistoriskeAnslag()[[2]]$setPris( pris =   103072)

Dekomponer$new( anslag1 = bud$giHistoriskeAnslag()[[1]], anslag2 = bud$giAnslag()[[1]],  antall_1 = 10216, antall_2 = 10295  )$giDf()
Dekomponer$new( anslag1 = bud$giHistoriskeAnslag()[[1]], anslag2 = bud$giAnslag()[[1]],  antall_1 = 10216, antall_2 = 10295  )$giDekomponert()

Dekomponer$new( anslag1 = bud$giHistoriskeAnslag()[[2]], anslag2 = bud$giAnslag()[[1]], sumAnslag1 =  1638.477*10^6 , antall_1 = 10045, antall_2 = 10295  )$giDf()
Dekomponer$new( anslag1 = bud$giHistoriskeAnslag()[[2]], anslag2 = bud$giAnslag()[[1]], sumAnslag1 =  1638.477*10^6 , antall_1 = 10045, antall_2 = 10295  )$giDekomponert()



# Tabeller til forsiden ---------------------------------------------------

gj_ytelse_test <-
    navR::AvgMottakereYtelse$new(
        name = "test",
        dfMottakere = mottakere,
        dfRegnskap = regnskap,
        gj_pris = 104716,
        ANSLAG_AR = 2021,
        ANSLAG_MND_PERIODE = 8
    )


gj_ytelse_test$lagTabell()

