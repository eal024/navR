






hovedtabell1_hjelp1 <- function( budsjett, list_anslag ) {

        df <- tibble::tibble( en    = c( str_c("Post ", str_sub(bud_post1$giKapittelpost(), start = 6, end = 7) )),
                              navn  = map_chr( list_anslag, function(x) x$giAnslagNavn() ) ) %>%
            mutate(anslag = map2_dbl( list_anslag, navn, function(x,y){ if(y != regnskap_ifjor$giAnslagNavn() ){
                (x$giSumAnslag()/10^6) %>% navR::anslag_avrund( i_mill_kr = T)} else { (x$giSumAnslag()/10^6)} }  )
            ) %>%
            pivot_wider( names_from =  navn, values_from = anslag) %>%
            mutate( `Endring fra vedtatt` =  ( nytt_iar$giSumAnslag() %>% navR::anslag_avrund( ) - vedtatt_iar$giSumAnslag() %>% navR::anslag_avrund() )/10^6,
                    `Endring fra forrige` =  ( nytt_iar$giSumAnslag() %>% navR::anslag_avrund( ) - forrige_iar$giSumAnslag() %>% navR::anslag_avrund() )/10^6
            )

        names(df)[1] <- c( lubridate::year(budsjett$giPeriode() ) %>% as.character() )

        return(df)

}

# hovedtabell1
# tabell1_forside
hovedtabell1 <- function(budsjett_object , budsjett_anslag ) {

    l <- map2(bud,a_list, function(x,y) hovedtabell1_hjelp1(x,y) )

    return(bind_rows(l))

}

test <- function(bud , a_list ) {

    l <- map2(bud , a_list, function(x,y) hovedtabell1_hjelp1(x,y) )

    return(bind_rows(l))

}



