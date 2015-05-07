-- 招募神将

local PVShopRecruitBuyGod = class("PVShopRecruitBuyGod", BaseUIView)
godFlag = false

--免费招募成功通知
local REFRESH_RECRUIT_TIME__NOTICE = "REFRESH_RECRUIT_TIME__NOTICE"

function PVShopRecruitBuyGod:ctor(id)
    self.super.ctor(self, id)
    self:registerNetCallback()
    self.__flag = false
end

function PVShopRecruitBuyGod:showResult(data)
    local rec_type = getDataManager():getShopData():getShopRecruitType()
    if rec_type == 3 then return end

    print(" $$ ui response recruit God hero $$", id, data)
    print("----PVShopRecruitBuyGod:data-----")
    print("SHOP_EQUIP_TYPE ",SHOP_EQUIP_TYPE)
    table.print(data)

    local commonData = getDataManager():getCommonData()
    local shopTemplate = getTemplateManager():getShopTemplate()

    local function func()
        self.__flag = false
        -- if not godFlag then
        cclog("-12-3-4-5-2-2-2--1-1-1-1-1-1-1--2-2-2-1-1--1-1-1- ",data.gain)
            getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopShowCards", data.gain,2)
            godFlag = true
            groupCallBack(GuideGroupKey.BTN_CLICK_ZHAOMU)   
        -- end
    end
    self.blackHouse:setVisible(true)
    self.blackHouse:setOpacity(0)
    self.blackHouse:runAction( cc.FadeIn:create(1) )

     local function cancelEff()
        local size = self.layerTouch:getContentSize()
        local rectArea = cc.rect(0, 0, size.width, size.height)
        local function onTouchEvent(eventType, x, y)
            local _pos = self.layerTouch:convertToNodeSpace(cc.p(x,y))
            local isInRect = cc.rectContainsPoint(rectArea, _pos)
            if eventType == "began" then
                if isInRect then
                    getAudioManager():playEffectButton2()
                    cclog("--------PVShopRecruitBuyGod---------hahahaha")
                    self.animationNode:removeAllChildren()
                    func()
                    return true
                end
            elseif eventType == "ended" then
                --self.imgTokenLeft:setScale(1)
                return 
            end
        end
        cclog("这里是true的世界")
        self.layerTouch:setVisible(true)
        self.layerTouch:setTouchEnabled(true)
        self.layerTouch:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
        self.layerTouch:registerScriptTouchHandler(onTouchEvent)
    end

    if SHOP_EQUIP_TYPE == 3 then
        if self.godHeroUseMoney == 0 then 
            commonData:setExcellentHero(commonData:getTime())
        else
            commonData:subGold( self.godHeroUseMoney )  -- 扣除相应的钱
        end
        cancelEff()
        local node = UI_shangchengwujiangchouqu001(func)
        self.animationNode:addChild(node)
    elseif SHOP_EQUIP_TYPE == 4 then
        commonData:subGold( shopTemplate:getTenGodHeroUseMoney() )
        cancelEff()
        local node = UI_shangchengwujiangchouqushilianchou(func)
        self.animationNode:addChild(node)
    end

    --发送通知商店招募更新时间
    local eventDispatcher = cc.Director:getInstance():getRunningScene():getEventDispatcher()
    local event = cc.EventCustom:new(REFRESH_RECRUIT_TIME__NOTICE)
    eventDispatcher:dispatchEvent(event) 

end

-- 注册网络response回调
function PVShopRecruitBuyGod:registerNetCallback()
    local function responseCallback(id, data)  
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20028 then
            local guidInfo = getNewGManager():getCurrentInfo()
            getNewGManager():sendGuidProtocol(true, guidInfo["skip_to"])
        end
        self:showResult(data)
    end

    --[[local function getGoodsByGuidCallback(id, data)
        print(" getGoodsByGuidCallback ")
        table.print(data)
        
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20028 then
            self:showResult(data)
        end
    end]]--

    self:registerMsg(SHOP_REQUEST_HERO_CODE, responseCallback)
    --self:registerMsg(NewbeeGuideStep, getGoodsByGuidCallback)
end

function PVShopRecruitBuyGod:onMVCEnter()

    self:init()
    self:initTouchListener()
    self:loadCCBI("shop/ui_shop_wjcq.ccbi", self.ccbiNode)
    self:initView()
end


function PVShopRecruitBuyGod:init()
    self.ccbiNode = {}
    self.ccbiRootNode = {}
    
    self.heroesTable = getTemplateManager():getShopTemplate():getPreviewEpicHeroId()
    self.shopTemp = getTemplateManager():getShopTemplate()
