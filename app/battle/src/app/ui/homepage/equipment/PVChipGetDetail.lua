-- 查看碎片获得途径
-- 所接受的数据为to_get_config中的一条数据

local PVChipGetDetail = class("PVChipGetDetail", BaseUIView)

function PVChipGetDetail:ctor(id)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_navi.plist")
    PVChipGetDetail.super.ctor(self, id)
end

function PVChipGetDetail:init()
    g_Click = false

    -- 解析出数据
    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.stageData = getDataManager():getStageData()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.c_EquipData = getDataManager():getEquipmentData()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_EquipTemplate = getTemplateManager():getEquipTemplate()
    self.c_BagTemplate = getTemplateManager():getBagTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.bagData = getDataManager():getBagData()


    self.data = self.funcTable[1]
    self.itemId = self.funcTable[2]
    self.typeId = self.funcTable[3]            -- 1、武将 2、武将碎片 3、装备 4、装备碎片 nil、道具
    print("--------self.data---------")
    table.print(self.data)

    self.listData = {}
    local index = 1
    for k,v in pairs(self.data.stage) do
        if v / 100000 <= 5 and v / 100000 >= 1 then
            local chapterIdx, stageIdx = self.stageTemp:getIndexofStage(v)
            local _simpleId = self.stageTemp:getSimpleStage(chapterIdx, stageIdx)
            local _stageData = self.stageTemp:getTemplateById(_simpleId)
            local _name = self.languageTemp:getLanguageById(_stageData.name)
            local _str = Localize.query("chipget.1").."\n".._stageData.chapter.."-".. _stageData.section .._name
            local str = string.format(_str, chapterIdx)
            self.listData[index] = {type=1, name=str, stageId=_simpleId}
            index = index + 1
        end
    end
    if self.data.coinHero == 1 then
        self.listData[index] = {type=2, name=Localize.query("chipget.2")}
        index = index + 1
    end
    if self.data.moneyHero == 1 then
        self.listData[index] = {type=3, name=Localize.query("chipget.3")}
        index = index + 1
    end
    if self.data.moneyEqu == 1 or self.data.coinEqu == 1 then

        self.listData[index] = {type=4, name=Localize.query("chipget.11")}
        index = index + 1
    end
    -- if self.data.moneyEqu == 1 then
    --     self.listData[index] = {type=5, name=Localize.query("chipget.5")}
    --     index = index + 1
    -- end
    if self.data.soulShop == 1 then
        self.listData[index] = {type=6, name=Localize.query("chipget.6")}
        index = index + 1
    end
    if self.data.arenaShop == 1 then
        self.listData[index] = {type=7, name=Localize.query("chipget.7")}
        index = index + 1
    end
    if self.data.stageBreak == 1 then
        self.listData[index] = {type=8, name=Localize.query("chipget.8")}
        index = index + 1
    end

    if self.data.itemShop == 1 then
        self.listData[index] = {type=9, name=Localize.query("chipget.12")}
        index = index + 1
    end

    if self.data.equipShop == 1 then
        self.listData[index] = {type=10, name=Localize.query("chipget.13")}
        index = index + 1
    end

    if self.data.isStage == 1 then
        self.listData[index] = {type=11, name=Localize.query("chipget.14")}
        index = index + 1
    end

    if self.data.isEliteStage == 1 then
        self.listData[index] = {type=12, name=Localize.query("chipget.15")}
        index = index + 1
    end

    if self.data.isActiveStage == 1 then
        self.listData[index] = {type=13, name=Localize.query("chipget.16")}
        index = index + 1
    end

    self.number = index - 1

    if self.number == 0 then
        local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
        -- getOtherModule():showToastView(tipText)
        getOtherModule():showAlertDialog(nil, tipText)

    end

    -- print("   ^^^^^^^^^^^  self.listData  ^^^^^^^^^^^")
    -- table.print(self.listData)
    -- print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

end

function PVChipGetDetail:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
    game.addSpriteFramesWithFile("res/stage/stage_map.plist")
    self:init()
    self:initTouchListener()
    self:loadCCBI("common/ui_chip_get.ccbi", self.ccbiNode)
    self:initView()
