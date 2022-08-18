#' Determine the colonizationPotential (cP) for all patches
#'
#' @param habitats Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
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
#' cP <- colonizationPotential(habitats_lech, sddkernel_chondrilla, cap=TRUE)
#'

colonizationPotential <- function(habitats, kernel, cap=FALSE, summarize=TRUE){
  res <- effectiveSeedrain(habitats, kernel, summarize=summarize, fun=sum)
  if(summarize==T){
    names(res) <- c("patch","cP")
    if(cap==T){
      res$cP[res$cP[]>1] <- 1 # make sure each habitat counts max as 1
    }
    return(res)
  }
  z <- raster::clump(habitats)
  raster::zonal(res, z, fun=sum)
  if(cap){
    res <- res*(res<=1)+1*(res>1)
  }
  return(res)
# test
}
