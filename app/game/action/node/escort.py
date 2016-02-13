# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import escort_pb2, common_pb2
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
#from app.game.core.item_group_helper import get_return
from shared.utils.const import const
from gfirefly.server.globalobject import GlobalObject
#from app.game.action.node._fight_start_logic import assemble
from app.game.action.root.netforwarding import push_message
from shared.utils.date_util import get_current_timestamp, is_in_period
import cPickle
import copy
from app.game.core.task import hook_task, CONDITIONId
from shared.tlog import tlog_action
from shared.common_logic.escort_task import load_data_to_response, update_task_pb, update_rob_task_info_pb


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def get_all_task_info_1901(pro_data, player):
    """取得所有押运信息"""
    response = escort_pb2.GetEscortTasksResponse()
    escort_component = player.escort_component
    escort_component.check_time()

    response.start_protect_times = escort_component.start_protect_times
    response.protect_times = escort_component.protect_times
    response.rob_times = escort_component.rob_times
    response.refresh_times = escort_component.refresh_times

    # 登陆更新任务状态
    remote_gate["world"].update_task_state_remote(escort_component.protect_records, escort_component.rob_records)
    for _, task in escort_component.tasks.items():
        task_pb = response.tasks.add()
        task_pb.task_id = task.get("task_id")
        task_pb.task_no = task.get("task_no")
        task_pb.state = task.get("state")

    # 可劫运的任务
    #if not escort_component.can_rob_tasks: # 如果没有则刷新
    tasks = remote_gate["world"].get_can_rob_tasks_remote(player.guild.g_id)
    #logger.debug("can_rob_tasks_remote %s" % tasks)
    #for task_id, task in tasks.items():
        #logger.debug("task_id, task")
        #logger.debug(task)
        #escort_component.can_rob_tasks[task.get("task_id")] = dict(guild_id=task.get("protect_guild_info").get("id"))
    #escort_component.save_data()
    #else:
        #tasks = remote_gate["world"].get_tasks_by_ids_remote(escort_component.can_rob_tasks)
    load_data_to_response(tasks, response.can_rob_tasks)
    # 押运邀请
    tasks = remote_gate["world"].get_invite_remote(player.guild.g_id, 1)
    load_data_to_response(tasks, response.tasks_protect_invite)
    # 劫运邀请
    tasks = remote_gate["world"].get_invite_remote(player.guild.g_id, 2)
    load_data_to_response(tasks, response.tasks_rob_invite)
    # 我的押运任务
    #tasks = remote_gate["world"].get_tasks_by_ids_remote(escort_component.protect_records)
    #record_util(player.base_info.id, tasks, response.my_protect_tasks)
    # 我的当前任务
    #task = get_my_current_task(tasks, player.base_info.id)
    #update_task_pb(task, response.my_current_task)
    # 我的劫运任务
    tasks = remote_gate["world"].get_tasks_by_ids_remote(escort_component.rob_records)
    get_my_current_rob_task(player.base_info.id, tasks, response.my_current_rob_task)

    #record_util(player.base_info.id, tasks, response.my_protect_tasks)

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def get_escort_record_1902(data, player):
    """根据类型获取押运记录"""
    request = escort_pb2.GetEscortRecordsRequest()
    request.ParseFromString(data)
    response = escort_pb2.GetEscortRecordsResponse()
    logger.debug("request %s" % request)
    record_type = request.record_type
    current = request.current
    escort_component = player.escort_component

    logger.debug("guild %s" % player.guild.g_id)
    tasks = {}
    if record_type == 1: # 我的押运记录

        logger.debug("3======================== %s" % escort_component.protect_records)
        tasks = remote_gate["world"].get_tasks_by_ids_remote(escort_component.protect_records)
        logger.debug("======================== %s" % tasks)
        if current:
            task = get_my_current_task(tasks, player.base_info.id)
            if task:
                update_task_pb(task, response.tasks.add())
        else:
            logger.debug("1======================== %s" % tasks)
            load_data_to_response(tasks, response.tasks)

    elif record_type == 2: # 我的劫运记录
        logger.debug("rob_records======================== %s" % escort_component.rob_records)
        tasks = remote_gate["world"].get_tasks_by_ids_remote(escort_component.rob_records)
        load_data_to_response(tasks, response.tasks)

    elif record_type == 3: # 军团押劫记录
        tasks = remote_gate["world"].get_guild_task_records_remote(player.guild.g_id)
        #load_data_to_response(tasks, response.tasks)
        response.ParseFromString(tasks)

    logger.debug("response %s" % response)
    logger.debug("response len %s" % len(response.SerializePartialToString()))
    return response.SerializePartialToString()

