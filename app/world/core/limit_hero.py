# -*- coding:utf-8 -*-

from shared.db_opear.configs_data import game_configs
from gtwisted.core import reactor
from shared.utils.mail_helper import deal_mail
import time
from app.world.action.gateforwarding import limit_hero_obj
from shared.utils.ranking import Ranking
from gfirefly.server.globalobject import GlobalObject
from shared.time_event_manager.te_manager import te_manager
from shared.common_logic.activity import do_get_act_open_info


childsmanager = GlobalObject().root.childsmanager


def send_reward(act_id):
    instance = Ranking.instance('LimitHeroRank')
    rank_info = instance.get(1, 9999)
    rank = 0
    for (p_id, integral) in rank_info:
        rank += 1
        need_integral = game_configs.base_config. \
            get('CardTimeParticipateInAwards')

        mail_id = get_mail_id(rank, act_id)
        if mail_id:
            mail_data, _ = deal_mail(conf_id=mail_id, receive_id=int(p_id),
                                     rank=rank, integral=int(integral))
            for child in childsmanager.childs.values():
                child.push_message_remote('receive_mail_remote', int(p_id),
                                          mail_data)
                break

        need_integral = game_configs.base_config. \
            get('CardTimeParticipateInAwards')
        mail_id = game_configs.base_config. \
            get('CardTimeActivity2').get(act_id)[0]
        if int(integral) < need_integral:
            continue
        mail_data, _ = deal_mail(conf_id=mail_id, receive_id=int(p_id))
        for child in childsmanager.childs.values():
            child.push_message_remote('receive_mail_remote', int(p_id),
                                      mail_data)
            break


def get_mail_id(rank, act_id):
    mail_id = 0
    reward_info = game_configs.base_config. \
        get('CardTimeActivity').get(act_id)
    for _, info in reward_info.items():
        if info[0] <= rank <= info[1]:
            mail_id = info[2]
            break
    return mail_id


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
    if act_data['end_time']:
        limit_hero_obj.act_id = act_data['id']
        # need_time = int(act_data['end_time']-time.time())
        print act_data['end_time'], 'limit hero end time ============'
        te_manager.add_event(act_data['end_time'], 1, deal_end_act)
        # reactor.callLater(need_time, deal_end_act)
        return
    if act_data['start_time']:
        # need_time = int(act_data['start_time']-time.time())
        print act_data['start_time'], 'limit hero start time ============'
        te_manager.add_event(act_data['start_time'], 1, tick_limit_hero)
        # reactor.callLater(need_time, tick_limit_hero)


def get_activity_info():
    act_confs = game_configs.activity_config.get(17, [])
    activity_id = 0
    timeEnd = 0
    timeStart = 0
    now = time.time()
    for act_conf in act_confs:
        act_time_info = do_get_act_open_info(act_conf.id)
        if act_time_info.get('time_end') <= now:
            continue
        if act_time_info.get('is_open'):
            activity_id = act_conf.id
            timeStart = act_time_info.get('time_start')
            timeEnd = act_time_info.get('time_end')
            break
        if act_time_info.get('time_start') > now:
            if not activity_id:
                activity_id = act_conf.id
                timeStart = act_time_info.get('time_start')
            elif timeStart > act_time_info.get('time_start'):
                activity_id = act_conf.id
                timeStart = act_time_info.get('time_start')

    return {'id': activity_id, 'end_time': timeEnd, 'start_time': timeStart}
