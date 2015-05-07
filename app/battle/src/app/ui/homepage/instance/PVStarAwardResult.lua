local PVStarAwardResult = class("PVStarAwardResult", BaseUIView)

function PVStarAwardResult:ctor(id)
    PVStarAwardResult.super.ctor(self, id)
    self.instanceTemp = getTemplateManager():getInstanceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self._resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.lineUpData = getDataManager():getLineupData()
    self.c_EquipTemp = getTemplateManager():getEquipTemplate()
    self.squipTemp = getTemplateManager():getSquipmentTemplate()

    self.stageData = getDataManager():getStageData()
    self.soldierData = getDataManager():getSoldierData()
    self.lineUpData = getDataManager():getLineupData()

    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.commonData = getDataManager():getCommonData()
    self.dropTemp = getTemplateManager():getDropTemplate()
end

function PVStarAwardResult:onMVCEnter()
    -- self:showAttributeView()
    self:initData()
    self:initView()
    self:createTableView()
end

function PVStarAwardResult:initView()
    self.UICommonGetCard = {}
    self:initTouchListener()
    self:loadCCBI("common/ui_common_getcard.ccbi", self.UICommonGetCard)

    self.contentLayer = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]
end

function PVStarAwardResult:initTouchListener()

    local function onCloseClick()
       self:onHideView()
    end

    local function onSureClick()
       self:onHideView()
    end

    self.UICommonGetCard["UICommonGetCard"] = {}

    self.UICommonGetCard["UICommonGetCard"]["onCloseClick"] = onCloseClick
    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick

end

function PVStarAwardResult:registerDataBack()

end

function PVStarAwardResult:initData()
    --self.data = self.funcTable[1]
    local resultData = self.funcTable[1]
    self.itemList = self:createTableData(resultData)
    self.itemListSize = #self.itemList
end

function PVStarAwardResult:createTableData(dropItem)

    local heros = dropItem.heros                --武将
    local equips = dropItem.equipments          --装备
    local items = dropItem.items                --道具
    local h_chips = dropItem.hero_chips         --英雄灵魂石
    local e_chips = dropItem.equipment_chips    --装备碎片
    local finance = dropItem.finance            --finance
    local stamina = dropItem.stamina
    local runt = dropItem.runt                  --符文

    local _itemList = {}  -- 将创建物件需要的数据暂存到_itemList中
    local _index = 1
    --武将
    if heros ~= nil then
        for k,var in pairs(heros) do
            _itemList[_index] = {type = 101, detailId = var.hero_no, nums = 1}
            _index = _index + 1
        end
    end
    --装备
    if equips ~= nil then
        for k,var in pairs(equips) do
            _itemList[_index] = {type = 102, detailId = var.no, nums = 1}
            _index = _index + 1
        end
    end
    --英雄碎片
    if h_chips ~= nil then
        for k,var in pairs(h_chips) do
            _itemList[_index] = {type = 103, detailId = var.hero_chip_no, nums = var.hero_chip_num}
            _index = _index + 1
        end
    end
    --装备碎片
    if e_chips ~= nil then
        for k,var in pairs(e_chips) do
            _itemList[_index] = {type = 104, detailId = var.equipment_chip_no, nums = var.equipment_chip_num}
            _index = _index + 1
        end
    end
    --道具碎片
    if items ~= nil then
        for k,var in pairs(items) do
            _itemList[_index] = {type = 105, detailId = var.item_no, nums = var.item_num}
            _index = _index + 1
        end
    end
    --其他
    if finance ~= nil then
        --更改获取资源数据结构
        local finance_changes = finance.finance_changes
        for k,v in pairs(finance_changes) do
            if v.item_no ~= nil then
                _itemList[_index] = {type = v.item_type, detailId = v.item_no, nums = v.item_num}
                _index = _index + 1
            end
        end
    end
    --符文
    if runt ~= nil then
        for k, v in pairs(runt) do
            _itemList[_index] = {type = 108, detailId = v.runt_id, nums = 1}
            _index = _index + 1
        end
    end
    return _itemList
end