end

function PVChipGetDetail:initTouchListener()
    local function onCloseMenu()
        getAudioManager():playEffectButton2()
        _data = nil
        self:onHideView(80)
    end
    self.ccbiNode = {}
    self.ccbiNode["UIGetRootView"] = {}
    self.ccbiNode["UIGetRootView"]["onCloseClick"] = onCloseMenu
end

-- 获取控件与设置属性
function PVChipGetDetail:initView()
	self.ccbiRootNode = self.ccbiNode["UIGetRootView"]
	self.detailLayer = self.ccbiRootNode["detailLayer"]
    self.uiIcon = self.ccbiRootNode["uiIcon"]
    self.nameLabel = self.ccbiRootNode["nameLabel"]
    self.numLabel = self.ccbiRootNode["numLabel"]

    local _id = self.itemId
    if self.typeId == 1 then      -- 武将
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(_id)
        local nameStr = soldierTemplateItem.nameStr
        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local quality = soldierTemplateItem.quality
        local resIcon = self.c_SoldierTemplate:getSoldierIcon(_id)
        changeNewIconImage(self.uiIcon, resIcon, quality) --更新icon
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        self.nameLabel:setString(name)
        self.nameLabel:setColor(color)
        local _nums = self.c_SoldierData:getSoldierNumById(_id)
        self.numLabel:setString(tostring(_nums))
    elseif self.typeId == 2 then  -- 武将碎片
        local soldierTemplateItem = self.c_SoldierTemplate:getChipTempLateById(_id)
        local combineResult = soldierTemplateItem.combineResult
        local nameStr = soldierTemplateItem.language
        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local quality = soldierTemplateItem.quality
        local resIcon = self.c_SoldierTemplate:getSoldierIcon(combineResult)
        changeHeroChipIcon(self.uiIcon, resIcon, quality) --更新icon
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        self.nameLabel:setString(name)
        self.nameLabel:setColor(color)
        local _nums = self.c_SoldierData:getPatchNumById(_id)
        self.numLabel:setString(tostring(_nums).."/"..tostring(soldierTemplateItem.needNum))
    elseif self.typeId == 3 then  -- 装备
        local equipTemplateItem = self.c_EquipTemplate:getTemplateById(_id)
        local nameStr = equipTemplateItem.name
        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local quality = equipTemplateItem.quality
        local resIcon = self.c_EquipTemplate:getEquipResIcon(_id)
        changeEquipIconImageBottom(self.uiIcon, resIcon, quality)  -- 设置卡的图片
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        self.nameLabel:setString(name)
        self.nameLabel:setColor(color)
        local _nums = self.c_EquipData:getEquipNumById(_id)
        self.numLabel:setString(tostring(_nums))

    elseif self.typeId == 4 then  -- 装备碎片
        local equipTemplateItem = self.chipTemp:getTemplateById(_id)
        local nameStr = equipTemplateItem.language
        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local quality = equipTemplateItem.quality
        local resIcon = self.resourceTemp:getResourceById(equipTemplateItem.resId)
        changeEquipChipIconImageBottom(self.uiIcon, resIcon, quality)  -- 设置卡的图片
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        self.nameLabel:setString(name)
        self.nameLabel:setColor(color)
        local _nums = self.c_EquipData:getPatchNumById(_id)
        self.numLabel:setString(tostring(_nums).."/"..tostring(equipTemplateItem.needNum))

    else                          -- 道具
        local bagTempItem = self.c_BagTemplate:getItemById(_id)
        local quality = self.c_BagTemplate:getItemQualityById(_id)
        local resIcon = self.c_BagTemplate:getItemResIcon(_id)
        local name = self.c_LanguageTemplate:getLanguageById(bagTempItem.name)
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        self.nameLabel:setString(name)
        self.nameLabel:setColor(color)
        setItemImage3(self.uiIcon, resIcon, quality)
        local _nums = self.bagData:getItemNumById(_id)
        self.numLabel:setString(tostring(_nums))
    end

	self:createTableView()
end

g_Click = false

