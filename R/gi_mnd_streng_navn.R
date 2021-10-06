







periode_for <- function( periode, x, ar = 1) {

    x_vec =  c(-0,-(x+ (12*ar)-1  ) )

    fra = c( periode  %m+% months(c(x_vec[1],x_vec[2])) ) %>% map_chr( function(x) str_c( navR::gi_mnd_navn(x, forkortet = T), "",  year(x) %>% str_sub(start = 3, end = 4) ))

    str_c( str_c(fra[2], "-", fra[1]))
}


# bud$lagTabellMndUtviklingMottakere() %>%
#     group_by(lengde) %>%
#     mutate( lengde = str_c( periode_for( bud$giPeriode(), lengde, ar = 1), " til ",periode_for(bud$giPeriode(), lengde, ar = 0 )  ))
#


