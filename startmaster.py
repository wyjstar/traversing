# coding:utf8

import os
import json

from gevent import monkey
import urllib
import traceback

monkey.patch_all()

CONFIG_FILE = 'config.json'
DEFAULT_JSON = dict(server_name='local',
                    login_ip='127.0.0.1',
                    front_ip='127.0.0.1',
                    server_no='1',
                    open_time='2016-01-01 12:00:00')

if __name__ == "__main__":

    if not os.path.exists('app/logs'):
        os.system("mkdir app/logs")

    try:
        f = urllib.urlopen("http://127.0.0.1:2600/GameInfo/GetConfigUrl")
        url = f.readlines()[0]
        res = urllib.urlretrieve(url, '/tmp/config.zip')
        # print res
        print("update_excell=========")
        os.system("cd /tmp; unzip -o config.zip")
        os.system("cp /tmp/excel_cpickle config/excel_cpickle")
        os.system(
            "cp -r /tmp/lua/. app/battle/src/app/datacenter/template/config/")

    except Exception, e:
        print("gm is not running! so copy lua/ from local.")
        print traceback.format_exc()
        os.system(
            "cp -r config/lua/* app/battle/src/app/datacenter/template/config/")

    # if os.path.exists('/tmp/excel_cpickle'):
    #     os.system("cp /tmp/excel_cpickle config/excel_cpickle")
    #     os.system("cp -r /tmp/lua/. app/battle/src/app/datacenter/template/config/")

    # import sys
    # print(sys.exit())

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
