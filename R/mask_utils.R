
library(Rcpp)

sourceCpp('src/mask_utils.cpp')

new_RLEVec <- function(n)
{

}

new_MaskVec <- function(h, w, n)
{

}

mask_utils_decode <- function(rleObjs)
{
  print(rleObjs)
}

_frString <- function(rleObjs)
{
  n <- length(rleObjs)

  rv <- new_RLEVec(n)
}
