-- 游历网络
local TravelNet = class("TravelNet", BaseNetWork)

NET_ID_TRAVEL_INIT = 830 -- 游历初始化
NET_ID_TRAVEL = 831 -- 发送游历   （如果是直接领取事件，返回的数据可以直接加入到背包）
NET_ID_TRAVEL_BUY_SHOES = 832 -- 购买鞋
NET_ID_TRAVEL_SETTLE = 833 -- 游历结算  （暂时使用在等待时间和答题两个事件上）
NET_ID_TRAVEL_WAITEVENT = 834 -- 稍后获得  战斗之前需要发给协议
NET_ID_TRAVEL_NOWAITEVENT = 835 -- (打斗事件和等待时间事件中的立即获得)
NET_ID_TRAVEL_GAINBOX = 836 -- 领取宝箱
NET_ID_TRAVEL_AUTOTRAVEL = 837 -- 自动游历
NET_ID_TRAVEL_SETTLEAUTO = 838 -- 自动游历领取
NET_ID_TRAVEL_FASTFINISH = 839 -- 自动游历立即完成



function TravelNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNet()
end

function TravelNet:init()
   
end

--发送初始化游历
function TravelNet:sendGetTravelInitResponse()
    cclog("----------------------- sendGetTravelInitResponse ----------------------------")
    self:sendMsg(NET_ID_TRAVEL_INIT)
end

--发送领取宝箱
function TravelNet:sendGetGainBox()
    cclog("----------------------- sendGetGainBox ----------------------------")
    self:sendMsg(NET_ID_TRAVEL_GAINBOX)
end

--自动游历

function TravelNet:sendAutoTravel(data)
    cclog("----------------------- AutoTravelRequest ----------------------------")
    self:sendMsg(NET_ID_TRAVEL_AUTOTRAVEL, "AutoTravelRequest", data)
    cclog("-----------------------  ----------------------------")
end

--自动游历,领取
function TravelNet:sendSettleAutoTravel(data)
    cclog("----------------------- SettleAutoRequest ----------------------------")
    -- table.print(data)
    self:sendMsg(NET_ID_TRAVEL_SETTLEAUTO, "SettleAutoRequest", data)
    cclog("-----------------------end----------------------------")
end

--自动游历,立即完成
function TravelNet:sendFastFinishRequest(data)
    cclog("----------------------- FastFinishAutoRequest ----------------------------")
    -- table.print(data)
    self:sendMsg(NET_ID_TRAVEL_FASTFINISH, "FastFinishAutoRequest", data)
    cclog("-----------------------end----------------------------")
end

--发送游历请求游历事件
--@param data TravelRequest数据结构
function TravelNet:sendTravelRequest(data)
    cclog("----------------------- sendTravelRequest ----------------------------")
    self:sendMsg(NET_ID_TRAVEL, "TravelRequest", data)
end

--发送购买鞋子
--@param data BuyShoesRequest数据结构
function TravelNet:sendBuyShoesRequest(data)
    cclog("----------------------- BuyShoesRequest ----------------------------")
    self:sendMsg(NET_ID_TRAVEL_BUY_SHOES, "BuyShoesRequest", data)
end

--游历结算
--@param data TravelSettleRequest数据结构
function TravelNet:sendTravelSettleRequest(data)
    cclog("----------------------- TravelSettleRequest ----------------------------")
    self:sendMsg(NET_ID_TRAVEL_SETTLE, "TravelSettleRequest", data)
end

--稍后获得
--@param data WaitEventStartRequest数据结构
function TravelNet:sendWaitEventStartRequest(data)
    cclog("----------------------- EventStartRequest ----------------------------")
    self:sendMsg(NET_ID_TRAVEL_WAITEVENT, "EventStartRequest", data)
end

--（打斗的和等待时间立即获得）
--@param data NoWaitRequest数据结构
function TravelNet:sendNoWaitRequest(data)
    cclog("----------------------- NoWaitRequest ----------------------------")
    self:sendMsg(NET_ID_TRAVEL_NOWAITEVENT, "NoWaitRequest", data)
end

