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
        self._month_buy = 0
        self._last_time = 0
        self._mail_id = 0

    def init_data(self, character_data):
        rebate = character_data.get('rebate')
        month_buy = character_data.get('month_buy')
        last_time = character_data.get('last_time')
        mail_id = character_data.get('mail_id')
        self._rebate = rebate
        self._month_buy = month_buy
        self._last_time = last_time
        self._mail_id = mail_id

    def save_data(self):
        char_obj = tb_character_info.getObj(self.owner.base_info.id)
        if char_obj:
            char_obj.hset('rebate', self._rebate)
            char_obj.hset('month_buy', self._month_buy)
            char_obj.hset('last_time', self._last_time)
            char_obj.hset('mail_id', self._mail_id)
        else:
            logger.error('cant find Rebate:%s', self.owner.base_info.id)

    def new_data(self):
        rebate = dict(rebate=self._rebate, month_buy=self._month_buy, last_time=self._last_time, mail_id=self._mail_id)
        return rebate
    
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
        for rebate in self._rebate.keys():
            rebates.append(rebate)
        return rebates
    
    def rebate_status(self, rebate_id, days):
        one = self._rebate.get(rebate_id, None)
        if not one:
            return 1, 0, 0
        func = None
        refresh = None
        param = None
        if days == 30:
            func = 'moonCard'
            refresh = game_configs.base_config['moonCardFreshTime']
            param = 'moonCardSurplusDay'
        elif days == 7:
            func = 'weekCard'
            refresh = game_configs.base_config['weekCardFreshTime']
            param = 'weekCardSurplusDay'
        else:
            func = None
        if func == None:
            return 0, 0, 0
        formula = game_configs.formula_config.get(func).get("formula")
        all_vars = {}
        all_vars[param] = one._count
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
        # if days == 30:
        #     func = 'moonCard'
        #     param = 'moonCardSurplusDay'
        # elif days == 7:
        #     func = 'weekCard'
        #     param = 'weekCardSurplusDay'
        # else:
        #     func = None
        # if func == None:
        #     return 0, 0, 0
        # formula = game_configs.formula_config.get(func).get("formula")
        # all_vars = {}
        # all_vars[param] = one._count
        # switch = eval(formula, all_vars)
        switch = 0
        if one._count == game_configs.base_config['moonCardRemindDays']:
            switch = 1
        if switch and one._start != one._mail:
            return 1
        return 0
        
    def month_start(self, mail_id):
        if self._month_buy == 0:
            self._month_buy = xtime.timestamp()
            self._mail_id = mail_id
    
    def month_mails(self):
        tomorrow_ts = xtime.tomorrow_ts()
        mail_times = 0
        if self._month_buy != 0:
            while True:
                if self._last_time == 0:
                    mail_times += 1
                    self._last_time = self._month_buy
                    
                elif self._last_time + 24*60*60 < tomorrow_ts:
                    mail_times += 1
                    self._last_time += 24*60*60
                else:
                    break
        return self._mail_id, mail_times
    
