% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/epsg.R
\name{epsg}
\alias{epsg}
\title{Convert EPSG Code to CRS String}
\usage{
epsg(x)
}
\arguments{
\item{x}{An integer or numeric value representing the EPSG code. For example, 4326 corresponds to WGS 84.}
}
\value{
A character string in PROJ.4 format that represents the CRS associated with the given EPSG code.
}
\description{
This function converts an EPSG code into a corresponding coordinate reference system (CRS) string in PROJ.4 format. The EPSG code is a standard identifier used for geographic coordinate systems.
}
\details{
The function attempts to convert an EPSG code into its corresponding PROJ.4 string using the \code{sp} package. If the conversion fails (e.g., due to an invalid or unsupported EPSG code), the function will stop and return an error message.

The \code{EPSG} code is a widely used identifier for coordinate reference systems. This function simplifies the process of obtaining the corresponding PROJ.4 string, which can then be used in various spatial analysis tasks.
}
\examples{
# Convert EPSG code 4326 to PROJ.4 string
epsg(4326)

# Convert EPSG code 28992 (RD New / Amersfoort)
epsg(28992)

# Handling an invalid EPSG code (this will return an error)
\dontrun{
epsg(999999)
}

}
\references{
European Petroleum Survey Group (EPSG). \emph{Geodetic Parameter Dataset}. \url{https://epsg.org/}

Bivand, R. S., Pebesma, E., & Gómez-Rubio, V. (2013). \emph{Applied Spatial Data Analysis with R} (2nd ed.). Springer. \doi{10.1007/978-1-4614-7618-4}
}
