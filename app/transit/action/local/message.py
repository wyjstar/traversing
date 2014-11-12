# coding:utf8
"""
created by sphinx on
"""
from gfirefly.server.globalobject import rootserviceHandle, GlobalObject
from app.transit.root.messagecache import message_cache

groot = GlobalObject().root


@rootserviceHandle
def push_message(key, character_id, args, kw):
    message_cache.cache(key, character_id, *args, **kw)
    return True


@rootserviceHandle
def pull_message(character_id):
    count = 0
    for key, message in message_cache.get(character_id):
        childs = groot.childsmanager.childs
        # print groot.childsmanager

        args = (message.get('topic_id'), message.get('character_id'))
        args += message.get('args')
        kw = message.get('kw')

        for child in childs.values():
            if 'gate' in child.name:
                result = groot.callChild(child.id,
                                         'pull_message',
                                         *args, **kw)
                if type(result) is bool and result:
                    message_cache.delete(character_id, key)
                    count += 1
                    break
    return True
