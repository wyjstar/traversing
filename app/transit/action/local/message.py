"""
created by sphinx on 
"""
from gfirefly.server.globalobject import rootserviceHandle, GlobalObject
from app.transit.root.messagecache import message_cache


@rootserviceHandle
def push_message(topic_id, character_id, args, kw):
    message_cache.cache(topic_id, character_id, *args, **kw)
    return True


@rootserviceHandle
def pull_message(character_id):
    print 'transit pull message:', character_id
    count = 0
    for message in message_cache.get(character_id):
        childs = GlobalObject().root.childsmanager.childs
        # print GlobalObject().root.childsmanager

        for child in childs.keys():
            args = (message.get('topic_id'), message.get('character_id'))
            args += message.get('args')
            kw = message.get('kw')
            print 'pull message =====', args, '*****', kw
            result = GlobalObject().root.callChild(child, 100001, *args, **kw)
            if type(result) is bool and result:
                print 'delete message'
                message_cache.delete(message.get('topic_id'), character_id)
                count += 1
                break
    print 'pull message:', count
    return True
