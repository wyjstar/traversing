from gfirefly.utils.services import CommandService
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from app.gate.core.virtual_character_manager import VCharacterManager

remoteservice = CommandService('transitremote')
GlobalObject().remote['transit']._reference.addService(remoteservice)
groot = GlobalObject().root


@remoteserviceHandle('transit')
def pull_message_remote(key, character_id, args):
    logger.debug("netforwarding.pull_message_remote")
    oldvcharacter = VCharacterManager().get_by_id(character_id)
    if oldvcharacter:
        args = (key, oldvcharacter.dynamic_id, args)
        logger.debug(args)
        logger.debug(oldvcharacter.node)
        child_node = groot.child(oldvcharacter.node)
        result = child_node.callbackChild(*args)
        # print 'gate found character to pull message:', oldvcharacter.__dict__, args, result
        return result
    else:
        return False