def get_my_current_task(tasks, player_id):
    """我的押运任务, 筛选我的"""
    for task_id, task in tasks.items():
        protecter0 = task.get("protecters")[0].get("id")
        logger.debug("task protecter0 %s player_id %s" % (protecter0, player_id))
        if task.get("state") in [1, 2] and protecter0 == player_id:
            logger.debug("task protecter0 %s player_id %s" % (protecter0, player_id))
            return task

def get_my_current_rob_task(player_id, tasks, task_pb):
    for task_id, task in tasks.items():
        if not task.get("rob_task_infos"):
            continue
        for rob_task_info in task.get("rob_task_infos", []):
            if player_id == rob_task_info.get("robbers")[0].get("id") and rob_task_info.get("rob_state")==1 and task.get("state") == 2:
                task["rob_task_infos"] = [rob_task_info]
                update_task_pb(task, task_pb)
                break


def record_util(player_id, tasks, tasks_pb):
    for task_id, task in tasks.items():
        if not task.get("rob_task_infos"):
            task_pb = tasks_pb.add()
            update_task_pb(task, task_pb)
            continue
        for rob_task_info in task.get("rob_task_infos", []):
            is_in_rob = False
            for robber_info in rob_task_info.get("robbers"):
                if player_id == robber_info.get("id"):
                    is_in_rob = True
            if not is_in_rob: continue

            tmp_task = copy.deepcopy(task)
            tmp_task["rob_task_infos"] = [rob_task_info]
            task_pb = tasks_pb.add()
            update_task_pb(tmp_task, task_pb)

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

    tlog_action.log('RefreshEscortTasks', player, escort_component.refresh_times+1)

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def receive_escort_task_1905(data, player):
    """接受押运任务"""
    request = escort_pb2.ReceiveEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    #protect_or_rob = request.protect_or_rob
    #task_guild_id = request.task_guild_id

    response = common_pb2.CommonResponse()

    res = receive_protect_task(player, task_id)

    if not res.get('result'):
        response.result_no = res.get('result_no')
    response.result = res.get('result')
    tlog_action.log('ReceiveEscortTask', player, task_id)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def receive_rob_escort_task_1907(data, player):
    """接受劫运任务"""
    request = escort_pb2.ReceiveEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    #protect_or_rob = request.protect_or_rob
    task_guild_id = request.task_guild_id

    response = escort_pb2.ReceiveEscortTaskResponse()

    res = receive_rob_task(player, task_id, task_guild_id)
    if res.get("result"):
        task = res.get("task")
        update_task_pb(task, response.task)
    response.res.result = res.get('result')
    if not res.get('result'):
        response.res.result_no = res.get('result_no')
    else:
        tlog_action.log('ReceiveRobEscortTask', player, task_id, task_guild_id)
    return response.SerializePartialToString()

def receive_protect_task(player, task_id):
    """接受保护任务"""
    escort_component = player.escort_component
    task_info = escort_component.tasks.get(task_id)
    if not task_info:
        logger.error("can't find this task_info!")
        return {'result': False, 'result_no': 190501}

    escort_open_time_item = game_configs.base_config.get("EscortOpenTime")
    if not is_in_period(escort_open_time_item):
        logger.error("feature not open!")
        return {'result': False, 'result_no': 30000}

    res = remote_gate["world"].get_guild_info_remote(player.guild.g_id, "build", 0)
    if not res.get("result"):
        logger.error("get guild info error!")
        return res

    build = res.get("build")
    guild_item = game_configs.guild_config.get(4).get(build.get(4))


    escort_component = player.escort_component
    if escort_component.start_protect_times >= guild_item.escortTimeMax:
        logger.error("start_protect_times not enough!")
        return {'result': False, 'result_no': 190502}

    task_info["state"] = 1
    task_info["player_info"] = get_player_info(player)
    escort_component.protect_records[task_id] = dict(guild_id=player.guild.g_id)
    escort_component.save_data()
    res = remote_gate["world"].add_task_remote(player.guild.g_id, task_info)
    if not res.get("result"):
        return res

    escort_component.start_protect_times += 1
    escort_component.save_data()
    return {'result': True}

