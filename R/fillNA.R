#' Fill NA values in a Raster
#'
#' This function fills NA values in a raster using a focal median filter.
#'
#' @param x A `SpatRaster` object from the `terra` package.
#' @param w A matrix representing the focal window to be used. Typically, this is a square matrix with odd dimensions.
#' @param i An integer specifying the number of iterations to apply the focal filter.
#' @param verbose A logical value indicating whether to print the iteration number. Default is `FALSE`.
#'
#' @return A `SpatRaster` object with NA values filled.
#'
#' @details The function iteratively applies a focal median filter to fill NA values in a raster. The filter is applied `i` times. If `verbose` is `TRUE`, the function prints the iteration number.
#'
#' @examples
#' # Load the meuse.grid data
#' data(meuse.grid, package = "spEnviroDistr")
#' coordinates(meuse.grid) = ~x+y
#' proj4string(meuse.grid) <- CRS("+init=epsg:28992")
#' gridded(meuse.grid) <- TRUE
#'
#' # Convert meuse.grid to SpatRaster
#' r <- rast(meuse.grid)
#'
#' # Define the focal window
#' w <- matrix(1, 3, 3)
#'
#' # Fill NA values with 3 iterations and verbose output
#' result <- fillNA(r[["alt"]], w, 3, verbose = TRUE)
#'
#' # Plot the result
#' plot(c(r[["alt"]],result))
#'
#' @importFrom stats median
#' @importFrom terra focal
#' @export
fillNA=function(x,w,i, verbose = FALSE){
  if (verbose) cat("Iteration:", i, "\n")
  a=names(x)
  x=focal(x, w=w,median, na.policy="only", na.rm=T)
  names(x)=a
  i=i-1
  if(i>0) fillNA(x,w,i,verbose) else return(x)
}
