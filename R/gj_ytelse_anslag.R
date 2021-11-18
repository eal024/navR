


##  Lage en df for en serie anslag
gj_ytelse_anslag <- function( tabell, gj_ar,  anslag, gi_navn ){

    # Tar først inn tabell (antall og snittytelse basert på regnskap)
    tabell <- tabell

    # Antall i siste regnskapsår
    antall_base_ar <- tabell$antall[tabell$ar == ( as.numeric(gj_ar)-1) ]

    # Nullstiller antall mottakere til null (slik at det ikke lagres på "stedet" i minnet)
    map( anslag , function(x) x$setAntallMottakere( antall = NULL ) )


    # Setter lengde på vektorer som inngår i loopen under.
    # Vektorene skal ha info om antall, gj. ytelse og ar. Dette hentes ut fra anslagene i loopen.
    vec_antall    <- vector( length = length(anslag))
    vec_gj_ytelse <- vector( length = length(anslag))
    vec_ar        <- vector( length = length(anslag))

    # Hente ut info fra anslagene
    for(i in 1:length(anslag)) {

        vec_ar[i] <- anslag[[i]]$giAr()

        # Første i listen er årets anslag.
        if( i == 1){      antall =   anslag[[i]]$setAntallMottakere(antall = antall_base_ar*anslag[[i]]$giVolumvekst( ) )}

        # De påfølgende anslagene følger etter
        else if( i > 1 ){ antall =   anslag[[i]]$setAntallMottakere(antall = anslag[[i-1]]$giAntallMottakere()*anslag[[i]]$giVolumvekst( ) ) }

        #
        vec_antall[i]    <- anslag[[i]]$giAntallMottakere()
        vec_gj_ytelse[i] <- anslag[[i]]$giSumAnslag()/vec_antall[i]

    }

    ## Setter det sammen til en tibble
    tibble::tibble( ar = c( (gj_ar-1), vec_ar),
                    antall = c( antall_base_ar, vec_antall ),
                    ytelse = c( tabell$ytelse[tabell$ar == (gj_ar-1) ] ,vec_gj_ytelse)
                    ) %>%
        dplyr::mutate( antall_endring = ((antall/lag(antall))-1), ytelse_endring = ((ytelse/lag(ytelse))-1) ) %>%
        dplyr::mutate( navn = gi_navn) %>%
        dplyr::relocate( navn, .before = ar) %>%
        na.omit()

}




