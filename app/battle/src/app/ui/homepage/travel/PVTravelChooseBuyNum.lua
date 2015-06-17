--游历
--选择购买鞋子的数量
local PVTravelChooseBuyNum = class("PVTravelChooseBuyNum", BaseUIView)

function PVTravelChooseBuyNum:ctor(id)
    self.super.ctor(self, id)
end

function PVTravelChooseBuyNum:onMVCEnter()
    --game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

    self.UITravelBuyNumView = {}
    self:initTouchListener()

    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_chooseBuyNum.ccbi", self.UITravelBuyNumView)
    self:initView() 

    self:initRegisterNetCallBack()
    
end

function PVTravelChooseBuyNum:onExit()
    --self:unregisterScriptHandler()
    --game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

end

function PVTravelChooseBuyNum:initShoesImage(menu, sp, tag )
    local res, name = getTemplateManager():getBaseTemplate():getCaoXieResName(tag)

    res = res..".webp"
    res = "res/icon/resource/"..res

    sp:setTexture(res)


    local quality = getTemplateManager():getBaseTemplate():getCaoXiePin(tag)
    local resPin = ""
    -- 绿、蓝3星、蓝4星、紫5星、紫6星
    if quality == 1 or quality == 2 then 
        resPin = resPin.."#ui_common2_bg2_lv.png"
    elseif quality == 3 or quality == 4 then
        resPin = resPin.."#ui_common2_bg2_lan.png"
    elseif quality == 5 or quality == 6 then
        resPin = resPin.."#ui_common2_bg2_zi.png"
    end
    game.setSpriteFrame(menu:getNormalImage(), resPin) 

end

