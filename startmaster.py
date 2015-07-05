# coding:utf8

import os
import json

from gevent import monkey

monkey.patch_os()

CONFIG_FILE = 'config.json'
DEFAULT_JSON = dict(server_name='local',
                    login_ip='127.0.0.1',
                    front_ip='127.0.0.1',
                    server_no='1')


if __name__ == "__main__":

    if os.path.exists('/tmp/excel_cpickle'):
        os.system("cp /tmp/excel_cpickle config/excel_cpickle")
    if os.path.exists('/tmp/server_list.json'):
        os.system("cp /tmp/server_list.json server_list.json")

    if os.path.exists('template.json'):
        template = open('template.json')
        str_template = template.read()
        if os.path.exists('my.json'):
            config = json.load(open('my.json'))
            replace_items = config.items()
        else:
            replace_items = DEFAULT_JSON.items()
        for k, v in replace_items:
            str_template = str_template.replace('<=%s=>' % k, v)

        fp = open('config.json', 'w')
        fp.write(str_template)
        fp.flush()
        fp.close()
    else:
        print 'can not find template.json'

    if not os.path.exists(CONFIG_FILE):
        print 'can not find config.json'
    else:
        from gfirefly.master.master import Master
        master = Master()
        master.config(CONFIG_FILE, 'appmain.py')
        master.start()
