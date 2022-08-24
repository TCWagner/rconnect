#' Determine the absolute Number of Connections (nC) for all patches
#'
#' @param habitats Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
#' @param threshold Minimum fraction of eC at which two patches are connected.
#' @param summarize If TRUE, a table instead of a raster is returned.
#'
#' @return A table or raster with the number of connections (nC) for each Patch
#' @export
#'
#' @examples
#' example <- system.file("extdata/cc_clumped_lech_ehd.tif", package = "rconnect")
#' habitats_lech <- raster::raster(example)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' nC <- absoluteConnections(habitats_lech, sddkernel_chondrilla, threshold=0.01)
#'
#'
absoluteConnections <- function(habitats, kernel, threshold=0.05, summarize=TRUE){

  ecm <- effectiveConnectionsMatrix(habitats, kernel, threshold)
  res <- colSums(ecm>threshold, na.rm=T)
  zs <- data.frame(patch=seq(1,length(res)), nC=res)

  if(summarize){
    return(zs)
     }

  # else reclassify and return raster

  rc <- raster::clump(habitats>=0)
  rc2 <- raster::reclassify(rc, zs)
  result <- rc2
  names(result) <- c("nC")

  return(result)

  }
