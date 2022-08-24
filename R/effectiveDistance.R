#' Calculate effectiveDistance (eD) for habitat patches
#'
#' @param habitats Raster with the effective seedrain, summed up for each patch.
#' @param kernel Dispersal kernel of the species.
#' @param threshold Minimum fraction of eC at which two patches are connected.
#' @param summarize If TRUE, a table instead of a raster is returned.
#'
#' @return A raster or a summary table with the effective Distance (eD) for each Patch. For practical reasons NA is returned for infinite distance
#' @export
#'
#' @examples
#' example <- system.file("extdata/cc_clumped_lech_ehd.tif", package = "rconnect")
#' habitats_lech <- raster::raster(example)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' eD <- effectiveDistance(habitats_lech, sddkernel_chondrilla)
#'
effectiveDistance <- function(habitats, kernel, threshold=0, summarize=TRUE){
  coef <- 1-attr(kernel,"decay")

  pc <- effectiveConnections(habitats, kernel, threshold=threshold)
  res <- log(pc$eC, base=coef)
  zs <- data.frame(patch=seq(1,length(res)), eD=res)

  zs$eD[zs$eD<0] <- 0

  if(summarize){
    return(zs)
  }

  rc <- raster::clump(habitats>=0)
  result <- raster::reclassify(rc, zs)
  names(result) <- c("eD")
  return(result)

}
