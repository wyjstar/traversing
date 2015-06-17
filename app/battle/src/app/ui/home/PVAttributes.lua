local PVAttributes = class("PVAttributes")
local userNotice = {}
local sysNotice = {}

function PVAttributes:ctor(attrs)
	self.isInit = false
	if attrs == nil then return end
	self.init(attrs)   
end

function PVAttributes:updateNoticeBuff(data)
    if not self.isInit then return end    
    
    if notice_id == 2001 then show_msg(msg);return end  --notice_id==2001,则直接显示消息

    local noteInfo = getTemplateManager():getBaseTemplate():getNoteInfoById(tonumber(data.notice_id))
    if not noteInfo then return end
    
    if noteInfo.type == 1 then
        self.noteSys = true
        table.insert(sysNotice,data)
    elseif noteInfo.type ==2 then
        table.insert(userNotice,data)
    end
    cclog("------updateNoticeBuff----------------")
    table.print(userNotice)
end

function PVAttributes:updateNoteSys(i)
    if not self.isInit then return end    
    if #sysNotice < 1 then return end
    local noteInfo = self.baseTemp:getNoteInfoById(tonumber(sysNotice[i].notice_id))
    local text = getTemplateManager():getLanguageTemplate():getLanguageById(noteInfo.text)
    local label = cc.LabelTTF:create("xxxxxxxxx", MINI_BLACK_FONT_NAME, 24)
    label:setString(text)
    label:setAnchorPoint(cc.p(0,0.5))
    label:setPosition(cc.p(self.noticeSize.width,20))
    -- label:setPosition(cc.p(630,20))
    self.noticeLayersys:addChild(label)
    table.insert(self.tabText,label)
    self.noteSys = false
end

