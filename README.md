
<!-- README.md is generated from README.Rmd. Please edit that file -->

# navR

badges: start ![navR](inst/figures/logo_navR.png) badges: end

Målet med navR er i hovedsak å tilrettelegge arbeidet med
budsjettanslaget til folketrygde i verktøyet R.

## Installasjon

Installer navR fra [GitHub](https://github.com/) ved:

``` r
# install.packages("devtools")
devtools::install_github("eal024/navR")
```

## Eksempel

Et enkelt eksempel på hvordan bruke navR:

``` r
tabell <- navR::RegnskapTabell$new(
    dfRegnskap = navR::regnskap %>% filter(dato < ymd("2020-08-01")) %>% rename( pris = g),
    pris_gjeldende = 100000,
    anslag_ar = 2020,
    anslag_mnd_periode = 08
)


regnskapstabell <- tabell$lagRegnskapTabell(celing_date = T) %>%
    mutate(across(
        .cols = c(regnskap, endring_regnskap, regnskap_fast, endring_regnskap_f),
        .fns = function(x) x / 10 ^ 6 ) 
    )
```

``` r
library(kableExtra)
#> 
#> Attaching package: 'kableExtra'
#> The following object is masked from 'package:dplyr':
#> 
#>     group_rows

navR::latex_tabell(regnskapstabell, size = 6)
```

``` r
knitr::kable(regnskapstabell)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
kategori
</th>
<th style="text-align:left;">
ar
</th>
<th style="text-align:right;">
regnskap
</th>
<th style="text-align:right;">
endring\_regnskap
</th>
<th style="text-align:right;">
regnskap\_vekst
</th>
<th style="text-align:right;">
pris\_snitt
</th>
<th style="text-align:right;">
regnskap\_fast
</th>
<th style="text-align:right;">
endring\_regnskap\_f
</th>
<th style="text-align:right;">
regnskap\_fast\_vekst
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Regnskap
</td>
<td style="text-align:left;">
2016
</td>
<td style="text-align:right;">
2295.4302
</td>
<td style="text-align:right;">
-209.53035
</td>
<td style="text-align:right;">
-0.0836462
</td>
<td style="text-align:right;">
91740.00
</td>
<td style="text-align:right;">
2502.1040
</td>
<td style="text-align:right;">
-296.6721
</td>
<td style="text-align:right;">
-0.1060006
</td>
</tr>
<tr>
<td style="text-align:left;">
Regnskap
</td>
<td style="text-align:left;">
2017
</td>
<td style="text-align:right;">
2055.7662
</td>
<td style="text-align:right;">
-239.66400
</td>
<td style="text-align:right;">
-0.1044092
</td>
<td style="text-align:right;">
93281.33
</td>
<td style="text-align:right;">
2203.8345
</td>
<td style="text-align:right;">
-298.2695
</td>
<td style="text-align:right;">
-0.1192075
</td>
</tr>
<tr>
<td style="text-align:left;">
Regnskap
</td>
<td style="text-align:left;">
2018
</td>
<td style="text-align:right;">
1826.7347
</td>
<td style="text-align:right;">
-229.03149
</td>
<td style="text-align:right;">
-0.1114093
</td>
<td style="text-align:right;">
95800.00
</td>
<td style="text-align:right;">
1906.8212
</td>
<td style="text-align:right;">
-297.0133
</td>
<td style="text-align:right;">
-0.1347711
</td>
</tr>
<tr>
<td style="text-align:left;">
Regnskap
</td>
<td style="text-align:left;">
2019
</td>
<td style="text-align:right;">
1709.0292
</td>
<td style="text-align:right;">
-117.70549
</td>
<td style="text-align:right;">
-0.0644349
</td>
<td style="text-align:right;">
98866.33
</td>
<td style="text-align:right;">
1728.6261
</td>
<td style="text-align:right;">
-178.1951
</td>
<td style="text-align:right;">
-0.0934514
</td>
</tr>
<tr>
<td style="text-align:left;">
Regnskap
</td>
<td style="text-align:left;">
2019-08-31
</td>
<td style="text-align:right;">
1146.9949
</td>
<td style="text-align:right;">
-87.79218
</td>
<td style="text-align:right;">
-0.0710990
</td>
<td style="text-align:right;">
98370.50
</td>
<td style="text-align:right;">
1165.9947
</td>
<td style="text-align:right;">
-130.2539
</td>
<td style="text-align:right;">
-0.1004853
</td>
</tr>
<tr>
<td style="text-align:left;">
Regnskap
</td>
<td style="text-align:left;">
2020-08-31
</td>
<td style="text-align:right;">
955.4292
</td>
<td style="text-align:right;">
-191.56570
</td>
<td style="text-align:right;">
-0.1670153
</td>
<td style="text-align:right;">
99858.00
</td>
<td style="text-align:right;">
956.7878
</td>
<td style="text-align:right;">
-209.2069
</td>
<td style="text-align:right;">
-0.1794236
</td>
</tr>
</tbody>
</table>
