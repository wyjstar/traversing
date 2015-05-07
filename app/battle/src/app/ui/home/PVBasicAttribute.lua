--角色基本属性页面展示
local PVBasicAttribute = class("PVBasicAttribute", BaseUIView)

-- UPDATE_HEAD_ICON = "update_head_icon"

UPDATE_HEAD = "UPDATE_HEAD"

userNotice = {}
sysNotice = {}

function PVBasicAttribute:ctor(id)
    PVBasicAttribute.super.ctor(self, id)
    -- self.baseTemp = getTemplateManager():getBaseTemplate()
    -- self.lanTemp = getTemplateManager():getLanguageTemplate()
    self:onMVCEnter()
end

function PVBasicAttribute:onMVCEnter()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.lanTemp = getTemplateManager():getLanguageTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    -- self.baseTemp = getTemplateManager():getBaseTemplate()
    self:init()
end

function PVBasicAttribute:init()
    getDataManager():getCommonData():countTimer()
    self.UIBaseAttribute = {}

    self:initTouchListener()
    self:loadCCBI("common/ui_basic_attribute.ccbi", self.UIBaseAttribute)

    self:initView()
    -- self:changeShieldLayerState(false)

    local function headCallFunc()
        self:updateHeadIcon()
    end
    self.listener = cc.EventListenerCustom:create(UPDATE_HEAD, headCallFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

   
    local tab = {notice_id = 3001,player_name = "xxxxxxxx",hero_no = "刘备",hero_break_level = "0", equipment_no = "0"}
  
    -- for i=1,100 do
    --     table.insert(userNotice,tab)
    -- end
    self.noteSys = false
    self.notSysIdx = 1
    self.noteTimes = self.baseTemp:getNoteTimes()
    self.tabText = {}
    self:initNotice()
    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end
end

function PVBasicAttribute:onExit()
    cclog("-----PVBasicAttribute--onExit----")
    -- self:unregisterScriptHandler()
    if self.scheduerNotice ~= nil then
        timer.unscheduleGlobal(self.scheduerNotice)
        self.scheduerNotice = nil
    end
    self:getEventDispatcher():removeEventListener(self.listener)
end

function PVBasicAttribute:onReloadView()
    print("---PVBasicAttribute:onExit---")
end

function PVBasicAttribute:initView()

    self.animationManager = self.UIBaseAttribute["UIBaseAttribute"]["mAnimationManager"]

    self.headIcon = self.UIBaseAttribute["UIBaseAttribute"]["headSprite"]
    self.headIconSp = self.UIBaseAttribute["UIBaseAttribute"]["headSpriteSp"]
    self.playername = self.UIBaseAttribute["UIBaseAttribute"]["playername"]
    self.lvBMLabel = self.UIBaseAttribute["UIBaseAttribute"]["lvBMLabel"]
    self.moneyBMLabel = self.UIBaseAttribute["UIBaseAttribute"]["moneyBMLabel"]
    self.superMoneyBMLabel = self.UIBaseAttribute["UIBaseAttribute"]["superMoneyBMLabel"]
    self.expBMLabel = self.UIBaseAttribute["UIBaseAttribute"]["exp_label"]
    self.expBMLabel:setLocalZOrder(10)
    self.staminaBMLabel = self.UIBaseAttribute["UIBaseAttribute"]["stamina_label"]
    self.staminaBMLabel:setLocalZOrder(10)
    self.expSprite = self.UIBaseAttribute["UIBaseAttribute"]["expSprite"]
    self.energySprite = self.UIBaseAttribute["UIBaseAttribute"]["energySprite"]
    self.vipBMLabel = self.UIBaseAttribute["UIBaseAttribute"]["vipBMLabel"]
    self.HeadClick = self.UIBaseAttribute["UIBaseAttribute"]["HeadClick"]
    self.CombatPowerBMLabel = self.UIBaseAttribute["UIBaseAttribute"]["powerBMLabel"]

    self.noticeLayer = self.UIBaseAttribute["UIBaseAttribute"]["notice"]
    self.noticeLayer:setVisible(true)
    self.noticeSize = self.noticeLayer:getContentSize()
    self.noticePosx,self.noticePosy= self.noticeLayer:getPosition()
    cclog("------self.noticePosx-----"..self.noticePosx)
    cclog("------self.noticePosy-----"..self.noticePosy)

    local parent = self.expSprite:getParent()
    local posX, posY = self.expSprite:getPosition()
    self.expSprite:removeFromParent(false)
    self.expPrgress = cc.ProgressTimer:create(self.expSprite)
    self.expPrgress:setAnchorPoint(cc.p(0, 0.5))
    self.expPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.expPrgress:setBarChangeRate(cc.p(1, 0))
    self.expPrgress:setMidpoint(cc.p(0, 0))
    self.expPrgress:setPosition(posX, posY)
    self.expPrgress:setLocalZOrder(1)
    parent:addChild(self.expPrgress)

    local parent = self.energySprite:getParent()
    local posX, posY = self.energySprite:getPosition()
    self.energySprite:removeFromParent(false)
    self.staminaProgress = cc.ProgressTimer:create(self.energySprite)
    self.staminaProgress:setAnchorPoint(cc.p(0, 0.5))
    self.staminaProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.staminaProgress:setBarChangeRate(cc.p(1, 0))
    self.staminaProgress:setMidpoint(cc.p(0, 0))
    self.staminaProgress:setPosition(posX, posY)
    self.staminaProgress:setLocalZOrder(1)
    parent:addChild(self.staminaProgress)

    -- update data
    self:updateData()
end

function PVBasicAttribute:initTouchListener()
    function onHeadClick()
        cclog('--onHeadClick--')
        -- getAudioManager():playEffectButton2()
    end
    local function onBuyTL()
        getAudioManager():playEffectButton2()
        local curStamina = getDataManager():getCommonData():getStamina()
        local max = getTemplateManager():getBaseTemplate():getStaminaMax()
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
    function headOnClick()
        cclog('--onHeadClick--')
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVHeadView")
        -- getAudioManager():playEffectButton2()
    end
    self.UIBaseAttribute["UIBaseAttribute"] = {}
    self.UIBaseAttribute["UIBaseAttribute"]["onHeadClick"] = onHeadClick
    self.UIBaseAttribute["UIBaseAttribute"]["menuBuyTL"] = onBuyTL
    self.UIBaseAttribute["UIBaseAttribute"]["headOnClick"] = headOnClick

end

function PVBasicAttribute:showView()
    self.animationManager:runAnimationsForSequenceNamed("Timeline")
end

--更新数据
function PVBasicAttribute:updateData()

    -- 更新数据
    local _data = getDataManager():getCommonData()
    self.playername:setString(_data:getUserName())
    self.moneyBMLabel:setString(_data:getCoin())
    self.lvBMLabel:setString("Lv." .. string.format(_data:getLevel()))
    self.superMoneyBMLabel:setString(_data:getGold())

    print("gold : ! ", _data:getGold())

    self.vipBMLabel:setString("VIP".._data:getVip())

    self:updateStamina()
    self:updateHeadIcon()
    self:updateCombatPower()
    self:updateExp()

end

----更新具体数据

--更新普通货币
function PVBasicAttribute:updateCoin()
    self.moneyBMLabel:setString(getDataManager():getCommonData():getCoin())
end
--更新充值币
function PVBasicAttribute:updateGold()
    self.superMoneyBMLabel:setString(getDataManager():getCommonData():getGold())
end
--更新体力
function PVBasicAttribute:updateStamina()

    local max = getTemplateManager():getBaseTemplate():getStaminaMax()
    local curr = getDataManager():getCommonData():getStamina()
    self.staminaBMLabel:setString(curr.."/"..max)
    self.staminaProgress:setPercentage(100*curr/max)
end
--更新Exp
function PVBasicAttribute:updateExp()
    local _data = getDataManager():getCommonData()
    local level = _data:getLevel()
    print("level=====" .. level)
    local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
    self.expBMLabel:setString(_data:getExp().."/"..maxExp)
    -- _data:getExp()
    self.expPrgress:setPercentage(100*_data:getExp()/maxExp)
end


function PVBasicAttribute:updateLevel()
    print("------updateLevel-------",getDataManager():getCommonData():getLevel())
    self.lvBMLabel:setString("Lv." .. string.format(getDataManager():getCommonData():getLevel()))
    print("------updateLevel-------")
end

--更名
function PVBasicAttribute:updateUserName()
    self.playername:setString(getDataManager():getCommonData():getUserName())
end

-- 头像
function PVBasicAttribute:updateHeadIcon()
    -- local heropb = getDataManager():getLineupData():getSlotItemBySeat(1)
    local heroNo = getDataManager():getCommonData():getHead()
    if heroNo ~= nil then
        -- local heroNo = heropb.hero.hero_no
        local resIcon = getTemplateManager():getSoldierTemplate():getSoldierIcon(heroNo)
        local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(heroNo)
        if resIcon == 0 then
        end

        self.headIcon:getNormalImage():setTexture("res/icon/hero/"..resIcon)

        if quality == 1 or quality == 2 then
            game.setSpriteFrame(self.headIconSp, "#ui_common_frameg.png")
        elseif quality == 3 or quality == 4 then
            game.setSpriteFrame(self.headIconSp, "#ui_common_framebu.png")
        elseif quality == 5 or quality == 6 then
            game.setSpriteFrame(self.headIconSp, "#ui_common_framep.png")
        end
    end
end

-- 战斗力
function PVBasicAttribute:updateCombatPower()
    local power = getCalculationManager():getCalculation():CombatPowerAllSoldierLineUp()
    self.CombatPowerBMLabel:setString(tostring( roundNumber(power) ))
    print("======updateCombatPower=====")
    print(self.current_power)
    print(power)
    if self.current_power ~= nil and roundNumber(self.current_power)<roundNumber(power) then
        -- 当战斗力提升时，则显示战斗力提升。
        getOtherModule():showCombatPowerUpView(roundNumber(self.current_power), roundNumber(power))
    end
    self.current_power = power
end

-- and so on

-- function ( )
--     print("")
--     self:eventDispatcher:removeEventListener(self._listener1)
-- end

--系统公告
function PVBasicAttribute:updateNoticeBuff(data)
    local noteInfo = getTemplateManager():getBaseTemplate():getNoteInfoById(tonumber(data.notice_id))
    if noteInfo.type == 1 then
        self.noteSys = true
        table.insert(sysNotice,data)
    elseif noteInfo.type ==2 then
        table.insert(userNotice,data)
    end
    cclog("-=-=--=-=-=-ssjwoswds-=-wwwwwwwwww=-=-=")
    table.print(userNotice)
    cclog("-=-=--=-=-=-ssjwoswds-=-=-=-rrrrrrrrrrrr=")
    table.print(sysNotice)
end

function PVBasicAttribute:updateNoteSys(i)
    cclog("------------PVBasicAttribute:updateNoteSys-------------")
    if #sysNotice < 1 then return end
    -- local temNotice = {}
    -- table.insert(temNotice,userNotice[1])
    local noteInfo = self.baseTemp:getNoteInfoById(tonumber(sysNotice[i].notice_id))
    local text = getTemplateManager():getLanguageTemplate():getLanguageById(noteInfo.text)
    local label = cc.LabelTTF:create("xxxxxxxxx", MINI_BLACK_FONT_NAME, 24)
    label:setString(text)
   
    label:setAnchorPoint(cc.p(0,0.5))
    -- label:setPosition(cc.p(600,20))
    label:setPosition(cc.p(self.noticeSize.width,20))

    self.noticeLayer:addChild(label)
    table.insert(self.tabText,label)
    self.noteSys = false
    cclog("-2-2-2-2-2-2-2-2-2-2-2-2-2-2")
    table.print(sysNotice)
end
function PVBasicAttribute:updataNotice()
    -- cclog("------------PVBasicAttribute:updataNotice-------------")
    
    if sysNotice ~= nil and #sysNotice > 0 then
        if self.noteTimes <= 0 then
            self:updateNoteSys(self.notSysIdx)
            self.noteTimes = self.baseTemp:getNoteTimes()
            self.notSysIdx = self.notSysIdx + 1
            if self.notSysIdx > #sysNotice then self.notSysIdx = 1 end
            return
        end
        self.noteTimes = self.noteTimes - 1
    end
    if #userNotice < 1 then return end

    local temNotice = {}
    table.insert(temNotice,userNotice[1])
    local noteInfo = self.baseTemp:getNoteInfoById(tonumber(temNotice[1].notice_id))
    
    local text = getTemplateManager():getLanguageTemplate():getLanguageById(noteInfo.text)
    
    local function getColorByQuality(id)
        local item
        item  = hero_config[id]
        if item == nil then
            item = equipment_config[id]
        end
        if  item == nil then
            return ui.COLOR_RED
        end
        if item.quality == 1 then
            return ui.COLOR_WHITE
        elseif item.quality == 2 then
            return ui.COLOR_GREEN
        elseif item.quality == 3 or item.quality == 4 then
            return ui.COLOR_BLUE
        elseif item.quality == 5 or item.quality == 6 then
            return ui.COLOR_PURPLE
        end
    end

    local function setAresource(str)
        local _describeLanguage = str
        local strTable = {}
        local infoTable = {}
        local richtext = ccui.RichText:create()
        richtext:setAnchorPoint(cc.p(0,0.5))

        local idx = 0
        local repStr = ""
        for findStr in string.gmatch(str, "%$%w+%$") do  -- 模式匹配“$id:字段$”
            -- cclog("----------findstr -------"..findStr)
            if idx == 0 then
                repStr = temNotice[1].player_name
            elseif idx == 1 then
                if temNotice[1].hero_no ~= "0" then
                    repStr = self.soldierTemp:getHeroName(tonumber(temNotice[1].hero_no))
                elseif temNotice[1].equipment_no ~= "0" then
                    repStr = self.equipTemp:getEquipName(tonumber(temNotice[1].equipment_no))
                end
            elseif idx == 2 then
                 repStr = temNotice[1].hero_break_level
            end
            table.insert(infoTable,repStr)
            repStr = ":"
            _describeLanguage = string.gsub(_describeLanguage, "%$%w+%$", repStr, 1)
            idx = idx + 1
        end
        for i=1,idx-1 do
            -- cclog("---------setAresource-----".._describeLanguage)
            local posS,posE = string.find(_describeLanguage,":")
            _describeLanguage = string.sub(_describeLanguage, posS+1, -1)
            local str = string.sub(_describeLanguage,1,string.find(_describeLanguage,":")-1)
            table.insert(strTable,str)
            table.print(strTable)
        end
        for i=1,idx do 
            cclog("------------richar------------"..infoTable[i].."----"..i)
            local color = ui.COLOR_YELLOW
            if i == 2 then
                if temNotice[1].hero_no ~= "0" then
                    color = getColorByQuality(tonumber(temNotice[1].hero_no))
                elseif temNotice[1].equipment_no ~= "0" then
                    color = getColorByQuality(tonumber(temNotice[1].equipment_no))
                end
            elseif i ==3 then
                color = ui.COLOR_PURPLE
            end
            local re0 = ccui.RichElementText:create(1, color, 255, infoTable[i], "res/ccb/resource/miniblack.ttf", 22)
            richtext:pushBackElement(re0)
            if i <= #strTable then
                cclog("..-------"..strTable[i])
                local re1 = ccui.RichElementText:create(1, ui.COLOR_WHITE, 255, strTable[i], "res/ccb/resource/miniblack.ttf", 22)
                richtext:pushBackElement(re1)
            end
        end

        return richtext
    end

    local nodeRich = setAresource(text)
    cclog("-------text-------"..text)
    nodeRich:setPosition(cc.p(self.noticeSize.width,16))
    table.insert(self.tabText,nodeRich)
    table.remove(userNotice,1)
    self.noticeLayer:addChild(nodeRich)
    unpack(userNotice)
    cclog("-1-1-1-1-1-1-1-1-1-1-1-1-11-1-1-11-")
    table.print(userNotice)
end

function PVBasicAttribute:initNotice()

    cclog("-------------PVBasicAttribute:initNotice-------")
 
    local function updateTimer()
        -- cclog("--------PVBasicAttribute:updateTimer-----------")
        if self.tabText == nil then return end
        for k,v in pairs(self.tabText) do
            v:setPositionX(v:getPositionX() - 1)
            -- cclog("-------k---------"..k.."---"..v:getPositionX())

        end
        local tNum = #self.tabText
 
        if tNum >= 1 then
            if self.tabText[1]:getPositionX() <= -(self.tabText[1]:getContentSize().width) then
                if self.noteSys then
                    self:updateNoteSys(#sysNotice)
                else
                    self:updataNotice()
                end
                self.tabText[1]:removeFromParent()
                table.remove(self.tabText,1)
                unpack(self.tabText)
            end
        elseif tNum < 1 and userNotice ~= nil then
            if self.noteSys then
                self:updateNoteSys(#sysNotice)
            else
                self:updataNotice()
            end
        end
    end
    if self.scheduerNotice == nil then
        self.scheduerNotice = timer.scheduleGlobal(updateTimer, 0.016)
    end
end

return PVBasicAttribute
