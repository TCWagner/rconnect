#' Determine the absolute Number of Connections (nC) for all patches
#'
#' @param habitatraster Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
#' @param minp Minimum fraction of eC at which two patches are connected.
#'
#' @return A table or raster with the number of connections (nC) for each Patch
#' @export
#'
#' @examples
#' data(habitats_lech)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' eC <- absoluteConnections(habitats_lech, sddkernel_chondrilla, minp=0.01)
#'
absoluteConnections <- function(habitatraster, kernel, minp=0.05, summarize=TRUE){
  return(effectiveConnections(habitatraster = habitatraster, kernel=kernel, minp=minp, weight=FALSE, cap=FALSE, summarize=summarize))

  }
