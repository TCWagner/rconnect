#' Determine the colonizationPotential (cP) for all patches
#'
#' @param habitats Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
#' @param threshold Minimum of eC at which two patches are connected.
#' @param cap If true, values larger than 1 are capped.
#' @param summarize If TRUE, a table instead of a raster is returned.
#'
#' @return A table or raster with the colonizationPotential for each Patch
#' @export
#'
#' @examples
#' example <- system.file("extdata/cc_clumped_lech_ehd.tif", package = "rconnect")
#' habitats_lech <- raster::raster(example)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' cP <- colonizationPotential(habitats_lech, sddkernel_chondrilla, threshold=0.01, cap=TRUE)
#'

colonizationPotential <- function(habitats, kernel, threshold=0, cap=FALSE, summarize=TRUE){
  res <- effectiveConnections(habitats, kernel, threshold)

  cp <- mean(res$eC, na.rm=T)
  if(cap){
    cp <- min(cp,1)
  }

  return(cp)
}

