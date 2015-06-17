
local PVArenaCheckInfo = class("PVArenaCheckInfo", BaseUIView)

function PVArenaCheckInfo:ctor(id)
    PVArenaCheckInfo.super.ctor(self, id)

    self:regeisterNetCallBack()

    self.lineupData = getDataManager():getLineupData()
    self.sodierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_SoldierCalculation = getCalculationManager():getSoldierCalculation()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_equipTemp = getTemplateManager():getEquipTemplate()
    self.c_EquipmentData = getDataManager():getEquipmentData()
    self.c_arenaData = getDataManager():getArenaData()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.c_SecretPlaceData = getDataManager():getMineData()

    self.curIndex = 1
    self.lastSelectHeroIndex = 1
    self.TYPE_TYPE = self.TYPE_SOLDIER_VIEW
    self.TYPE_MOVE_NONE = 0  --滑动类型为无
    self.TYPE_MOVE_LEFT = 1  --滑动类型为向左
    self.TYPE_MOVE_RIGHT = 2  --滑动类型为向右

    self.formType = nil  -- 枭雄和擂台排行进来
    FROM_TYPE_MINE = 1   -- 符文秘境进来
    self.otherPlayerLineUp = nil
    self.str_type = Localize.query("lineupTypeShow.1")

end

function PVArenaCheckInfo:onMVCEnter()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_arena.plist")

    self.UIArenaCheckView = {}

    self:initTouchListener()

    self:loadCCBI("arena/ui_arena_checkInfo.ccbi", self.UIArenaCheckView)


    self:initData()
    self:initView()
    self:updateData()
    self:initHeroLayerTouch()

    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end

    -- self:registerScriptHandler(onNodeEvent)

end

function PVArenaCheckInfo:initData()
    self.curTeamName = self.funcTable[1]    --玩家名称
    self.formType = self.funcTable[2]       --来自何处
    if self.formType == FROM_TYPE_MINE then 
        self.otherPlayerLineUp = self.c_SecretPlaceData:getLineupData()
    else
        self.otherPlayerLineUp = self.c_arenaData:getOtherPlayerLineUp()
    end
end

function PVArenaCheckInfo:onExit()
    -- self.sodierData:clearHeroImage()
    self.sodierData:clearHeroImagePVR()
    self.sodierData:clearHeroImagePlist()
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_arena.plist")
end

function PVArenaCheckInfo:regeisterNetCallBack()
   
end

function PVArenaCheckInfo:updateData()
    self.selectSoldierData = self.otherPlayerLineUp.slot
    self:updateHeroIcon()
    self:updateUnOpenView()
    self:updateOtherView()
    self:updateSoldierEquipment() --更新显示装备
    self:updateSelectSoldierLinkView(self.lastSelectHeroIndex)  --更新武将羁绊
end

--更新武将界面羁绊信息
function PVArenaCheckInfo:updateSelectSoldierLinkView(seat)
    local slotItem = self:getSlotItemBySeat(seat)
    if slotItem == nil then
        return 0
    end

    local heroPb = slotItem.hero
    local soldierId = heroPb.hero_no

    self:initLinkData(soldierId)

    self.size = table.getn(self.cheerDiscriptions)
    if self.tableView ~= nil then
        self.tableView:reloadData()
    end

    self.totleLinkDataItem = self.c_SoldierTemplate:getLinkDataById(soldierId) --这个英雄的全部羁绊信息
    self.linkItemTable = self.lineupData:getLink(soldierId)   --这个英雄羁绊上得信息
    if self.totleLinkDataItem ~= nil then
        local size = table.getn(self.totleLinkDataItem)
        for k,v in pairs(self.linkLabel) do
            if size < k then v:setVisible(false)
            else
                local item = self.totleLinkDataItem[k]
                local name = item["name"]
                local resStr = self.c_LanguageTemplate:getLanguageById(name)
                v:setVisible(true)
                v:setString(resStr)
                -- 遍历所有的羁绊，显示已激活的羁绊
                local _color = ui.COLOR_GREEN
                local _opacity = 255
                local _isGreen = true
                for _k,_v in pairs(self.totleLinkDataItem[k].trigger) do

                    if (not self:isExistsSelectSoldierData(_v)) then
                        _color = ui.COLOR_GREY
                        _isGreen = false
                        _opacity = 100
                        break
                    end
                end

                if _isGreen == false then
                    _color = ui.COLOR_GREEN

                    for _k,_v in pairs(self.totleLinkDataItem[k].trigger) do
                        if not self:isExistsEquipmentData2(_v) then
                             _color = ui.COLOR_GREY
                             _opacity = 100
                            break
                        end
                    end
                end
                -- v:setColor(_color)
                v:setOpacity(_opacity)

            end
        end
    end
end

function PVArenaCheckInfo:isExistsEquipmentData2(linkid)
    local lineUpSlot = self:getSlotItemBySeat(self.lastSelectHeroIndex)
    if lineUpSlot == nil then
        return false
    end

    local slotEquipment = lineUpSlot.equs

    for k, v in pairs(slotEquipment) do
        local equipmentPB = v.equ
        local templateId = equipmentPB.no
        if templateId == linkid then
            return true
        end
    end
    return false
end