function PVChipGetDetail:createTableView()
    -- print("------- createTableView --------")
    -- print("q#######################q")
	local function tableCellTouched(tbl, cell)
        print("smelting list touch ", cell:getIdx())

        getAudioManager():playEffectButton2()
    end
    local function numberOfCellsInTableView(tab)
        return self.number
    end
    local function cellSizeForTable(tbl, idx)
        return 105, 640
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function gotoViewClick()
                local _item = self.listData[idx+1]
                local _type = _item.type
                print("type ============ ", _type)
                if _type == 1 then
                    local stageData = getDataManager():getStageData()
                    local _stageId = _item.stageId

                    local _isUnlock = stageData:getStageIsLock(_stageId) -- 策划说不同难度的关卡掉落的东西一样
                    if _isUnlock == false then -- 未锁
                        g_stage_id = _stageId
                        print("=====g_Click=============")
                        print(g_Click)
                        if g_Click == false then
                            local __refreshCurrent = function()
                                timer.unscheduleGlobal(__refreshCurrentView1)
                                __refreshCurrentView1 = nil
                               g_Click = true
                               self:onHideView(1)
                                getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", g_stage_id, 1)
                            end
                            __refreshCurrentView1 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                        end
                    else
                        -- getOtherModule():showToastView( Localize.query("chipget.9") )
                        getOtherModule():showAlertDialog(nil, Localize.query("chipget.9"))
                    end   --剧情第几章
                elseif _type == 2 then -- 良将招募
                    local shopTemplate = getTemplateManager():getShopTemplate()
                    local _commonData = getDataManager():getCommonData()
                    self._heroUseMoney = shopTemplate:getHeroUseMoney()
                    -- 良将周期免费
                    self.preHeroTime = _commonData:getFineHero()
                    self.currTime = os.time()
                    self.heroFreePeriod = shopTemplate:getHeroFreePeriod() * 3600 -- 免费周期（sec）
                    self.diffTime1 = os.difftime(self.currTime, self.preHeroTime)


                    if self.diffTime1 > self.heroFreePeriod then
                        self._heroUseMoney = 0
                    end


                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView2)
                        __refreshCurrentView2 = nil
                        _heroUseMoney1 = self._heroUseMoney
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()

                        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuy", _heroUseMoney1)
                    end
                    __refreshCurrentView2 = timer.scheduleGlobal(__refreshCurrent, 0.1)

                    -- getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuy", self._heroUseMoney)
                elseif _type == 3 then -- 神将招募
                    local shopTemplate = getTemplateManager():getShopTemplate()
                    local _commonData = getDataManager():getCommonData()
                    self._godHeroUseMoney = shopTemplate:getGodHeroUseMoney()

                    self.preGodHeroTime = _commonData:getExcellentHero()
                    self.godHeroFreePeriod = shopTemplate:getGodHeroFreePeriod() * 3600
                    self.currTime = os.time()
                    self.diffTime2 = os.difftime(self.currTime, self.preGodHeroTime)

                    if self.diffTime2 > self.godHeroFreePeriod then
                        self._godHeroUseMoney = 0
                    end

                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView3)
                        __refreshCurrentView3 = nil
                        _godHeroUseMoney1 = self._godHeroUseMoney
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()

                        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuyGod", _godHeroUseMoney1)
                    end
                    __refreshCurrentView3 = timer.scheduleGlobal(__refreshCurrent, 0.1)


                    -- getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopRecruitBuyGod", self._godHeroUseMoney)
                elseif _type == 4 then -- 良装抽取
                    SHOP_EQUIP_TYPE = 11
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView4)
                        __refreshCurrentView4 = nil
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()       --多添加两个是为了解决出现卡死bug
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()

                        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopPage", 2)
                        -- getModule(MODULE_NAME_SHOP):showUIView("PVShopPage", 2)
                    end
                    __refreshCurrentView4 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                    -- getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopPage", 2)
                elseif _type == 5 then -- 神装抽取
                    SHOP_EQUIP_TYPE = 12
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView5)
                        __refreshCurrentView5 = nil
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopPage", 2)
                        -- getModule(MODULE_NAME_SHOP):showUIView("PVShopPage", 2)
                    end
                    __refreshCurrentView5 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                    -- getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopPage", 2)
                elseif _type == 6 then -- 武魂商店
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView6)
                        __refreshCurrentView6 = nil
                        -- getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSecretShop")
                        --武魂商店关卡
                        local _stageId = getTemplateManager():getBaseTemplate():getHeroSacrificeOpenStage()
                        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
                        if _isOpen then
                            getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretShop")
                            -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSmeltView")
                        else
                            getStageTips(_stageId)
                            return
                        end

                        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretShop")
                    end
                    __refreshCurrentView6 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                    -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSecretShop")
                elseif _type == 7 then      --竞技场商店
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView7)
                        __refreshCurrentView7 = nil
                        -- local lv = getDataManager():getCommonData():getLevel()
                        -- local startLv = getTemplateManager():getBaseTemplate():getArenaLevel()
                        -- if lv >= startLv then
                        --     getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        --     getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVArenaPanel",3)
                        -- else
                        --     getOtherModule():showAlertDialog(nil, Localize.query("chipget.10"))
                        -- end

                        local _stageId = getTemplateManager():getBaseTemplate():getArenaOpenStage()
                        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
                        if _isOpen then
                            getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVArenaPanel",3)
                        else
                            -- getStageTips(_stageId)
                            getOtherModule():showAlertDialog(nil, Localize.query("chipget.10"))
                            return
                        end

                    end
                    __refreshCurrentView7 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                    -- getOtherModule():showToastView( Localize.query("chipget.10") )
                elseif _type == 8 then      --武将乱入
                    -- getOtherModule():showToastView( Localize.query("chipget.8") )
                    -- getOtherModule():showAlertDialog(nil, Localize.query("chipget.8"))
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView5)
                        __refreshCurrentView5 = nil
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVChapters", nil, 1)
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", nil, 1)
                    end
                    __refreshCurrentView5 = timer.scheduleGlobal(__refreshCurrent, 0.1)

                elseif _type == 9 then      --商城道具商店
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView5)
                        __refreshCurrentView5 = nil
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopPage", 3)
                        -- getModule(MODULE_NAME_SHOP):showUIView("PVShopPage", 3)
                    end
                    __refreshCurrentView5 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                elseif _type == 10 then     --熔炼商店
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView5)
                        __refreshCurrentView5 = nil
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipShop")
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipShop")
                    end
                    __refreshCurrentView5 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                elseif _type == 11 then     --剧情关卡
                    if cell.isOpen == false then
                        return
                    end
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView5)
                        __refreshCurrentView5 = nil
                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVChapters", nil, 1)
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", nil, 1)
                    end
                    __refreshCurrentView5 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                elseif _type == 12 then     --精英副本
                    if cell.isOpen == false then
                        getOtherModule():showAlertDialog(nil, Localize.query("chipget.9"))
                        return
                    end
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView5)
                        __refreshCurrentView5 = nil
                        local _stageId = getTemplateManager():getBaseTemplate():getSpecialStageOpenStage()
                        local _isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
                        if not _isOpen then
                            getStageTips(_stageId)
                            return
                        end

                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", nil, 2)
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVChapters", nil, 2)
                    end
                    __refreshCurrentView5 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                elseif _type == 13 then     --活动关卡
                    if cell.isOpen == false then
                        return
                    end
                    local __refreshCurrent = function()
                        timer.unscheduleGlobal(__refreshCurrentView5)
                        __refreshCurrentView5 = nil
                        local _stageId = getTemplateManager():getBaseTemplate():getActivityStageOpenStage()
                        local _isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
                        if not _isOpen then  
                            getStageTips(_stageId)
                            return
                        end

                        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
                        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", nil, 3)
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVChapters", nil, 3)
                    end
                    __refreshCurrentView5 = timer.scheduleGlobal(__refreshCurrent, 0.1)
                end
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIGetDetail"] = {}
            cell.cardinfo["UIGetDetail"]["gotoViewClick"] = gotoViewClick
            cell.cardinfo["UIGetDetail"]["gotoViewClick1"] = gotoViewClick
            local node = CCBReaderLoad("common/ui_chip_get_item.ccbi", proxy, cell.cardinfo)
            cell:addChild(node)

            cell.labelDetail = cell.cardinfo["UIGetDetail"]["label_detail"]
            cell.labelTimes = cell.cardinfo["UIGetDetail"]["label_times"]
            cell.noOpenLabel = cell.cardinfo["UIGetDetail"]["noOpenLabel"]
            cell.noOpenLabel:setVisible(false)
            cell.imgGrey = cell.cardinfo["UIGetDetail"]["bg_grey"]
            cell.imgLight = cell.cardinfo["UIGetDetail"]["bg_light"]
            cell.tubiaoNode = cell.cardinfo["UIGetDetail"]["tubiaoNode"]
            cell.img_frame_locked = cell.cardinfo["UIGetDetail"]["img_frame_locked"] -- 框
            cell.img_frame = cell.cardinfo["UIGetDetail"]["img_frame"]               -- 图
            cell.gotoViewBtn = cell.cardinfo["UIGetDetail"]["gotoViewBtn"]           
            cell.unOpenViewBtn = cell.cardinfo["UIGetDetail"]["unOpenViewBtn"] 

        end

        -- 更新控件的数据

        local _itemData = self.listData[idx+1]
        cell.isOpen = true

        if _itemData.type == 1 then -- stage 类

            cell.noOpenLabel:setVisible(false)
            cell.noOpenLabel:setString("未开启")

            local _stageId = _itemData.stageId
            cell.labelDetail:setString(_itemData.name)

            local _stageTempItem = self.stageTemp:getTemplateById(_stageId)
            local _iconFrame = getTemplateManager():getResourceTemplate():getResourceById(_stageTempItem.icon)
            -- print("_iconFrame =================== ", _iconFrame)
            local _icon = getTemplateManager():getResourceTemplate():getResourceById(_stageTempItem.iconHero)
            -- local _iconFrame = string.gsub(_iconFrame, ".png", "_mask.png")
            local _icon = string.gsub(_icon, ".png", ".webp")
            -- local _iconFrame = string.gsub(_iconFrame, ".png", ".webp")

            -- print("_iconFrame _iconFrame  =================== ", _iconFrame)
            game.setSpriteFrame(cell.img_frame, _icon)
            game.setSpriteFrame(cell.img_frame_locked, "#".._iconFrame)
            cell.img_frame_locked:setVisible(true)
            local _maxFightNum = _stageTempItem.limitTimes
            local _currFightNum = self.stageData:getStageFightNum(_stageId)

            if _maxFightNum ~= 0 then
                cell.labelTimes:setString(string.format("%d/%d", _currFightNum, _maxFightNum))
            else
                cell.labelTimes:setString(string.format("%d", _currFightNum))
            end

            local _isUnlock = self.stageData:getStageIsLock(_stageId) -- 策划说不同难度的关卡掉落的东西一样
            if _isUnlock == true then
                local _iconFrame = string.gsub(_iconFrame, ".png", "_mask.png")
                game.setSpriteFrame(cell.img_frame_locked, "#".._iconFrame)
                -- cell.imgGrey:setVisible(true)
                -- cell.imgLight:setVisible(false)
                cell.labelTimes:setColor(ui.COLOR_GREY)
                cell.labelDetail:setColor(ui.COLOR_GREY)
                cell.noOpenLabel:setVisible(false)
                cell.labelTimes:setVisible(false)
                cell.unOpenViewBtn:setVisible(true)
                cell.gotoViewBtn:setVisible(false)
            else
                cell.noOpenLabel:setVisible(false)
                cell.labelTimes:setVisible(true)
                cell.unOpenViewBtn:setVisible(false)
                cell.gotoViewBtn:setVisible(true)

                -- cell.imgGrey:setVisible(false)
                -- cell.imgLight:setVisible(true)
                cell.labelTimes:setColor(ui.COLOR_GREEN)
                cell.labelDetail:setColor(ui.COLOR_GREEN)
            end

        elseif _itemData.type == 2 then -- 良将招募
            print("-------- _itemData.type == 2 -------")
            game.setSpriteFrame(cell.img_frame, "#ui_navi_shop1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 3 then -- 神将招募
            game.setSpriteFrame(cell.img_frame, "#ui_navi_shop1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 4 then -- 良装抽取
            game.setSpriteFrame(cell.img_frame, "#ui_navi_shop1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 5 then -- 神装抽取
            game.setSpriteFrame(cell.img_frame, "#ui_navi_shop1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 6 then -- 武魂商店
            game.setSpriteFrame(cell.img_frame, "#ui_navi2_lvu1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 7 then      --竞技场商店
            game.setSpriteFrame(cell.img_frame, "#ui_navi_shop1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 8 then      --武将乱入
            game.setSpriteFrame(cell.img_frame, "#ui_navi2_sa1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 9 then      --商城道具商店
            game.setSpriteFrame(cell.img_frame, "#ui_navi_shop1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 10 then     --熔炼商店
            game.setSpriteFrame(cell.img_frame, "#ui_navi2_lvu1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)

        elseif _itemData.type == 11 then     --剧情关卡
            game.setSpriteFrame(cell.img_frame, "#ui_navi2_sa1.png")
            cell.img_frame_locked:setVisible(false)

            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)


        elseif _itemData.type == 12 then

            game.setSpriteFrame(cell.img_frame, "#ui_navi2_sa1.png")
            cell.img_frame_locked:setVisible(false)

            local lv = getDataManager():getCommonData():getLevel()
            local starLv = getTemplateManager():getBaseTemplate():getFBStageStartLv()
            if lv > starLv then
                -- cell.imgGrey:setVisible(false)
                -- cell.imgLight:setVisible(true)
                cell.labelTimes:setString("")
                cell.noOpenLabel:setString("")
                cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            else

                cell.isOpen = false

                -- cell.imgGrey:setVisible(true)
                -- cell.imgLight:setVisible(false)
                -- cell.labelTimes:setString(starLv .. "级开启")
                cell.noOpenLabel:setVisible(false)
                cell.labelTimes:setVisible(false)
                cell.unOpenViewBtn:setVisible(true)
                cell.gotoViewBtn:setVisible(false)

                cell.labelTimes:setColor(ui.COLOR_RED)
            end
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)


        elseif _itemData.type == 13 then

            game.setSpriteFrame(cell.img_frame, "#ui_navi2_sa1.png")
            cell.img_frame_locked:setVisible(false)

            local lv = getDataManager():getCommonData():getLevel()
            local starLv = getTemplateManager():getBaseTemplate():getHDStageStartLv()
            if lv > starLv then
                -- cell.imgGrey:setVisible(false)
                -- cell.imgLight:setVisible(true)
                cell.labelTimes:setString("")
                cell.noOpenLabel:setString("")
                cell.unOpenViewBtn:setVisible(false)
                cell.gotoViewBtn:setVisible(true)
            else
                cell.isOpen = false

                -- cell.imgGrey:setVisible(true)
                -- cell.imgLight:setVisible(false)

                cell.noOpenLabel:setVisible(false)
                cell.labelTimes:setVisible(false)
                cell.unOpenViewBtn:setVisible(true)
                cell.gotoViewBtn:setVisible(false)

                -- cell.labelTimes:setString(starLv .. "级开启")
                cell.labelTimes:setColor(ui.COLOR_RED)
            end
            cell.labelDetail:setString(_itemData.name)
            cell.labelDetail:setColor(ui.COLOR_WHITE)
        else
            -- cell.imgGrey:setVisible(false)
            -- cell.imgLight:setVisible(true)
            cell.labelTimes:setString("")
            cell.noOpenLabel:setString("")
            cell.unOpenViewBtn:setVisible(false)
            cell.gotoViewBtn:setVisible(true)
            cell.labelDetail:setString(_itemData.name)
        end

        return cell
    end

    local layerSize = self.detailLayer:getContentSize()
    self.tableView = cc.TableView:create(layerSize)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.detailLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.detailLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVChipGetDetail:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
    -- game.removeSpriteFramesWithFile("res/stage/stage_map.plist")
end

return PVChipGetDetail

