-- 招募良将
local PVShopRecruitBuy = class("PVShopRecruitBuy", BaseUIView)
calFlag = false

--免费招募成功通知
local REFRESH_RECRUIT_TIME__NOTICE = "REFRESH_RECRUIT_TIME__NOTICE"

function PVShopRecruitBuy:ctor(id)
    self.super.ctor(self, id)
    self:registerNetCallback()
    self.__flag = false
end

-- 注册网络response回调
function PVShopRecruitBuy:registerNetCallback()

    local function responseCallback(id, data)  
        local rec_type = getDataManager():getShopData():getShopRecruitType()
        if rec_type == 3 then return end
        
        print(" $$ ui response recruit hero $$", id, data)
        -- table.print(data)
        local function func()
            self.__flag = false
            self.blackHouse:setVisible(false)
            cclog("-1-1-1-1-1-1-1-1--1-1--1-1-1-")
            -- table.print(data.gain)
            if data.res.result == true then
                -- if not calFlag then
                    cclog("-2-2-2-2-2-2-2-2-2-2-2-2-22-2-")
                    getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopShowCards", data.gain,1) 
                    calFlag = true

                -- end           
            end
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
                        cclog("----------PVShopRecruitBuy-------ahahahaha")
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

        local commonData = getDataManager():getCommonData()
        local shopTemplate = getTemplateManager():getShopTemplate()

        if SHOP_EQUIP_TYPE == 1 then 
            if self.heroUseMoney == 0 then 
                -- commonData:setFineHero(os.time())  -- 本次免费，将本次抽取的时间放入DataCenter
                commonData:setFineHero(commonData:getTime())  -- 本次免费，将本次抽取的时间放入DataCenter
            else
                commonData:subCoin( self.heroUseMoney )  -- 扣除相应的钱
            end
            cancelEff()
            local node = UI_shangchengwujiangchouqu001(func)
            self.animationNode:addChild(node)

        elseif SHOP_EQUIP_TYPE == 2 then
            commonData:subCoin( shopTemplate:getTenHeroUseMoney() )  -- 扣除相应的钱
            cancelEff()
            local node = UI_shangchengwujiangchouqushilianchou(func)
            self.animationNode:addChild(node)
        end
        cclog("我已经返回了")

        --发送通知商店招募更新时间
        local eventDispatcher = cc.Director:getInstance():getRunningScene():getEventDispatcher()
        local event = cc.EventCustom:new(REFRESH_RECRUIT_TIME__NOTICE)
        eventDispatcher:dispatchEvent(event) 

    end
    self:registerMsg(SHOP_REQUEST_HERO_CODE, responseCallback)
end

function PVShopRecruitBuy:onMVCEnter()
    self:init()
    self:initTouchListener()
    self:loadCCBI("shop/ui_shop_wjcq.ccbi", self.ccbiNode)
    self:initView()
end

function PVShopRecruitBuy:init() 
    self.ccbiNode = {}
    self.ccbiRootNode = {}

    self.heroesTable = getTemplateManager():getShopTemplate():getPreviewNormalHeroId()
    self.shopTemp = getTemplateManager():getShopTemplate()
end