function PVTravelChooseBuyNum:initView()
    --ui使用变量绑定
    self.itemNumLabel1 = self.UITravelBuyNumView["UITravelBuyNumView"]["itemNumLabel1"]
    self.itemNumLabel1:setString(0)
    self.itemNumLabel2 = self.UITravelBuyNumView["UITravelBuyNumView"]["itemNumLabel2"]
    self.itemNumLabel2:setString(0)
    self.itemNumLabel3 = self.UITravelBuyNumView["UITravelBuyNumView"]["itemNumLabel3"]
    self.itemNumLabel3:setString(0)
    self.sliderLayer1 = self.UITravelBuyNumView["UITravelBuyNumView"]["sliderLayer1"]
    self.sliderLayer2 = self.UITravelBuyNumView["UITravelBuyNumView"]["sliderLayer2"]
    self.sliderLayer3 = self.UITravelBuyNumView["UITravelBuyNumView"]["sliderLayer3"]

    self.itemMenuItem1 = self.UITravelBuyNumView["UITravelBuyNumView"]["itemMenuItem1"]
    self.itemMenuItem2 = self.UITravelBuyNumView["UITravelBuyNumView"]["itemMenuItem2"]
    self.itemMenuItem3 = self.UITravelBuyNumView["UITravelBuyNumView"]["itemMenuItem3"]

    self.friendIcon1 = self.UITravelBuyNumView["UITravelBuyNumView"]["friendIcon1"]
    self.friendIcon2 = self.UITravelBuyNumView["UITravelBuyNumView"]["friendIcon2"]
    self.friendIcon3 = self.UITravelBuyNumView["UITravelBuyNumView"]["friendIcon3"]

    self.goldNum = self.UITravelBuyNumView["UITravelBuyNumView"]["goldNum"]

    

    self:initShoesImage(self.itemMenuItem1, self.friendIcon1, 1)
    self:initShoesImage(self.itemMenuItem2, self.friendIcon2, 2)
    self:initShoesImage(self.itemMenuItem3, self.friendIcon3, 3)




    --获取VIP等级
    self.viplevel = getDataManager():getCommonData():getVip()
    print(self.viplevel)
    self.buyShoeTimes = vip_config[self.viplevel].buyShoeTimes
    print(self.buyShoeTimes)

    self.buyNumMax = self.UITravelBuyNumView["UITravelBuyNumView"]["buyNumMax"]
    -- print("=============buy_shoe_times==============")
    -- table.print(getDataManager():getTravelData():getTravelInitResponse())
    -- table.print()

    self.buyCanNum = self.buyShoeTimes - getDataManager():getTravelData():getTravelInitResponse().buy_shoe_times
    self.buyNumMax:setString("今日还可购买"..self.buyCanNum.."双鞋子")

    --slider动态创建
    local sprite1 = game.newSprite("#ui_bag_slider1.png")
    local sprite2 = game.newSprite("#ui_bag_slider2.png")
    local sprite3 = game.newSprite("#ui_bag_sliderb.png")
    local sprite4 = game.newSprite("#ui_bag_sliderb.png")

    self.curNumber = 0
    self.curNumber2 = 0
    self.curNumber3 = 0
    -- self.shoesType = self:getTransferData()[1]
    -- --print("shoesType :::::::::::::::: "..self.shoesType)
    -- if self.shoesType == 1 then self.curNumber = 1 self.itemNumLabel1:setString(1) end
    -- if self.shoesType == 2 then self.curNumber2 = 1 self.itemNumLabel2:setString(1) end
    -- if self.shoesType == 3 then self.curNumber3 = 1 self.itemNumLabel3:setString(1) end

    self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setMinimumValue(0)
    -- self.slider:setScale(0.7)
    self.slider:setValue(curNumber)
    self.slider:setMaximumValue(self.buyCanNum)
    self.slider:setPosition(0, 16)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.slider:registerControlEventHandler(function(pSender) self:sliderCallback(pSender)  end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.sliderLayer1:addChild(self.slider)


    self.slider2 = cc.ControlSlider:create(cc.Sprite:createWithSpriteFrame(sprite1:getSpriteFrame()), 
                                            cc.Sprite:createWithSpriteFrame(sprite2:getSpriteFrame()), 
                                            cc.Sprite:createWithSpriteFrame(sprite3:getSpriteFrame()),
                                            cc.Sprite:createWithSpriteFrame(sprite4:getSpriteFrame()))
    self.slider2:setMinimumValue(0)
    -- self.slider2:setScale(0.7)
    self.slider2:setValue(curNumber2)
    self.slider2:setMaximumValue(self.buyCanNum)
    self.slider2:setPosition(0, 16)
    self.slider2:setAnchorPoint(cc.p(0,0.5))
    self.slider2:registerControlEventHandler(function(pSender) self:sliderCallback2(pSender)  end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.sliderLayer2:addChild(self.slider2)

    self.slider3 = cc.ControlSlider:create(cc.Sprite:createWithSpriteFrame(sprite1:getSpriteFrame()), 
                                            cc.Sprite:createWithSpriteFrame(sprite2:getSpriteFrame()), 
                                            cc.Sprite:createWithSpriteFrame(sprite3:getSpriteFrame()),
                                            cc.Sprite:createWithSpriteFrame(sprite4:getSpriteFrame()))
    self.slider3:setMinimumValue(0)
    -- self.slider3:setScale(0.7)
    self.slider3:setValue(curNumber3)
    self.slider3:setMaximumValue(self.buyCanNum)
    self.slider3:setPosition(0, 16)
    self.slider3:setAnchorPoint(cc.p(0,0.5))
    self.slider3:registerControlEventHandler(function(pSender) self:sliderCallback3(pSender)  end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.sliderLayer3:addChild(self.slider3)


    self:setGoldNum()

    
end

function PVTravelChooseBuyNum:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    --确定
    local function onTravelMakeSure()

        local data = {}
        data.shoes_infos = {}

        local _index = 1
        if self.curNumber >0 then
            local _subdata = {}
            _subdata.shoes_type = CAO_SHOES
            _subdata.shoes_no = self.curNumber
            table.insert(data.shoes_infos, _subdata)
        end

        if self.curNumber2 >0 then
            local _subdata = {}
            _subdata.shoes_type = BU_SHOES
            _subdata.shoes_no = self.curNumber2
            table.insert(data.shoes_infos, _subdata)
        end
        
        if self.curNumber3 >0 then
            local _subdata = {}
            _subdata.shoes_type = PI_SHOES
            _subdata.shoes_no = self.curNumber3
            table.insert(data.shoes_infos, _subdata)
        end
        -- local _baseconfig = getTemplateManager():getBaseTemplate()
        -- local _goldAll = 0
        -- for k,v in pairs(data.shoes_infos) do
        --     if v.shoes_type == CAO_SHOES then
        --         _goldAll = _goldAll + _baseconfig:getCaoXieGold()
        --     elseif v.shoes_type == BU_SHOES then
        --         _goldAll = _goldAll + _baseconfig:getBuXieGold()
        --     elseif v.shoes_type == PI_SHOES then
        --         _goldAll = _goldAll + _baseconfig:getPiXieGold()
        --     end
        -- end

        if self.allGoldNum > getDataManager():getCommonData():getGold() then
            -- self:toastShow("金币不足")
            getOtherModule():showAlertDialog(nil, Localize.query(101))
            return
        end
        if self.curNumber + self.curNumber2 + self.curNumber3 <= 0 then
            -- self:toastShow("请选择购买的鞋子数量")
            getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.2"))
            return
        end
        getNetManager():getTravelNet():sendBuyShoesRequest(data)
    end
    --物品
    local function onItemClick1()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 1)
    end
    --物品
    local function onItemClick2()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 2)
    end

    --物品
    local function onItemClick3()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 3)
    end

    --数值减小1
    local function onLeftBtn1()
        self.curNumber = self.curNumber - 1
        if self.curNumber < 0 then
            self.slider:setValue(0)
        else
            self.slider:setValue(self.curNumber)
        end
    end

    --数值增加1
    local function onRightBtn1()
        self.curNumber = self.curNumber + 1
        self.slider:setValue(self.curNumber)
    end
    
    --数值减小2
    local function onLeftBtn2()
        self.curNumber2 = self.curNumber2 - 1
        if self.curNumber2 < 0 then
            self.slider2:setValue(0)
        else
            self.slider2:setValue(self.curNumber2)
        end
    end

    --数值增加2
    local function onRightBtn2()
        self.curNumber2 = self.curNumber2 + 1
        self.slider2:setValue(self.curNumber2)
    end

    --数值减小3
    local function onLeftBtn3()
        self.curNumber3 = self.curNumber3 - 1
        if self.curNumber3 < 0 then
            self.slider3:setValue(0)
        else
            self.slider3:setValue(self.curNumber3)
        end
    end

    --数值增加3
    local function onRightBtn3()
        self.curNumber3 = self.curNumber3 + 1
        self.slider3:setValue(self.curNumber3)
    end
    
    self.UITravelBuyNumView["UITravelBuyNumView"] = {}
    self.UITravelBuyNumView["UITravelBuyNumView"]["onCloseClick"] = onCloseClick
    self.UITravelBuyNumView["UITravelBuyNumView"]["onItemClick1"] = onItemClick1
    self.UITravelBuyNumView["UITravelBuyNumView"]["onItemClick2"] = onItemClick2
    self.UITravelBuyNumView["UITravelBuyNumView"]["onItemClick3"] = onItemClick3
    self.UITravelBuyNumView["UITravelBuyNumView"]["onLeftBtn1"] = onLeftBtn1
    self.UITravelBuyNumView["UITravelBuyNumView"]["onRightBtn1"] = onRightBtn1
    self.UITravelBuyNumView["UITravelBuyNumView"]["onTravelMakeSure"] = onTravelMakeSure
    self.UITravelBuyNumView["UITravelBuyNumView"]["onLeftBtn2"] = onLeftBtn2
    self.UITravelBuyNumView["UITravelBuyNumView"]["onRightBtn2"] = onRightBtn2
    self.UITravelBuyNumView["UITravelBuyNumView"]["onLeftBtn3"] = onLeftBtn3
    self.UITravelBuyNumView["UITravelBuyNumView"]["onRightBtn3"] = onRightBtn3
    
