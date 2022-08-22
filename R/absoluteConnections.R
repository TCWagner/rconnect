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
  rc <- raster::clump(habitats>0)

  patches <- raster::cellStats(rc, max)

  zs <- data.frame(zone=seq(1,patches), connections=rep(0,patches))

  for(p in 1:patches){
    focalpatch <- rc==p
    otherpatches <- rc != p

    pdp2_local <- raster::focal(focalpatch, kernel, na.rm=T)/sum(kernel) # make sure it is normalized (0...1)

    #targets <- pdp2_local * (pdp2_local > threshold)
    targets <- pdp2_local * otherpatches
    targets <- targets > threshold
    res <- as.data.frame(raster::zonal(targets, rc, fun=max))

    # zonal statistics

    zs$connections <- zs$connections + res$value
    zs$connections[is.infinite(zs$connection[])] <- NA

  }
  names(zs) <- c("patch", "nC")

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
