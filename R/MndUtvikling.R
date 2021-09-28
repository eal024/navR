#' R6 Class MndUtvikling
#'
#' @description
#' Tabell som viser manedlig endring, sammenliknet med tilsvarende periode aret for.
#' Periodene som vises er 3-, 6-, 9- og 12-mandersutviklingen.
#'
#' @details
#' Object MndUtviling opprettes forst, deretter lager du tabellen med method: tabellMndUtvikling
#' Ved kolonne == mottakere, lages tabell av mottakere, hvis regnskap, lages regnskapsutviling
#'
#'
#' @param df_data data.frame med regnskap eller mottakere
#' @param anslag_ar  Gjeldende ar for anslaget
#' @param anslag_mnd_periode  Gjeldende maned for anslaget

#' @return Tabell med mnd utvikling

#' @examples
#' Opprett forst class navR::MndUtvikling$new()
#'
#' Dertter navR::MndUtvikling$new()$tabellMndUtvikling()


MndUtvikling <- R6::R6Class( "mnd utvikling",

                             public = list(
                                 initialize = function( df_data, anslag_ar = NULL, anslag_mnd_periode = NULL, REGNSKAP_ARET_FOR = NULL , MOTTAKERE_ARET_FOR = NULL, PRIS_VEKST = NULL, pris_gjeldende = NULL ) {
                                     #library(lubridate)
                                     private$pris_gjeldende <- pris_gjeldende
                                     private$anslag_ar <- anslag_ar
                                     private$anslag_mnd_periode <- anslag_mnd_periode
                                     private$df_data <- df_data
                                     private$REGNSKAP_ARET_FOR <- REGNSKAP_ARET_FOR
                                     private$MOTTAKERE_ARET_FOR <- MOTTAKERE_ARET_FOR
                                     private$PRIS_VEKST <- PRIS_VEKST
                                     private$k <- ifelse( sum(str_detect(names(private$df_data),"mottakere")) > 0,  "mottakere","regnskap" )

                                 },
                                 # Lag regnskapstabell
                                 tabellMndUtvikling = function( tiltak_kost_ar1 = NULL, tiltak_kost_ar2 = NULL ){

                                     if(is.null(tiltak_kost_ar1)){ private$tiltak_kost_ar1  = 0} else{private$tiltak_kost_ar1 = tiltak_kost_ar1 }
                                     if(is.null(tiltak_kost_ar2)){ private$tiltak_kost_ar2  = 0} else{private$tiltak_kost_ar2 = tiltak_kost_ar2 }
                                     df_data         <- private$df_data
                                     var_ar          <- private$anslag_ar
                                     var_mnd         <- private$anslag_mnd_periode
                                     pris_gjeldende     <- private$pris_gjeldende



                                     # Del 1: Returnerer fra til mnd df_data
                                     df_ramme <- tibble(
                                         # Lengde og fra_mnd
                                         lengde = rep( c(2,5,8,11), times = 2),
                                         fra_mnd =  c( str_c( (var_ar-1) , "-", ifelse(var_mnd < 10, str_c("0",var_mnd),var_mnd ),"-01") %>% rep( times = 4),
                                                       str_c( var_ar, "-", ifelse(var_mnd < 10, str_c("0",var_mnd), var_mnd ),"-01") %>% rep( times = 4)) %>% lubridate::ymd(),
                                         # Data fra privat
                                         df_data = list(private$df_data )
                                     ) %>%
                                         mutate( til_mnd = fra_mnd - c( months(c(2,5,8,11)) )) %>%
                                         select( lengde,  fra_mnd, til_mnd, df_data)


                                     # Del2
                                     # Utregningen
                                     df_del1 <-
                                         df_ramme %>%
                                         # Denne kan gjøres i en linje:
                                         mutate(
                                             df_data = map2(df_data, fra_mnd , function(x,y) {x %>% filter( dato <= y )} ),
                                             df_data = map2(df_data, til_mnd , function(x,y) {x %>% filter( dato >= y )} )
                                         )
                                     # #
                                     # # # Om regnskap lager df_del2 lik regnskap, ellers lik mottakre

                                     ifelse( private$k == "regnskap",
                                             # Regnskap
                                             df_del2 <- df_del1 %>%
                                                 #
                                                 mutate( sum = map( df_data , function(x){
                                                     x %>% mutate( verdier_faste = regnskap*pris_gjeldende/pris ) %>%  summarise( verdier_faste = sum(verdier_faste))})
                                                 ),
                                             # Mottakere
                                             df_del2 <- df_del1 %>%
                                                 mutate( sum = map( df_data , function(x){
                                                     x %>%   summarise( verdier_faste = mean(mottakere))})  )
                                     )

                                     # #
                                     # # # Her regnes antall per mnd.
                                     df_del3 <- df_del2 %>%
                                         select(lengde,  contains("mnd"), sum) %>%
                                         unnest(sum) %>%
                                         mutate( ar = lubridate::year(fra_mnd), lengde = lengde+1 ) %>%
                                         select( lengde, ar, verdier_faste) %>%
                                         group_by(  lengde) %>%
                                         # Denne kan endres og heller referere til ar i år og år i fjor: og rowwise -> nå er år x2020 og x2019 -> dette vil jo endres dynamisk.
                                         mutate( vekst = ( verdier_faste[ar == var_ar] - verdier_faste[ar == (var_ar-1)] )/ verdier_faste[ar == (var_ar - 1) ] ) %>%
                                         pivot_wider( names_from = ar, values_from = verdier_faste) %>% janitor::clean_names() %>% ungroup() %>%
                                         rename(  forrige = 3, naa = 4)


                                     # Utregning av anslag basert på utvikling:
                                     # Her skal også tiltak legges til
                                     # # Mellomsteg
                                     # Utregning av antall i år
                                     verdi_i_ar <- ifelse( private$k == "regnskap",
                                                           # Om regnskap blir verdien i år:
                                                           df_data %>% group_by(ar = lubridate::year(dato)) %>%  filter( ar == var_ar) %>% summarise( verdi = sum(regnskap, na.rm = T) ) %>% pull(verdi),
                                                           # Om navn kolonne df-input er mottaker (definert som k) = blir verdi snitt mottaker per mnd.
                                                           df_data %>% group_by(ar = lubridate::year(dato)) %>%  filter( ar == var_ar) %>% summarise( verdi = mean(mottakere, na.rm =T)) %>% pull(verdi)
                                     )
                                     #
                                     # #
                                     # Nest år
                                     ifelse(private$k == "regnskap",
                                            # Om siste mnd. er mnd 12 (var_mnd == 12), vil naa være neste år.
                                            df_periode_tabell <- df_del3 %>% mutate( nytt_ar = ifelse(var_mnd == 12, verdi_i_ar, private$REGNSKAP_ARET_FOR)*(1+vekst)*(private$PRIS_VEKST) ),
                                            # Mottakere
                                            df_periode_tabell <- df_del3 %>% mutate( nytt_ar = ifelse(var_mnd == 12, verdi_i_ar, private$MOTTAKERE_ARET_FOR)*(1+vekst))
                                     )
                                     # # # Nest år pluss ett år til
                                     ifelse(private$k == "regnskap",
                                            # Om siste mnd. er mnd 12 (var_mnd == 12), vil naa være neste år.
                                            df_periode_tabell <- df_periode_tabell %>% mutate( nytt_ar_2 = nytt_ar*(1+vekst) ),
                                            # Mottakere
                                            df_periode_tabell <- df_periode_tabell %>% mutate( nytt_ar_2 = nytt_ar*(1+vekst))
                                     )

                                     #df_periode_tabell

                                     ny <-  (ncol(df_periode_tabell)-2)
                                     ny2 <- (ncol(df_periode_tabell)-1)
                                     #
                                     names(df_periode_tabell) <- c(names(df_periode_tabell)[c(1:(length(df_periode_tabell)-2) )],
                                                                   # Nytt navn neste år
                                                                   str_c("anslag_", as.character(var_ar)),
                                                                   # Nytt navn året etter neste
                                                                   str_c("anslag_", as.character(var_ar+1)) )


                                     # Legg til tiltak
                                     df_periode_tabell[5] <- df_periode_tabell[5] + private$tiltak_kost_ar1
                                     df_periode_tabell[6] <- df_periode_tabell[6] + private$tiltak_kost_ar1 + private$tiltak_kost_ar2

                                     # Retur:
                                     df_periode_tabell

                                 },

                                 giK = function( ){
                                     return(private$REGNSKAP_ARET_FOR)
                                 },
                                 # Print
                                 print = function(...){
                                     cat("Mndutvikling for:", private$k ,"\n")
                                 }
                             ),
                             # Private
                             private = list(
                                 anslag_mnd_periode = NULL,
                                 anslag_ar = NULL,
                                 df_data = NULL,
                                 REGNSKAP_ARET_FOR = NULL,
                                 PRIS_VEKST = NULL,
                                 MOTTAKERE_ARET_FOR = NULL,
                                 k = NULL,
                                 pris_gjeldende =  NULL,
                                 tiltak_kost_ar1 = NULL,
                                 tiltak_kost_ar2 = NULL
                             )
)
