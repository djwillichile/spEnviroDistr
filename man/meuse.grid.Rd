% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meuse.grid.R
\docType{data}
\name{meuse.grid}
\alias{meuse.grid}
\title{Prediction Grid for Meuse Data Set}
\format{
A data frame with 3103 observations on the following 9 variables:
\describe{
\item{x}{A numeric vector representing the x-coordinate in the RD New (Rijksdriehoek) topographical map coordinate system of the Netherlands.}
\item{y}{A numeric vector representing the y-coordinate in the RD New system.}
\item{part.a}{An arbitrary division of the study area into two parts, labeled as 'a'.}
\item{part.b}{The complementary division of the study area, labeled as 'b'.}
\item{elev}{Relative elevation above the local river bed in meters.}
\item{alt}{Altitude above sea level in meters, derived from the \code{meuse.alt} dataset, which contains altitudes digitized from the 1:10,000 topographical map of the Netherlands.}
\item{dist}{Distance to the Meuse river, derived from a spatial distance operation in a GIS; normalized to \eqn{[0,1]}.}
\item{soil}{Soil type. These classifications are not based on a specific soil map and may not match published soil maps at a scale of 1:50,000.}
\item{ffreq}{Flooding frequency class. The exact method of generating this classification is unknown. For definitions, see the \code{meuse} dataset.}
}
}
\source{
\url{http://www.gstat.org/}
}
\usage{
data(meuse.grid, package = "spEnviroDistr")
}
\description{
The \code{meuse.grid} data frame represents a spatial grid with 40 m x 40 m spacing that covers the Meuse study area.
This dataset is often used for spatial interpolation and geostatistical analysis in the context of environmental modeling.
}
\details{
The \code{x} and \code{y} coordinates are provided in the RD New coordinate system, which is the standard topographical map projection for the Netherlands.
These coordinates were projected to UTM using the R-Grass interface package by Roger Bivand.

The \code{alt} variable represents altitude above sea level, digitized from the 1:10,000 topographical map of the Netherlands as part of the \code{meuse.alt} dataset. This provides a detailed elevation model for the Meuse study area.

The \code{meuse.grid} dataset is commonly used in conjunction with the \code{meuse} dataset for spatial prediction and kriging exercises, where the grid serves as the prediction surface.
}
\examples{
data(meuse.grid, package = "spEnviroDistr")
coordinates(meuse.grid) <- ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
gridded(meuse.grid) <- TRUE

# Visualize the elevation data
spplot(meuse.grid, "alt")

# Visualize multiple variables
spplot(meuse.grid, c("dist", "soil", "ffreq", "part.a", "part.b", "elev"))
}
\references{
\emph{Gstat: A Program for Geostatistical Modelling, Prediction and Simulation}. URL: \url{http://www.gstat.org/}

Bivand, R. S., Pebesma, E., & Gómez-Rubio, V. (2013). \emph{Applied Spatial Data Analysis with R} (2nd ed.). Springer. \doi{10.1007/978-1-4614-7618-4}
}
\keyword{datasets}
