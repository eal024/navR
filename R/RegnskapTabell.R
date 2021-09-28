#' R6 Class Regnskapstabell
#'
#' @description
#' Tabellen viser nominelle og prisjustert utgifter. Per ar og per mnd i innevaerende ar.
#'
#' @details
#' Tabellen ma "lages" med metode "lagTabell".
#'
#' @param dfRegnskap data.frame med regnskapstall per mnd. input data skal ha tre rader  dato ("YYYY-MM-DD"), nominelle regnskapstall per mnd og prisjusterer per mnd.
#' @param pris_gjeldende  Forutsatt prisjusterer.
#' @param anslag_ar  Gjeldende ar for anslaget
#' @param anslag_mnd_periode  Gjeldende maned for anslaget
#' @return Tabell med arlige summerte regnskapstall

#' @examples
#' Opprett forst class obj_tabell <- regnskapstabell:RegnskapTabell$new(
#'    dfRegnskap = navR::regnskap,
#'    pris_gjeldende = 104817,
#'    anslag_ar = 2021,
#'    anslag_mnd_periode = 2,
#'    post = "post70"
#'    )
#'
#' Dertter lag tabell med metode:
#' obj_tabell$lagRegnskapTabell()
#' Når anslaget er laget legges anslagene til med metoden lagRegnskapTabell2( anslag1, anslag2 ),
#' eks: obj_tabell$lagRegnskapTabell2(anslag2020, anslag2021)



