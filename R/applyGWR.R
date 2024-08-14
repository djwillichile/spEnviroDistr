#' Apply Geographically Weighted Regression (GWR)
#'
#' This function applies Geographically Weighted Regression (GWR) to a given formula and dataset.
#' It allows for bandwidth selection and adaptive bandwidth, with optional progress messages.
#'
#' @param formula A formula object describing the model to be fitted.
#' @param data A spatial data frame containing the variables in the formula.
#' @param longlat Logical; if TRUE, coordinates are treated as longitude/latitude.
#' @param cl Optional cluster object for parallel processing.
#' @param fit.points Optional spatial data frame for making predictions.
#' @param showProgressSteps Logical; if TRUE, prints progress messages.
#' @return A list containing the inputs and the GWR output.
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
#' RESULT <- apply.GWR(sqrt(copper) ~ alt + dist, meuse, longlat = FALSE, cl = cl)
#'
#' print(RESULT$output)
#'
#' RESULT <- apply.GWR(log(copper) ~ alt + dist + elev, meuse, longlat = FALSE, cl = cl, fit.points = meuse.grid)
#' @export
apply.GWR <- function(formula, data, longlat = TRUE,cl = NULL,
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

  output <- list(inputs = list(formula = formula, data = data,longlat = longlat),
                 output = gwrG)

  return(output)
}