function PVArenaCheckInfo:initView()
    
    self.userSpriteA = self.UIArenaCheckView["UIArenaCheckView"]["userSpriteA"]
    self.userSpriteB = self.UIArenaCheckView["UIArenaCheckView"]["userSpriteB"]
    self.userSpriteC = self.UIArenaCheckView["UIArenaCheckView"]["userSpriteC"]
    self.userSpriteD = self.UIArenaCheckView["UIArenaCheckView"]["userSpriteD"]
    self.userSpriteE = self.UIArenaCheckView["UIArenaCheckView"]["userSpriteE"]
    self.userSpriteF = self.UIArenaCheckView["UIArenaCheckView"]["userSpriteF"]

    self.equipMenuA = self.UIArenaCheckView["UIArenaCheckView"]["equipMenuA"]
    self.equipMenuB = self.UIArenaCheckView["UIArenaCheckView"]["equipMenuB"]
    self.equipMenuC = self.UIArenaCheckView["UIArenaCheckView"]["equipMenuC"]
    self.equipMenuD = self.UIArenaCheckView["UIArenaCheckView"]["equipMenuD"]
    self.equipMenuE = self.UIArenaCheckView["UIArenaCheckView"]["equipMenuE"]
    self.equipMenuF = self.UIArenaCheckView["UIArenaCheckView"]["equipMenuF"]

    self.qulityA = self.UIArenaCheckView["UIArenaCheckView"]["qulityA"]  --人物身上的装备
    self.qulityB = self.UIArenaCheckView["UIArenaCheckView"]["qulityB"]
    self.qulityC = self.UIArenaCheckView["UIArenaCheckView"]["qulityC"]
    self.qulityD = self.UIArenaCheckView["UIArenaCheckView"]["qulityD"]
    self.qulityE = self.UIArenaCheckView["UIArenaCheckView"]["qulityE"]
    self.qulityF = self.UIArenaCheckView["UIArenaCheckView"]["qulityF"]

    self.starSelect1 = self.UIArenaCheckView["UIArenaCheckView"]["starSelect1"]
    self.starSelect2 = self.UIArenaCheckView["UIArenaCheckView"]["starSelect2"]
    self.starSelect3 = self.UIArenaCheckView["UIArenaCheckView"]["starSelect3"]
    self.starSelect4 = self.UIArenaCheckView["UIArenaCheckView"]["starSelect4"]
    self.starSelect5 = self.UIArenaCheckView["UIArenaCheckView"]["starSelect5"]
    self.starSelect6 = self.UIArenaCheckView["UIArenaCheckView"]["starSelect6"]

    self.starTable = {}

    table.insert(self.starTable, self.starSelect1)
    table.insert(self.starTable, self.starSelect2)
    table.insert(self.starTable, self.starSelect3)
    table.insert(self.starTable, self.starSelect4)
    table.insert(self.starTable, self.starSelect5)
    table.insert(self.starTable, self.starSelect6)

    self.upOpenBgA = self.UIArenaCheckView["UIArenaCheckView"]["upOpenBgA"]  --未开启背景
    self.upOpenBgB = self.UIArenaCheckView["UIArenaCheckView"]["upOpenBgB"]  --未开启背景
    self.upOpenBgC = self.UIArenaCheckView["UIArenaCheckView"]["upOpenBgC"]  --未开启背景
    self.upOpenBgD = self.UIArenaCheckView["UIArenaCheckView"]["upOpenBgD"]  --未开启背景
    self.upOpenBgE = self.UIArenaCheckView["UIArenaCheckView"]["upOpenBgE"]  --未开启背景
    self.upOpenBgF = self.UIArenaCheckView["UIArenaCheckView"]["upOpenBgF"]  --未开启背景

    self.linkLabelA = self.UIArenaCheckView["UIArenaCheckView"]["linkLabelA"]
    self.linkLabelB = self.UIArenaCheckView["UIArenaCheckView"]["linkLabelB"]
    self.linkLabelC = self.UIArenaCheckView["UIArenaCheckView"]["linkLabelC"]
    self.linkLabelD = self.UIArenaCheckView["UIArenaCheckView"]["linkLabelD"]
    self.linkLabelE = self.UIArenaCheckView["UIArenaCheckView"]["linkLabelE"]
    self.linkLabelF = self.UIArenaCheckView["UIArenaCheckView"]["linkLabelF"]
    self.linkLabel = {}
    table.insert(self.linkLabel, self.linkLabelA)
    table.insert(self.linkLabel, self.linkLabelB)
    table.insert(self.linkLabel, self.linkLabelC)
    table.insert(self.linkLabel, self.linkLabelD)
    table.insert(self.linkLabel, self.linkLabelE)
    table.insert(self.linkLabel, self.linkLabelF)

    --武将小头像亮框
    self.iconMenuTable = {}
    self.lightKuangA = self.UIArenaCheckView["UIArenaCheckView"]["lightKuangA"]
    self.lightKuangB = self.UIArenaCheckView["UIArenaCheckView"]["lightKuangB"]
    self.lightKuangC = self.UIArenaCheckView["UIArenaCheckView"]["lightKuangC"]
    self.lightKuangD = self.UIArenaCheckView["UIArenaCheckView"]["lightKuangD"]
    self.lightKuangE = self.UIArenaCheckView["UIArenaCheckView"]["lightKuangE"]
    self.lightKuangF = self.UIArenaCheckView["UIArenaCheckView"]["lightKuangF"]
    table.insert(self.iconMenuTable, self.lightKuangA)
    table.insert(self.iconMenuTable, self.lightKuangB)
    table.insert(self.iconMenuTable, self.lightKuangC)
    table.insert(self.iconMenuTable, self.lightKuangD)
    table.insert(self.iconMenuTable, self.lightKuangE)
    table.insert(self.iconMenuTable, self.lightKuangF)

    self.imgHeroBg = self.UIArenaCheckView["UIArenaCheckView"]["playerSprite"] --英雄影子

    self.hpLabel = self.UIArenaCheckView["UIArenaCheckView"]["hpLabel"]
    self.powerLabel = self.UIArenaCheckView["UIArenaCheckView"]["powerLabel"]
    self.physicalDefLabel = self.UIArenaCheckView["UIArenaCheckView"]["physicalDefLabel"]
    self.magicDefLabel = self.UIArenaCheckView["UIArenaCheckView"]["magicDefLabel"]

    self.heroNode = self.UIArenaCheckView["UIArenaCheckView"]["heroNode"]
    self.heroNode2 = self.UIArenaCheckView["UIArenaCheckView"]["heroNode2"]

    self.heroNameLabel = self.UIArenaCheckView["UIArenaCheckView"]["heroNameLabel"]  --武将名
    self.bkLvBMLabel = self.UIArenaCheckView["UIArenaCheckView"]["bkLvBMLabel"]  --突破
    self.lvBMLabel = self.UIArenaCheckView["UIArenaCheckView"]["levelNumLabelNode"]  --等级
    self.breakLvBg = self.UIArenaCheckView["UIArenaCheckView"]["breakLvBg"]

    self.expSizeLayer = self.UIArenaCheckView["UIArenaCheckView"]["expSizeLayer"]
    self.expSprite = self.UIArenaCheckView["UIArenaCheckView"]["expSprite"]

    --阵容标签中的查看羁绊信息的相关变量
    self.linkTouchLayer = self.UIArenaCheckView["UIArenaCheckView"]["linkTouchLayer"]
    self.lineupHeroName = self.UIArenaCheckView["UIArenaCheckView"]["lineupHeroName"]
    self.linkInfoMenuItem = self.UIArenaCheckView["UIArenaCheckView"]["linkInfoMenuItem"]
    self.zhushouMenuitem = self.UIArenaCheckView["UIArenaCheckView"]["zhushouMenuitem"]
    self.linkDetailLayer = self.UIArenaCheckView["UIArenaCheckView"]["linkDetailLayer"]
    self.bgMenuItem = self.UIArenaCheckView["UIArenaCheckView"]["bgMenuItem"]
    self.chekLinkLayer = self.UIArenaCheckView["UIArenaCheckView"]["chekLinkLayer"]
    self.sxSprite = self.UIArenaCheckView["UIArenaCheckView"]["sxSprite"]
    self.jbSprite = self.UIArenaCheckView["UIArenaCheckView"]["jbSprite"]
    self.starAndNameNode = self.UIArenaCheckView["UIArenaCheckView"]["starAndNameNode"]


    -- self.levelNumLabelNode = self.UIArenaCheckView["UIArenaCheckView"]["levelNumLabelNode"]

    --战队名称显示
    self.teamName = self.UIArenaCheckView["UIArenaCheckView"]["teamName"]

    self.teamName:setString(self.curTeamName)
    self.linkInfoMenuItem:setAllowScale(false)
    self.bgMenuItem:setAllowScale(false)

    self:onSelectAddClick(self.curIndex)
    self.type = 1
    self:createListView()
end

function PVArenaCheckInfo:initHeroLayerTouch()
    self.heroLayer = self.UIArenaCheckView["UIArenaCheckView"]["heroLayer"]
    local posX,posY = self.heroLayer:getPosition()
    local size = self.heroLayer:getContentSize()

    local rectArea = cc.rect(posX, posY, size.width, size.height)

    local moveType = self.TYPE_MOVE_NONE
    local MAGIN = 50
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            local isInRect = cc.rectContainsPoint(rectArea, cc.p(x,y))
            moveType = self.TYPE_MOVE_NONE
            if isInRect then
                self.touchBeginX = x
                return true
            else
                return false
            end

        elseif  eventType == "moved" then
            local length = self.touchBeginX - x
            if math.abs(length) > MAGIN then
                if length > 0 then
                    moveType = self.TYPE_MOVE_LEFT
                else
                    moveType = self.TYPE_MOVE_RIGHT
                end
            else
                moveType = self.TYPE_MOVE_NONE
            end
        elseif  eventType == "ended" then
            self:onLayerTouchCallBack(moveType)
        end
    end
    self.heroLayer:registerScriptTouchHandler(onTouchEvent)
    self.heroLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.heroLayer:setTouchEnabled(true)
end

--触摸事件结束回调
function PVArenaCheckInfo:onLayerTouchCallBack(moveType)
    if moveType == self.TYPE_MOVE_NONE then
        --点击英雄大图进入英雄详细信息查看
        local heroData = self:getSlotItemBySeat(self.lastSelectHeroIndex)
        local heroPB = heroData.hero
        if heroPB.hero_no == 0 or heroPB == nil then return end
        local level = heroPB.level
        local break_level = heroPB.break_level
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", heroPB.hero_no, 1, level, nil,break_level)
    elseif moveType == self.TYPE_MOVE_LEFT then
        self:OnTouchMoveRight()
    elseif moveType == self.TYPE_MOVE_RIGHT then
        self:OnTouchMoveLeft()
    end
end

--往左滑动
function PVArenaCheckInfo:OnTouchMoveLeft()
    if self.lastSelectHeroIndex == 1 then
        self.lastSelectHeroIndex = self.maxOpenIndex
    else
        self.lastSelectHeroIndex = self.lastSelectHeroIndex -1
    end
    self:onSelectAddClick(self.lastSelectHeroIndex)
end

