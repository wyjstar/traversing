# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
# import time
# from gfirefly.server.logobj import logger
from app.game.component.Component import Component
from gfirefly.server.globalobject import GlobalObject


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

    def get_balance_m(self):
        GlobalObject().pay.get_balance_m(self._platform, self._openid, self._appid,
                                         self._appkey, self._openkey, self._pay_token,
                                         self._pf, self._pfkey, self._zoneid)
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
