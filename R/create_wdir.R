

#' #' create project environment
#' #' @export
create_wdir <-  function( ) {

    if( dir.exists("data")       ) {message("data folder exist")       } else{ dir.create("data");message("folder data created") }
    if( dir.exists("data_export")) {message("data_export folder exist")} else{ dir.create("data_export");message("Folder for exporting data is created")}
    if( dir.exists("plot")) {message("plot folder exist")       } else{ dir.create("plot");message("Folder plot, for saving plots is created ")}



}