--往右滑动
function PVArenaCheckInfo:OnTouchMoveRight()

    if self.lastSelectHeroIndex == self.maxOpenIndex then
        self.lastSelectHeroIndex = 1
    else
        self.lastSelectHeroIndex = self.lastSelectHeroIndex + 1
    end
    self:onSelectAddClick(self.lastSelectHeroIndex)
end

function PVArenaCheckInfo:initLinkData(soldierId)

    self.cheerDiscriptions = {}

    local function getBuffInfo(buff)
        local strEffect = ""
        for i,v in ipairs(buff) do
            local buffInfo = self.c_SoldierTemplate:getSkillBuffTempLateById(buff[i])
            local buffEffectId = buffInfo.effectId
            local buffType = buffInfo.valueType
            local buffValue = buffInfo.valueEffect
            local strValue = nil
            if buffType == 1 then strValue = tostring(buffValue)
            elseif buffType == 2 then strValue = tostring(buffValue) .. "%"
            end
            strEffect = strEffect .. self.c_SoldierTemplate:getSkillBuffEffectName(buffEffectId) .. strValue
        end
        return strEffect
    end

    local posy = 250-5
    local posx = 0
    local _height = 0
    local linkItem = self.c_SoldierTemplate:getLinkTempLateById(soldierId)
    for i=1, 5 do
        local isTrigger,trigger = self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, i)

        if isTrigger then
            local strName = "linkname"..tostring(i)
            local strText = "linktext"..tostring(i)
            local strSkill = "link"..tostring(i)
            local name = linkItem[strName]
            local text = linkItem[strText]
            local skillId = linkItem[strSkill]
            local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
            local textLanguage = self.c_LanguageTemplate:getLanguageById(text)
            local skillInfo = self.c_SoldierTemplate:getSkillTempLateById(skillId)

            local buff = skillInfo.group
            textLanguage = string.gsub(textLanguage, "s%%", "")
            textLanguage = textLanguage .. getBuffInfo(buff)


            local _dis = nameLanguage.."："..textLanguage
            self.cheerDiscriptions[i] = {}
            self.cheerDiscriptions[i].trigger = trigger
            self.cheerDiscriptions[i].dis = _dis

        end
    end
end

function PVArenaCheckInfo:isExistsSelectSoldierData(linkid)
    for k,v in pairs(self.selectSoldierData) do
        if v.hero.hero_no == linkid then
            return true
        end
    end

    return false
end

--有无上阵人数，默认的黑色icon的显示与隐藏的方法
function PVArenaCheckInfo:updateUnOpenView()
    if self.maxOpenIndex > 0 then
        self.upOpenBgA:setVisible(false)
    else
        self.upOpenBgA:setVisible(true)
    end

    if self.maxOpenIndex > 1 then
        self.upOpenBgB:setVisible(false)
    else
        self.upOpenBgB:setVisible(true)
    end

    if self.maxOpenIndex > 2 then
        self.upOpenBgC:setVisible(false)
    else
        self.upOpenBgC:setVisible(true)
    end

    if self.maxOpenIndex > 3 then
        self.upOpenBgD:setVisible(false)
    else
        self.upOpenBgD:setVisible(true)
    end

    if self.maxOpenIndex > 4 then
        self.upOpenBgE:setVisible(false)
    else
        self.upOpenBgE:setVisible(true)
    end

    if self.maxOpenIndex > 5 then
        self.upOpenBgF:setVisible(false)
    else
        self.upOpenBgF:setVisible(true)
    end
end

--更新上阵英雄的icon
function PVArenaCheckInfo:updateHeroIcon()
    local tempIndex = 0

    for k, v in pairs(self.selectSoldierData) do
       local seat = v.slot_no
       local hero = v.hero
       local activation = v.activation
       local heroId = hero.hero_no
       self:updateHeroIconImage(heroId, seat, activation)
       if activation == true then
        tempIndex = tempIndex + 1
       end
    end
    self.maxOpenIndex = tempIndex
end

--更新上阵英雄icon使用的方法
function PVArenaCheckInfo:updateHeroIconImage(id, seatIndex, activation)
    local nowSprite = nil
    if seatIndex == 1 then
        nowSprite = self.userSpriteA
    elseif seatIndex == 2 then
        nowSprite = self.userSpriteB
    elseif seatIndex == 3 then
        nowSprite = self.userSpriteC
    elseif seatIndex == 4 then
        nowSprite = self.userSpriteD
    elseif seatIndex == 5 then
        nowSprite = self.userSpriteE
    elseif seatIndex == 6 then
        nowSprite = self.userSpriteF
    end
    if id ~= 0  then
        nowSprite:setVisible(true)
    else
        nowSprite:setVisible(false)
        return
    end

    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(id)
    local quality = soldierTemplateItem.quality

    local resIcon = self.c_SoldierTemplate:getSoldierIcon(id)
    changeNewIconImage(nowSprite, resIcon, quality)  -- 新版icon

end

--上阵英雄装备的更新显示
function PVArenaCheckInfo:updateSoldierEquipment()
    local lineUpSlot = self:getSlotItemBySeat(self.lastSelectHeroIndex)

    if lineUpSlot == nil then
        return
    end

    local slotEquipment = lineUpSlot.equs
    -- print("-------updateSoldierEquipment-------")
    -- table.print(slotEquipment)
    for k, v in pairs(slotEquipment) do
        self:updateEquipIcon(v)
    end
end

--更新武将装备图标
function PVArenaCheckInfo:updateEquipIcon(slotEquipment)
    local seat = slotEquipment.no    --装备格子编号
    local equipmentPB = slotEquipment.equ
    local templateId = equipmentPB.no
    local activation = true
    if templateId == 0 then
        activation = false
    end
    -- print("---------equipmentPB.no-------",equipmentPB.strengthen_lv)
    local tempIconSprite = nil
    if seat == 1 then
        if activation then
            self.qulityA:setVisible(true)
            tempIconSprite = self.qulityA
        else
            self.qulityA:setVisible(false)
        end
    end

    if seat == 2 then
        if activation then
            self.qulityB:setVisible(true)
            tempIconSprite = self.qulityB
        else
            self.qulityB:setVisible(false)
        end
    end

    if seat == 3 then
        if activation then
            self.qulityC:setVisible(true)
            tempIconSprite = self.qulityC
        else
            self.qulityC:setVisible(false)
        end
    end

    if seat == 4 then
        if activation then
            self.qulityD:setVisible(true)
            tempIconSprite = self.qulityD
        else
            self.qulityD:setVisible(false)
        end
    end

    if seat == 5 then
        if activation then
            self.qulityE:setVisible(true)
            tempIconSprite = self.qulityE
        else
            self.qulityE:setVisible(false)
        end
    end

    if seat == 6 then
        if activation then
            self.qulityF:setVisible(true)
            tempIconSprite = self.qulityF
        else
            self.qulityF:setVisible(false)
        end
    end

    if activation then
        local equipmentItem = self.c_equipTemp:getTemplateById(templateId)
        local quality = equipmentItem.quality
        local resIcon = self.c_equipTemp:getEquipResIcon(templateId)
        -- changeEquipIconImageBottom(tempIconSprite, resIcon, quality)
        setNewEquipCardWithFrame(tempIconSprite, resIcon, quality)
    end
end

function PVArenaCheckInfo:onSelectAddClick(selectSeat)
    getAudioManager():playEffectButton2()
    self.lastSelectHeroIndex = selectSeat
    self:updateHeroIconLight(selectSeat)
    local isInSeated = self:getIsSeated(selectSeat)
    if isInSeated then
        self.cheerSelectIndex = selectSeat
        self.linkInfoMenuItem:setEnabled(true)
        self:updateOtherView()
        self:updateSoldierEquipment() --更新显示装备
        self:updateSelectSoldierLinkView(selectSeat) --更新武将页面羁绊信息
    else
        self.curIndex = self.curIndex - 1
        self.linkInfoMenuItem:setEnabled(false)
        self:showEmptyView()
        self:clearAttribute()
        self:updateSoldierEquipment() --更新显示装备
        self:updateOtherView()
    end
    
end

