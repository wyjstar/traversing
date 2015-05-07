-- 宝箱抽取第一个界面
--[[
    @ 如果免费直接在本页进行抽取免费的装备
]]

---------- 新版本被放弃 ------------


local PVShopChest = class(".PVShopChest", function ()
    return cc.Node:create()
end)


function PVShopChest:ctor(id)
    
    --初始化属性
    self:init()

    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI()
    --self:registerNetCallback()
end

--初始化属性
function PVShopChest:init()
    
    self.ccbiNode = {}
    self.ccbiRootNode = {}

    local function onNodeEvent(event)
        if "exit" == event then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)

end

function PVShopChest:onExit()
    self:removeAllScheduler()
end

function PVShopChest:clickedLeft()
    self:removeAllScheduler()
    SHOP_EQUIP_TYPE = 11
    if self._equipUseMoney == 0 then
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopChestNum", "free")
    else
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopChestNum")
    end
end

function PVShopChest:clickedRight()
    self:removeAllScheduler()
    SHOP_EQUIP_TYPE = 12        
    if self._godEquipUseMoney == 0 then
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopChestNum", "free")
    else
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopChestNum")
    end

end


--加载本界面的ccbi ui_shop_rc.ccbi
function PVShopChest:loadCCBI()

    self.ccbiNode["UIShopChest"] = {}
    self.ccbiNode["UIShopChest"]["menuClickA"] = menuClickA
    self.ccbiNode["UIShopChest"]["menuClickB"] = menuClickB

    local proxy = cc.CCBProxy:create()
    local rcView = CCBReaderLoad("shop/ui_shop_chest1.ccbi", proxy, self.ccbiNode)
    self:addChild(rcView)

    self.ccbiRootNode = self.ccbiNode["UIShopChest"]
    self.labelLeft1 = self.ccbiRootNode["label_left_1"]        --左边免费剩下时间提示label
    -- self.labelLeft2 = self.ccbiRootNode["label_left_2"]        --左边抽取所需金币提示label 
    self.labelRight1 = self.ccbiRootNode["label_right_1"]      --右边可免费招募剩余次数提示label
    -- self.labelRight2 = self.ccbiRootNode["label_right_2"]      --右边抽取神将所需金币提示label
    self.layerLeft = self.ccbiRootNode["layer_left"]
    self.layerRight = self.ccbiRootNode["layer_right"]
    self.bgLeftSelect = self.ccbiRootNode["img_bg_select_l"]
    self.bgRightSelect = self.ccbiRootNode["img_bg_select_r"]
    self.bgLeftSelect:setVisible(false)
    self.bgRightSelect:setVisible(false)

    -- 添加点击事件
    -- 点击到区域内进入
    local size = self.layerLeft:getContentSize()
    local rectArea = cc.rect(0, 0, size.width, size.height)
    self.layerLeft:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.layerLeft:setTouchEnabled(true)
    self.layerRight:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.layerRight:setTouchEnabled(true)
    local function onTouchEvent1(eventType, x, y)
        local _pos = self.layerLeft:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, _pos)
        if eventType == "began" then
            if isInRect then
                self.bgLeftSelect:setVisible(true)
                return true
            end
        elseif eventType == "ended" then
            if isInRect then
                getAudioManager():playEffectButton2()
                self:clickedLeft()
                self.bgLeftSelect:setVisible(false)
            end
            self.bgLeftSelect:setVisible(false)
        end
    end
    local function onTouchEvent2(eventType, x, y)
        local _pos = self.layerRight:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, _pos)
        if eventType == "began" then
            if isInRect then
                self.bgRightSelect:setVisible(true)
                return true
            end
        elseif  eventType == "ended" then
            if isInRect then
                getAudioManager():playEffectButton2()
                self:clickedRight()
            end
            self.bgRightSelect:setVisible(false)
        end
    end
    self.layerLeft:registerScriptTouchHandler(onTouchEvent1)
    self.layerRight:registerScriptTouchHandler(onTouchEvent2)

    -- 
    self:updateData()
end

function PVShopChest:updateData()

    local shopTemplate = getTemplateManager():getShopTemplate()
    local _commonData = getDataManager():getCommonData()
    self._equipUseMoney = shopTemplate:getEquipUseMoney()
    self._godEquipUseMoney = shopTemplate:getGodEquipUseMoney()

    -- self.labelLeft2:setString(string.format(self._equipUseMoney))
    -- self.labelRight2:setString(string.format(self._godEquipUseMoney))
    self.labelLeft1:setString("")
    self.labelRight1:setString("")

    ----良装

    self.preEquipTime = _commonData:getFineEquipment()   -- 上次免费抽奖时间
    self.preGodEquipTime = _commonData:getExcellentEquipment()
    self.currTime = _commonData:getTime()
    self.equipFreePeriod = shopTemplate:getEquipFreePeriod() * 3600 -- 免费周期（sec）
    self.godEquipFreePeriod = shopTemplate:getGodEquipFreePeriod() * 3600 

    self.diffTime1 = os.difftime(self.currTime, self.preEquipTime)
    self.diffTime2 = os.difftime(self.currTime, self.preGodEquipTime)

    local function updateTimer1(dt)
        self.diffTime1 = self.diffTime1 + 1
        if self.diffTime1 > self.equipFreePeriod then
            -- 免费，停止倒计时
            timer.unscheduleGlobal(self.scheduer1)
            self.scheduer1 = nil
            self.labelLeft1:setString( Localize.query("shop.5") )
            self._equipUseMoney = 0
        else
            -- 倒计时 剩余时间
            local _leftTime = self.equipFreePeriod - self.diffTime1
            self.labelLeft1:setString( string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
        end 
    end

    if self.diffTime1 < self.equipFreePeriod then
        self:removeScheduler1()
        self.scheduer1 = timer.scheduleGlobal(updateTimer1, 1.0)
    else
        self.labelLeft1:setString( Localize.query("shop.5") )
        self._equipUseMoney = 0
    end

    ----神装
    local function updateTimer2(dt)
        self.diffTime2 = self.diffTime2 + 1
        if self.diffTime2 > self.godEquipFreePeriod then  -- 免费，停止倒计时    
            timer.unscheduleGlobal(self.scheduer2)
            self.scheduer2 = nil
            self._godEquipUseMoney = 0
        else  -- 倒计时 剩余时间
            local _leftTime = self.godEquipFreePeriod - self.diffTime2
            self.labelRight1:setString( string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
        end 
    end

    if self.diffTime2 < self.godEquipFreePeriod then
        self:removeScheduler2()
        self.scheduer2 = timer.scheduleGlobal(updateTimer2, 1.0)
    else
        self.labelRight1:setString( Localize.query("shop.5") )
        self._godEquipUseMoney = 0
    end

end


function PVShopChest:letEnabled(flag)
    self.layerLeft:setTouchEnabled(flag)
    self.layerRight:setTouchEnabled(flag)
end

function PVShopChest:removeAllScheduler()
    self:removeScheduler1()
    self:removeScheduler2()
end

function PVShopChest:removeScheduler1()
    if self.scheduer1 ~= nil then 
        timer.unscheduleGlobal(self.scheduer1)
        self.scheduer1 = nil
    end
end

function PVShopChest:removeScheduler2()
    if self.scheduer2 ~= nil then
        timer.unscheduleGlobal(self.scheduer2)
        self.scheduer2 = nil
    end
end


--@return
return PVShopChest
