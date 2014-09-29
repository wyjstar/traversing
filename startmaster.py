# coding:utf8

import os
import json
from gevent import monkey

monkey.patch_os()

if __name__ == "__main__":
    if os.path.exists('my.json') and os.path.exists('template.json'):
        config = json.load(open('my.json'))
        template = open('template.json')
        str_template = template.read()
        for k, v in config.items():
            str_template = str_template.replace('<=%s=>' % k, v)
            fp = open('myconfig.json', 'w')
            fp.write(str_template)
            fp.flush()
            fp.close()

    from gfirefly.master.master import Master
    master = Master()
    master.config('config.json', 'appmain.py')
    # master.start()