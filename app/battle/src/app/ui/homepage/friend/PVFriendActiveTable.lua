local  PVFriendActiveTable = class("PVFriendActiveTable", BaseUIView)

function PVFriendActiveTable:ctor(id)
    PVFriendActiveTable.super.ctor(self, id)
end

function PVFriendActiveTable:onMVCEnter()

    self.list = self.funcTable[1]

    self.UICommonGetCard = {}
    self.UICommonGetCard["UICommonGetCard"] = {}

    self:initTouchListener()

    self:loadCCBI("common/ui_common_getcard.ccbi", self.UICommonGetCard)

    self:initView()
    self:initData()
    self:createTableView()
end

function PVFriendActiveTable:initTouchListener()
    -- 按键响应函数
    local function onSureClick()
        self:onHideView()
    end

    -- 按键绑定
    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick
end

function PVFriendActiveTable:initView()
    -- 初始化元素
    self.contentLayer = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]
end

function initData()
    self.list = self.funcTable[1]
end

function createTableView()
    -- body
    self.layerSize = self.contentLayer:getContentSize()

    self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW))
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)
end

function PVFriendPanel:numberOfCellsInTableView(table)
    return table.table.nums(self.list)
end

function PVFriendPanel:tableCellTouched(tab, cell)
    local index = cell:getIdx()
end

function PVFriendPanel:cellSizeForTable(table, idx)
    return 125,110
end

function PVFriendPanel:tableCellAtIndex(tbl, idx)

    local function onItemClick()
        -- body
    end

    local cell = tbl:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
        local cardinfo = {}
        cardinfo["UICommonGetCard"] = {}
        local proxy = cc.CCBProxy:create()
        local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, cardinfo)
        cell:addChild(node)
        cell.card = cardinfo["UICommonGetCard"]["img_card"]
        cell.number = cardinfo["UICommonGetCard"]["label_number"]
        cell.number:setLocalZOrder(10)
    end

    local v = self.itemList[idx + 1]
    cell.number:setString("X "..tostring(v.count))
    print("v.countv.countv.count ======= ", v.count)
    -- local sprite = game.newSprite()
    if v.type < 100 then  -- 可直接读的资源图
        _temp = v.type
        local _icon = self._resourceTemp:getResourceById(_temp)
        setItemImage(cell.card, "res/icon/resource/".._icon, 1)
    else  -- 需要继续查表
        if v.type == 101 then -- 武将
            _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
            local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
            changeIconImage(cell.card,_temp,quality)
        elseif v.type == 102 then -- equpment
            _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
            local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
            setEquipCardWithFrame(cell.card, _temp, quality)
        elseif v.type == 103 then -- hero chips
            _temp = self._chipTemp:getTemplateById(v.detailId).resId
            local _icon = self._resourceTemp:getResourceById(_temp)
            local _quality = self._chipTemp:getTemplateById(v.detailId).quality
            setChipWithFrame(cell.card,"res/icon/hero/".._icon, _quality)
        elseif v.type == 104 then -- equipment chips
            _temp = self._chipTemp:getTemplateById(v.detailId).resId
            local _icon = self._resourceTemp:getResourceById(_temp)
            local _quality = self._chipTemp:getTemplateById(v.detailId).quality
            setChipWithFrame(cell.card,"res/icon/equipment/".._icon, _quality)
        elseif v.type == 105 then  -- item
            _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
            local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
            setCardWithFrame(cell.card,"res/icon/item/".._temp,quality)
        elseif v.type == 107 then  -- item
            local _icon = self._resourceTemp:getResourceById(v.detailId)
            setItemImage(cell.card,"res/icon/resource/".._icon,1)
        end
    end

    return cell
end

return PVFriendActiveTable