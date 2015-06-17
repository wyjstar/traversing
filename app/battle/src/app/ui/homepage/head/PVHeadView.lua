--

UPDATE_HEAD = "UPDATE_HEAD"
UPDATE_TL = "UPDATE_TL"

local PVHeadView = class("PVHeadView", BaseUIView)

function PVHeadView:ctor(id)
    PVHeadView.super.ctor(self, id)
end

function PVHeadView:onMVCEnter()

    -- self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self:initData()

 	self.ccbiNode = {}

	self:initTouchListener()

    self:loadCCBI("head/ui_head_view.ccbi", self.ccbiNode)

    self:initView()
    self:updateData()

    local function headCallFunc()

        self:updateHeadImage()
    end
    self.listener = cc.EventListenerCustom:create(UPDATE_HEAD, headCallFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)


    local function headAddTL()

        self:updateStamina()
    end
    self.listener1 = cc.EventListenerCustom:create(UPDATE_TL, headAddTL)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener1, 1)

end

function PVHeadView:initData()

end

function PVHeadView:updateData()
    self:updateHeadImage()
    self:updateUserName()
    self:updateUserId()
    self:updateUserVip()

    self:updateUserLv()
    self:updateCoin()
    self:updateGold()
    self:updateStamina()
    self:updateExp()
end

function PVHeadView:onExit()

    print("----PVHeadView:onExit------")

    if __scheduerOutputTime ~= nil then
        timer.unscheduleGlobal(__scheduerOutputTime)
        __scheduerOutputTime = nil
    end
    -- print("PVHeadView:onExit()")
    self:getEventDispatcher():removeEventListener(self.listener)
    self:getEventDispatcher():removeEventListener(self.listener1)


    getDataManager():getResourceData():clearResourcePlistTexture()

end

function PVHeadView:initTouchListener()

    local function onCloseClick()
        getAudioManager():playEffectButton2()
        -- self:onExit()

        self:onHideView(1)
    end
    local function menuClickA()
        getAudioManager():playEffectButton2()
        self:updateMenu(1)
    end
    local function menuClickB()
        getAudioManager():playEffectButton2()
        self:updateMenu(2)
    end

    local function vipMenuOnClick()
        print("------------------ vipMenuOnClick ---------------------")
        getAudioManager():playEffectButton2()
        -- self:toastShow("功能尚未开放")
        -- getOtherModule():showAlertDialog(nil, "功能尚未开放")
        getModule(MODULE_NAME_SHOP):showUIView("PVShopRechargeVip")
    end
    local function changeMenuOnClick()
        print("------------------ changeMenuOnClick ---------------------")
        getAudioManager():playEffectButton2()
        -- self:toastShow("功能尚未开放")
        getOtherModule():showOtherView("PVHeadChange")

    end
    local function setMenuOnClick()
        print("------------------ setMenuOnClick ---------------------")
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVHeadSet")
    end
    local function exitMenuOnClick()
        cc.UserDefault:getInstance():setStringForKey("tourist_id", "")
        cc.UserDefault:getInstance():setBoolForKey("isTourist", false)
        cc.UserDefault:getInstance():setBoolForKey("isBound", false)
        print("------------------ exitMenuOnClick ---------------------")
        getAudioManager():playEffectButton2()

        if __scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(__scheduerOutputTime)
            __scheduerOutputTime = nil
        end

        getNetManager():loginout()
        -- self:onHideView()
        -- local ServerList = require("src.app.platform.PVServerList")
        -- local serverList = ServerList.new("PVServerList")
        -- game.getRunningScene():addChild(serverList)
    end
    local function menuBuyTL()
        getAudioManager():playEffectButton2()
        local curStamina = getDataManager():getCommonData():getStamina()
        local max = getTemplateManager():getBaseTemplate():getStaminaMax()
        -- print("==============================="..max)
        -- print(curStamina)
        if curStamina < max then
            local left = getTemplateManager():getBaseTemplate():getBuyStaminaLeftTimes()
            if left > 0 then
                -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVBuyStamina")
                getOtherModule():showOtherView("PVBuyStamina")
            else
                getOtherModule():showAlertDialog(nil, Localize.query("basic.1"))
                -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("SystemTips", Localize.query("basic.1"), 1)
            end
        else
            getOtherModule():showAlertDialog(nil, Localize.query("basic.2"))
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("SystemTips", Localize.query("basic.2"), 1)
        end
    end

    local function menuBuyMoney(  )
        -- body
    end

    local function menuBuyGold(  )
        -- body
         getAudioManager():playEffectButton2()
         print("menuclick back 。。。")
         getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
    end

    self.ccbiNode["UIHeadView"] = {}
    self.ccbiNode["UIHeadView"]["onCloseClick"] = onCloseClick

    self.ccbiNode["UIHeadView"]["menuClickA"] = menuClickA
    self.ccbiNode["UIHeadView"]["menuClickB"] = menuClickB

    self.ccbiNode["UIHeadView"]["vipMenuOnClick"] = vipMenuOnClick
    self.ccbiNode["UIHeadView"]["changeMenuOnClick"] = changeMenuOnClick
    self.ccbiNode["UIHeadView"]["setMenuOnClick"] = setMenuOnClick
    self.ccbiNode["UIHeadView"]["exitMenuOnClick"] = exitMenuOnClick

    self.ccbiNode["UIHeadView"]["menuBuyTL"] = menuBuyTL
    self.ccbiNode["UIHeadView"]["menuBuyMoney"] = menuBuyMoney
    self.ccbiNode["UIHeadView"]["menuBuyGold"] = menuBuyGold

