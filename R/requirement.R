required_packages <- c("keras", "tensorflow", "reticulate", "argparse", "yaml", "R6", "rjson", "itertools", 'logging')
installed_packages <- installed.packages()
uninstalled_packages <- setdiff(required_packages, installed_packages)

uninstalled_packages
if (length(uninstalled_packages) > 0)
{
  install.packages(uninstalled_packages)
}

if (length(required_packages) > 0)
{
  lapply(required_packages, library, character.only=TRUE)
}
