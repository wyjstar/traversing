# coding: utf-8
# Created on 2013-8-31
# Author: jiang


from sdk.api.tencent import common
from sdk.func import xtime
from sdk.util.http import HttpRequest
#from gfirefly.server.logobj import logger


class MidasApi(object):
    """
    支付接口
    """

    def __init__(self, host, goods_host, valid_host, log=None, discountid="", giftid=""):
        self.host = host
        self.goods_host = goods_host
        self.valid_host = valid_host
        self.http = HttpRequest(log)
        self.discountid = discountid
        self.giftid = giftid

    def _new_url(self, uri):
        return "http://%s%s" % (self.host, uri)

    def _new_goods_url(self, uri):
        return "http://%s%s" % (self.host, uri)

    def _new_valid_url(self, uri):
        return "http://%s%s" % (self.host, uri)

    def get_balance_m(self, platform, openid, pay_appid, pay_appkey, access_token, pay_token, pf, pfkey, zoneid):
        """ 获取用户充值币余额
        @return: example,
        {"ret":0,"balance":200,"gen_balance":0, "first_save":1}
        ret：返回码
        balance：充值币个数（包含了赠送充值币）
        gen_balance:赠送充值币个数
        first_save:是否满足首次充值，1：满足，0：不满足。
        """
        uri = '/mpay/get_balance_m'
        cookie = common.create_cookie(platform, uri)
        print cookie, "cookie============"
        params = {
                  'openid':openid,
                  'openkey':access_token,
                  'pay_token':pay_token,
                  'appid':pay_appid,
                  'ts':xtime.timestamp(),
                  'pf':pf,
                  'pfkey':pfkey,
                  'zoneid':zoneid,
                  'format':'json'
        }
        method = 'get'
        en_params = common.encoding_params(method, uri, params, pay_appkey)
        result = self.http.request(self._new_url(uri), en_params, cookie, method=method)
        return result

    def pay_m(self, platform, openid, pay_appid, pay_appkey, access_token, pay_token, pf, pfkey, zoneid, amt):
        """ 扣除用户充值币
        @return: example,
        {"ret" : 0,"billno" : "20102","balance":200}
        ret：返回码
        billno：预扣流水号
        balance：预扣后的余额
        """
        uri = '/mpay/pay_m'
        cookie = common.create_cookie(platform, uri)
        params = {
                  'openid':openid,
                  'openkey':access_token,
                  'pay_token':pay_token,
                  'appid':pay_appid,
                  'ts':xtime.timestamp(),
                  'pf':pf,
                  'pfkey':pfkey,
                  'zoneid':zoneid,
                  'amt': amt,
                  'format':'json'
        }
        method = 'get'
        en_params = common.encoding_params(method, uri, params, pay_appkey)
        result = self.http.request(self._new_url(uri), en_params, cookie, method=method)
        return result

    def cancel_pay_m(self, platform, openid, pay_appid, pay_appkey, access_token, pay_token, pf, pfkey, zoneid, amt, billno):
        """ 退款
        @return: example,
        {"ret":0}
        ret：返回码
        """
        uri = '/mpay/cancel_pay_m'
        cookie = common.create_cookie(platform, uri)
        params = {
                  'openid':openid,
                  'openkey':access_token,
                  'pay_token':pay_token,
                  'appid':pay_appid,
                  'ts':xtime.timestamp(),
                  'pf':pf,
                  'pfkey':pfkey,
                  'zoneid':zoneid,
                  'amt': amt,
                  'billno': billno,
                  'format':'json'
        }
        method = 'get'
        en_params = common.encoding_params(method, uri, params, pay_appkey)
        result = self.http.request(self._new_url(uri), en_params, cookie, method=method)
        return result

    def present_m(self, platform, openid, pay_appid, pay_appkey, access_token, pay_token, pf, pfkey, zoneid, discountid, giftid, presenttimes):
        """ 直接赠接口，可以用于赠送充值币
        @return: example,
        {"ret":0}
        ret：返回码
        """
        uri = '/mpay/present_m'
        cookie = common.create_cookie(platform, uri)
        params = {
                  'openid':openid,
                  'openkey':access_token,
                  'pay_token':pay_token,
                  'appid':pay_appid,
                  'ts':xtime.timestamp(),
                  'pf':pf,
                  'pfkey':pfkey,
                  'zoneid':zoneid,
                  'discountid': discountid,
                  'giftid': giftid,
                  'presenttimes': presenttimes,
                  'format':'json'
        }
        method = 'get'
        en_params = common.encoding_params(method, uri, params, pay_appkey)
        result = self.http.request(self._new_url(uri), en_params, cookie, method=method)
        return result

    def buy_goods_m(self, platform, openid, pay_appid, pay_appkey, access_token, pay_token, pf, pfkey, zoneid, payitem, goodsmeta, goodsurl, appmode=1):
        """ 直接赠接口，可以用于赠送充值币
        @return: example,
        {"ret":0}
        ret：返回码
        """
        uri = '/mpay/buy_goods_m'
        cookie = common.create_cookie(platform, uri)
        params = {
                  'openid':openid,
                  'openkey':access_token,
                  'pay_token':pay_token,
                  'appid':pay_appid,
                  'ts':xtime.timestamp(),
                  'pf':pf,
                  'pfkey':pfkey,
                  'zoneid':zoneid,
                  'payitem': payitem,
                  'goodsmeta': goodsmeta,
                  'goodsurl': goodsurl,
                  'appmode': appmode,
                  'format':'json'
        }
        method = 'get'
        en_params = common.encoding_params(method, uri, params, pay_appkey)
        result = self.http.request(self._new_url(uri), en_params, cookie, method=method)
        return result

    def activity_qualification(self, platform, openid, pay_appid, pay_appkey, access_token, pay_token, pf, pfkey, zoneid, req_from):
        """
        活动资格查询接口

        @return: example,
        {"ret" : 0,"first_save" : 0, "wx_pay" : 0, "kj_pay" : 0, "kj_pay" : 0, "qualified" :4, "qualified_info" : "", "is_show_act_page" : 4, "discounttype" : "", "discounturl" : ""}

        ret：返回码
        first_save：int 是否满足首次充值，1：满足，0：不满足。
        wx_pay：int 是否开通微信支付，1：开通，0：未开通。
        kj_pay：int 是否开通快捷支付，1：开通，0：未开通。
        qualified：int 是否有资格， 1：有；2：没有资格；
        qualified_info：string 资格校验信息
        is_show_act_page：int 是否弹出活动页面
        discounttype：string 活动类型，需要传给sdk
        discounturl：string 活动url，需要传给sdk
        """
        req_from = 'InGame' if req_from==1 else 'Market'
        uri = '/mpay/query_qualify_m'
        cookie = common.create_cookie(platform, uri)
        params = {
                  'openid':openid,
                  'openkey':access_token,
                  'pay_token':pay_token,
                  'appid':pay_appid,
                  'ts':xtime.timestamp(),
                  'pf':pf,
                  'pfkey':pfkey,
                  'zoneid':zoneid,
                  'req_from': req_from,
                  'accounttype': 'save',
                  'format':'json'
        }
        method = 'get'
        en_params = common.encoding_params(method, uri, params, pay_appkey)
        result = self.http.request(self._new_url(uri), en_params, cookie, method=method)
        return result
