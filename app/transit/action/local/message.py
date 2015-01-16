# coding:utf8
"""
created by sphinx on
"""
from gfirefly.server.globalobject import rootserviceHandle, GlobalObject
from app.transit.root.messagecache import message_cache
from gfirefly.server.logobj import logger

groot = GlobalObject().root


@rootserviceHandle
def push_message_remote(key, character_id, *args):
    logger.debug("message.push_message_remote")
    logger.debug(args)
    childs = groot.childsmanager.childs
    for child in childs.values():
        if 'gate' in child.name:
            result = child.pull_message_remote(key, character_id, *args)
            if type(result) is bool and result:
                return

    message_cache.cache(key, character_id, *args)
    return True


@rootserviceHandle
def pull_message_remote(character_id):
    count = 0
    childs = groot.childsmanager.childs
    # print groot.childsmanager


    logger.debug("pull all message")
    for key, message in message_cache.get(character_id):
        args = (message.get('topic_id'), message.get('character_id'))
        args += message.get('args')
        kw = message.get('kw')
        logger.debug("args:%s", message.get('args'))
        logger.debug("message.pull_message_remote")

        for child in childs.values():
            if 'gate' in child.name:
                result = child.pull_message_remote(*args, **kw)
                logger.debug("result:%s", result)
                if type(result) is bool and result:
                    message_cache.delete(character_id, key)
                    count += 1
                    break
    return True
