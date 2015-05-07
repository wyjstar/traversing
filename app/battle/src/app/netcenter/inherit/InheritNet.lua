-- 传承网络
local InheritNet = class("InheritNet", BaseNetWork)

NET_ID_INHERIT_REFINE = 151
NET_ID_INHERIT_EQUIPMENT = 152
NET_ID_INHERIT_UNPARA = 153

-- InheritRefineRequest
-- InheritEquipmentRequest
-- InheritUnparaRequest

function InheritNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNet()
end

function InheritNet:init()
   
end

--发送
function InheritNet:sendGetInheritRefineRequest(data)
    cclog("----------------------- sendGetInheritRefineRequest ----------------------------")
    self:sendMsg(NET_ID_INHERIT_REFINE,"InheritRefineRequest", data)
end
--发送

function InheritNet:sendGetInheritEquipmentRequest(data)
    cclog("----------------------- sendGetInheritEquipmentRequest ----------------------------")
    self:sendMsg(NET_ID_INHERIT_EQUIPMENT,"InheritEquipmentRequest", data)
end
--发送
function InheritNet:sendGetInheritUnparaRequest(data)
    cclog("----------------------- sendGetInheritUnparaRequest ----------------------------")
    self:sendMsg(NET_ID_INHERIT_UNPARA,"InheritUnparaRequest", data)
end


--注册接受网络协议
function InheritNet:initRegisterNet()
    
    local function onGetInheritResponseCallBack(data)
        cclog("+++++++++++++++++++  onGetInheritResponseCallBack  ++++++++++++++++++++")
        getDataManager():getInheritData():setInheritResponse(data)
    end

    self:registerNetMsg(NET_ID_INHERIT_REFINE, "CommonResponse", onGetInheritResponseCallBack)
    self:registerNetMsg(NET_ID_INHERIT_EQUIPMENT, "CommonResponse", onGetInheritResponseCallBack)
    self:registerNetMsg(NET_ID_INHERIT_UNPARA, "CommonResponse", onGetInheritResponseCallBack)
end

return InheritNet
