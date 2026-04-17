# Convert SpatRaster to Spatial Points Data Frame

This function converts a `SpatRaster` object into a
`SpatialPointsDataFrame`, preserving the coordinate reference system
(CRS) and including `x` and `y` coordinates. It is useful when you need
to work with raster data in a spatial format suitable for analysis in
various spatial data packages.

## Usage

``` r
toSpatData(layers, na.rm = TRUE)
```

## Arguments

- layers:

  A `SpatRaster` object representing the raster layers to be converted.

- na.rm:

  Logical. If `TRUE`, NA values are removed from the data (default is
  `TRUE`).

## Value

A `SpatialPointsDataFrame` object containing the raster data with
corresponding spatial coordinates.

## Details

The function first converts the `SpatRaster` into a tibble with x and y
coordinates using the `as_tibble` function. The resulting tibble is then
converted into a spatial object with spatial points (x and y
coordinates). The coordinate reference system (CRS) is assigned from the
input raster using the `proj4string` function.

## Note

The function assumes that the `SpatRaster` object has a valid CRS. If
the CRS is missing or invalid, the resulting spatial object may not
align properly with other spatial data.

## Examples

``` r
logo <- rast(system.file("ex/logo.tif", package="terra"))
names(logo) <- c("red", "green", "blue")
spat_data <- toSpatData(logo)
head(spat_data)
#>   coordinates red green blue
#> 1 (0.5, 76.5) 255   255  255
#> 2 (1.5, 76.5) 255   255  255
#> 3 (2.5, 76.5) 255   255  255
#> 4 (3.5, 76.5) 255   255  255
#> 5 (4.5, 76.5) 255   255  255
#> 6 (5.5, 76.5) 255   255  255
```
