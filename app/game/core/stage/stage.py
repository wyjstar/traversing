# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午8:43.
"""
import cPickle


class Stage(object):
    """关卡
    """
    def __init__(self, stage_id, attacks=0, state=-1):
        self._stage_id = stage_id  # 关卡编号
        self._attacks = attacks  # 攻击次数
        self._state = state  # 关卡状态 -2: 未开启 -1：开启没打过 0：输 1：赢

    @property
    def stage_id(self):
        return self._stage_id

    @property
    def attacks(self):
        return self._attacks

    @property
    def state(self):
        return self._state

    @property
    def info(self):
        return dict(stage_id=self._stage_id, attacks=self._attacks, state=self._state)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        return cls(**info)


class StageAward(object):
    """关卡奖励
    """
    def __init__(self, chapter_id, dragon_gift=-1, award_info=[]):
        self._chapter_id = chapter_id  # 章节编号
        self._award_info = award_info  # 奖励领取信息 list -1:奖励没达成 0：奖励达成没有领取 1：已经领取
        self._dragon_gift = dragon_gift  # 龙纹奖励 int -1:奖励没达成 0：奖励达成没有领取 1：已经领取

    @property
    def chapter_id(self):
        return self._chapter_id

    @property
    def award_info(self):
        return self._award_info

    @property
    def dragon_gift(self):
        return self._dragon_gift

    @property
    def info(self):
        return dict(chapter_id=self._chapter_id, award_info=self._award_info)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        return cls(**info)