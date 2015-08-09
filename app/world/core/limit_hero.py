# -*- coding:utf-8 -*-

from shared.db_opear.configs_data import game_configs
from gtwisted.core import reactor
from shared.utils.mail_helper import deal_mail
import time
from app.world.action.gateforwarding import limit_hero_obj
from shared.utils.ranking import Ranking
from gfirefly.server.globalobject import GlobalObject


childsmanager = GlobalObject().root.childsmanager


def send_reward(act_id):
    instance = Ranking.instance('LimitHeroRank')
    rank_info = instance.get(1, 9999)
    rank = 1
    for (p_id, integral) in rank_info:
        need_integral = game_configs.base_config. \
            get('CardTimeParticipateInAwards')
        if int(integral) < need_integral:
            break
        mail_id = get_mail_id(rank, act_id)
        mail_data, _ = deal_mail(conf_id=mail_id, receive_id=int(p_id))
        for child in childsmanager.childs.values():
            child.push_message_remote('receive_mail_remote', int(p_id), mail_data)
            break
        rank += 1


def get_mail_id(rank, act_id):
    reward_info = game_configs.base_config. \
        get('CardTimeActivity').get(act_id)
    for _, info in reward_info.items():
        if info[0] <= rank <= info[1]:
            return info[2]
    for _, info in reward_info.items():
        if not info[0]:
            return info[2]


def deal_end_act():
    send_reward(limit_hero_obj.act_id)
    limit_hero_obj.act_id = 0
    clear_rank()
    tick_limit_hero()


def clear_rank():
    instance = Ranking.instance('LimitHeroRank')
    instance.clear_rank()


def tick_limit_hero():
    act_data = get_activity_info()
    if not act_data['id']:
        return
    limit_hero_obj.act_id = act_data['id']
    need_time = int(act_data['end_time']-time.time())
    print need_time, 'limit hero end time ============'
    reactor.callLater(need_time, deal_end_act)


def get_activity_info():
    act_confs = game_configs.activity_config.get(17)
    activity_id = 0
    timeEnd = 0
    now = time.time()+1
    for act_conf in act_confs:
        if act_conf.timeStart <= now <= act_conf.timeEnd:
            activity_id = act_conf.id
            timeEnd = int(act_conf.timeEnd)
            break
    return {'id': activity_id, 'end_time': timeEnd}