function PVAttributes:initNotice()
    if not self.isInit then return end    
    local function updateTimer()
        if self.tabText == nil then return end
        for k,v in pairs(self.tabText) do
            v:setPositionX(v:getPositionX() - 1)
        end
        local tNum = #self.tabText
        if tNum >= 1 then
            if self.tabText[1]:getPositionX() <= -(self.tabText[1]:getContentSize().width) then
                if self.noteSys then
                    self:updateNoteSys(#sysNotice)
                else
                    self:updateNotice()
                end
                self.tabText[1]:removeFromParent()
                table.remove(self.tabText,1)
                unpack(self.tabText)
            end
        elseif tNum < 1 and userNotice ~= nil then
            if self.noteSys then
                self:updateNoteSys(#sysNotice)
            else
                self:updateNotice()
            end
        end
    end
    if self.scheduerNotice == nil then
        self.scheduerNotice = timer.scheduleGlobal(updateTimer, 0.016)
    end
end

function PVAttributes:updateNotice()
    if not self.isInit then return end    
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
        cclog("-----------getColorByQuality----------"..id)
        local item = nil 
        item = hero_config[id]
        if item == nil then
            item = equipment_config[id]
        end
        if item==nil then
            return ui.COLOR_WHITE
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
        for findStr in string.gmatch(str, "%$%w+%$") do  
            -- cclog("----------findstr -------"..findStr)
            if idx == 0 then
                repStr = temNotice[1].player_name
            elseif idx == 1 then
                if tonumber(temNotice[1].hero_no) ~= 0 then
                    repStr = self.soldierTemp:getHeroName(tonumber(temNotice[1].hero_no))
                elseif tonumber(temNotice[1].equipment_no) ~= 0 then
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
            -- cclog("------------richar------------"..infoTable[i].."----"..i)
            local color = ui.COLOR_YELLOW
            if i == 2 then
                if tonumber(temNotice[1].hero_no) ~= 0 then
                    color = getColorByQuality(tonumber(temNotice[1].hero_no))
                elseif tonumber(temNotice[1].equipment_no) ~= 0 then
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
    nodeRich:setPosition(cc.p(self.noticeSize.width,20))
    table.insert(self.tabText,nodeRich)
    table.remove(userNotice,1)
    self.noticeLayersys:addChild(nodeRich)
    unpack(userNotice)
    cclog("-1-1-1-1-1-1-1-1-1-1-1-1-11-1-1-11-")
    table.print(userNotice)
end

function PVAttributes:clear()
     if self.scheduerNotice ~= nil then
        timer.unscheduleGlobal(self.scheduerNotice)
        self.scheduerNotice = nil
    end
    self.isInit = false    
    self.dispatcher:removeEventListener(self.listener)    
end

function PVAttributes:init(attrs)
	self.commonData_ = getDataManager():getCommonData()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.lanTemp = getTemplateManager():getLanguageTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()

    getDataManager():getCommonData():countTimer()

    self.moneyBMLabel = attrs["yinding"]
    self.superMoneyBMLabel = attrs["yuanbao"]
    self.headIcon = attrs["player_head"]
    self.playername = attrs["player_name"]
    self.vipBMLabel = attrs["player_vip"]
    self.lvBMLabel = attrs["player_level"]
    self.expBMLabel = attrs["label_exp"]
    self.jingyan_bg = attrs["jingyan_bg"]

    self.staminaBMLabel = attrs["label_tili"]
    self.tili_bg = attrs["tili_bg"]
    
    local player_exp = attrs["player_exp"]
    local high_light1 = attrs["high_light1"]
    local player_tili = attrs["player_tili"]
    local high_light2 = attrs["high_light2"]
    local btn_add_tili = attrs["btn_add_tili"]
    self.CombatPowerBMLabel = attrs["player_zhanli"]
    self.noticeLayer = attrs["bg_notice"]
    self.noticeLayersys = attrs["noticeLayer"]
    -- self.noticeSize = self.noticeLayer:getContentSize() 
    self.noticeSize = self.noticeLayersys:getContentSize() 
    cclog("---------- self.noticeSize------".. self.noticeSize.width)   

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
    self.tiliProgress = cc.ProgressTimer:create(player_tili)
    self.tiliProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.tiliProgress:setBarChangeRate(cc.p(0, 1))
    self.tiliProgress:setMidpoint(cc.p(0, 0))
    self.tiliProgress:setPosition(posX, posY)
    self.tiliProgress:setLocalZOrder(1)         
    tili_parent:addChild(self.tiliProgress, 1)
    self.isInit = true
	self:updateData()
    self.tili_bg:setLocalZOrder(2)
    self.jingyan_bg:setLocalZOrder(2)
    btn_add_tili:setLocalZOrder(2)
    self.expBMLabel:setLocalZOrder(2)
    self.staminaBMLabel:setLocalZOrder(2)
    high_light1:setLocalZOrder(2)
    high_light2:setLocalZOrder(2)

    self.noteSys = false
    self.notSysIdx = 1
    self.noteTimes = self.baseTemp:getNoteTimes()
    self.tabText = {}
    self:initNotice()

    local function headCallFunc()
        self:updateHeadIcon()
    end
    self.listener = cc.EventListenerCustom:create(UPDATE_HEAD, headCallFunc)
    --ugly code
    self.dispatcher = self.moneyBMLabel:getEventDispatcher()
    self.dispatcher:addEventListenerWithFixedPriority(self.listener, 1)          	
end

function PVAttributes:updateData()

	if not self.isInit then return end
    -- 更新数据
    local _data = self.commonData_
    self.playername:setString(_data:getUserName())
    self.moneyBMLabel:setString(_data:getCoin())
    self.lvBMLabel:setString(tostring("Lv.".._data:getLevel()))
    self.superMoneyBMLabel:setString(_data:getGold())
    self.vipBMLabel:setString(_data:getVip())
    self:updateStamina()
    self:updateHeadIcon()
    self:updateCombatPower()
    self:updateExp()
end

----更新具体数据

--更新普通货币
function PVAttributes:updateCoin()
	if not self.isInit then return end	
    self.moneyBMLabel:setString(self.commonData_:getCoin())
end
--更新充值币
function PVAttributes:updateGold()
	if not self.isInit then return end	
    self.superMoneyBMLabel:setString(self.commonData_:getGold())
end
--更新体力
function PVAttributes:updateStamina()
	if not self.isInit then return end
    local max = getTemplateManager():getBaseTemplate():getStaminaMax()
    local curr = self.commonData_:getStamina()
    self.staminaBMLabel:setString(curr.."/"..max)
    self.tiliProgress:setPercentage(100*curr/max)
end
--更新Exp
function PVAttributes:updateExp()
	if not self.isInit then return end	
    local _data = self.commonData_
    local level = _data:getLevel()
    local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
    local _exp = _data:getExp()
    
    -- while _exp >= maxExp do
    --     print("========_exp >= maxExp==========")
    --     print(_exp)
    --     print(maxExp)
    --     _exp = _exp - maxExp
    --     level = level + 1
       
    --     maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)

    --     if _exp <= maxExp then
    --         print("========_exp >= maxExp==222222==")
    --         self.commonData_:setLevel(level)
    --         self.commonData_:setExp(_exp)
    --         break
    --     end

    -- end
    
    -- self.commonData_:setLevel(level)
    -- self.commonData_:setExp(_exp)

    self.expBMLabel:setString(_exp.."/"..maxExp)
    self.expProgress:setPercentage(100*_data:getExp()/maxExp)
end

function PVAttributes:updateVip()
    if not self.isInit then return end
    self.vipBMLabel:setString(tostring(self.commonData_:getVip()))
end

function PVAttributes:updateLevel()
	if not self.isInit then return end	
    self.lvBMLabel:setString(tostring("Lv."..self.commonData_:getLevel()))
end

--更名
function PVAttributes:updateUserName()
	if not self.isInit then return end	
    self.playername:setString(self.commonData_:getUserName())
end

-- 头像
function PVAttributes:updateHeadIcon()
	if not self.isInit then return end	
    local heroNo = self.commonData_:getHead()
    if heroNo ~= nil then
        local resIcon = getTemplateManager():getSoldierTemplate():getSoldierHead(heroNo)
        local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(heroNo)

        self.headIcon:setTexture("res/icon/hero_head/"..resIcon)
    end
end

-- 战斗力
function PVAttributes:updateCombatPower()
    
    cclog("--PVAttributes:updateCombatPower----")

	if not self.isInit then return end	
    cclog("--PVAttributes:updateCombatPower--11111--")
    
    local power = getCalculationManager():getCalculation():CombatPowerAllSoldierLineUp()
    self.CombatPowerBMLabel:setString(tostring( roundNumber(power) ))
    if self.current_power ~= nil and roundNumber(self.current_power)~=roundNumber(power) then
        -- 当战斗力提升时，则显示战斗力提升。
        print("---------------updateCombatPower------------------")
        print(self.current_power)
        print(power)
        getOtherModule():showCombatPowerUpView(roundNumber(self.current_power), roundNumber(power))
    end
    self.current_power = power
end

return PVAttributes
