#' Budsjettobjektet.
#'
#' Hovedobjektet til budsjettdokumentet.
#' Budsjett-objektet har metoder som lager tabeller, og gir navn i tabeller og tekst.
#' Det skal være et budsjett-objekt for hver post.

#' @param name Det lange og spesifiserte navnet paa anslaget.
#' @param name_nytt_anslag kortnavnet eks. "oktober-anslaget"
#' @param kapittelpost kapittel og post, format som 2620.70

Budsjett <- R6::R6Class( "Budsjett",

                         public = list(
                             #library(tidyverse),
                             initialize = function( name,
                                                    name_nytt_anslag,
                                                    periode,
                                                    dfRegnskap,
                                                    pris_gjeldende,
                                                    dfMottakere,
                                                    PRIS_VEKST,
                                                    nyeAnslag = NULL,
                                                    historiskeAnslag = NULL,
                                                    kapittelpost = NULL,
                                                    regnskap = NULL
                             ) {

                                 ## Private variabler deklareres:
                                 private$name <- name;
                                 private$kapittelpost <- kapittelpost;

                                 #private$name_nytt_anslag <- name_nytt_anslag
                                 private$ar <- stringr::str_sub( as.character(periode), start = 1, end = 4) %>% as.integer()
                                 private$mnd <- ifelse( nchar(periode) < 5, stringr::str_sub(periode, start = 6, end = 6), str_sub(periode, start = 5, end = 6)) %>% as.integer()

                                 # Data
                                 private$dfRegnskap <- dfRegnskap
                                 private$dfMottakere <- dfMottakere

                                 # Brukes i ulike tabeller
                                 private$pris_gjeldende <- pris_gjeldende

                                 # Brukes anslag og månedsutvikling: Kan forenkles -> bruk kun pris_gjeldende
                                 private$PRIS_VEKST <-PRIS_VEKST

                                 #private$tiltak_pst <- tiltak_pst
                                 #private$volumvekst <- volumvekst
                                 #private$vekst_ytelse <- vekst_ytelse

                                 ## Samling av anslagene i lister:
                                 private$historiskeAnslag <- ifelse( is.null(nyeAnslag), list(), ifelse( class(nyeAnslag) != "list", stop("må enten være NULL, eller en liste"), nyeAnslag ) )
                                 private$nyeAnslag <-  ifelse( is.null(nyeAnslag), list(), ifelse( class(nyeAnslag) != "list", stop("må enten være NULL, eller en liste"), nyeAnslag ) )



                                 #     # Object regnskapstabell -> se metodene lagRegnskapstabell
                                 private$regnskapTabell <- RegnskapTabell$new(
                                     dfRegnskap = private$dfRegnskap,
                                     pris_gjeldende = private$pris_gjeldende,
                                     anslag_ar = private$ar,
                                     anslag_mnd_periode = private$mnd)

                                 #     # Regnskapet året før
                                 private$REGNSKAP_ARET_FOR <- private$regnskapTabell$giRegnskaptallAr( (private$ar - 1) )
                                 #
                                 #
                                 # #     # Mottakertabell
                                 private$mottakerTabell <- Mottakere$new(
                                     name = private$name,
                                     dfMottakere = private$dfMottakere,
                                     ANSLAG_AR = private$ar,
                                     ANSLAG_MND_PERIODE = private$mnd)$lagTabell( )
                                 # #
                                 # #     # mottakere året før
                                 private$MOTTAKERE_ARET_FOR <- private$mottakerTabell$gjennomsnitt[private$mottakerTabell$ar == as.character(private$ar-1)]
                                 # #
                                 # #     # Anslaget nytt
                                 # private$nytt_anslag <- Anslag$new(
                                 #     # Navn på anslag fra navn_nytt_anslag
                                 #     name = private$name_nytt_anslag,
                                 #     ar = private$ar,
                                 #     regnskap_ifjor = private$REGNSKAP_ARET_FOR,
                                 #     vekst_ytelse = private$vekst_ytelse,
                                 #     prisvekst = private$PRIS_VEKST,
                                 #     volumvekst = private$volumvekst,
                                 #     tiltak = private$tiltak_pst
                                 #     )

                                 # private$nytt_anslag$dfAnslag()

                                 # private$nytt_anslag <- private$nytt_anslag
                                 #
                                 # # # Nytt anslag blir lagt til listen "nyeAnslag"

                                 # private$nyeAnslag[[1]] <- private$nytt_anslag

                                 #private$nyeAnslag <- set_names(private$nyeAnslag, purrr::map_chr(private$nyeAnslag, ~.x$giAnslagNavn() %>% as.character() ) )



                                 # #
                                 #     # Nye anslag
                                 # #     # Nytt anslag dette år må alltid komme først. #private$nytt_anslag$giAnslagNavn() = private$nytt_anslag
                                 #private$nyeAnslag <- return(private$nytt_anslag$giAnslagNavn() )
                                 # #
                                 # #
                                 #
                                 #
                             },

                             # Gi regnskapstabell
                             lagRegnskapTabell = function(  ){

                                 return( private$regnskapTabell$lagRegnskapTabell()   )

                             },

                             # Regnskapstabell med anslagene
                             lagRegnskapTabell2 = function( anslag1 , anslag2 , printversjon = FALSE, celing_date = TRUE){

                                 return( private$regnskapTabell$lagRegnskapTabell2(anslag1 = anslag1, anslag2 = anslag2, printversjon = printversjon, celing_date = celing_date)   )

                             },



                             # Gi mottakertabell
                             lagMottakerTabell = function(  ){
                                 return( private$mottakerTabell  )
                             },


                             giRegnskapstall = function( ar_til_bake ) {
                                 return(private$regnskapTabell$giRegnskaptallAr( (private$ar - ar_til_bake) ))
                             },

                             giRegnskapstallIfjor = function( ) {
                                 return(private$REGNSKAP_ARET_FOR)
                             },
                             #

                             #

                             ## Månedsutvikling regnskapet
                             lagTabellMndUtviklingRegnskap = function( tiltak_kost_ar1 = NULL, tiltak_kost_ar2 = NULL  ) {

                                 # If regnskapTabell or mottaker
                                 utvikling <- MndUtvikling$new( df_data = private$dfRegnskap,
                                                                pris_gjeldende = private$pris_gjeldende,
                                                                anslag_ar = private$ar,
                                                                anslag_mnd_periode = private$mnd,
                                                                PRIS_VEKST = private$PRIS_VEKST,
                                                                REGNSKAP_ARET_FOR = private$REGNSKAP_ARET_FOR

                                 )

                                 # Utvikling tabell.
                                 mndTabellRegnskap <- utvikling$tabellMndUtvikling( tiltak_kost_ar1 = tiltak_kost_ar1 , tiltak_kost_ar2 = tiltak_kost_ar2  )

                                 mndTabellRegnskap_1 <- mndTabellRegnskap %>%
                                     group_by(lengde) %>%
                                     mutate( lengde =  stringr::str_c( periode_for( self$giPeriode(), lengde, ar = 1), " til ",periode_for(self$giPeriode(), lengde, ar = 0)  ) )

                                 return( mndTabellRegnskap_1 )

                             },

                             ## Utvikling mottakere:
                             lagTabellMndUtviklingMottakere = function(   ) {

                                 # Slå sammen med lagTabell i liste deretter returner en fra listen
                                 utvikling <- MndUtvikling$new( df_data = private$dfMottakere,
                                                                # For mottakere
                                                                #df_data = private$dfMottakere,
                                                                pris_gjeldende = private$pris_gjeldende,
                                                                anslag_ar = private$ar,
                                                                anslag_mnd_periode = private$mnd,
                                                                PRIS_VEKST = private$PRIS_VEKST,
                                                                REGNSKAP_ARET_FOR = private$REGNSKAP_ARET_FOR,
                                                                MOTTAKERE_ARET_FOR = private$MOTTAKERE_ARET_FOR )

                                 df <- utvikling$tabellMndUtvikling() %>%
                                     group_by(lengde) %>%
                                     mutate( lengde =  stringr::str_c( periode_for( self$giPeriode(), lengde, ar = 1), " til ",periode_for(self$giPeriode(), lengde, ar = 0)  ) )


                                 return( df )

                             },


                             setKapittelpost = function( kapittelpost ) {

                                 private$kapittelpost = kapittelpost
                             },

                             giKapittelpost  = function( kapittelpost ) {return(private$kapittelpost) },




                             # # Nye anslag: Retur av liste og retur av df ----------------------------------------------

                             # lagNyttAnslagNesteAr = function(  name,
                             #                                ar = NULL,
                             #                                regnskap_ifjor = NULL,
                             #                                vekst_ytelse = NULL,
                             #                                prisvekst = NULL,
                             #                                volumvekst = NULL,
                             #                                tiltak = NULL,
                             #                                underregulering = NULL ) {
                             #
                             #
                             #                                                           anslag <- Anslag$new(  name = name,
                             #                                                                        ar = ar,
                             #                                                                        regnskap_ifjor = regnskap_ifjor,
                             #                                                                        prisvekst = prisvekst,
                             #                                                                        volumvekst = volumvekst,
                             #                                                                        tiltak = tiltak,
                             #                                                                        underregulering = underregulering)
                             #
                             #                                                           anslag
                             #
                             #
                             #
                             #     },

                             leggTilNyttAnslag = function( anslag, rekkefolge ) {

                                 # Denne må forbedres
                                 private$nyeAnslag[[rekkefolge]] <- anslag
                                 #
                                 #private$nyeAnslag <- set_names(private$nyeAnslag, purrr::map_chr(private$nyeAnslag, ~.x$giAnslagNavn() %>% as.character()) )

                                 private$nyeAnslag

                             },

                             giPeriode = function( ) {
                                 return( lubridate::ymd(str_c(private$ar, "-", private$mnd, "-01") ) )
                             },


                             ## Retur av liste
                             giAnslag = function( ) {
                                 # Nytt anslag
                                 private$nyeAnslag





                             },
                             #



                             # Historiske anslag -------------------------------------------------------

                             # # Legg til tidligere anslag
                             leggTilHistoriskAnslag = function( anslag, rekkefolge) {

                                 private$historiskeAnslag[[rekkefolge]] <- anslag

                                 navn <- purrr::map_chr(private$historiskeAnslag, function(x)
                                     if(is.null(x$giKortNavn())){ return(x$giAnslagNavn())} else{x$giKortNavn()}

                                 )

                                 private$historiskeAnslag <- set_names(private$historiskeAnslag, navn)



                             },
                             #

                             # ## Print ut historiske anslag
                             giHistoriskeAnslag = function(  ) { private$historiskeAnslag },


                             # Sammenlikne nytt med historiske anslag ----------------------------------

                             gidfRegnskap  = function( ) { return(private$dfRegnskap) },
                             gidfMottakere = function( ) { return(private$dfMottakere) },







                             # Print -------------------------------------------------------------------
                             print = function(...){
                                 cat("Dette er budsjettet for ", private$kapittelpost  ,". Året er  ",private$ar,"og mnd  er", private$mnd, "\n")
                                 cat("Anslaget er:", private$name," For ar: ", private$ar, "\n");
                                 #     cat("Regnskapet i fjor viser:", private$dfRegnskap[private$dfRegnskap$ar == (private$ar-1)], "\n")
                                 #     # cat("G er ", private$G, "\n")
                             }
                         ),
                         # Private
                         private = list(name = NULL,
                                        name_nytt_anslag = NULL,
                                        kapittelpost = NULL,
                                        ar = NULL,
                                        mnd = NULL,
                                        dfRegnskap = NULL,
                                        pris_gjeldende = NULL,
                                        dfMottakere = NULL,
                                        PRIS_VEKST = NULL,
                                        #vekst_ytelse = NULL,
                                        #tiltak_pst = NULL,
                                        #volumvekst = NULL,

                                        mottakerTabell = NULL,
                                        regnskapTabell = NULL,
                                        REGNSKAP_ARET_FOR = NULL,
                                        MOTTAKERE_ARET_FOR = NULL,

                                        # # Anslag
                                        #nytt_anslag = NULL,
                                        #nytt_anslag_neste_ar = NULL,
                                        historiskeAnslag = NULL,
                                        nyeAnslag = NULL,
                                        regnskap = NULL


                         )
)


#' @export
