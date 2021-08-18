

AvgMottakereYtelse <- R6::R6Class( "Gjennomsnittlig antall mottakere og gjennomsnittlig ytelse",
                          public = list(
                              initialize = function( name,
                                                     dfMottakere,
                                                     dfRegnskap,
                                                     gj_pris,
                                                     ANSLAG_AR,
                                                     ANSLAG_MND_PERIODE ) {

                                  # Private variabler
                                  private$name               <- name
                                  private$dfMottakere        <- dfMottakere
                                  private$dfRegnskap         <- dfRegnskap %>% mutate( dato = lubridate::ymd(dato))
                                  private$ANSLAG_AR          <- ANSLAG_AR
                                  private$ANSLAG_MND_PERIODE <- ANSLAG_MND_PERIODE
                                  private$gj_pris            <- gj_pris
                              },

                              # Tabell
                              lagTabell = function(  ){
                                  # Årlig regnskap
                                  df <-
                                      private$dfRegnskap %>%
                                      # Legger til mottakere
                                      dplyr::left_join( private$dfMottakere, by = "dato" ) %>%
                                      dplyr::mutate   ( regnskap_fast = regnskap*(private$gj_pris/g) )

                                  del1 <- df %>%
                                      dplyr::group_by ( ar            = year(dato) ) %>%
                                      dplyr::summarise( regnskap      = sum(regnskap,na.rm = T),
                                                        regnskap_fast = sum(regnskap_fast, na.rm = T),
                                                        mottakere     = mean(mottakere, na.rm = T),
                                                        .groups       = "drop"
                                                        ) %>%
                                      dplyr::filter( ar < private$ANSLAG_AR) %>%
                                      dplyr::mutate(
                                          ar = as.character(ar),
                                          a = regnskap,
                                          regnskap  = regnskap/mottakere,
                                          regnskap_fast = regnskap_fast/mottakere,
                                          endring_regnskap_prosent = regnskap/lag(regnskap)-1,
                                          endring_regnskap_fast_prosent = regnskap_fast/lag(regnskap_fast)-1,
                                          endring_mottakere = mottakere/lag(mottakere)-1
                                      )



                                  # Månedelig kostnader
                                  del2 <- df %>%
                                              # Filter ant. månder, og de siste 3 årene.
                                              dplyr::filter(  lubridate::year(dato)  <= (private$ANSLAG_AR),
                                                              lubridate::year(dato)  > (private$ANSLAG_AR-3),
                                                              lubridate::month(dato) <= private$ANSLAG_MND_PERIODE
                                                              ) %>%
                                              dplyr::group_by( ar = lubridate::year(dato)  ) %>%
                                              dplyr::summarise( a = sum( regnskap ,na.rm = T),
                                                                regnskap      = sum( regnskap ,na.rm = T)*(12/private$ANSLAG_MND_PERIODE),
                                                                regnskap_fast = sum( regnskap_fast, na.rm = T)*(12/private$ANSLAG_MND_PERIODE),
                                                                mottakere     = mean(mottakere, na.rm = T),
                                                                .groups = "drop") %>%
                                              dplyr::mutate( ar = str_c(ar,"-",
                                                                        ifelse(private$ANSLAG_MND_PERIODE < 10,
                                                                               str_c("0",(private$ANSLAG_MND_PERIODE) ),(private$ANSLAG_MND_PERIODE) ),"-01")
                                                             ) %>%
                                      dplyr::mutate(
                                          regnskap  = regnskap/mottakere,
                                          regnskap_fast = regnskap_fast/mottakere,
                                          endring_regnskap_prosent = regnskap/lag(regnskap)-1,
                                          endring_regnskap_fast_prosent = regnskap_fast/lag(regnskap_fast)-1,
                                          endring_mottakere = mottakere/lag(mottakere)-1
                                      )

                                    ## Retur denne.
                                  dplyr::bind_rows(del1 , del2 ) %>% na.omit() %>%
                                      dplyr::select( ar,
                                                     antall = mottakere,
                                                     antall_endring = endring_mottakere,
                                                     #tot_regnskap = a,
                                                     ytelse = regnskap,
                                                     ytelse_endring = endring_regnskap_prosent
                                                     )



                              },

                              # Print
                              print = function(...){
                                  cat("Dette printes ut:", private$name,"\n");}
                          ),
                              # Private
                          private = list(
                                         name               = NULL,
                                         dfMottakere        = NULL,
                                         dfRegnskap         = NULL,
                                         tabellMottakere    = NULL,
                                         ANSLAG_AR          = NULL,
                                         ANSLAG_MND_PERIODE = NULL,
                                         gj_pris            = NULL
                                         )
)
