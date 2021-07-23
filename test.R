
.fname <- function()
{
    path <- commandArgs()[4]

    file <- strsplit(path, split = "=|\\.")
    print(file)

    return(file[[1]][[2]])
}

file <- .fname()
print(file)
