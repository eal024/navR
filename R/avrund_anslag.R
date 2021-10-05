# avrund_anslag


#' @description
#' Avrunder etter avrundingsregler til budsjettanslag til Budsjettgruppa.
#'
#' @details
#' Avrunder verdi etter avrundingsreglene til hvordan budsjettanslag skal leveres til Budsjettgruppa.
#' Poster på under 2 mill. kroner blir avrundet til nærmeste 0,1 mill. kroner.
#' Poster i intervallet 2–199 mill. kroner blir avrundet til nærmeste 1 mill. kroner.
#' Poster i intervallet 200–999 mill. kroner blir avrundet til nærmeste 5 mill. kroner.
#' Poster på 1000 mill. kroner eller mer blir avrundet til nærmeste 10 mill. kroner
#'
#' @param x verdi som skal avrundes.
#' @param i_mill_kr boolean TRUE eller FALSE i mill.kr eller i hele kroner. Default er FALSE

#' @examples
#' avrund_anslag(x = 204.1, i_mill_kr = T)
#' returns 205



avrund_anslag <- function( x, i_mill_kr = F){

    if( i_mill_kr == FALSE){
        #
        if(x <= 2*10^6)     { return( round(x, -5) ) }
        else if( x > 2*10^6 & x < 199*10^6){ return( round(x, -6))}
        else if( dplyr::between(x, 200*10^6, 999*10^6) ){ return( plyr::round_any(x, 5*10^6, f = round) )}
        else if( x > 999*10^6){return( round(x,-7))}
    }
    if( i_mill_kr == TRUE){
        #
        if(x <= 2)     { return( round(x, 1) ) }
        else if( x > 2 & x < 199){ return( round(x, .1))}
        else if( dplyr::between(x, 200 , 999 ) ){ return( plyr::round_any( x, 5, f = round) ) }
        else if( x > 1000){return( round(x,-1))}
    }




}