end

function PVTravelChooseBuyNum:setGoldNum(  )
    local _baseconfig = getTemplateManager():getBaseTemplate()
    _goldAll = _baseconfig:getCaoXieGold()*self.curNumber + _baseconfig:getBuXieGold()*self.curNumber2 + _baseconfig:getPiXieGold()*self.curNumber3
    self.allGoldNum = _goldAll
    self.goldNum:setString(tostring(_goldAll))
end

function PVTravelChooseBuyNum:sliderCallback(pSender)
    local _value = pSender:getValue()
    if _value==nil and string.len(_value)<=0 then return end
    local value = toint(_value)
    self.curNumber = math.ceil(value)
    if self.curNumber > self.buyCanNum-self.curNumber3-self.curNumber2 then
        self.curNumber = self.buyCanNum-self.curNumber3-self.curNumber2
        self.slider:setValue(self.curNumber)
        -- self:toastShow(Localize.query("PVTravelChooseBuyNum.1"))
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.1"))
    end
    self.itemNumLabel1:setString(self.curNumber)
    self:setGoldNum()
    --print(self.curNumber)    
end

function PVTravelChooseBuyNum:sliderCallback2(pSender)
    local _value = pSender:getValue()
    if _value==nil and string.len(_value)<=0 then return end
    local value = toint(_value)
    self.curNumber2 = math.ceil(value)
    --self.curNumber2 = math.ceil(pSender:getValue())
    --print(self.curNumber2)
    if self.curNumber2 > self.buyCanNum-self.curNumber-self.curNumber3  then
        self.curNumber2 = self.buyCanNum-self.curNumber-self.curNumber3
        self.slider2:setValue(self.curNumber2)
        -- self:toastShow(Localize.query("PVTravelChooseBuyNum.1"))
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.1"))
    end
    self.itemNumLabel2:setString(self.curNumber2)
    self:setGoldNum()