function PVStarAwardResult:createTableView()
    local function tableCellTouched( tbl, cell )
        local index = cell:getIdx()
        local v = self.itemList[index + 1]
        -- if v.type == 101 then -- 武将
        --     getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v.detailId, 2, nil, 1)
        -- elseif v.type == 102 then -- 装备
        --     local equipment = getTemplateManager():getEquipTemplate():getTemplateById(v.detailId)
        --     getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2)
        -- elseif v.type == 103 then -- 武将碎片
        --     local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(v.detailId)
        --     getOtherModule():showOtherView("PVCommonChipDetail", 1, v.detailId, nowPatchNum)
        -- elseif v.type == 104 then -- 装备碎片
        --     local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(v.detailId)
        --     getOtherModule():showOtherView("PVCommonChipDetail", 2, v.detailId, nowPatchNum)
        -- elseif v.type == 105 then  -- 道具
        --     getOtherModule():showOtherView("PVCommonDetail", 1, v.detailId, 1)
        -- elseif v.type == 107 then
        --     getOtherModule():showOtherView("PVCommonDetail", 2, v.detailId, 2)
        -- elseif v.type == 108 then
        --     print("v.type == 108 ========== ", v.detailId)
        --     local runeItem = {}
        --     runeItem.runt_id = v.detailId
        --     runeItem.inRuneType = getTemplateManager():getStoneTemplate():getStoneItemById(v.detailId).type
        --     runeItem.runePos = 0
        --     getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
        -- end
        checkCommonDetail(v.type, v.detailId)
    end
    local function numberOfCellsInTableView(tab)
       return self.itemListSize
    end
    local function cellSizeForTable(tbl, idx)
        return 135,110
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local cardinfo = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, cardinfo)
            cell:addChild(node)
            cell.card = cardinfo["UICommonGetCard"]["img_card"]
            cell.number = cardinfo["UICommonGetCard"]["label_number"]
            cell.number:setLocalZOrder(10)
        end

        local v = self.itemList[idx + 1]
        -- local sprite = game.newSprite()

        -- if v.type < 100 then  -- 可直接读的资源图
        --     _temp = v.type
        --     local _icon = self._resourceTemp:getResourceById(_temp)
        --     setItemImage(cell.card,"res/icon/resource/".._icon,1)
        -- else  -- 需要继续查表
        --     if v.type == 101 then -- 武将
        --         _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
        --         local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
        --         changeNewIconImage(cell.card,_temp,quality)
        --     elseif v.type == 102 then -- equpment
        --         _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
        --         local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
        --         changeEquipIconImageBottom(cell.card, _temp, quality)
        --     elseif v.type == 103 then -- hero chips
        --         _temp = self.chipTemp:getTemplateById(v.detailId).resId
        --         local _icon = self._resourceTemp:getResourceById(_temp)
        --         local _quality = self.chipTemp:getTemplateById(v.detailId).quality
        --         setChipWithFrame(cell.card,"res/icon/hero/".._icon, _quality)
        --     elseif v.type == 104 then -- equipment chips
        --         _temp = self.chipTemp:getTemplateById(v.detailId).resId
        --         local _icon = self._resourceTemp:getResourceById(_temp)
        --         local _quality = self.chipTemp:getTemplateById(v.detailId).quality
        --         setChipWithFrame(cell.card,"res/icon/equipment/".._icon, _quality)
        --     elseif v.type == 105 then  -- item
        --         _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
        --         local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
        --         setCardWithFrame(cell.card,"res/icon/item/".._temp,quality)
        --     elseif v.type == 107 then
        --         local _icon = self._resourceTemp:getResourceById(v.detailId)
        --         setItemImage(cell.card,"res/icon/resource/".._icon,1)
        --     elseif v.type == 108 then
        --         local resId = getTemplateManager():getStoneTemplate():getStoneItemById(v.detailId).res
        --         local resIcon = self._resourceTemp:getResourceById(resId)
        --         local quality = getTemplateManager():getStoneTemplate():getStoneItemById(v.detailId).quality
        --         local icon = "res/icon/rune/" .. resIcon
        --         getDataManager():getRuneData():setItemImage(cell.card, icon, quality)
        --     end
        -- end
        setCommonDrop(v.type, v.detailId, cell.card)
        cell.number:setString("X "..tostring(v.nums))
        -- local oldSprite = cell.number:getParent():getChildByTag(100)
        -- if oldSprite then
        --     cell.number:getParent():removeChildByTag(100)
        -- end
        -- cell.number:getParent():addChild(sprite)
        -- sprite:setTag(100)
        -- sprite:setPosition(55, 55)
        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.contentLayer:removeAllChildren()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.dropTableView:setDelegate()
    self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    if self.itemListSize ~= nil and self.itemListSize < 4 then
        self.dropTableView:setPosition(cc.p( (4 - self.itemListSize) * 105 / 2, 0))
    else
        self.dropTableView:setPosition(scc.p(0, 0))
    end
    self.contentLayer:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.dropTableView:reloadData()
end


return PVStarAwardResult

















