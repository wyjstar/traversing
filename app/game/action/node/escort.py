# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import escort_pb2, common_pb2
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return, dump_game_response_to_string
from shared.utils.const import const
from shared.utils.date_util import get_current_timestamp
from gfirefly.server.globalobject import GlobalObject
from app.game.action.node._fight_start_logic import get_seeds
from app.game.action.node._fight_start_logic import pvp_process
from app.game.core.mail_helper import send_mail
from app.game.action.node._fight_start_logic import assemble
import cPickle
import copy


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def get_all_task_info_1901(pro_data, player):
    """取得所有押运信息"""
    response = escort_pb2.GetEscortTasksResponse()
    escort_component = player.escort_component

    response.start_protect_times = escort_component.start_protect_times
    response.protect_times = escort_component.protect_times
    response.rob_times = escort_component.rob_times
    response.refresh_times = escort_component.refresh_times

    for _, task in escort_component.tasks.items():
        task_pb = response.tasks.add()
        task_pb.task_id = task.get("task_id")
        task_pb.task_no = task.get("task_no")
        task_pb.state = task.get("state")

    if not escort_component.can_rob_tasks: # 如果没有则刷新
        tasks = remote_gate["world"].get_can_rob_tasks_remote(player.guild.g_id)
    else:
        tasks = remote_gate["world"].get_tasks_by_ids_remote(player.guild.g_id, escort_component.can_rob_tasks)
        for task_id in tasks.keys():
            escort_component.can_rob_tasks.append(task_id)
        escort_component.save_data()

    load_data_to_response(tasks, response.can_rob_tasks)

    #send_reward_when_task_finish(player)
    logger.debug("response %s" % response)
    return response.SerializePartialToString()

# todo: send reward when task finished
def send_reward_when_task_finish(player):
    """任务完成后发奖"""
    for task_id in player.escort_component.protect_records:
        task = remote_gate["world"].get_task_by_id_remote(player.guild.g_id, task_id)
        task_item = game_configs.guild_task_config.get(task.task_no)
        if task.is_finished(task_item):
            task.state = -1
            protecters_num = len(task.protecters)
            peoplePercentage = task_item.peoplePercentage.get(protecters_num)
            robbedPercentage = 0
            for t in range(task.rob_success_times()):
                robbedPercentage = robbedPercentage + task_item.robbedPercentage.get(t+1)


            robbedPercentage = task_item.robbedPercentage.get(task.rob_success_times())
            logger.debug("peoplePercentage protecters_num robbedPercentage %s %s %s" % (peoplePercentage, protecters_num, robbedPercentage))
            escort_formula = game_configs.formula_config.get("EscortReward").get("formula")
            assert escort_formula!=None, "escort_formula can not be None!"
            percent = eval(escort_formula, {"peoplePercentage": peoplePercentage, "robbedPercentage": robbedPercentage})

            return_data = gain(player, task_item.reward, const.ESCORT_ROB, multiple=percent)
            reward_response_pb = common_pb2.GameResourcesResponse()
            get_return(player, return_data, reward_response_pb)
            task.reward = reward_response_pb.SerializePartialToString()
            # send reward mail
            str_rewards = dump_game_response_to_string(reward_response_pb)
            for player_info in task.protecters:
                send_mail(conf_id=1001,  receive_id=player_info.get("id"),
                                      nickname=player_info.get("nickname"), arg1=str(str_rewards))



