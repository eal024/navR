


##  Lage en df for en serie anslag
gj_ytelse_anslag <- function( tabell, gj_ar,  anslag, gi_navn ){

    tabell <- tabell
    antall_base_ar <- tabell$antall[tabell$ar == ( as.numeric(gj_ar)-1) ]


    map( anslag , function(x) x$setAntallMottakere( antall = NULL ) )


    # Vectores
    vec_antall    <- vector( length = length(anslag))
    vec_gj_ytelse <- vector( length = length(anslag))
    vec_ar        <- vector( length = length(anslag))

    # Hente ut info fra anslagene
    for(i in 1:length(anslag)) {

        vec_ar[i] <- anslag[[i]]$giAr()


        if( i == 1){      antall =   anslag[[i]]$setAntallMottakere(antall = antall_base_ar*anslag[[i]]$giVolumvekst( ) )}

        else if( i > 1 ){ antall =   anslag[[i]]$setAntallMottakere(antall = anslag[[i-1]]$giAntallMottakere()*anslag[[i]]$giVolumvekst( ) ) }

        vec_antall[i] <- anslag[[i]]$giAntallMottakere()
        vec_gj_ytelse[i] <- anslag[[i]]$giSumAnslag()/vec_antall[i]

    }


    tibble::tibble( ar = c( (gj_ar-1), vec_ar),
                    antall = c( antall_base_ar, vec_antall ), ytelse = c( tabell$ytelse[tabell$ar == (gj_ar-1) ] ,vec_gj_ytelse) ) %>%
        dplyr::mutate( antall_endring = antall/lag(antall), ytelse_endring = ytelse/lag(ytelse) ) %>%
        dplyr::mutate( navn = gi_navn) %>%
        dplyr::relocate( navn, .before = ar) %>%
        na.omit()

}
