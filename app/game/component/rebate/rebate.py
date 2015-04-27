# coding: utf-8
'''
Created on 2015-4-24

@author: hack
'''
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data.game_configs import base_config
from shared.utils import xtime

WEEK_REBATE = 0
MONTH_REBATE = 1

class OneRebate(object):
    """
    返利卡
    """
    def __init__(self):
        self._start = 0  # 返利卡购买时间
        self._last = 0  # 返利卡最后一次领取返利时间
        self._count = 0 #领取次数
    
    def end_time(self, cont_days):
        return self._start + cont_days*24*60*60
    
    def can_draw(self, cont_days, refresh_time):
        now = xtime.timestamp()
        end = self.end_time(cont_days)
        if now > end:
            return False
        today = xtime.today_ts()
        if self._last > today: 
            return False #今日已领取
        h, m, s = map(int, refresh_time.split(':')) #刷新时间
        today_refresh = today + h*60*60 + m*60+s
        if now < today_refresh: #未刷新
            return False
    
    def draw(self):
        self._last = xtime.timestamp()

class Rebate(Component):
    """
    月卡周卡
    """
    def __init__(self, owner):
        super(Rebate, self).__init__(owner)
        self._rebate = {}

    def init_data(self, character_data):
        rebate = character_data.get('rebate')
        self._rebate[WEEK_REBATE] = rebate.get('week')
        self._rebate[MONTH_REBATE] = rebate.get('month')

    def save_data(self):
        char_obj = tb_character_info.getObj(self.owner.base_info.id)
        if char_obj:
            rebate = dict(rebate=self._rebate)
            char_obj.hset('rebate', rebate)
        else:
            logger.error('cant find Rebate:%s', self.owner.base_info.id)

    def new_data(self):
        rebate = dict(rebate=self._rebate)
        return {'rebate': rebate}
    
    def rebate_info(self, some):
        return self._rebate[some]
    
    def set_rebate(self, rtype, some_rebate):
        self._rebate[rtype] = some_rebate
        