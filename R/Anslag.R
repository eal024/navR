



# Anslag
Anslag <- R6::R6Class( "Anslag",
                       public = list(
                           initialize = function( name,
                                                  ar = NULL,
                                                  regnskap_ifjor = NULL,
                                                  vekst_ytelse = NULL,
                                                  prisvekst = NULL,
                                                  volumvekst = NULL,
                                                  tiltak = NULL,
                                                  underregulering = NULL) {

                               # Private forutsetninger omgjøres til 1 om ingen input.
                               private$name <- name
                               private$ar <- ar
                               private$regnskap_ifjor <- regnskap_ifjor
                               private$prisvekst <- ifelse( is.null(prisvekst), 1, prisvekst)
                               private$vekst_ytelse <- ifelse( is.null(vekst_ytelse) , 1, vekst_ytelse)
                               private$volumvekst <- ifelse( is.null(volumvekst), 1, volumvekst)
                               private$tiltak <- ifelse( is.null(tiltak), 1 , tiltak )
                               private$underregulering <-  ifelse( is.null(underregulering), 1 , underregulering )

                               # Forutsetninger i tall.
                               volumvekst       <- private$regnskap_ifjor  *( private$volumvekst-1);
                               vekst_ytelse     <- (private$vekst_ytelse-1)*( private$regnskap_ifjor + volumvekst )
                               prisvekst        <- (private$prisvekst-1)   *( private$regnskap_ifjor + volumvekst + vekst_ytelse )
                               underregulering  <- (private$underregulering-1)   *( private$regnskap_ifjor + volumvekst + vekst_ytelse + prisvekst)
                               tiltak           <- (private$tiltak -1)     *( private$regnskap_ifjor + volumvekst + vekst_ytelse +prisvekst + underregulering)
                               prisvekst        <- (private$prisvekst-1)   *( private$regnskap_ifjor + volumvekst + vekst_ytelse + tiltak)

                               # Forutsetninger i prosent
                               p_regnskap       <- as.character(0) %>% format( digits = 2)
                               p_volum          <- as.character( ((private$volumvekst-1) *100) %>% format(digits = 2))
                               p_vekst_ytelse   <- as.character( ((private$vekst_ytelse-1) *100) %>% format(digits = 2))
                               p_prisvekst      <- as.character( ((private$prisvekst-1) *100) %>% format(digits = 2))
                               p_underr         <- as.character( ((private$underregulering-1)*100) %>% format(digits = 2))
                               p_tiltak         <- as.character((round( (private$tiltak-1) *100, digits = 2 ) )) %>% format(digits = 2)

                               # anslag data.frame
                               df <- tibble( tekst = c(paste0("regnskap", as.character(private$ar-1)), "volum", "ytelse", "prisveks", "underregulering", "tiltak" ),
                                             prosent = c(
                                                 as.character(0),
                                                 p_volum         ,
                                                 p_vekst_ytelse  ,
                                                 p_prisvekst     ,
                                                 p_underr        ,
                                                 p_tiltak
                                             ),
                                             tall = c(
                                                 private$regnskap_ifjor,
                                                 volumvekst     ,
                                                 vekst_ytelse   ,
                                                 prisvekst      ,
                                                 underregulering,
                                                 tiltak
                                             )
                               )
                               # Om underregulering ikke er med filter bort
                               ifelse( private$underregulering == 1, df <- df %>% dplyr::filter( tekst != "underregulering" ) , df <- df )

                               # sum df
                               df_1 <- add_row( df, tekst = paste0("sum", as.character(private$ar)), prosent = as.character(((summarise(df,a = sum(tall) ) %>% pull(a))/df[1,3]) %>% format(digits = 4) ) , tall = summarise(df,a = sum(tall) ) %>% pull(a) )

                               # Nytt anslag legger seg til her.
                               private$anslag_tall <- summarise(df,a = sum(tall) ) %>% pull(a)
                               private$DFAnslag <- df_1


                           },
                           # Anslag
                           dfAnslag = function(  ){

                               # Forutsetninger i tall.
                               volumvekst       <- private$regnskap_ifjor        *( private$volumvekst-1);
                               vekst_ytelse     <- (private$vekst_ytelse-1)      *( private$regnskap_ifjor + volumvekst )
                               prisvekst        <- (private$prisvekst-1)         *( private$regnskap_ifjor + volumvekst + vekst_ytelse )
                               underregulering  <- (private$underregulering-1)   *( private$regnskap_ifjor + volumvekst + vekst_ytelse + prisvekst)
                               tiltak           <- (private$tiltak -1)           *( private$regnskap_ifjor + volumvekst + vekst_ytelse +prisvekst + underregulering)
                               # Her er det ulik praksis. Se 667
                               prisvekst        <- (private$prisvekst-1)         *( private$regnskap_ifjor + volumvekst + vekst_ytelse + tiltak)

                               # Forutsetninger i prosent
                               p_regnskap       <- as.character(0) %>% format( digits = 2)
                               p_volum          <- as.character( ((private$volumvekst-1) *100) %>% format(digits = 2))
                               p_vekst_ytelse   <- as.character( ((private$vekst_ytelse-1) *100) %>% format(digits = 2))
                               p_prisvekst      <- as.character( ((private$prisvekst-1) *100) %>% format(digits = 2))
                               p_underr         <- as.character( ((private$underregulering-1)*100) %>% format(digits = 2))
                               p_tiltak         <- as.character((round( (private$tiltak-1) *100, digits = 2 ) )) %>% format(digits = 2)

                               # anslag data.frame
                               df <- tibble( tekst = c(paste0("regnskap", as.character(private$ar-1)), "volum", "ytelse", "prisveks", "underregulering", "tiltak" ),
                                             prosent = c(
                                                 as.character(0),
                                                 p_volum         ,
                                                 p_vekst_ytelse  ,
                                                 p_prisvekst     ,
                                                 p_underr        ,
                                                 p_tiltak
                                             ),
                                             tall = c(
                                                 private$regnskap_ifjor,
                                                 volumvekst     ,
                                                 vekst_ytelse   ,
                                                 prisvekst      ,
                                                 underregulering,
                                                 tiltak
                                             )
                               )
                               # Om underregulering ikke er med filter bort
                               ifelse( private$underregulering == 1, df <- df %>% dplyr::filter( tekst != "underregulering" ) , df <- df )

                               # sum df
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
                           setVolum = function( volumvekst ) {
                               private$volumvekst = volumvekst
                               self$dfAnslag()
                               },

                           setYtelse = function( vekst_ytelse ) {
                               private$vekst_ytelse = vekst_ytelse
                               self$dfAnslag()
                           },
                           setPrisvekst = function( prisvekst ) {
                               private$prisvekst = prisvekst
                               self$dfAnslag()
                               },
                           setTiltak = function( tiltak ) {
                               private$tiltak = tiltak
                               self$dfAnslag()
                               },
                           setUnderregulering = function( underregulering ) {
                               private$underregulering = underregulering
                               self$dfAnslag()
                               },

                           giSumAnslag = function( ) {
                               self$dfAnslag()
                               private$anslag_tall},

                           giPrisvekst = function( ) { private$prisvekst },

                           giAr = function( ) { private$ar },

                           giVolumvekst = function(  ) { private$volumvekst },

                           giAnslagNavn = function( ) { private$name },

                           giVolum = function( antall_ifjor ) { antall_ifjor*private$volumvekst() },

                           setPris = function( pris , ifjor = F) { private$pris = ifelse( ifjor == F, pris, pris*private$prisvekst)},

                           giPris = function( ) { private$pris},


                           # Print
                           print = function(...){
                               # Må endre rekkefølgen til korrekt.
                               cat("Anslag: ", private$name,"\n");
                               cat("Forutsetninger:\n");
                               cat( "  Regnskap", (private$ar-1), ": ",  (private$regnskap_ifjor)/10^6, "mill.kroner\n");
                               cat( "  Volumvekst      : ", (private$volumvekst-1)*100, "%\n");
                               cat( "  Vekst ytelse    : ", ((private$vekst_ytelse-1)*100) %>% format( digits = 2), "%\n");
                               cat( "  Prisvekst       : ", ((private$prisvekst-1)*100) %>% format( digits = 2), "%\n");
                               cat( "  Underregulering : ", ((private$underregulering-1)*100) %>% format( digits = 2), "%\n");
                               cat( "  Tiltak          : ", ((private$tiltak-1)*100) %>% format( digits = 2), "%\n");
                               # Underregulering av satsen
                               cat( "  Nytt anslag   : ", (private$anslag_tall)/10^6, "mill.kroner\n");
                               if( !is.null(private$pris) ) { cat("\nAnslått pris (G) ", private$pris) } ;
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
                           # Ekstra info
                           pris = NULL,

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
