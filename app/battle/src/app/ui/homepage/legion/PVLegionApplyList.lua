
--军团申请列表

local PVLegionApplyList = class("PVLegionApplyList", BaseUIView)

function PVLegionApplyList:ctor(id)
    PVLegionApplyList.super.ctor(self, id)
end

function PVLegionApplyList:onMVCEnter()
    self.applyList = {}

    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self:registerDataBack()

    self:initView()
end

function PVLegionApplyList:updateView()

end

function PVLegionApplyList:registerDataBack()
    --申请列表返回
    local function getApplyListBack()
        self:initData()
        self:initTableView()
    end
    self:registerMsg(GET_APPLY_LIST, getApplyListBack)

    --全部清空、拒绝、同意 网络返回
    local function getDealBack(data)
        local responsData = self.legionData:getLegionResultData()
        table.nums(responsData)
        self.result = responsData.result
        self.message = responsData.message
        self.apply_ids = responsData.p_ids
        if self.result then
            for k, v in pairs(self.totalSelect) do
                self:removeTableData(k)
            end

            if table.getn(self.apply_ids) > 0 then
                -- local tip = Localize.query("legion.3")
                local tip = ""
                for k,v in pairs(self.apply_ids) do
                    tip = tip .. v
                end
                -- self.labelCommon:initAction(tip)
                -- self:toastShow(tip)
                local tipStr = "玩家" .. tip .. "已经有自己的军团了！"
                getOtherModule():showAlertDialog(nil, tipStr)
            end

            local addNum = table.getn(self.totalSelect) - table.getn(self.apply_ids)
            self.legionData:updateMemberNum(addNum, 1)

            self:loadData()
            self.totalSelect = {}
            self.itemCount = table.nums(self.applyList)
            self.memberNumber:setString(self.itemCount .. " / 50")
            self.tableView:reloadData()

            self:resetTabviewContentOffset(self.tableView)

            local event = cc.EventCustom:new(UPDATE_LEGION_NOTICE)
            self:getEventDispatcher():dispatchEvent(event)
        else
            -- self.labelCommon:initAction(self.message)
            self:toastShow(self.message)
        end
    end
    self:registerMsg(DEALI_JOIN_APPLY, getDealBack)
end



function PVLegionApplyList:initView()
    self.UILegionApplyListView = {}
    self:initTouchListener()
    self:loadCCBI("legion/ui_legion_apply_list.ccbi", self.UILegionApplyListView)

    self.contentLayer = self.UILegionApplyListView["UILegionApplyListView"]["contentLayer"]
    self.memberNumber = self.UILegionApplyListView["UILegionApplyListView"]["memberNumber"]     --军团成员数

end

function PVLegionApplyList:initData()
    self.applyList = self.legionData:getApplyList()
    self.itemCount = table.nums(self.applyList)
    self.totalSelect = {}
    self.tagTable = {}
    self:loadData()

    self.memberNumber:setString(self.itemCount .. " / 50")

    if self.itemCount > 0 then
        for k,v in pairs(self.applyList) do
            self.tagTable[k] = {}
            self.tagTable[k].isSelect = false
        end
    end
end

function PVLegionApplyList:loadData()
    local index = 1
    for k, v in pairs(self.applyList) do
        v.index = index
        index = index + 1
    end
end

function PVLegionApplyList:removeTableData(_index)
    for m, n in pairs(self.applyList) do
        local index = n.index
        if index == _index then
            table.remove(self.applyList, m)
            return
        end
    end
end

