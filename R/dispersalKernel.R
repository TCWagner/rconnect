#' Create a rectangular dispersal kernel
#'
#' @param cellsize Cell size of your habitat raster.
#' @param radius Radius of the kernel in cells.
#' @param decay Decay of the negative exponential function of the kernel.
#' @param centervalue value that should be set for the focal cell.
#' @param weighted Wether the kernel should be normalized
#'
#' @return A matrix with the kernel probablity density.
#' @export
#'
#' @examples
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#'

dispersalKernel <- function(cellsize=1, radius=3, decay=1, centervalue=0, weighted=T){
  kernelwidth = 2* radius+1
  center <- as.integer((kernelwidth * kernelwidth)/2)+1
  r <- raster::raster(vals=1, crs="+proj=utm +zone=32 +ellps=GRS80 +units=m +no_defs", res=c(cellsize,cellsize), xmn=0, xmx=cellsize*kernelwidth, ymn=0, ymx=cellsize*kernelwidth)
  r[center] <- 2
  d <- raster::gridDistance(r,origin=2)

  kernel <- (1-decay)^raster::as.matrix(d)

  kernel[center] <- centervalue



  # and normalize
  if(weighted){
    kernel <- kernel/(sum(kernel))
  }

  class(kernel) <- c("dispersalkernel")
  attr(kernel, "cellsize") <- cellsize
  attr(kernel, "radius") <- radius
  attr(kernel, "formula") <- "negative exponential"
  attr(kernel, "decay") <- decay
  attr(kernel, "normalized") <- weighted


  return(kernel)
}
