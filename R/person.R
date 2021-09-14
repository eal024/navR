
person <- R6::R6Class( "Person",
             public = list(initialize = function( name) {
                 private$name <- name},

                 giNavn = function(  ){return(private$name) },

                 print = function(...){
                               cat("Personen er: ", private$name,"\n")}
             ),
             private = list(name = NULL)
             )


person_kvinne <- R6::R6Class( "Kvinne",
                              inherit = person,
                              public  = list(initialize = function( name, alder) {
                                  private$name  <- name
                                  private$alder <- alder
                                  },


                                  giNavn  = function(  ){return(private$name) },

                                  kvinneF = function( ) { print("Kvinnegruppa Ottar") },

                                  print = function(...){
                                      super$print()
                                      cat("Og alderen er: ", private$alder, "\n" )}
                              ),



                              private = list(name = NULL, alder = NULL)
)



eirik <- person$new("Eirik")

martha <- person_kvinne$new("Martha", 18)

class(martha)
class(eirik)
eirik
martha
martha$kvinneF()

