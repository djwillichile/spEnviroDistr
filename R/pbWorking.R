#' @export
pbWorking=function(x){
  prog=x/2
  cat('\r', "Working [", strrep("=",floor(prog)),
      strrep(" ", 50-floor(prog)), "] ", 2*prog, "%", sep="")
}


