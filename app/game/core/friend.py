# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""

import datetime
from app.game.logic.common.check import have_player
from app.game.redis_mode import tb_character_friend


@have_player
def add_friend_request(dynamic_id, target_id, **kwargs):
    """
    add target to inviter's applicants list
    :param dynamic_id:
    :param target_id:
    :return:
    """
    target = tb_character_friend.getObjData(target_id)
    print target
    print 'hi friend'
    if not target:
        data = {'id': target_id, 'friends': [], 'blacklist': [], 'applicants_list': {}}
        tb_character_friend.new(data)
    target = tb_character_friend.getObjData(target_id)
    target_applicants = target.get('applicants_list')
    target_applicants[target_id]=datetime.datetime.now()



@have_player
def become_friends(dynamic_id, target_id, **kwargs):
    """
    :param dynamic_id:
    :param target_id:
    :param kwargs:
    :return:
    """
    # todo check target id if exist in applicants list

    # todo check if player which id is target id is exist

    player1 = tb_character_friend.getObjData(kwargs.base_info.id)
    player2 = tb_character_friend.getObjData(target_id)
    if not player1:
        data = {'id': kwargs.base_info.id, 'friends': [], 'blacklist': [], 'applicants_list': {}}
        tb_character_friend.new(data)
    if not player2:
        data = {'id': target_id, 'friends': [], 'blacklist': [], 'applicants_list': {}}
        tb_character_friend.new(data)

    player = tb_character_friend.getObjData(kwargs.base_info.id)
    player_friends = player.get('friends')
    player_friends.append(target_id)

    player = tb_character_friend.getObjData(target_id)
    player_friends = player.get('friends')
    player_friends.append(kwargs.base_info.id)

    return 0