--注册接受网络协议
function TravelNet:initRegisterNet()
    
    local function onGetTravelInitResponseCallBack(data)
        cclog("+++++++++++++++++++  onGetTravelInitResponseCallBack  ++++++++++++++++++++")
        table.print(data)
        getDataManager():getTravelData():setTravelInitResponse(data)
        
    end

    local function onGainBoxCallBack(data)
        cclog("+++++++++++++++++++  onGainBoxCallBack  ++++++++++++++++++++")
        -- table.print(data)

        getDataManager():getTravelData():setOpenChestResponse(data)
        
    end

    local function onTravelResponseCallBack(data)
        cclog("+++++++++++++++++++  onTravelResponseCallBack  ++++++++++++++++++++ ")
        table.print(data)
         getDataManager():getTravelData():setTravelResponse(data)
    end

    local function onBuyShoesCallBack(data)
        cclog("+++++++++++++++++++  onBuyShoesCallBack  ++++++++++++++++++++ ")


        getDataManager():getTravelData():setBuyShoesResponse(data)
    end

    local function onTravelSettleResponseCallback(data)
        cclog("+++++++++++++++++++  onTravelSettleResponseCallback  ++++++++++++++++++++  ")
        
        -- table.print(data)

        getDataManager():getTravelData():setTravelSettleResponse(data)
    end

    local function onWaitEventStartResponseCallback(data)
        cclog("+++++++++++++++++++  onWaitEventStartResponseCallback  ++++++++++++++++++++  ")
        
        -- table.print(data)

        getDataManager():getTravelData():setWaitEventStartResponse(data)
    end

    local function onNoWaitResponseCallback(data)
        cclog("+++++++++++++++++++  onTravelSettleResponseCallback  ++++++++++++++++++++  ")
        getDataManager():getTravelData():setNoWaitResponse(data)
    end

    local function onAutoTravelResponseCallback(data)
        cclog("+++++++++++++++++++  onAutoTravelResponseCallback  ++++++++++++++++++++  ")

        -- table.print(data)
        getDataManager():getTravelData():setAutoTravelResponse(data)
    end
    local function onSettleAutoResponseCallback(data)
        cclog("+++++++++++++++++++  onSettleAutoResponseCallback  ++++++++++++++++++++  ")
        -- table.print(data)
        getDataManager():getTravelData():setSettleAutoResponse(data)

    end
    local function onFastFinishAutoResponseCallback(data)
        cclog("+++++++++++++++++++  onFastFinishAutoResponseCallback  ++++++++++++++++++++  ")
        -- table.print(data)
        getDataManager():getTravelData():setFastFinishAutoResponse(data)

    end

    self:registerNetMsg(NET_ID_TRAVEL_GAINBOX, "OpenChestResponse", onGainBoxCallBack)
    self:registerNetMsg(NET_ID_TRAVEL_INIT, "TravelInitResponse", onGetTravelInitResponseCallBack)
    self:registerNetMsg(NET_ID_TRAVEL, "TravelResponse", onTravelResponseCallBack)
    self:registerNetMsg(NET_ID_TRAVEL_BUY_SHOES, "BuyShoesResponse", onBuyShoesCallBack)
    self:registerNetMsg(NET_ID_TRAVEL_SETTLE, "TravelSettleResponse", onTravelSettleResponseCallback)
    self:registerNetMsg(NET_ID_TRAVEL_WAITEVENT, "EventStartResponse", onWaitEventStartResponseCallback)
    self:registerNetMsg(NET_ID_TRAVEL_NOWAITEVENT, "NoWaitResponse", onNoWaitResponseCallback)
    self:registerNetMsg(NET_ID_TRAVEL_AUTOTRAVEL, "AutoTravelResponse", onAutoTravelResponseCallback)
    self:registerNetMsg(NET_ID_TRAVEL_SETTLEAUTO, "SettleAutoResponse", onSettleAutoResponseCallback)
    self:registerNetMsg(NET_ID_TRAVEL_FASTFINISH, "FastFinishAutoResponse", onFastFinishAutoResponseCallback)
    

end

return TravelNet