def receive_rob_task(player, task_id, task_guild_id):
    """
    接受劫运任务
    """
    receive_rob_times = player.finance[const.GUILD_ESCORT_ROB_TIMES]
    escort_open_time_item = game_configs.base_config.get("EscortOpenTime")
    if not is_in_period(escort_open_time_item):
        logger.error("feature not open!")
        return {'result': False, 'result_no': 30000}

    if receive_rob_times <= 0:
        logger.error("receive_rob_times! %s" % receive_rob_times)
        return {'result': False, 'result_no': 190901}

    escort_component = player.escort_component
    task = remote_gate["world"].get_task_by_id_remote(task_guild_id, task_id)
    if task.get('state') != 2:
        logger.error("task state not right! %s" % task.get("state"))
        return {'result': False, 'result_no': 190902}

    #if player.base_info.id in task.get('rob_task_infos') and task.get():
        #logger.debug("this task has been robbed!")
        #return {'result': False, 'result_no': 190902}

    logger.debug("receive_rob_task, start=======")
    res = remote_gate["world"].add_player_remote(task_guild_id, task_id, get_player_info(player), 2, -1, {})
    logger.debug("receive_rob_task, end=======")
    if res.get('result'):
        escort_component.rob_records[task.get("task_id")] = dict(guild_id=task_guild_id, rob_no=res.get('task').get('rob_task_infos')[0].get('rob_no'))
        escort_component.save_data()

    return res


def get_player_info(player):
    player_info = {}
    player_info["id"] = player.base_info.id
    player_info["nickname"] = player.base_info.base_name
    player_info["level"] = player.base_info.level
    player_info["head"] = player.base_info.heads.now_head
    player_info["vip_level"] = player.base_info.vip_level
    player_info["power"] = int(player.line_up_component.combat_power)
    player_info["g_id"] = player.guild.g_id
    player_info["BattleUnitGrop"] = cPickle.dumps(player.fight_cache_component.get_red_units())
    line_up = player.line_up_component
    caption_hero = line_up.line_up_slots.get(line_up.caption_pos).hero_slot.hero_obj
    player_info["hero_no"] = caption_hero.hero_no
    player_info["level"] = caption_hero.level
    player_info["break_level"] = caption_hero.break_level

    return player_info

@remoteserviceHandle('gate')
def cancel_escort_task_1906(data, player):
    """取消劫运任务"""
    request = escort_pb2.CancelEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    task_guild_id = request.task_guild_id
    rob_no = request.rob_no
    if rob_no == -1:
        logger.debug("rob_no can not be None!!")
    remote_gate["world"].cancel_rob_task_remote(task_guild_id, task_id, rob_no)
    response = common_pb2.CommonResponse()
    tlog_action.log('CancelEscortTask', player, task_id, task_guild_id)
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
    task_guild_id = request.task_guild_id
    rob_no = request.rob_no

    escort_open_time_item = game_configs.base_config.get("EscortOpenTime")
    if not is_in_period(escort_open_time_item):
        logger.error("feature not open!")
        response.result = False
        response.result_no = 30000
        return response.SerializePartialToString()
    res = None
    if send_or_in == 1:
        res = send_invite(player, task_id, protect_or_rob, task_guild_id, rob_no)
    elif send_or_in == 2:
        res = in_invite(player, task_id, protect_or_rob, task_guild_id, rob_no)

    response.result = res.get('result')
    if not res.get('result'):
        response.result_no = res.get('result_no')
        return response.SerializePartialToString()

    tlog_action.log('GuildTaskInvite', player, task_id, task_guild_id, send_or_in, protect_or_rob, rob_no)
    response.result = True
    return response.SerializePartialToString()

