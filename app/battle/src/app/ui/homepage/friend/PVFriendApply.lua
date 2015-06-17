
local PVFriendApply = class("PVFriendApply", BaseUIView)

function PVFriendApply:ctor(id)
    PVFriendApply.super.ctor(self, id)
end

function PVFriendApply:onMVCEnter()
    self.UIFriendApplyView = {}

    self:initTouchListener()

    self:loadCCBI("friend/ui_friend_apply.ccbi", self.UIFriendApplyView)

    self:initView()
    self:initTableView()
    self:onUIHide()
end

function PVFriendApply:initView()
    self.contentLayer = self.UIFriendApplyView["UIFriendApplyView"]["contentLayer"]

    self.generalItems = {}
    for i =1, 10 do
        self.generalItems[i] = {}
        self.generalItems[i].isSelect = false
        self.generalItems[i].id = i
    end

    self.itemCount = table.nums(self.generalItems)

    self.totalSelect = {}

    self.curIndex = 1
end

function PVFriendApply:initTouchListener()
    --全部同意
    local function onAllAgreeClick()
        cclog("onAllAgreeClick")
    end

    --全部忽略
    local function onAllIgnoreClick()
        cclog("onAllIgnoreClick")
    end

    self.UIFriendApplyView["UIFriendApplyView"] = {}

    self.UIFriendApplyView["UIFriendApplyView"]["onAllAgreeClick"] = onAllAgreeClick
    self.UIFriendApplyView["UIFriendApplyView"]["onAllIgnoreClick"] = onAllIgnoreClick
end

function PVFriendApply:initTableView()
    self.tableView = cc.TableView:create(cc.size(540, 490))

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

    -- local scrBar = PVScrollBar:new()
    -- scrBar:init(self.tableView,1)
    -- local layerSize = self.contentLayer:getContentSize()
    -- scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    -- self.contentLayer:addChild(scrBar,2)
    
    self.tableView:reloadData()
end

function PVFriendApply:scrollViewDidScroll(view)
end

function PVFriendApply:scrollViewDidZoom(view)
end

function PVFriendApply:tableCellTouched(table, cell)
end

function PVFriendApply:cellSizeForTable(table, idx)
    return 160, 519
end

function PVFriendApply:tableCellAtIndex(tbl, idx)
    cell = tbl:dequeueCell()

    if nil == cell then
            cell = cc.TableViewCell:new()

            local function onItemClick()
                cclog("onItemClick")
            end

            local function onIgnoreClick()
                cclog("onIgnoreClick")
                local index = cell:getIdx()
            end

            local function onAgreeClick()
                cclog("onAgreeClick")
                local index = cell:getIdx()
            end

            cell.UIApplyItem = {}
            cell.UIApplyItem["UIApplyItem"] = {}
            cell.UIApplyItem["UIApplyItem"]["onItemClick"] = onItemClick
            cell.UIApplyItem["UIApplyItem"]["onIgnoreClick"] = onIgnoreClick
            cell.UIApplyItem["UIApplyItem"]["onAgreeClick"] = onAgreeClick

            local proxy = cc.CCBProxy:create()
            local applyItem = CCBReaderLoad("friend/ui_friend_apply_item.ccbi", proxy, cell.UIApplyItem)

            cell:addChild(applyItem)
        end

        if table.nums(self.generalItems) > 0 then
            local strValue = string.format("%d", self.generalItems[idx + 1].id)

            local detailLabel1 = cell.UIApplyItem["UIApplyItem"]["detailLabel1"] --好友名称

            detailLabel1:setString(strValue)

            local index = cell:getIdx()
        end
    return cell
end

function PVFriendApply:numberOfCellsInTableView(table)
   return self.itemCount
end

function PVFriendApply:onShowLegionApplyView()
    self:setVisible(true)
    self.tableView:reloadData()
end

function PVFriendApply:onHideLegionApplyView()
    self:setVisible(false)
end

function PVFriendApply:onHomePageHide()
    self:onHideLegionApplyView()
end

return PVFriendApply
