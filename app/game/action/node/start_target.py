# -*- coding:utf-8 -*-
"""
created by.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import start_target_pb2
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
import time
from shared.tlog import tlog_action
from app.game.core.activity import get_act_info


@remoteserviceHandle('gate')
def get_target_info_1826(data, player):
    """获取任务信息"""
    args = start_target_pb2.GetStartTargetInfoRequest()
    args.ParseFromString(data)
    # day = args.day  # 0为所有
    response = start_target_pb2.GetStartTargetInfoResponse()

    # 第几天登录
    day = player.base_info.login_day

    # 更新一下 登录奖励的状态
    # player.start_target.update_29()

    response.day = day
    # 需要查询的目标ID
    target_ids = {}
    if args.day:
        ids = []
        for a, b in game_configs.base_config.get('seven'+str(args.day)).items():
            ids += b
        target_ids[args.day] = ids
    else:
        for x in [1, 2, 3, 4, 5, 6, 7]:
            if x > day:
                continue
            ids = []
            for a, b in game_configs.base_config.get('seven'+str(x)).items():
                ids += b
            target_ids[x] = ids

    for _, ids in target_ids.items():
        for target_id in ids:
            if not player.act.is_activiy_open(target_id):
                continue

            logger.debug("target_id %s" % target_id)
            info = get_act_info(player, target_id)
            target_info_pro = response.start_target_info.add()
            target_info_pro.target_id = target_id
            if info.get('jindu'):
                target_info_pro.jindu = info.get('jindu')
            if info.get('state'):
                target_info_pro.state = info.get('state')

    player.act.save_data()

    logger.debug("response==========================start targe  %s" % response)
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_target_info_1827(data, player):
    """获取任务奖励"""
    args = start_target_pb2.GetStartTargetRewardRequest()
    args.ParseFromString(data)
    target_id = args.target_id
    response = start_target_pb2.GetStartTargetRewardResponse()

    if not player.act.is_activiy_open(target_id):
        response.res.result = False
        logger.error("start target dont open")
        response.res.result_no = 890  # 不在活动时间内
        return response.SerializeToString()
    # 第几天登录
    day = player.base_info.login_day

    target_ids = []
    for x in [1, 2, 3, 4, 5, 6, 7]:
        if x > day:
            continue
        for a, b in game_configs.base_config.get('seven'+str(x)).items():
            target_ids += b

    if target_id not in target_ids:
        response.res.result = False
        logger.error("this start target dont open")
        response.res.result_no = 800
        return response.SerializeToString()

    target_conf = game_configs.activity_config.get(target_id)

    info = get_act_info(player, target_id)
    if (target_conf.type != 30 and info.get('state') != 2) or (target_conf.type == 30 and info.get('state') == 3):
        response.res.result = False
        logger.error("this start target 条件不满足")
        response.res.result_no = 800
        return response.SerializeToString()

    need_gold = 0
    if target_conf.type == 30:
        need_gold = target_conf.parameterB

    def func():
        return_data = gain(player, target_conf.reward, const.START_TARGET)  # 获取
        get_return(player, return_data, response.gain)
        if target_conf.type == 30:
            if target_conf.count <= (info.get('jindu') + 1):
                player.act.act_infos[target_id] = [3, 0]
            else:
                player.act.act_infos[target_id] = [1, info.get('jindu') + 1]
        else:
            player.act.act_infos[target_id] = [3, 0]

        tlog_action.log('StartTargetGetGift', player, target_id)

    player.pay.pay(need_gold, const.START_TARGET, func)
    player.act.save_data()

    response.res.result = True
    return response.SerializeToString()