end

function PVHeadView:updateMenu(idx)
    if idx == 1 then
        self.menuA:setEnabled(false)
        self.menuB:setEnabled(true)

        self.inforNor:setVisible(false)
        self.nameNor:setVisible(true)
        self.inforSelected:setVisible(true)
        self.nameSelected:setVisible(false)

    else

        -- self:toastShow("功能尚未开放")
        getOtherModule():showAlertDialog(nil, Localize.query("common.function.isNoOpen"))

        -- self.menuA:setEnabled(true)
        -- self.menuB:setEnabled(false)

        -- self.inforNor:setVisible(true)
        -- self.nameNor:setVisible(false)
        -- self.inforSelected:setVisible(false)
        -- self.nameSelected:setVisible(true)
    end
end


function PVHeadView:initView()
	self.peopleSprite = self.ccbiNode["UIHeadView"]["peopleSprite"]

    self.inforSelected = self.ccbiNode["UIHeadView"]["inforSelected"]
    self.nameSelected = self.ccbiNode["UIHeadView"]["nameSelected"]
    self.inforNor = self.ccbiNode["UIHeadView"]["inforNor"]
    self.nameNor = self.ccbiNode["UIHeadView"]["nameNor"]


    self.menuA = self.ccbiNode["UIHeadView"]["menuA"]
    self.menuB = self.ccbiNode["UIHeadView"]["menuB"]
    self.menuA:setAllowScale(false)
    self.menuB:setAllowScale(false)
    self.menuIdx = 1
    self:updateMenu(1)

    -- vip特权 更换头像 功能暂未开放
    self.vipMenu = self.ccbiNode["UIHeadView"]["vipMenu"]
    self.changeMenu = self.ccbiNode["UIHeadView"]["changeMenu"]

    self.buyMoneyBtn = self.ccbiNode["UIHeadView"]["buyMoneyBtn"]
    self.buyGoldBtn = self.ccbiNode["UIHeadView"]["buyGoldBtn"]        --充值界面暂未开启置灰
    -- self.buyMoneyBtn:setEnabled(false)
    -- self.buyGoldBtn:setEnabled(false)

    -- self.vipMenu:setEnabled(false)
    -- self.changeMenu:setEnabled(false)
    -- SpriteGrayUtil:drawSpriteTextureGray(self.vipMenu)
    -- SpriteGrayUtil:drawSpriteTextureGray(self.changeMenu)
    -- SpriteGrayUtil:drawSpriteTextureGray(self.buyMoneyBtn)
    -- SpriteGrayUtil:drawSpriteTextureGray(self.buyGoldBtn)

	self.idLabel = self.ccbiNode["UIHeadView"]["idLabel"]
	self.nameLabel = self.ccbiNode["UIHeadView"]["nameLabel"]
    self.tiLabel = self.ccbiNode["UIHeadView"]["tiLabel"]
    
    self.tiTimeLabel = self.ccbiNode["UIHeadView"]["tiTimeLabel"]
    self.moneyBMLabel = self.ccbiNode["UIHeadView"]["moneyBMLabel"]
    self.superMoneyBMLabel = self.ccbiNode["UIHeadView"]["superMoneyBMLabel"]
    self.sodierMaxLabel = self.ccbiNode["UIHeadView"]["sodierMaxLabel"]
    self.equMaxLabel = self.ccbiNode["UIHeadView"]["equMaxLabel"]
    self.lvBMLabel = self.ccbiNode["UIHeadView"]["lvBMLabel"]
    self.vipBMLabel = self.ccbiNode["UIHeadView"]["vipBMLabel"]
    self.player_zhanli = self.ccbiNode["UIHeadView"]["player_zhanli"]
    self.tiTimeLabel_bg = self.ccbiNode["UIHeadView"]["tiTimeLabel_bg"]
    self.exp_label_bg = self.ccbiNode["UIHeadView"]["exp_label_bg"]
    self.heroBagImg = self.ccbiNode["UIHeadView"]["heroBagImg"]

    local power = getCalculationManager():getCalculation():CombatPowerAllSoldierLineUp()
    self.player_zhanli:setString(tostring( roundNumber(power) ))

    self.expBMLabel = self.ccbiNode["UIHeadView"]["exp_label"]
    self.expBMLabel:setLocalZOrder(10)
 

    local player_exp = self.ccbiNode["UIHeadView"]["player_exp"]
    local high_light1 = self.ccbiNode["UIHeadView"]["high_light1"]
    local player_tili = self.ccbiNode["UIHeadView"]["player_tili"]
    local high_light2 = self.ccbiNode["UIHeadView"]["high_light2"]
    -- local btn_add_tili = self.ccbiNode["UIHeadView"]["btn_add_tili"]

    local exp_parent, posX, posY = player_exp:getParent(), player_exp:getPositionX(), player_exp:getPositionY()
    player_exp:removeFromParent(false)
    self.expProgress = cc.ProgressTimer:create(player_exp)
    self.expProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.expProgress:setBarChangeRate(cc.p(0, 1))
    self.expProgress:setMidpoint(cc.p(0, 0))
    self.expProgress:setPosition(posX, posY)
    self.expProgress:setLocalZOrder(1)     
    exp_parent:addChild(self.expProgress)

    local tili_parent, posX, posY = player_tili:getParent(), player_tili:getPositionX(), player_tili:getPositionY()
    player_tili:removeFromParent(false)
    player_tili:setVisible(true)
    self.staminaProgress = cc.ProgressTimer:create(player_tili)
    self.staminaProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.staminaProgress:setBarChangeRate(cc.p(0, 1))
    self.staminaProgress:setMidpoint(cc.p(0, 0))
    self.staminaProgress:setPosition(posX, posY)
    self.staminaProgress:setLocalZOrder(1)         
    tili_parent:addChild(self.staminaProgress, 1)

    high_light1:setLocalZOrder(2)
    high_light2:setLocalZOrder(2)
    self.tiTimeLabel_bg:setLocalZOrder(2)
    self.exp_label_bg:setLocalZOrder(2)
    self.tiLabel:setLocalZOrder(2)
    self.tiTimeLabel:setLocalZOrder(2)
