#' Convert a List of Layers into a RasterStack of Predictors
#'
#' This function converts a list of raster layers into a `SpatRaster` object, aligning them to a common reference grid for spatial analysis.
#' It allows for resampling of the layers to match a specified reference layer and assigns appropriate names to the resulting raster stack.
#'
#' @param layerList A list of raster layers (`SpatRaster` objects) to be combined into a `SpatRaster` stack. These layers should represent different environmental variables or predictors.
#' @param layerNames An optional character vector specifying names for the layers in the resulting `SpatRaster`. If not provided, the function will attempt to derive names from the input list.
#' @param reference An optional reference layer (`SpatRaster`) to which all layers in `layerList` will be resampled. If not provided, the first layer in `layerList` will be used as the reference.
#'
#' @return A `SpatRaster` object where all layers have been resampled to match the reference layer and assigned appropriate names.
#'
#' @details
#' The function first checks if `layerNames` are provided or if they can be derived from the `layerList`.
#' If the length of `layerNames` does not match the length of `layerList`, the function will stop and return an error.
#'
#' If no reference layer is provided, the function will use the first layer in `layerList` as the reference for resampling.
#' Each layer in `layerList` is then resampled to match the reference layer's resolution and extent.
#' The resulting raster layers are combined into a `SpatRaster` stack, which can be used as input for further spatial analysis or modeling.
#'
#' @note The function uses parallel processing to speed up the resampling process when dealing with large datasets.
#'
#' @examples
#' library(terra)
#'
#' # Example raster layers
#' r1 <- rast(nrows=10, ncols=10)
#' r2 <- rast(nrows=10, ncols=10)
#' values(r1) <- runif(ncell(r1))
#' values(r2) <- runif(ncell(r2))
#'
#' # Convert to list
#' layers <- list(r1, r2)
#'
#' # Use the first layer as reference for resampling
#' predictors <- toPredictors(layers)
#'
#' # Check the names and extent
#' names(predictors)
#' ext(predictors)
#'
#' @importFrom terra rast resample
#' @importFrom pbapply pblapply
#' @export
toPredictors <- function(layerList, layerNames = NULL, reference = NULL) {
  if (is.null(layerNames) & is.null(names(layerList)))
    layerNames <- as.character(sapply(layerList, names))

  if (is.null(layerNames)) layerNames <- names(layerList)

  if (length(layerNames) != length(layerList))
    stop("layerNames length and layerList length is not equal")

  if (is.null(reference)) {
    message("IMPORTANT!\nFirst layer will be used as reference for resampling")
    reference <- layerList[[1]]
  }

  predictors <- rast(pblapply(layerList, function(x)
    resample(x, reference, verbose = FALSE)))

  names(predictors) <- layerNames

  return(predictors)
}

