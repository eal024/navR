


nav_farger_vis_farger <- function( ) {

    nav_fargene2 <- navR::nav_farger()

    tibble::tibble( navn = nav_fargene2, farger = nav_fargene2, verdi = 1) %>%
        ggplot2::ggplot( aes( y = verdi, x = farger, fill = farger)) +
        ggplot2::geom_col() +
        ggplot2::scale_fill_manual( values = nav_fargene2)

}
