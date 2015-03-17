# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
# import time
# from gfirefly.server.logobj import logger
from app.game.component.Component import Component
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from shared.utils.const import const


class CharacterPay(Component):

    def __init__(self, owner):
        super(CharacterPay, self).__init__(owner)
        self._platform = 0
        self._open_id = ""
        self._open_key = ""
        self._pay_token = ""
        self._appid = ""
        self._pf = ""
        self._pfkey = ""
        self._zoneid = 0

    def set_pay_arg(self, value):
        self._platform = value.get("platform")
        self._open_id = value.get("openid")
        self._openkey = value.get("openkey")
        self._pay_token = value.get("pay_token")
        self._appid = value.get("appid")
        self._pf = value.get("pf")
        self._pfkey = value.get("pfkey")
        self._zoneid = value.get("zoneid")
        self.get_balance() # 登录时从tx拉取gold

    def get_balance_m(self):
        logger.debug("get_balance_m: platform- %s\
                     openid- %s \
                     openkey - %s \
                     pay_token - %s \
                     appid - %s \
                     pf - %s \
                     pfkey - %s \
                     zoneid - %s "%
                     (self._platform, self._open_id,
                      self._openkey, self._pay_token,
                      self._appid, self._pf,
                      self._pfkey, self._zoneid))
        if const.PAY:
            return
        try:
            data = GlobalObject().pay.get_balance_m(self._platform, self._openid, self._appid,
                                         self._appkey, self._openkey, self._pay_token,
                                         self._pf, self._pfkey, self._zoneid)
        except Exception, e:
            logger.error("get balance error:%s" % e)
        return

        if data['ret'] == 1018:
            return False
        elif data['ret'] != 0:
            logger.error("get_balance failed: %s" % data)
            return
        balance = data['balance']
        gen_balance = data['gen_balance']
        return balance, gen_balance

    def get_balance(self):
        result = self.get_balance_m()
        if not result:
            return False

        balance, gen_balance = result
        recharge_balance = balance - gen_balance
        current_balance = recharge_balance - self._owner.finance.gold
        if current_balance > 0:
            self._owner.base_info.set_vip_level(balance)
        self._owner.finance.gold = balance
        self._owner.finance.save_data()

    def pay_m(self, num):
        GlobalObject().pay.get_balance_m(self._platform, self._openid, self._appid,
                                         self._appkey, self._openkey, self._pay_token,
                                         self._pf, self._pfkey, self._zoneid, num)
    def cancel_pay_m(self, num, billno):
        GlobalObject().pay.get_balance_m(self._platform, self._openid, self._appid,
                                         self._appkey, self._openkey, self._pay_token,
                                         self._pf, self._pfkey, self._zoneid, num, billno)

    def present_m(self, discountid, giftid, presenttimes):
        GlobalObject().pay.get_balance_m(self._platform, self._openid, self._appid,
                                         self._appkey, self._openkey, self._pay_token,
                                         self._pf, self._pfkey, self._zoneid, discountid, giftid, presenttimes)
