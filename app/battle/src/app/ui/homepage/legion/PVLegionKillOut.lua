
-- local LabelCommon = import("....ui.other.LabelCommon")

local PVLegionKillOut = class("PVLegionKillOut", BaseUIView)

function PVLegionKillOut:ctor(id)
    print("进入 -------------- ", id)
    PVLegionKillOut.super.ctor(self, id)
end

function PVLegionKillOut:onMVCEnter()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.commonData = getDataManager():getCommonData()
    self:registerDataBack()

    self:initView()
    self:initData(self.funcTable[1])
    self:initTableView()
end

function PVLegionKillOut:initData(member_list)
    self.memberList = member_list

    self.my_id = self.commonData:getAccountId()

    self.my_position = self.legionData:getLegionPosition()

    -- for k,v in pairs(self.memberList) do
    --     if v.p_id == my_id then
    --         table.remove(self.memberList, k)
    --     end
    -- end

    self.itemCount = table.nums(self.memberList)

    self.totalSelect = {}
    self.tagTable = {}
    self.itemCount = table.nums(self.memberList)

    self:loadData()

    --标记列表初始化
    if self.itemCount > 0 then
        for k,v in pairs(self.memberList) do
            self.tagTable[k] = {}
            self.tagTable[k].isSelect = false
        end
    end

    --职位图片初始化
    self.positionTable = {"#ui_legion_s_tz.png", "#ui_legion_s_ftz.png", "#ui_legion_s_zl.png", "#ui_legion_s_jyg.png", "#ui_legion_s_hy.png"}

end

function PVLegionKillOut:registerDataBack()
    --踢出军团返回
    local function getKillBack(data)
        local responsData = self.legionData:getLegionResultData()
        table.nums(responsData)
        self.result = responsData.result
        self.message = responsData.message
        if self.result then
            for k, v in pairs(self.totalSelect) do
                self:removeTableData(v)
            end
            local killNum = table.getn(self.totalSelect)
            self.legionData:updateMemberNum(killNum, 2)

            self:loadData()
            self.totalSelect = {}
            self.itemCount = table.nums(self.memberList)
            self.tableView:reloadData()
            self:tableViewItemAction(self.tableView)
        else
            -- self.labelCommon:initAction(self.message)
            self:toastShow(self.message)
        end
    end
    self:registerMsg(KILL_OUT, getKillBack)
end

function PVLegionKillOut:initView()
    self.UILegionKillOutView = {}
    self:initTouchListener()

    self:loadCCBI("legion/ui_legion_killout.ccbi", self.UILegionKillOutView)

    self.contentLayer = self.UILegionKillOutView["UILegionKillOutView"]["contentLayer"]

    -- self.labelCommon = LabelCommon.new()
    -- self:addChild(self.labelCommon)

    -- self.generalItems = {}
    --  for i =1, 10 do
    --     self.generalItems[i] = {}
    --     self.generalItems[i].isSelect = false
    --     self.generalItems[i].id = i
    -- end
    -- self:loadData()
    -- self.itemCount = table.nums(self.generalItems)

    -- self.totalSelect = {}
end

function PVLegionKillOut:loadData()
    local index = 1
    for k, v in pairs(self.memberList) do
        v.index = index
        index = index + 1
    end
end

function PVLegionKillOut:removeTableData(_index)
    for m, n in pairs(self.memberList) do
        local id = n.p_id
        if id == _index then
            table.remove(self.memberList, m)
            return
        end
    end
end

function PVLegionKillOut:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --踢出军团
    local function onKilloutLegionClick()
        getAudioManager():playEffectButton2()
        if table.getn(self.totalSelect) > 0 then
            self.legionNet:sendKillOutLegion(self.totalSelect)
        else
            getOtherModule():showAlertDialog(nil, Localize.query("PVLegionKillOut.1"))
        end
        for k,v in pairs(self.tagTable) do
            v.isSelect = false
        end
    end

    self.UILegionKillOutView["UILegionKillOutView"] = {}
    self.UILegionKillOutView["UILegionKillOutView"]["backMenuClick"] = onBackClick
    self.UILegionKillOutView["UILegionKillOutView"]["onKilloutLegionClick"] = onKilloutLegionClick
