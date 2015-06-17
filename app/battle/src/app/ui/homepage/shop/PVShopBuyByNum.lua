
local PVShopBuyByNum = class("PVShopBuyByNum", BaseUIView)

function PVShopBuyByNum:ctor(id)
    self.super.ctor(self, id)
end

function PVShopBuyByNum:onMVCEnter()
    --game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
    self.shopTemp = getTemplateManager():getShopTemplate()
    self.bagTemplate = getTemplateManager():getBagTemplate()
    self.shopData = getDataManager():getShopData()

    self.UIShopBuyByNumView = {}
    self:initTouchListener()

    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_chooseAutoTime.ccbi", self.UIShopBuyByNumView)
    self:initData()
    self:initView() 
    
end 

function PVShopBuyByNum:initData()
    assert(self.funcTable ~= nil, "if you used DialogGetCard UI, you must to give a text in !")
    self.buyGoodId = self.funcTable[1]
    self.propItem = self.shopTemp:getTemplateById(self.buyGoodId)
    self.propId = self.propItem.gain["105"][3]
    self.vipNo = getDataManager():getCommonData():getVip()
end


function PVShopBuyByNum:initView()
     --ui使用变量绑定
    self.travelTime = self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["travelTime"]
    self.sliderLayer = self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["sliderLayer"]
    self.travelTimeDes = self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["travelTimeDes"]
    self.goldNum = self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["goldNum"]
    self.spriteTitle = self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["spriteTitle"]
    game.setSpriteFrame(self.spriteTitle,"#ui_travel_chooseBuyNum.png")
   
    --slider动态创建
    local sprite1 = game.newSprite("#ui_bag_slider1.png")
    local sprite2 = game.newSprite("#ui_bag_slider2.png")
    local sprite3 = game.newSprite("#ui_bag_sliderb.png")
    local sprite4 = game.newSprite("#ui_bag_sliderb.png")

    self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setMinimumValue(1)
    self.slider:setValue(1)

    -- self.slider:setMaximumValue(10)
    local vipLimte = self.shopTemp:getBuyVIPLimitNumById(self.buyGoodId,self.vipNo)
    local maxNum = self.shopTemp:getBuyMaxNumById(self.buyGoodId)
    if vipLimte~=0 and vipLimte <= maxNum then
        self.slider:setMaximumValue(vipLimte)
    else
        self.slider:setMaximumValue(maxNum)
    end
    self.slider:setPosition(0, 20)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.slider:registerControlEventHandler(function(pSender) self:sliderCallback(pSender)  end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.sliderLayer:addChild(self.slider)
    self.travelTime:setString("1个")
    local _name = self.bagTemplate:getItemName(self.propId)
    self.travelTimeDes:setString(_name)

    self.curNumber = 1

    self:setGoldNum()

    
end

function PVShopBuyByNum:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    --确定
    local function onMakeSureBtn()

        -- local data = {}

        -- if self.curNumber >0 then
        --     local _subdata = {}
        --     data.ids = {self.buyGoodId}
        --     data.item_count = {self.curNumber}
        --     -- table.insert(data.shoes_infos, _subdata)
        -- end
        if self.allGoldNum > getDataManager():getCommonData():getGold() then
            -- self:toastShow("金币不足")
            getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
            return
        end

        self.shopData:setProBuyTypeAndMoney(2,self.allGoldNum)
        getNetManager():getShopNet():sendBuyGoods(self.buyGoodId,self.curNumber)
        self:onHideView()
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
    self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"] = {}
    self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["onCloseClick"] = onCloseClick
    self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["onMakeSureBtn"] = onMakeSureBtn
    self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["onLeftBtn"] = onLeftBtn
    self.UIShopBuyByNumView["UITravelChooseAutoTimeItem"]["onRightBtn"] = onRightBtn

end

function PVShopBuyByNum:setGoldNum(  )
    local useMoney = table.getValueByIndex(self.propItem.consume, 1)[1]
    _goldAll = useMoney * self.curNumber
    self.allGoldNum = _goldAll
    self.goldNum:setString(tostring(_goldAll))
end

function PVShopBuyByNum:sliderCallback(pSender)
    local _value = pSender:getValue()
    if _value==nil and string.len(_value)<=0 then return end
    local value = toint(_value)
    self.curNumber = math.ceil(value)
    -- if self.curNumber > 10 then
    --     self.curNumber = 10
    --     self.slider:setValue(self.curNumber)
    --     getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.1"))
    -- end

    local vipLimte = self.shopTemp:getBuyVIPLimitNumById(self.buyGoodId,self.vipNo)
    local maxNum = self.shopTemp:getBuyMaxNumById(self.buyGoodId)

    --todo 如果当前的数量大于还可以购买的数量那么返回
    if vipLimte ~= 0 and self.shopData:getProLimitOneDayById(self.buyGoodId) + self.curNumber > vipLimte then

        if self.buyGoodId == 30003 then
            getOtherModule():showAlertDialog(nil, Localize.query("basic.4"))
        elseif self.buyGoodId == 30002 then
            getOtherModule():showAlertDialog(nil, Localize.query("basic.5"))
        end
        self.slider:setValue(vipLimte-self.shopData:getProLimitOneDayById(self.buyGoodId))
    end

    if vipLimte~=0 and vipLimte <= maxNum then
        if self.curNumber > vipLimte then
            self.curNumber = vipLimte
            self.slider:setValue(self.curNumber)
            getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.1"))
        end
    else
        if self.curNumber > maxNum then
            self.curNumber = maxNum
            self.slider:setValue(self.curNumber)
            getOtherModule():showAlertDialog(nil, Localize.query("PVTravelChooseBuyNum.1"))
        end
    end
    
    self.travelTime:setString(self.curNumber.."个")
    self:setGoldNum()   
end


function PVShopBuyByNum:onReloadView()
   
end

return PVShopBuyByNum