def send_invite(player, task_id, protect_or_rob, task_guild_id, rob_no):
    """docstring for send_invite"""
    AnnouncementCoolingTime = game_configs.base_config.get("AnnouncementCoolingTime", 0)
    task = remote_gate["world"].get_task_by_id_remote(task_guild_id, task_id)
    if protect_or_rob == 1:
        last_send_invite_time = task.get("last_send_invite_time", 0)
        if last_send_invite_time + AnnouncementCoolingTime > int(get_current_timestamp()):
            logger.error("last_send_invite_time %s AnnouncementCoolingTime %s current %s" % (last_send_invite_time, AnnouncementCoolingTime, int(get_current_timestamp())))
            return {'result': False, 'result_no': 1908041}
    if protect_or_rob == 2:
        last_send_invite_time = task.get("rob_task_infos")[0].get("last_send_invite_time", 0)
        if last_send_invite_time + AnnouncementCoolingTime > int(get_current_timestamp()):
            logger.error("last_send_invite_time %s AnnouncementCoolingTime %s current %s" % (last_send_invite_time, AnnouncementCoolingTime, int(get_current_timestamp())))
            return {'result': False, 'result_no': 1908041}

    task = remote_gate["world"].send_escort_task_invite_remote(task_guild_id, task_id, player.guild.g_id, rob_no, protect_or_rob)
    if not task:
        logger.error("can't find this task!")
        return {'result': False, 'result_no': 190801}


    push_response = escort_pb2.InviteEscortTaskPushResponse()
    update_task_pb(task, push_response.task)
    push_response.protect_or_rob = protect_or_rob
    guild_info = {}
    if protect_or_rob == 1:
        guild_info = task.get("protect_guild_info")
    if protect_or_rob == 2:
        guild_info = task.get("rob_task_infos")[0].get("rob_guild_info")

    remote_gate.push_object_character_remote(19082, push_response.SerializePartialToString(), player.guild.get_guild_member_ids(guild_info.get("p_list", {})))
    logger.debug("push_response %s" % push_response)


    return {'result': True}

def in_invite(player, task_id, protect_or_rob, task_guild_id, rob_no):
    """
    参与邀请
    """

    res = remote_gate["world"].get_guild_info_remote(player.guild.g_id, "build", 0)
    if not res.get("result"):
        logger.error("get guild info error!")
        return res

    build = res.get("build")
    guild_item = game_configs.guild_config.get(4).get(build.get(4))

    escort_component = player.escort_component
    if protect_or_rob == 1 and escort_component.protect_times >= guild_item.protectionEscortTimeMax:
        logger.error("protect_times not enough!")
        return {'result': False, 'result_no': 190812}
    if protect_or_rob == 2 and escort_component.rob_times >= guild_item.snatchTimeMax:
        logger.error("rob_times not enough!")
        return {'result': False, 'result_no': 190803}

    # add CharacterInfo to the task
    res = remote_gate["world"].add_player_remote(task_guild_id, task_id, get_player_info(player), protect_or_rob, rob_no, escort_component.protect_records)
    if not res.get("result"):
        return res
    task = res.get("task")
    # push info to head players
    push_response = escort_pb2.InviteEscortTaskPushResponse()
    update_task_pb(task, push_response.task)
    push_response.protect_or_rob = protect_or_rob
    if protect_or_rob == 1:
        player.escort_component.protect_records[task_id] = dict(guild_id=task_guild_id)
    if protect_or_rob == 2:
        player.escort_component.rob_records[task_id] = dict(guild_id=task_guild_id, rob_no=rob_no)
    player.escort_component.save_data()

    if protect_or_rob == 1:
        player_id = task.get("protecters")[0].get("id")
    else:
        logger.debug("rob_task_infos %s" % task.get("rob_task_infos"))
        player_id = task.get("rob_task_infos")[0].get("robbers")[0].get("id")
    #logger.debug("protecters[0] %s" % task.get("protecters")[0])
    remote_gate.push_object_character_remote(19081, push_response.SerializePartialToString(), [player_id])
    return {'result': True}

@remoteserviceHandle('gate')
def start_protect_escort_1909(data, player):
    """手动开始押运"""
    request = escort_pb2.StartEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    task_guild_id = request.task_guild_id
    response = escort_pb2.StartEscortTaskResponse()
    response.res.result = True

    res = start_protect_escort(player, task_guild_id, task_id)

    if not res.get("result"):
        response.res.result_no = res.get("result_no")
        return response.SerializePartialToString()
    tlog_action.log('StartProtectEscort', player, task_id, task_guild_id)
    response.res.result = res.get("result")
    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def start_rob_escort_1910(data, player):
    """手动开始劫运"""
    request = escort_pb2.StartEscortTaskRequest()
    request.ParseFromString(data)
    logger.debug("request %s" % request)
    task_id = request.task_id
    task_guild_id = request.task_guild_id
    rob_no = request.rob_no
    response = escort_pb2.StartEscortTaskResponse()
    response.res.result = True

    res = start_rob_escort(player, task_id, response, task_guild_id, rob_no)

    response.res.result = res.get("result")
    if not res.get("result"):
        response.res.result_no = res.get("result_no")
        return response.SerializePartialToString()
    logger.debug("response %s" % response)
    tlog_action.log('StartRobEscort', player, task_id, task_guild_id)
    return response.SerializePartialToString()

