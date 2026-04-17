# Convert EPSG Code to CRS String

This function converts an EPSG code into a corresponding coordinate
reference system (CRS) string in PROJ.4 format. The EPSG code is a
standard identifier used for geographic coordinate systems.

## Usage

``` r
epsg(x)
```

## Arguments

- x:

  An integer or numeric value representing the EPSG code. For example,
  4326 corresponds to WGS 84.

## Value

A character string in PROJ.4 format that represents the CRS associated
with the given EPSG code.

## Details

The function attempts to convert an EPSG code into its corresponding
PROJ.4 string using the `sp` package. If the conversion fails (e.g., due
to an invalid or unsupported EPSG code), the function will stop and
return an error message.

The `EPSG` code is a widely used identifier for coordinate reference
systems. This function simplifies the process of obtaining the
corresponding PROJ.4 string, which can then be used in various spatial
analysis tasks.

## References

European Petroleum Survey Group (EPSG). *Geodetic Parameter Dataset*.
<https://epsg.org/>

Bivand, R. S., Pebesma, E., & Gómez-Rubio, V. (2013). *Applied Spatial
Data Analysis with R* (2nd ed.). Springer.
[doi:10.1007/978-1-4614-7618-4](https://doi.org/10.1007/978-1-4614-7618-4)

## Examples

``` r
# Convert EPSG code 4326 to PROJ.4 string
epsg(4326)
#> [1] "+proj=longlat +datum=WGS84 +no_defs"

# Convert EPSG code 28992 (RD New / Amersfoort)
epsg(28992)
#> [1] "+proj=sterea +lat_0=52.1561605555556 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

# Handling an invalid EPSG code (this will return an error)
if (FALSE) { # \dontrun{
epsg(999999)
} # }
```