RegnskapTabell <- R6::R6Class( "Regnskapstabell",

                               public = list(

                                   initialize = function( dfRegnskap, pris_gjeldende, anslag_ar, anslag_mnd_periode, post = "post70"){
                                       #
                                       private$dfRegnskap         <- dfRegnskap
                                       private$pris_gjeldende     <- pris_gjeldende
                                       private$anslag_ar          <- anslag_ar
                                       private$anslag_mnd_periode <- anslag_mnd_periode
                                       private$post <- post
                                       private$ifjor_regnskap <- " Enda ikke utregnet"
                                   },

                                   # Lag regnskapstabell
                                   lagRegnskapTabell = function( celing_date = TRUE) {

                                       # Ma passe med resterende del
                                       prisjusterer <- private$pris_gjeldende

                                       # Regnskaptabell
                                       tabell_regnskap_del0 <-
                                           private$dfRegnskap %>%
                                           # Endre g til pris
                                           dplyr::select( dato, regnskap_nominell = regnskap, pris)  %>%
                                           # # Denne må justeres
                                           dplyr::mutate( kategori = "post70") %>%
                                           dplyr::group_by(  ar = lubridate::year(dato)) %>%
                                           dplyr::summarise( regnskap = sum( regnskap_nominell,na.rm = T),
                                                             pris_snitt =   mean(pris, na.rm = T),
                                                             .groups = "drop") %>%
                                           dplyr::mutate( regnskap_fast = (regnskap*prisjusterer)/pris_snitt )

                                       private$tabell_regnskap_del0 <- tabell_regnskap_del0

                                       tabell_regnskap_del1 <-
                                           tabell_regnskap_del0 %>%
                                           dplyr::filter( between(ar, (private$anslag_ar-7 ),( ifelse(private$anslag_mnd_periode == 12,(private$anslag_ar),(private$anslag_ar -1) ) ) ))  %>%
                                           #dplyr::arrange( kategori) %>%
                                           #dplyr::group_by(kategori) %>%
                                           dplyr::mutate( endring_regnskap = regnskap-lag(regnskap),
                                                          endring_regnskap_f = regnskap_fast -lag(regnskap_fast),
                                                          regnskap_vekst = regnskap/lag(regnskap)-1,
                                                          regnskap_fast_vekst = regnskap_fast/lag(regnskap_fast)-1) %>%
                                           tidyr::drop_na() %>%
                                           dplyr::select( ar,  regnskap, endring_regnskap, regnskap_vekst, pris_snitt, regnskap_fast, endring_regnskap_f, regnskap_fast_vekst) %>%
                                           dplyr::mutate( ar = as.character(ar))

                                       # #
                                       # #
                                       # #
                                       # # # Del2
                                       tabell_regnskap_del2 <-
                                           private$dfRegnskap %>%
                                           dplyr::select( dato, regnskap_nominell = regnskap, pris) %>%
                                           dplyr::filter(  lubridate::year(dato) <= (private$anslag_ar),
                                                           lubridate::year(dato) > (private$anslag_ar-3) ,
                                                           lubridate::month(dato) <= private$anslag_mnd_periode
                                                            ) %>%
                                           dplyr::group_by( ar = lubridate::year(dato) ) %>%
                                           dplyr::summarise( regnskap   =  sum( regnskap_nominell,na.rm = T),
                                                             pris_snitt =   mean(pris, na.rm = T),
                                                             .groups    = "drop") %>%
                                           dplyr::filter( ar > 2013) %>%
                                           dplyr::mutate( regnskap_fast = ((regnskap*prisjusterer)/pris_snitt) ) %>%
                                           dplyr::mutate( ar = str_c(ar,"-",
                                                                     ifelse(private$anslag_mnd_periode < 10, str_c("0",(private$anslag_mnd_periode) ),(private$anslag_mnd_periode) ),"-01") ) %>%
                                           dplyr::relocate( contains("snitt"), .after = last_col() )
                                       # #
                                       # #
                                       #
                                       if( celing_date == T ) {tabell_regnskap_del2 <- tabell_regnskap_del2 %>%
                                           dplyr::mutate( ar = (lubridate::ceiling_date(ymd(ar), unit = "month") -1) %>% as.character()  )  }

                                       #
                                       tabell_regnskap_del2_2 <-
                                           tabell_regnskap_del2  %>%
                                           dplyr::mutate( verdi_faktor = pris_snitt ) %>%
                                           dplyr::mutate( faktor = "pris_snitt") %>%
                                           #dplyr::group_by(  ar ) %>%
                                           dplyr::mutate( verdi_faktor_1 = verdi_faktor  )  %>%
                                           dplyr::distinct() %>%
                                           dplyr::mutate( endring_regnskap = regnskap-lag(regnskap),
                                                          endring_regnskap_f = regnskap_fast -lag(regnskap_fast),
                                                          regnskap_vekst = regnskap/lag(regnskap)-1,
                                                          regnskap_fast_vekst = regnskap_fast/lag(regnskap_fast)-1) %>%
                                           tidyr::drop_na( ) %>%
                                           dplyr::select( ar,  regnskap, endring_regnskap, regnskap_vekst, pris_snitt = verdi_faktor_1, regnskap_fast, endring_regnskap_f, regnskap_fast_vekst)

                                       #
                                       private$tabell_regnskap_historikk <- dplyr::bind_rows( tabell_regnskap_del1  %>% mutate( ar = as.character(ar)), tabell_regnskap_del2_2) %>%
                                           mutate( kategori = "Regnskap") %>%
                                           dplyr::ungroup()
                                       #
                                       #
                                       private$ifjor_regnskap = private$tabell_regnskap_historikk %>% dplyr::filter( ar == as.character(private$anslag_ar-1) ) %>% dplyr::pull(regnskap)/10^6
                                       #


                                       return(private$tabell_regnskap_historikk  %>%
                                                  dplyr::select( kategori, everything())
                                              )


                                   },



                                   giRegnskaptallAr = function( ar ) {

                                       private$dfRegnskap %>% dplyr::filter( lubridate::year(dato) == ar ) %>% dplyr::summarise( r = sum(regnskap)) %>% pull(r)


                                   },

                                   tabellRegnskapDel3 = function( anslag1, anslag2 ){

                                       df <- tibble(

                                           kategori = c("Anslag", "Anslag") ,
                                           ar =       c(anslag1$giAr(),anslag2$giAr() ),
                                           regnskap = c( anslag1$giSumAnslag(),anslag2$giSumAnslag()),
                                           pris_snitt = c( private$pris_gjeldende, private$pris_gjeldende*anslag2$giPrisvekst() ),
                                           regnskap_fast = c( anslag1$giSumAnslag() ,anslag2$giSumAnslag()/anslag2$giPrisvekst() )
                                       )

                                       df2 <- bind_rows( private$tabell_regnskap_del0 %>% dplyr::filter( ar < anslag1$giAr() ), df )

                                       df3 <- df2 %>%
                                           dplyr::arrange( ar) %>%
                                           dplyr::mutate( endring_regnskap = regnskap-lag(regnskap),
                                                          endring_regnskap_f = regnskap_fast -lag(regnskap_fast),
                                                          regnskap_vekst = regnskap/lag(regnskap)-1,
                                                          #pris_snitt = c( private$g_gjeldende, private$g_gjeldende*anslag2$giPrisvekst() ),
                                                          regnskap_fast_vekst = regnskap_fast/lag(regnskap_fast)-1) %>%
                                           tidyr::drop_na() %>%
                                           dplyr::mutate( ar = as.character(ar) ) %>%
                                           dplyr::select( ar,  regnskap, endring_regnskap, regnskap_vekst,pris_snitt, regnskap_fast, endring_regnskap_f, regnskap_fast_vekst, kategori) %>%
                                           dplyr::filter( dplyr::between(ar, (private$anslag_ar), (private$anslag_ar+1) ) )


                                       return( df3 )

                                   },

                                   lagRegnskapTabell2 = function( anslag1, anslag2, printversjon = FALSE, celing_date = TRUE) {

                                       df  <- self$lagRegnskapTabell(celing_date = celing_date)
                                       df2 <- self$tabellRegnskapDel3(anslag1, anslag2)
                                       df3 <- dplyr::bind_rows(df, df2) %>%
                                           dplyr::select( kategori, everything())

                                       if( printversjon == FALSE){df3} else {

                                           #
                                           df3 %>% dplyr::mutate_at(
                                               vars(regnskap, endring_regnskap, regnskap_fast, endring_regnskap_f),
                                               function(x) x/10^6
                                           )
                                       }

                                   },


                                   # Print
                                   print = function(...){
                                       cat("Dette er test av automatisering av regnskapstabellen:", "\n");
                                       cat("Ifjor ", (private$anslag_ar-1), ": " ,private$ifjor_regnskap, " mill.kroner\n");
                                   }
                               ),
                               # Private
                               private = list(
                                   ifjor_regnskap = NULL,
                                   dfRegnskap = NULL,
                                   anslag_ar = NULL,
                                   pris_gjeldende = NULL,
                                   anslag_mnd_periode = NULL,
                                   tabell_regnskap_historikk = NULL,
                                   post = NULL,
                                   tabell_regnskap_del0 = NULL
                               )

)
#
#
#
#
#
#
