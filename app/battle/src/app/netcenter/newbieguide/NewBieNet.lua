
NewBieNet = class("NewBieNet", BaseNetWork)

NewbeeGuideStep = 1802
function NewBieNet:ctor()
    self.super.ctor(self, self.__cname)
    self:initRegisterNet()
end

function NewBieNet:setHttpLoginSuccessResponse(data)
    self.httpLoginSuccessResponse = data
end

function NewBieNet:sendDoGuideId(showLoading, id, common_id, sub_common_id)
    print("NewBieNet:sendDoGuideId=======id----" .. id, common_id, sub_common_id)
    local  _data = { step_id = id }
    --去掉特殊处理
    --[[if common_id then
        _data["common_id"] = common_id
    end
    if sub_common_id then
        _data["sub_common_id"] = sub_common_id        
    end]]--

    self:sendMsg(NewbeeGuideStep, "NewbeeGuideStepRequest", _data, showLoading)
end


--注册接受网络协议
function NewBieNet:initRegisterNet()

    local  function callBack(data)
        print("initRegisterNet_______callBack_")
        if data.res.result then
            getDataProcessor():gainGameResourcesResponse(data.gain)

            if data.gain.runt and #data.gain.runt > 0 then
                getDataManager():getRuneData():setBagRunes(data.gain.runt)
            end
        else
            print("------服务器返回失败---------")
        end
    end
    self:registerNetMsg(NewbeeGuideStep, "NewbeeGuideStepResponse", callBack)
end

return NewBieNet
