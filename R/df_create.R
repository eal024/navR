


df_create <- function( l_test) {
    navn  <- purrr::map2_chr(l_test, 1:length(l_test) ,
                             function(x,y) if(y == 1 ){lubridate::year(x$giPeriode()) %>% as.character()} else{x$giAnslagNavn()} )

    verdi <- purrr::map2_chr( l_test, 1:length(l_test),
                      function(x,y) { if(y == 1){
                          ( x$giKapittelpost()) %>% as.character()
                      }else{
                          # Regnskapet printes:
                          if( y == 2  ){ format( (x$giSumAnslag()/10^6), digit = 0)
                              # Annet enn regnskap printes:
                              }else{ format(( navR::anslag_avrund( x$giSumAnslag()/10^6, i_mill_kr = T)), big.mark = " ", digits =0 ) }
                          }
                          })

    df <-  tibble::tibble( navn =navn, value = verdi) %>%
        pivot_wider( names_from  = navn, values_from = value)
    #
    `Endring fra forrige` <- as.numeric( str_remove_all(df[[ncol(df)]], pattern =  " ") ) - as.numeric( str_remove_all(df[[(ncol(df)-1)]], pattern =  " ") )
    `Endring fra vedtatt` <- as.numeric( str_remove_all(df[[ncol(df)]], pattern =  " ") ) - as.numeric( str_remove_all(df[[(ncol(df)-2)]], pattern =  " ") )



    df %>%
      mutate( `Endring fra forrige` = `Endring fra forrige`,
              `Endring fra vedtatt` = `Endring fra vedtatt`
              )
}

# df_create2 <- function( l_test) {
#     navn  <- purrr::map2_chr(l_test, 1:length(l_test) ,
#                              function(x,y) if(y == 1 ){(lubridate::year(x$giPeriode()) +1) %>% as.character()} else{x$giAnslagNavn()} )
#
#     verdi <- purrr::map2_chr( l_test, 1:length(l_test),
#                               function(x,y) { if(y == 1){
#                                   ( x$giKapittelpost()) %>% as.character()
#                               }else{# Annet enn regnskap printes:
#                                   format(( navR::anslag_avrund( x$giSumAnslag()/10^6, i_mill_kr = T)), big.mark = " ", digits =0 )
#                               }
#                               }
#                               )
#
#     df <-  tibble::tibble( navn =navn, value = verdi) %>%
#         pivot_wider( names_from  = navn, values_from = value)
#     #
#     `Endring fra forrige` <- as.numeric( str_remove_all(df[[ncol(df)]], pattern =  " ") ) - as.numeric( str_remove_all(df[[(ncol(df)-1)]], pattern =  " ") )
#
#     df %>%
#         mutate( `Endring fra forrige` = `Endring fra forrige`
#         )
# }
#




#
# list(list(Regnskap = regnskap_ifjor$giSumAnslag(), Forrige = forrige_iar$giSumAnslag(), Nytt = nytt_iar$giSumAnslag()     ) %>% as_tibble(),
#      list(Regnskap = 0,                            Forrige = forrige_iar$giSumAnslag(), Nytt = nytt_neste_ar$giSumAnslag()) %>% as_tibble()
#      ) %>%
#     bind_rows() %>%
#     rowwise() %>%
#     mutate( across( .cols = 2:ncol(.), .fns = function(x) anslag_avrund(x, i_mill_kr = F) ))
#
# test <- list( ar = year(bud_post1$giPeriode())   ,  Regnskap = regnskap_ifjor, vedtatt_iar = vedtatt_iar, Forrige = forrige_iar, Nytt = nytt_iar )
# test2 <- list(ar = year(bud_post1$giPeriode()) +1,  Regnskap = regnskap_ifjor, Forrige = forrige_neste_ar, Nytt = nytt_neste_ar )

