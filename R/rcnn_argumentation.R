#' read argument from command line
#' A Honolulu_White Function
#'
#' This function was written by a person with little experieces in R package generating from Honolulu.
#' @param params Are you a new guy? Defaults to TRUE.
#' @keywords params
#' @export
#' @examples
#' rebuild_params()

library(argparse)

config_path = system.file('data',  'config.yaml', package = 'vqar')

parse_args <- function()
{
    #"""Parse input arguments"""
    parser = argparse::ArgumentParser(description='Train a X-RCNN network')

    parser$add_argument(
           '--task', dest='step', required=TRUE,
           help='The step(task) of processing')
    parser$add_argument(
           '--dataset', dest='dataset', required=TRUE,
           help='Dataset to use')
    parser$add_argument(
        '--cfg', dest='cfg_file', required=FALSE,
        help='Config file for training (and optionally testing)')
    parser$add_argument(
        '--set', dest='set_cfgs',
        help=paste(c('Set config keys. Key value sequence seperate by whitespace,',
                     'e.g. [key] [value] [key] [value]'), sep = '\n'),
        default=NULL, nargs='+')

    parser$add_argument(
        '--disp_interval',
        help='Display training info every N iterations',
        default=20, type="integer")
    parser$add_argument(
             '--no_cuda', dest='cuda',
             help='Do not use CUDA device', action='store_false')

    # Optimization
    # These options has the highest prioity and can overwrite the values in config file
    # or values set by set_cfgs$ `None` means do not overwrite$
    parser$add_argument(
        '--bs', dest='batch_size',
        help='Explicitly specify to overwrite the value comed from cfg_file$',
        type="integer")
    parser$add_argument(
        '--nw', dest='num_workers',
        help='Explicitly specify to overwrite number of workers to load data$ Defaults to 4',
        type="integer")
    parser$add_argument(
        '--iter_size',
        help='Update once every iter_size steps, as in Caffe$',
        default=1, type="integer")

    parser$add_argument(
        '--o', dest='optimizer', help='Training optimizer$',
        default=NULL)
    parser$add_argument(
        '--lr', help='Base learning rate$',
        default=NULL, type="double")
    parser$add_argument(
        '--lr_decay_gamma',
        help='Learning rate decay rate$',
        default=NULL, type="double")

    # Epoch
    parser$add_argument(
        '--start_step',
        help='Starting step count for training epoch$ 0-indexed$',
        default=0, type="integer")

    # Resume training: requires same iterations per epoch
    parser$add_argument(
        '--resume',
        help='resume to training on a checkpoint',
        action='store_true')

    parser$add_argument(
        '--no_save', help='do not save anything', action='store_true')

    parser$add_argument(
        '--load_ckpt', help='checkpoint path to load', action = 'store_true')
    parser$add_argument(
        '--load_detectron', help='path to the detectron weight pickle file', action = 'store_false')

    parser$add_argument(
        '--use_tfboard', help='Use tensorflow tensorboard to log training info',
        action='store_true')

    # dataset options
    parser$add_argument(
        '--clevr_comp_cat',
        help='Use compositional categories for clevr dataset',
        default=1, type="integer")

    return(parser$parse_args())
}