def start_protect_escort(player, task_guild_id, task_id):
    """docstring for start_protect_escort"""

    escort_open_time_item = game_configs.base_config.get("EscortOpenTime")
    if not is_in_period(escort_open_time_item):
        logger.error("feature not open!")
        return {'result': False, 'result_no': 30000}

    res = remote_gate["world"].start_protect_task_remote(task_guild_id, task_id)

    # 参与押运次数
    task = res.get("task")
    for no, protecter in enumerate(task.get("protecters")):
        if no == 0: continue
        push_message("remove_escort_in_times_remote", int(protecter.get("id")), 1)
    return {"result": True}

@remoteserviceHandle('gate')
def remove_escort_in_times_remote(protect_or_rob, is_online, player):
    logger.debug("remove_escort_in_times_remote========= %s" % protect_or_rob)
    if protect_or_rob == 1:
        player.escort_component.protect_times += 1
    else:
        player.escort_component.rob_times += 1
    player.escort_component.save_data()

@remoteserviceHandle('gate')
def add_guild_activity_times_remote(task_no, protect_or_rob, is_online, player):
    """
    添加活动信息
    """
    logger.debug("add_guild_activity_times_remote============%s %s" % (task_no, protect_or_rob))
    if protect_or_rob == 1:
        player.guild_activity.add_protect_escort_times(task_no)
        player.act.add_protect_escort_times(task_no)
        hook_task(player, CONDITIONId.PROTECT_ESCORT, 1)
    elif protect_or_rob == 2:
        player.guild_activity.add_rob_escort_times(task_no)
        player.act.add_rob_escort_times(task_no)
        hook_task(player, CONDITIONId.ROB_ESCORT, 1)


def start_rob_escort(player, task_id, response, task_guild_id, rob_no):
    """
    手动开始劫运
    """
    res = remote_gate["world"].start_rob_escort_remote(task_guild_id, task_id, rob_no, player.base_info.id)
    if res.get("result"):
        player.finance.consume(const.GUILD_ESCORT_ROB_TIMES, 1, const.ESCORT_ROB)
        player.finance.save_data()
        update_rob_task_info_pb(res.get("protecters", []), res.get("rob_task_info", {}), response.rob_task_info, protect_or_rob=2)
        # push info to head players
        push_response = escort_pb2.InviteEscortTaskPushResponse()
        task = res.get("task")
        update_task_pb(task, push_response.task)
        push_response.protect_or_rob = 2
        logger.debug("19101 push_response %s" % push_response)
        for player_info in res.get("rob_task_info", {}).get("robbers"):
            remote_gate.push_object_character_remote(19101, push_response.SerializePartialToString(), [player_info.get("id")])

        remote_gate.push_object_character_remote(19102, push_response.SerializePartialToString(), [task.get("protecters")[0].get("id")])
        # 参与劫运次数
        task = res.get("task")
        for no, robber in enumerate(res.get("rob_task_info", {}).get("robbers", [])):
            if res.get("rob_task_info").get("rob_result", False):
                push_message("add_guild_activity_times_remote", int(robber.get("id")), task.get("task_no"), 2)
            if no == 0: continue
            push_message("remove_escort_in_times_remote", int(robber.get("id")), 2)
    return res

#def load_data_to_response(tasks, tasks_pb):
    #"""docstring for load_data_to_response"""
    #for task_id, task in tasks.items():
        #task_pb = tasks_pb.add()
        #update_task_pb(task, task_pb)

