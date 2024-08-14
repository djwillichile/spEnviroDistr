#' Converts a Data Frame into a Spatial Grid Object
#'
#' This function transforms a data frame into a spatial grid object, suitable for spatial analysis.
#' The function uses the columns specified in the `coords` parameter to define the spatial coordinates
#' in the data frame. The coordinate reference system (CRS) is specified by the `crs_str` parameter,
#' which defines how the spatial coordinates are interpreted. The result is a grid object that can
#' be used for spatial analysis in various spatial data packages and tools.
#'
#' @param x A data frame containing the spatial data. Must include columns for coordinates.
#' @param coords A character vector of length 2 specifying the names of the columns
#'   in the data frame that represent the x and y coordinates.
#' @param crs_str A character string or a `CRS` object representing the coordinate
#'   reference system to be assigned to the spatial object. If `NULL`, no CRS is assigned.
#'
#' @return A spatial grid object with the specified coordinates and CRS.
#'
#' @details The function assumes that the data frame contains columns with coordinate data
#'   specified by the `coords` parameter. It converts the data frame to a spatial grid object
#'   using the `sp` package functions. The CRS is set if a valid CRS string or object is provided.
#'
#' @examples
#' # Load the meuse.grid data
#' data(meuse.grid, package = "spEnviroDistr")
#'
#' # Convert meuse.grid to a spatial grid with specified coordinates and CRS
#' meuse.grid <- toGrid(meuse.grid, coords = c("x", "y"), crs_str = "+init=epsg:28992")
#'
#' # Plot the spatial grid
#' spplot(meuse.grid, "alt")
#' spplot(meuse.grid, c("dist", "soil", "ffreq", "part.a", "part.b", "elev"))
#'
#' @importFrom sp coordinates proj4string gridded CRS
#' @export
toGrid <- function(x, coords, crs_str) {

  if (!is.data.frame(x)) {
    stop("x must be a data frame.")
  }

  if (length(coords) != 2 | !is.character(coords)) {
    stop("coords must be a character vector of length 2.")
  }

  if (is.null(crs_str)) warning("CRS is NULL. No CRS is assigned.")

  if (!all(coords %in% names(x))) {
    stop("The specified coordinates in 'coords' must be present in the data frame.")
  }

  if(class(crs_str) != "CRS") crs_str <- CRS(crs_str)

  names(x)[names(x) %in% coords] <- c("Longitude", "Latitude")

  coordinates(x) <-  ~ Longitude + Latitude
  proj4string(x) <- crs_str
  gridded(x) <-  TRUE

  return(x)
}
