#-*- coding:utf-8 -*-
"""
created by server on 14-6-27上午10:13.
"""

from shared.db_opear.configs_data import game_configs
from app.game.core.PlayersManager import PlayersManager
from app.game.redis_mode import tb_equipment_list
from app.game.redis_mode import tb_character_info
import json


def get_equip_list(dynamicId ):
    player = PlayersManager().get_player_by_dynamic_id(dynamicId)
    if not player:
        return {'result': False, 'list': ''}
    equipment_list = player.base_info.user_equipment_list
    print equipment_list
    user_equipment_list = []

    for user_equipment_data in equipment_list:
        list_data = user_equipment_data.get('equip_list_data')
        user_equip = {'id': user_equipment_data.get('eid'),
                      'configId': list_data.get('id'),
                      'name': list_data.get('name'),
                      'quality': list_data.get('quality'),
                      'type': list_data.get('type')}
        user_equipment_list.append(user_equip)
        print user_equipment_data.get('id')
        print user_equipment_data.get('name')
    return {'result': True, 'list': str(user_equipment_list)}


def add_equip(dynamicId, equip_id):
    player = PlayersManager().get_player_by_dynamic_id(dynamicId)
    if not player:
        return {'result': False, 'list': ''}
    for data_id in game_configs.equipment.get('equipment').keys():
        if int(data_id) == int(equip_id):
            list_size = len(player.base_info.user_equipment_list)
            list_data = {'eid': list_size, 'equip_list_data': game_configs.equipment.get('equipment')[data_id]}
            player.base_info.user_equipment_list.append(list_data)
            print game_configs.equipment.get('equipment')[data_id].values()
            equip_data = tb_character_info.getObjData(player.base_info.id)
            if not equip_data:
                return {'result': False}
            equip_id_list = equip_data.get('equipment')
            equip_id_data = {'id': equip_data.get('id'), 'nickname': equip_data.get('nickname'), 'equipment': equip_data.get('equipment')}
            pmmode = tb_character_info.getObj(player.base_info.id)
            pmmode.update_multi(equip_id_data)

            equip_list_data = {'id': player.base_info.id, 'equipdata': list_data}
            #equipmmode = tb_equipment_list.new(equip_list_data)
            #equipmmode.insert()
            print equip_list_data
            pmmode = tb_equipment_list.getObj(player.base_info.id)
            pmmode.update_multi(equip_list_data)

    return {'result': True}


def remove_equip(dynamicId, equip_id):
    player = PlayersManager().get_player_by_dynamic_id(dynamicId)
    if not player:
        return {'result': False, 'list': ''}

        #player.base_info.equipment_list.remove(data)
        player.base_info.equipment_id_list.remove(equip_id)
        equip_data = tb_character_info.getObjData(player.base_info.id)
        equip_id_list = equip_data.get('equipment')
        equip_id_list.remove(equip_id)
        equip_id_data = {'id': equip_data.get('id'), 'nickname': equip_data.get('nickname'), 'equipment': equip_data.get('equipment')}
        pmmode = tb_character_info.getObj(player.base_info.id)
        pmmode.update_multi(equip_id_data)

        equip_list_data = tb_equipment_list.getObjData(player.base_info.id)
        for per_equip_list_data in equip_list_data:
            if per_equip_list_data.get('id') == equip_id:
                equip_list_data.remove(per_equip_list_data)
                break
        equip_list_data = dict(id=player.base_info.id, equipdata=equip_list_data)
        pmmode = tb_equipment_list.getObj(player.base_info.id)
        pmmode.update_multi(equip_list_data)
    return {'result': True, 'list': ''}


def add_equip_list_data(dynamicId, request_proto):
        #player = PlayersManager().get_player_by_dynamic_id(dynamicId)
        #if not player:
            #return {'result': False, 'list': ''}
        #equip_list_data = dict(id=player.base_info.id, equipdata=request_proto)
        #equipmmode = tb_equipment_list.new(equip_list_data)
        #equipmmode.insert()

        #equip_id_data = {'id': 59, 'nickname': 'qqwwee'}
        equip_id_data = []
        pmmode = tb_equipment_list.getObj(59)
        pmmode.update_multi(equip_id_data)
        print 'nmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm'
        return {'result': True}