end

function PVTravelChooseBuyNum:sliderCallback3(pSender)
    local _value = pSender:getValue()
    if _value==nil and string.len(_value)<=0 then return end

    local value = toint(_value)
    self.curNumber3 = math.ceil(value)
    --self.curNumber3 = math.ceil(pSender:getValue())
    if self.curNumber3 > self.buyCanNum-self.curNumber-self.curNumber2  then
        self.curNumber3 = self.buyCanNum-self.curNumber-self.curNumber2
        self.slider3:setValue(self.curNumber3)
        -- self:toastShow(Localize.query("PVTravelChooseBuyNum.1"))
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.1"))
    end
    --print(self.curNumber3)
    self.itemNumLabel3:setString(self.curNumber3) 
    self:setGoldNum() 
end

function PVTravelChooseBuyNum:initRegisterNetCallBack()
    function onReciveMsgCallBack(_id)
        if _id == NET_ID_TRAVEL_BUY_SHOES then -- 购买鞋子
            self:updateShoes()
        end
    end

    self:registerMsg(NET_ID_TRAVEL_BUY_SHOES, onReciveMsgCallBack)
end

function PVTravelChooseBuyNum:updateShoes()
    local _buyShoesResponse = getDataManager():getTravelData():getBuyShoesResponse()
    if _buyShoesResponse.res.result == false then
        -- self:toastShow("购买鞋子失败")
        getOtherModule():showAlertDialog(nil,  Localize.query("PVTravelChooseBuyNum.3"))
        return
    end
    
    getDataManager():getCommonData():subGold(self.allGoldNum)
    getDataManager():getTravelData():addBuyShoesNum(self.curNumber+self.curNumber2+self.curNumber3)

    -- 更新UI上鞋子数量
    getDataManager():getTravelData():addShoes(CAO_SHOES, self.curNumber)
    getDataManager():getTravelData():addShoes(BU_SHOES, self.curNumber2)
    getDataManager():getTravelData():addShoes(PI_SHOES, self.curNumber3)
        
    local event = cc.EventCustom:new(UPDATE_SHOES)
    self:getEventDispatcher():dispatchEvent(event)

    -- self:toastShow("购买鞋子成功")
    getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.4"))

    self:onHideView()
end

function PVTravelChooseBuyNum:onReloadView()
   
end

return PVTravelChooseBuyNum

