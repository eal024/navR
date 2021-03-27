

Budsjett <- R6::R6Class( "Budsjett",

                           public = list(
                               #library(tidyverse),
                               initialize = function( name, periode, dfRegnskap, g_gjeldende, dfMottakere, PRIS_VEKST, tiltak_pst, volumvekst, vekst_ytelse ) {

                                   private$name <- name
                                   private$ar <- str_sub(periode, start =1, end = 4) %>% as.integer()
                                   private$mnd <- ifelse( nchar(periode) < 5, str_sub(periode, start = 6, end = 6), str_sub(periode, start = 5, end = 6)) %>% as.integer()
                                   private$dfRegnskap <- dfRegnskap
                                   private$g_gjeldende <- g_gjeldende
                                   private$dfMottakere <- dfMottakere
                                   private$PRIS_VEKST <-PRIS_VEKST
                                   private$tiltak_pst <- tiltak_pst
                                   private$volumvekst <- volumvekst
                                   private$vekst_ytelse <- vekst_ytelse

                                   # Regnskapstabell
                                   private$regnskapTabell <- RegnskapTabell$new(
                                       dfRegnskap = private$dfRegnskap,
                                       g_gjeldende = private$g_gjeldende,
                                       anslag_ar = private$ar,
                                       anslag_mnd_periode = private$mnd)$lagRegnskapTabell()

                                   # Regnskapet året før
                                   private$REGNSKAP_ARET_FOR <- private$regnskapTabell$regnskap[private$regnskapTabell$ar == as.character(private$ar-1)]



                                   # Mottakertabell
                                   private$mottakerTabell <- Mottakere$new(
                                       name = private$name,
                                       dfMottakere = private$dfMottakere,
                                       ANSLAG_AR = private$ar,
                                       ANSLAG_MND_PERIODE = private$mnd)$lagTabell( )

                                   # mottakere året før
                                   private$MOTTAKERE_ARET_FOR <- private$mottakerTabell$gjennomsnitt[private$mottakerTabell$ar == as.character(private$ar-1)]

                                   # Anslaget nytt
                                   private$nytt_anslag <- Anslag$new(
                                       name = private$name,
                                       ar = private$ar,
                                       regnskap_ifjor = private$REGNSKAP_ARET_FOR,
                                       vekst_ytelse = private$vekst_ytelse,
                                       prisvekst = private$PRIS_VEKST,
                                       volumvekst = private$volumvekst,
                                       tiltak = private$tiltak_pst)

                                   #)

                               },


                               # Gi regnskapstabell
                               lagRegnskapTabell = function(  ){

                                   return( private$regnskapTabell   )

                               },

                               # Gi mottakertabell
                               lagMottakerTabell = function(  ){
                                   return( private$mottakerTabell  )
                               },

                               giRegnskapstallIfjor = function( ) {
                                   return(private$REGNSKAP_ARET_FOR)
                               },


                               # Legg til tidligere anslag
                               leggTilHistoriskAnslag = function( navn, ar, regnskap_ifjor,  prisvekst, volumvekst,tiltak) {

                                   # Historisk anslag 1
                                   private$historiskAnslag1 = Anslag$new(
                                       name = navn,
                                       ar = ar,
                                       regnskap_ifjor = regnskap_ifjor,
                                       prisvekst = prisvekst,
                                       volumvekst = volumvekst,
                                       tiltak = tiltak)
                               },

                               lagTabellMndUtviklingRegnskap = function(   ) {

                                   # If regnskapTabell or mottaker
                                   utvikling <- MndUtvikling$new( df_data = private$dfRegnskap,
                                                                  g_gjeldende = private$g_gjeldende,
                                                                  anslag_ar = private$ar,
                                                                  anslag_mnd_periode = private$mnd,
                                                                  PRIS_VEKST = private$PRIS_VEKST,
                                                                  REGNSKAP_ARET_FOR = private$REGNSKAP_ARET_FOR)




                                   return( utvikling$tabellMndUtvikling())

                               },
                               lagTabellMndUtviklingMottakere = function(   ) {

                                   # Slå sammen med lagTabell i liste deretter returner en fra listen
                                   utvikling <- MndUtvikling$new( df_data = private$dfMottakere,
                                                                  # For mottakere
                                                                  #df_data = private$dfMottakere,
                                                                  g_gjeldende = private$g_gjeldende,
                                                                  anslag_ar = private$ar,
                                                                  anslag_mnd_periode = private$mnd,
                                                                  PRIS_VEKST = private$PRIS_VEKST,
                                                                  REGNSKAP_ARET_FOR = private$REGNSKAP_ARET_FOR,
                                                                  MOTTAKERE_ARET_FOR = private$MOTTAKERE_ARET_FOR )

                                   return( utvikling$tabellMndUtvikling())

                               },


                               # # Gi anslagene i liste ----------------------------------------------
                               giAnslag = function( ) { return( list(
                                   # Nytt anslag
                                   nytt_anslag = list( private$nytt_anslag, private$nytt_anslag$dfAnslag()  )
                               )
                               ) },

                               # Gi info om anslag
                               giInfoOmAnslag = function( ) {return(private$nytt_anslag)},


                               # Skriv ut alt
                               skrivUtTabeller = function( ) { list(nytt_anslag = private$nytt_anslag$dfAnslag(), hist_regnskap = private$regnskapTabell  ) %>% writexl::write_xlsx( str_c(today()," ",paste0(private$name) ," tabller.xlsx" )) },


                               giM = function( ) { return(private$MOTTAKERE_ARET_FOR)},

                               # Print
                               print = function(...){
                                   cat("Anslaget er:", private$name," For ar: ", private$ar, "\n");
                                   # cat("Regnskapet i fjor viser:", private$dfRegnskap[private$dfRegnskap$ar == (private$ar-1)], "\n")
                                   # cat("G er ", private$G, "\n")
                               }
                           ),
                           # Private
                           private = list(name = NULL,
                                          ar= NULL ,
                                          mnd = NULL,
                                          dfRegnskap = NULL,
                                          test = NULL,
                                          g_gjeldende = NULL,
                                          dfMottakere = NULL,
                                          PRIS_VEKST = NULL,
                                          mottakerTabell = NULL,
                                          regnskapTabell = NULL,
                                          REGNSKAP_ARET_FOR = NULL,
                                          MOTTAKERE_ARET_FOR = NULL,
                                          # Nytt anslag
                                          nytt_anslag = NULL,
                                          vekst_ytelse = NULL,
                                          tiltak_pst = NULL,
                                          volumvekst = NULL,
                                          historiskAnslag1 = NULL
                                          # dfForutseting = NULL,
                                          #G = NA
                           )
)
