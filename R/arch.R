#!/usr/bin/env Rscript

root <- getwd()
setwd(root)

source("./src/requirement.R")
source("./src/arg_reader.R")

start <- function()
{

}

arg_list <- commandArgs(trailingOnly = TRUE)
#arg_list

args <- read_args(arg_list)
print(args)
