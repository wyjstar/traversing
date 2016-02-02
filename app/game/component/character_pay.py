# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
# import time
# from gfirefly.server.logobj import logger
from app.game.component.Component import Component
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger
from shared.tlog import tlog_action
from gtwisted.core import reactor
from app.proto_file.common_pb2 import GetGoldResponse
import traceback
from app.proto_file.common_pb2 import GetGoldResponse
from shared.utils.const import const
from shared.db_opear.configs_data import game_configs

remote_gate = GlobalObject().remote.get('gate')


class CharacterPay(Component):
    def __init__(self, owner):
        super(CharacterPay, self).__init__(owner)
        self._platform = 0
        self._openid = ""
        self._open_key = ""
        self._pay_token = ""
        self._appid = ""
        self._pf = ""
        self._pfkey = ""
        self._zoneid = GlobalObject().allconfig.get('server_no')
        self._flowid = ""

        self.loop_times = 0
        self.REMOTE_DEPLOYED = False
        if 'deploy' in GlobalObject().allconfig:
            deplayed = GlobalObject().allconfig["deploy"]["remote_deployed"]
            # channel = GlobalObject().allconfig["deploy"]["channel"]
            self.REMOTE_DEPLOYED = deplayed

        if 'test' not in GlobalObject().allconfig["msdk"]["host"]:
            self._appkey = GlobalObject().allconfig["msdk"]["formal_recharge_appkey"]
        else:
            self._appkey = GlobalObject().allconfig["msdk"]["test_recharge_appkey"]
        self._appkey = str(self._appkey)


    def set_pay_arg(self, value):
        self._platform = value.get("platform")
        self._openid = str(value.get("openid"))
        self._openkey = str(value.get("openkey"))
        self._pay_token = str(value.get("pay_token"))
        self._appid = str(value.get("appid"))
        #self._appkey = str(value.get("appkey"))
        self._pf = str(value.get("pf"))
        self._pfkey = str(value.get("pfkey"))
        login_channel = str(value.get("login_channel"))
        logger.debug("login_channel %s" % login_channel)
        if login_channel != "tencent":
            self.REMOTE_DEPLOYED = False
        # self._zoneid = str(value.get("zoneid"))
        if self.REMOTE_DEPLOYED:
            previous_gold = self._owner.finance.gold
            self.get_balance()  # 登录时从tx拉取gold
            add_gold = self._owner.finance.gold - previous_gold
            if add_gold == 0:
                return
            logger.info('tencent add gold:%s', add_gold)
            recharge_config = game_configs.recharge_config.get('android')
            for k, item in recharge_config.items():
                if item.get('activity') == add_gold:
                    response = GetGoldResponse()
                    self._owner.recharge.recharge_gain(item, response, 5, True)
                    break
            else:
                logger.error('tencent add gold-num:%d', add_gold)

    def refresh_pay_arg(self, value):
        self._openkey = str(value.get("openkey"))
        self._pay_token = str(value.get("pay_token"))
        self._pf = str(value.get("pf"))
        self._pfkey = str(value.get("pfkey"))

    def _get_balance_m(self):
        if not self.REMOTE_DEPLOYED:
            return
        logger.debug("_get_balance_m: platform- %s\
                     openid- %s \
                     openkey - %s \
                     pay_token - %s \
                     appid - %s \
                     appkey - %s \
                     pf - %s \
                     pfkey - %s \
                     zoneid - %s " %
                     (self._platform, self._openid, self._openkey,
                      self._pay_token, self._appid, self._appkey, self._pf,
                      self._pfkey, self._zoneid))
        try:
            data = GlobalObject().pay.get_balance_m(
                self._platform, self._openid, self._appid, self._appkey,
                self._openkey, self._pay_token, self._pf, self._pfkey,
                self._zoneid)
            logger.debug(data)
        except Exception, e:
            logger.error("get balance error:%s" % e)
            logger.error(traceback.format_exc())
            return

        if data['ret'] == 1018:
            return False
        elif data['ret'] != 0:
            logger.error("get_balance failed: %s" % data)
            return
        balance = data['balance']
        gen_balance = data['gen_balance']
        # add gen balance
        gen_balance_add = gen_balance - self._owner.base_info.gen_balance
        self._owner.base_info.gen_balance = gen_balance
        self._owner.finance.gold += gen_balance_add
        self._owner.finance.save_data()
        # isfirst = data['first_save']
        # if isfirst == 1:
        # tlog_action.log('Recharge', self.owner, isfirst, 1)
        return balance, gen_balance

    def get_balance(self):
        result = self._get_balance_m()
        if not result:
            return False

        balance, gen_balance = result  # 充值结果：balance 当前值， gen_balance 赠送
        recharge_balance = balance - self._owner.finance.gold  # 累计充值数量
        if recharge_balance > 0:
            self._owner.base_info.recharge += recharge_balance
            self._owner.base_info.set_vip_level(self._owner.base_info.recharge)
        self._owner.base_info.gen_balance = gen_balance
        self._owner.finance.gold = balance
        self._owner.base_info.save_data()
        self._owner.finance.save_data()
        return True

    def recharge(self):
        result = self._get_balance_m()
        if not result:
            return False

        balance, gen_balance = result  # 充值结果：balance 当前值， gen_balance 赠送
        # add gen balance
        gen_balance_add = gen_balance - self._owner.base_info.gen_balance
        self._owner.finance.gold += gen_balance_add
        self._owner.finance.save_data()
        recharge_balance = balance - self._owner.finance.gold  # 累计充值数量

        self._owner.base_info.gen_balance = gen_balance
        self._owner.base_info.save_data()

        if recharge_balance > 0:
            # self._owner.recharge.charge(recharge_balance) # 充值活动
            # self._owner.base_info.recharge += recharge_balance
            # self._owner.base_info.set_vip_level(self._owner.base_info.recharge)
            self._owner.finance.gold = balance
            # self._owner.base_info.save_data()
            self._owner.finance.save_data()
            self.loop_times = 0

            response = GetGoldResponse()
            response.res.result = True
            response.gold = self._owner.finance.gold
            response.vip_level = self._owner.base_info.vip_level
            remote_gate.push_object_remote(2001,
                                           response.SerializePartialToString(),
                                           self._owner.base_info.id)
        else:
            self.loop_times += 1
            reactor.callLater(30 * self.loop_times, self.recharge)

    def _pay_m(self, num):
        if num == 0:
            return 0, 0
        if not self.REMOTE_DEPLOYED:
            self._owner.finance.consume_gold(num, 0)
            self._owner.finance.save_data()
            return 0, 0
        result = {}
        try:
            result = GlobalObject().pay.pay_m(
                self._platform, self._openid, self._appid, self._appkey,
                self._openkey, self._pay_token, self._pf, self._pfkey,
                self._zoneid, num)
        except Exception, e:
            logger.error("pay error:%s" % e)
            logger.error(traceback.format_exc())
            return

        if result['ret'] == 1018:
            return False
        elif result['ret'] != 0:
            logger.error("pay_m failed: %s", result)
            return False
        billno = result['billno']
        balance = result['balance']
        return billno, balance

    def pay(self, num, reason, func=None, *args, **kwargs):
        """
        func: 发货方法
        args, kwargs: 发货方法的参数
        """
        result = self._pay_m(num)
        if not result:
            return False
        if not func:
            return []
        billno, _balance = result
        try:
            func(*args, **kwargs)
        except Exception, e:
            logger.error("pay error: cancel_pay %s", e)
            logger.error(traceback.format_exc())
            self._cancel_pay_m(num, billno)
            return False
        self.get_balance()
        tlog_action.log('ItemFlow', self.owner, const.REDUCE, const.RESOURCE,
                        num, 2, 0, reason, self.owner.finance.gold, '')
        tlog_action.log('MoneyFlow', self.owner, self.owner.finance.gold, num,
                        reason, const.REDUCE, 2)
        return True

    def _cancel_pay_m(self, num, billno):
        """
        取消订单
        """
        result = {}
        if num == 0:
            return True
        if not self.REMOTE_DEPLOYED:
            self._owner.finance.add_gold(num, 0)
            self._owner.finance.save_data()
            return True
        try:
            result = GlobalObject().pay.cancel_pay_m(
                self._platform, self._openid, self._appid, self._appkey,
                self._openkey, self._pay_token, self._pf, self._pfkey,
                self._zoneid, num, billno)
        except Exception, e:
            logger.error("pay error:%s" % e)
            return

        if result['ret'] == 1018:
            return False
        elif result['ret'] != 0:
            logger.error("cancel_pay_m failed: %s", result)
        return True

    def _present_m(self, num):
        """
        赠送gold, 用于掉落包中的gold
        """
        result = {}
        try:
            pay = GlobalObject().pay
            discountid = pay.discountid
            giftid = pay.giftid
            result = GlobalObject().pay.present_m(
                self._platform, self._openid, self._appid, self._appkey,
                self._openkey, self._pay_token, self._pf, self._pfkey,
                self._zoneid, discountid, giftid, num)
        except Exception, e:
            logger.error("present error:%s" % e)
            logger.error(traceback.format_exc())
            return

        if result['ret'] == 1018:
            return False
        elif result['ret'] != 0:
            logger.error("present_m failed: %s", result)
            return False
        return True

    def present(self, num):
        """
        赠送gold, 用于掉落包中的gold, 更新gold
        """
        self._present_m(num)
        self.get_balance()

    @property
    def flowid(self):
        return self._flowid

    @flowid.setter
    def flowid(self, v):
        self._flowid = v
