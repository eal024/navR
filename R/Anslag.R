



# Anslag
Anslag <- R6::R6Class( "Anslag",
                       public = list(
                           initialize = function( name, ar = NULL, regnskap_ifjor = NULL, vekst_ytelse = NULL,  prisvekst = NULL, volumvekst = NULL, tiltak = NULL) {

                               private$name <- name
                               private$ar <- ar
                               private$regnskap_ifjor = regnskap_ifjor
                               private$prisvekst <- prisvekst
                               private$vekst_ytelse <- vekst_ytelse
                               private$volumvekst <- volumvekst
                               private$tiltak <- tiltak
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
                                                       # Tiltak
                                                       ( private$regnskap_ifjor + private$regnskap_ifjor*(private$volumvekst-1) + private$regnskap_ifjor*(private$vekst_ytelse-1)+ private$regnskap_ifjor*(private$prisvekst-1) ) *(private$tiltak-1)
                                             )
                               )
                               df <- add_row( df, tekst = paste0("sum", as.character(private$ar)), prosent = as.character(((summarise(df,a = sum(tall) ) %>% pull(a))/df[1,3]) %>% format(digits = 4) ) , tall = summarise(df,a = sum(tall) ) %>% pull(a) )

                               return( df %>% mutate( tall = tall/10^6) )
                               #
                               #
                           },

                           giAnslagNavn = function( ){return( private$name)},

                           # Print
                           print = function(...){
                               cat("Anslag: ", private$name,"\n");
                               cat("Forutsetninger:\n");
                               cat( "  Regnskap", private$ar, ": ",  (private$regnskap_ifjor)/10^6, "mill.kroner\n")
                               cat( "  U. ytelse     : ", ((private$vekst_ytelse-1)*100) %>% format( digits = 2), "%\n")
                               cat( "  Prisvekst     : ", ((private$prisvekst-1)*100) %>% format( digits = 2), "%\n")
                               cat( "  Volumvekst    : ", (private$volumvekst-1)*100, "%\n")
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
                           tiltak = NULL

                       )
)