end


-- 武将大图
function PVHeadView:updateHeadImage()
    print("--------- updateHeadImage -----------")
    local heroNo = getDataManager():getCommonData():getHead()
    if heroNo ~= nil then
        local resIcon = getTemplateManager():getSoldierTemplate():getSoldierHead(heroNo)
        self.peopleSprite:setTexture("res/icon/hero_head/"..resIcon)

        local resIcon = getTemplateManager():getSoldierTemplate():getHeroBigImageById(heroNo)
        self.heroBagImg:removeAllChildren()
        self.heroBagImg:addChild(resIcon)
        resIcon:setScale(1.5)
        resIcon:setOpacity(200)
        resIcon:setPosition(self.heroBagImg:getContentSize().width / 2, self.heroBagImg:getContentSize().height / 2)

    end
end

--更名
function PVHeadView:updateUserName()
    self.nameLabel:setString(getDataManager():getCommonData():getUserName())
end

--更id
function PVHeadView:updateUserId()
    self.idLabel:setString(getDataManager():getCommonData():getAccountId())
end

--更vip
function PVHeadView:updateUserVip()
    self.vipBMLabel:setString("VIP"..getDataManager():getCommonData():getVip())
end

--更等级
function PVHeadView:updateUserLv()
    self.lvBMLabel:setString(getDataManager():getCommonData():getLevel())
    self.sodierMaxLabel:setString(getDataManager():getCommonData():getLevel())
    self.equMaxLabel:setString(getDataManager():getCommonData():getLevel())