@remoteserviceHandle('gate')
def get_escort_record_1902(data, player):
    """根据类型获取押运记录"""
    request = escort_pb2.GetEscortRecordsRequest()
    request.ParseFromString(data)
    response = escort_pb2.GetEscortRecordsResponse()
    logger.debug("request %s" % request)
    record_type = request.record_type
    escort_component = player.escort_component

    logger.debug("guild %s" % player.guild.g_id)
    tasks = {}
    if record_type == 1: # 我的押运记录
        tasks = remote_gate["world"].get_tasks_by_ids_remote(player.guild.g_id, escort_component.protect_records)
        load_data_to_response(tasks, response.tasks)

    elif record_type == 2: # 我的劫运记录
        tasks = remote_gate["world"].get_tasks_by_ids_remote(player.guild.g_id, escort_component.rob_records)
        load_data_to_response(tasks, response.tasks)

    elif record_type == 3: # 军团押劫记录
        tasks = remote_gate["world"].get_guild_task_records_remote(player.guild.g_id)
        for task_id, task in tasks.items():
            if not task.get("rob_task_infos"):
                task_pb = response.tasks.add()
                update_task_pb(task, task_pb)
                break
            for header, rob_task_info in task.get("rob_task_infos", {}):
                tmp_task = copy.deepcopy(task)
                tmp_task["rob_task_infos"] = {}
                tmp_task["rob_task_infos"][header] = rob_task_info
                task_pb = response.tasks.add()
                update_task_pb(tmp_task, task_pb)

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def refresh_can_rob_tasks_1903(data, player):
    """刷新可劫运任务"""
    response = escort_pb2.RefreshEscortTaskResponse()
    response.res.result = True

    tasks = remote_gate["world"].get_can_rob_tasks_remote(player.guild.g_id)
    load_data_to_response(tasks, response.tasks)

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def refresh_tasks_1904(data, player):
    """刷新任务列表"""
    response = escort_pb2.RefreshEscortTaskResponse()
    response.res.result = True
    escort_component = player.escort_component

    if escort_component.refresh_times >= game_configs.base_config.get("EscortRefreshFrequencyMax"):
        logger.error("reach the max refresh time!")
        response.res.result = False
        response.res.result_no = 190401
        return response.SerializePartialToString()

    price = game_configs.base_config.get("EscortRefreshPrice")
    need_gold = price[escort_component.refresh_times]

    def func():
        escort_component.refresh_tasks() #刷新任务
        escort_component.refresh_times = escort_component.refresh_times + 1
        escort_component.save_data()
        for _, task in escort_component.tasks.items():
            task_pb = response.tasks.add()
            update_task_pb(task, task_pb)
    player.pay.pay(need_gold, const.REFRESH_ESCORT_TASKS, func)

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def receive_escort_task_1905(data, player):
    """接受押运、劫运任务"""
    request = escort_pb2.ReceiveEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    protect_or_rob = request.protect_or_rob

    response = common_pb2.CommonResponse()

    res = None
    if protect_or_rob == 1:
        res = receive_protect_task(player, task_id)
    elif protect_or_rob == 2:
        res = receive_rob_task(player, task_id)
        logger.debug("res %s" % res)

    if not res.get('result'):
        response.result_no = res.get('result_no')
    response.result = res.get('result')
    return response.SerializePartialToString()

def receive_protect_task(player, task_id):
    """接受保护任务"""
    escort_component = player.escort_component
    task_info = escort_component.tasks.get(task_id)
    if not task_info:
        logger.error("can't find this task_info!")
        return {'result': False, 'result_no': 190501}

    task_info["state"] = 1
    task_info["protecters"] = [get_player_info(player)]
    escort_component.protect_records.append(task_id)
    escort_component.save_data()
    remote_gate["world"].add_task_remote(player.guild.g_id, task_info)
    return {'result': True}

def receive_rob_task(player, task_id):
    """
    接受劫运任务
    """
    escort_component = player.escort_component
    task = remote_gate["world"].get_task_by_id_remote(player.guild.g_id, task_id)
    if task.get('state') != 2:
        logger.error("task state not right! %s" % task.get("state"))
        return {'result': False, 'result_no': 190901}
    if player.base_info.id in task.get('rob_task_infos'):
        logger.debug("this task has been robbed!")
        return {'result': False, 'result_no': 190902}
    escort_component.rob_records.append(task.get("task_id"))
    escort_component.save_data()

    remote_gate["world"].add_player_remote(player.guild.g_id, task_id, get_player_info(player), 2, 0)

    return {'result': True}

def get_player_info(player):
    player_info = {}
    player_info["id"] = player.base_info.id
    player_info["nickname"] = player.base_info.base_name
    player_info["level"] = player.base_info.level
    player_info["head"] = player.base_info.heads.now_head
    player_info["vip_level"] = player.base_info.vip_level
    player_info["power"] = int(player.line_up_component.combat_power)
    player_info["BattleUnitGrop"] = cPickle.dumps(player.fight_cache_component.get_red_units())
    return player_info

@remoteserviceHandle('gate')
def cancel_escort_task_1906(data, player):
    """取消劫运任务"""
    request = escort_pb2.CancelEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    remote_gate["world"].cancel_rob_task_remote(player.guild.g_id, task_id, player.base_info.id)
    response = common_pb2.CommonResponse()
    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def invite_1908(data, player):
    """发送/接受邀请"""
    request = escort_pb2.InviteEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    response = common_pb2.CommonResponse()
    task_id = request.task_id
    send_or_in = request.send_or_in
    protect_or_rob = request.protect_or_rob
    res = None
    if send_or_in == 1:
        res = send_invite(player, task_id, protect_or_rob)
    elif send_or_in == 2:
        res = in_invite(player, task_id, protect_or_rob)

    if not res.get('result'):
        response.result_no = res.get('result_no')
        return response.SerializePartialToString()

    response.result = True
    return response.SerializePartialToString()

