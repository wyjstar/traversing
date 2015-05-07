
--lua层网络管理类

menu_scene = "menuScene"
player_scene = "playerScene"
fight_scene = "fightScene"

local NetManage = NetManage or class("NetManage")

local Socket = import("...framework.network.Socket")
local SodierNet = import(".soldier.SodierNet")
local LineUpNet = import(".soldier.LineUpNet")
local LoginNet = import(".login.LoginNet")
local BagNet = import(".bag.BagNet")
local EquipNet = import(".equip.EquipNet")
local FriendNet  = import(".friend.FriendNet")
local LegionNet = import(".legion.LegionNet")
local ShopNet = import(".shop.ShopNet")
local SacrificeNet = import(".sacrifice.SacrificeNet")
local ChatNet = import(".chat.ChatNet")
local EmailNet = import(".email.EmailNet")
local InstanceNet = import(".instance.InstanceNet")
local ActivityNet = import(".activity.ActivityNet")
local ArenaNet = import(".arena.ArenaNet")
local BossNet = import(".arena.BossNet")
local ActiveDegreeNet = import(".active.ActiveDegreeNet")
local TravelNet = import(".travel.TravelNet")
local SecretPlaceNet = import(".SecretPlaceNet.SecretPlaceNet")
local HeadNet = import(".head.HeadNet")

local InheritNet = import(".inherit.InheritNet")

local RuneNet = import(".rune.RuneNet")
local NewBieNet = import(".newbieguide.NewBieNet")

local RankNet = import(".rank.RankNet")

local HttpCenter = import(".HttpCenter")

local HEARTBEAT_TIME = 30.0            --  socket heart beat time

g_isReconnect = false
g_isLoginOut = false

g_currentSceneStatus = player_scene

function NetManage:ctor(controller)
    self.itemsData = nil --物品数据类
    self:init()
end

--初始化类的实例
function NetManage:init()
    self.dataCache_ = {} --断网时缓存数据
    self.netTable = {}
    self.bagNet = nil                       --背包
    self.soldierNet = nil               	--武将
    self.loginNet = nil		                --登陆
    self.friendNet = nil		            -- 社交
    self.legionNet = nil                    --公会
    self.sacrificeNet = nil                 -- 献祭
    self.lineUpNet = nil                    --阵容
    self.chatNet = nil                      --聊天
    self.emailNet = nil                     --邮件
    self.instanceNet = nil                  --关卡
    self.activityNet = nil                  --活动
    self.heartBeatNet = nil                 --心跳
    self.arenaNet = nil                     --竞技场
    self.bossNet = nil                      --世界Boss
    self.activeNet = nil                    --活跃度
    self.travelNet = nil                    --游历
    self.headNet = nil                      --头像
    self.SecretPlaceNet = nil               --秘境

    self.inheritNet = nil                   --传承

    self.runeNet = nil                      --符文
    self.shopNet = nil
    self.equipNet = nil                     --装备
    self.newBieNet = nil                    --新手引导
    self.rankNet = nil                    --排行
    self.director = cc.Director:getInstance()

end

-- 获取http连接
function NetManage:getHttpCenter()
    if g_httpCenter == nil then
       g_httpCenter = HttpCenter:new()
       g_httpCenter:setDelegate(self)
    end

    return g_httpCenter
end

-- 关闭连接
function NetManage:closeConnect()
    local socket = self:getSocket()
    socket:closeConnect()
    self.dataCache_ = {}
end

--连接成功
function NetManage:onConnectSuccess()

    -- 登陆 gameServer
    self:getLoginNet():sendUserLogin()

    local __heartBeat = function()
        local socket = self:getSocket()
        socket:sendMsg(88, nil, "12", false)
    end

    self.heartBeatNet = timer.scheduleGlobal(__heartBeat, HEARTBEAT_TIME)

    --重发断开后缓冲数据，应该分帧发送，一次发送会造成堵塞
    for i = 1, #self.dataCache_ do
        local data = table.remove(self.dataCache_)
        self:getSocket():reSend(data)
    end
end