end

function PVLegionKillOut:initTableView()
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

function PVLegionKillOut:scrollViewDidScroll(view)
end

function PVLegionKillOut:scrollViewDidZoom(view)
end

function PVLegionKillOut:tableCellTouched(table, cell)
    --self:dispatchEvent(const.EVENT_PV_USEITEMTIPS_HIDE)
end

function PVLegionKillOut:cellSizeForTable(table, idx)
    --local layerSize = self.itemLayer:getContentSize()
    return 85, 545
end

function PVLegionKillOut:tableCellAtIndex(tbl, idx)

    local cell = tbl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()
        local strValue = self.memberList[idx+1].p_id
        --选择按钮
        local function onSelectClick()
            local index = cell.index
            local num = table.nums(self.totalSelect)
            local selectSprite = cell.UILegionKillOutItem["UILegionKillOutItem"]["selectSprite"]
            if selectSprite:isVisible() then
                selectSprite:setVisible(false)
                for k,v in pairs(self.totalSelect) do
                    if v == self.memberList[index + 1].p_id then
                        table.remove(self.totalSelect, k)
                    end
                end
                self:changeSelect(index + 1, false)
            else
                selectSprite:setVisible(true)
                table.insert(self.totalSelect, num + 1, self.memberList[index + 1].p_id)
                self:changeSelect(index + 1, true)
            end
        end

        cell.UILegionKillOutItem = {}
        cell.UILegionKillOutItem["UILegionKillOutItem"] = {}

        cell.UILegionKillOutItem["UILegionKillOutItem"]["onSelectClick"] = onSelectClick

        local proxy = cc.CCBProxy:create()
        local killOutItem = CCBReaderLoad("legion/ui_legion_killout_item.ccbi", proxy, cell.UILegionKillOutItem)

        local selectItem = cell.UILegionKillOutItem["UILegionKillOutItem"]["selectItem"]          --选择按钮
        if strValue == self.my_id then
            selectItem:setVisible(false)
            selectItem:setEnabled(false)
        else
            selectItem:setVisible(true)
            selectItem:setEnabled(true)
        end

        cell:addChild(killOutItem)
    end

    cell.index = idx

    if table.nums(self.memberList) > 0 then
        local strValue = string.format("%d", table.getValueByIndex(self.memberList, idx+1).p_id)

        local playerName = cell.UILegionKillOutItem["UILegionKillOutItem"]["playerName"]          --成员名称
        local levelBMFnt = cell.UILegionKillOutItem["UILegionKillOutItem"]["levelBMFnt"]          --成员等级
        local positionSprite = cell.UILegionKillOutItem["UILegionKillOutItem"]["positionSprite"]  --成员职位
        local repuValue = cell.UILegionKillOutItem["UILegionKillOutItem"]["repuValue"]            --贡献值
        local killValue = cell.UILegionKillOutItem["UILegionKillOutItem"]["killValue"]            --杀敌人数
        local selectSprite = cell.UILegionKillOutItem["UILegionKillOutItem"]["selectSprite"]      --选择图片
        local selectItem = cell.UILegionKillOutItem["UILegionKillOutItem"]["selectItem"]          --选择按钮

        playerName:setString(self.memberList[idx + 1].name)
        levelBMFnt:setString("Lv." .. string.format("%d",self.memberList[idx + 1].level))
        repuValue:setString(string.format("%d",self.memberList[idx + 1].all_contribution))
        killValue:setString(string.format("%d",self.memberList[idx + 1].k_num))

        local position = self.memberList[idx + 1].position
        game.setSpriteFrame(positionSprite, self.positionTable[position])

        local isSelect = self:getSelectByIndex(idx + 1)
        if isSelect then
            selectSprite:setVisible(true)
        else
            selectSprite:setVisible(false)
        end
    end

    return cell
end

function PVLegionKillOut:numberOfCellsInTableView(table)
   return self.itemCount
end

function PVLegionKillOut:changeSelect(curIndex, changeSelect)
    self.tagTable[curIndex].isSelect = changeSelect
end

function PVLegionKillOut:getSelectByIndex(curIndex)
    local result = self.tagTable[curIndex].isSelect
    return result
end

return PVLegionKillOut