def send_invite(player, task_id, protect_or_rob):
    """docstring for send_invite"""
    escort_component = player.escort_component

    task = escort_component.tasks.get(task_id)

    if not task:
        logger.error("can't find this task!")
        return {'result': False, 'result_no': 190801}
    task = remote_gate["world"].send_escort_task_invite_remote(player.guild.g_id, task_id, protect_or_rob)

    push_response = escort_pb2.InviteEscortTaskPushResponse()
    update_task_pb(task, push_response.task)
    push_response.protect_or_rob = protect_or_rob
    for p_id in get_guild_member_ids(player.guild.g_id):
        remote_gate.push_object_remote(19082, push_response.SerializePartialToString(), player.base_info.id)


    return {'result': True}

def get_guild_member_ids(g_id):
    """docstring for get_guild_member_ids"""
    return [10000]

def in_invite(player, task_id, protect_or_rob):
    """
    参与邀请
    """
    # add CharacterInfo to the task
    task = remote_gate["world"].add_player_remote(player.guild.g_id, task_id, get_player_info(player), protect_or_rob, 0)
    # push info to related players
    push_response = escort_pb2.InviteEscortTaskPushResponse()
    update_task_pb(task, push_response.task)
    push_response.protect_or_rob = protect_or_rob
    remote_gate.push_object_remote(19081, push_response.SerializePartialToString(), task.get("protecters")[0].get("id"))
    return {'result': True}

@remoteserviceHandle('gate')
def start_escort_1909(data, player):
    """手动开始押运或者劫运"""
    request = escort_pb2.StartEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    protect_or_rob = request.protect_or_rob
    response = escort_pb2.StartEscortTaskResponse()
    response.res.result = True

    if protect_or_rob == 1:
        start_protect_escort(player.guild.g_id, task_id)
    elif protect_or_rob == 2:
        start_rob_escort(player, task_id, response)
    logger.debug("response %s" % response)
    return response.SerializePartialToString()

def start_protect_escort(guild_id, task_id):
    """docstring for start_protect_escort"""
    res = remote_gate["world"].start_protect_task_remote(guild_id, task_id)
    return {"result": True}

def start_rob_escort(player, task_id, response):
    """
    手动开始劫运
    """
    task = remote_gate["world"].get_task_by_id_remote(player.guild.g_id, task_id)
    # construct battle units
    # update rob task
    task_item = game_configs.guild_task_config.get(task.get("task_no"))
    logger.debug("task %s" % task)
    rob_task_info = task.get("rob_task_infos").get(player.base_info.id)
    seed1, seed2 = get_seeds()
    rob_task_info["seed1"] = seed1
    rob_task_info["seed2"] = seed2
    red_groups = []
    blue_groups = []
    for player_info in task.get("protecters"):
        red_group = cPickle.loads(player_info.get("BattleUnitGrop"))
        red_groups.append(red_group)

    for player_info in task.get("rob_task_infos").get(player.base_info.id).get("robbers"):
        blue_group = cPickle.loads(player_info.get("BattleUnitGrop"))
        blue_groups.append(blue_group)
    logger.debug("red_groups %s" % red_groups)
    logger.debug("blue_groups %s" % blue_groups)

    # pvp battle
    rob_result = pvp_process(player, None, red_groups, blue_groups,
                               None, None,
                               None, None,
                               seed1, seed2,
                               const.BATTLE_GUILD)

    rob_task_info["rob_result"] = rob_result
    rob_task_info["rob_time"] = get_current_timestamp()
    if rob_result:
        robbers_num = len(rob_task_info.get("robbers"))
        peoplePercentage = task_item.peoplePercentage.get(robbers_num)
        robbedPercentage = task_item.robbedPercentage.get(len(task.rob_task_infos))
        logger.debug("peoplePercentage robbers_num %s %s" % (peoplePercentage, robbers_num))
        snatch_formula = game_configs.formula_config.get("SnatchReward").get("formula")
        assert snatch_formula!=None, "snatch_formula can not be None!"
        percent = eval(snatch_formula, {"peoplePercentage": peoplePercentage, "robbedPercentage": robbedPercentage})
        return_data = gain(player, task_item.reward, const.ESCORT_ROB, multiple=percent)
        rob_response_pb = common_pb2.GameResourcesResponse()
        get_return(player, return_data, rob_response_pb)
        rob_task_info["rob_reward"] = rob_response_pb.SerializePartialToString()
        # send reward mail
        str_rewards = dump_game_response_to_string(rob_response_pb)

        for player_info in rob_task_info.get("robbers"):
            send_mail(conf_id=1002,  receive_id=player_info.get("id"),
                                  nickname=player_info.get("nickname"), arg1=str(str_rewards))
    remote_gate["world"].start_rob_escort_remote(player.guild.g_id, task_id, rob_task_info)
    update_rob_task_info_pb(rob_task_info, response.rob_task_info)
    return {"result": True}

