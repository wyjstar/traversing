# coding: utf-8
# created on 2014-9-25
# author: jiang

import json
import urllib2
import time
# from func import xtime
SANDBOX = True


allow_sandbox = True    # 允许使用沙盒支付
logical_bids = ['com.mobartsgame.Lord']    # 合法的产品标记
try_more_times = {1: 0.1, 2: 0.2, 3: 0.7}   # 重试次数及间隔


class IAPSDK(object):
    """
    IAP服务端SDK
    """

    def __init__(self, bids=logical_bids, try_more_times=try_more_times):
        self._bids = bids   # 合法的产品标记
        self.try_more_times = try_more_times

    def _request(self, url, data, times=1):
        """ HTTP协议请求数据（附带重试机制）
        @param url: 请求地址
        @param data: 传递数据
        """
        data_json = json.dumps(data)
        try:
            req = urllib2.Request(url, data_json,
                                  {'content-type': 'application/json'})
            response_stream = urllib2.urlopen(req)
            response = response_stream.read()
        except:
            sleep_time = self.try_more_times.get(times, None)
            if sleep_time is None:
                raise
            time.sleep(sleep_time)
            response = self._request(url, data, times=times + 1)
        return json.loads(response)

    def verify(self, purchase_info, transaction_id):
        """
        校验订单有效性
        @param purchase_info:
            从transaction的transactionReceipt属性中得到收据的数据，并以base64方式编码。
        """
        if SANDBOX:
            url = "https://sandbox.itunes.apple.com/verifyReceipt"
        else:
            url = "https://buy.itunes.apple.com/verifyReceipt"
        data = {
            "receipt-data": purchase_info
        }

        try:
            result = self._request(url, data)
        except Exception, e:
            # 请求异常，下次登陆再校验
            return {"status": 2, "error": e}

        print 'result', result
        status = result['status']
#         if allow_sandbox and status == 21007:
#             # 沙盒环境，验证成功（用于上线前的测试）
#             # rcpt = result['receipt']
#             # transaction_id = rcpt['transaction_id']
# #             return {"status": 100}
#             # #
# #             transaction_id = "transaction_id_test_"
#             now = xtime.timestamp()
# #             transaction_id += str(now)
#             transaction_id = transaction_id
#             product_id = "product_id_test_1001"
#             quantity = 1000
#             purchase_date_ms = "purchase_date_ms_test_"
#             purchase_date_ms += str(now)
#             return {"status": 0, "orderid": transaction_id,
#                     "goodscode": product_id, "count": quantity,
#                     "purchase_date": purchase_date_ms}

        if result['status'] != 0:
            # 校验为无效交易
            return {"status": 1, "error": "error status %s" % status}

        bid = result['receipt']['bid']
        if self._bids and result['receipt']['bid'] not in self._bids:
            # 校验为无效交易
            return {"status": 1, "error": "invalid bid %s" % bid}

        # 验证成功，执行发货
        rcpt = result['receipt']
        transaction_id = rcpt['transaction_id']
        product_id = rcpt['product_id']
        quantity = rcpt['quantity']
        purchase_date_ms = rcpt['purchase_date_ms']

        return {"status": 0, "orderid": transaction_id,
                "goodscode": product_id, "count": quantity,
                "purchase_date": purchase_date_ms}


# if __name__ == "__main__":
#     purchase_info = "BASE64-STR"
#     iap = IAPSDK(bids=['com.mobartsgame.dragon.91'])
#     iap.try_more_times = {1: 0.1, 2: 0.2}
#     res = iap.verify(purchase_info)
#     print(res)
