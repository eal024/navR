#
#
# RegnskapTabell <- R6::R6Class( "Regnskapstabell",
#
#                                public = list(
#
#                                    initialize = function( dfRegnskap, g_gjeldende, anslag_ar, anslag_mnd_periode, post = "post70"){
#                                        #
#                                        private$dfRegnskap  <-     dfRegnskap
#                                        private$g_gjeldende <-     g_gjeldende
#                                        private$anslag_ar          <- anslag_ar
#                                        private$anslag_mnd_periode <- anslag_mnd_periode
#                                        private$post <- post
#                                        private$ifjor_regnskap <- " Enda ikke utregnet"
#                                    },
#
#                                    # Lag regnskapstabell
#                                    lagRegnskapTabell = function(  ) {
#
#                                        # Ma passe med resterende del
#                                        prisjusterer <- private$g_gjeldende
#
#                                        # Regnskaptabell
#                                        tabell_regnskap_del0 <-
#                                            private$dfRegnskap %>%
#                                            dplyr::select( dato, regnskap_nominell = regnskap, g)  %>%
#                                            # # Denne må justeres
#                                            dplyr::mutate( kategori = "post70") %>%
#                                            dplyr::group_by( kategori, ar = lubridate::year(dato)) %>%
#                                            dplyr::summarise( regnskap = sum( regnskap_nominell,na.rm = T),
#                                                              g_snitt =   mean(g, na.rm = T),
#                                                              .groups = "drop") %>%
#                                            dplyr::mutate( regnskap_fast = case_when(
#                                                stringr::str_detect(kategori, "70") ~ ((regnskap*prisjusterer)/g_snitt))
#                                            )
#
#                                        private$tabell_regnskap_del0 <- tabell_regnskap_del0
#
#                                        tabell_regnskap_del1 <-
#                                            tabell_regnskap_del0 %>%
#                                            dplyr::filter( between(ar, (private$anslag_ar-7 ),( ifelse(private$anslag_mnd_periode == 12,(private$anslag_ar),(private$anslag_ar -1) ) ) ))  %>%
#                                            dplyr::arrange( kategori) %>%
#                                            dplyr::select(-c(g_snitt))%>%
#                                            dplyr::group_by(kategori) %>%
#                                            dplyr::mutate( endring_regnskap = regnskap-lag(regnskap),
#                                                           endring_regnskap_f = regnskap_fast -lag(regnskap_fast),
#                                                           regnskap_vekst = regnskap/lag(regnskap)-1,
#                                                           regnskap_fast_vekst = regnskap_fast/lag(regnskap_fast)-1) %>%
#                                            tidyr::drop_na() %>%
#                                            dplyr::select( ar, kategori, regnskap, endring_regnskap, regnskap_vekst, regnskap_fast, endring_regnskap_f, regnskap_fast_vekst)
#                                        #
#
#
#                                        # # Del2
#                                        tabell_regnskap_del2 <-
#                                            private$dfRegnskap %>%
#                                            dplyr::select( dato, regnskap_nominell = regnskap, g) %>%
#                                            dplyr::mutate( kategori = "post70") %>%
#                                            dplyr::filter(  lubridate::year(dato) <= (private$anslag_ar),  lubridate::year(dato) > (private$anslag_ar-3) , lubridate::month(dato) <= private$anslag_mnd_periode ) %>%
#                                            dplyr::group_by( ar = lubridate::year(dato), kategori ) %>%
#                                            dplyr::summarise( regnskap = sum( regnskap_nominell,na.rm = T),
#                                                              g_snitt =   mean(g, na.rm = T),
#                                                              .groups = "drop") %>%
#                                            #kpi_snitt = mean(kpi_faktor_2015, na.rm = T),
#                                            #sats_snitt = mean(max_sats_1_barn_gml,na.rm = T)) %>%
#                                            dplyr::filter( ar > 2013) %>%
#                                            dplyr::mutate( regnskap_fast = case_when(
#                                                str_detect(kategori, "70") ~ ((regnskap*prisjusterer)/g_snitt) )) %>%
#                                            # str_detect(kategori, "72") ~ ((regnskap*sats_gjeldende)/sats_snitt),
#                                            # str_detect(kategori, "73") ~ ((regnskap*kpi_gjeldende)/kpi_snitt))
#                                            # ) %>%
#                                            dplyr::arrange( kategori) %>%
#                                            dplyr::mutate( ar = str_c(ar,"-",
#                                                                      ifelse(private$anslag_mnd_periode < 10, str_c("0",(private$anslag_mnd_periode) ),(private$anslag_mnd_periode) ),"-01") ) %>%
#                                            dplyr::relocate( contains("snitt"), .after = last_col())
#
#
#                                        tabell_regnskap_del2_2 <-
#                                            tabell_regnskap_del2  %>%
#                                            dplyr::mutate( verdi_faktor = g_snitt ) %>%
#                                            dplyr::mutate( faktor = "g_snitt") %>%
#                                            # pivot_longer( names_to = "faktor", values_to = "verdi_faktor", g_snitt:sats_snitt ) %>%
#                                            dplyr::group_by( kategori, ar) %>%
#                                            dplyr::mutate( verdi_faktor_1 =  dplyr::case_when( #str_detect( kategori, "70") ~verdi_faktor[ faktor == "g_snitt"], T ~))
#                                                #                                      # str_detect( kategori, "72") ~verdi_faktor[ faktor == "kpi_snitt"],
#                                                #                                      # str_detect( kategori, "73") ~verdi_faktor[ faktor == "sats_snitt"])
#                                                T~ verdi_faktor[faktor == "g_snitt"])) %>%
#                                            dplyr::select( ar, kategori, regnskap, regnskap_fast, verdi_faktor_1) %>%
#                                            dplyr::group_by(kategori) %>%
#                                            dplyr::distinct() %>%
#                                            dplyr::mutate( endring_regnskap = regnskap-lag(regnskap),
#                                                           endring_regnskap_f = regnskap_fast -lag(regnskap_fast),
#                                                           regnskap_vekst = regnskap/lag(regnskap)-1,
#                                                           regnskap_fast_vekst = regnskap_fast/lag(regnskap_fast)-1) %>%
#                                            tidyr::drop_na() %>%
#                                            dplyr::select( ar, kategori, regnskap, endring_regnskap, regnskap_vekst, regnskap_fast, endring_regnskap_f, regnskap_fast_vekst)
#
#                                        private$tabell_regnskap_historikk <- dplyr::bind_rows(tabell_regnskap_del1 %>% mutate( ar = as.character(ar)), tabell_regnskap_del2_2) %>%
#                                            dplyr::arrange( kategori) %>% dplyr::ungroup()
#                                        #
#
#                                        private$ifjor_regnskap = private$tabell_regnskap_historikk %>% dplyr::filter( ar == as.character(private$anslag_ar-1) ) %>% dplyr::pull(regnskap)/10^6
#
#                                        return(private$tabell_regnskap_historikk)
#
#
#
#                                    },
#
#                                    tabellRegnskapDel3 = function( anslag1, anslag2 ){
#
#                                        df <- tibble(
#
#                                            kategori = c("Anslag", "Anslag") ,
#                                            ar =       c(anslag1$giAr(),anslag2$giAr() ),
#                                            regnskap = c( anslag1$giSumAnslag(),anslag2$giSumAnslag()),
#                                            g_snitt = c( private$g_gjeldende, private$g_gjeldende*anslag2$giPrisvekst() ),
#                                            regnskap_fast = c( anslag1$giSumAnslag() ,anslag2$giSumAnslag()/anslag2$giPrisvekst() )
#                                             )
#
#                                        df2 <- bind_rows( private$tabell_regnskap_del0 %>% dplyr::filter( ar < anslag1$giAr() ), df )
#
#                                        df3 <- df2 %>%
#                                            dplyr::arrange( ar) %>%
#                                            dplyr::mutate( endring_regnskap = regnskap-lag(regnskap),
#                                                           endring_regnskap_f = regnskap_fast -lag(regnskap_fast),
#                                                           regnskap_vekst = regnskap/lag(regnskap)-1,
#                                                           regnskap_fast_vekst = regnskap_fast/lag(regnskap_fast)-1) %>%
#                                            tidyr::drop_na() %>%
#                                            dplyr::mutate( ar = as.character(ar) ) %>%
#                                            dplyr::select( ar, kategori, regnskap, endring_regnskap, regnskap_vekst, regnskap_fast, endring_regnskap_f, regnskap_fast_vekst) %>%
#                                            dplyr::filter( dplyr::between(ar, (private$anslag_ar), (private$anslag_ar+1) ) )
#
#
#                                        return( df3 )
#
#                                    },
#
#                                    lagRegnskapTabell2 = function( anslag1, anslag2) {
#
#                                        df  <- self$lagRegnskapTabell()
#                                        df2 <- self$tabellRegnskapDel3(anslag1, anslag2)
#
#                                        dplyr::bind_rows(df, df2)
#                                    },
#
#
#
#
#                                    # Print
#                                    print = function(...){
#                                        cat("Dette er test av automatisering av regnskapstabellen:", "\n");
#                                        cat("Ifjor ", (private$anslag_ar-1), ": " ,private$ifjor_regnskap, " mill.kroner\n");
#                                    }
#                                ),
#                                # Private
#                                private = list(
#                                    ifjor_regnskap = NULL,
#                                    dfRegnskap = NULL,
#                                    anslag_ar = NULL,
#                                    g_gjeldende = NULL,
#                                    anslag_mnd_periode = NULL,
#                                    tabell_regnskap_historikk = NULL,
#                                    post = NULL,
#                                    tabell_regnskap_del0 = NULL
#                                )
#
# )
# #
# #
# #
# #
# #
# #
