# -*- coding:utf-8 -*-
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.item_group_helper import gain, get_return
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data import game_configs
import time
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import get_consume_gold_num
from app.game.core.item_group_helper import do_get_draw_drop_bag
from app.proto_file.limit_hero_pb2 import *
from app.game.core import rank_helper
from gfirefly.server.logobj import logger
from shared.utils.const import const
from app.game.redis_mode import tb_character_info
from app.game.action.root import netforwarding


@remoteserviceHandle('gate')
def get_limit_hero_info_1812(data, player):

    response = GetLimitHeroInfoResponse()
    activity_id = netforwarding.get_activity_id()
    response.activity_id = activity_id

    if not activity_id:
        response.res.result = False
        response.res.result_no = 864
        logger.debug(response)
        return response.SerializeToString()

    player.limit_hero.update(activity_id)
    response.free_time = player.limit_hero.free_time
    response.draw_times = player.limit_hero.draw_times
    deal_response(player, response)

    integral = rank_helper.get_value('LimitHeroRank',
                                     player.base_info.id)
    if not int(integral):
        integral = 0
    else:
        integral = int(integral)
    response.integral = int(integral)
    response.integral_draw_times = player.limit_hero.integral_draw_times

    response.res.result = True
    logger.debug(response)
    return response.SerializeToString()


def deal_response(player, response):
    rank_no = rank_helper.get_rank_by_key('LimitHeroRank',
                                          player.base_info.id)
    response.rank = rank_no
    rank_info = rank_helper.get_rank('LimitHeroRank', 1, 10)
    rank = 1
    for (p_id, integral) in rank_info:
        nickname = tb_character_info.getObj(p_id).\
            hget('nickname')
        limit_rank = response.limit_rank.add()
        limit_rank.rank = rank
        limit_rank.integral = int(integral)
        limit_rank.nickname = nickname
        rank += 1


@remoteserviceHandle('gate')
def draw_1813(data, player):
    """draw"""
    args = LimitHeroDrawRequest()
    args.ParseFromString(data)
    response = LimitHeroDrawResponse()
    draw_type = args.draw_type
    need_gold = 0
    draw_flag = 1  # 免费，积分，元宝

    free_time_conf = game_configs.base_config.get('CardTimeLimitFreeCountdown') \
        * 60 * 60
    integral = int(rank_helper.get_value('LimitHeroRank',
                                         player.base_info.id))

    activity_id = netforwarding.get_activity_id()
    if not activity_id:
        response.res.result = False
        response.res.result_no = 864
        # logger.debug(response)
        return response.SerializeToString()

    player.limit_hero.update(activity_id)

    act_conf = game_configs.activity_config.get(activity_id)
    shop_id = game_configs.base_config.get('CardTimeActivityShop')
    shop_conf = game_configs.shop_config.get(shop_id[activity_id])
    if draw_type == 1 and \
            time.time() < free_time_conf + player.limit_hero.free_time:
        response.res.result = False
        response.res.result_no = 889
        # logger.debug(response)
        return response.SerializeToString()
    elif draw_type == 2:  # 元宝
        need_integral = game_configs.base_config.get('CardTimeLimit')
        times = integral/need_integral-player.limit_hero.integral_draw_times
        if times:
            draw_flag = 2
        else:
            result = is_afford(player, shop_conf.consume)  # 校验
            if not result.get('result'):
                response.res.result = False
                response.res.result_no = 888
                return response.SerializePartialToString()
            need_gold = get_consume_gold_num(shop_conf.consume)
            draw_flag = 3

    def func():
        not_luck_times = (player.limit_hero.draw_times+1) % \
            game_configs.base_config.get('CardTimeCumulateTimes')
        if not_luck_times:
            pseudo_bag_id = act_conf.reward[0].item_no
            drop = do_get_draw_drop_bag(pseudo_bag_id,
                                        player.limit_hero.draw_times+1)
        else:
            drop = game_configs.base_config.get('CardTimeCumulate')

        return_data = gain(player, drop, const.LIMIT_HERO)
        get_return(player, return_data, response.gain)

        player.limit_hero.draw_times += 1
        if draw_flag == 1:
            free_time = int(time.time())
            player.limit_hero.free_time = free_time
            response.free_time = free_time
        elif draw_flag == 2:
            player.limit_hero.integral_draw_times += 1
        # else:
        add_integral = shop_conf.Integral[0].num
        rank_integral = integral + add_integral + 1 - time.time()/10000000000
        rank_helper.add_rank_info('LimitHeroRank',
                                  player.base_info.id, rank_integral)
        player.limit_hero.save_data()
        deal_response(player, response)

    player.pay.pay(need_gold, const.LIMIT_HERO, func)

    response.res.result = True
    # logger.debug(response)
    return response.SerializeToString()
