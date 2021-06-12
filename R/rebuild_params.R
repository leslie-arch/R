# read argument from command line
#' A Honolulu_White Function
#'
#' This function was written by a person with little experieces in R package generating from Honolulu.
#' @param params Are you a new guy? Defaults to TRUE.
#' @keywords params
#' @export
#' @examples
#' rebuild_params()

rebuild_params <- function(params)
{
  parser <- ArgumentParser(description='Set training modules and configs')
  # positional parameter
  #parser$add_argument('integers', metavar='N', type="integer", nargs='+',
  #                                          help='an integer for the accumulator')
  parser$add_argument('-m', '--model', dest='model', action='store',
                      default='vgg1r86',
                      help='sum the integers (default: find the max)')
  parser$add_argument('-d', '--dataset', dest='dataset', action='store',
                      default='mscoco',
                      help='dataset name, find file path depends on dataset name')
  #group1 = parser$add_argument_group('group1', 'group1 description')
  #group1$add_argument('foo', help='foo help')

  args <- parser$parse_args(params)
  return(args)
}
