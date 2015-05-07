
--军团成员列表

local PVLegionMemberList = class("PVLegionMemberList", BaseUIView)

function PVLegionMemberList:ctor(id)
    PVLegionMemberList.super.ctor(self, id)
end

function PVLegionMemberList:onMVCEnter()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.commonData = getDataManager():getCommonData()
    self.my_id = self.commonData:getAccountId()
    --self.my_position = self.legionData:getLegionPosition()
    self:registerDataBack()

    self:initView()
end

function PVLegionMemberList:updateView()
    self:initData()
    self.tableView:reloadData()
    self:tableViewItemAction(self.tableView)
    self.legionData:setTransferId(nil)
end

function PVLegionMemberList:updateMemberView()
end

function PVLegionMemberList:initData()
    self.my_position = self.legionData:getPositionById()
    self.memberList = self.legionData:getMemberList()
    self.curId = self.legionData:getTransferId()
    if self.curId ~= nil then
        for k,v in pairs(self.memberList) do
            if self.curId == v.p_id then
                v.position = 1
            end
        end
    end
    self.itemCount = table.nums(self.memberList)
    local function mySort(member1, member2)
        if member1.position ~= member2.position then
            return member1.position < member2.position
        else
            return member1.all_contribution > member2.all_contribution
        end
    end
    table.sort(self.memberList, mySort)

    self.totalSelect = {}
    self.positionTable = {"#ui_legion_s_tz.png", "#ui_legion_s_ftz.png", "#ui_legion_s_zl.png", "#ui_legion_s_jyg.png", "#ui_legion_s_hy.png"}

    self:updateSet()
end

--当职位发生变化是重新设置
function PVLegionMemberList:updateSet()

    if self.my_position == 1 then
        self.transferMenuItem:setEnabled(true)
        self.killOutMenuItem:setEnabled(true)
        self.killOutSprite:setColor(cc.c3b(255,255,255))
        self.transferSprite:setColor(cc.c3b(255,255,255))
    else
        self.transferMenuItem:setEnabled(false)
        self.killOutMenuItem:setEnabled(false)
        self.killOutSprite:setColor(cc.c3b(88,87,86))
        self.transferSprite:setColor(cc.c3b(88,87,86))
    end
end

--注册网络协议返回调用接口
function PVLegionMemberList:registerDataBack()
    --获取成员列表返回
    local function getMemberListBack()
        self:initData()
        self:initTableView()
    end

    self:registerMsg(GET_MEMBER_LIST, getMemberListBack)

    local function mySort(member1, member2)
        if member1.position ~= member2.position then
            return member1.position < member2.position
        else
            return member1.all_contribution > member2.all_contribution
        end
    end

    --晋升职位返回
    local function getPromotionBack()
        local responsData = self.legionData:getLegionResultData()
        self.result = responsData.result
        self.message = responsData.message
        self.change_id = responsData.p_id                                           --要替换的对象的id
        if self.result then
            -- self.labelCommon:initAction(self.message)
            self:toastShow(self.message)
            --local prePosition = self.legionData:getPositionById()
            self.legionData:setPositionById(self.my_id, self.my_position - 1)       --晋升成功重新设置职位的数值
            self.legionData:setLegionPosition(self.my_position - 1)
            self.my_position = self.legionData:getLegionPosition()                    --获取晋升成功之后职位的数值
            print("self.change_id ====================== ", self.change_id)
            if self.change_id ~= 0 then
                for k,v in pairs(self.memberList) do
                    if self.change_id == v.p_id then
                        v.position = self.my_position + 1
                    elseif self.my_id == v.p_id then
                        v.position = self.my_position
                        self.legionData:setPositionById(v.p_id, v.position)
                    end
                end
            end
            table.sort(self.memberList, mySort)
            self.tableView:reloadData()
            self:resetTabviewContentOffset(self.tableView)
        else
            -- self.labelCommon:initAction(self.message)
            -- self:toastShow(self.message)
            getOtherModule():showAlertDialog(nil, self.message)
        end

    end

    self:registerMsg(LEGION_PROMOTION, getPromotionBack)

    --转让团长返回
    -- local function getTransferEndBack()
    --     local responsData = self.legionData:getLegionResultData()
    --     local transfer_id = self.legionData:getPositionById()
    --     self.result = responsData.result
    --     self.message = responsData.message
    --     if self.result then
    --         --self.legionData:setLegionPosition(5)
    --         for k,v in pairs(self.memberList) do
    --             if self.my_id == v.p_id then
    --                 v.position = 5
    --                 -- self.legionData:setPositionById(self.my_id, 5)
    --                 --self.legionData:setLegionPosition(5)
    --                 self.my_position = 5
    --             elseif transfer_id == v.p_id then
    --                 v.position = 1
    --                 -- self.legionData:setPositionById(transfer_id, 1)
    --             end
    --         end
    --         self:updateSet()
    --         -- self.memberList = self.legionData:getMemberList()
    --         self.itemCount = table.nums(self.memberList)
    --         self.tableView:reloadData()
    --     end
    -- end

    -- self:registerMsg(TRANSFER_LEGION, getTransferEndBack)
