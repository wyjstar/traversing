# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午8:43.
"""
import cPickle
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger


class Stage(object):
    """关卡
    """
    def __init__(self, stage_id, attacks=0, state=-1, reset=[0, 1],
                 drop_num=0):
        self._stage_id = stage_id   # 关卡编号
        self._attacks = attacks     # 攻击次数
        self._state = state         # 关卡状态 -2: 未开启 -1：已开启但没打 0：输 1：赢
        self._reset = reset         # 次数重置 【重置次数， 时间】
        self._drop_num = drop_num   # 本关卡掉落包数量, 当战斗失败时设置,防止玩家强退，来刷最大掉落数

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
    def drop_num(self):
        return self._drop_num

    @drop_num.setter
    def drop_num(self, drop_num):
        self._drop_num = drop_num

    @property
    def info(self):
        return dict(stage_id=self._stage_id, attacks=self._attacks,
                    state=self._state, reset=self._reset,
                    drop_num=self._drop_num)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        return cls(**info)

    def update(self, result):
        """更新攻击次数和关卡状态
        """
        self._drop_num = 0  # 结算时清空drop_num
        if result:  # win
            self._attacks += 1  # 攻击次数+1
            self._state = 1  # 状态赢
        else:
            self._state = 0


class StageAward(object):
    """关卡奖励
    """
    def __init__(self, chapter_id, dragon_gift=-1, award_info=[]):
        self._chapter_id = chapter_id  # 章节编号
        self._award_info = award_info  # 奖励领取信息 list -1:奖励没达成 0：奖励达成没有领取 1：已经领取
        self._dragon_gift = dragon_gift  # 龙纹奖励 int -1:奖励没达成 0：奖励达成没有领取 1：已经领取
        self._already_gift = []  # 已领奖励

    @property
    def chapter_id(self):
        return self._chapter_id

    @property
    def award_info(self):
        if not self._award_info:
            self.update(0)
        return self._award_info

    @property
    def dragon_gift(self):
        return self._dragon_gift

    @dragon_gift.setter
    def dragon_gift(self, v):
        self._dragon_gift = v

    @property
    def info(self):
        return dict(chapter_id=self._chapter_id, award_info=self._award_info,
                    dragon_gift=self._dragon_gift)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        return cls(**info)

    def update(self, star_num):
        """根据星星数量更新奖励信息
        """
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
        if self._dragon_gift == -1:
            if self._award_info[-1] != -1:
                self._dragon_gift = 0

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
        return stage
