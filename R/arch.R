#!/usr/bin/env Rscript

root <- getwd()
setwd(root)

start <- function()
{

}

params <- function()
{
  params <- commandArgs(trailingOnly = TRUE)
  #arg_list

  args <- rebuild_params("-d mscoco")
  print(args)
}
