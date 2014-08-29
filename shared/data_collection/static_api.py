# -*- coding:utf-8 -*-
"""
created by server on 14-8-27下午4:15.
"""
import time
from scribeutil import SCRIBE_AVAILABLE # 检查scribe是否可用
from scribeutil import ScribeClient

def scribesender(host, port, category_prefix=None):
    scribe_client = ScribeClient(host, port)

    def sender(data):
        today = time.strftime('%Y-%m-%d')
        category = category_prefix + '_' + today if category_prefix else today

        print 'category<--->:', category, data

        scribe_client.log(category, data)
    return sender

SCRIBE_SERVER = getattr({}, 'SCRIBE_SERVER', '127.0.0.1')
SCRIBE_PORT = getattr({}, 'SCRIBE_PORT', 1463)
CATEGORY_PREFIX = getattr({}, 'CATEGORY_PREFIX', '')

if SCRIBE_AVAILABLE:   # 如果scribe可用，则创建scribe的通道
    output = scribesender(SCRIBE_SERVER, SCRIBE_PORT, CATEGORY_PREFIX)
    print 'output:', output
else:
    output = None

formatter = ['uid', 'scene', 'level', 'stay', 'action', 'v1', 'v2', 'v3', 'v4', 'num'] # 日志标准格式

def write(player=None, mdata={'v1': 34, 'v2': 3}):
    '''
    写入接口
    data: {'action':'dsf', 'v1':34, 'v2':3, }
    '''

    print 'scribe start:'

    if not output:
        print 'nooutput'
        return None
    try:

        # try:
        #     stay = (datetime.datetime.now() - rk_user.add_time).days +1
        #     stay = stay if stay < 4 else 0
        # except:
        #     stay = 0
        #
        # try:
        #     action = mdata['action']
        # except KeyError:
        #     print 'no action name specified...'
        data = {
                'uid':1,
                'scene':2,
                'action':3,
                'level':4,
                'stay':5,
                'success':True,
                'num':1
                }
        data.update(mdata)
        delimiter = '\t'
        record = []
        for item in formatter:
            record.append(data.get(item, ''))
        log = delimiter.join(map(str, record))

        print 'write log:', log

        output(log)

        print 'scribe end'
    except Exception, e:
        print e

