local PVStarAwardShow = class("PVStarAwardShow", BaseUIView)

function PVStarAwardShow:ctor(id)
    PVStarAwardShow.super.ctor(self, id)
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

function PVStarAwardShow:onMVCEnter()
    -- self:showAttributeView()
    self:initData()
    self:initView()
    self:createTableView()
end

function PVStarAwardShow:initView()
    self.StarShow = {}
    self:initTouchListener()
    self:loadCCBI("instance/ui_prize_jl_item.ccbi", self.StarShow)
    print("PVStarAwardShow:initView")
    table.print(self.StarShow)
    print("PVStarAwardShow:initView")
    self.conLayer = self.StarShow["StarShow"]["conLayer"]
end

function PVStarAwardShow:initTouchListener()

    local function onCloseClick()
        stepCallBack(G_GUIDE_40113)

        --groupCallBack(GuideGroupKey.BTN_CLOSE_BAOXIANG_TIP_WINDOW)

        self:onHideView()
    end

    self.StarShow["StarShow"] = {}

    self.StarShow["StarShow"]["onCloseClick"] = onCloseClick

end

function PVStarAwardShow:registerDataBack()

end

function PVStarAwardShow:initData()
    --self.data = self.funcTable[1]
    self.chapperId = self.funcTable[1]
    local awardIndex = self.funcTable[2]

    local chapterItem = self.stageTemp:getChapterItemByChapterNo(self.chapperId)
    local starGift = chapterItem.starGift
    local giftItem = starGift[awardIndex]
    local bagBagItem = self.dropTemp:getBigBagById(giftItem)
    local smallBagIdList = bagBagItem.smallPacketId
    self.itemList = {}
    for k, smallDropId in pairs(smallBagIdList) do

        local smallBagItemList = self.dropTemp:getAllItemsByDropId(smallDropId)
        for m, n in pairs(smallBagItemList) do
            self.itemList[#self.itemList + 1] = n
        end
    end
    self.itemListSize = #self.itemList
    print("tableCellAtIndex=======")
    table.print(self.itemList)
    print("tableCellAtIndex=======")

end

function PVStarAwardShow:createTableView()
    local function tableCellTouched( tbl, cell )
        local index = cell:getIdx()
        local v = self.itemList[index + 1]
        if v.type == 101 then -- 武将
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v.detailId, 2, nil, 1)
        elseif v.type == 102 then -- 装备
            local equipment = getTemplateManager():getEquipTemplate():getTemplateById(v.detailId)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2)
        elseif v.type == 103 then -- 武将碎片
            local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(v.detailId)
            getOtherModule():showOtherView("PVCommonChipDetail", 1, v.detailId, nowPatchNum)
        elseif v.type == 104 then -- 装备碎片
            local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(v.detailId)
            getOtherModule():showOtherView("PVCommonChipDetail", 2, v.detailId, nowPatchNum)
        elseif v.type == 105 then  -- 道具
            getOtherModule():showOtherView("PVCommonDetail", 1, v.detailId, 1)
        elseif v.type == 107 then
            getOtherModule():showOtherView("PVCommonDetail", 2, v.detailId, 2)
        elseif v.type == 108 then
            local runeItem = {}
            runeItem.runt_id = v.detailId
            runeItem.inRuneType = getTemplateManager():getStoneTemplate():getStoneItemById(v.detailId).type
            runeItem.runePos = 0
            getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
        end
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
            -- cell.card:setVisible(false)
            cell.number = cardinfo["UICommonGetCard"]["label_number"]
            cell.number:setLocalZOrder(10)
        end

        local v = self.itemList[idx + 1]
        cell.number:setString("X "..tostring(v.count))
        print("v.countv.countv.count ======= ")
        table.print(v)
        -- local sprite = game.newSprite()
        if v.type < 100 then  -- 可直接读的资源图
            _temp = v.type
            local _icon = self._resourceTemp:getResourceById(_temp)
            setItemImage(cell.card,"#".._icon,1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
                changeNewIconImage(cell.card,_temp,quality)
            elseif v.type == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
                local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
                changeEquipIconImageBottom(cell.card, _temp, quality)
            elseif v.type == 103 then -- hero chips
                _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(cell.card,"res/icon/hero/".._icon, _quality)
            elseif v.type == 104 then -- equipment chips
                _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(cell.card,"res/icon/equipment/".._icon, _quality)
            elseif v.type == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
                setCardWithFrame(cell.card,"res/icon/item/".._temp,quality)
            elseif v.type == 107 then  -- 资源 元气...
                local _icon = self._resourceTemp:getResourceById(v.detailId)
                setItemImage(cell.card,"res/icon/resource/".._icon,1)
            elseif v.type == 108 then  -- 符文
                -- local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.detailId)
                -- setItemImage(cell.card, _respng, _quality)
                local resId = getTemplateManager():getStoneTemplate():getStoneItemById(v.detailId).res
                local resIcon = self._resourceTemp:getResourceById(resId)
                local quality = getTemplateManager():getStoneTemplate():getStoneItemById(v.detailId).quality
                local icon = "res/icon/rune/" .. resIcon
                getDataManager():getRuneData():setItemImage(cell.card, icon, quality)
            end
        end
        -- sprite:setLocalZOrder(1)
        -- cell:addChild(sprite)
        -- sprite:setPosition(55, 55)
        return cell
    end

    local layerSize = self.conLayer:getContentSize()
    self.conLayer:removeAllChildren()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.dropTableView:setDelegate()
    if self.itemListSize < 3 then
        self.dropTableView:setPosition(cc.p(125 / self.itemListSize, 0))
    else
        self.dropTableView:setPosition(cc.p(15, 0))
    end
    -- self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.conLayer:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.dropTableView:reloadData()
end


return PVStarAwardShow

