end
--更新普通货币
function PVHeadView:updateCoin()
    self.moneyBMLabel:setString(getDataManager():getCommonData():getCoin())
end
--更新充值币
function PVHeadView:updateGold()
    self.superMoneyBMLabel:setString(getDataManager():getCommonData():getGold())
end


function PVHeadView:startTimer()

    local function updateTimer(dt)
        local recoverTime = getTemplateManager():getBaseTemplate():getStaminaRecoverTime()

        self.time = self.time+dt
        local _time = recoverTime-self.time
        if _time <= 0 then
            _time = 0
        end
        self.tiTimeLabel:setString(string.format("%02d:%02d",math.floor(_time/60), _time%60))

        if recoverTime <= self.time then
            self.time = 0
            print("{{{{{{{{{{{  self.time  }}}}}}}}}}}")
            self:updateStamina()
            local max = getTemplateManager():getBaseTemplate():getStaminaMax()
            self.curr = self.curr+1
            -- self.tiLabel:setString(self.curr.."/"..max)

            if self.curr >= max then
                if __scheduerOutputTime ~= nil then
                    timer.unscheduleGlobal(__scheduerOutputTime)
                    __scheduerOutputTime = nil
                end
            end

        end
    end

    __scheduerOutputTime = timer.scheduleGlobal(updateTimer, 1.0)

end

--更新体力
function PVHeadView:updateStamina()
    local max = getTemplateManager():getBaseTemplate():getStaminaMax()
    self.curr = getDataManager():getCommonData():getStamina()

    local recoverTime = getTemplateManager():getBaseTemplate():getStaminaRecoverTime()
    self.tiLabel:setString(self.curr.."/"..max)
    self.staminaProgress:setPercentage(100*self.curr/max)
    if self.curr >= max then
        self.tiTimeLabel:setString("00:00")
    else
        self.time = getDataManager():getCommonData():countTime()
        self.tiTimeLabel:setString(string.format("%02d:%02d",math.floor((recoverTime-self.time)/60),(recoverTime-self.time)%60))
        if __scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(__scheduerOutputTime)
            __scheduerOutputTime = nil
        end
        self:startTimer()
        -- self.tiTimeLabel:setString("30:00")
    end
end
--更新Exp
function PVHeadView:updateExp() 
    local _data = getDataManager():getCommonData()
    local level = _data:getLevel()
    print("level=====" .. level)
    local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
    self.expBMLabel:setString(_data:getExp().."/"..maxExp)
    self.expProgress:setPercentage(100*_data:getExp()/maxExp)
end


return PVHeadView
