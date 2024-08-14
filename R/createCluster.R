#' Create a Cluster for Parallel Processing
#'
#' This function detects the number of cores available on the machine,
#' subtracts the number of cores specified to be left free, and creates a cluster
#' using the remaining cores.
#'
#' @param free Integer. Number of cores to leave free. Default is 1.
#' @return A cluster object.
#' @details This function detects the total number of available cores on the machine, subtracts
#' the number of cores specified to be left free, and creates a cluster with the remaining cores.
#' On Linux systems, the cluster type is determined using the `snow` package's `getClusterOption()`.
#' On other operating systems, it creates a default cluster without specifying the type.
#'
#' Note: This function requires the `parallel` and `snow` packages to be installed.
#'
#' @examples
#' \dontrun{
#' cl <- createCluster(free = 2)
#' }
#' @importFrom parallel detectCores makeCluster stopCluster
#' @importFrom snow getClusterOption
#' @export
createCluster <- function(free = 1) {
  no_cores <- parallel::detectCores() - free
  os <- Sys.info()["sysname"]

  if (os == "Linux") {
    type <- snow::getClusterOption("type")
    cl <- parallel::makeCluster(no_cores, type = type)
    return(cl)
  }

  cl <- parallel::makeCluster(no_cores)
  return(cl)
}
