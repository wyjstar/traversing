-- 头像网络
local HeadNet = class("HeadNet", BaseNetWork)

NET_ID_HEAD_CHANGE = 847 


function HeadNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNet()
end

function HeadNet:init()
   
end

function HeadNet:sendChangeHead(id)
    cclog("----------------------- ChangeHeadRequest ----------------------------")
    local data = {}
    data.hero_id = id

    self:sendMsg(NET_ID_HEAD_CHANGE, "ChangeHeadRequest", data)
    cclog("-----------------------  ----------------------------")
end

--注册接受网络协议
function HeadNet:initRegisterNet()
    
    local function onChangeHeadCallBack(data)
        cclog("+++++++++++++++++++  onChangeHeadCallBack  ++++++++++++++++++++")
        -- local changeHeadResponse = getDataManager():getTravelData():getBuyShoesResponse()
        -- if data.res.result == false then
        --     self:toastShow("更换头像失败")
        --     return
        -- else
        --     self:toastShow("更换头像成功")
        -- end
        -- getDataManager():getCommonData():setHead(data)
    end
    
    self:registerNetMsg(NET_ID_HEAD_CHANGE, "ChangeHeadResponse", onChangeHeadCallBack)
end

return HeadNet
