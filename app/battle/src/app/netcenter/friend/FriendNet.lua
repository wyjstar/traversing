--社交网络
FriendNet = FriendNet or class("FriendNet", BaseNetWork)

CHECK_INFO = 706
FRIEND_APPLY_REQUEST               = 1100      --好友申请
FRIEND_ACCEPT_APPLY_REQUEST        = 1101      --接受好友申请
FRIEND_REFUSE_APPLY_REQUEST        = 1102      --拒绝好友申请
FRIEND_DELETE_REQUEST              = 1103      --删除好友
FRIEND_ADDBLACK_NAME_REQUEST       = 1104      --添加黑名单
FRIEND_DELBLACK_NAME_REQUEST       = 1105      --删除黑名单
FRIEND_LIST_REQUEST                = 1106      --好友列表
FRIEND_FIND_REQUEST                = 1107      --查询好友
FRIEND_PRESENTVIGOR_REQUEST     = 1108   --请求：赠送活力给好友@jiang
FRIEND_FORWARD_REQUEST             = 1110      --通知：有新的好友申请
FRIEND_PRIVATECHAT_REQUEST       = 1060     --请求：好友私聊@jiang
FRIEND_OPENRECEIVE_REQUEST        = 1061     --请求：开启活力接收@jiang
FRIEND_CLOSERECEIVE_REQUEST      = 1062     --请求：关闭活力接收@jiang


function FriendNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
     self:initRegisterNet()
end

function FriendNet:init()

end

--发送好友列表、黑名单列表、好友申请列表
function FriendNet:sendGetFriendListMsg()
    -- cclog("---FriendNet:sendGetFriendListMsg---")
    self:sendMsg(FRIEND_LIST_REQUEST)
end

--好友申请
function FriendNet:sendFriendApply(data)
    self:sendMsg(FRIEND_APPLY_REQUEST, "FriendCommon", data)
end

--接受好友申请
function FriendNet:sendAcceptFriendApply(data)
    self:sendMsg(FRIEND_ACCEPT_APPLY_REQUEST, "FriendCommon", data)
end

--拒绝好友申请
function FriendNet:sendRefuseFriendApply(data)
    self:sendMsg(FRIEND_REFUSE_APPLY_REQUEST, "FriendCommon", data)
end

--删除好友
function FriendNet:sendDeleteFriend(data)
    self:sendMsg(FRIEND_DELETE_REQUEST, "FriendCommon", data)
end

--添加黑名单
function FriendNet:sendAddBlackName(data)
    self:sendMsg(FRIEND_ADDBLACK_NAME_REQUEST, "FriendCommon", data)
end

--删除黑名单
function FriendNet:sendDelBlackName(data)
    self:sendMsg(FRIEND_DELBLACK_NAME_REQUEST, "FriendCommon", data)
end

--查询好友
function FriendNet:sendFindFriend(data)
    -- table.print(data)
    self:sendMsg(FRIEND_FIND_REQUEST, "FindFriendRequest", data)
end

--发送私信
function FriendNet:sendPrivateChat(data)
    self:sendMsg(FRIEND_PRIVATECHAT_REQUEST, "FriendPrivateChatRequest", data)
end

--开启活力赠送
function FriendNet:sendOpenReceive()
    self:sendMsg(FRIEND_OPENRECEIVE_REQUEST)
end

--关闭活力赠送
function FriendNet:sendCloseReceive()
    self:sendMsg(FRIEND_CLOSERECEIVE_REQUEST)
end

--赠送活力给好友
function FriendNet:sendPresentVigor(data)
    self:sendMsg(FRIEND_PRESENTVIGOR_REQUEST, "FriendCommon", data)
end

--发送查看信息界面
function FriendNet:sendCheckInfo(uid)
    local data = { target_id = uid }
    self:sendMsg(CHECK_INFO, "GetLineUpRequest", data)
end

--注册接受网络协议
function FriendNet:initRegisterNet()

    local function getFriendCallBack(data)
        cclog("<< response 好友列表 >>")
        getDataManager():getFriendData():setListData(data)
        isEnterGame = nil
    end

    local function CommonResponseCallBack(data)

        getDataManager():getFriendData():setCommonResponseData(data)
        self:sendGetFriendListMsg() -- 请求一次好友

        --[[更新好友红点
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        local event = cc.EventCustom:new(UPDATE_FRIEND_NOTICE)
        dispatcher:dispatchEvent(event)]]
    end

    local function FindFriendResponseCallBack(data)

        -- table.print(data)
        getDataManager():getFriendData():setFindFriendResponseData(data)

    end

    local function FriendPrivateChatResponseCallback(data)
    end

    --战队信息查看
    local function checkInfoCallBack(data)
        print("查看好友信息==== ========= ", data)
        table.print(data)
        local c_arenaData = getDataManager():getArenaData()
        c_arenaData:setRankCheckInfo(data.slot)
        c_arenaData:setOtherPlayerLineUp(data)
    end

    self:registerNetMsg(CHECK_INFO, "LineUpResponse", checkInfoCallBack)    --请求好友信息

    self:registerNetMsg(FRIEND_LIST_REQUEST, "GetPlayerFriendsResponse", getFriendCallBack)         --好友列表、黑名单列表、好友申请列表
    self:registerNetMsg(FRIEND_APPLY_REQUEST, "CommonResponse", CommonResponseCallBack)             --好友申请
    self:registerNetMsg(FRIEND_ACCEPT_APPLY_REQUEST, "CommonResponse", CommonResponseCallBack)      --接受好友申请
    self:registerNetMsg(FRIEND_REFUSE_APPLY_REQUEST, "CommonResponse", CommonResponseCallBack)      --拒绝好友申请
    self:registerNetMsg(FRIEND_DELETE_REQUEST, "CommonResponse", CommonResponseCallBack)            --删除好友
    self:registerNetMsg(FRIEND_ADDBLACK_NAME_REQUEST, "CommonResponse", CommonResponseCallBack)     --添加黑名单
    self:registerNetMsg(FRIEND_DELBLACK_NAME_REQUEST, "CommonResponse", CommonResponseCallBack)     --删除黑名单
    self:registerNetMsg(FRIEND_FIND_REQUEST, "FindFriendResponse", FindFriendResponseCallBack)      --查询好友
    self:registerNetMsg(FRIEND_FORWARD_REQUEST, "CommonResponse", CommonResponseCallBack)           --转发好友申请到客户端

    self:registerNetMsg(FRIEND_PRIVATECHAT_REQUEST, "CommonResponse")          --响应发送私信
    self:registerNetMsg(FRIEND_OPENRECEIVE_REQUEST, "CommonResponse")          --开启活力赠送
    self:registerNetMsg(FRIEND_CLOSERECEIVE_REQUEST, "CommonResponse")          --关闭活力赠送
    self:registerNetMsg(FRIEND_PRESENTVIGOR_REQUEST, "CommonResponse")          --赠送活力给好友
end

return FriendNet
