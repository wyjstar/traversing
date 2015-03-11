from app.gate.redis_mode import tb_character_info, tb_guild_info
from app.gate.core.virtual_character_manager import VCharacterManager
from gfirefly.server.globalobject import GlobalObject
from shared.utils import trie_tree
import re
import cPickle
from app.proto_file.db_pb2 import Stamina_DB

groot = GlobalObject().root


def modify_user_info(args):
    oldvcharacter = VCharacterManager().get_by_id(int(args.get('uid')))
    if oldvcharacter:
        args = (args.get('command'), oldvcharacter.dynamic_id,
                cPickle.dumps(args))
        child_node = groot.child(oldvcharacter.node)
        return child_node.callbackChild(*args)
    else:
        character_obj = tb_character_info.getObj(int(args.get('uid')))
        if not character_obj.exists():
            return {'success': 0, 'message': 1}

        if args['attr_name'] == 'user_level':
            data = {'level': int(args['attr_value'])}
            character_obj.hmset(data)
            return {'success': 1}
        elif args['attr_name'] == 'vip_level':
            data = {'vip_level': int(args['attr_value'])}
            character_obj.hmset(data)
            return {'success': 1}
        elif args['attr_name'] == 'user_exp':
            data = {'exp': int(args['attr_value'])}
            character_obj.hmset(data)
            return {'success': 1}
        elif args['attr_name'] == 'buy_stamina_times':
            stamina_data = character_obj.hget('stamina')
            stamina = Stamina_DB()
            stamina.ParseFromString(stamina_data)
            stamina.buy_stamina_times = int(args['attr_value'])
            data = {'stamina': stamina.SerializeToString()}
            character_obj.hmset(data)
            return {'success': 1}
        elif args['attr_name'] == 'stamina':
            finance = character_obj.hget('finances')
            finance[7] = int(args['attr_value'])
            data = {'finances': finance}
            character_obj.hmset(data)
            return {'success': 1}
        elif args['attr_name'] == 'nickname':
            nickname = args['attr_value']
            match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]', nickname)
            if match:
                return {'success': 0, 'message': 2}

            if trie_tree.check.replace_bad_word(nickname) != nickname:
                return {'success': 0, 'message': 2}

            nickname_obj = tb_character_info.getObj('nickname')
            result = nickname_obj.hsetnx(args['attr_value'], args['uid'])
            if result:
                data = {'nickname': args['attr_value']}
                character_obj.hmset(data)
                return {'success': 1}
            else:
                return {'success': 0, 'message': 0}
        else:
            return {'success': 0, 'message': 2}