end

-- 更新数据
function PVShopRecruitBuyGod:updateData()
    
    local shopTemplate = getTemplateManager():getShopTemplate()
    local _commonData = getDataManager():getCommonData()
    self.godHeroUseMoney = shopTemplate:getGodHeroUseMoney()

    -- 需要多少钱
    self.shen_label:setString("")

    self.preGodHeroTime = _commonData:getExcellentHero()
    self.currTime = _commonData:getTime()   --应该获取服务器时间
    self.godHeroFreePeriod = shopTemplate:getGodHeroFreePeriod() * 3600 
    self.diffTime2 = os.difftime(self.currTime, self.preGodHeroTime)

    ---- 神将周期免费
    local function updateTimer2(dt)
        self.diffTime2 = self.diffTime2 + 1
        if self.diffTime2 > self.godHeroFreePeriod then  -- 免费，停止倒计时    
            timer.unscheduleGlobal(self.scheduer2)
            self.scheduer2 = nil
            self.godHeroUseMoney = 0
            -- self.godHeroRedDot:setVisible(true)
        else  -- 倒计时 剩余时间
            local _leftTime = self.godHeroFreePeriod - self.diffTime2
            self.shen_label:setString( string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
            -- self.godHeroRedDot:setVisible(false)
        end 
    end     

    if self.diffTime2 < self.godHeroFreePeriod then
        self:removeScheduler2()
        self.scheduer2 = timer.scheduleGlobal(updateTimer2, 1.0)
        -- self.godHeroRedDot:setVisible(false)
    else
        self.shen_label:setString( Localize.query("shop.5") )
        -- self.godHeroRedDot:setVisible(true)
        self.godHeroUseMoney = 0
    end

end

-- remove all scheduler
function PVShopRecruitBuyGod:removeAllScheduler()
    self:removeScheduler2()
end

function PVShopRecruitBuyGod:removeScheduler2()
    if self.scheduer2 ~= nil then
        timer.unscheduleGlobal(self.scheduer2)
        self.scheduer2 = nil
    end
end


function PVShopRecruitBuyGod:initTouchListener()
    
    local function menuBack()
        self:removeAllScheduler()
        getAudioManager():playEffectButton2()
        self:onHideView()
        --stepCallBack(G_GUIDE_20103)
        -- stepCallBack(G_GUIDE_20120)
    end

    local function onClickPreviewBtn()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopHeroPreview", self.heroesTable)
        print("click prieview")
    end

    self.ccbiNode["UIShopRcZero"] = {}
    self.ccbiNode["UIShopRcZero"]["menuClickLeft"] = menuClickRecruit1
    self.ccbiNode["UIShopRcZero"]["menuClickRight"] = menuClickRecruit10
    self.ccbiNode["UIShopRcZero"]["menuBack"] = menuBack
    self.ccbiNode["UIShopRcZero"]["onClickPreviewBtn"] = onClickPreviewBtn

end

function PVShopRecruitBuyGod:clickedLeft()
    print("1111111111111")
    local gId = getNewGManager():getCurrentGid()
    if gId == GuideId.G_GUIDE_20028 then
        local rewards = getTemplateManager():getBaseTemplate():getRecruitForGuide()
        local heroId = rewards["101"][3]
        print("heroId ",heroId)

        --判断是否获得了该英雄，如果有，直接播放动画
        local bFind = getDataManager():getSoldierData():getSoldierDataById(heroId)
        print("bFind ",bFind)

        if bFind ~= nil then
            local  data = {
                ["gain"] = {
                    ["heros"] = {
                        [1] = {
                            ["level"] = 1, 
                            ["refine"] = 0, 
                            ["is_guard"] = false, 
                            ["exp"] = 0, 
                            ["is_online"] = false, 
                            ["hero_no"] = heroId, 
                            ["break_level"] = 0,
                        },
                    },
                },
            }
            SHOP_EQUIP_TYPE = 3
            
            self:showResult(data)
            return
        end
    end
    if self:checkIsCanBuy( self.godHeroUseMoney ) == true then -- 买得起，才发送协议
        SHOP_EQUIP_TYPE = 3
        cclog("发送三号协议")
        --[[if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20028 then
            local guidInfo = getNewGManager():getCurrentInfo()
            getNewGManager():sendGuidProtocol(guidInfo["skip_to"])
        else
            getNetManager():getShopNet():sendBuyGodHeroMsg()
        end]]--

        getNetManager():getShopNet():sendBuyGodHeroMsg()

        self.__flag = true
    else
        print("!!! gold is not enough")
        getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
    end
    -- stepCallBack(G_GUIDE_20102)
end

function PVShopRecruitBuyGod:clickedRight()
    local _shopTemplate = getTemplateManager():getShopTemplate()
    if self:checkIsCanBuy( _shopTemplate:getTenGodHeroUseMoney() ) == true then
        SHOP_EQUIP_TYPE = 4
        cclog("发送四号协议")
        getNetManager():getShopNet():sendBuyGodHero10Msg()
        self.__flag = true
    else
        print("!!! gold is not enough")
        getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
    end   
end

function PVShopRecruitBuyGod:initView()
    self.ccbiRootNode = self.ccbiNode["UIShopRcZero"]

     --更新免费次数及剩余时间         
    self.shen_label = self.ccbiRootNode["shen_label"]      
    self.godHeroUseMoney = self.shopTemp:getGodHeroUseMoney()
    self:updateData()

    self.labelMoney1 = self.ccbiRootNode["label_left"]
    self.labelMoney10 = self.ccbiRootNode["label_right"]
    self.nodeCoin = self.ccbiRootNode["node_coin"]
    self.nodeGold = self.ccbiRootNode["node_gold"]
    self.layerLeft = self.ccbiRootNode["lay_left"]
    self.layerRight = self.ccbiRootNode["lay_right"]
    self.animationNode = self.ccbiRootNode["animationNode"]
    self.nodeForStar = self.ccbiRootNode["node_forStar"]
    self.blackHouse = self.ccbiRootNode["black_house"]
    self.blackHouse:setVisible(false)
    self.imgTokenLeft = self.ccbiRootNode["img_token_l"]
    self.imgTokenRight = self.ccbiRootNode["img_token_r"]
    self.layerTouch = self.ccbiRootNode["layerTouch"]

    self.normalHeroNode = self.ccbiRootNode["normalHeroNode"]
    self.epicHeroNode = self.ccbiRootNode["epicHeroNode"]
    self.normalHeroNode:setVisible(false)
    self.epicHeroNode:setVisible(true)

    self.nodeCoin:setVisible(false)
    self.nodeGold:setVisible(true)

    --触摸层隐藏
    self.layerTouch:setVisible(false)
    self.layerTouch:setTouchEnabled(false)
    -- 赋值
    local shopTemplate = getTemplateManager():getShopTemplate()
    local _hero10UseMoney = shopTemplate:getTenGodHeroUseMoney()

    if self.godHeroUseMoney == 0 then 
        self.labelMoney1:setString("免费")
    else
        self.labelMoney1:setString(string.format(self.godHeroUseMoney))
    end
    self.labelMoney10:setString(string.format(_hero10UseMoney))

    -- 事件
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
            if isInRect and self.__flag == false then
                getAudioManager():playEffectButton2()
                self.imgTokenLeft:setScale(0.9)
                self:clickedLeft()
                -- self.__flag = true
                return true
            end
        elseif eventType == "ended" then
            self.imgTokenLeft:setScale(1)
        end
    end
    local function onTouchEvent2(eventType, x, y)
        local _pos = self.layerRight:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, _pos)
        if eventType == "began" then
            if isInRect and self.__flag == false then
                getAudioManager():playEffectButton2()
                self.imgTokenRight:setScale(0.9)
                self:clickedRight()
                -- self.__flag = true
                return true
            end
        elseif eventType == "ended" then
            self.imgTokenRight:setScale(1)
        end
    end
    self.layerLeft:registerScriptTouchHandler(onTouchEvent1)
    self.layerRight:registerScriptTouchHandler(onTouchEvent2)

    -- 天空星星闪闪
    local node = UI_Xingxingshanshan()
    self.nodeForStar:addChild(node)
end

--检查是否可以购买
function PVShopRecruitBuyGod:checkIsCanBuy(money)
    local commonData = getDataManager():getCommonData()
    print("-------用户的元宝PVShopRecruitBuyGod--------"..commonData:getGold().."消耗："..money)
    if commonData:getGold() < money then return false
    else return true end
end

-- 更新界面
function PVShopRecruitBuyGod:onReloadView()
    print("--PVShopRecruitBuyGod:onReloadView-----")
    if SHOP_PAST_PAGE_HIDEVIEW == true then
        self:onHideView()
    else
        if SHOP_EQUIP_TYPE == 3 then
            local shopTemplate = getTemplateManager():getShopTemplate()
            local _useMoney = shopTemplate:getGodHeroUseMoney()
            self.godHeroUseMoney = _useMoney
            self.labelMoney1:setString(string.format(_useMoney))
        end
    end

end

return PVShopRecruitBuyGod