end

function PVLegionMemberList:initView()
    self.UILegionMemberListView = {}
    self:initTouchListener()
    self:loadCCBI("legion/ui_legion_member_list_.ccbi", self.UILegionMemberListView)

    self.contentLayer = self.UILegionMemberListView["UILegionMemberListView"]["contentLayer"]
    self.killOutSprite = self.UILegionMemberListView["UILegionMemberListView"]["killOutSprite"]         --踢出军团图片
    self.killOutMenuItem = self.UILegionMemberListView["UILegionMemberListView"]["killOutMenuItem"]     --踢出军团按钮
    self.transferSprite = self.UILegionMemberListView["UILegionMemberListView"]["transferSprite"]       --转让军团图片
    self.transferMenuItem = self.UILegionMemberListView["UILegionMemberListView"]["transferMenuItem"]   --转让军团按钮


end

function PVLegionMemberList:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView(self.memberNum)
        --self:onUIHide()
    end

    --退出军团
    local function onExitLegionClick()
        cclog("onExitLegionClick")
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVLegionExit")
    end

    --踢出军团
    local function onKillOutLegionClick()
        cclog("onKillOutLegionClick")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionKillOut", self.memberList)
    end

    --转让团长
    local function onTranferLegionClick()
        cclog("onTranferLegionClick")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionTransfer", self.memberList)
    end

    --晋升职位
    local function onPromotionClick()
        cclog("onPromotionClick")
        getAudioManager():playEffectButton2()
        self.legionNet:sendPromotion()
    end

    self.UILegionMemberListView["UILegionMemberListView"] = {}
    self.UILegionMemberListView["UILegionMemberListView"]["backMenuClick"] = onBackClick
    self.UILegionMemberListView["UILegionMemberListView"]["onExitLegionClick"] = onExitLegionClick
    self.UILegionMemberListView["UILegionMemberListView"]["onKillOutLegionClick"] = onKillOutLegionClick
    self.UILegionMemberListView["UILegionMemberListView"]["onTranferLegionClick"] = onTranferLegionClick
    self.UILegionMemberListView["UILegionMemberListView"]["onPromotionClick"] = onPromotionClick
end

function PVLegionMemberList:initTableView()
    local layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.contentLayer:addChild(self.tableView, 100)

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

function PVLegionMemberList:scrollViewDidScroll(view)
end

function PVLegionMemberList:scrollViewDidZoom(view)
end

function PVLegionMemberList:tableCellTouched(table, cell)
    --self:dispatchEvent(const.EVENT_PV_USEITEMTIPS_HIDE)
end

function PVLegionMemberList:cellSizeForTable(table, idx)
    return 80, 560
end

function PVLegionMemberList:tableCellAtIndex(tbl, idx)

    local cell = tbl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()

        cell.UILegionMemberListItem = {}
        cell.UILegionMemberListItem["UILegionMemberListItem"] = {}

        local memberListProxy = cc.CCBProxy:create()
        local memberListItem = CCBReaderLoad("legion/ui_legion_member_list_item.ccbi", memberListProxy, cell.UILegionMemberListItem)

        cell:addChild(memberListItem)
    end

    if table.nums(self.memberList) > 0 then
        local strValue = string.format("%d", self.memberList[idx + 1].p_id)

        local playerName = cell.UILegionMemberListItem["UILegionMemberListItem"]["playerName"]          --成员名称
        local levelBMFnt = cell.UILegionMemberListItem["UILegionMemberListItem"]["levelBMFnt"]          --成员等级
        local positionSprite = cell.UILegionMemberListItem["UILegionMemberListItem"]["positionSprite"]  --成员职位
        local repuValue = cell.UILegionMemberListItem["UILegionMemberListItem"]["repuValue"]            --贡献值
        local killValue = cell.UILegionMemberListItem["UILegionMemberListItem"]["killValue"]            --杀敌人数

        local position = self.memberList[idx + 1].position
        print("转让后重新load成员列表 ============= ", position)
        game.setSpriteFrame(positionSprite, self.positionTable[position])
        playerName:setString(self.memberList[idx + 1].name)
        levelBMFnt:setString("Lv." .. string.format("%d",self.memberList[idx + 1].level))
        repuValue:setString(string.format("%d",self.memberList[idx + 1].all_contribution))
        killValue:setString(string.format("%d",self.memberList[idx + 1].k_num))

    end

    return cell
end

function PVLegionMemberList:numberOfCellsInTableView(table)
   return self.itemCount
end

return PVLegionMemberList
