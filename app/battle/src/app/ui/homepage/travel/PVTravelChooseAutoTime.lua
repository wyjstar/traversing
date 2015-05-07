--游历
--选择自动游历时长
local PVTravelChooseAutoTime = class("PVTravelChooseAutoTime", BaseUIView)

function PVTravelChooseAutoTime:ctor(id)
    self.super.ctor(self, id)
end

function PVTravelChooseAutoTime:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
    --self:showAttributeView()

    self.UITravelChooseAutoTimeItem = {}

    self:initTouchListener()
    self.tag = self:getTransferData()[1]

    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_chooseAutoTime.ccbi", self.UITravelChooseAutoTimeItem)
    print("***************")
    self:initView() 

     
end

function PVTravelChooseAutoTime:onExit()
    --self:unregisterScriptHandler()
    --game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

end

function PVTravelChooseAutoTime:initView()
     --ui使用变量绑定
    self.travelTime = self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["travelTime"]
    self.sliderLayer = self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["sliderLayer"]
    self.travelTimeDes = self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["travelTimeDes"]
    self.goldNum = self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["goldNum"]

   
    --slider动态创建
    local sprite1 = game.newSprite("#ui_bag_slider1.png")
    local sprite2 = game.newSprite("#ui_bag_slider2.png")
    local sprite3 = game.newSprite("#ui_bag_sliderb.png")
    local sprite4 = game.newSprite("#ui_bag_sliderb.png")

    self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setMinimumValue(1)
    self.slider:setValue(1)
    local taNum = getTemplateManager():getBaseTemplate():getAutoNum()            --自动游历阶段数
    self.slider:setMaximumValue(taNum)
    self.slider:setPosition(0, 20)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.slider:registerControlEventHandler(function(pSender) self:sliderCallback(pSender)  end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.sliderLayer:addChild(self.slider)
    self.travelTime:setString("30分钟/8小时")
    self.travelTimeDes:setString("30分钟可游历5次")

    self.curNumber = 1
    -- self.autoTravelPrice = 50
    local autoTimeNum = self.curNumber*30
    autoTimeTimes = getTemplateManager():getBaseTemplate():getAutoTimeTimes(autoTimeNum)
    self.autoTravelPrice = getTemplateManager():getBaseTemplate():getAutoTravelPrice(autoTimeNum)
    self.goldNum:setString(self.autoTravelPrice) 
end




function PVTravelChooseAutoTime:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    --确定，开始自动游历
    local function onMakeSureBtn()

        print(self.autoTravelPrice)
        local allGold = getDataManager():getCommonData():getGold()
        if self.autoTravelPrice <= allGold then
            -- getDataManager():getCommonData():subGold(tonumber(self.autoTravelPrice))
        else
            -- self:toastShow(Localize.query("activity.5"))
            getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
            return
        end

        tag = self.tag
        curNumber = self.curNumber*30
        autoTravelPrice = self.autoTravelPrice
        self:onHideView()
        getModule(MODULE_NAME_LINEUP):removeLastView()
        -- getOtherModule():showOtherView("PVTravelTraveling", tag, curNumber)
        print(">>>>>>price:"..autoTravelPrice)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelTraveling", tag, curNumber, autoTravelPrice)
        tag = nil
        curNumber = nil
        autoTravelPrice = nil
    end
    local function onLeftBtn()
        self.curNumber = self.curNumber - 1
        if self.curNumber < 1 then
            self.slider:setValue(1)
        else
            self.slider:setValue(self.curNumber)
        end
    end
    local function onRightBtn()
        self.curNumber = self.curNumber + 1
        self.slider:setValue(self.curNumber)
    end
    self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"] = {}
    self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["onCloseClick"] = onCloseClick
    self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["onMakeSureBtn"] = onMakeSureBtn
    self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["onLeftBtn"] = onLeftBtn
    self.UITravelChooseAutoTimeItem["UITravelChooseAutoTimeItem"]["onRightBtn"] = onRightBtn
end

function PVTravelChooseAutoTime:sliderCallback(pSender)
    local _value = pSender:getValue()
    if _value==nil and string.len(_value)<=0 then return end
    local value = toint(_value)
    self.curNumber = math.ceil(value)
    --self.curNumber = math.ceil(pSender:getValue())

    local autoTimeNum = self.curNumber*30 --getTemplateManager():getBaseTemplate():getAutoTimeNum(self.curNumber)
    --print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..autoTimeNum)
    local autoTimeTimes = 0
    -- self.autoTravelPrice = 0
    if autoTimeNum == 0 then 
    else
        autoTimeTimes = getTemplateManager():getBaseTemplate():getAutoTimeTimes(autoTimeNum)
        self.autoTravelPrice = getTemplateManager():getBaseTemplate():getAutoTravelPrice(autoTimeNum)
    end
    --local autoTravelTime = autoTimeNum/60
    local taNum = (getTemplateManager():getBaseTemplate():getAutoNum()/2)
    --分钟小时的转换
    if math.ceil(autoTimeNum/60)-1 == 0 then
        if autoTimeNum == 60 then
            self.travelTime:setString(tostring(1).."小时／" .. taNum.. "小时")
            self.travelTimeDes:setString(tostring(1).."小时可游历"..autoTimeTimes.."次")
        else
            self.travelTime:setString(tostring(autoTimeNum).."分钟／" .. taNum.. "小时")
            self.travelTimeDes:setString(tostring(autoTimeNum).."分钟可游历"..autoTimeTimes.."次")
        end
    else
        if autoTimeNum%60 == 0 then
            self.travelTime:setString(tostring(math.ceil(autoTimeNum/60)).."小时／" .. taNum.. "小时")
            self.travelTimeDes:setString(tostring(math.ceil(autoTimeNum/60)).."小时可游历"..tostring(autoTimeTimes).."次")
        else
            self.travelTime:setString(tostring(math.ceil(autoTimeNum/60)-1).."小时"..tostring(autoTimeNum%60).."分钟／" .. taNum.. "小时")
            self.travelTimeDes:setString(tostring(math.ceil(autoTimeNum/60)-1).."小时"..tostring(autoTimeNum%60).."分钟可游历"..autoTimeTimes.."次")
        end

    end

    --self.travelTime:setString(autoTimeNum/60.."分钟／4小时")
    --self.travelTimeDes:setString(autoTimeNum.."分钟可游历"..autoTimeTimes.."次")
    self.goldNum:setString(self.autoTravelPrice)   
end

function PVTravelChooseAutoTime:onReloadView()
   
end

return PVTravelChooseAutoTime