--当选择的座位号上没有英雄时
function PVArenaCheckInfo:showEmptyView()
    --英雄大图
    self.heroNode:removeAllChildren()

    -- self.qulityA:setVisible(false)          --武将身上的装备
    -- self.qulityB:setVisible(false)
    -- self.qulityC:setVisible(false)
    -- self.qulityD:setVisible(false)
    -- self.qulityE:setVisible(false)
    -- self.qulityF:setVisible(false)

    self.breakLvBg:setVisible(false)
    updateStarLV(self.starTable, 0) --更新星级

    -- self.bkLvBMLabel:setString("")   --更新突破等级

    self.heroNameLabel:setString("")   --武将名称

    self.lvBMLabel:removeAllChildren()
    -- self.lvBMLabel:setString("")  --英雄等级
    self.chekLinkLayer:setVisible(false)
    self.linkInfoMenuItem:setEnabled(false)
    self.zhushouMenuitem:setEnabled(false)
    self.starAndNameNode:setVisible(false)
    self.breakLvBg:setVisible(false)
end

function PVArenaCheckInfo:initTouchListener()

    local function menuAddClickA()
        local isInSeated = self:getIsSeated(1)
        if isInSeated then
            self.curIndex = 1
            self:onSelectAddClick(1)
        end
    end

    local function menuAddClickB()
        local isInSeated = self:getIsSeated(2)
        if isInSeated then
            self.curIndex = 2
            self:onSelectAddClick(2)
        end
    end

    local function menuAddClickC()
        local isInSeated = self:getIsSeated(3)
        if isInSeated then
            self.curIndex = 3
            self:onSelectAddClick(3)
        end
    end

    local function menuAddClickD()
        local isInSeated = self:getIsSeated(4)
        if isInSeated then
            self.curIndex = 4
            self:onSelectAddClick(4)
        end
    end

    local function menuAddClickE()
        local isInSeated = self:getIsSeated(5)
        if isInSeated then
            self.curIndex = 5
            self:onSelectAddClick(5)
        end
    end

    local function menuAddClickF()
        local isInSeated = self:getIsSeated(6)
        if isInSeated then
            self.curIndex = 6
            self:onSelectAddClick(6)
        end
    end

    local function equipClickA()

        self:showSelectEquipmenatView(1)
    end

    local function equipClickB()

        self:showSelectEquipmenatView(2)
    end

    local function equipClickC()

        self:showSelectEquipmenatView(3)
    end

    local function equipClickD()

        self:showSelectEquipmenatView(4)
    end

    local function equipClickE()

        self:showSelectEquipmenatView(5)
    end

    local function equipClickF()

        self:showSelectEquipmenatView(6)
    end

    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    local function onCloseClick()
        self.jbSprite:removeAllChildren()
        self.sxSprite:removeAllChildren()
        self.chekLinkLayer:setVisible(false)
    end

    --查看属性信息
    local function onAttributeClick()
        self.str_type = Localize.query("lineupTypeShow.1")
        self.jbSprite:removeAllChildren()
        self.sxSprite:removeAllChildren()

        local _node = UI_Wujiangjiemianwujianganniu(20,20)
        getAudioManager():playEffectButton2()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
            self.tableView = nil
        end
        if self.chekLinkLayer:isVisible() then
            if self.scrollView then
                self.chekLinkLayer:setVisible(false)
            else
                self.sxSprite:addChild(_node)
            end
            self:createAttrScroll()
            self:createAttributeScollView()
        else
            if self.scrollView then
                self.chekLinkLayer:setVisible(true)
                self.sxSprite:addChild(_node)
            else
                self.chekLinkLayer:setVisible(true)
                 self.sxSprite:addChild(_node)
            end
            self:createAttrScroll()
            self:createAttributeScollView()
        end
        local heroData = self:getSlotItemBySeat(self.lastSelectHeroIndex)
        local nameStr = self.c_SoldierTemplate:getHeroName(heroData.hero.hero_no)
        local _name_type = nameStr .. self.str_type
        self.lineupHeroName:setString(_name_type)  --羁绊界面武将名称
    end
    --查看羁绊信息
    local function onLinkIndoClick()
        self.str_type = Localize.query("lineupTypeShow.2")
        self.jbSprite:removeAllChildren()
        self.sxSprite:removeAllChildren()
        local _node = UI_Wujiangjiemianwujianganniu(20,20)
        if self.scrollView ~= nil then
            self.scrollView:removeFromParent(true)
            self.scrollView = nil
        end
        if self.chekLinkLayer:isVisible() then
            if self.tableView then
                self.chekLinkLayer:setVisible(false)
                self.tableView:setTouchEnabled(false)
            else
                self:createListView()
                self:onSelectAddClick(self.curIndex)
                self.jbSprite:addChild(_node)
            end
        else
            if self.tableView then
                self.chekLinkLayer:setVisible(true)
                self:createListView()
                self:onSelectAddClick(self.curIndex)
                self.tableView:setTouchEnabled(true)
            else
                self.chekLinkLayer:setVisible(true)
                self:createListView()
                self:onSelectAddClick(self.curIndex)
            end
            self.jbSprite:addChild(_node)
        end
        local heroData = self:getSlotItemBySeat(self.lastSelectHeroIndex)
        local nameStr = self.c_SoldierTemplate:getHeroName(heroData.hero.hero_no)
        local _name_type = nameStr .. self.str_type
        self.lineupHeroName:setString(_name_type)  --羁绊界面武将名称
    end

    self.UIArenaCheckView["UIArenaCheckView"] = {}

    self.UIArenaCheckView["UIArenaCheckView"]["menuAddClickA"] = menuAddClickA
    self.UIArenaCheckView["UIArenaCheckView"]["menuAddClickB"] = menuAddClickB
    self.UIArenaCheckView["UIArenaCheckView"]["menuAddClickC"] = menuAddClickC
    self.UIArenaCheckView["UIArenaCheckView"]["menuAddClickD"] = menuAddClickD
    self.UIArenaCheckView["UIArenaCheckView"]["menuAddClickE"] = menuAddClickE
    self.UIArenaCheckView["UIArenaCheckView"]["menuAddClickF"] = menuAddClickF

    self.UIArenaCheckView["UIArenaCheckView"]["equipClickA"] = equipClickA
    self.UIArenaCheckView["UIArenaCheckView"]["equipClickB"] = equipClickB
    self.UIArenaCheckView["UIArenaCheckView"]["equipClickC"] = equipClickC
    self.UIArenaCheckView["UIArenaCheckView"]["equipClickD"] = equipClickD
    self.UIArenaCheckView["UIArenaCheckView"]["equipClickE"] = equipClickE
    self.UIArenaCheckView["UIArenaCheckView"]["equipClickF"] = equipClickF

    self.UIArenaCheckView["UIArenaCheckView"]["backMenuClick"] = backMenuClick
    self.UIArenaCheckView["UIArenaCheckView"]["onLinkIndoClick"] = onLinkIndoClick
    self.UIArenaCheckView["UIArenaCheckView"]["onAttributeClick"] = onAttributeClick
    self.UIArenaCheckView["UIArenaCheckView"]["onCloseClick"] = onCloseClick
end

--获得该座位是否有人坐
function PVArenaCheckInfo:getIsSeated(seat)
    self.selectSoldierData = self.otherPlayerLineUp.slot
    for k, v in pairs(self.selectSoldierData) do
        local tempSeat = v.slot_no
        if tempSeat == seat then
            if v.hero.hero_no ~= 0 then
                return true
            else
                return false
            end
        end
    end
end

