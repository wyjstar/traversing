# coding: utf-8
'''
Created on 2015-4-24

@author: hack
'''
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.utils import xtime
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.game_configs import base_config

WEEK_REBATE = 0
MONTH_REBATE = 1

class OneRebate(object):
    """
    返利卡
    """
    def __init__(self):
        self._start = 0  # 返利卡购买时间
        self._last = 0  # 返利卡最后一次领取时间
        self._count = 0 #剩余次数
        self._mail = 0 #最后一次发送邮件时间
    
    def last(self):
        return self._count
    
    def can_draw(self, refresh):
        h,m,s = map(int, refresh.split(':'))
        today = xtime.today_ts()
        today_node = today+h*60*60+m*60+s
        if self._last < today_node and self._count > 0:
            return 1
        return 0
    
    def draw(self):
        self._last = xtime.timestamp()
        self._count -= 1
        
    def new_rebate(self, cont_days):
        self._start = xtime.timestamp()
        self._count += cont_days
        
    def set_mail(self):
        self._mail = self._start

class Rebate(Component):
    """
    月卡周卡
    """
    def __init__(self, owner):
        super(Rebate, self).__init__(owner)
        self._rebate = {}

    def init_data(self, character_data):
        rebate = character_data.get('rebate')
        self._rebate = rebate

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
    
    def rebate_info(self, rid):
        one_rebate =  self._rebate.get(rid, None)
        if one_rebate == None:
            one_rebate = OneRebate()
#             self._rebate[rid] = one_rebate
        return one_rebate
    
    def set_rebate(self, rid, some_rebate):
        self._rebate[rid] = some_rebate
        
    def all_rebates(self):
        rebates = []
        for rebate in self._rebate.values():
            rebates.append(rebate)
        return rebates
    
    def rebate_status(self, rebate_id, days):
        one = self._rebate.get(rebate_id, None)
        if not one:
            return 1, 0, 0
        func = None
        refresh = None
        if days == 30:
            func = 'moonCard'
            refresh = base_config['moonCardFreshTime']
        elif days == 7:
            func = 'weekCard'
            refresh = base_config['weekCardFreshTime']
        else:
            func = None
        if func == None:
            return 0, 0, 0
        formula = game_configs.formula_config.get(func).get("formula")
        all_vars = {}
        all_vars['weekCardSurplusDay'] = one._count
        switch = eval(formula, all_vars)
        last = one.last()
        can_draw = one.can_draw(refresh)
        return switch, last, can_draw
    
    def send_mail(self, rid):
        rebate = self._rebate.get(rid)
        if rebate:
            self._rebate[rid].set_mail()
            
    def need_mail(self, rid, days):
        one = self._rebate.get(rid, None)
        if not one:
            return 0
        if days == 30:
            func = 'moonCard'
        elif days == 7:
            func = 'weekCard'
        else:
            func = None
        if func == None:
            return 0, 0, 0
        formula = game_configs.formula_config.get(func).get("formula")
        all_vars = {}
        all_vars['weekCardSurplusDay'] = one._count
        switch = eval(formula, all_vars)
        if switch and one._start != one._mail:
            return 1
        return 0
        