def load_data_to_response(tasks, tasks_pb):
    """docstring for load_data_to_response"""
    for task_id, task in tasks.items():
        task_pb = tasks_pb.add()
        update_task_pb(task, task_pb)

def update_task_pb(task, task_pb):
    """docstring for load_task_to_response"""
    task_pb.task_id = task.get("task_id")
    task_pb.task_no = task.get("task_no")
    task_pb.state = task.get("state")
    task_pb.receive_task_time = task.get("receive_task_time", 0)
    task_pb.start_protect_time = task.get("start_protect_time", 0)
    update_guild_pb(task.get("protect_guild_info"), task_pb.protect_guild_info)
    update_player_infos_pb(task.get("protecters"), task_pb.protecters)

    for rob_task_info in task.get("rob_task_infos"):
        rob_task_info_pb = task_pb.rob_task_infos.add()
        update_rob_task_info_pb(task.get("protecters"), rob_task_info, rob_task_info_pb)

def update_guild_pb(guild_info, guild_info_pb):
    guild_info_pb.g_id = guild_info.get("g_id", -1)
    guild_info_pb.rank = guild_info.get("rank", -1)
    guild_info_pb.name = guild_info.get("name", "")
    guild_info_pb.level = guild_info.get("level", 0)
    guild_info_pb.president = guild_info.get("president", "")
    guild_info_pb.p_num = guild_info.get("p_num", 0)
    guild_info_pb.icon_id = guild_info.get("icon_id", 0)
    guild_info_pb.call = guild_info.get("call", "")

def update_player_infos_pb(player_infos, player_infos_pb):
    for player_info in player_infos:
        player_info_pb = player_infos_pb.add()
        player_info_pb.id = player_info.get("id")
        player_info_pb.nickname = player_info.get("nickname")
        player_info_pb.level = player_info.get("level")
        player_info_pb.hero_no = player_info.get("head")
        player_info_pb.vip_level = player_info.get("vip_level")
        player_info_pb.power = player_info.get("power")

def update_rob_task_info_pb(protecters, rob_task_info, rob_task_info_pb):
    # guild
    update_guild_pb(rob_task_info.get("rob_guild_info"), rob_task_info_pb.rob_guild_info)
    # robbers
    update_player_infos_pb(rob_task_info.get("robbers"), rob_task_info_pb.robbers)
    # protect battle units
    update_side_battle_unit_pb(protecters, rob_task_info_pb.red)
    update_side_battle_unit_pb(rob_task_info.get("robbers"), rob_task_info_pb.blue)
    # seed
    rob_task_info_pb.seed1 = rob_task_info.get("seed1")
    rob_task_info_pb.seed2 = rob_task_info.get("seed2")
    # rob reward
    rob_response_pb = common_pb2.GameResourcesResponse()
    rob_task_info_pb.rob_reward = rob_response_pb.ParseFromString(rob_task_info.get("rob_reward", ""))
    # rob_result
    rob_task_info_pb.rob_result = rob_task_info.get("rob_result")
    # rob_time
    rob_task_info_pb.rob_time = rob_task_info.get("rob_time")
    # rob_state
    rob_task_info_pb.rob_time = rob_task_info.get("rob_state", 0)
    # rob_receive_task_time
    rob_task_info_pb.rob_time = rob_task_info.get("rob_receive_task_time", 0)

def update_side_battle_unit_pb(player_infos, battle_unit_group_pb):
    for player_info in player_infos:
        battle_unit_group_pb = battle_unit_group_pb.add()
        for no, battle_unit in cPickle.loads(player_info.get("BattleUnitGrop")):
            battle_unit_pb = battle_unit_group_pb.group.add()
            assemble(battle_unit_pb, battle_unit)