--连接失败
function NetManage:onConnectFailed(data_)
    -- self:closeConnect()
    if g_isLoginOut == true then g_isLoginOut = false return end

    self:onRemoveNetLoading()

    if self.heartBeatNet then timer.unscheduleGlobal(self.heartBeatNet) end

    g_isReconnect = true

    if g_currentSceneStatus == menu_scene then

        logout()

        return
    end

    if data_ then
        self.dataCache_[#self.dataCache_ + 1] = data_
    end

    self:_httpthirdLogin()

end

function NetManage:_httpthirdLoginResponse(status, response)
    local data = {}

     if status == 200 then  -- 成功
           data = parseJson(response)

       if data.result == true then

            -- 回调
            local _roleLoginCallfunc = function(status, response)
                self:_roleLoginResponse(status, response)
            end

            g_NetManager:getHttpCenter():sendLoginByPassport(_roleLoginCallfunc, data.passport)

            return
        end
    end

     -- 回到登录界面
    local  sure = function()
        logout()
    end

    if g_FightScene ~= nil then
       getTempFightData():setFightPause() --战斗暂停
    end

    getOtherModule():showAlertDialog(sure, Localize.query("NetManage.1"))
end

-- loginout
function NetManage:loginout()
    g_isReconnect = false
    self:closeConnect()
    clearLoginuserAndPwd()
    getDataManager():clearCurrentPlayerData()
    enterMenuScene()
    g_isLoginOut = true
end

-- 正式登录成功
function NetManage:_roleLoginResponse(status, response)
    local data = {}

     if status == 200 then  -- 成功
        data = parseJson(response)

        self.loginNet:setHttpLoginSuccessResponse(data)

         -- 重连socket
         self:_reconnect()

         return
    end

     -- 回到登录界面
    local  sure = function()
         logout()
    end

    getOtherModule():showAlertDialog(sure, Localize.query("NetManage.2"))
end

-- http登陆，，网络断开重连用到
function NetManage:_httpthirdLogin()

    local _thirdLoginCallfunc = function(status, response)
        self:_httpthirdLoginResponse(status, response)
    end

    local _user = cc.UserDefault:getInstance():getStringForKey("user_name")
    local _pwd = cc.UserDefault:getInstance():getStringForKey("password")
    self:getHttpCenter():sendThirdLogin(_thirdLoginCallfunc, _user, _pwd)
end

-- 重连
function NetManage:_reconnect()
     -- 确定重连
    self:onNetLoading()

    local socket = self:getSocket()
    socket:reconnect()
    print("---重连 重连----")
end

-- 是否重连网络
function NetManage:onReconnect()

    self:onRemoveNetLoading()

    local  sure = function()
        -- 确定重连
        self:onNetLoading()

        local socket = self:getSocket()
        socket:reconnect()
    end

    local cancel = function()
        logout()
    end

     getOtherModule():showConfirmDialog(sure, cancel, Localize.query("NetManage.3"))

end

--连接ing
function NetManage:onNetLoading()
    cclog("-----onNetLoading--------")
    getOtherModule():showNetLoading()
end

--remove 连接ing
function NetManage:onRemoveNetLoading()
    getOtherModule():removeNetLoading()
end

--接受网络协议
function NetManage:onReceiveMsg(comid, data)
    self:onRemoveNetLoading()

    local scene = game.getRunningScene()
    if scene.onNetMsgUpdateUI ~= nil then
        game.getRunningScene():onNetMsgUpdateUI(comid, data)
    end
    --[[if ISSHOW_GUIDE then
        getNewGManager():onNetReceive(comid, data)
    end]]--

end

--连接网络
function NetManage:connectNet()
    local socket = self:getSocket()
    socket:connect(SOCKET_URL,SOCKET_PORT)
end

function NetManage:sendPreLoadNet()
    self:getEquipNet():sendGetEquipMsg()                  --装备
    table.insert(g_netResponselist, 1)
    self:getEquipNet():sendGetChipsMsg()                  --装备碎片
    table.insert(g_netResponselist, 1)
    self:getInstanceNet():sendGetAllStageInfoMsg()        --关卡信息
    table.insert(g_netResponselist, 1)
    self:getSoldierNet():sendGetSoldierMsg()              --武将
    table.insert(g_netResponselist, 1)
    self:getSoldierNet():sendGetSoldierPatch()            --武将碎片
    table.insert(g_netResponselist, 1)
    self:getBagNet():sendGetPropList()                    --背包道具
    table.insert(g_netResponselist, 1)
    self:getInstanceNet():sendGetAllChapterPrizeMsg()     --章节奖励
    table.insert(g_netResponselist, 1)

    self:getLineUpNet():sendGetLineUpMsg()                --阵容信息
    table.insert(g_netResponselist, 1)

    self:getEmailNet():sendGetEmailListMsg()              -- 邮件列表
    table.insert(g_netResponselist, 1)

    self:getActivityNet():sendGetLastTimeMsg()            -- 上次领取体力时间
    table.insert(g_netResponselist, 1)
    self:getActivityNet():sendGetSignListMsg()            -- 已经签到列表
    table.insert(g_netResponselist, 1)
    self:getActivityNet():sendGetOnlineLevelGiftList()    -- 在线奖励和等级奖励的初始化列表
    table.insert(g_netResponselist, 1)
    self:getActivityNet():sendGetLoginGiftListMsg()       -- 登陆奖励的初始化列表
    table.insert(g_netResponselist, 1)
    self:getActivityNet():sendGetRechargeListMsg()       -- 充值活动初始化
    table.insert(g_netResponselist, 1)
    self:getActivityNet():sendGetBrewInfoMsg()
    table.insert(g_netResponselist, 1)
    self:getLegionNet():sendGetLegionInfo()               --发送获取公会信息
    self:getLegionNet():sendGetApplyList()               --发送获取公会申请列表信息
    table.insert(g_netResponselist, 1)
    self:getArenaNet():sendGetArenaList()                 --竞技场中竞技列表
    -- self:getArenaNet():sendGetRankList()                  --竞技场中排行列表
    -- self:getArenaNet():sendGetExchangeList()              --竞技场中兑换列表
    table.insert(g_netResponselist, 1)
    self:getShopNet():sendGetShopList(24)                    --VIP礼包

    local data = { boss_id = "world_boss" }                 --世界boss
    self:getBossNet():sendGetBossInfo(data)
    -- table.insert(g_netResponselist, 1)
    self:getChatNet()
    -- table.insert(g_netResponselist, 1)
    self:getActiveNet():sendGetTaskList()                 --活跃度任务列表
    -- table.insert(g_netResponselist, 1)
    self:getSecretPlaceNet():getMineBaseInfo()            --获取秘境信息
    -- table.insert(g_netResponselist, 1)
    self:getTravelNet():sendGetTravelInitResponse()      --游历
    table.insert(g_netResponselist, 1)
    -- 获取我的资源矿信息
    data = {}
    data.position = 0
    self:getSecretPlaceNet():getDetailInfo(data)
    -- table.insert(g_netResponselist, 1)
    -- 必须把这个放到最后
     self:getFriendNet():sendGetFriendListMsg()            -- 发送接收好友列表
     -- table.insert(g_netResponselist, 1)
end

-- 队列升级之后发送的协议  --需要重新获取或者手动改动
function NetManage:sendMsgAfterPlayerUpgrade()
    self:getSoldierNet():sendGetSoldierMsg()
    self:getLineUpNet():sendGetLineUpMsg()
end

function NetManage:getSocket()
    if g_Socket == nil then
        g_Socket = Socket.new()
        g_Socket:setDelegate(self)
    end
    return g_Socket
end

function NetManage:getTravelNet()
    if self.travelNet == nil then
        self.travelNet = TravelNet.new()
    end

    return self.travelNet
end

function NetManage:getHeadNet()
    if self.headNet == nil then
        self.headNet = HeadNet.new()
    end

    return self.headNet
end

function NetManage:getInheritNet()
    if self.inheritNet == nil then
        self.inheritNet = InheritNet.new()
    end

    return self.inheritNet
end

function NetManage:getSecretPlaceNet()
    if self.SecretPlaceNet == nil then
        self.SecretPlaceNet = SecretPlaceNet.new()
    end

    return self.SecretPlaceNet
end

function NetManage:getEmailNet()
    if self.emailNet == nil then
        self.emailNet = EmailNet.new()
    end

    return self.emailNet;
end

function NetManage:getSoldierNet()
    if self.soldierNet == nil then
        self.soldierNet = SodierNet.new()
    end

    return self.soldierNet
end

function NetManage:getSacrificeNet()
    if self.sacrificeNet == nil then
        self.sacrificeNet = SacrificeNet.new()
    end

    return self.sacrificeNet
end

function NetManage:getFriendNet()
	if self.friendNet == nil then
		self.friendNet = FriendNet.new()
	end
	return self.friendNet;
end

function NetManage:getLoginNet()
	if self.loginNet == nil then
		self.loginNet = LoginNet.new()
	end
	return self.loginNet
end

--初始化加载数据加载
function NetManage:loadData()

end

--背包
function NetManage:getBagNet()
    if self.bagNet == nil then
        self.bagNet = BagNet.new()
    end
    return self.bagNet
end

--获取装备数据实例
function NetManage:getEquipNet()
    if self.equipNet == nil then
        self.equipNet = EquipNet.new()
    end
    return self.equipNet
end

--军团
function NetManage:getLegionNet()
    if self.legionNet == nil then
        self.legionNet = LegionNet.new()
    end
    return self.legionNet
end

function NetManage:getLineUpNet()
    if self.lineUpNet == nil then
        self.lineUpNet = LineUpNet.new()
    end
    return self.lineUpNet
end


--获取商城实例
function NetManage:getShopNet()
    if self.shopNet == nil then
        self.shopNet = ShopNet.new()
    end
    return self.shopNet
end

--聊天
function NetManage:getChatNet()
    if self.chatNet == nil then
        self.chatNet = ChatNet.new()
    end
    return self.chatNet
end

--关卡
function NetManage:getInstanceNet()
    if self.instanceNet == nil then
        self.instanceNet = InstanceNet.new()
    end
    return self.instanceNet
end

--活动
function NetManage:getActivityNet()
    if self.activityNet == nil then
        self.activityNet = ActivityNet.new()
    end
    return self.activityNet
end

--竞技场
function NetManage:getArenaNet()
    if self.arenaNet == nil then
        self.arenaNet = ArenaNet.new()
    end
    return self.arenaNet
end

--世界Boss
function NetManage:getBossNet()
    if self.bossNet == nil then
        self.bossNet = BossNet.new()
    end
    return self.bossNet
end

--活跃度
function NetManage:getActiveNet()
    if self.activeNet == nil then
        self.activeNet = ActiveDegreeNet.new()
    end
    return self.activeNet
end

--新手引导
function NetManage:getNewBieNet()
    if self.newBieNet == nil then
        self.newBieNet = NewBieNet.new()
    end
    return self.newBieNet
end

--符文
function NetManage:getRuneNet()
    if self.runeNet == nil then
        self.runeNet = RuneNet.new()
    end
    return self.runeNet
end

--排行
function NetManage:getRankNet()
    if self.rankNet == nil then
        self.rankNet = RankNet.new()
    end
    return self.rankNet
end



function NetManage:clear()
    self.bagNet = nil                       --背包
    self.soldierNet = nil                   --武将
    self.loginNet = nil                     --登陆
    self.friendNet = nil                    -- 社交
    self.legionNet = nil                    --公会
    self.sacrificeNet = nil                 -- 献祭
    self.lineUpNet = nil                    --阵容
    self.chatNet = nil                      --聊天
    self.emailNet = nil                     --邮件
    self.instanceNet = nil                  --关卡
    self.activityNet = nil                  --活动
    self.heartBeatNet = nil                 --心跳
    self.arenaNet = nil                     --竞技场
    self.bossNet = nil                      --世界Boss
    self.activeNet = nil                    --活跃度
    self.travelNet = nil                    --游历
    self.SecretPlaceNet = nil               --秘境

    self.inheritNet = nil                   --传承

    self.runeNet = nil                      --符文

    self.newBieNet = nil                    --新手引导
    self.shopNet = nil
    self.equipNet = nil                     --装备
    self.headNet = nil
    self.rankNet = nil
    self.dataCache_ = {}
end

--@return
return NetManage
