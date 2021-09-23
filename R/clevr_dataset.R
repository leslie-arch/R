
source("mask_utils.R")

new_clevr_dataset <- function(name, cfg)
{
  message('Creating dataset: ', name)

  value <- list()

  image_dir <- paste(cfg$DATASETS$DIR, cfg$DATASETS[[toupper(name)]][['IMAGE']], sep = '/')
  anns_file <- paste(cfg$DATASETS$DIR, cfg$DATASETS[[toupper(name)]][['ANNS']], sep = '/')

  class(value) <- "ClevrDataset"
  value[['name']] <- name
  value[['image_directory']] <- image_dir
  value[['anns_file']] <- anns_file
  scenes <- fromJSON(file = anns_file)
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
                                   gt_cache = FALSE,
                                   proposal_file = NULL,
                                   min_proposal_size = 2,
                                   proposal_limit = -1,
                                   crowd_filter_thresh = 0)
{
  nimgs <- length(obj$scenes)
  entries <- list()
  #message('------------ images: ', nimgs)
  for(i in 1:nimgs)
  {
    entries[[i]] <- list(file_name = obj$scenes[[i]]$image_filename,
                      height = 320,
                      width = 480,
                      id = obj$scenes[[i]]$image_index)
  }

  for(i in 1:length(entries))
  {
    entries[[i]] <- proc_roidb_entry(obj, entries[[i]])
  }

  if (gt_cache)
  {
    gt_cache_path <- paste(obj$cache_path, paste0(obj$name, '_gt_roidb.pkl'), sep = '/')
    message('ground truth: ', gt_cache_path)
    if(file.exists(gt_cache_path))
    {
      entries <- add_gt_from_cache(obj, entries, gt_cache_path)
    }
    else
    {
      for(i in 1:length(entries))
      {
        entries[[i]] <- add_gt_annotations(obj, entries[[i]])
      }
    }
  }

  if(!is.null(proposal_file))
  {
    #add_proposals_from_file(obj,
    #                        proposal_file,
    #                        min_proposal_size,
    #                        proposal_limit,
    #                        crowd_filter_thresh)
    message('--------: ', proposal_file)
  }

  #roidb <- add_class_assignments(obj)
  return(obj)
}

proc_roidb_entry <- function(obj, entry) UseMethod('proc_roidb_entry', obj)
proc_roidb_entry.ClevrDataset <- function(obj, entry)
{
  # """Adds empty metadata fields to an roidb entry."""
  # Reference back to the parent dataset
  #entry['dataset'] = self
  # Make file_name an abs path

  im_path = paste(obj$image_directory, entry$file_name, sep = '/')
  if(!file.exists(im_path)) stop(sprintf('Image not found: %s', im_path))

  entry[['image']] <- im_path
  entry[['flipped']] <- FALSE
  entry[['has_visible_keypoints']] = FALSE
  # Empty placeholders
  entry[['boxes']] <- matrix(nrow = 0, ncol = 4)
  entry[['segms']] = list()
  entry[['gt_classes']] = vector(mode = 'numeric')
  entry[['seg_areas']] = vector(mode = 'numeric')
  #entry[['gt_overlaps']] = scipy.sparse.csr_matrix(
  #  np.empty((0, self.num_classes), dtype=np.float32)
  #)
  entry[['gt_overlaps']] <- matrix(nrow = 0, ncol = obj$num_classes)
  entry[['is_crowd']] = vector(mode = 'logical')
  # 'box_to_gt_ind_map': Shape is (#rois). Maps from each roi to the index
  # in the list of rois that satisfy np.where(entry['gt_classes'] > 0)
  entry[['box_to_gt_ind_map']] = vector(mode = 'logical')
  # Remove unwanted fields that come from the json file (if they exist)
  entry[['file_name']] <- NULL

  return(entry)
}

add_gt_from_cache <- function(obj, entries, gt_cache_path) UseMethod('add_gt_from_cache', obj, ...)
add_gt_fram_cache.ClevrDataset <- function(obj, entries, gt_cache_path)
{
  return(NULL)
}

add_gt_annotations <- function(obj, entry) UseMethod('add_gt_annotations', obj, ...)
add_gt_annotations.ClevrDataset <- function(obj, entry)
{
  print('---------------------- add_gt_annotations:')

  en_id <- entry[['id']] + 1
  en_objs <- obj$scenes[[en_id]][['objects']]

  valid_objs <- list()
  valid_segms <- list()
  width <- entry[['width']]
  height <- entry[['height']]

  for(en_obj in en_objs)
  {
    rle <- preprocess_rle(obj, en_obj[['mask']])
    mask <- decode_rle(rle)

    bbox <- rle_mask_to_boxes(as.list(rle))
  }

  return(NULL)
}

preprocess_rle <- function(obj, mask) UseMethod('preprocess_rle', obj, ...)
preprocess_rle.ClevrDataset <- function(obj, mask)
{
  print('------------- preprocess_rle:')

  mask_utils_decode(mask)

  return(mask)
}
