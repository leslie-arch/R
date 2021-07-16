#!/usr/bin/env Rscript

root <- getwd()
setwd(root)

source('rcnn_argumentation.R')
main <- function()
{
  args <- parse_args()
  sprintf("start with config:\n[%s]", str(args))
}

main()
