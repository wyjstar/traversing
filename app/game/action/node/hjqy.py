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
from app.game.action.node._fight_start_logic import pvp_process
from app.game.action.node._fight_start_logic import get_seeds
from shared.utils.date_util import is_in_period

remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def init_2101(pro_data, player):
    """获取hjqy信息
    """
    response = hjqy_pb2.HjqyInitResponse()
    friend_ids = player.friends.friends + [player.base_info.id]
    return_data = remote_gate['world'].hjqy_init_remote(friend_ids)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def share_2102(pro_data, player):
    """分享hjqy, 广播协议号2112
    """
    response = CommonResponse()
    result = remote_gate['world'].share_hjqy_remote(player.base_info.id)
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

    line_up = request.line_up
    attack_type = request.attack_type # 全力一击，普通攻击

    hjqyExchangeBUFFTime = game_configs.base_config.get("hjqyExchangeBUFFTime")
    hjqyItemRate = game_configs.base_config.get("hjqyItemRate")

    need_hjqy_coin = 1
    if attack_type == 2:
        need_hjqy_coin = 2
    if is_in_period(hjqyExchangeBUFFTime) and attack_type == 2:
        need_hjqy_coin = need_hjqy_coin * hjqyItemRate

    if need_hjqy_coin > player.finance[const.HJQYCOIN]:
        logger.error("hjqy coin not enough！")
        response.res.result = False
        response.res.result_no = 21031
        return response.SerializePartialToString()


    __skill = request.skill
    __best_skill, __skill_level = player.line_up_component.get_skill_info_by_unpar(__skill)

    player.fight_cache_component.stage_id = request.stage_id
    red_units, blue_units, drop_num, monster_unpara = player.fight_cache_component.fighting_start()
    seed1, seed2 = get_seeds()
    fight_result = pvp_process(player, line_up, red_units, blue_units,
                               __best_skill, monster_unpara, 1,
                               __skill, seed1, seed2,
                               const.BATTLE_HJQY_PVP)
    fight_result = remote_gate['world'].hjqy_battle_remote(player.base_info.id)

    # 消耗讨伐令
    player.finance.consume(const.FIGHTTOKEN, need_hjqy_coin)

    response.fight_result = fight_result
    response.res.result = True
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


