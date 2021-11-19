





create_copies <- function( poster ){

    df <- tibble::tibble(         files = dir()) %>%
        dplyr::filter(        stringr::str_detect(files ,"post70")) %>%
        tidyr::nest(        data      = c(files)) %>%
        tidyr::expand_grid( post      = poster   ) %>%
        dplyr::mutate(      nytt_navn = purrr::map2( data, post, function(x,y) {stringr::str_replace_all(x$files, pattern = "70", replacement = y)} )) %>%
        tidyr::unnest(      col       = c(data, nytt_navn) ) %>%
        dplyr::mutate(      kopi1     = purrr::walk2(files,  nytt_navn, function(x,y) { file.copy(x, to = y ) } ) )
    rm(df)
}


