
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rconnect

<!-- badges: start -->
<!-- badges: end -->

rconnect is a simple package that implements riverscape connectivity
measures ‘effectiveDistance’ and ‘effectiveConnectivity’ for wind
dispersed plants as described by Wagner & Wöllner (2022)

## Installation

You can install the current development version of rconnect from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("TCWagner/rconnect")
```

## Example

This is a basic example how to work with the package and calculate
simple connectivity metrics of a riverscape.

Let’s find out how well the habitats of a riverscape (a riverine
landscape) are connected for a certain species. As example we chose the
Asteracea Chondrilla chondrilloides, an wind dispersed species well
adapted to open gravel bars of alpine rivers. For details about the
species ecology, dispersal and status, see Wöllner et al. 2022.

Let’s start with a raster file, containing the suitable habitats for our
species. Suitable habitats need to have a value \> 0; 0 codes for
unsuitable habitats. Here we use our example data that comes with our
package: habitats_lech

``` r
library(raster)
#> Warning: Paket 'raster' wurde unter R Version 4.1.2 erstellt
#> Lade nötiges Paket: sp
library(rconnect)

## load the example raster with suitable habitats. suitable habitats need to be coded with values > 0
## you may use your own raster, here we use our example data:
data(habitats_lech)
plot(habitats_lech)
```

<img src="man/figures/README-example-1.png" width="100%" />

We then need to create a dispersal kernel for the species under
consideration. Assuming a negative exponential decrease of the seeds
with distance and a dispersal distance of \~14m the decay is 0.19.

To create the kernel, we need to provide the cellsize of our raster
containing the suitable habitats (5m), and the intended radius of our
kernel in cells. By default, the kernel center cell will be set to 0 and
the kernel normalized to sum up to 1.

``` r
cckernel <- dispersalKernel(cellsize=5, radius=5, decay=0.19)
#> Lade nötigen Namensraum: igraph
```

Now we can easily calculate the number of connections (eC) that each
patch has:

``` r
nC <- absoluteConnections(habitats_lech, cckernel)
nC
#>   patch nC
#> 1     1  0
#> 2     2  1
#> 3     3  2
#> 4     4  0
#> 5     5  3
#> 6     6  1
#> 7     7  1
#> 8     8  1
#> 9     9  0
```

However, if we want to have the effective connections (that is the
connections weighted by distance) we can use:

``` r
eC <- effectiveConnections(habitats_lech, cckernel)
eC
#>   patch        eC
#> 1     1 0.0000000
#> 2     2 0.1842729
#> 3     3 0.5721172
#> 4     4 0.0000000
#> 5     5 1.0000000
#> 6     6 0.1258424
#> 7     7 0.2991850
#> 8     8 0.5086541
#> 9     9 0.0000000
```

If we want to have the effective connectivity for our whole riverscape
we just need to calculate the mean of the effective connections:

``` r
mean(eC$eC)
#> [1] 0.2988968
```

So, our riverscape has a conectivity of \~30% for Chondrilla
choncrilloides.

We can now determine the effective distance (eD), a measure that tells
us, how fas away a patch would be from an …

``` r
eD <- effectiveDistance(habitats_lech, cckernel)
eD
#>   patch         eD
#> 1     1         NA
#> 2     2  4.9962768
#> 3     3  0.0000000
#> 4     4 10.9351921
#> 5     5  0.0000000
#> 6     6  8.9908412
#> 7     7  4.9482707
#> 8     8  0.4196436
#> 9     9 17.1338503
```

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
