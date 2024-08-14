#' Prediction Grid for Meuse Data Set
#'
#' The meuse.grid data frame has 3103 rows and 7 columns; a grid with 40 m x 40 m spacing that covers the Meuse study area (see meuse).
#'
#' @docType data
#' @usage data(meuse, package = "spEnviroDistr")
#' @format A data frame with 3103 observations on the following 9 variables:
#' \describe{
#'   \item{x}{A numeric vector; x-coordinate (see meuse).}
#'   \item{y}{A numeric vector; y-coordinate (see meuse).}
#'   \item{part.a}{Arbitrary division of the area in two areas, a and b.}
#'   \item{part.b}{See part.a.}
#'   \item{elev}{Relative elevation above local river bed, m.}
#'   \item{alt}{Altitude above sea level, m.}
#'   \item{dist}{Distance to the Meuse river; obtained by a spread (spatial distance) GIS operation, from border of river; normalized to \eqn{[0,1]}.}
#'   \item{soil}{Soil type, for definitions see this item in meuse; it is questionable whether these data come from a real soil map, they do not match the published 1:50 000 map.}
#'   \item{ffreq}{Flooding frequency class, for definitions see this item in meuse; it is not known how this map was generated.}
#' }
#' @details x and y are in RD New, the Dutch topographical map coordinate system. Roger Bivand projected this to UTM in the R-Grass interface package.
#' @source \url{http://www.gstat.org/}
#' @references See the meuse documentation.
#' @examples
#' data(meuse.grid, package = "spEnviroDistr")
#' coordinates(meuse.grid) = ~x+y
#' proj4string(meuse.grid) <- CRS("+init=epsg:28992")
#' gridded(meuse.grid) = TRUE
#' spplot(meuse.grid, "alt")
#' spplot(meuse.grid, c("dist", "soil", "ffreq", "part.a", "part.b","elev"))
"meuse.grid"
