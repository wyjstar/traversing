
local PVLegionTransfer = class("PVLegionTransfer", BaseUIView)

function PVLegionTransfer:ctor(id)
    PVLegionTransfer.super.ctor(self, id)
end

function PVLegionTransfer:onMVCEnter()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.commonData = getDataManager():getCommonData()
    self:registerDataBack()

    self:initView()
    self:initData(self.funcTable[1])
    self:initTableView()
end

function PVLegionTransfer:registerDataBack()
    -- 转让团长返回
    local function getTransferEndBack()
        -- if self.memberList ~= nil then
        --     for k,v in pairs(self.memberList) do
        --         if self.transferId == v.p_id then
        --             self.legionData:setPositionById(self.transferId, 1)
        --         end
        --     end
        -- end
        local responsData = self.legionData:getLegionResultData()
        print("转让返回 ==============")
        table.print(responsData)
        if responsData.result then
            self.legionData:setPositionById(self.commonData:getAccountId(), 5)
            self.legionData:setLegionPosition(5)
            self.legionData:setTransferId(self.transferId)
            self:onHideView()
        end
    end
    self:registerMsg(TRANSFER_LEGION, getTransferEndBack)
end

function PVLegionTransfer:initData(member_list)
    self.curIndex = nil
    self.my_id = self.commonData:getAccountId()

    self.memberList = member_list

    -- local my_id = self.commonData:getAccountId()

    -- for k,v in pairs(self.memberList) do
    --     if v.p_id == my_id then
    --         table.remove(self.memberList, k)
    --     end
    -- end

    self.itemCount = table.nums(self.memberList)

    --self.totalSelect = {}
    self.transferId = nil

    self.positionTable = {"#ui_legion_s_tz.png", "#ui_legion_s_ftz.png", "#ui_legion_s_zl.png", "#ui_legion_s_jyg.png", "#ui_legion_s_hy.png"}

end

function PVLegionTransfer:initView()
    self.UILegionTransferView = {}
    self:initTouchListener()

    self:loadCCBI("legion/ui_legion_transfer.ccbi", self.UILegionTransferView)

    self.contentLayer = self.UILegionTransferView["UILegionTransferView"]["contentLayer"]
    self.timeValue = self.UILegionTransferView["UILegionTransferView"]["timeValue"]

end

function PVLegionTransfer:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --转让团长
    local function onTransferLegionClick()
        getAudioManager():playEffectButton2()
        -- if table.nums(self.totalSelect) == 1 then
        --     --self:onHideView()
        -- end
        -- if self.memberList ~= nil then
        --     for k,v in pairs(self.memberList) do
        --         if self.transferId == v.p_id then
        --             self.legionData:setPositionById(self.transferId, 1)
        --         end
        --     end
        -- end
        print("当前玩家的id ================ ",self.commonData:getAccountId())
        print("转让的目标的id ==================== ", self.transferId)
        if self.transferId ~= nil then
            self.legionNet:sendTransferLegion(self.transferId)
        else
            -- self:toastShow("您还未选择要转让的对象")
            -- getOtherModule():showToastView(Localize.query("legion.10"))
            getOtherModule():showAlertDialog(nil, Localize.query("legion.10"))

            -- self:onHideView()
        end
    end

    self.UILegionTransferView["UILegionTransferView"] = {}
    self.UILegionTransferView["UILegionTransferView"]["backMenuClick"] = onBackClick
    self.UILegionTransferView["UILegionTransferView"]["onTransferLegionClick"] = onTransferLegionClick
end

function PVLegionTransfer:initTableView()
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

function PVLegionTransfer:scrollViewDidScroll(view)
end

function PVLegionTransfer:scrollViewDidZoom(view)
end

function PVLegionTransfer:tableCellTouched(table, cell)
end

function PVLegionTransfer:cellSizeForTable(table, idx)
    return 85, 545
end

function PVLegionTransfer:tableCellAtIndex(tbl, idx)

    local cell = tbl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()

        local strValue = self.memberList[idx + 1].p_id

        --选择按钮
        local function onSelectClick()
            local index = cell:getIdx()
            local selectSprite = cell.UILegionKillOutItem["UILegionKillOutItem"]["selectSprite"]
            if self.curIndex == nil then
                cell.itemMenu:setTouchEnabled(true)
                if (selectSprite:isVisible()) then
                    selectSprite:setVisible(false)
                   -- self.memberList[index + 1].isSelect = false
                    --self.totalSelect[index] = nil
                    --table.remove(self.totalSelect, index)

                    self.transferId = nil
                else
                    selectSprite:setVisible(true)
                    --self.memberList[index + 1].isSelect = true
                    --table.insert(self.totalSelect, index, index)

                    self.transferId = self.memberList[index + 1].p_id
                    self.curIndex = index
                end
            elseif self.curIndex == index then
                selectSprite:setVisible(false)
                cell.itemMenu:setTouchEnabled(true)
                -- self.totalSelect[index] = nil
                -- table.remove(self.totalSelect, index)
                self.transferId = nil
                self.curIndex = nil
            else
                cell.itemMenu:setTouchEnabled(false)
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

    if table.nums(self.memberList) > 0 then
        local strValue = string.format("%d", self.memberList[idx + 1].p_id)

        local playerName = cell.UILegionKillOutItem["UILegionKillOutItem"]["playerName"]          --成员名称
        local levelBMFnt = cell.UILegionKillOutItem["UILegionKillOutItem"]["levelBMFnt"]          --成员等级
        local positionSprite = cell.UILegionKillOutItem["UILegionKillOutItem"]["positionSprite"]  --成员职位
        local repuValue = cell.UILegionKillOutItem["UILegionKillOutItem"]["repuValue"]            --贡献值
        local killValue = cell.UILegionKillOutItem["UILegionKillOutItem"]["killValue"]            --杀敌人数
        cell.itemMenu = cell.UILegionKillOutItem["UILegionKillOutItem"]["itemMenu"]
        local selectSprite = cell.UILegionKillOutItem["UILegionKillOutItem"]["selectSprite"]

        local position = self.memberList[idx + 1].position
        game.setSpriteFrame(positionSprite, self.positionTable[position])

        playerName:setString(self.memberList[idx + 1].name)
        levelBMFnt:setString("Lv." .. string.format("%d",self.memberList[idx + 1].level))
        repuValue:setString(string.format("%d",self.memberList[idx + 1].all_contribution))
        killValue:setString(string.format("%d",self.memberList[idx + 1].k_num))
    end

    return cell
end

function PVLegionTransfer:numberOfCellsInTableView(table)
   return self.itemCount
end

return PVLegionTransfer
