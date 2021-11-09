



## Latex utprint


latex_tabell  <- function( tabell, size, position = "left" ) {

    tabell_strip <- 1:nrow(tabell)
    tabell_strip <- tabell_strip[tabell_strip %% 2 == 1]

    knitr::kable( x = tabell,
                  booktabs = T, escape = F, digits = 0,
                  format = "latex",
                  col.names  = linebreak( names(tabell) ),
                  align = rep("r", times = ncol(tabell) )
    ) %>%
        kableExtra::kable_styling( latex_options = c("HOLD_position","striped"), stripe_index = tabell_strip  , font_size = size, position = position )




}

