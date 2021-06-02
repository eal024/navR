#'
#'
#' #' create project environment
#' #' @export
#' create_proj_str <-  function( ) {
#'
#'     #
#'     mapper <- dir()
#'     print_liste <- list()
#'
#'     # data
#'     data <- ifelse(  purrr::map_dbl(mapper, ~.x %>% grepl("data")) %>% sum() == 0 , "data opprettet"  ,  "data finnes og opprettes derfor ikke." )
#'
#'     cat(paste("element 1:", data )  )
#'
#'
#' }

