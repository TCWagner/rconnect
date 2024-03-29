% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/effectiveDistancesMatrix.R
\name{effectiveDistancesMatrix}
\alias{effectiveDistancesMatrix}
\title{Returns a matrix with the effective Distances (eD) between patches}
\usage{
effectiveDistancesMatrix(
  habitats,
  kernel,
  threshold = 0.05,
  replace_inf = FALSE
)
}
\arguments{
\item{habitats}{Raster containing patches of suitable habitats, coded with values > 0.}

\item{kernel}{Dispersal kernel of the species.}

\item{threshold}{Minimum of eC at which two patches are connected.}

\item{replace_inf}{If other than FALSE, all infinite values (eC=0) will be replaced by this value.}
}
\value{
A matrix with patch-to-patch effectiveDistances
}
\description{
Returns a matrix with the effective Distances (eD) between patches
}
\examples{
example <- system.file("extdata/cc_clumped_lech_ehd.tif", package = "rconnect")
habitats_lech <- raster::raster(example)
sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
eDM <- effectiveDistancesMatrix(habitats_lech, sddkernel_chondrilla, threshold=0.01)

}
