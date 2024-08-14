#' @export
epsg<-function(x){
  x<-as.numeric(x)
  crs_str<-NULL
  try(crs_str<-sp::CRS(paste0("+init=epsg:",x)),silent = T)
  if(is.null(crs_str)) stop("fred")
  crs_str<-sp::proj4string(crs_str)
  return(crs_str)
}
