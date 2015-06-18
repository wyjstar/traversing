# -*- coding:utf-8 -*-
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.achievement_config import TaskType
from app.game.redis_mode import tb_character_info
import random
import time
import cPickle


class TaskStatus:
    RUNNING = 1
    COMPLETE = 2
    FINISHED = 3


class EventType:
    1  # 通过指定关卡  关卡ID 通过次数
    2  # 达到指定等级  玩家等级
    3  # 邀请好友成功  邀请成功的用户数量
    STAGE_1 = 4  # 完成任意剧情关卡  完成次数
    STAGE_2 = 5  # 完成任意副本关卡  完成次数
    6  # 拥有绿色武将  拥有个数
    7  # 拥有蓝色武将  拥有个数
    8  # 拥有紫色武将  拥有个数
    9  # 拥有绿色装备  拥有个数
    10  # 拥有蓝色装备 拥有个数
    11  # 拥有紫色装备 拥有个数
    12  # 上缴需求道具 物品ID 上缴个数
    SPORTS = 13  # 竞技场争夺 完成次数
    14  # 雇佣好友助战 完成次数
    PRESENT = 15  # 赠送好友体力 完成次数
    16  # 接受好友赠送体力 完成次数
    17  # 加入公会 完成次数
    STAGE_3 = 18  # 完成任意活动关卡 完成次数
    WINE = 19  # 煮酒 完成次数
    MAGIC = 20  # 探索秘境 完成次数
    WORD = 21  # 收获符文 完成次数
    TRAVEL = 22  # 游历 完成次数
    BOSS = 23  # 攻打世界BOSS 完成次数
    LIVELY = 24  # 达到指定活跃度值 活跃度值


class CountEvent:
    events = [EventType.STAGE_1, EventType.STAGE_2, EventType.SPORTS,
              EventType.PRESENT, EventType.STAGE_3, EventType.WINE,
              EventType.MAGIC, EventType.WORD, EventType.TRAVEL,
              EventType.BOSS, EventType.LIVELY]

    @classmethod
    def create_event(cls, eventid, count, ifadd=False):
        return {'eventid': eventid, 'count': count, 'ifadd': ifadd}


class JudeEvent:
    AND = 1
    OR = 2


class TaskEvents(object):
    def __init__(self, taskid):
        self._taskid = taskid
        self._events = []
        self._status = TaskStatus.RUNNING

    def add_event(self, event):
        self._events.append(event)

    def check(self, data):
        if self._status != TaskStatus.RUNNING:
            return []
        data['taskid'] = self._taskid
        task = game_configs.achievement_config.get(self._taskid)
        jude = True if task.composition == JudeEvent.AND else False
        for event in self._events:
            ret = event.check(data)
            if task.composition == JudeEvent.AND:
                jude = ret and jude
            else:
                jude = jude or ret
        if jude:
            self._status = TaskStatus.COMPLETE
            return [self._taskid,
                    task.condition[self._events[0]._seq][1],
                    task.condition[self._events[0]._seq][1],
                    self._status]
        else:
            return [self._taskid,
                    self._events[0]._current,
                    task.condition[self._events[0]._seq][1],
                    self._status]

    def status(self):
        task = game_configs.achievement_config.get(self._taskid)
        if not task:
            return []
        if self._status != TaskStatus.RUNNING:
            return [self._taskid,
                    task.condition[self._events[0]._seq][1],
                    task.condition[self._events[0]._seq][1],
                    self._status]
        else:
            return [self._taskid,
                    self._events[0]._current,
                    task.condition[self._events[0]._seq][1],
                    self._status]


class TaskEvent(object):
    def __init__(self):
        self._eventid = 0
        self._seq = -1
        self._current = 0
        self._event_status = 0

    def check(self, data):
        print 'TaskEvent.check'
        pass

    def check_count(self, data, event):
        """
        任务的条件类型是次数的检查
        """
        task_id = data['taskid']
        task = game_configs.achievement_config.get(task_id)
        one_cond = task.condition.get(event._seq)
        if event._eventid != one_cond[0]:
            return True if event._event_status != TaskStatus.Running else False
        if event._current >= one_cond[1]:
            return True
        ifadd = data.get('ifadd')
        adddata = data.get('count')
        if event._eventid in CountEvent.events:
            if ifadd:
                event._current += adddata
            else:
                if adddata > event._current:
                    event._current = adddata
        print 'event._current', event._current
        if event._current >= one_cond[1]:
            event._event_status = TaskStatus.COMPLETE
            return True
        return False

    @classmethod
    def create(cls, eventtype, seq):
        clsname = 'SubEvent%s' % eventtype
        sub_event = eval(clsname)()
        sub_event._eventid = eventtype
        sub_event._seq = seq
        return sub_event


class SubEvent1(TaskEvent):
    def check(self, data):
        pass


class SubEvent2(TaskEvent):
    def check(self, data):
        pass


class SubEvent3(TaskEvent):
    def check(self, data):
        pass


