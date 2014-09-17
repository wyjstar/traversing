# -*- coding:utf-8 -*-
"""
created by server on 14-9-15上午11:28.
"""
from gevent import queue
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.battle_round_pb2 import Round
from app.battle.core.battle_check import BattleCheck

@remote_service_handle
def battle_round_999(dynamic_id, round_data, user_data):
    """
    user_data:{'hero_card':[battle_unit], 'config_data':{}}
    :param dynamic_id:
    :param round_data:
    :param user_data:
    :return:
    """
    request = Round()
    request.ParseFromString(round_data)

    # camp = request.camp
    # executor = request.executor
    # skill_id = request.skill_id
    # skill_type = request.skill_type
    # buffs = request.buffs
    # for item in buffs:
    #     pass

    battle_data = {}
    battle_data["camp"] = request.camp
    battle_data["exectuor"] = request.exectuor
    battle_data["skill_id"] = request.skill_id
    battle_data["skill_type"] = request.skill_type
    battle_data["buffs"] = request.buffs
    battle_check = BattleCheck(battle_data)