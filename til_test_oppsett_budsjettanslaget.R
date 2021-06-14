


# Oppsett budsjettanslag.
# Eksempelet er basert på budsjettanslaget kapittel 2620 mars 2020.
library(tidyverse)
library(navR)


# Data og forutsetninger
regnskap_feb <- navR::regnskap %>% filter( dato < lubridate::ymd("2021-03-01")) %>% arrange( desc(dato))
mottakere_feb <- navR::mottakere %>% filter( dato < lubridate::ymd("2021-03-01"))%>% arrange( desc(dato))

# Pris
#g_20 <- 100853
g_21 <- 104514



# Budsjettet
bud <- navR::Budsjett$new(     name = "Test 1 for kap 2620, feb 2021",
                               name_nytt_anslag = "feb2020",
                               periode = 202102,
                               dfRegnskap = regnskap_feb,
                               dfMottakere =  mottakere_feb %>% mutate(kategori = "post70"),
                               g_gjeldende = g_21,
                               PRIS_VEKST = (104514/98866)
                          )

# Tabeller som viser statistikk.
bud$lagRegnskapTabell( )
bud$lagMottakerTabell()

bud$lagTabellMndUtviklingRegnskap()
bud$lagTabellMndUtviklingMottakere()

# Denne kan være giRegnskapstallHistorie( ar == )

## Må forbedres. Gi regnskapstall for et gitt år.
bud$giRegnskapstallIfjor( )



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

bud$lagRegnskapTabell2( ans)











