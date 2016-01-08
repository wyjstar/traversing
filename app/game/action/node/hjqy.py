# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from app.proto_file.common_pb2 import CommonResponse
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import hjqy_pb2
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.game.action.node._fight_start_logic import get_seeds
from shared.utils.date_util import is_in_period, is_next_day, get_current_timestamp
import cPickle
from app.game.core.task import hook_task, CONDITIONId
from app.game.core.mail_helper import send_mail
from app.game.core.activity import target_update
from shared.tlog import tlog_action

remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def init_2101(pro_data, player):
    """获取hjqy信息
    """
    request = hjqy_pb2.HjqyInitRequest()
    request.ParseFromString(pro_data)

    response = hjqy_pb2.HjqyInitResponse()
    friend_ids = player.friends.friends
    data = remote_gate['world'].hjqy_init_remote(player.base_info.id, friend_ids)
    logger.debug("return data %s" % data)
    for boss_data in data.values():
        if (request.owner_id and request.owner_id == boss_data.get("player_id")) or (not request.owner_id):
            construct_boss_pb(boss_data, response)

    response.damage_hp = remote_gate['world'].hjqy_damage_hp_remote(player.base_info.id)
    response.rank = remote_gate['world'].hjqy_rank_remote(player.base_info.id)

    if is_next_day(get_current_timestamp(), player.hjqy_component.last_time):
        player.hjqy_component.received_ids = []
        player.hjqy_component.last_time = get_current_timestamp()
        player.hjqy_component.save_data()

    for temp in player.hjqy_component.received_ids:
        response.hjqy_ids.append(temp)

    return response.SerializeToString()

def construct_boss_pb(data, response):
    """docstring for construct_boss_pb"""
    boss_pb = response.bosses.add()
    boss_pb.player_id = data.get("player_id")
    boss_pb.nickname = data.get("nickname")
    boss_pb.stage_id = data.get("stage_id")
    boss_pb.is_share = data.get("is_share")
    boss_pb.trigger_time = data.get("trigger_time")
    boss_pb.hp_max = data.get("hp_max")
    boss_pb.hp_left = data.get("hp_left")
    #boss_pb.damage_hp = data.get("damage_hp")
    boss_pb.state = data.get("state")


    #required int32 player_id = 1;     // 触发boss的玩家id
    #required int32 stage_id = 4;      // 关卡id
    #required bool is_share = 3;       // 是否分享给好友
    #optional bool open_or_not = 8;    // 是否开启, no:上面参数有效，yes：下面参数有效
    #optional int32 hp_left = 9;       // 剩余血量
    #optional int32 demage_hp = 10;    // 伤害
    #optional int32 rank_no = 11;      // 名次
    #optional int32 fight_times = 12;  // 战斗次数
    #optional int32 hp_max = 13;       // boss最大血量
    #optional int32 trigger_time = 14; // 触发时间

@remoteserviceHandle('gate')
def share_2102(pro_data, player):
    """分享hjqy, 广播协议号2112
    """
    response = CommonResponse()
    result = remote_gate['world'].share_hjqy_remote(player.base_info.id)
    friend_ids = player.friends.friends
    boss_info = remote_gate['world'].get_boss_info_remote(player.base_info.id)
    for fid in friend_ids:
        send_mail(conf_id=512, receive_id=fid, nickname=player.base_info.base_name, boss_id=boss_info.get('stage_id'))

    #remote_gate.push_object_remote(2112, '', friend_ids)
    response.result = result
    return response.SerializeToString()



