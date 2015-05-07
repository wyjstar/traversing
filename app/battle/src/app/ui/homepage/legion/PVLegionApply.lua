--军团申请

local PVLegionApply = class("PVLegionApply", BaseUIView)

function PVLegionApply:ctor(id)
    PVLegionApply.super.ctor(self, id)
end

function PVLegionApply:onMVCEnter()
    self:showAttributeView()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.legionTempalte = getTemplateManager():getLegionTemplate()
    self:registerDataBack()
end

function PVLegionApply:registerDataBack()
    --军团排行列表返回
    local function getRankListBack()
        self:initView()
        self:initData()
        self:initTableView()
    end
    self:registerMsg(GET_RANK_LIST, getRankListBack)

    --申请加入军团处理
    local function getJoinLegionBack()
        local responsData = self.legionData:getJoinResponseData()
        -- table.print(responsData)
        local result = responsData.result
        local message = responsData.message
        -- self.labelCommon:initAction("申请加入军团成功")
        local spareTime = responsData.spare_time
        local hour = math.floor(spareTime/3600)
        local min = math.floor(spareTime%3600/60)
        local timeStr = tostring(hour) .. "小时" .. tostring(min) .. "分钟之后才可以申请加入军团！"
        if result then
            getOtherModule():showAlertDialog(nil, Localize.query("legion.2"))
        else
            getOtherModule():showAlertDialog(nil, timeStr)
        end
    end
    self:registerMsg(JOIN_LEGION, getJoinLegionBack)
end

function PVLegionApply:initData()
    self.rankList = self.legionData:getRankList()
    local function mySort(member1, member2)
        return member1.rank > member2.rank
    end
    table.sort(self.rankList, mySort)
    self.itemCount = table.nums(self.rankList)
     self.totalSelect = {}
end

function PVLegionApply:initView()
    self.UILegionApplyView = {}
    self:initTouchListener()
    self:loadCCBI("legion/ui_legion_apply.ccbi", self.UILegionApplyView)

    self.contentLayer = self.UILegionApplyView["UILegionApplyView"]["contentLayer"]

end

function PVLegionApply:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --创建公会
    local function onCreateLegionClick()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVLegionCreate")
    end

    --ui中的事件
    self.UILegionApplyView["UILegionApplyView"] = {}

    self.UILegionApplyView["UILegionApplyView"]["backMenuClick"] = onBackClick
    self.UILegionApplyView["UILegionApplyView"]["onCreateLegionClick"] = onCreateLegionClick
end

--返回更新时回调
function PVLegionApply:onReloadView()
    if isSucceed then
        self:onHideView()
    end
end

function PVLegionApply:initTableView()
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

function PVLegionApply:scrollViewDidScroll(view)
end

function PVLegionApply:scrollViewDidZoom(view)
end

function PVLegionApply:tableCellTouched(table, cell)
    local g_id = self.rankList[cell:getIdx() + 1].g_id
    print("触摸事件 g_id ============== ", g_id)
end

function PVLegionApply:cellSizeForTable(table, idx)
    return CONFIG_GENERAL_CELL_HEIGHT, CONFIG_GENERAL_CELL_WIDTH
end

function PVLegionApply:tableCellAtIndex(tbl, idx)

    local cell = tbl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()

        local function onItemClick()
            cclog("onItemClick")
        end

        --军团申请
        local function onApplyClick()
            local g_id = self.rankList[cell.index + 1].g_id
            self.legionNet:sendApplyJoin(g_id)
        end

        cell.UILegionItem = {}
        cell.UILegionItem["UILegionItem"] = {}
        cell.UILegionItem["UILegionItem"]["onItemClick"] = onItemClick
        cell.UILegionItem["UILegionItem"]["onApplyClick"] = onApplyClick

        local itemProxy = cc.CCBProxy:create()
        local legionItem = CCBReaderLoad("legion/ui_legion_apply_item.ccbi", itemProxy, cell.UILegionItem)

        cell:addChild(legionItem)
    end

    if table.nums(self.rankList) > 0 then
        cell.index = idx
        -- local rankValue = string.format("%d", self.rankList[idx + 1].rank)
        local curRankValue = string.format("%d", self.rankList[idx + 1].rank)
        local rankValue = self.itemCount - curRankValue + 1
        local rankName = self.rankList[idx + 1].name
        local level = self.rankList[idx + 1].level
        local president = self.rankList[idx + 1].president
        local number = self.rankList[idx + 1].p_num
        self.otherDetail = self.legionTempalte:getGuildTemplateByLevel(level)
        local legionRank = cell.UILegionItem["UILegionItem"]["legionRank"] --军团排行
        local legionName = cell.UILegionItem["UILegionItem"]["legionName"] --军团名称
        local levelLayer = cell.UILegionItem["UILegionItem"]["levelLayer"] --军团等级层
        local levelBMFnt = cell.UILegionItem["UILegionItem"]["levelBMFnt"] --军团等级数
        local coloneName = cell.UILegionItem["UILegionItem"]["coloneName"] --团长名称
        local memberNumber = cell.UILegionItem["UILegionItem"]["memberNumver"] --军团成员数量

        legionRank:setString(rankValue)
        legionRank:setString(rankValue)
        legionName:setString(rankName)
        levelBMFnt:setString(level)
        memberNumber:setString(number .. " / " .. self.otherDetail.p_max)
        coloneName:setString(president)
        --coloneLevel:setString("LV: " .. strValue)


    end

    return cell
end

function PVLegionApply:numberOfCellsInTableView(table)
   return self.itemCount
end

return PVLegionApply
