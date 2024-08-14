#' @export
toTerra=function(x){
  msg=paste0("Object is '",class(x),"', must be a class from 'raster' or 'terra' package.")

  if(is.null(attr(class(x),"package"))) stop(msg)
  if(!(attr(class(x),"package") %in% c("raster","terra"))) stop(msg)

  if(attr(class(x),"package")=="raster") x=rast(x)

  return(x)
}
