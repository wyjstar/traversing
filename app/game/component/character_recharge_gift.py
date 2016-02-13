# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
import time
from shared.utils.const import const
from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import get_return
from app.game.core.item_group_helper import gain
from shared.tlog import tlog_action
from app.game.core.rebate_fun import rebate_call
from app.game.core.mail_helper import send_mail
from app.game.core.activity import target_update

RECHARGE_GIFT_TYPE = [7, 8, 9, 10]


class CharacterRechargeGift(Component):
    def __init__(self, owner):
        super(CharacterRechargeGift, self).__init__(owner)
        self._recharge = {}

    def init_data(self, character_info):
        self._recharge = character_info.get('recharge', {})
        self.check_time()

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        activity.hset('recharge', self._recharge)
        self.check_time()

    def new_data(self):
        return {'recharge': self._recharge}

    def check_time(self):
        for activity_id, activity_data in self._recharge.items():
            activity = game_configs.activity_config.get(activity_id)
            if activity is None:
                del self._recharge[activity_id]
                continue

    def charge(self, recharge):
        # 保存首次充值id
        # vip
        # 活动
        for gift_type in RECHARGE_GIFT_TYPE:
            activitys = game_configs.activity_config.get(gift_type)
            if activitys is None:
                logger.debug('activity type is not exist:%s', gift_type)
                continue
            for activity in activitys:
                self.type_process(activity, recharge)

        self.save_data()
        logger.debug(self._recharge)

    def type_process(self, activity, recharge):
        activity_id = activity.get('id')

        _time_now_struct = time.localtime()
        str_time = '%s-%s-%s 00:00:00' % (_time_now_struct.tm_year,
                                          _time_now_struct.tm_mon,
                                          _time_now_struct.tm_mday)
        _date_now = int(time.mktime(time.strptime(str_time,
                                                  '%Y-%m-%d %H:%M:%S')))
        _time_now = int(time.time())

        if not self.owner.act.is_activiy_open(activity_id):
            logger.debug('activity:not in time:%s', activity_id)
            return

        gift_type = activity.get('type')
        if gift_type == 7:  # first time recharge
            if activity_id in self._recharge:
                logger.debug('recharge first is exist:%s:%s', activity_id,
                             self._recharge[activity_id])
            else:
                self._recharge[activity_id] = {_time_now: 0}

        if gift_type == 8:  # single recharge
            # if recharge == activity.get('parameterA') or (activity.get('id') != 8010 and recharge > activity.get('parameterA')):
            if recharge == activity.get('parameterA'):
                if activity_id not in self._recharge:
                    self._recharge[activity_id] = {}
                # if len(self._recharge[activity_id]) < activity.get(
                #         'repeat') or activity.get('repeat') == -1:
                self._recharge[activity_id].update({_time_now: recharge})
                # else:
                #     logger.debug('over activity repeat times:%s(%s)',
                #                  self._recharge, activity.get('repeat'))

        if gift_type == 9:  # accumulating recharge
            accumulating = 0
            switch = 0
            if activity_id in self._recharge:
                accumulating, switch = self._recharge[activity_id].items()[0]
            accumulating += recharge
            self._recharge[activity_id] = {accumulating: switch}

        if gift_type == 10:
            if recharge == int(activity.get('parameterA')):
                if activity_id not in self._recharge:
                    self._recharge[activity_id] = {}

                if _date_now not in self._recharge[activity_id].keys():
                    self._recharge[activity_id][_date_now] = 0

    def get_data(self, response):
        print self._recharge, type(self._recharge)
        _time_now_struct = time.localtime()
        str_time = '%s-%s-%s 00:00:00' % (_time_now_struct.tm_year,
                                          _time_now_struct.tm_mon,
                                          _time_now_struct.tm_mday)
        _date_now = int(time.mktime(time.strptime(str_time,
                                                  '%Y-%m-%d %H:%M:%S')))
        for recharge_id, recharge_data in self._recharge.items():
            print recharge_id, recharge_data, '========================recharege gift get data'
            activity = game_configs.activity_config.get(recharge_id)
            if activity is None:
                logger.debug('activity id:%s not exist', recharge_id)
                break
            item = response.recharge_items.add()
            item.gift_id = recharge_id
            item.gift_type = activity.get('type')
            for k, v in recharge_data.items():
                if item.gift_type == 7:
                    _data = item.data.add()
                    _data.is_receive = v
                    _data.recharge_time = k
                if item.gift_type == 10:
                    if k == _date_now:
                        _data = item.data.add()
                        _data.is_receive = v
                        _data.recharge_time = k
                if item.gift_type == 8:
                    _data = item.data.add()
                    _data.is_receive = v
                    _data.recharge_time = k
                    _data.recharge_accumulation = v
                    if _data.recharge_accumulation == 0:
                        _data.is_receive = 1
                elif item.gift_type == 9:
                    _data = item.data.add()
                    _data.is_receive = v
                    _data.recharge_accumulation = k

    def take_gift(self, recharge_items, response):
        for recharge_item in recharge_items:
            if recharge_item.gift_id not in self._recharge:
                logger.error('recharge id:%s is not exist:%s',
                             recharge_item.gift_id, self._recharge)
                response.res.result = False
                return
            recharge_data = self._recharge[recharge_item.gift_id]
            for data in recharge_item.data:
                if recharge_item.gift_type == 8 and data.recharge_time in recharge_data:
                    if recharge_data[data.recharge_time] == 0:
                        response.res.result = False
                        logger.error('take recharge repeat:%s', recharge_data)
                        break

                    self._get_activity_gift(recharge_item.gift_id, response)
                    recharge_data[data.recharge_time] = 0
                    if not recharge_data:
                        del self._recharge[recharge_item.gift_id]
                elif data.recharge_time in recharge_data and\
                        recharge_data[data.recharge_time] == 0:
                    self._get_activity_gift(recharge_item.gift_id, response)
                    recharge_data[data.recharge_time] = 1
                elif data.recharge_accumulation in recharge_data and\
                        recharge_data[data.recharge_accumulation] == 0:
                    self._get_activity_gift(recharge_item.gift_id, response)
                    recharge_data[data.recharge_accumulation] = 1
                else:
                    response.res.result = False
                    logger.error('error recharge taken:%s:%s', recharge_item,
                                 self._recharge)

        logger.debug(self._recharge)

    def _get_activity_gift(self, activity_id, response):
        activity = game_configs.activity_config.get(activity_id)
        return_data = gain(self.owner, activity.get('reward'),
                           const.RECHARGE)  # 获取
        get_return(self.owner, return_data, response.gain)

    def get_recharge_response(self, response):
        """docstring for get_response"""
        response.gold = self._owner.finance.gold
        response.vip_level = self._owner.base_info.vip_level
        response.recharge = self._owner.base_info.recharge

    def send_mail(self, recharge_item):
        mail_id = recharge_item.get('mailId')
        send_mail(conf_id=mail_id, receive_id=self._owner.base_info.id)

    def recharge_gain(self,
                      recharge_item,
                      response,
                      channel,
                      is_tencent=False):
        """
        充值掉落
        """
        logger.debug("recharge_gain========1")
        isfirst = 0
        if not is_tencent:
            return_data = gain(self._owner, recharge_item.get('setting'),
                               const.RECHARGE)  # 获取
            get_return(self._owner, return_data, response.gain)
        if recharge_item.get('type') == 2:
            logger.debug("recharge_gain========")
            rebate_call(self._owner, recharge_item)
            self._owner.recharge.send_mail(recharge_item)  # 发送奖励邮件
        else:
            rres = self._owner.base_info.first_recharge(recharge_item,
                                                        response)
            if rres:
                # 首次充值
                isfirst = 1
                self._owner.recharge.send_mail(recharge_item)  # 发送奖励邮件

        tlog_action.log('Recharge', self._owner, isfirst,
                        recharge_item.get('id'), channel)

        charge_num = recharge_item.get('activity')  # 充值元宝数量
        # vip
        self._owner.base_info.recharge += charge_num
        self._owner.base_info.max_single_recharge = max(
            charge_num, self._owner.base_info.max_single_recharge)
        self._owner.base_info.set_vip_level(self._owner.base_info.recharge)

        self._owner.act.condition_add(44, charge_num)
        # 更新 七日奖励
        target_update(self.owner, [44])

        # 活动
        self._owner.recharge.charge(charge_num)
        if not is_tencent:
            self._owner.recharge.get_recharge_response(
                response.info)  # recharge
