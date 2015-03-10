# coding: utf-8
# Created on 2013-8-28
# Author: Panjiang

import json
import urllib
from sdk.util.http import HttpRequest


class ReportApi(object):
    """
    上报数据接口
    """

    def __init__(self, appid, qq_rank_host, wx_rank_host, log=None):
        self.appid = appid
        self.qq_rank_host = qq_rank_host
        self.wx_rank_host = wx_rank_host
        self.http = HttpRequest(log)

    def update_qq_score(self, zone_id, nickname, openid, score=None, top_score=None):
        """
        更新qq用户游戏分数

        Example:
            http://10.153.96.115:10000/game/rp_achieves?appid=xxx&access_token=xxx&openid=xxx&uin=xxx&param={}
        """
        if score:
            score = int(score)
        if top_score:
            top_score = int(top_score)
        ls = []

        item_zone = {'type':1001, 'data':str(zone_id), 'expires':0, 'bcover':1}
        ls.append(item_zone)

        url_nickname = urllib.quote(nickname.encode('utf8'))
        item_nickname = {'type':1002, 'data': url_nickname, 'expires':0, 'bcover':1}
        ls.append(item_nickname)


        if score:
            item_score = {'type':3, 'data':str(score), 'expires':0, 'bcover':0}
            ls.append(item_score)

        if top_score:
            max_score = {'type':5, 'data':str(top_score), 'expires':0, 'bcover':1}
            ls.append(max_score)

        data = json.dumps({"zone":2, "total":10, "list":ls})
        uri = '/v2/game/rp_achieves?appid=%s&openid=%s&param=%s' % (self.appid, openid, data)

        # host = ("192.168.10.241", 8080)
        # uri = '/test.php?appid=%s&openid=%s&param=%s' % (product.appid, user.openid, data)
        self.http.request(self.qq_rank_host, uri)

    def update_wx_score(self, wx_access_token, openid, score):
        """
        更新微信用户游戏分数
        """
        uri = '/game/score?access_token=%s' % wx_access_token
        data = json.dumps({"openid":openid, "score":score, "expires":0})
        self.http.request(self.wx_rank_host, uri, data, json_type=True)
    
