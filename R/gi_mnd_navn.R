






gi_mnd_navn <- function( date, forkortet = FALSE) {

    long_names <- c("januar", "februar", "mars", "april", "mai", "juni", "juli", "august", "september", "oktober","november", "desember")

    mnd <- factor( long_names,
                  levels = long_names )

    if( forkortet == T)
    { return( str_sub(mnd[ lubridate::month(date)], start = 1, end = 3) )
    } else {
            return(mnd[ lubridate::month(date) ]) }

}



