



# Anslag
Anslag <- R6::R6Class( "Anslag",
                       public = list(
                           initialize = function( name, ar = NULL, regnskap_ifjor = NULL, vekst_ytelse = NULL,  prisvekst = NULL, volumvekst = NULL, tiltak = NULL, underregulering = NULL ) {

                               private$name <- name
                               private$ar <- ar
                               private$regnskap_ifjor <- regnskap_ifjor
                               private$prisvekst <- ifelse( is.null(prisvekst), 1, prisvekst)
                               private$vekst_ytelse <- ifelse( is.null(vekst_ytelse) , 1, vekst_ytelse)
                               private$volumvekst <- ifelse( is.null(volumvekst), 1, volumvekst)
                               private$tiltak <- ifelse( is.null(tiltak), 1 , tiltak )
                               private$underregulering <-  ifelse( is.null(underregulering), 1 , underregulering )


                           },
                           # Anslag
                           dfAnslag = function(  ){
                               # anslag data.frame
                               df <- tibble( tekst = c(paste0("regnskap", as.character(private$ar-1)), "volum", "ytelse", "prisveks", "tiltak" ),
                                             prosent = c(
                                                 as.character(0) %>% format(digits = 2), as.character( ((private$volumvekst-1) *100) %>% format(digits = 2)) ,
                                                 as.character( ((private$vekst_ytelse-1) *100) %>% format(digits = 2)),
                                                 as.character( ((private$prisvekst-1) *100) %>% format(digits = 2)),
                                                 as.character((private$tiltak-1) *100) %>% format(digits = 2) ),
                                             tall = c( private$regnskap_ifjor,
                                                       # Volumvekst
                                                       private$regnskap_ifjor*(private$volumvekst-1),
                                                       # Underliggende vekst i ytelse
                                                       ( private$regnskap_ifjor + private$regnskap_ifjor*(private$volumvekst-1) ) *(private$vekst_ytelse-1),
                                                       # Prisvekst
                                                       ( private$regnskap_ifjor + private$regnskap_ifjor*(private$volumvekst-1) + private$regnskap_ifjor*(private$vekst_ytelse-1) )*(private$prisvekst-1) ,
                                                       # Underregulering av satsen
                                                       # Kommer her.

                                                       # Tiltak
                                                       ( private$regnskap_ifjor + private$regnskap_ifjor*(private$volumvekst-1) + private$regnskap_ifjor*(private$vekst_ytelse-1)+ private$regnskap_ifjor*(private$prisvekst-1) ) *(private$tiltak-1)
                                                                                                    )
                               )
                               df_1 <- add_row( df, tekst = paste0("sum", as.character(private$ar)), prosent = as.character(((summarise(df,a = sum(tall) ) %>% pull(a))/df[1,3]) %>% format(digits = 4) ) , tall = summarise(df,a = sum(tall) ) %>% pull(a) )

                               # Nytt anslag legger seg til her.
                               private$anslag_tall <- summarise(df,a = sum(tall) ) %>% pull(a)
                               private$DFAnslag <- df_1

                               #return( df_1 %>% mutate( tall = tall/10^6) )

                               #
                               #
                           },

                           giDfAnslag = function( mill.kroner = T ) {
                               self$dfAnslag();
                               if( mill.kroner == T ) { return( private$DFAnslag %>% mutate( tall = tall/10^6) ) } else { return(private$DFAnslag) } },

                           # Endre forutsetninger
                           setVolum = function( volumvekst ) { private$volumvekst = volumvekst },
                           setYtelse = function( vekst_ytelse ) { private$vekst_ytelse = vekst_ytelse },
                           setPrisvekst = function( prisvekst ) { private$prisvekst = prisvekst },
                           setTiltak = function( tiltak ) { private$tiltak = tiltak },

                           giSumAnslag = function( ) { private$anslag_tall},

                           # Print
                           print = function(...){
                               # Må endre rekkefølgen til korrekt.
                               cat("Anslag: ", private$name,"\n");
                               cat("Forutsetninger:\n");
                               cat( "  Regnskap", private$ar, ": ",  (private$regnskap_ifjor)/10^6, "mill.kroner\n")
                               cat( "  Volumvekst    : ", (private$volumvekst-1)*100, "%\n")
                               cat( "  Vekst ytelse  : ", ((private$vekst_ytelse-1)*100) %>% format( digits = 2), "%\n")
                               cat( "  Prisvekst     : ", ((private$prisvekst-1)*100) %>% format( digits = 2), "%\n")
                               cat( "  Tiltak        : ", ((private$tiltak-1)*100) %>% format( digits = 2), "%\n")

                               # Underregulering av satsen
                               cat( "  Nytt anslag   : ", (private$anslag_tall)/10^6, "mill.kroner\n")
                           }
                       ), # Private
                       private = list(
                           name = NULL,
                           ar = NULL,
                           regnskap_ifjor = NULL,
                           # Vekst underliggende ytelse
                           vekst_ytelse = NULL,
                           # 1+0,0v
                           prisvekst = NULL,
                           # 1+0,0v
                           volumvekst = NULL,
                           # Prosent
                           tiltak = NULL,
                           # Underregulering av prisveksten
                           underregulering = NULL,
                           # Anslaget
                           anslag_tall = NULL,
                           DFAnslag = NULL

                       )
)
