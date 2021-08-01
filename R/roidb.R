source('R/clevr_dataset.R')

roidb_for_training <- function(cfg)
{
  datasets <- cfg$TRAIN$DATASETS

  for(n in datasets)
  {
    roidb <- new_clevr_dataset(n, cfg)
  }

  return(roidb)
}
