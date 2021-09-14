# tabell <- R6::R6Class( "Tabell",
#                        public = list(initialize = function( name) {
#                            private$name <- name
#
#                            private$tabell <- dplyr::tibble( navn = c("Eirik", "Trond"), alder = c(37,41))
#
#                            },
#
#                            giTabell = function(  ){return(private$tabell) },
#
#                            print = function(...){
#                                cat("Tabell: ", private$name,"\n")}
#                        ),
#                        private = list(name = NULL, tabell = NULL)
# )
#
#
# utvidetTabell <- R6::R6Class( "Utvidet tabell",
#                               inherit = tabell,
#                               public  = list(initialize = function( name) {
#                                   private$name  <- name
#                               },
#
#
#                               giTabell = function( ) {
#                                   tabell$new("Tabell")$giTabell() %>% bind_rows( tibble( navn = "christoffer", alder = 30)) },
#
#                               print = function(...){
#                                   super$print()
#                                   cat("Og alderen er: ", private$alder, "\n" )}
#                               ),
#
#
#
#                               private = list(name = NULL)
# )
#
#
#
#
#
# en <- tabell$new("start")
#
# en$giTabell()
#
# to <- utvidetTabell$new("utivdet tabell")
#
# to$giTabell()
#
#
#
#
#
#