--
function PVArenaCheckInfo:updateOtherView()
    self.linkInfoMenuItem:setEnabled(true)
    self.zhushouMenuitem:setEnabled(true)
    self.starAndNameNode:setVisible(true)
    self.breakLvBg:setVisible(true)
    -- 下一个英雄位置
    local _nextHeroIndex = nil
    if self.lastSelectHeroIndex == 6 then  -- self.maxOpenIndex
        _nextHeroIndex = 1
    else
        _nextHeroIndex = self.lastSelectHeroIndex + 1
    end
    heroData = self:getSlotItemBySeat(self.lastSelectHeroIndex)
    heroData2 = self:getSlotItemBySeat(_nextHeroIndex)
    local heroPB = heroData.hero
    local heroId = heroPB.hero_no
    local heroPB2 = heroData2.hero
    local heroId2 = heroPB2.hero_no
    if heroId == nil then heroId = 0 end
    if heroId2 == nil then heroId2 = 0 end
    local level = heroPB.level
    local break_level = heroPB.break_level

    --更新英雄大图
    local _time = 0.3
    local _time2 = 0.1
    self.heroNode:removeAllChildren()
    self.heroNode2:removeAllChildren()
    if heroId ~= 0 then           -- 11111大图
        self.sodierData:loadHeroImage(heroId)
        local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(heroId)
        self.heroNode:addChild(heroImageNode)
        -- self.heroNode:stopActionByTag(10001)
        -- self.heroNode:stopActionByTag(10002)
        -- local _node1 = heroImageNode:getChildByTag(1)
        -- local _node2 = heroImageNode:getChildByTag(2)
        -- self.heroNode:setScale(0.9)
        -- heroImageNode:setOpacity(100)
        -- if _node1 ~= nil then  _node1:setOpacity(100) end
        -- if _node2 ~= nil then  _node2:setOpacity(100) end

        -- if self.moveType ==  1 then
        --     self.heroNode:setPosition(cc.p(534, 712))
        -- elseif self.moveType ==  2 then
        --     self.heroNode:setPosition(cc.p(0, 0))
        -- end

        -- local moveTo = cc.MoveTo:create(_time, cc.p(280, 518))
        -- local scaleTo = cc.ScaleTo:create(_time, 1.3)
        -- local fadeInAction = cc.FadeIn:create(_time)
        -- local fadeInAction1 = cc.FadeIn:create(_time)
        -- local fadeInAction2 = cc.FadeIn:create(_time)
        -- moveTo:setTag(10001)
        -- scaleTo:setTag(10002)
        -- fadeInAction:setTag(10003)
        -- fadeInAction1:setTag(10004)
        -- fadeInAction2:setTag(10005)
        -- self.heroNode:runAction(moveTo)
        -- self.heroNode:runAction(scaleTo)
        -- heroImageNode:runAction(fadeInAction)
        -- if _node1 ~= nil then _node1:runAction(fadeInAction1) end
        -- if _node2 ~= nil then _node2:runAction(fadeInAction2) end
    end
    if heroId2 ~= 0 then          -- 下一个英雄大图
        print("-------222222222-------",heroId2)
        self.sodierData:loadHeroImage(heroId2)
        local heroImageNode2 = self.c_SoldierTemplate:getHeroBigImageById(heroId2)
        self.heroNode2:addChild(heroImageNode2)
        local _node1 = heroImageNode2:getChildByTag(1)
        local _node2 = heroImageNode2:getChildByTag(2)
        if _node1 ~= nil then  _node1:setOpacity(100) end
        if _node2 ~= nil then  _node1:setOpacity(100) end
        heroImageNode2:setOpacity(100)
    end

    if heroId == 0 then self:showEmptyView() return end
    self:updateAttribute(heroId, level, break_level)   --更新属性


    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(heroId)
    local quality = soldierTemplateItem.quality

    local breakStr = "" .. break_level

    if break_level > 0 then
        self.breakLvBg:setVisible(true)
        self.breakLvBg:setSpriteFrame(self:updateBreakLv(break_level))
        -- self.bkLvBMLabel:setString(breakStr)              --更新突破等级
    else
        self.breakLvBg:setVisible(false)
    end

    updateStarLV(self.starTable, quality) --更新星级

    local nameStr = self.c_SoldierTemplate:getHeroName(heroId)
    local _name_type = nameStr .. self.str_type
    self.heroNameLabel:setString(nameStr)   --武将名称
    self.lineupHeroName:setString(_name_type)


    -- local heroLvStr = "Lv." ..string.format(level)
    -- self.lvBMLabel:setString(heroLvStr)  --英雄等级
    print("---------level-----------",level)
    local levelNode = getLevelNode(level)    --更新等级
    self.lvBMLabel:removeAllChildren()
    self.lvBMLabel:addChild(levelNode)
    local exp = self.c_arenaData:getExpById(heroId)

    local totalExp = self.c_SoldierTemplate:getHeroExpByLevel(level)
    print("expSpriteexpSpriteexpSprite ==================  ", exp ,   totalExp)
    local size = self.expSizeLayer:getContentSize()
    self.expSprite:setScaleX(exp / totalExp)
    --expSprite
end

function PVArenaCheckInfo:updateBreakLv(level)
    local _img = ""
    if level == 1 then
        _img = "ui_lineup_number1.png"
    elseif level == 2 then
        _img = "ui_lineup_number2.png"
    elseif level == 3 then
        _img = "ui_lineup_number3.png"
    elseif level == 4 then
        _img = "ui_lineup_number4.png"
    elseif level == 5 then
        _img = "ui_lineup_number5.png"
    elseif level == 6 then
        _img = "ui_lineup_number6.png"
    elseif level == 7 then
        _img = "ui_lineup_number7.png"
    elseif level == 8 then
        _img = "ui_lineup_number8.png"
    elseif level == 9 then
        _img = "ui_lineup_number9.png"
    end

    return _img
end

--清除属性
function PVArenaCheckInfo:clearAttribute(heroId, level, break_level)
    self.hpLabel:setString("0")
    self.powerLabel:setString("0")
    self.physicalDefLabel:setString("0")
    self.magicDefLabel:setString("0")

    for k,v in pairs(self.linkLabel) do
        v:setVisible(false)
    end
end

--更新属性
function PVArenaCheckInfo:updateAttribute(heroId, level, break_level)
    -- local hpValue = self.c_SoldierCalculation:getSoldierHP(heroId, level, break_level)
    -- local atkValue = self.c_SoldierCalculation:getSoldierATK(heroId, level, break_level)
    -- local pdefValue = self.c_SoldierCalculation:getSoldierPDEF(heroId, level, break_level)
    -- local mdefValue = self.c_SoldierCalculation:getSoldierMDEF(heroId, level, break_level)

    -- self.hpLabel:setString(string.format(hpValue))
    -- self.powerLabel:setString(string.format(atkValue))
    -- self.physicalDefLabel:setString(string.format(pdefValue))
    -- self.magicDefLabel:setString(string.format(mdefValue))
    -- 新版本使用
    self.c_Calculation:setLineUpData(self.otherPlayerLineUp)
    local attr = self.c_Calculation:SoldierLineUpAttr(self.lastSelectHeroIndex)
    self.c_Calculation:resetLineUpData()
    self.hpLabel:setString(string.format(roundAttriNum(attr.hpArray)))
    self.powerLabel:setString(string.format(roundAttriNum(attr.atkArray)))
    self.physicalDefLabel:setString(string.format(roundAttriNum(attr.physicalDefArray)))
    self.magicDefLabel:setString(string.format(roundAttriNum(attr.magicDefArray)))
end

function PVArenaCheckInfo:setColorByIsOpenCheerLink(item, label)
    for _k,_v in pairs(self.linkItemTable) do
        if _v.link == item.link then
            label:setColor(ui.COLOR_GREEN)
            break
        end
    end
end

