from app.gate.redis_mode import tb_character_info, tb_guild_info
from app.gate.core.virtual_character_manager import VCharacterManager
from gfirefly.server.globalobject import GlobalObject
import cPickle
from app.gate.action.root import netforwarding
from app.proto_file.db_pb2 import Mail_PB

groot = GlobalObject().root


def get_user_info(args):
    print args
    character_obj = tb_character_info.getObj(args['uid'])
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    character_info = character_obj.hmget(['nickname', 'attackpoint',
                                          'heads', 'upgrade_time',
                                          'level', 'id', 'exp',
                                          'vip_level', 'register_time',
                                          'upgrade_time', 'guild_id',
                                          'position'])
    if character_info['guild_id'] == 'no':
        position = 0
        guild_name = ''
        guild_id = ''
    else:
        guild_id = character_info['guild_id']
        guild_obj = tb_guild_info.getObj()
        if guild_obj.exists():
            guild_info = guild_obj.hmget(['name'])
            positon = character_info['positon']
            guild_name = guild_info['name']
        else:
            position = 0
            guild_name = ''

    return {'success': 1,
            'message': {'uid': character_info['id'],
                        'nickname': character_info['nickname'],
                        'level': character_info['level'],
                        'exp': character_info['exp'],
                        'vip_level': character_info['vip_level'],
                        'register_time': character_info['register_time'],
                        'recently_login_time': character_info['upgrade_time'],
                        'guild_id': guild_id,
                        'guild_name': guild_name,
                        'position': position}}


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


def send_mail(args):
    print "======1=========1========1=========1====="
    #mail = Mail_PB()
    # mail.sender_id = player.base_info.id
    #mail.sender_name = player.base_info.base_name
    #mail.sender_icon = player.base_info.head
    #mail.receive_id = target_id
    #mail.receive_name = ''
    #mail.title = title
    #mail.content = content
    #mail.mail_type = MailComponent.TYPE_MESSAGE
    #mail.prize = ''
    #mail.send_time = int(time.time())
    #mail_data = mail.SerializePartialToString()

    #if args['uids'] == '0':
    #    for uid in []:
    #        netforwarding.push_message_remote('receive_mail_remote',
    #                                          uid, mail_data)
    #else:
    #    for uid in args['uids'].split(';'):
    #        netforwarding.push_message_remote('receive_mail_remote',
    #                                          int(uid), mail_data)
