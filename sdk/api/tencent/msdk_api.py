# coding: utf-8
# Created on 2013-9-4
# Author: Haihe, Panjiang

import json
import urllib

from sdk.func import xtime
from sdk.func import xid
from sdk.util.http import HttpRequest


class MSDKClient(object):
    """
    MSDK客戶端基类
    """
    def __init__(self, host, appid, appkey, log=None):
        self.host = host
        self.appid = appid
        self.appkey = appkey
        self.http = HttpRequest(log)
        
    def request(self, openid, path, data):
        """
        按照规定格式执行请求
        """
        timestamp = xtime.timestamp()
        sig = xid.md5(str(self.appkey) + str(timestamp))
        parmameters = {'timestamp':timestamp, 'appid':self.appid, 'sig':sig, 'openid':openid, 'encode':1}
        url = 'http://%s/%s' % (self.host, path + urllib.urlencode(parmameters))
        return self.http.request(url, json.dumps(data))

    def guest_request(self, openid, path, data):
        """
        按照规定格式执行游客登录请求
        """
        timestamp = xtime.timestamp()
        sig = xid.md5(str(self.appkey) + str(timestamp))
        parmameters = {'timestamp':timestamp, 'appid':"G_%s"%self.appid, 'sig':sig, 'openid':openid, 'encode':1}
        url = 'http://%s/%s' % (self.host, path + urllib.urlencode(parmameters))
        return self.http.request(url, json.dumps(data))


class AccessApi(MSDKClient):
    _verify_login = '/wxoauth/verify_login/?'
    _check_token = '/wxoauth/check_token/?'
    _guest_check_token = 'auth/guest_check_token/?'
        
    def qq_verify_login(self, openid, req):
        """
        通过开平的接口验证登录态是否有效，有效的话自动续期
        """
        return self.request(openid, self._verify_login, req)
    
    def wx_check_token(self, openid, req):
        """
        验证wx的accessToken
        """
        return self.request(openid, self._check_token, req)

    def guest_check_token(self, guestid, access_token):
        """
        验证游客登录
        """
        return self.guest_request(guestid, self._guest_check_token, access_token)



class RelationApi(MSDKClient):
    _LoadvipUrl = '/profile/load_vip/?'
    _WXProfileUrl = '/relation/wxprofile/?'
    _WXFriendsUrl = '/relation/wxfriends_profile/?'
    _QQUserinfoUrl = '/relation/qquserinfo/?'
    _QQProfileUrl = '/relation/qqprofile/?'
    _QQFriendsUrl = '/relation/qqfriends_detail/?'

    def load_vip(self, openid, req):
        """
        获取VIP信息
        """
        return self.request(openid, self._LoadvipUrl, req)
    
    def get_wx_profile(self, openid, req):
        """
        拉取微信个人基本资料
        """
        return self.request(openid, self._WXProfileUrl, req)
    
    def get_wx_friends(self, openid, req):
        """
        拉取微信好友关系
        """
        return self.request(openid, self._WXFriendsUrl, req)

    def get_qq_profile(self, openid, req):
        """
        获取QQ基本信息
        """
        return self.request(openid, self._QQProfileUrl, req)
    
    def get_qq_friends(self, openid, req):
        """
        获取QQ游戏中好友
        """
        return self.request(openid, self._QQFriendsUrl, req)


class ShareApi(MSDKClient):
    _ShareToQQ = '/share/qq/?'
    _ShareToWX = '/share/wx/?'
    _ShareToQzoneUrl = '/share/qzone?'

    def share_to_qzone(self, openid, req):
        """
        分享到QQ空间
        """
        return self.request(openid, self._ShareToQzoneUrl, req)
    
    def share_to_qq(self, openid, req):
        """
        分享给QQ
        """
        return self.request(openid, self._ShareToQQ, req)
    
    def share_to_wx(self, openid, req):
        """
        分享给微信
        """
        return self.request(openid, self._ShareToWX, req)