--创建羁绊列表
function PVArenaCheckInfo:createListView()
    local function tableCellTouched(table, cell)
    end

    local function numberOfCellsInTableView(table)
        return self.size
    end

    local function cellSizeForTable(table, idx)
        return self.itemSize.height+5,self.itemSize.width
    end

    
    local function tableCellAtIndex(tab, idx)
        local cell = nil --tab:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UILinkItem"] = {}
            local node = nil  --CCBReaderLoad("lineup/ui_link_item.ccbi", proxy, cell.cardinfo)
    
            if self.cheerDiscriptions[idx + 1].typeId == 1 and idx == 0 then
                node = CCBReaderLoad("lineup/ui_link_item.ccbi", proxy, cell.cardinfo)
            elseif self.cheerDiscriptions[idx + 1].typeId == 2 and idx == 0 then
                node = CCBReaderLoad("lineup/ui_link_item.ccbi", proxy, cell.cardinfo)
            elseif self.cheerDiscriptions[idx + 1].typeId == 2 and self.cheerDiscriptions[idx].typeId == 1 then
                node = CCBReaderLoad("lineup/ui_link_item.ccbi", proxy, cell.cardinfo)
            else
                node = CCBReaderLoad("lineup/ui_link_item1.ccbi", proxy, cell.cardinfo)
            end

            local layer = cell.cardinfo["UILinkItem"]["layer"]
            local descLabel = cell.cardinfo["UILinkItem"]["descLabel"]

            cell:addChild(node)
        end

        local discriptionLab = cell.cardinfo["UILinkItem"]["discriptionLab"]
        local linkTypeNme = cell.cardinfo["UILinkItem"]["linkTypeNameLabel"]
        local linkbg = cell.cardinfo["UILinkItem"]["linkbg"]
        local linkTypeName1 = cell.cardinfo["UILinkItem"]["linkTypeName1"]
        local linkTypeName2 = cell.cardinfo["UILinkItem"]["linkTypeName2"]

        -- local linkSprite = cell.cardinfo["UILinkItem"]["lineSprite"]
        discriptionLab:setDimensions(600,0)
        if self.type == 1 then
            local _posX, _posY = discriptionLab:getPosition()
            discriptionLab:setPosition(cc.p(_posX - 35, _posY))
            -- local _posX, _posY = linkTypeNme:getPosition()
            -- linkTypeNme:setPosition(cc.p(_posX - 80, _posY))
        elseif self.type == 2 then
            local _posX, _posY = discriptionLab:getPosition()
            discriptionLab:setPosition(cc.p(_posX - 35, _posY))
        end
        discriptionLab:setString(self.cheerDiscriptions[idx + 1].dis)
        discriptionLab:setColor(ui.COLOR_GREY)
        print("----羁绊ID-----",self.cheerDiscriptions[idx + 1].typeId)

        local _color = self:getLinkColor(self.cheerDiscriptions[idx + 1])
        discriptionLab:setColor(_color)
        if self.cheerDiscriptions[idx + 1].typeId == 1 and idx == 0 then
            linkTypeName1:setVisible(true)
            linkTypeName2:setVisible(false)
        elseif self.cheerDiscriptions[idx + 1].typeId == 2 and idx == 0 then
            linkTypeName1:setVisible(false)
            linkTypeName2:setVisible(true)
        elseif self.cheerDiscriptions[idx + 1].typeId == 2 and self.cheerDiscriptions[idx].typeId == 1 then
            linkTypeName1:setVisible(false)
            linkTypeName2:setVisible(true)
        else
            linkTypeName1:setVisible(false)
            linkTypeName2:setVisible(false)
        end
        return cell
    end


    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("lineup/ui_link_item.ccbi", proxy, tempTable)
    local sizeLayer = tempTable["UILinkItem"]["sizeLayer"]

    self.itemSize = sizeLayer:getContentSize()
    self.layerSize = self.linkDetailLayer:getContentSize()


    if self.tableView ~= nil then
        self.tableView:removeFromParent(true)
    end
    self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))
    self.linkDetailLayer:addChild(self.tableView)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)

    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    -- local scrBar = PVScrollBar:new()
    -- scrBar:init(self.tableView,1)
    -- scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
    -- self.linkDetailLayer:addChild(scrBar,2)
end

function PVArenaCheckInfo:getLinkColor(LinkDataItem, label)

    local _color = ui.COLOR_GREEN
    local _isGreen = true
    for _k,_v in pairs(LinkDataItem.trigger) do

        if not self:isExistsSelectSoldierData(_v) then
            _color = ui.COLOR_GREY
            _isGreen = false
            break
        end
    end

    if _isGreen == false then
        _color = ui.COLOR_GREEN
        for _k,_v in pairs(LinkDataItem.trigger) do
            if not self:isExistsEquipmentData(_v) then
                 _color = ui.COLOR_GREY
                break
            end
        end
    end

    return _color
end

function PVArenaCheckInfo:isExistsEquipmentData(linkid)
    local lineUpSlot = self:getSlotItemBySeat(self.cheerSelectIndex)
    if lineUpSlot == nil then
        return false
    end

    local slotEquipment = lineUpSlot.equs

    for k, v in pairs(slotEquipment) do
        local equipmentPB = v.equ
        local templateId = equipmentPB.no

        if templateId == linkid then
            return true
        end
    end
    return false
end

-- function PVArenaCheckInfo:showSelectHeroView()
--     local _seatState = self:getIsSeated(self.curIndex)
--     if _seatState then
--         local slotItem = self.lineupData:getSlotItemBySeat(self.curIndex)
--         if slotItem ~= nil then
--             local heroPb = slotItem.hero
--             local soldierId = heroPb.hero_no
--             if soldierId ~= 0 then
--                 getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", soldierId, 1, nil, nil)
--             end
--         end
--     else
--        getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_HERO, self.fromType)
--     end
-- end

function PVArenaCheckInfo:showSelectEquipmenatView(seat)
    cclog("self.lastSelectHeroIndex＝＝=========="..self.lastSelectHeroIndex)
    local isInSeated = self:getIsSeated(self.lastSelectHeroIndex)
    if not isInSeated then
        getOtherModule():showAlertDialog(nil, Localize.query("lineup.5"))
        return
    end

    self.lastSelectType = TYPE_SELECT_EQUIP
    self.lastSelectEquipSeat = seat

    local equipData = self.c_arenaData:getEquipDataSeat(self.lastSelectHeroIndex, seat)
    -- print("---------equipData---------")
    -- table.print(equipData)
    if equipData ~= nil and equipData.no ~= 0 and equipData.id ~= "" then --如果装备位上有装备,则跳到装备属性页面
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherPlayerEquipAttribute", equipData)
    end
end

--创建属性加成列表
function PVArenaCheckInfo:createAttrScroll()
    if self.scrollView ~= nil then
        self.scrollView:removeFromParent(true)
        self.scrollView = nil
    end
    self.linkDetailLayer:removeChildByTag(10001)
    -- self.listLayer:removeChildByTag(10001)

    self.scrollView = cc.ScrollView:create()
    local screenSize = nil
    print("选择武将 -==========-")
    if self.scrollView ~= nil then
        screenSize = self.linkDetailLayer:getContentSize()
        self.scrollView:setViewSize(cc.size(screenSize.width, screenSize.height))
        self.scrollView:ignoreAnchorPointForPosition(true)
        self.scrollView:setDirection(1)
        self.scrollView:setClippingToBounds(true)
        self.scrollView:setBounceable(true)
        self.scrollView:setDelegate()
        self.scrollView:updateInset()
        self.scrollView:setContentSize(cc.size(screenSize.width, 1000))

    end
    self.linkDetailLayer:addChild(self.scrollView)

    -- local scrBar = PVScrollBar:new()
    -- scrBar:init(self.scrollView,1)
    -- scrBar:setPosition(cc.p(screenSize.width,screenSize.height/2))
    -- self.linkDetailLayer:addChild(scrBar,2,10001)
end