function PVLegionApplyList:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --同意
    local function onAgreeClick()
        getAudioManager():playEffectButton2()
        if table.nums(self.totalSelect) > 0 then
            self.legionNet:sendDealApply(self.totalSelect, 1)
        else
            -- self:toastShow("您还没有选择同意的对象")
            -- getOtherModule():showToastView(Localize.query("legion.4"))
            getOtherModule():showAlertDialog(nil, Localize.query("legion.4"))
        end

        for k,v in pairs(self.tagTable) do
            v.isSelect = false
        end
    end

    --拒绝
    local function onRefuseClick()
        getAudioManager():playEffectButton2()
        if table.nums(self.totalSelect) > 0 then
            self.legionNet:sendDealApply(self.totalSelect, 2)
        else
            -- self:toastShow("您还没有选择拒绝的对象")
            -- getOtherModule():showToastView(Localize.query("legion.5"))
            getOtherModule():showAlertDialog(nil, Localize.query("legion.5"))
        end
    end

    --全部清空
    local function onClearAllClick()
        getAudioManager():playEffectButton2()
        for k,v in pairs(self.applyList) do
            table.insert(self.totalSelect, k, v.p_id)
        end
        self.legionNet:sendDealApply(self.totalSelect, 3)
    end

    self.UILegionApplyListView["UILegionApplyListView"] = {}
    self.UILegionApplyListView["UILegionApplyListView"]["backMenuClick"] = onBackClick
    self.UILegionApplyListView["UILegionApplyListView"]["onAgreeClick"] = onAgreeClick
    self.UILegionApplyListView["UILegionApplyListView"]["onRefuseClick"] = onRefuseClick
    self.UILegionApplyListView["UILegionApplyListView"]["onClearAllClick"] = onClearAllClick
end

function PVLegionApplyList:initTableView()
    local layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()

    self:tableViewItemAction(self.tableView)
end

function PVLegionApplyList:scrollViewDidScroll(view)
end

function PVLegionApplyList:scrollViewDidZoom(view)
end

function PVLegionApplyList:tableCellTouched(table, cell)
end

function PVLegionApplyList:cellSizeForTable(table, idx)
    return 80, 560
end

function PVLegionApplyList:tableCellAtIndex(tbl, idx)

    local cell = tbl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()

        --选择按钮
        local function onItemClick()
            local index = cell.index
            local num = table.nums(self.totalSelect)
            local selectSprite = cell.UILegionApplyListItem["UILegionApplyListItem"]["selectSprite"]
            if selectSprite:isVisible() then
                selectSprite:setVisible(false)
                for k,v in pairs(self.totalSelect) do
                    if v == self.applyList[index + 1].p_id then
                        table.remove(self.totalSelect, k)
                    end
                end
                self:changeSelect(index + 1, false)
            else
                selectSprite:setVisible(true)
                table.insert(self.totalSelect, num + 1, self.applyList[index + 1].p_id)
                self:changeSelect(index + 1, true)
            end
        end

        cell.UILegionApplyListItem = {}
        cell.UILegionApplyListItem["UILegionApplyListItem"] = {}
        --local selectSprite = cell.UILegionApplyListItem["UILegionApplyListItem"]["selectSprite"]

        cell.UILegionApplyListItem["UILegionApplyListItem"]["onItemClick"] = onItemClick

        local applyListProxy = cc.CCBProxy:create()
        local applyListItem = CCBReaderLoad("legion/ui_legion_apply_list_item.ccbi", applyListProxy, cell.UILegionApplyListItem)

        cell:addChild(applyListItem)
    end

    cell.index = idx

    if table.nums(self.applyList) > 0 then
        local strValue = string.format("%d", self.applyList[idx+1].p_id)

        local playerName = cell.UILegionApplyListItem["UILegionApplyListItem"]["playerName"]        --玩家名称
        local levelBMFnt = cell.UILegionApplyListItem["UILegionApplyListItem"]["levelBMFnt"]      --玩家等级
        local powerValue = cell.UILegionApplyListItem["UILegionApplyListItem"]["powerValue"]        --玩家战斗力
        --cell.selectSprite = cell.UILegionApplyListItem["UILegionApplyListItem"]["selectSprite"]    --选择图片
        local selectSprite = cell.UILegionApplyListItem["UILegionApplyListItem"]["selectSprite"]    --选择图片

        playerName:setString(self.applyList[idx+1].name)
        levelBMFnt:setString("Lv." .. self.applyList[idx+1].level)
        powerValue:setString(self.applyList[idx+1].fight_power)

        local isSelect = self:getSelectByIndex(idx + 1)
        if isSelect then
            selectSprite:setVisible(true)
        else
            selectSprite:setVisible(false)
        end
    end

    return cell
end

function PVLegionApplyList:numberOfCellsInTableView(table)
   return self.itemCount
end

function PVLegionApplyList:changeSelect(index , changeSelect)
    self.tagTable[index].isSelect = changeSelect
end

function PVLegionApplyList:getSelectByIndex(index)
    local result = self.tagTable[index].isSelect
    return result
end

return PVLegionApplyList
