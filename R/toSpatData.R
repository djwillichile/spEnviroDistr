#' Convert SpatRaster to Spatial Points Data Frame
#'
#' This function converts a `SpatRaster` object into a `SpatialPointsDataFrame`,
#' preserving the coordinate reference system (CRS) and including `x` and `y` coordinates.
#' It is useful when you need to work with raster data in a spatial format suitable for analysis
#' in various spatial data packages.
#'
#' @param layers A `SpatRaster` object representing the raster layers to be converted.
#' @param na.rm Logical. If `TRUE`, NA values are removed from the data (default is `TRUE`).
#'
#' @return A `SpatialPointsDataFrame` object containing the raster data with corresponding spatial coordinates.
#'
#' @details
#' The function first converts the `SpatRaster` into a tibble with x and y coordinates using the `as_tibble` function.
#' The resulting tibble is then converted into a spatial object with spatial points (x and y coordinates).
#' The coordinate reference system (CRS) is assigned from the input raster using the `proj4string` function.
#'
#' @note The function assumes that the `SpatRaster` object has a valid CRS.
#' If the CRS is missing or invalid, the resulting spatial object may not align properly with other spatial data.
#'
#' @importFrom terra crs
#' @importFrom tidyterra as_tibble
#' @importFrom sp coordinates proj4string
#' @export
#'
#' @examples
#' logo <- rast(system.file("ex/logo.tif", package="terra"))
#' names(logo) <- c("red", "green", "blue")
#' spat_data <- toSpatData(logo)
#' head(spat_data)
toSpatData <- function(layers, na.rm = TRUE) {
  # Convert SpatRaster to a tibble with x, y coordinates
  layer_data <- as_tibble(layers, xy = TRUE, na.rm = na.rm)

  # Convert tibble to spatial points data frame
  coordinates(layer_data) <- ~x + y

  # Set the coordinate reference system (CRS) using the CRS of the input layers
  proj4string(layer_data) <- crs(layers, proj = TRUE)

  return(layer_data)
}
