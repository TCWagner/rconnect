#' Summarize the colonizationPotential (cP) for a riverscape
#'
#' @param habitats Raster containing patches of suitable habitats, coded with values > 0.
#' @param kernel Dispersal kernel of the species.
#' @param threshold Minimum of eC at which two patches are connected.
#' @param ed_with_threshold If true, only patches within threshold are considered for eDm.
#' @param cap If true, values larger than 1 are capped.
#'
#' @return A table or raster with the colonizationPotential for each Patch
#' @export
#'
#' @examples
#' example <- system.file("extdata/cc_clumped_lech_ehd.tif", package = "rconnect")
#' habitats_lech <- raster::raster(example)
#' sddkernel_chondrilla <- dispersalKernel(cellsize=5, radius=3, decay=0.19)
#' cP <- colonizationPotential(habitats_lech, sddkernel_chondrilla, threshold=0.01, cap=TRUE)
#'

colonizationPotential <- function(habitats, kernel, threshold=0, ed_with_threshold=FALSE, cap=FALSE){
  coef <- 1-attr(kernel,"decay")
  ecm <- effectiveConnectionsMatrix(habitats, kernel, threshold)

  # calculate eCm
  res <- colSums(ecm*(ecm>threshold), na.rm=T)
  efc <- res
  eCm <- mean(res)
  eCm_sd <- stats::sd(res)

  # calculate eDm
  if(ed_with_threshold==FALSE){
    ecm <- effectiveConnectionsMatrix(habitats, kernel, threshold=0)
  }
  res <- colSums(ecm, na.rm=T)
  res <- log(res, base=coef)
  res[res<0] <- 0
  res <- subset(res, res<Inf)
  eDm <- mean(res)
  eDm_sd <- stats::sd(res)

  # calculate nCm
  res <- colSums(ecm>threshold, na.rm=T)
  nbc <- res
  nCm <- mean(res)
  nCm_sd <- stats::sd(res)

  # calculate CC

  cC <- efc/nbc

  cC[is.na(cC)] <- 0
  cC <- subset(cC, cC>0)
  cCm <- mean(cC)
  cCm_sd <- stats::sd(cC)

  cp <- data.frame(habitats=names(habitats),threshold=threshold,cP=eCm, cP_rsd=eCm_sd/eCm, eD=eDm, eDm_rsd=eDm_sd/eDm, nCm=nCm, nCm_rsd=nCm_sd/nCm, cCm=cCm, cCm_rsd=cCm_sd/cCm)

  return(cp)

}

