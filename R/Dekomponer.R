

# Rydde
# Finere utprint.
# Mer fleksibel på anslag sum, og diverse.
# Test om endret input pris får effekt på utregingen.

Dekomponer <- R6::R6Class("dekomponer",

                        public = list(
                          initialize = function(anslag1, anslag2, antall_1 = NA, antall_2 = NA, sumAnslag1 = NULL, sumAnslag2 = NULL, pris1 = NULL, pris2 = NULL) {

                              # Stopp om ikke pris kommer med.
                              stopifnot( !is.null(pris1) | !is.null(pris2) | !is.null(anslag1$giPris()) | !is.null( anslag2$giPris() ) )

                              # Instanse variabler
                              private$anslag1  <- anslag1
                              private$anslag2  <- anslag2
                              private$antall_1 <- antall_1
                              private$antall_2 <- antall_2
                              ## Pris
                              if( is.null(pris1) ) {private$pris1 <- private$anslag1$giPris() } else{ private$pris1 <- pris1 }
                              if( is.null(pris2) ) {private$pris2 <- private$anslag2$giPris() } else{ private$pris2 <- pris2 }

                              ## Info fra anslaget
                              private$sumAnslag1 <- ifelse( is.null(sumAnslag1), private$anslag1$giSumAnslag(), sumAnslag1  )
                              private$sumAnslag2 <- ifelse( is.null(sumAnslag2), private$anslag2$giSumAnslag(), sumAnslag2  )
                              # Gjennomsnitt ytelse
                              private$gj_ytelse1 <- private$sumAnslag1/private$antall_1
                              private$gj_ytelse2 <- private$sumAnslag2/private$antall_2
                              # Gjennomsnittlig ytelse ny G
                              private$gj_ytelse1_ny_pris <- private$gj_ytelse1*( private$pris2/private$pris1 )
                              private$gj_ytelse2_ny_pris <- private$gj_ytelse2*( private$pris2/private$pris2 )

                              #Oversikt df
                              private$df <- tibble::tibble( var = c("prisvekst %",
                                                                    "middelbestand",
                                                                    "anslag" ,
                                                                    "gj.beløp",
                                                                    "gj.beløp ny pris"
                                                                    ),
                                              anslag1 = c(
                                                  # Pris
                                                  private$pris1,
                                              #     # Middelbestand
                                                  private$antall_1,
                                                    # Anslag
                                                  private$sumAnslag1,
                                              #     # Gj.beløp
                                                  private$gj_ytelse1,
                                              #     # Gj.beløp, ny G,
                                                  private$gj_ytelse1_ny_pris
                                                          ),

                                              anslag2 = c(
                                                  # Pris i 100
                                                  private$pris2,
                                                  #     # Middelbestand
                                                  private$antall_2,
                                                  # Anslag
                                                  private$sumAnslag2,
                                                  #     # Gj.beløp
                                                  private$gj_ytelse2,
                                                  #     # Gj.beløp, ny G
                                                  private$gj_ytelse2_ny_pris
                                              ),
                                              )

                              ## Oversikts df med korrekte navn.
                              names(private$df) <- c("var", private$anslag1$giAnslagNavn(), private$anslag2$giAnslagNavn())

                          },

                          giDekomponert = function( ) {
                              # Effekt av Grunnbeløp
                              a1 <- private$sumAnslag1
                              a1_ny_pris <- private$sumAnslag1*( private$pris2/private$pris1 )
                              effekt_av_g <- a1_ny_pris - private$sumAnslag1


                              #Prosent-effekt
                              pros_ef_g      <- effekt_av_g/a1
                              pros_ef_vol    <- (private$antall_2-private$antall_1)/private$antall_1
                              pros_ef_ytelse <- (private$gj_ytelse2_ny_pris-private$gj_ytelse1_ny_pris)/private$gj_ytelse1_ny_pris

                              # Snitt beløp
                              # gj_ytelse1
                              # gj_ytelse2
                              snitt_a1 <- private$gj_ytelse1
                              snitt_a2 <- private$gj_ytelse2

                              delta_gj_belop_prosent <- (private$gj_ytelse2_ny_pris-private$gj_ytelse1_ny_pris)/private$gj_ytelse1_ny_pris

                              #tibble::tibble( a1_mill = a1/10^6, a2_mill = a1_ny_pris/10^6, delta_mill = effekt_av_g/10^6, prosent = prosent)

                              df2 <- tibble::tibble( tekst = c("vedtatt", "effekt av pris", "endret volum", "snitt_beløp"),
                                              percent = c(0, pros_ef_g   ,pros_ef_vol, pros_ef_ytelse),
                                              sum =     c( 0,
                                                           # Pris
                                                           pros_ef_g*private$sumAnslag1,
                                                           # Volum
                                                           (pros_ef_g+1)*pros_ef_vol*private$sumAnslag1 ,
                                                           # Ytelse
                                                           (pros_ef_g+1)*(1 + pros_ef_vol)*pros_ef_ytelse*private$sumAnslag1 )
                                              )

                              df2 <- df2 %>% mutate( accum = cumsum(sum), totalt = private$sumAnslag1 + accum) %>% mutate_at( vars(sum, accum, totalt), function(x) x/10^6) %>%
                                  mutate( endring_mill =  totalt - lag(totalt)   )


                              bind_rows(df2,
                                        df2 %>% summarise(      endring_mill =  sum(endring_mill, na.rm = T),
                                                                tekst        =  "totalt",
                                                                percent      =  private$sumAnslag2/private$sumAnslag1,
                                                                accum        =  sum(endring_mill, na.rm = T),
                                                                totalt       =  private$sumAnslag2/(10^6)  )
                                        )



                              },


                          giDf =  function( ) {return(private$df)},


                          print = function(...) {
                              cat("Dekomponering av endrede forutsetninger. Anslag ", private$anslag1$giAnslagNavn(), " mot anslag: ", private$anslag2$giAnslagNavn(), "\n", sep = "" );
                              cat("Total endring er :" ,10, " \n");
                              cat(" Prisendring gir anslagsendring  :" ,10, " \n");
                              cat(" Volumendring gir anslagsendring :" ,10, " \n");

                          }
                      ),
                      private = list(
                          anslag1 = NULL,
                          anslag2 = NULL,
                          sumAnslag1 = NULL,
                          sumAnslag2 = NULL,
                          antall_1 = NULL,
                          antall_2 = NULL,
                          pris1 = NULL,
                          pris2 = NULL,
                          df = NULL,
                          gj_ytelse1 = NULL,
                          gj_ytelse2 = NULL,
                          gj_ytelse1_ny_pris = NULL,
                          gj_ytelse2_ny_pris = NULL
                      )
)


