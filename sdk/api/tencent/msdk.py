# coding: utf-8
# Created on 2013-8-19
# Author: Yujinling

import json
import time
from sdk.api.tencent.msdk_api import AccessApi, RelationApi, ShareApi


OS_IOS = 0
OS_AND = 1
PLATFORM_WX = 1
PLATFORM_QQ = 2
PLATFORM_GUEST = 5

class Msdk(object):
    host = ''
    qq_appid = ''
    qq_appkey = ''
    wx_appid = ''
    wx_appkey = ''
    qzoneconfig = {}

    def __init__(self, host, qq_appid, qq_appkey, wx_appid, wx_appkey, log=''):
        self.qq_appid = qq_appid
        self.wx_appid = wx_appid

        self.qq_access = AccessApi(host, qq_appid, qq_appkey, log=log)
        self.qq_relation = RelationApi(host, qq_appid, qq_appkey, log=log)
        self.qq_share = ShareApi(host, qq_appid, qq_appkey, log=log)

        self.wx_access = AccessApi(host, wx_appid, wx_appkey, log=log)
        self.wx_relation = RelationApi(host, wx_appid, wx_appkey, log=log)
        self.wx_share = ShareApi(host, wx_appid, wx_appkey, log=log)


    def verify_login(self, platform, openid, token):
        """
        登陆校验
        """
        res = {}
        print "platform:",platform
        print "openid:",openid
        print "token:",token
        if platform == PLATFORM_WX:
            params = {'openid':openid, 'accessToken':token}
            res = self.wx_access.wx_check_token(openid, params)
        elif platform == PLATFORM_QQ:
            params = {'appid':self.qq_appid, 'openkey':token, 'openid':openid}
            res = self.qq_access.qq_verify_login(openid, params)
        elif platform == PLATFORM_GUEST:
            guest_check = {'accessToken':token,'guestid':openid}
            res = self.qq_access.guest_check_token(openid, guest_check)
        print res
        ret = res.get('ret', 1)
        return ret


    def get_friends(self, platform, openid, token):
        """
        获取好友列表
        """
        res = {}
        if platform == PLATFORM_WX:
            params = {'openid':openid, 'accessToken':token}
            res = self.wx_relation.get_wx_friends(openid, params)
        elif platform == PLATFORM_QQ:
            params = {'appid':self.qq_appid, 'accessToken':token, 'openid':openid}
            res = self.qq_relation.get_qq_friends(openid, params)
        ret = res.get('ret', 1)
        if ret == -10000:
            return -1
        if ret != 0:
            return []
        lists = res.get('lists', [])
        return lists


    def get_profile(self, platform, token, *openid):
        """
        获取指定玩家信息
        """
        res = {}
        if platform == PLATFORM_WX:
            params = {'accessToken':token, 'openids':openid}
            res = self.wx_relation.get_wx_profile(openid, params)
        elif platform == PLATFORM_QQ:
            params = {'appid':self.qq_appid, 'accessToken':token, 'openid':openid[0]}
            res = self.qq_relation.get_qq_profile(openid, params)

        ret = res.get('ret', 1)
        if ret == -10000:
            return -1
        if ret != 0:
            res = {}
        if platform == PLATFORM_QQ:
            return res
        retlist = res.get('lists', [])
        return retlist


    def get_nickname(self, platform, openid, token):
        """
        获取指定玩家昵称
        """
        profile = self.get_profile(platform, token, openid)
        if profile == -1:
            return ''
        if platform == PLATFORM_QQ:
            return profile.get('nickName', '')
        if not profile:
            return ''
        return profile[0].get('nickName', '')

    @classmethod
    def profile_list(cls, platform, profile):
        """
        解析玩家信息

        @return: [OpenId, Nickname, Picture]
        """
        if platform == 2:
            return [profile['openid'], profile['nickName'], profile['figureurl_qq'] + '/100']
        elif platform == 1:
            return [profile['openid'], profile['nickName'], profile['picture'] + '/132']

    def share_to_qzone(self, openid, access_token, os, summary, qzoneconfig={}):
        """
        分享到QQ空间

        @param summary: 分享内容
        """
        platform = ''
        if os == OS_IOS:
            platform = 'iosqz'
        elif os == OS_AND:
            platform = 'androidqz'

        title = qzoneconfig.get('title', 0)
        share_url = qzoneconfig.get('share_url', 0)
        pics = qzoneconfig.get('pics', 0)
        req = {'hopenid':openid, 'appid':self.qq_appid, 'key_type':128, 'key_str':access_token, 'platform':platform,
               'tlogmsg':'', 'title':title, 'summary':summary, 'share_url':share_url, 'pics':pics}
        res = self.qq_share.shareto_qzone(openid, req)
        ret = res.get('ret', 1)
        return ret

    def get_profile_list(self, platform, openid, token):
        """
        获取指定OpenID信息列表

        @return: [OpenId, Nickname, Picture]
        """
        profile = self.get_profile(platform, token, openid)
        if not profile or profile == -1:
            return []
        if platform == PLATFORM_WX:
            profile = profile[0]
            return [openid, profile['nickName'], profile['picture'] + '/132']
        else:
            return [openid, profile['nickName'], profile['picture100']]

    def get_friends_list(self, platform, openid, token):
        """
        获取指定OpenID好友列表

        @return: [OpenId, Nickname, Picture]
        """
        friends_list = []

        friends = self.get_friends(platform, openid, token)
        if friends == -1:
            return -1

        # 解析好友信息
        has_self = False
        for profile in friends:
            plist = self.profile_list(platform, profile)
            if plist[0] == openid:
                has_self = True
            friends_list.append(plist)

        # 无自己信息，单独拉取
        if not has_self:
            self_info = self.get_profile_list(platform, openid, token)
            if self_info:
                friends_list.append(self_info)
        return friends_list

    def get_load_vip(self, openid, login=1, vip=1, uin=0):
        """
        获取VIP信息
        """
        if login != 1 and login != 2:
            return []

        if login == PLATFORM_WX:
            req = {'appid':self.wx_appid, 'login':login, 'openid':openid, 'vip':vip, 'uin':uin}
            res = self.wx_relation.load_vip(openid, req)
        if login == PLATFORM_QQ:
            req = {'appid':self.qq_appid, 'login':login, 'openid':openid, 'vip':vip, 'uin':uin}
            res = self.wx_relation.loadVip(openid, req)

        ret = res.get('ret', 1)
        if ret != 0:
            res = {}
        return res.get('lists', [])

    def share_to_wx(self, openid, fopenid, access_token, **kwds):
        """
        分享信息到WX
        """
        req = {'extinfo':'', 'title':'', 'description':'', 'media_tag_name':'share_to_wx', 'thumb_media_id':''}
        req.update({'openidsh':openid, 'fopenid':fopenid, 'access_token':access_token})
        if kwds:
            req.update(kwds)
        res = self.wx_share.share_to_wx(openid, req)
        return res.get('ret', 1)

    def share_to_qq(self, openid, fopenids, access_token, **kwds):
        """
        分享信息到QQ
        """
        req = {'image_url':'', 'summary':'', 'target_url':'', 'title':'', 'act':1, 'dst':1001, 'flag':1, 'src':0,
               'game_tag':'MSG_HEART_SEND'}
        req.update({'appid':self.qq_appid, 'openid':openid, 'fopenids':json.dumps(fopenids),
                    'access_token':access_token, 'oauth_consumer_key':self.qq_appid})
        if kwds:
            req.update(kwds)
        res = self.qq_share.share_to_qq(openid, req)
        return res.get('ret', 1)
