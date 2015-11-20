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
from app.game.component.character_escort import Guild
from gfirefly.server.globalobject import GlobalObject
from app.game.action.node._fight_start_logic import get_seeds
from app.game.action.node._fight_start_logic import pvp_process
from app.game.core.mail_helper import send_mail


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def get_all_task_info_1901(pro_data, player):
    """取得所有押运信息"""
    response = escort_pb2.GetEscortTasksResponse()
    escort_component = player.escort_component

    response.start_protect_times = escort_component.start_protect_times
    response.protect_time = escort_component.protect_time
    response.rob_times = escort_component.rob_times
    response.refresh_times = escort_component.refresh_times

    for task in escort_component.tasks:
        task_pb = response.tasks.add()
        task.update_pb(task_pb)

    send_reward_when_task_finish(player)
    return response.SerializePartialToString()

def send_reward_when_task_finish(player):
    """任务完成后发奖"""
    for task_id in player.escort_component.protect_records:
        task = Guild().get_task_by_id(task_id)
        task_item = game_configs.guild_task_config.get(task.task_no)
        if task.is_finished(task_item):
            protecters_num = len(task.protecters)
            peoplePercentage = task_item.peoplePercentage.get(protecters_num)
            robbedPercentage = 0
            for t in range(task.rob_success_times()):
                robbedPercentage = robbedPercentage + task_item.robbedPercentage.get(t+1)


            robbedPercentage = task_item.robbedPercentage.get(task.rob_success_times())
            logger.debug("peoplePercentage protecters_num robbedPercentage %s %s %s" % (peoplePercentage, protecters_num, robbedPercentage))
            escort_formula = game_configs.formula_config.get("EscortReward").get("formula")
            assert escort_formula!=None, "snatch_formula can not be None!"
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

    if record_type == 1: # 我的押运记录
        for task_id in escort_component.protect_records:
            task = Guild().get_task_by_id(task_id)
            task_pb = response.tasks.add()
            task.update_pb(task_pb)

    elif record_type == 2: # 我的劫运记录
        for task_id in escort_component.rob_records:
            task = Guild().get_task_by_id(task_id)
            task_pb = response.tasks.add()
            task.update_pb(task_pb)
    elif record_type == 3: # 军团押劫记录
        pass
        # todo:

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def refresh_can_rob_tasks_1903(data, player):
    """可劫运任务"""
    response = escort_pb2.RefreshEscortTaskResponse()
    response.res.result = True

    #todo: 从军团总任务池中获取可劫任务

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def refresh_tasks_1904(data, player):
    """刷新任务列表"""
    response = escort_pb2.RefreshEscortTaskResponse()
    response.res.result = True
    escort_component = player.escort_component

    if escort_component.refresh_times > game_configs.base_config.get("EscortRefreshFrequencyMax"):
        logger.error("reach the max refresh time!")
        response.res.result = False
        response.res.result_no = 190401
        return response.SerializePartialToString()

    price = game_configs.base_config.get("EscortRefreshPrice")
    need_gold = price[escort_component.refresh_times]

    def func():
        escort_component.refresh_tasks() #刷新任务
        escort_component.save_data()
        for task in escort_component.tasks:
            task_pb = response.tasks.add()
            task.update_pb(task_pb)
    player.pay.pay(need_gold, const.REFRESH_ESCORT_TASKS, func)

    logger.debug("response %s" % response)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def receive_escort_task_1905(data, player):
    """接受押运、劫运任务"""
    request = escort_pb2.EscortTaskRequest()
    logger.debug("request %s" % request)
    task_id = request.task_id
    protect_or_rob = request.protect_or_rob

    response = common_pb2.CommonResponse()

    res = None
    if protect_or_rob == 1:
        res = receive_protect_task(player, task_id)
    elif protect_or_rob == 2:
        res = receive_rob_task(player, task_id)

    if not res.get('result'):
        response.result_no = res.get('result_no')
    response.result = res.get('result')
    return response.SerializePartialToString()

def receive_protect_task(player, task_id):
    """接受保护任务"""
    escort_component = player.escort_component
    task = escort_component.tasks.get(task_id)
    if not task:
        logger.error("can't find this task!")
        return {'result': False, 'result_no': 190501}

    task.state = 1
    task.add_player(player, 1)
    escort_component.protect_records.append[task.task_id]
    escort_component.save_data()
    Guild().add_task(task)
    Guild().save_data()
    return {'result': True}

def receive_rob_task(player, task_id):
    """
    接受劫运任务
    """
    escort_component = player.escort_component
    task = Guild().get_task_by_id(task_id)
    if task.state != 2:
        logger.error("task state not right! %s" % task.state)
        return {'result': False, 'result_no': 190901}
    if player.base_info.id in task.rob_task_infos:
        logger.debug("this task has been robbed!")
        return {'result': False, 'result_no': 190902}
    escort_component.rob_records.append[task.task_id]
    escort_component.save_data()

    task.add_player(player, 2)
    Guild().save_data()
    return {'result': True}

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
    # todo: send invite to guild
    return {'result': True}

def in_invite(player, task_id, protect_or_rob):
    """
    参与邀请
    """
    # get task from guild
    task = Guild().get_task_by_id(task_id)
    # add CharacterInfo to the task
    task.add_player(player, protect_or_rob)
    # push info to related players
    push_response = escort_pb2.InviteEscortTaskPushResponse()
    task.update_pb(push_response.task)
    push_response.protect_or_rob = protect_or_rob
    remote_gate.push_object_remote(19081, push_response.SerializePartialToString(), player.base_info.id)
    return {'result': True}

@remoteserviceHandle('gate')
def start_escort_1909(data, player):
    """手动开始押运或者劫运"""
    request = escort_pb2.StartEscortTaskRequest()
    request.ParseFromString(data)
    task_id = request.task_id
    protect_or_rob = request.protect_or_rob
    response = common_pb2.StartEscortTaskResponse()
    response.res.result = True
    escort_component = player.escort_component
    task = Guild().get_task_by_id(task_id)

    if protect_or_rob == 1:
        start_protect_escort(escort_component, task)
    elif protect_or_rob == 2:
        rob_task_info = task.rob_task_infos.get(player.base_info.id)
        start_rob_escort(player, rob_task_info)
        task.update_rob_task_info_pb(rob_task_info, response.rob_task_info)

    return response.SerializePartialToString()

def start_protect_escort(escort_component, task):
    """docstring for start_protect_escort"""
    if task.state != 1:
        logger.error("task state not right! %s" % task.state)
        return {'result': False, 'result_no': 190901}
    task.state = 2
    task.start_protect_time = get_current_timestamp()
    Guild().save_data()
    return {"result": True}

def start_rob_escort(player, task):
    """
    手动开始劫运
    """
    # construct battle units
    # update rob task
    #escort_component = player.escort_component
    task_item = game_configs.guild_task_config.get(task.task_no)
    rob_task_info = task.rob_task_infos.get(player.base_info.id)
    seed1, seed2 = get_seeds()
    rob_task_info["seed1"] = seed1
    rob_task_info["seed2"] = seed2
    # pvp battle
    rob_result = pvp_process(player, None, task.red_groups, task.blue_groups,
                               None, None,
                               None, None,
                               seed1, seed2,
                               const.BATTLE_GUILD)

    rob_task_info["rob_result"] = rob_result
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


    Guild().save_data()
