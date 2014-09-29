# -*- coding:utf-8 -*-
"""
created by server on 14-8-15下午5:30.
"""
from app.game.logic.common.check import have_player
from shared.db_opear.configs_data.game_configs import activity_config
from app.game.logic.item_group_helper import gain, get_return


@have_player
def init_login_gift(dynamicid, **kwargs):
    """
    获取登录活动信息
    """
    player = kwargs.get('player')
    return player.login_gift.cumulative_received, player.login_gift.continuous_received,\
        player.login_gift.cumulative_day, player.login_gift.continuous_day


@have_player
def get_login_gift(dynamicid, activity_id, activity_type, response, **kwargs):
    """
    领取登录奖励
    """
    player = kwargs.get('player')
    if activity_type == 1:  # 累积登录
        if player.login_gift.cumulative_received.count(activity_id) == 0:  # 未领取
            if player.login_gift.cumulative_day[1]:  # 是新手活动
                res = False
                err_no = 800
                for i in activity_config.get(1):
                    if i.get('id') == activity_id:
                        if i.get('parameterA') <= player.login_gift.cumulative_day[0]:
                            player.login_gift.cumulative_received.append(activity_id)
                            gain_data = i['reward']
                            return_data = gain(player, gain_data)
                            get_return(player, return_data, response.gain)
                            res = True
                            err_no = 0
                        else:
                            res = False
                            err_no = 802  # 条件没有达到

            else:  # 未知错误,不是新手活动的情况，目前代码不应该走这里
                res = False
                err_no = 800
        else:
            res = False
            err_no = 801  # 已经领取过
    else:  # 连续登录奖励
        if player.login_gift.continuous_received.count(activity_id) == 0:  # 未领取
            if player.login_gift.continuous_day[1]:  # 是新手活动
                res = False
                err_no = 800
                for i in activity_config.get(2):
                    if i.get('id') == activity_id:
                        if i.get('parameterA') <= player.login_gift.continuous_day[0]:
                            player.login_gift.continuous_received.append(activity_id)
                            gain_data = i['reward']
                            return_data = gain(player, gain_data)
                            get_return(player, return_data, response.gain)
                            res = True
                            err_no = 0
                        else:
                            res = False
                            err_no = 802  # 条件没有达到

            else:  # 未知错误,不是新手活动的情况，目前代码不应该走这里
                res = False
                err_no = 800
        else:
            res = False
            err_no = 801  # 已经领取过
    player.login_gift.save_data()
    return res, err_no


