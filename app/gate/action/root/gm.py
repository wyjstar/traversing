from app.gate.redis_mode import tb_character_info, tb_guild_info
from app.gate.core.virtual_character_manager import VCharacterManager
from gfirefly.server.globalobject import GlobalObject
import cPickle

groot = GlobalObject().root


def modify_vip_level(args):
    print args
    pass


def modify_user_level(args):
    oldvcharacter = VCharacterManager().get_by_id(int(args.get('uid')))
    if oldvcharacter:
        args = (args.get('command'), oldvcharacter.dynamic_id,
                cPickle.dumps(args))
        child_node = groot.child(oldvcharacter.node)
        res = child_node.callbackChild(*args)
    else:
        data = {'vip_level': int(args['level'])}
        character_obj = tb_character_info.getObj(int(args.get('uid')))
        if not character_obj.exists():
            return {'success': 0, 'message': 1}
        character_obj.hmset(data)
        res = {'success': 1}
    return res
