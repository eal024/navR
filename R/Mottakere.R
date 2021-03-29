

Mottakere <- R6::R6Class( "mottakere",
                            public = list(
                                initialize = function( name, dfMottakere, ANSLAG_AR, ANSLAG_MND_PERIODE ) {
                                    private$name <- name
                                    private$dfMottakere <- dfMottakere
                                    private$ANSLAG_AR <- ANSLAG_AR
                                    private$ANSLAG_MND_PERIODE <- ANSLAG_MND_PERIODE
                                },

                                # mottakertabell
                                lagTabell = function(  ){

                                    filter_ar = ifelse( private$ANSLAG_MND_PERIODE == 12, private$ANSLAG_AR+1, private$ANSLAG_AR )

                                    tabell_mottakere_del1 <-
                                        private$dfMottakere %>%
                                        filter( lubridate::year(dato)  <  filter_ar) %>%
                                        group_by(kategori, ar = lubridate::year(dato)) %>%
                                        mutate( per_des = mottakere[dato == max(dato)]) %>%
                                        group_by( ar, kategori, per_des) %>%
                                        summarise( gjennomsnitt = mean(mottakere),
                                                   .groups = "drop") %>%
                                        group_by( kategori) %>%
                                        # across
                                        mutate( vekst_pst_gj = gjennomsnitt/lag(gjennomsnitt)-1,
                                                vekst_pst_des = per_des/lag(per_des)-1) %>%
                                        select( ar, kategori, gjennomsnitt,vekst_pst_gj,per_des ,vekst_pst_des) %>%
                                        drop_na()



                                    # # Del 2
                                    # # Del2
                                    tabell_mottakere_del2 <-
                                        # Del2
                                        private$dfMottakere %>%
                                        # Dobbelsjekk denne
                                        filter( lubridate::month(dato) <= private$ANSLAG_MND_PERIODE) %>%
                                        group_by(kategori, ar = lubridate::year(dato)) %>%
                                        mutate( per_des = mottakere[dato == max(dato)]) %>%
                                        group_by( kategori, ar = lubridate::year(dato), per_des) %>%
                                        summarise( gjennomsnitt = mean(mottakere),
                                                   .groups = "drop") %>%
                                        arrange( kategori, ar) %>%
                                        ungroup() %>%
                                        group_by( kategori) %>%
                                        # across
                                        mutate(
                                            vekst_pst_gj = gjennomsnitt/lag(gjennomsnitt)-1,
                                            vekst_pst_des = per_des/lag(per_des)-1) %>%
                                        select( ar, kategori, gjennomsnitt,vekst_pst_gj,per_des ,vekst_pst_des) %>%
                                        # Var konstant
                                        filter( ar %in% c( (private$ANSLAG_AR-1)  ,private$ANSLAG_AR)) %>%
                                        mutate( ar = str_c(ar,"-",ifelse( private$ANSLAG_MND_PERIODE < 10, str_c("0",(private$ANSLAG_MND_PERIODE) ), (private$ANSLAG_MND_PERIODE) ),"-01") ) %>%
                                        drop_na()


                                    private$tabellMottakere <- bind_rows(tabell_mottakere_del1 %>% mutate(ar = as.character(ar)), tabell_mottakere_del2) %>%
                                        arrange( kategori) %>% ungroup()

                                    return(private$tabellMottakere );

                                },

                                # Print
                                print = function(...){
                                    cat("Dette printes ut:", private$name,"\n");}
                            ), # Private
                            private = list(
                                name = NULL,
                                dfMottakere = NULL,
                                tabellMottakere = NULL,
                                ANSLAG_AR = NULL,
                                ANSLAG_MND_PERIODE = NULL
                            )
)