-- 更新数据
function PVShopRecruitBuy:updateData()
    
    local shopTemplate = getTemplateManager():getShopTemplate()
    local _commonData = getDataManager():getCommonData()
    self.heroUseMoney = shopTemplate:getHeroUseMoney()

    -- 需要多少钱
    self.liang_label:setString("")

    -- 良将周期免费
    self.preHeroTime = _commonData:getFineHero()
    -- self.currTime = os.time()
    self.currTime = _commonData:getTime()   --应该获取服务器时间
    self.heroFreePeriod = shopTemplate:getHeroFreePeriod() * 3600 -- 免费周期（sec）

    self.diffTime1 = os.difftime(self.currTime, self.preHeroTime)

    local function updateTimer1(dt)
        self.diffTime1 = self.diffTime1 + 1
        if self.diffTime1 > self.heroFreePeriod then
            -- 免费，停止倒计时
            timer.unscheduleGlobal(self.scheduer1)
            self.scheduer1 = nil
            self.liang_label:setString( Localize.query("shop.5") )
            self.heroUseMoney = 0
            -- self.heroRedDot:setVisible(true)
        else
            -- 倒计时 剩余时间
            local _leftTime = self.heroFreePeriod - self.diffTime1
            self.liang_label:setString( string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
            -- self.heroRedDot:setVisible(false)
        end 
    end

    if self.diffTime1 < self.heroFreePeriod then
        self:removeScheduler1()
        self.scheduer1 = timer.scheduleGlobal(updateTimer1, 1.0)
        -- self.heroRedDot:setVisible(false)
    else
        self.liang_label:setString( Localize.query("shop.5") )
        self.heroUseMoney = 0
        -- self.heroRedDot:setVisible(true)
    end

end

-- remove all scheduler
function PVShopRecruitBuy:removeAllScheduler()
    self:removeScheduler1()
  
end

function PVShopRecruitBuy:removeScheduler1()
    if self.scheduer1 ~= nil then 
        timer.unscheduleGlobal(self.scheduer1)
        self.scheduer1 = nil
    end
end



-- 触控事件
function PVShopRecruitBuy:initTouchListener()
    
    local function menuBack()
        getAudioManager():playEffectButton2()
        self:removeAllScheduler()
        self:onHideView()
    end

    local function onClickPreviewBtn()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopHeroPreview", self.heroesTable)
        print("click prieview")
    end

    self.ccbiNode["UIShopRcZero"] = {}
    self.ccbiNode["UIShopRcZero"]["menuBack"] = menuBack
    self.ccbiNode["UIShopRcZero"]["onClickPreviewBtn"] = onClickPreviewBtn
end

function PVShopRecruitBuy:clickedLeft()
    print("22222222222222")
    if self:checkIsCanBuy( self.heroUseMoney ) == true then  -- 买得起，才发送协议
        SHOP_EQUIP_TYPE = 1
        getNetManager():getShopNet():sendBuyHeroMsg()
        self.__flag = true
        --self:cancelEff(true)
    else
        -- self:toastShow( Localize.query("shop.10") )
        getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
    end
    --stepCallBack(G_GUIDE_20080)
end
function PVShopRecruitBuy:clickedRight()
    local _shopTemplate = getTemplateManager():getShopTemplate()
    if self:checkIsCanBuy( _shopTemplate:getTenHeroUseMoney() ) == true then  -- 买得起，才发送协议
        SHOP_EQUIP_TYPE = 2
        getNetManager():getShopNet():sendBuyHero10Msg()
        self.__flag = true
        --self:cancelEff(true)
    else
        -- self:toastShow( Localize.query("shop.10") )
        getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
    end
end

-- 获取ccbi控件
function PVShopRecruitBuy:initView()

    self.ccbiRootNode = self.ccbiNode["UIShopRcZero"]

    --更新免费次数及剩余时间         
    self.liang_label = self.ccbiRootNode["liang_label"]      
    self.heroUseMoney = self.shopTemp:getHeroUseMoney()
    self:updateData()

    self.animationNode = self.ccbiRootNode["animationNode"]
    self.labelCoinMoney1 = self.ccbiRootNode["labelcoin_left"]
    self.labelCoinMoney10 = self.ccbiRootNode["labelcoin_right"]
    self.nodeCoin = self.ccbiRootNode["node_coin"]
    self.nodeGold = self.ccbiRootNode["node_gold"]
    self.layerLeft = self.ccbiRootNode["lay_left"]
    self.layerRight = self.ccbiRootNode["lay_right"]
    self.nodeForStar = self.ccbiRootNode["node_forStar"]
    self.blackHouse = self.ccbiRootNode["black_house"]
    self.blackHouse:setVisible(false)
    self.imgTokenLeft = self.ccbiRootNode["img_token_l"]
    self.imgTokenRight = self.ccbiRootNode["img_token_r"]
    self.layerTouch = self.ccbiRootNode["layerTouch"]

    self.normalHeroNode = self.ccbiRootNode["normalHeroNode"]
    self.epicHeroNode = self.ccbiRootNode["epicHeroNode"]
    self.normalHeroNode:setVisible(true)
    self.epicHeroNode:setVisible(false)

    --self:cancelEff(false)
    self.layerTouch:setVisible(false)
    self.layerTouch:setTouchEnabled(false)
    -- 赋值
    self.nodeCoin:setVisible(true)
    self.nodeGold:setVisible(false)

    local shopTemplate = getTemplateManager():getShopTemplate()
    local _hero10UseMoney = shopTemplate:getTenHeroUseMoney()

    if self.heroUseMoney == 0 then 
        self.labelCoinMoney1:setString("免费")
    else
        self.labelCoinMoney1:setString(string.format(self.heroUseMoney))
    end
    self.labelCoinMoney10:setString(string.format(_hero10UseMoney))

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
                self.imgTokenLeft:setScale(0.9)
                getAudioManager():playEffectButton2()
                self:clickedLeft()
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
                self.imgTokenRight:setScale(0.9)
                getAudioManager():playEffectButton2()
                self:clickedRight()
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
function PVShopRecruitBuy:checkIsCanBuy(money)
    local commonData = getDataManager():getCommonData()
    print("-------用户的银两PVShopRecruitBuy--------"..commonData:getCoin().."消耗："..money)
    if commonData:getCoin() < money then return false
    else return true end
end

-- 更新界面
function PVShopRecruitBuy:onReloadView()
    print("--PVShopRecruitBuy:onReloadView-----")
    if SHOP_PAST_PAGE_HIDEVIEW == true then
        self:onHideView()
    else
        if SHOP_EQUIP_TYPE == 1 then
            local shopTemplate = getTemplateManager():getShopTemplate()
            local _heroUseMoney = shopTemplate:getHeroUseMoney()
            self.heroUseMoney = _heroUseMoney
            self.labelCoinMoney1:setString(string.format(_heroUseMoney))
        end
    end

end



--@return 
return PVShopRecruitBuy
