#' Convert a Data Frame into a Spatial Grid Object
#'
#' This function transforms a data frame into a spatial grid object, making it suitable for spatial analysis.
#' The function uses the columns specified in the `coords` parameter to define the spatial coordinates
#' in the data frame. The coordinate reference system (CRS) is specified by the `crs_str` parameter,
#' which defines how the spatial coordinates are interpreted. The resulting grid object can
#' be used for spatial analysis in various spatial data packages and tools.
#'
#' @param x A data frame containing the spatial data. The data frame must include columns that represent coordinates.
#' @param coords A character vector of length 2 specifying the names of the columns
#'   in the data frame that represent the x and y coordinates, respectively.
#' @param crs_str A character string or a `CRS` object representing the coordinate
#'   reference system to be assigned to the spatial object. If `NULL`, no CRS is assigned, and a warning is issued.
#'
#' @return A spatial grid object (`SpatialGridDataFrame`) with the specified coordinates and CRS.
#'
#' @details
#' The function first checks that the input `x` is a data frame and that the `coords` parameter
#' specifies two valid column names in `x`. The columns specified by `coords` are renamed to "Longitude"
#' and "Latitude" for internal processing.
#'
#' The function then converts the data frame to a spatial object using the `coordinates` function
#' from the `sp` package, sets the coordinate reference system (CRS) using `proj4string`, and
#' finally converts the spatial points to a grid structure using `gridded`.
#'
#' If a valid `crs_str` is not provided, the function will proceed without assigning a CRS,
#' but it will issue a warning. Assigning a CRS is important for ensuring that spatial data
#' aligns correctly with other spatial datasets.
#'
#' @note The function assumes that the input data frame is structured such that the coordinates
#' are in the same projection system. If the coordinates are in a different projection or are not projected,
#' the user must provide an appropriate `crs_str`.
#'
#' @references
#' Bivand, R. S., Pebesma, E., & Gómez-Rubio, V. (2013). \emph{Applied Spatial Data Analysis with R} (2nd ed.). Springer. \doi{10.1007/978-1-4614-7618-4}
#'
#' Pebesma, E., & Bivand, R. S. (2005). Classes and methods for spatial data in R. \emph{R News}, 5(2), 9-13.
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
