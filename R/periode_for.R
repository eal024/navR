
#' Hjelpefunksjon gi navn-vektor i mnd tabell
#'
#' @description
#' Hjelpefuksjon som teller måneder tilbake, og gir vectoren navn etter angitt mnd.
#'
#' @details
#' Hjelpefunksjon, sammen med fuksjon navR::gi_mnd_navn
#'
#' @param periode
#' @param x  vector mndTabell$lengde c(3,6,9,12)
#' @param ar 1 for ett ar tilbake, 0 for gjeldende ar.

#' @examples
#' # Illustrarert:
#' ar    <- 1
#  x     <- c(3,6,9,12)
#  x_vec <- c( -12*(ar), -(x+(12*ar) ))
#  c( ymd("2021-10-01")  %m+% months(c(x_vec[1],x_vec[2])) ) %>% map_chr( function(x) str_c( navR::gi_mnd_navn(x, forkortet = T), "",  year(x) %>% str_sub(start = 3, end = 4) ))



periode_for <- function( periode, x, ar) {

    # Bruker c(3,6,9,12). For i år, lager: c(0,-3,-9,-12), For år = 1, lager c(-12,-15, -18, -21, -24).
    # Dette brukes til å "telle" antall måndeder tilbake.
    x_vec =  c( (-12*ar),-(x+ (12*ar)  ) )

    # Teller mnd. tilbake, for x_vec og gir dem navn fra funksjon gi_mnd_navn
    fra = c( periode  %m+% months(c(x_vec[1],x_vec[2])) ) %>% map_chr( function(x) str_c( navR::gi_mnd_navn(x, forkortet = T), "",  year(x) %>% str_sub(start = 3, end = 4) ))

    # Lager framstillingen: "jul20-okt20" (for perioden 2021-10-01, år = 1)
    str_c( str_c( fra[2], "-", fra[1]) )
}






# periode_for_test <- function( periode, x, ar = 1) {
#
#     # Bruker c(3,6,9,12) og lager c()
#     x_vec =  c( (-12*ar),-(x+ (12*ar)  ) )
#
#     fra = c( periode  %m+% months(c(x_vec[1],x_vec[2])) ) %>% map_chr( function(x) str_c( navR::gi_mnd_navn(x, forkortet = T), "",  year(x) %>% str_sub(start = 3, end = 4) ))
#
#     str_c( str_c( fra[2], "-", fra[1]) )
# }


# tabell$tabellMndUtvikling() %>%
#     group_by(lengde) %>%
#     mutate( lengde =  stringr::str_c( periode_for_test( ymd("2021-10-01")  , lengde, ar = 1), " til ",periode_for_test( ymd("2021-10-01") , lengde, ar = 0)  ) )
#
#
# c( ymd("2021-10-01")  %m+% months(c(x_vec[1],x_vec[2])) ) %>% map_chr( function(x) str_c( navR::gi_mnd_navn(x, forkortet = T), "",  year(x) %>% str_sub(start = 3, end = 4) ))
#
#
# a <- tabell$tabellMndUtvikling()$lengde
#
# x_vec <- c(0,a+(12*1)-1)
#
# x_vec[1]
#
#
# c( ymd("2021-10-01")  %m+% months(c(x_vec[1],x_vec[2]) ) )
#
#
#
# # Tar inn c(3,6,9,12)
# #
# ar    <- 1
# x     <- c(3,6,9,12)
# x_vec <- c( -12*(ar), -(x+(12*ar) ))
# x_vec
#
# c( ymd("2021-10-01")  %m+% months(c(x_vec[1],x_vec[2])) ) %>% map_chr( function(x) str_c( navR::gi_mnd_navn(x, forkortet = T), "",  year(x) %>% str_sub(start = 3, end = 4) ))
#
#
#
# mutate( lengde =  stringr::str_c( periode_for( bud_post1$giPeriode()  , lengde, ar = 1), " til ",periode_for(bud_post1$giPeriode(), lengde, ar = 0)  ) )
#
#









