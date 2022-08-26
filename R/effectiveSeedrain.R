#' Determines the effective Seed Rain (eS)
#'
#' @param habitats Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
#' @param seedweight raster containing weight for seed density(e.g. occupancy, seed load ...)
#' @param suitabilityweight raster containing weight for habitat suitability
#' @param weightmode whether seed rain should be calculated for sending cells or receiving cells. Only used when weights are provided
#' @param summarize If true, a summary table will be returned instead of a raster.
#' @param fun A function used for summary. If summarize=TRUE and none is provided sum is used.
#' If summarize is FALSE and a function is provided, a zonal statistics is applied to the raster
#'
#' @return A raster or a table with the effective seed rain (eS)
#' @export
#'
#' @examples
#' example <- system.file("extdata/cc_clumped_lech_ehd.tif", package = "rconnect")
#' habitats_lech <- raster::raster(example)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' eS <- effectiveSeedrain(habitats_lech, sddkernel_chondrilla, fun=sum)
#'

effectiveSeedrain <- function(habitats, kernel, seedweight=FALSE, suitabilityweight=FALSE, weightmode="receive", summarize=TRUE, fun=sum){
  rc <- raster::clump(habitats>0)#+1

  # create an empty template with extent of original raster
  template <- (rc>=0)*0

  patches <- raster::cellStats(rc, max)

  # make sure kernel is normalized
  kernel <- kernel/sum(kernel)

  for(p in 1:patches+1){
    focalpatch <- rc==p
    otherpatches <- rc != p
    if(methods::is(seedweight,"RasterLayer")){
      otherpatches <- otherpatches * seedweight
    }

    pdp2_local <- raster::focal(focalpatch, kernel, na.rm=T)
    pdp2_other <- raster::focal(otherpatches, kernel, na.rm=T)

    pdp2 <- pdp2_other*focalpatch
    if(methods::is(suitabilityweight,"RasterLayer")){
      pdp2 <- pdp2*suitabilityweight
    }


    template <- template + pdp2
  }

  result <- template
  names(result) <- c("eS")

  # if summarize is TRUE but no function provided, use sum as default
  if(summarize & !methods::is(fun, "function")){
    fun <- sum
  }


  if(methods::is(fun, "function")){
    rc <- raster::clump(habitats>=0)
    zs <- as.data.frame(raster::zonal(template, rc, fun=fun)) # evtl statt mean summe?
    rc2 <- raster::reclassify(rc, zs)
    result <- rc2
    names(result) <- c(paste(substitute(fun),"of eS"))
  }

  # if summarize is TRUE do zonal statistics and return results instead of a raster
  if(summarize){
    names(zs) <- c("patch", "eS")
    return(zs)
  }

  return(result)

}