@remoteserviceHandle('gate')
def battle_2103(pro_data, player):
    """
    开始战斗
    request:HjqyBattleRequest
    response:HjqyBattleResponse
    """
    request = hjqy_pb2.HjqyBattleRequest()
    request.ParseFromString(pro_data)
    response = hjqy_pb2.HjqyBattleResponse()

    if player.base_info.is_firstday_from_register(const.OPEN_FEATURE_HJQY):
        response.res.result = False
        response.res.result_no = 150901
        return response.SerializeToString()
    boss_id = request.owner_id
    attack_type = request.attack_type # 全力一击，普通攻击
    logger.debug("request %s" % request)

    hjqyExchangeBUFFTime = game_configs.base_config.get("hjqyExchangeBUFFTime")
    hjqyItemRate = game_configs.base_config.get("hjqyItemRate")

    hjqyExchangeBUFFNumber = game_configs.base_config.get("hjqyExchangeBUFFNumber")
    hjqyExchangeNumber = game_configs.base_config.get("hjqyExchangeNumber")
    need_hjqy_fight_token = hjqyExchangeNumber
    if attack_type == 2:
        need_hjqy_fight_token = hjqyExchangeBUFFNumber
    if is_in_period(hjqyExchangeBUFFTime) and attack_type == 2:
        need_hjqy_fight_token = need_hjqy_fight_token * hjqyItemRate

    if need_hjqy_fight_token > player.finance[const.HJQYFIGHTTOKEN]:
        logger.error("hjqy coin not enough！")
        response.res.result = False
        response.res.result_no = 210301
        return response.SerializePartialToString()

    data = remote_gate['world'].get_boss_info_remote(boss_id)

    if not data or data.get('state') == const.BOSS_DEAD:
        logger.error("hjqy boss dead！")
        response.res.result = False
        response.res.result_no = 210302
        return response.SerializePartialToString()
    if data.get('state') == const.BOSS_RUN_AWAY:
        logger.error("hjqy boss run away！")
        response.res.result = False
        response.res.result_no = 210303
        return response.SerializePartialToString()


    stage_id = data.get("stage_id")
    player.fight_cache_component.stage_id = stage_id
    red_units = player.fight_cache_component.get_red_units()

    blue_units = cPickle.loads(remote_gate['world'].blue_units_remote(boss_id))

    seed1, seed2 = get_seeds()
    player_info = dict(player_id=player.base_info.id,
            nickname=player.base_info.base_name,
            user_icon=player.base_info.heads.now_head,
            level=player.base_info.level)

    str_red_units = cPickle.dumps(red_units)
    red_unpar_data = player.line_up_component.get_red_unpar_data()
    fight_result, boss_state, current_damage_hp, is_kill = remote_gate['world'].hjqy_battle_remote(player_info, boss_id, str_red_units, red_unpar_data, attack_type, seed1, seed2)

    logger.debug("============battle over")

    # 消耗讨伐令
    player.finance.consume(const.HJQYFIGHTTOKEN, need_hjqy_fight_token, const.HJQY_BATTLE)

    # 功勋奖励
    hjqyMeritoriousServiceOpenTime = game_configs.base_config.get("hjqyMeritoriousServiceOpenTime")
    hjqyMeritoriousServiceRate = game_configs.base_config.get("hjqyMeritoriousServiceRate")
    meritorious_service = player.fight_cache_component._get_stage_config().meritorious_service
    logger.debug("========= %s %s ========"%(is_in_period(hjqyMeritoriousServiceOpenTime), hjqyMeritoriousServiceOpenTime ))
    if is_in_period(hjqyMeritoriousServiceOpenTime):  # 增加功勋的活动
        meritorious_service = meritorious_service * hjqyMeritoriousServiceRate
    player.finance.add(const.HJQYCOIN, meritorious_service, reason=const.HJQY_BATTLE)
    player.finance.save_data()

    response.fight_result = fight_result
    pvp_assemble_units(red_units, blue_units, response)
    response.seed1 = seed1
    response.seed2 = seed2
    response.attack_type = attack_type
    response.hjqy_coin = meritorious_service
    response.stage_id = stage_id
    response.res.result = True

    hook_task(player, CONDITIONId.HJQY, 1)

    tlog_action.log('BattleHJQY', player, boss_id, is_kill)

    # start target
    all_current_damage_hp = remote_gate['world'].\
        hjqy_damage_hp_remote(player.base_info.id)
    player.act.condition_update(38, current_damage_hp)
    player.act.condition_update(39, all_current_damage_hp)
    # 更新 七日奖励
    target_update(player, [38, 39])

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def add_reward_2104(pro_data, player):
    """
    获取累积奖励
    request:HjqyAddRewardRequest
    response:HjqyAddRewardResponse
    """
    # 检查是否可领取
    request = hjqy_pb2.HjqyAddRewardRequest()
    request.ParseFromString(pro_data)
    response = hjqy_pb2.HjqyAddRewardResponse()

    damage_hp = remote_gate['world'].hjqy_damage_hp_remote(player.base_info.id)
    hjqy_info = game_configs.hjqy_config.get(request.id)

    if hjqy_info.output_requirements > damage_hp:
        logger.debug("damage_hp is not enough!")
        response.res.result = False
        response.res.result_no = 21041
        return response.SerializePartialToString()

    # 检查奖励是否被领取
    if request.id in player.hjqy_component.received_ids:
        logger.debug("has got the reward!")
        response.res.result = False
        response.res.result_no = 21042
        return response.SerializePartialToString()

    # 掉落
    data = gain(player, hjqy_info.get("rewards"), const.HJQY_ADD_REWARD)
    get_return(player, data, response.gain)

    # 保存已经获取的id
    player.hjqy_component.received_ids.append(request.id)
    player.hjqy_component.save_data()
    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def get_rank_2105(pro_data, player):
    """
    获取排名:HjqyRankResponse
    """
    response = hjqy_pb2.HjqyRankResponse()
    rank_infos = remote_gate['world'].get_hjqy_rank_remote()
    for info in rank_infos:
        info_pb = response.info.add()
        info_pb.id = info.get("player_id")
        info_pb.nickname = info.get("nickname")
        info_pb.user_icon = info.get("user_icon")
        info_pb.level = info.get("level")
        info_pb.damage_hp = info.get("damage_hp")
        info_pb.rank = info.get("rank")

    return response.SerializePartialToString()
