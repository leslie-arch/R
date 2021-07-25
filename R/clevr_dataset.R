
new_clevr_dataset <- function(name, cfg)
{
  message('Creating dataset: ', str(name))

  value <- list()

  image_dir <- paste(cfg$DATASETS$DIR, cfg$DATASETS[[toupper(name)]][['IMAGE']], sep = '/')
  anns_dir <- paste(cfg$DATASETS$DIR, cfg$DATASETS[[toupper(name)]][['ANNS']], sep = '/')
  #message('------------------', image_dir)
  #message('------------------', anns_dir)

  value
  class(value) <- "ClevrDataset"
  return(value)
}
