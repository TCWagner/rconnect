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
#' data(habitats_lech)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' eC <- absoluteConnections(habitats_lech, sddkernel_chondrilla, threshold=0.01)
#'
absoluteConnections <- function(habitats, kernel, threshold=0.05, summarize=TRUE){
  return(effectiveConnections(habitats = habitats, kernel=kernel, threshold=threshold, weighted=FALSE, cap=FALSE, summarize=summarize))

  }
