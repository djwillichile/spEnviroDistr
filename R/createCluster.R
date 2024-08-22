#' Create a Cluster for Parallel Processing
#'
#' This function creates a parallel processing cluster by detecting the number of available CPU cores on the machine,
#' subtracting the number of cores specified to be left free, and using the remaining cores to create the cluster.
#' This can be useful for speeding up computations that can be parallelized.
#'
#' @param free Integer. The number of CPU cores to leave free for other tasks. The default is 1.
#' @return A `cluster` object that can be used with parallel processing functions like `parLapply` and `parApply`.
#' @details
#' This function detects the total number of CPU cores available on the machine using the `parallel` package.
#' It then subtracts the number of cores specified in the `free` parameter and creates a cluster using the remaining cores.
#'
#' On Linux systems, the function will use the `snow` package's `getClusterOption()` to determine the type of cluster
#' to create, ensuring compatibility with the system's parallel processing capabilities. On other operating systems,
#' the function defaults to creating a basic cluster without specifying a type, which should work for most cases.
#'
#' Note that this function requires the `parallel` and `snow` packages to be installed and loaded.
#'
#' @examples
#' \dontrun{
#' # Create a cluster leaving 2 cores free for other tasks
#' cl <- createCluster(free = 2)
#'
#' # Use the cluster for parallel processing
#' # ...
#'
#' # Stop the cluster when done
#' parallel::stopCluster(cl)
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
