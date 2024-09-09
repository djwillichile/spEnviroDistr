#' Downscale Function for Spatial Data
#'
#' This function performs downscaling of spatial data using regression methods, including linear regression (lm), generalized linear model (glm), and geographically weighted regression (gwr).
#' It ensures that all input rasters have the same CRS and extent, resamples the response raster if necessary, and checks the overlap percentage between the high-resolution predictor and low-resolution predictor rasters.
#'
#' @param response SpatRaster. The response variable raster (e.g., temperature) at low resolution.
#' @param pred.lr SpatRaster. The low-resolution predictor raster(s) (e.g., elevation at low resolution).
#' @param pred.hr SpatRaster. The high-resolution predictor raster(s) (e.g., elevation at high resolution) to be used for prediction.
#' @param method Character. The method used for downscaling. Options are "lm" for linear regression, "glm" for generalized linear model, and "gwr" for geographically weighted regression. Default is "gwr".
#' @param cl Optional. A cluster object for parallel processing. Default is NULL.
#'
#' @return A list containing two elements: the fitted model and the predicted high-resolution raster.
#' @details
#' The function checks that all rasters share the same CRS and extent. If the extents are not identical, it resamples the response raster to match the low-resolution predictor raster using bilinear interpolation.
#' It also calculates the overlap percentage between the high- and low-resolution rasters and stops execution if the overlap is less than 60%.
#'
#' The response raster is the variable of interest at a lower resolution (e.g., temperature), while `pred.lr` and `pred.hr` are the predictors at low and high resolutions, respectively (e.g., elevation). If the method is "lm" or "glm", it fits the model using the response and low-resolution predictor raster data and returns the model and the predicted high-resolution raster. If the method is "gwr", it performs geographically weighted regression using the provided spatial data and returns the result.
#'
#' @importFrom terra crs ext expanse intersect union resample rast
#' @importFrom stats lm glm formula predict
#' @importFrom sp gridded
#' @examples
#' library(terra)
#'
#' # Load sample data
#' data(dem)
#' data(elev)
#' data(tavg)
#'
#' # Convert to SpatRaster objects
#' tavg <- rast(tavg)   # Response raster (e.g., temperature)
#' elev <- rast(elev)   # Low-resolution predictor (e.g., elevation at low resolution)
#' dem <- rast(dem)     # High-resolution predictor (e.g., elevation at high resolution)
#' dem<-aggregate(dem,2)
#'
#' # Apply the downscale function with GWR method
#' result <- downscale(response = tavg, pred.lr = elev, pred.hr = dem, method = "gwr")
#'
#' # View the model and predicted high-resolution raster
#' print(result$model)
#' par(mfrow=c(2,1))
#' plot(tavg)
#' plot(result$result)
#'
#' @export
downscale <- function(response, pred.lr, pred.hr, method = "gwr", cl=NULL) {

  if (!method %in% c("gwr","lm","glm")){
    stop("method must be 'lm', 'glm' or 'gwr'")
  }

  # Ensure all rasters have the same CRS and extent
  if (!identical(crs(response), crs(pred.lr)) ||
      !identical(crs(response), crs(pred.hr))) {
    stop("All rasters must have the same CRS.")
  }

  # Resample response to match pred.lr extent if necessary
  if (!identical(ext(response), ext(pred.lr))) {
    response <- resample(response, pred.lr, method = "bilinear")
  }


  # Calculate overlap between extents of pred.hr and pred.lr
  ext.hr<-ext(pred.hr)
  ext.lr<-ext(pred.lr)
  overlap_area <- terra::intersect(ext.hr, ext.lr)
  total_area <- terra::union(ext.hr, ext.lr)
  overlap_percent <- (expanse(as.polygons(overlap_area)) / expanse(as.polygons(total_area)))

  # plot(total_area)
  # plot(overlap_area,add=T)

  # Check if overlap is less than 60%
  if (overlap_percent < .6) {
    stop("The extent of pred.hr overlaps less than 60% with pred.lr")
  }

  FIT=formula(paste0(names(response),"~",paste(names(pred.lr),collapse = "+")))

  model_data<-toSpatData(c(response,pred.lr))
  fit.points<-toSpatData(pred.hr,na.rm = T)
  gridded(fit.points)<-T

  # Model fitting for lm or glm
  if(method == "lm") model <- lm(FIT, data = model_data)
  if(method == "glm") model <- glm(FIT, data = model_data)

  if(method %in% c("lm","glm")) {
    result <- predict(pred.hr,model)
    names(result)<-names(response)

    return(list(model=model,result=result))
  }

  # Model fitting for GWR
  if(method == "gwr") {
    result <- applyGWR(FIT,model_data,longlat = T, fit.points = fit.points)
    RESULT <- applyGWR(FIT,model_data,longlat = T)

    RESULT$output$lm<-result$output$lm
    RESULT$output$SDF<-result$output$SDF

    result<-rast(result$output$SDF)$pred
    names(result)<-names(response)

    return(list(model=RESULT$output,result=result))

  }
}
