#' Returns a matrix with the effective Connections (eC) between patches
#'
#' @param habitats Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
#' @param threshold Minimum of eC at which two patches are connected.
#'
#' @return A matrix with patch-to-patch effectiveConnectivity
#' @export
#'
#' @examples
#' data(habitats_lech)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' eCM <- effectiveConnectionsMatrix(habitats_lech, sddkernel_chondrilla, threshold=0.01)
#'

effectiveConnectionsMatrix <- function(habitats, kernel, threshold=0.05){
  rc <- raster::clump(habitats>0)

  patches <- raster::cellStats(rc, max)

  zs <- array(0,c(patches,patches))

  for(p in 1:patches){
    focalpatch <- rc==p
    otherpatches <- rc != p

    pdp2_local <- raster::focal(focalpatch, kernel, na.rm=T)/sum(kernel) # make sure it is normalized (0...1)

    targets <- pdp2_local * (pdp2_local > threshold)
    targets <- targets * otherpatches
    # zonal statistics


    # determine how much a each patch gets from the source
    res <- as.data.frame(raster::zonal(targets, rc, fun=sum))
    zs[,p] <- as.numeric(res$value)
    zs[p,p] <- 1

  }

  return(zs)
}
