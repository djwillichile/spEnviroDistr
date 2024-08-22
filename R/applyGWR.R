#' Apply Geographically Weighted Regression (GWR)
#'
#' This function applies Geographically Weighted Regression (GWR) to a given formula and dataset.
#' GWR is a local form of linear regression used to model spatially varying relationships.
#'
#' @param formula A formula object describing the model to be fitted, e.g., `log(y) ~ x1 + x2`.
#' @param data A spatial data frame (`SpatialPointsDataFrame` or `SpatialPolygonsDataFrame`)
#'   containing the variables in the formula.
#' @param longlat Logical; if `TRUE`, coordinates are treated as longitude/latitude. Default is `TRUE`.
#' @param cl Optional. A cluster object for parallel processing created by `makeCluster`. Default is `NULL`.
#' @param fit.points Optional. A spatial data frame for making predictions at specified locations.
#'   If `NULL`, no predictions are made.
#' @param showProgressSteps Logical; if `TRUE`, prints progress messages during the analysis. Default is `FALSE`.
#'
#' @return A list with the following components:
#' \describe{
#'   \item{inputs}{A list containing the inputs used for the GWR analysis: `formula`, `data`, and `longlat`.}
#'   \item{output}{A list of class `gwr` containing the following elements:}
#'   \describe{
#'     \item{SDF}{A `SpatialPointsDataFrame` (which may be gridded) or `SpatialPolygonsDataFrame` object with `fit.points`, weights, GWR coefficient estimates, R-squared, and coefficient standard errors in its "data" slot.}
#'     \item{lhat}{The Leung et al. L matrix, which provides an indication of local multicollinearity.}
#'     \item{lm}{An ordinary least squares (OLS) global regression model fitted on the same model formula, as returned by `lm.wfit()`.}
#'     \item{bandwidth}{The bandwidth used in the GWR analysis.}
#'     \item{this.call}{The function call used to run the GWR analysis.}
#'   }
#' }
#'
#' @details This function is intended for use with spatial datasets where relationships between variables
#'   may vary across space. GWR fits a separate regression model at each location in the data, weighting
#'   nearby points more heavily based on a specified bandwidth.
#'
#' @references
#' Fotheringham, A. S., Brunsdon, C., & Charlton, M. (2002). \emph{Geographically Weighted Regression: The Analysis of Spatially Varying Relationships}. John Wiley & Sons. \doi{10.1002/9780470999141}
#'
#' Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996). Geographically Weighted Regression: A Method for Exploring Spatial Nonstationarity. \emph{Geographical Analysis}, 28(4), 281-298. \doi{10.1111/j.1538-4632.1996.tb00936.x}
#'
#' Fotheringham, A. S., & O'Sullivan, D. (2004). Spatial Nonstationarity and Local Models. In \emph{Geographic Information Systems: Principles, Techniques, Management and Applications} (2nd ed., pp. 239-255). Wiley.
#'
#' Bivand, R. S., Pebesma, E., & Gómez-Rubio, V. (2013). \emph{Applied Spatial Data Analysis with R} (2nd ed.). Springer. \doi{10.1007/978-1-4614-7618-4}
#'
#' @examples
#' data(meuse.grid, package = "spEnviroDistr")
#' coordinates(meuse.grid) = ~x+y
#' proj4string(meuse.grid) <- CRS("+init=epsg:28992")
#' gridded(meuse.grid) <- TRUE
#'
#' data(meuse, package = "spEnviroDistr")
#' coordinates(meuse) = ~x+y
#' proj4string(meuse) <- CRS("+init=epsg:28992")
#'
#' cl <- createCluster(free = 2)
#' RESULT <- applyGWR(log(copper) ~ alt + dist, meuse, longlat = FALSE, cl = cl)
#'
#' print(RESULT$output)
#'
#' RESULT <- applyGWR(log(copper) ~ alt + dist + elev, meuse, longlat = FALSE, cl = cl, fit.points = meuse.grid)
#'
#' @importFrom spgwr gwr gwr.sel
#' @importFrom sp coordinates proj4string
#' @export
applyGWR <- function(formula, data, longlat = TRUE,cl = NULL,
                      fit.points = NULL, showProgressSteps = FALSE) {

  if (showProgressSteps) cat("\nObtaining bandwidth\n")
  # Bandwidth
  bwG <- gwr.sel(formula = formula, data = data, longlat = longlat,
                 verbose = FALSE, adapt = FALSE,
                  method = "cv", RMSE = TRUE, show.error.messages = FALSE)

  if (showProgressSteps) cat("\nObtaining adaptive bandwidth\n")
  # Adaptive
  adG <- gwr.sel(formula = formula, data = data, longlat = longlat,
                 verbose = FALSE, adapt =  TRUE,
                 method = "cv", RMSE = TRUE, show.error.messages = FALSE)

  if (showProgressSteps) cat("\nEstimating parameters\n")
  # GWR according to parameters
  gwrG <- gwr(formula = formula, data = data, longlat = longlat,
              bandwidth = bwG, adapt = adG,
              predictions = TRUE, cl = cl, hatmatrix = TRUE)

  output <- list(inputs = list(formula = formula, data = data,longlat = longlat),
                 output = gwrG)

  if (is.null(fit.points)) return(output)

  if (showProgressSteps) cat("\nPredicting on the grid\n")
  gwrG <- gwr(formula = formula, data = data, longlat = longlat,
              bandwidth = bwG, adapt = adG,
              fit.points = fit.points, predict = TRUE,
              se.fit = TRUE, fittedGWRobject = gwrG, cl = cl)

  output$output <- gwrG

  return(output)
}
