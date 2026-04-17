# Apply Geographically Weighted Regression (GWR)

This function applies Geographically Weighted Regression (GWR) to a
given formula and dataset. GWR is a local form of linear regression used
to model spatially varying relationships.

## Usage

``` r
applyGWR(
  formula,
  data,
  longlat = TRUE,
  cl = NULL,
  fit.points = NULL,
  showProgressSteps = FALSE
)
```

## Arguments

- formula:

  A formula object describing the model to be fitted, e.g.,
  `log(y) ~ x1 + x2`.

- data:

  A spatial data frame (`SpatialPointsDataFrame` or
  `SpatialPolygonsDataFrame`) containing the variables in the formula.

- longlat:

  Logical; if `TRUE`, coordinates are treated as longitude/latitude.
  Default is `TRUE`.

- cl:

  Optional. A cluster object for parallel processing created by
  `makeCluster`. Default is `NULL`.

- fit.points:

  Optional. A spatial data frame for making predictions at specified
  locations. If `NULL`, no predictions are made.

- showProgressSteps:

  Logical; if `TRUE`, prints progress messages during the analysis.
  Default is `FALSE`.

## Value

A list with the following components:

- inputs:

  A list containing the inputs used for the GWR analysis: `formula`,
  `data`, and `longlat`.

- output:

  A list of class `gwr` containing the following elements:

## Details

This function is intended for use with spatial datasets where
relationships between variables may vary across space. GWR fits a
separate regression model at each location in the data, weighting nearby
points more heavily based on a specified bandwidth.

## References

Fotheringham, A. S., Brunsdon, C., & Charlton, M. (2002).
*Geographically Weighted Regression: The Analysis of Spatially Varying
Relationships*. John Wiley & Sons.
[doi:10.1002/9780470999141](https://doi.org/10.1002/9780470999141)

Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996).
Geographically Weighted Regression: A Method for Exploring Spatial
Nonstationarity. *Geographical Analysis*, 28(4), 281-298.
[doi:10.1111/j.1538-4632.1996.tb00936.x](https://doi.org/10.1111/j.1538-4632.1996.tb00936.x)

Fotheringham, A. S., & O'Sullivan, D. (2004). Spatial Nonstationarity
and Local Models. In *Geographic Information Systems: Principles,
Techniques, Management and Applications* (2nd ed., pp. 239-255). Wiley.

Bivand, R. S., Pebesma, E., & Gómez-Rubio, V. (2013). *Applied Spatial
Data Analysis with R* (2nd ed.). Springer.
[doi:10.1007/978-1-4614-7618-4](https://doi.org/10.1007/978-1-4614-7618-4)

## Examples

``` r
data(meuse.grid, package = "spEnviroDistr")
coordinates(meuse.grid) = ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
#> Warning: GDAL Message 1: +init=epsg:XXXX syntax is deprecated. It might return a CRS with a non-EPSG compliant axis order.
gridded(meuse.grid) <- TRUE

data(meuse, package = "spEnviroDistr")
coordinates(meuse) = ~x+y
proj4string(meuse) <- CRS("+init=epsg:28992")

cl <- createCluster(free = 2)
RESULT <- applyGWR(log(copper) ~ alt + dist, meuse, longlat = FALSE, cl = cl)

print(RESULT$output)
#> Call:
#> gwr(formula = formula, data = data, bandwidth = bwG, adapt = adG, 
#>     hatmatrix = TRUE, longlat = longlat, cl = cl, predictions = TRUE)
#> Kernel function: gwr.Gauss 
#> Adaptive quantile: 0.01146238 (about 1 of 155 data points)
#> Summary of GWR coefficient estimates at data points:
#>                     Min.     1st Qu.      Median     3rd Qu.        Max.
#> X.Intercept. -17.0918413   3.7531281   9.3204449  13.0599683  40.5131677
#> alt           -0.9623308  -0.2499946  -0.1443481   0.0032744   0.5419798
#> dist          -9.2546319  -3.8881674  -1.9964676  -0.7525851   3.9001866
#>               Global
#> X.Intercept.  6.7962
#> alt          -0.0786
#> dist         -1.5609
#> Number of data points: 155 
#> Effective number of parameters (residual: 2traceS - traceS'S): 85.62554 
#> Effective degrees of freedom (residual: 2traceS - traceS'S): 69.37446 
#> Sigma (residual: 2traceS - traceS'S): 0.261182 
#> Effective number of parameters (model: traceS): 66.28962 
#> Effective degrees of freedom (model: traceS): 88.71038 
#> Sigma (model: traceS): 0.2309702 
#> Sigma (ML): 0.1747339 
#> AICc (GWR p. 61, eq 2.33; p. 96, eq. 4.21): 139.6473 
#> AIC (GWR p. 96, eq. 4.22): -34.63161 
#> Residual sum of squares: 4.732451 
#> Quasi-global R2: 0.8810787 

RESULT <- applyGWR(log(copper) ~ alt + dist + elev, meuse, longlat = FALSE, cl = cl, fit.points = meuse.grid)
```
