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

  return(base)
}

adjust_config_with_args <- function(cfg, args)
{
  message("--------------------------", 'adjust config')
  #print(typeof(cfg$TRAIN$DATSETS))
  if ('clevr' %in% args$dataset)
  {
    cfg$TRAIN$DATASETS <- list('clevr_mini')
    #print(typeof(cfg$TRAIN$DATSETS))
    cfg$TRAIN$SCALES = c(320)

    cfg$DATASETS$DIR <- paste0(getwd(), '/data/mask_rcnn')
    message(cfg$DATASETS$DIR)
    cfg$MODEL$NUM_CLASSES <- ifelse(args$clear_comp_cat, 49, 4)
    cfg$MODEL$COMP_CAT <- ifelse(args$clear_comp_cat, TRUE, FALSE)
  }
  else
  {
    stop('Unexpected args.dateset: ', args$dataset)
  }

  return(cfg)
}
