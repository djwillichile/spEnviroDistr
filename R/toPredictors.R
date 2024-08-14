#' @export
toPredictors=function(layerList,layerNames=NULL,reference=NULL){
  if(is.null(layerNames) & is.null(names(layerList)))
    layerNames=as.character(sapply(layerList,names))

  if(is.null(layerNames)) layerNames=names(layerList)

  if(length(layerNames)!=length(layerList))
    stop("layerNames length and layerList length is not equal")

  if(is.null(reference)){
    message("IMPORTANT!\nFirst layer will be used at reference to resampling")
    reference=layerList[[1]]
  }

  predictors=rast(pblapply(layerList, function(x)
    resample(x,reference,verbose = F)))

  names(predictors)=layerNames

  return(predictors)

}
