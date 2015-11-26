# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午8:43.
"""
import cPickle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
import time
import random


class Stage(object):
    """关卡
    """
    def __init__(self, stage_id, attacks=0, state=-1, reset=None,
                 drop_num=0, chest_state=0, star_num=0, attack_times=0,
                 elite_drop2_info=None, elite_drop_times=0):
        self._stage_id = stage_id   # 关卡编号
        self._attacks = attacks     # 攻击次数
        self._state = state         # 关卡状态 -2: 未开启 -1：已开启但没打 0：输 1：赢
        self._chest_state = chest_state         # 关卡宝箱状态 0: 未开启 1：已开启
        self._reset = reset if reset else [0, int(time.time())]  # 次数重置 [重置次数， 时间]
        self._drop_num = drop_num   # 本关卡掉落包数量, 当战斗失败时设置,防止玩家强退，来刷最大掉落数
        self._star_num = star_num  # 通关关卡后得到的星星数量 0-3

        self._attack_times = attack_times  # 通关次数， 用来计算掉落
        self._elite_drop2_info = elite_drop2_info if elite_drop2_info else [] # 保底包 掉落信息 [0，0，0，0，0，1，0]
        self._elite_drop_times = elite_drop_times  # 随机精英包本周期内已经掉落次数

    def have_elite_drop(self, stage_conf):
        """
        """
        drop1_state = 0
        drop2_state = 0
        if self._attack_times == stage_conf.eliteDropFrequency or not self._elite_drop2_info:
            self._attack_times = 0
            self._elite_drop_times = 0
            self._elite_drop2_info = [0] * stage_conf.eliteDropFrequency
            num = random.randint(stage_conf.Lowerlimit, stage_conf.Upperlimit)
            for _ in range(num):
                for _ in range(num):
                    x = random.randint(0, stage_conf.eliteDropFrequency-1)
                    if not self._elite_drop2_info[x]:
                        self._elite_drop2_info[x] = 1
                        break
        if self._elite_drop2_info[self._attack_times]:
            drop2_state = 1
        if self._elite_drop_times < stage_conf.SpecialDropmax:
            drop1_state = 1
        self._attack_times += 1
        return drop1_state, drop2_state

    @property
    def elite_drop2_info(self):
        return self._elite_drop2_info

    @elite_drop2_info.setter
    def elite_drop2_info(self, v):
        self._elite_drop2_info = v

    @property
    def elite_drop_times(self):
        return self._elite_drop_times

    @elite_drop_times.setter
    def elite_drop_times(self, v):
        self._elite_drop_times = v

    @property
    def attack_times(self):
        return self._attack_times

    @attack_times.setter
    def attack_times(self, v):
        self._attack_times = v

    @property
    def stage_id(self):
        return self._stage_id

    @property
    def reset(self):
        return self._reset

    @reset.setter
    def reset(self, v):
        self._reset = v

    @property
    def attacks(self):
        return self._attacks

    @attacks.setter
    def attacks(self, attacks):
        self._attacks = attacks

    @property
    def state(self):
        return self._state

    @state.setter
    def state(self, state):
        self._state = state

    @property
    def chest_state(self):
        return self._chest_state

    @chest_state.setter
    def chest_state(self, v):
        self._chest_state = v

    @property
    def drop_num(self):
        return self._drop_num

    @drop_num.setter
    def drop_num(self, drop_num):
        self._drop_num = drop_num

    @property
    def star_num(self):
        return self._star_num

    @star_num.setter
    def star_num(self, v):
        self._star_num = v

    @property
    def info(self):
        return dict(stage_id=self._stage_id, attacks=self._attacks,
                    state=self._state, reset=self._reset,
                    drop_num=self._drop_num, chest_state=self._chest_state,
                    star_num=self._star_num, attack_times=self._attack_times,
                    elite_drop2_info=self._elite_drop2_info,
                    elite_drop_times=self._elite_drop_times)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        return cls(**info)

    def update(self, result, num):
        """更新攻击次数和关卡状态
        """
        self._drop_num = 0  # 结算时清空drop_num
        if result:  # win
            self._attacks += 1  # 攻击次数+1
            self._state = 1  # 状态赢
            if num > self._star_num:
                self.star_num = num
        # else:
        #     self._state = 0


class StageAward(object):
    """关卡奖励
    """
    def __init__(self, chapter_id, star_gift=-1, award_info=None,
                 now_random=0, random_gift_times=0):
        self._chapter_id = chapter_id  # 章节编号

        # 奖励领取信息 list -1:奖励没达成 0：奖励达成没有领取 1：已经领取
        self._award_info = award_info if award_info else []
        self._star_gift = star_gift  # -1:未达成 1:已领取 2已经放弃 3：未处理
        self._now_random = now_random  # 现在的星级抽奖随机值，0为未随机
        self._random_gift_times = random_gift_times  # 获取随机值的次数，用来计算梯度费用

    @property
    def random_gift_times(self):
        return self._random_gift_times

    @random_gift_times.setter
    def random_gift_times(self, v):
        self._random_gift_times = v

    @property
    def chapter_id(self):
        return self._chapter_id

    @property
    def award_info(self):
        if not self._award_info:
            self.update(0)
        return self._award_info

    @property
    def star_gift(self):
        return self._star_gift

    @star_gift.setter
    def star_gift(self, v):
        self._star_gift = v

    @property
    def now_random(self):
        return self._now_random

    @now_random.setter
    def now_random(self, v):
        self._now_random = v

    @property
    def info(self):
        return dict(chapter_id=self._chapter_id, award_info=self._award_info,
                    star_gift=self._star_gift, now_random=self._now_random,
                    random_gift_times=self._random_gift_times)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        return cls(**info)

    def update(self, star_num):
        """根据星星数量更新奖励信息
        """
        # 奖励领取信息 list -1:奖励没达成 0：奖励达成没有领取 1：已经领取
        award_info = self.check(star_num)
        if self._award_info:  # 领取奖励信息存在
            curr_award_info = []
            for curr_info, old_info in zip(award_info, self._award_info):
                if old_info == 0 or old_info == 1:  # 奖励没有领取或者已经领取完成
                    curr_award_info.append(old_info)
                else:
                    if curr_info == 0:
                        curr_award_info.append(curr_info)
                    else:
                        curr_award_info.append(old_info)
            self._award_info = curr_award_info
        else:
            self._award_info = award_info
        if not self._award_info:
            return
        if self._star_gift == -1:
            if self._award_info[-1] != -1:
                self._star_gift = 3

    def check(self, star_num):
        """根据星星数量判断是否能领取奖励
        """
        award_info = []  # 奖励可以领取状态

        stage = self.get_conf()
        star = stage.star
        for value in star:
            if star_num >= value:  # 可以领奖
                award_info.append(0)
            else:
                award_info.append(-1)  # 没达成

        return award_info

    def get_conf(self):
        stage = None  # 章节配置数据
        stages_config = game_configs.stage_config.get('stages')
        for stage_id, item in stages_config.items():
            if item.sectionCount and item.chapter ==\
                    self._chapter_id and item.chaptersTab:
                stage = item
                break
        if not stage:
            pass
        return stage