-- 创建详细属性加成列表
function PVArenaCheckInfo:createAttributeScollView()
    self.lineupAttrNode = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("lineup/ui_lineup_attribute_item.ccbi", proxy, self.lineupAttrNode)

    --属性一览
    local _attrLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrLifeLabel"]
    local _attrAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrAtkLabel"]
    local _attrPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrPdefLabel"]
    local _attrMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrMdefLabel"]
    local _attrHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrHitLabel"]
    local _attrDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrDodgeLabel"]
    local _attrCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrCriLabel"]
    local _attrDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrDuctilityLabel"]
    local _attrCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrCri_hurtLabel"]
    local _attrCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrCri_dedLabel"]
    local _attrBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrBlockLabel"]
    --装备
    local _equipLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipLifeLabel"]
    local _equipAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipAtkLabel"]
    local _equipPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipPdefLabel"]
    local _equipMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipMdefLabel"]
    local _equipHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipHitLabel"]
    local _equipDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipDodgeLabel"]
    local _equipCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipCriLabel"]
    local _equipDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipDuctilityLabel"]
    local _equipCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipCri_hurtLabel"]
    local _equipCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipCri_dedLabel"]
    local _equipBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipBlockLabel"]
    --炼体
    local _ltLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltLifeLabel"]
    local _ltAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltAtkLabel"]
    local _ltPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltPdefLabel"]
    local _ltMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltMdefLabel"]
    local _ltHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltHitLabel"]
    local _ltDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltDodgeLabel"]
    local _ltCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltCriLabel"]
    local _ltDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltDuctilityLabel"]
    local _ltCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltCri_hurtLabel"]
    local _ltCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltCri_dedLabel"]
    local _ltBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltBlockLabel"]
    --符文
    local _fwLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwLifeLabel"]
    local _fwAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwAtkLabel"]
    local _fwPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwPdefLabel"]
    local _fwMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwMdefLabel"]
    local _fwHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwHitLabel"]
    local _fwDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwDodgeLabel"]
    local _fwCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwCriLabel"]
    local _fwDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwDuctilityLabel"]
    local _fwCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwCri_hurtLabel"]
    local _fwCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwCri_dedLabel"]
    local _fwBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwBlockLabel"]
    --风物志
    local _fwzLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzLifeLabel"]
    local _fwzAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzAtkLabel"]
    local _fwzPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzPdefLabel"]
    local _fwzMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzMdefLabel"]
    --公会
    local _legionLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionLifeLabel"]
    local _legionAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionAtkLabel"]
    local _legionPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionPdefLabel"]
    local _legionMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionMdefLabel"]
    --
    local _arrowSprite = self.lineupAttrNode["UILineupAttributeItem"]["arrowSprite"]
    local seqAction = cc.Sequence:create({cc.MoveBy:create(0.3,cc.p(0,-10)),cc.MoveBy:create(0.3,cc.p(0,10))})
    _arrowSprite:runAction(cc.RepeatForever:create(seqAction))

    
    -- end

    -- local hero = self.c_arenaData:getHeroDataBySeat(self.lastSelectHeroIndex)
    -- print("---------hero--------",self.lastSelectHeroIndex)
    -- table.print(hero)
    local hero = self.otherPlayerLineUp.slot[self.curIndex].hero
    if hero == nil then return 0 end
    local _abc = math.floor
    --属性一览
    self.c_Calculation:setLineUpData(self.otherPlayerLineUp)
    local attr = self.c_Calculation:SoldierLineUpAttr(self.curIndex)
    _attrLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(attr.hpArray)))
    if attr.hpArray > 0 then
        _attrLifeLabel:setColor(ui.COLOR_GREEN)
    else
        _attrLifeLabel:setColor(ui.COLOR_GREY)
    end
    _attrAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(attr.atkArray)))
    if attr.atkArray > 0 then
        _attrAtkLabel:setColor(ui.COLOR_GREEN)
    else
        _attrAtkLabel:setColor(ui.COLOR_GREY)
    end
    _attrPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(attr.physicalDefArray)))
    if attr.physicalDefArray > 0 then
        _attrPdefLabel:setColor(ui.COLOR_GREEN)
    else
        _attrPdefLabel:setColor(ui.COLOR_GREY)
    end
    _attrMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(attr.magicDefArray)))
    if attr.magicDefArray > 0 then
        _attrMdefLabel:setColor(ui.COLOR_GREEN)
    else
        _attrMdefLabel:setColor(ui.COLOR_GREY)
    end
    _attrHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(attr.hitArray)))
    if attr.hitArray > 0 then
        _attrHitLabel:setColor(ui.COLOR_GREEN)
    else
        _attrHitLabel:setColor(ui.COLOR_GREY)
    end
    _attrDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(attr.dodgeArray)))
    if attr.dodgeArray > 0 then
        _attrDodgeLabel:setColor(ui.COLOR_GREEN)
    else
        _attrDodgeLabel:setColor(ui.COLOR_GREY)
    end
    _attrCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(attr.criArray)))
    if attr.criArray > 0 then
        _attrCriLabel:setColor(ui.COLOR_GREEN)
    else
        _attrCriLabel:setColor(ui.COLOR_GREY)
    end
    _attrDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(attr.ductilityArray)))
    if attr.ductilityArray > 0 then
        _attrDuctilityLabel:setColor(ui.COLOR_GREEN)
    else
        _attrDuctilityLabel:setColor(ui.COLOR_GREY)
    end
    _attrCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(attr.criCoeffArray)))
    if attr.criCoeffArray > 0 then
        _attrCri_hurtLabel:setColor(ui.COLOR_GREEN)
    else
        _attrCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _attrCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(attr.criDedCoeffArray )))
    if attr.criDedCoeffArray > 0 then
        _attrCri_dedLabel:setColor(ui.COLOR_GREEN)
    else
        _attrCri_dedLabel:setColor(ui.COLOR_GREY)
    end
    _attrBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(attr.blockArray )))
    if attr.blockArray > 0 then
        _attrBlockLabel:setColor(ui.COLOR_GREEN)
    else
        _attrBlockLabel:setColor(ui.COLOR_GREY)
    end
    --装备
    local self_attr = self.c_Calculation:SoldierSelfAttr(hero)
    local equ_attr = self.c_Calculation:EquAttr(self.otherPlayerLineUp.slot[self.curIndex], self_attr)
    _equipLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(equ_attr.hp)))
    if equ_attr.hp > 0 then
        _equipLifeLabel:setColor(ui.COLOR_GREEN)
    else
        _equipLifeLabel:setColor(ui.COLOR_GREY)
    end
    _equipAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(equ_attr.atk)))
    if equ_attr.atk > 0 then
        _equipAtkLabel:setColor(ui.COLOR_GREEN)
    else
        _equipAtkLabel:setColor(ui.COLOR_GREY)
    end
    _equipPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(equ_attr.physicalDef)))
    if equ_attr.physicalDef > 0 then
        _equipPdefLabel:setColor(ui.COLOR_GREEN)
    else
        _equipPdefLabel:setColor(ui.COLOR_GREY)
    end
    _equipMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(equ_attr.magicDef)))
    if equ_attr.magicDef > 0 then
        _equipMdefLabel:setColor(ui.COLOR_GREEN)
    else
        _equipMdefLabel:setColor(ui.COLOR_GREY)
    end
    _equipHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(equ_attr.hit)))
    if equ_attr.hit > 0 then
        _equipHitLabel:setColor(ui.COLOR_GREEN)
    else
        _equipHitLabel:setColor(ui.COLOR_GREY)
    end
     _equipDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(equ_attr.dodge)))
    if equ_attr.dodge > 0 then
        _equipDodgeLabel:setColor(ui.COLOR_GREEN)
    else
        _equipDodgeLabel:setColor(ui.COLOR_GREY)
    end
     _equipCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(equ_attr.cri)))
    if equ_attr.cri > 0 then
        _equipCriLabel:setColor(ui.COLOR_GREEN)
    else
        _equipCriLabel:setColor(ui.COLOR_GREY)
    end
    _equipDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(equ_attr.ductility)))
    if equ_attr.ductility > 0 then
        _equipDuctilityLabel:setColor(ui.COLOR_GREEN)
    else
        _equipDuctilityLabel:setColor(ui.COLOR_GREY)
    end
    _equipCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(equ_attr.criCoeff)))
    if equ_attr.criCoeff > 0 then
        _equipCri_hurtLabel:setColor(ui.COLOR_GREEN)
    else
        _equipCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _equipCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(equ_attr.criDedCoeff)))
    if equ_attr.criDedCoeff > 0 then
        _equipCri_dedLabel:setColor(ui.COLOR_GREEN)
    else
        _equipCri_dedLabel:setColor(ui.COLOR_GREY)
    end
     _equipBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(equ_attr.block)))
    if equ_attr.block > 0 then
        _equipBlockLabel:setColor(ui.COLOR_GREEN)
    else
        _equipBlockLabel:setColor(ui.COLOR_GREY)
    end
    --炼体
    local chain_attr = self.c_SoldierTemplate:getAllAttribute(hero.refine)
    _ltLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(chain_attr.hp)))
    if chain_attr.hp > 0 then
        _ltLifeLabel:setColor(ui.COLOR_GREEN)
    else
        _ltLifeLabel:setColor(ui.COLOR_GREY)
    end
    _ltAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(chain_attr.atk)))
    if chain_attr.atk > 0 then
        _ltAtkLabel:setColor(ui.COLOR_GREEN)
    else
        _ltAtkLabel:setColor(ui.COLOR_GREY)
    end
    _ltPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(chain_attr.physicalDef)))
    if chain_attr.physicalDef > 0 then
        _ltPdefLabel:setColor(ui.COLOR_GREEN)
    else
        _ltPdefLabel:setColor(ui.COLOR_GREY)
    end
    _ltMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(chain_attr.magicDef)))
    if chain_attr.magicDef > 0 then
        _ltMdefLabel:setColor(ui.COLOR_GREEN)
    else
        _ltMdefLabel:setColor(ui.COLOR_GREY)
    end
    _ltHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(chain_attr.hit)))
    if chain_attr.hit > 0 then
        _ltHitLabel:setColor(ui.COLOR_GREEN)
    else
        _ltHitLabel:setColor(ui.COLOR_GREY)
    end
    _ltDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(chain_attr.dodge)))
    if chain_attr.dodge > 0 then
        _ltDodgeLabel:setColor(ui.COLOR_GREEN)
    else
        _ltDodgeLabel:setColor(ui.COLOR_GREY)
    end
    _ltCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(chain_attr.cri)))
    if chain_attr.cri > 0 then
        _ltCriLabel:setColor(ui.COLOR_GREEN)
    else
        _ltCriLabel:setColor(ui.COLOR_GREY)
    end
    _ltDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(chain_attr.ductility)))
    if chain_attr.ductility > 0 then
        _ltDuctilityLabel:setColor(ui.COLOR_GREEN)
    else
        _ltDuctilityLabel:setColor(ui.COLOR_GREY)
    end
     _ltCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(chain_attr.criCoeff)))
    if chain_attr.criCoeff > 0 then
        _ltCri_hurtLabel:setColor(ui.COLOR_GREEN)
    else
        _ltCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _ltCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(chain_attr.criDedCoeff)))
    if chain_attr.criDedCoeff > 0 then
        _ltCri_dedLabel:setColor(ui.COLOR_GREEN)
    else
        _ltCri_dedLabel:setColor(ui.COLOR_GREY)
    end
    _ltBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(chain_attr.block)))
    if chain_attr.block > 0 then
        _ltBlockLabel:setColor(ui.COLOR_GREEN)
    else
        _ltBlockLabel:setColor(ui.COLOR_GREY)
    end
    --符文
    local hero_info = self.c_SoldierTemplate:getHeroTempLateById(hero.hero_no)
    local rune_attr = self.c_Calculation:SoldierRuneAttr(hero, hero_info)
    _fwLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(rune_attr.hp)))
    if rune_attr.hp > 0 then
        _fwLifeLabel:setColor(ui.COLOR_GREEN)
    else
        _fwLifeLabel:setColor(ui.COLOR_GREY)
    end
    _fwAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(rune_attr.atk)))
    if rune_attr.atk > 0 then
        _fwAtkLabel:setColor(ui.COLOR_GREEN)
    else
        _fwAtkLabel:setColor(ui.COLOR_GREY)
    end
    _fwPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(rune_attr.physicalDef)))
    if rune_attr.physicalDef > 0 then
        _fwPdefLabel:setColor(ui.COLOR_GREEN)
    else
        _fwPdefLabel:setColor(ui.COLOR_GREY)
    end
    _fwMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(rune_attr.magicDef)))
    if rune_attr.magicDef > 0 then
        _fwMdefLabel:setColor(ui.COLOR_GREEN)
    else
        _fwMdefLabel:setColor(ui.COLOR_GREY)
    end
    _fwHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(rune_attr.hit)))
    if rune_attr.hit > 0 then
        _fwHitLabel:setColor(ui.COLOR_GREEN)
    else
        _fwHitLabel:setColor(ui.COLOR_GREY)
    end
    _fwDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(rune_attr.dodge)))
    if rune_attr.dodge > 0 then
        _fwDodgeLabel:setColor(ui.COLOR_GREEN)
    else
        _fwDodgeLabel:setColor(ui.COLOR_GREY)
    end
    _fwCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(rune_attr.cri)))
    if rune_attr.cri > 0 then
        _fwCriLabel:setColor(ui.COLOR_GREEN)
    else
        _fwCriLabel:setColor(ui.COLOR_GREY)
    end
    _fwDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(rune_attr.ductility)))
    if rune_attr.ductility > 0 then
        _fwDuctilityLabel:setColor(ui.COLOR_GREEN)
    else
        _fwDuctilityLabel:setColor(ui.COLOR_GREY)
    end
    _fwCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(rune_attr.criCoeff)))
    if rune_attr.criCoeff > 0 then
        _fwCri_hurtLabel:setColor(ui.COLOR_GREEN)
    else
        _fwCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _fwCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(rune_attr.criDedCoeff)))
    if rune_attr.criDedCoeff > 0 then
        _fwCri_dedLabel:setColor(ui.COLOR_GREEN)
    else
        _fwCri_dedLabel:setColor(ui.COLOR_GREY)
    end
    _fwBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(rune_attr.block)))
    if rune_attr.block > 0 then
        _fwBlockLabel:setColor(ui.COLOR_GREEN)
    else
        _fwBlockLabel:setColor(ui.COLOR_GREY)
    end
    --风物志
    local travel_attr = self.c_Calculation:TravelAttr()
    _fwzLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(travel_attr.hp)))
    if travel_attr.hp > 0 then
        _fwzLifeLabel:setColor(ui.COLOR_GREEN)
    else
        _fwzLifeLabel:setColor(ui.COLOR_GREY)
    end
    _fwzAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(travel_attr.atk)))
    if travel_attr.atk > 0 then
        _fwzAtkLabel:setColor(ui.COLOR_GREEN)
    else
        _fwzAtkLabel:setColor(ui.COLOR_GREY)
    end
    _fwzPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(travel_attr.physicalDef)))
    if travel_attr.physicalDef > 0 then
        _fwzPdefLabel:setColor(ui.COLOR_GREEN)
    else
        _fwzPdefLabel:setColor(ui.COLOR_GREY)
    end
    _fwzMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(travel_attr.magicDef)))
    if travel_attr.magicDef > 0 then
        _fwzMdefLabel:setColor(ui.COLOR_GREEN)
    else
        _fwzMdefLabel:setColor(ui.COLOR_GREY)
    end
    --公会
    local _legionLevel = self.otherPlayerLineUp.guild_level
    if _legionLevel == nil then _legionLevel = 0 end
    local legion_attr = self.c_Calculation:LegionAttr(_legionLevel)
    _legionLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(legion_attr.hp)))
    if legion_attr.hp > 0 then
        _legionLifeLabel:setColor(ui.COLOR_GREEN)
    else
        _legionLifeLabel:setColor(ui.COLOR_GREY)
    end
    _legionAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(legion_attr.atk)))
    if legion_attr.atk > 0 then
        _legionAtkLabel:setColor(ui.COLOR_GREEN)
    else
        _legionAtkLabel:setColor(ui.COLOR_GREY)
    end
    _legionPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(legion_attr.physicalDef)))
    if legion_attr.physicalDef > 0 then
        _legionPdefLabel:setColor(ui.COLOR_GREEN)
    else
        _legionPdefLabel:setColor(ui.COLOR_GREY)
    end
    _legionMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(legion_attr.magicDef)))
    if legion_attr.magicDef > 0 then
        _legionMdefLabel:setColor(ui.COLOR_GREEN)
    else
        _legionMdefLabel:setColor(ui.COLOR_GREY)
    end
    self.c_Calculation:resetLineUpData()
    self.scrollView:addChild(node)
    self.scrollView:setContentOffset(cc.p(0, self.scrollView:minContainerOffset().y))
end


function PVArenaCheckInfo:keepSingleBitNum(num)
    return math.floor(num * 10) / 10
end


-- 根据座位号获取英雄(排行查看信息相关)
function PVArenaCheckInfo:getSlotItemBySeat(seatIndex)
    local _slot = self.otherPlayerLineUp.slot
    for k, v in pairs(_slot) do
        local seat = v.slot_no
        if seat == seatIndex then
            return v
        end
    end
    return nil
end

--更新武将头像底框
function PVArenaCheckInfo:updateHeroIconLight(idx)
    for k,v in pairs(self.iconMenuTable) do
        if k == idx then
            v:removeAllChildren()
            v:setVisible(true)
            -- local node = UI_Wujiangbuzhenxuanze()
            local node = UI_Wujiangjiemiantouxiang()
            v:addChild(node)
        else
            v:setVisible(false)
            v:removeAllChildren()
        end
    end
end


--返回更新
function PVArenaCheckInfo:onReloadView()
end

function PVArenaCheckInfo:clearResource()
    self.sodierData:clearHeroImagePVR()
    self.sodierData:clearHeroImagePlist()
end

return PVArenaCheckInfo









