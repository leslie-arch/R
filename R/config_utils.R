library(rjson)
library(yaml)
library(rlang)

init_config_with_file <- function(filename)
{
  path <- paste0(getwd(), '/extdata/base_config.yaml')
  base_cfg <- yaml::yaml.load_file(path)

  seted_cfg <- yaml::yaml.load_file(filename)

  update_config(base_cfg, seted_cfg)
}

update_config <- function(base, seted)
{
  print('updating config...\n')

  for( n in names(base))
  {
    if ( n %in% names(seted))
    {
      print(sprintf('-------------- %s\n', n))
    }
  }
}
