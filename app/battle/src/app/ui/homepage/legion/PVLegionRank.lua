
--军团排行

local PVLegionRank = class("PVLegionRank", BaseUIView)

function PVLegionRank:ctor(id)
    PVLegionRank.super.ctor(self, id)
end

function PVLegionRank:onMVCEnter()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.legionTempalte = getTemplateManager():getLegionTemplate()
    self:registerDataBack()

    self:initView()
end
--网络注册
function PVLegionRank:registerDataBack()
    local function getRankBack()
        self:initData()
        self:initTableView()
    end
    self:registerMsg(GET_RANK_LIST, getRankBack)
end

function PVLegionRank:initData()
    self.rankList = self.legionData:getRankList()

    local function mySort(member1, member2)
        return member1.rank > member2.rank
    end
    table.sort(self.rankList, mySort)

    self.itemCount = table.nums(self.rankList)
    self.totalSelect = {}
end

function PVLegionRank:initView()
    self.UILegionRankView = {}
    self:initTouchListener()
    self:loadCCBI("legion/ui_legion_rank.ccbi", self.UILegionRankView)

    self.contentLayer = self.UILegionRankView["UILegionRankView"]["contentLayer"]

    -- self.generalItems = {}
    --  for i =1, 10 do
    --     self.generalItems[i] = {}
    --     self.generalItems[i].isSelect = false
    --     self.generalItems[i].id = i
    -- end

    -- self.itemCount = table.nums(self.generalItems)

    -- self.totalSelect = {}


end

function PVLegionRank:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
        -- self:onHideLegionRankView()
    end

    self.UILegionRankView["UILegionRankView"] = {}
    self.UILegionRankView["UILegionRankView"]["backMenuClick"] = onBackClick
end

function PVLegionRank:initTableView()
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

function PVLegionRank:scrollViewDidScroll(view)
end

function PVLegionRank:scrollViewDidZoom(view)
end

function PVLegionRank:tableCellTouched(table, cell)
end

function PVLegionRank:cellSizeForTable(table, idx)
    return CONFIG_GENERAL_CELL_HEIGHT, CONFIG_GENERAL_CELL_WIDTH
end

function PVLegionRank:tableCellAtIndex(tbl, idx)

    local cell = tbl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()

        local function onItemClick()
            cclog("onItemClick")
        end

        cell.UILegionRankItem = {}
        cell.UILegionRankItem["UILegionRankItem"] = {}
        cell.UILegionRankItem["UILegionRankItem"]["onItemClick"] = onItemClick

        local itemProxy = cc.CCBProxy:create()
        local rankItem = CCBReaderLoad("legion/ui_legion_rank_item.ccbi", itemProxy, cell.UILegionRankItem)

        cell:addChild(rankItem)
    end

    if table.nums(self.rankList) > 0 then
        local curRankValue = string.format("%d", self.rankList[idx + 1].rank)
        local rankValue = self.itemCount - curRankValue + 1
        local rankName = self.rankList[idx + 1].name
        local level = self.rankList[idx + 1].level
        local president = self.rankList[idx + 1].president
        local number =  self.rankList[idx + 1].p_num
        local record =  self.rankList[idx + 1].record
        self.otherDetail = self.legionTempalte:getGuildTemplateByLevel(level)
        local legionRank = cell.UILegionRankItem["UILegionRankItem"]["legionRank"] --军团排行
        local legionName = cell.UILegionRankItem["UILegionRankItem"]["legionName"] --军团名称
        local levelLayer = cell.UILegionRankItem["UILegionRankItem"]["levelLayer"] --军团等级层
        local levelBMFnt = cell.UILegionRankItem["UILegionRankItem"]["levelBMFnt"] --军团等级数
        local coloneName = cell.UILegionRankItem["UILegionRankItem"]["coloneName"] --团长名称
        local memberNumber = cell.UILegionRankItem["UILegionRankItem"]["memberNumver"] --军团成员数量
        local recordValue = cell.UILegionRankItem["UILegionRankItem"]["powerValue"] --军团战绩

        legionRank:setString(rankValue)
        legionName:setString(rankName)
        levelBMFnt:setString(level)
        coloneName:setString(president)
        memberNumber:setString(number .. " / " .. self.otherDetail.p_max)
        recordValue:setString(record)

        --coloneLevel:setString("LV: " .. strValue)

        local index = cell:getIdx()
    end

    return cell
end

function PVLegionRank:numberOfCellsInTableView(table)
   return self.itemCount
end

function PVLegionRank:onShowLegionRankView()
    -- self.shieldlayer:setTouchEnabled(true)
    self:setVisible(true)
    self.tableView:reloadData()

    self:tableViewItemAction(self.tableView)
end

-- function PVLegionRank:onHideLegionRankView()
--     self.shieldlayer:setTouchEnabled(false)
--     self:setVisible(false)
-- end

-- function PVLegionRank:onHomePageHide()
--     self:onHideLegionRankView()
-- end

return PVLegionRank
