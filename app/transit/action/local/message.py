"""
created by sphinx on 
"""
from gfirefly.server.globalobject import rootserviceHandle, GlobalObject
from app.transit.root.messagecache import message_cache


@rootserviceHandle
def push_message(topic_id, character_id, *args, **kw):
    message_cache.cache(topic_id, character_id, args, kw)
    print 'transit =============== push message', character_id
    return True


@rootserviceHandle
def pull_message(character_id, *args, **kw):
    print 'transit pull message:', character_id
    count = 1
    for _ in message_cache.get(character_id):
        childs = GlobalObject().root.childsmanager.childs
        print GlobalObject().root.childsmanager
        for child in childs.keys():
            print 'child'*6, child
            if GlobalObject().root.callChild(child, 100100, _.get('topic_id'),
                                             _.get('character'), _.get('args'), _.get('_kw')):
            # if child.get_remote().callRemoteForResult('send_message_to_character',
            #                                           _.get('topic_id'),
            #                                           _.get('character'),
            #                                           _.get('args'),
            #                                           _.get('_kw')):
                message_cache.delete(_.get('topic_id'), _.get('character_id'))
                break
        count += 1
    print 'pull message:', count
    return True
