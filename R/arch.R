#!/usr/bin/env Rscript

root <- getwd()
setwd(root)

start <- function()
{

}

arg_list <- commandArgs(trailingOnly = TRUE)
#arg_list

args <- read_args(arg_list)
print(args)
