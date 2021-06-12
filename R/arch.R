#!/usr/bin/env Rscript

root <- getwd()
setwd(root)

start <- function()
{

}

params <- commandArgs(trailingOnly = TRUE)
#arg_list

args <- rebuild_params(params)
print(args)
