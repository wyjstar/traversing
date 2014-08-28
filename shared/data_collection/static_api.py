# -*- coding:utf-8 -*-
"""
created by server on 14-8-27下午4:15.
"""

#coding=utf8
import datetime
import time
from django.conf import settings
from scribeutil import SCRIBE_AVAILABLE # 检查scribe是否可用
from scribeutil import ScribeClient

def scribesender(host, port, category_prefix=None):
    scribe_client = ScribeClient(host, port)

    def sender(data):
        today = time.strftime('%Y-%m-%d')
        category = category_prefix + '_' + today if category_prefix else today
        scribe_client.log(category, data)
    return sender

SCRIBE_SERVER = getattr(settings, 'SCRIBE_SERVER', '127.0.0.1')
SCRIBE_PORT = getattr(settings, 'SCRIBE_PORT', 8250)
CATEGORY_PREFIX = getattr(settings, 'CATEGORY_PREFIX', '')

if SCRIBE_AVAILABLE:   # 如果scribe可用，则创建scribe的通道
    output = scribesender(SCRIBE_SERVER, SCRIBE_PORT, CATEGORY_PREFIX)
else:
    output = None

formatter = ['uid', 'scene', 'level', 'stay', 'action', 'v1', 'v2', 'v3', 'v4', 'num'] # 日志标准格式

def write(request, mdata):
    '''
    写入接口
    data: {'action':'dsf', 'v1':34, 'v2':3, }
    '''
    if not output:
        print 'nooutput'
        return None
    try:
        rk_user = request.rk_user
        try:
            stay = (datetime.datetime.now() - rk_user.add_time).days +1
            stay = stay if stay < 4 else 0
        except:
            stay = 0

        try:
            action = mdata['action']
        except KeyError:
            print 'no action name specified...'
        data = {
                'uid':rk_user.uid,
                'scene':'k',
                'action':action,
                'level':rk_user.game_info.level,
                'stay':stay,
                'success':True,
                'num':1
                }
        data.update(mdata)
        delimiter = '\t'
        record = []
        for item in formatter:
            record.append(data.get(item, ''))
        log = delimiter.join(map(str, record))
        output(log)
    except Exception, e:
        print e

