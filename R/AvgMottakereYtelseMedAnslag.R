

AvgMottakereYtelseMedAnslag <- R6::R6Class( "Gjennomsnittlig antall mottakere og gjennomsnittlig ytelse\nmed anslag",
                                            inherit    = AvgMottakereYtelse,
                                            public     = list(
                                                            lagTabell = function( df )
                                                                {
                                                                super$lagTabell() %>%
                                                                    dplyr::bind_rows(df)
                                                                }
                                                           )
                                           )




