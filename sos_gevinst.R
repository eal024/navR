
# library(tidyverse)
#
# # Hvor lenge individ jobber
# start       <- 24
# slutt       <- 34
# lengde      <- length( c(start:slutt) )
# inntekt     <- 4.57
# arb_avg_pst <- 0.2
# so_kost_pst <- 0.13
# kost        <- -200000/108287
# r           <- 0.04
# R           <- (1/(1+r)^c(0:(lengde-1) ) )
# Prop        <- 1
#
# df <- tibble(  tid         = seq(from = 0, to = (lengde- 1), length.out = lengde),
#          R           = R,
#          inntekt     = c(0, rep(x = inntekt, times = (lengde-1) ) )*Prop,
#          arb_avg     = arb_avg_pst*inntekt,
#          soskost     = so_kost_pst*inntekt,
#          kost        = c( kost, rep(0, times = (lengde-1) )  )
#          ) %>%
#     rowwise() %>%
#     mutate( disk_sum =  sum(inntekt ,arb_avg, soskost, kost)*R) %>%
#     ungroup()
#
#
# df %>% tail()
#
# df %>%
#     summarise_all( ~sum(.x)*108287/10^6)
