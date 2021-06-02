

# Table Chi-square Distribution
get_chi_table <- function( ) {
    tibble::tibble( df = 1:20, p = list(p = c(.995, 0.99,0.975,0.9,0.1,0.05,0.025,0.01) ) ) %>%
        dplyr::mutate( chi = map2(df,p, function(x,y) { qchisq( y, df = x, lower.tail = F) }  )) %>%
        tidyr::unnest( cols = c(p,chi)) %>%
        tidyr::pivot_wider( names_from = p, values_from = chi) %>% janitor::clean_names()
}




