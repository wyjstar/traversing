-- 招募窗口ui

local PVShopRecruit = class(".PVShopRecruit", function ()
    return cc.Node:create()
end)


function PVShopRecruit:ctor(id)
    --初始化属性
    self:init()
    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI()
end

--初始化属性
function PVShopRecruit:init()

    self.ccbiNode = {}
    self.ccbiRootNode = {}

    local function onNodeEvent(event)
        if "exit" == event then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function PVShopRecruit:onExit()
    self:removeAllScheduler()
end

function PVShopRecruit:clickedLeft()  --招募良将
    self:removeAllScheduler()
    getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuy", self._heroUseMoney)
    --stepCallBack(G_GUIDE_20079)
end
function PVShopRecruit:clickedRight()  --招募神将
    self:removeAllScheduler()
    getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuyGod", self._godHeroUseMoney)
    --stepCallBack(G_GUIDE_20101)
    groupCallBack(GuideGroupKey.BTN_CLICK_ZHAOJIANG)
end

--加载本界面的ccbi ui_shop_rc.ccbi
function PVShopRecruit:loadCCBI()

    local proxy = cc.CCBProxy:create()
    local rcView = CCBReaderLoad("shop/ui_shop_rc.ccbi", proxy, self.ccbiNode)
    self:addChild(rcView)

    self.ccbiRootNode = self.ccbiNode["UIShopRecruit"]
    self.labelLeft1 = self.ccbiRootNode["label_left_1"]        --左边免费剩下时间提示label
    self.labelLeft2 = self.ccbiRootNode["label_left_2"]        --左边抽取所需金币提示label 
    self.labelRight1 = self.ccbiRootNode["label_right_1"]      --右边可免费招募剩余次数提示label
    self.labelRight2 = self.ccbiRootNode["label_right_2"]      --右边抽取神将所需金币提示label
    self.layerLeft = self.ccbiRootNode["layer_left"]
    self.layerRight = self.ccbiRootNode["layer_right"]
    self.bgLeftSelect = self.ccbiRootNode["img_bg_select_l"]
    self.bgRightSelect = self.ccbiRootNode["img_bg_select_r"]
    self.heroRedDot = self.ccbiRootNode["heroRedDot"]
    self.godHeroRedDot = self.ccbiRootNode["godHeroRedDot"]
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
        elseif  eventType == "ended" then
            if isInRect then
                getAudioManager():playEffectButton2()
                self:clickedLeft()
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
        elseif eventType == "ended" then
            if isInRect then
                getAudioManager():playEffectButton2()
                self:clickedRight()
            end
            self.bgRightSelect:setVisible(false)
        end
    end
    self.layerLeft:registerScriptTouchHandler(onTouchEvent1)
    self.layerRight:registerScriptTouchHandler(onTouchEvent2)

    -- 免费抽取剩余时间    
    self:updateData()
end

function PVShopRecruit:letEnabled(flag)
    self.layerLeft:setTouchEnabled(flag)
    self.layerRight:setTouchEnabled(flag)
end

-- 更新数据
function PVShopRecruit:updateData()
    
    local shopTemplate = getTemplateManager():getShopTemplate()
    local _commonData = getDataManager():getCommonData()
    self._heroUseMoney = shopTemplate:getHeroUseMoney()
    self._godHeroUseMoney = shopTemplate:getGodHeroUseMoney()

    -- 需要多少钱
    self.labelLeft1:setString("")
    self.labelRight1:setString("")

    -- 良将周期免费
    self.preHeroTime = _commonData:getFineHero()
    self.preGodHeroTime = _commonData:getExcellentHero()
    -- self.currTime = os.time()
    self.currTime = _commonData:getTime()   --应该获取服务器时间
    self.heroFreePeriod = shopTemplate:getHeroFreePeriod() * 3600 -- 免费周期（sec）
    self.godHeroFreePeriod = shopTemplate:getGodHeroFreePeriod() * 3600 

    self.diffTime1 = os.difftime(self.currTime, self.preHeroTime)
    self.diffTime2 = os.difftime(self.currTime, self.preGodHeroTime)

    local function updateTimer1(dt)
        self.diffTime1 = self.diffTime1 + 1
        if self.diffTime1 > self.heroFreePeriod then
            -- 免费，停止倒计时
            timer.unscheduleGlobal(self.scheduer1)
            self.scheduer1 = nil
            self.labelLeft1:setString( Localize.query("shop.5") )
            self._heroUseMoney = 0
            self.heroRedDot:setVisible(true)
        else
            -- 倒计时 剩余时间
            local _leftTime = self.heroFreePeriod - self.diffTime1
            self.labelLeft1:setString( string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
            self.heroRedDot:setVisible(false)
        end 
    end

    if self.diffTime1 < self.heroFreePeriod then
        self:removeScheduler1()
        self.scheduer1 = timer.scheduleGlobal(updateTimer1, 1.0)
        self.heroRedDot:setVisible(false)
    else
        self.labelLeft1:setString( Localize.query("shop.5") )
        self._heroUseMoney = 0
        self.heroRedDot:setVisible(true)
    end

    ---- 神将周期免费
    local function updateTimer2(dt)
        self.diffTime2 = self.diffTime2 + 1
        if self.diffTime2 > self.godHeroFreePeriod then  -- 免费，停止倒计时    
            timer.unscheduleGlobal(self.scheduer2)
            self.scheduer2 = nil
            self._godHeroUseMoney = 0
            self.godHeroRedDot:setVisible(true)
        else  -- 倒计时 剩余时间
            local _leftTime = self.godHeroFreePeriod - self.diffTime2
            self.labelRight1:setString( string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
            self.godHeroRedDot:setVisible(false)
        end 
    end     

    if self.diffTime2 < self.godHeroFreePeriod then
        self:removeScheduler2()
        self.scheduer2 = timer.scheduleGlobal(updateTimer2, 1.0)
        self.godHeroRedDot:setVisible(false)
    else
        self.labelRight1:setString( Localize.query("shop.5") )
        self.godHeroRedDot:setVisible(true)
        self._godHeroUseMoney = 0
    end

end

-- remove all scheduler
function PVShopRecruit:removeAllScheduler()
    self:removeScheduler1()
    self:removeScheduler2()
end

function PVShopRecruit:removeScheduler1()
    if self.scheduer1 ~= nil then 
        timer.unscheduleGlobal(self.scheduer1)
        self.scheduer1 = nil
    end
end

function PVShopRecruit:removeScheduler2()
    if self.scheduer2 ~= nil then
        timer.unscheduleGlobal(self.scheduer2)
        self.scheduer2 = nil
    end
end


--@return
return PVShopRecruit