alt_creat <- function( test, test2 , navn_forste = "År" ){

    navn <- purrr::map2_chr( test, 1:length(test), function(x,y) {if(y == 1){
        if( is.numeric(x) ){ return( format(x, digits = 0)) }
        else if( is.character(x) ) { return(x) }
        } else { x$giAnslagNavn()} } )
    df   <- purrr::map( list( test, test2), function(y) {map2( y, 1:length(y),function(x,y)
                                                        {
                                                        #
                                                        if(y == 1){ x }
                                                        else if( is.null(x) ) {return(NA_real_)}
                                                        else { x$giSumAnslag() }
                                                        }
                                                      )} ) %>% bind_rows()

    names(df) <- c( navn_forste, navn[2:length(navn)])

    df %>%
        mutate( across( .cols = c(names(.)[3:ncol(.)]), .fns = function(x) navR::anslag_avrund(x, i_mill_kr = F))) %>%
        mutate( across( .cols = c(names(.)[2:ncol(.)]), .fns = function(x) {
           format(x/10^6, digits = 0, big.mark = " ") }) ) %>%
        mutate( across( .cols = everything(), .fns = function(x) ifelse( str_detect(x, "NA"), " ", x ) ))
}


# liste_hoved_1 <- list( post70 = list( post = bud_post1$giKapittelpost(), regnskap_ifjor = regnskap_ifjor, vedtatt_iar = vedtatt_iar, forrige = forrige_iar, nyttt = nytt_iar),
#                        post70 = list( post = bud_post1$giKapittelpost(), regnskap_ifjor = NULL, vedtatt_iar = NULL, forrige = forrige_iar, nyttt = nytt_iar),
#                        post70 = list( post = bud_post1$giKapittelpost(), regnskap_ifjor = NULL, vedtatt_iar = NULL, forrige = forrige_iar, nyttt = nytt_iar)
# )


#
# a <-  list(ar = "2021", regnskap_ifjor = regnskap_ifjor, vedtatt_iar = vedtatt_iar, forrige = forrige_iar, nyttt = nytt_iar )
# aa <- list(ar = "2021", regnskap_ifjor = NULL, vedtatt_iar = NULL, forrige = forrige_neste_ar, nyttt = nytt_neste_ar)
# #
# #
# alt_creat(a, aa , navn_forste = "År")

alt_creat2 <- function( liste , navn_forste = "År" ){

    # Navn:
    l_1 <- liste[[1]]
    navn <- purrr::map2_chr( l_1, 1:length(l_1), function(x,y) {if(y == 1){
        if( is.numeric(x) ){ return( format(x, digits = 0)) }
        else if( is.character(x) ) { return(x) }
    } else { x$giAnslagNavn()} } )


    df   <- purrr::map( liste, function(y) {map2( y, 1:length(y),function(x,y)
    {
        #
        if(y == 1){ x }
        else if( is.null(x) ) {return(NA_real_)}
        else { x$giSumAnslag() }
    }
    )} ) %>% bind_rows()

    names(df) <- c( navn_forste, navn[2:length(navn)])

    df %>%
        mutate( across( .cols = c(names(.)[3:ncol(.)]), .fns = function(x) navR::anslag_avrund(x, i_mill_kr = F))) %>%
        mutate( across( .cols = c(names(.)[2:ncol(.)]), .fns = function(x) {
            format(x/10^6, digits = 0, big.mark = " ") }) ) %>%
        mutate( across( .cols = everything(), .fns = function(x) ifelse( str_detect(x, "NA"), " ", x ) ))
}


# liste_hoved_1 <- list( post70 = list( post = bud_post1$giKapittelpost(), regnskap_ifjor = regnskap_ifjor, vedtatt_iar = vedtatt_iar, forrige = forrige_iar, nyttt = nytt_iar),
#                        post70 = list( post = bud_post1$giKapittelpost(), regnskap_ifjor = NULL, vedtatt_iar = NULL, forrige = forrige_iar, nyttt = nytt_iar),
#                        post70 = list( post = bud_post1$giKapittelpost(), regnskap_ifjor = NULL, vedtatt_iar = NULL, forrige = forrige_iar, nyttt = nytt_iar)
# )
#
# alt_creat2( liste_hoved_1)




