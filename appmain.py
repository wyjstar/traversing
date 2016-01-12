# coding:utf8

from gevent import monkey
monkey.patch_all()
import gevent
import sys
import json
import code
import signal
import traceback
from gfirefly.server.server import FFServer
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger


def dump_stacks(signal, frame):
    logger.error('signal SIGUSR1 server dump')
    codes = []
    for threadId, stack in sys._current_frames().items():
        for filename, lineno, name, line in traceback.extract_stack(stack):
            codes.append('File: "%s", line %d, in %s' % (filename, lineno,
                                                         name))
            if line:
                codes.append("  %s" % (line.strip()))
    for line in codes:
        logger.error(line)


def print_stack(signal, frame):
    d = {'_frame': frame}  # Allow access to frame object.
    d.update(frame.f_globals)  # Unless shadowed by global
    d.update(frame.f_locals)

    i = code.InteractiveConsole(d)
    message = "Signal received : entering python shell.\nTraceback:\n"
    message += ''.join(traceback.format_stack(frame))
    i.interact(message)


if __name__ == "__main__":
    signal.signal(signal.SIGUSR1, print_stack)
    signal.signal(signal.SIGUSR2, dump_stacks)
    signal.signal(signal.SIGQUIT, gevent.kill)
    # signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    args = sys.argv
    servername = None
    config = None
    if len(args) > 2:
        servername = args[1]
        config = json.load(open(args[2], 'r'))
    else:
        raise ValueError
    dbconf = config.get('db')
    memconf = config.get('memcached')
    redis_conf = config.get('redis')
    sersconf = config.get('servers', {})
    masterconf = config.get('master', {})
    msdkconf = config.get('msdk', {})

    mconfig = json.load(open('models.json', 'r'))
    model_default_config = mconfig.get('model_default', {})
    model_config = mconfig.get('models', {})
    GlobalObject().allconfig = config

    serconfig = sersconf.get(servername)
    ser = FFServer()
    ser.config(serconfig,
               servername=servername,
               dbconfig=dbconf,
               memconfig=memconf,
               redis_config=redis_conf,
               masterconf=masterconf,
               model_default_config=model_default_config,
               model_config=model_config,
               msdk_config=msdkconf)
    ser.start()
