#' Determine the effective Connections (eC) for all patches
#'
#' @param habitats Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
#' @param threshold Minimum of eC at which two patches are connected.
#' @param weighted If true, the connection are weighted.
#' @param cap If true, values larger than 1 are capped.
#' @param summarize If TRUE, a table instead of a raster is returned.
#'
#' @return A table or raster with the effectiveConnectivity for each Patch
#' @export
#'
#' @examples
#' data(habitats_lech)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' eC <- effectiveConnections(habitats_lech, sddkernel_chondrilla, threshold=0.01, cap=TRUE)
#'

effectiveConnections <- function(habitats, kernel, threshold=0.05, weighted=FALSE, cap=TRUE, summarize=T){
  rc <- raster::clump(habitats>0)

  patches <- raster::cellStats(rc, max)

  zs <- data.frame(zone=seq(1,patches), connections=rep(0,patches))

  for(p in 1:patches){
    focalpatch <- rc==p
    otherpatches <- rc != p

    pdp2_local <- raster::focal(focalpatch, kernel, na.rm=T)/sum(kernel) # make sure it is normalized (0...1)

    targets <- pdp2_local * (pdp2_local > threshold)
    targets <- targets * otherpatches
    # zonal statistics

    if(weighted==FALSE){
      targets <- targets > threshold
      res <- as.data.frame(raster::zonal(targets, rc, fun=max))
      #message("no weights")
    }

    if(weighted==TRUE){
      res <- as.data.frame(raster::zonal(targets, rc, fun=sum))
      res$value[res$value[]>1] <- 1 # make sure each habitat counts max as 1
    }

    zs$connections <- zs$connections + res$value


    zs$connections[is.infinite(zs$connection[])] <- NA

    if(cap){
      zs$connections[zs$connection[]>1] <- 1
    }
  }
  if(cap){
    names(zs) <- c("patch", "eC")
  }else{
    names(zs) <- c("patch", "nC")
  }

  if(summarize){
    return(zs)
  }

  # else reclassify and return raster

  rc <- raster::clump(habitats>=0)
  rc2 <- raster::reclassify(rc, zs)
  result <- rc2
  if(weighted==FALSE & cap==FALSE){
    names(result) <- c("nC")
  }else{
    names(result) <- c("eC")
  }

  return(result)
}
