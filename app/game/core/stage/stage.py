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
        self._state = state  # 关卡状态 -1：开启没打过 0：输 1：赢

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
    def __init__(self, chapter_id, award_info=[]):
        self._chapter_id = chapter_id  # 章节编号
        self._award_info = award_info  # 奖励领取信息 0：没有领取 1：已经领取

    @property
    def info(self):
        return dict(chapter_id=self._chapter_id, award_info=self._award_info)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        return cls(**info)