#def update_task_pb(task, task_pb):
    #"""docstring for load_task_to_response"""
    #task_pb.task_id = task.get("task_id")
    #task_pb.task_no = task.get("task_no")
    #task_pb.state = task.get("state")
    #task_pb.receive_task_time = int(task.get("receive_task_time", 0))
    #task_pb.start_protect_time = int(task.get("start_protect_time", 0))
    #task_pb.last_send_invite_time = task.get("last_send_invite_time", 0)
    #update_guild_pb(task.get("protect_guild_info", {}), task_pb.protect_guild_info)
    #update_player_infos_pb(task.get("protecters", []), task_pb.protecters)
    ## reward
    #load_to_game_response(task.get("reward", []), task_pb.reward)

    #for rob_task_info in task.get("rob_task_infos", []):
        #rob_task_info_pb = task_pb.rob_task_infos.add()
        #update_rob_task_info_pb(task.get("protecters"), rob_task_info, rob_task_info_pb)

#def update_guild_pb(guild_info, guild_info_pb):
    #guild_info_pb.g_id = guild_info.get("id", -1)
    #guild_info_pb.rank = guild_info.get("rank", -1)
    #guild_info_pb.name = guild_info.get("name", "")
    #guild_info_pb.level = guild_info.get("level", 0)
    #guild_info_pb.president = guild_info.get("president", "")
    #guild_info_pb.p_num = guild_info.get("p_num", 0)
    #guild_info_pb.icon_id = guild_info.get("icon_id", 0)
    #guild_info_pb.call = guild_info.get("call", "")

#def update_player_infos_pb(player_infos, player_infos_pb):
    #for player_info in player_infos:
        #player_info_pb = player_infos_pb.add()
        #player_info_pb.id = player_info.get("id")
        #player_info_pb.nickname = player_info.get("nickname")
        #player_info_pb.level = player_info.get("level")
        #player_info_pb.hero_no = player_info.get("head")
        #player_info_pb.vip_level = player_info.get("vip_level")
        #player_info_pb.power = player_info.get("power")
        #player_info_pb.guild_position = player_info.get("guild_position", 0)
        #player_info_pb.hero_no = player_info.get("hero_no", 0) # 队长头像
        #player_info_pb.friend_info.level = player_info.get("level", 0)
        #player_info_pb.friend_info.break_level = player_info.get("break_level", 0)

#def update_rob_task_info_pb(protecters, rob_task_info, rob_task_info_pb, protect_or_rob=1):
    ## guild
    #update_guild_pb(rob_task_info.get("rob_guild_info"), rob_task_info_pb.rob_guild_info)
    ## robbers
    #update_player_infos_pb(rob_task_info.get("robbers"), rob_task_info_pb.robbers)
    ## protect battle units
    #update_side_battle_unit_pb(protecters, rob_task_info_pb.blue)
    #update_side_battle_unit_pb(rob_task_info.get("robbers"), rob_task_info_pb.red)
    ## seed
    #rob_task_info_pb.seed1 = rob_task_info.get("seed1", 0)
    #rob_task_info_pb.seed2 = rob_task_info.get("seed2", 0)
    ## rob reward
    #load_to_game_response(rob_task_info.get("rob_reward", []), rob_task_info_pb.rob_reward)
    ## rob_result
    #rob_task_info_pb.rob_result = rob_task_info.get("rob_result", False)
    ## rob_time
    #rob_task_info_pb.rob_time = rob_task_info.get("rob_time", 0)
    ## rob_state
    #rob_task_info_pb.rob_state = rob_task_info.get("rob_state", 0)
    ## rob_receive_task_time
    #rob_task_info_pb.rob_receive_task_time = rob_task_info.get("rob_receive_task_time", 0)
    ## rob_no
    #rob_task_info_pb.rob_no = rob_task_info.get("rob_no", 0)
    ## last_send_invite_time
    #rob_task_info_pb.last_send_invite_time = rob_task_info.get("last_send_invite_time", 0)


#def update_side_battle_unit_pb(player_infos, battle_unit_groups_pb):
    #for player_info in player_infos:
        #battle_unit_group_pb = battle_unit_groups_pb.add()
        #for no, battle_unit in cPickle.loads(player_info.get("BattleUnitGrop")).items():
            #battle_unit_pb = battle_unit_group_pb.group.add()
            #assemble(battle_unit_pb, battle_unit)

#def load_to_game_response(rewards, response):
    #return_data = []
    #for data in rewards:
        #for k, v in data.items():
            #return_data.append([k, v[0], v[2]])

    #get_return(None, return_data, response)





