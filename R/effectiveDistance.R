#' Calculate effeciveDistance (eD) for habitat patches
#'
#' @param habitats Raster with the effective seedrain, summed up for each patch.
#' @param kernel kernel Dispersal kernel of the species.
#'
#' @return A raster or a summary table with the effective Distance (eD) for each Patch
#' @export
#'
#' @examples
#' data(habitats_lech)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' eD <- effectiveDistance(habitats_lech, sddkernel_chondrilla)
#'
effectiveDistance <- function(habitats, kernel, summarize=TRUE){
  coef <- 1-attr(kernel,"decay")
  eS <- effectiveSeedrain(habitats, kernel, summarize=F, fun=sum)

  rc <- raster::clump(eS>=0)
  zs <- as.data.frame(raster::zonal(eS, rc, fun=mean))

  zs$value <- log(zs$value, base=coef)
  zs$value <- zs$value*(zs$value>=0)
  zs$value[is.infinite(zs$value[])] <- NA

  if(summarize){
    names(zs) <- c("patch","eD")
    return(zs)
  }

  rc <- raster::clump(habitats>=0)
  result <- raster::reclassify(rc, zs)
  names(result) <- c("eD")

  return(result)

}