class SubEvent4(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent5(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent6(TaskEvent):
    def check(self, data):
        pass


class SubEvent7(TaskEvent):
    def check(self, data):
        pass


class SubEvent8(TaskEvent):
    def check(self, data):
        pass


class SubEvent9(TaskEvent):
    def check(self, data):
        pass


class SubEvent10(TaskEvent):
    def check(self, data):
        pass


class SubEvent11(TaskEvent):
    def check(self, data):
        pass


class SubEvent12(TaskEvent):
    def check(self, data):
        pass


class SubEvent13(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent14(TaskEvent):
    def check(self, data):
        pass


class SubEvent15(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent16(TaskEvent):
    def check(self, data):
        pass


class SubEvent17(TaskEvent):
    def check(self, data):
        pass


class SubEvent18(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent19(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent20(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent21(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent22(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent23(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class SubEvent24(TaskEvent):
    def check(self, data):
        return self.check_count(data, self)


class UserAchievement(Component):
    def __init__(self, owner=None):
        Component.__init__(self, owner)
        self._tasks = {}
        self._lively = 0
        self._event_task_map = {}
        self._last_day = ''
        self._update = False

    def init_data(self, character_info):
        tasks = character_info.get('tasks')
        all_tasks = tasks.get('1')
        if all_tasks:
            self._tasks = cPickle.loads(all_tasks)
        else:
            self._tasks = {}
        self._lively = character_info.get('lively')
        self._event_task_map = character_info.get('event_map')
        self._last_day = character_info.get('last_day')

    def save_data(self):
        lively_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = {'tasks': {'1': cPickle.dumps(self._tasks)},
                'lively': self._lively,
                'event_map': self._event_task_map,
                'last_day': self._last_day}
        lively_obj.hmset(data)

    def new_data(self):
        data = dict(tasks={'1': cPickle.dumps(self._tasks)},
                    lively=self._lively,
                    event_map=self._event_task_map,
                    last_day=self._last_day)
        return data

    def _reset(self):
        self._tasks = {}
        self._lively = 0
        self._event_task_map = {}
        self._last_day = time.strftime("%Y%m%d", time.localtime(time.time()))
        self._update = True

    def routine(self):
        for task_id in game_configs.achievement_config.keys():
            task = game_configs.achievement_config[task_id]
            if task_id not in self._tasks:
                task_event = TaskEvents(task_id)
                for seq in task.condition.keys():
                    cond = task.condition[seq]
                    etype = cond[0]
                    one_event = TaskEvent.create(etype, seq)
                    task_event.add_event(one_event)
                    if etype not in self._event_task_map:
                        self._event_task_map[etype] = [task_id]
                    else:
                        if task_id not in self._event_task_map[etype]:
                            self._event_task_map[etype].append(task_id)

                self._tasks[task_id] = task_event
                self._update = True

        for task_id in self._tasks.keys():
            if task_id not in game_configs.achievement_config:
                del self._tasks[task_id]
                self._update = True

    def _refresh(self):
        now = time.strftime("%Y%m%d", time.localtime(time.time()))
        if now != self._last_day or len(self._tasks) == 0:
            self._reset()
            self.routine()

    def lively_count(self):
        """
        统计活跃度获得
        """
        lively_add = 0
        for task_id in self._tasks:
            task = game_configs.achievement_config.get(task_id)
            if task and task.sort == TaskType.LIVELY:
                if self._tasks[task_id]._status == TaskStatus.COMPLETE:# or self._tasks[task_id]._status == TaskStatus.FINISHED:
                    lively_add += random.randint(task.reward['17'][0], task.reward['17'][1])
                    self._tasks[task_id]._status = TaskStatus.FINISHED
                    self._update = True

        self._lively += lively_add
        print 'lively_count', self._lively
        return self._lively

    def check_inter(self, event):
        """
        任务检查借口,event根据CountEvent.create_event创建
        """
        self._refresh()
        if not event:
            return []
        status_change = self.check_task(event)
        lively = self.lively_count()
        lively_event = CountEvent.create_event(EventType.LIVELY, lively, ifadd=False)
        lively_change = self.check_task(lively_event)
        return status_change + lively_change

    def check_task(self, event):
        eid = event['eventid']
        status = []
        if eid in self._event_task_map:
            for task_id in self._event_task_map[eid]:
                if task_id in self._tasks:
                    task_status = self._tasks[task_id].check(event)
                    if task_status:
                        status.append(task_status)
        return status

    def task_status(self):
        """
        查询状态,首次登陆
        """
        self._refresh()
        ret_status = []
        for tid in self._tasks:
            task_status = self._tasks[tid].status()
#             if task_status:
            ret_status.append(task_status)
        return ret_status

    def reward(self, task_id):
        """
        领取任务奖励
        判断是否能领奖
        """
        if task_id in self._tasks and task_id in game_configs.achievement_config:
            if self._tasks[task_id]._status == TaskStatus.COMPLETE:
                self._tasks[task_id]._status = TaskStatus.FINISHED
                return 0
            else:
                return self._tasks[task_id]._status
        return -1

    def debug(self):
        print 'user_achievement.debug'
        print self.__dict__
