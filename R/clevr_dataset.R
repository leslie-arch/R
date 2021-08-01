
new_clevr_dataset <- function(name, cfg)
{
  message('Creating dataset: ', name)

  value <- list()

  image_dir <- paste(cfg$DATASETS$DIR, cfg$DATASETS[[toupper(name)]][['IMAGE']], sep = '/')
  anns_file <- paste(cfg$DATASETS$DIR, cfg$DATASETS[[toupper(name)]][['ANNS']], sep = '/')

  class(value) <- "ClevrDataset"
  value[['image_directory']] <- image_dir
  value[['anns_file']] <- anns_file
  scenes <- fromJSON(file = anns_dir)
  value[['scenes']] <- as.list(scenes$scenes)

  if (cfg$CLEVR$COMP_CAT)
  {
    colors = c('blue', 'brown', 'cyan', 'gray', 'green', 'purple', 'red', 'yellow')
    materials = c('rubber', 'metal')
    shapes = c('cube', 'cylinder', 'sphere')
    category_ids = list()
    categories = list()
    cat_id = 1
    for (c in colors)
    {
      for (m in materials)
      {
        for (s in shapes)
        {
          categories <- append(categories, paste(c, m, s, sep = ' '))
          category_ids <- append(category_ids, cat_id)
          cat_id <- cat_id + 1
        }
      }
    }
  }
  else
  {
    category_ids = list(1, 2, 3)
    categories = list('cube', 'cylinder', 'sphere')
  }

  names(category_ids) <- categories
  #(category_ids)
  value[['category_to_id_map']] <- category_ids
  value[['classes']] <-  c('__background__', categories)
  value[['num_classes']] <- length(value$classes)

  #cache dir
  cache_path <- paste(cfg$DATA_DIR, 'cache', sep = '/')
  #message('--------- cache path: ', cache_path)
  if (! file.exists(cache_path))
  {
    dir.create(cache_path)
  }
  value[['cache_path']] <- cache_path

  return(value)
}

valid_cached_keys <- function(obj) UseMethod('valid_cached_keys')
valid_cached_keys.ClevrDataset <- function(obj)
{
  keys <- c('boxes', 'segms', 'gt_classes', 'seg_areas', 'gt_overlaps',
            'is_crowd', 'box_to_gt_ind_map')

  return(keys)
}

# get_roidb 被定义为泛型函数
# A <- function(obj) UseMethod(B)
# 当调用A函数时，会寻找并调用名为 B.<class> 的方法
# 所以，通常定义时A和B相同
get_roidb <- function(obj, ...)  UseMethod('get_roidb', obj)
get_roidb.ClevrDataset <- function(obj,
                                   gt = FALSE,
                                   proposal_file = NULL,
                                   min_proposal_size = 2,
                                   proposal_limit = -1,
                                   crowd_filter_thresh = 0)
{
  roidb <- obj
  nimgs <- length(roidb$scenes)
  entries <- list()
  #message('------------ images: ', nimgs)
  for(i in 1:nimgs)
  {
    entries[[i]] <- c(file_name = obj$scenes[[i]]$image_filename,
                      height = 320,
                      width = 480,
                      id = obj$scenes[[i]]$image_index)
  }

  message('----length entries: ', length(entries))
  print(entries[1:20])
  for(i in 1:length(entries))
  {
    entries[[i]] <- proc_roidb_entry(entries[[i]])
  }

  return(roidb)
}

proc_roidb_entry <- function(obj, ...)  UseMethod('proc_roidb_entry', obj)
proc_roidb_entry.ClevrDataset <- function(obj, entry)
{
  # """Adds empty metadata fields to an roidb entry."""
  # Reference back to the parent dataset
  #entry['dataset'] = self
  # Make file_name an abs path
  im_path = os.path.join(
    self.image_directory, self.image_prefix + entry['file_name']
  )
  assert os.path.exists(im_path), 'Image \'{}\' not found'.format(im_path)
  entry['image'] = im_path
  entry['flipped'] = False
  entry['has_visible_keypoints'] = False
                                        # Empty placeholders
  entry['boxes'] = np.empty((0, 4), dtype=np.float32)
  entry['segms'] = []
  entry['gt_classes'] = np.empty((0), dtype=np.int32)
  entry['seg_areas'] = np.empty((0), dtype=np.float32)
  entry['gt_overlaps'] = scipy.sparse.csr_matrix(
    np.empty((0, self.num_classes), dtype=np.float32)
  )
  entry['is_crowd'] = np.empty((0), dtype=np.bool)
                                        # 'box_to_gt_ind_map': Shape is (#rois). Maps from each roi to the index
                                        # in the list of rois that satisfy np.where(entry['gt_classes'] > 0)
  entry['box_to_gt_ind_map'] = np.empty((0), dtype=np.int32)
                                        # Remove unwanted fields that come from the json file (if they exist)
   entry['file_name']
}
