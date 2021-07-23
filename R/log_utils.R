library(rjson)
library(logging)


log_json_stats <- function(stats)
{
    loginfo('json_stats: {%s}', toJSON(stats))
}

log_stats <- function(stats, misc_args)
{
    # Log training statistics to terminal
    if ('epoch' %in% names(misc_args))
    {

        lines <- sprintf("[%s][%s][Epoch %d][Iter %d / %d]\n", 
            misc_args$run_name, misc_args$cfg_filename,
            misc_args$epoch, misc_args$step, misc_args$iters_per_epoch)
    }
    else
    {
      lines <- sprintf("[%s][%s][Step %d / %d]\n",
                       misc_args$run_name, misc_args$cfg_filename, stats['iter'], cfg['SOLVER']['MAX_ITER'])

    }

    lines <- paste0(lines, sprintf("\t\t loss: %.6f, lr: %.6f time: %.6f, eta: %s\n",
                                   stats['loss'], stats['lr'], stats['time'], stats['eta']))

    #if stats['metrics']:
    #    lines += "\t\t" + ", ".join("%s: %.6f" % (k, v) for k, v in stats['metrics'].items()) + "\n"

    #if stats['head_losses']:
    #    lines += "\t\t" + ", ".join("%s: %.6f" % (k, v) for k, v in stats['head_losses'].items()) + "\n"
    #if cfg.RPN.RPN_ON:
    #    lines += "\t\t" + ", ".join("%s: %.6f" % (k, v) for k, v in stats['rpn_losses'].items()) + "\n"
    #if cfg.FPN.FPN_ON:
    #    lines += "\t\t" + ", ".join("%s: %.6f" % (k, v) for k, v in stats['rpn_fpn_cls_losses'].items()) + "\n"
    #    lines += "\t\t" + ", ".join("%s: %.6f" % (k, v) for k, v in stats['rpn_fpn_bbox_losses'].items()) + "\n"
    print(lines)
}

#class SmoothedValue(object):
#    """Track a series of values and provide access to smoothed values over a
#    window or the global series average.
#    """
#
#    def __init__(self, window_size):
#        self.deque = deque(maxlen=window_size)
#        self.series = []
#        self.total = 0.0
#        self.count = 0
#
#    def AddValue(self, value):
#        self.deque.append(value)
#        self.series.append(value)
#        self.count += 1
#        self.total += value
#
#    def GetMedianValue(self):
#        return np.median(self.deque)
#
#    def GetAverageValue(self):
#        return np.mean(self.deque)
#
#    def GetGlobalAverageValue(self):
#        return self.total / self.count
#
#
#def send_email(subject, body, to):
#    s = smtplib.SMTP('localhost')
#    mime = MIMEText(body)
#    mime['Subject'] = subject
#    mime['To'] = to
#    s.sendmail('detectron', to, mime.as_string())
#
#
setup_logging <- function(name)
{
    # FORMAT = '%(levelname)s %(filename)s:%(lineno)4d: %(message)s'
    # Manually clear root loggers to prevent any module that may have called
    # logging.basicConfig() from blocking our logging setup

    logging::logReset()
    logging::basicConfig(level = 20)
    
    logger = logging::getLogger(name)
    return(logger)
}

