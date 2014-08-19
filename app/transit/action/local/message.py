"""
created by sphinx on 
"""
from gfirefly.server.globalobject import rootserviceHandle, GlobalObject
from app.transit.root.messagecache import message_cache


@rootserviceHandle
def push_message(topic_id, character_id, args, kw):
    print 'push message:::: topic id:%d character:%s args:%s, kw:%s' % \
          (topic_id, character_id, args, kw)

    message_cache.cache(topic_id, character_id, *args, **kw)

    print 'transit =============== push message', character_id
    return True


@rootserviceHandle
def pull_message(character_id):
    print 'transit pull message:', character_id
    count = 1
    for _ in message_cache.get(character_id):
        childs = GlobalObject().root.childsmanager.childs
        print GlobalObject().root.childsmanager

        for child in childs.keys():
            print 'pull message === child:%s, topic id:%d character:%s args:%s, kw:%s' % \
                  (child, _.get('topic_id'), _.get('character'), _.get('args'), _.get('_kw'))
            args = (_.get('topic_id'), _.get('character'))
            args += _.get('args')
            kw = _.get('_kw')
            print 'pull message =====', args, '*****', kw
            if GlobalObject().root.callChild(child, 100100, *args, **kw):
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
