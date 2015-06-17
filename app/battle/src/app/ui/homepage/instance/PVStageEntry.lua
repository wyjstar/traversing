local PVStageEntry = class("PVStageEntry", BaseUIView)

function PVStageEntry:ctor(id)
    isEntry = true
    PVStageEntry.super.ctor(self, id)

    self.instanceTemp = getTemplateManager():getInstanceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self._resourceTemp = getTemplateManager():getResourceTemplate()
    self._soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.lineUpData = getDataManager():getLineupData()
    self.c_EquipTemp = getTemplateManager():getEquipTemplate()
    self.squipTemp = getTemplateManager():getSquipmentTemplate()
    self.c_SoldierData = getDataManager():getSoldierData()
end

function PVStageEntry:onMVCEnter()
    self:showAttributeView()
    self:initData()
    self:initView()
    self:initTable()
end

function PVStageEntry:registerDataBack()

end

function PVStageEntry:initData()
    self.data = self.funcTable[1]
    self.conditionItems = self.funcTable[2]
    self.curProbability = self.funcTable[3]
    local break_id = self.instanceTemp:getTemplateById(self.data).stage_break_id
    print("break_id====")
    print(break_id)
    self.break_data = self.instanceTemp:getConditionDetail(break_id)

    self.itemCount = table.getn(self.conditionItems)
    print("self.itemCount ============= ", self.itemCount)
end

function PVStageEntry:initView()
    self.UILuanRuView = {}
    self:initTouchListener()
    self:loadCCBI("instance/ui_stage_luanru.ccbi", self.UILuanRuView)

    self.numberValue = self.UILuanRuView["UILuanRuView"]["numberValue"]             --乱入几率
    self.listLayer = self.UILuanRuView["UILuanRuView"]["listLayer"]                 --乱入条件
    self.rewardDetail = self.UILuanRuView["UILuanRuView"]["rewardDetail"]           --乱入奖励
    self.goMenuItem = self.UILuanRuView["UILuanRuView"]["goMenuItem"]               --前往按钮
    self.propIcon = self.UILuanRuView["UILuanRuView"]["propIcon"]                   --奖励的物品icon
    self.propIcontopNode = self.UILuanRuView["UILuanRuView"]["propIcontopNode"]     --乱入武将大图
    self.heroNaneSp = self.UILuanRuView["UILuanRuView"]["heroNaneSp"]               --乱入名字图


    local probability = self.curProbability * 100
    self.numberValue:setString(probability)

    -- self.rewardDetail:setString(self.rewardName)

    -- --乱入英雄信息
    local hero_id = self.break_data.hero_id
    self.soldier_name = self._soldierTemplate:getHeroName(hero_id)      --乱入武将的名称
    self.soldier_icon = self._soldierTemplate:getResIconNo(hero_id)     --乱入武将的头像信息
    local resIcon = getTemplateManager():getSoldierTemplate():getSoldierIcon(hero_id)
    local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(hero_id)
    addHeroHDSpriteFrame(hero_id)
    self.propIcontopNode:addChild(getTemplateManager():getSoldierTemplate():getHeroBigImageById(hero_id))

    self:setLuanruHeroNameSp(self.heroNaneSp,self.soldier_name)

    --乱入奖励
    local reward_odds = self.break_data.reward_odds                     --乱入奖励获得几率
    table.print(self.break_data)
    local rewardTab = self.break_data.reward
    local rewardId = ""
    for k,v in pairs(rewardTab) do
        if k == "106" then
            rewardId = v[3]
        end
    end
    self.rewardName = self.chipTemp:getChipName(rewardId)               --乱入奖励碎片名称
    local smallBagIds = getTemplateManager():getDropTemplate():getSmallBagIds(rewardId)
    for k,v in pairs(smallBagIds) do
        local smallItem = getTemplateManager():getDropTemplate():getSmallBagById(v)

        local rewardIcon = self.chipTemp:getChipIconById(smallItem.detailID)       --乱入奖励碎片icon

        local _quality = self.chipTemp:getTemplateById(smallItem.detailID).quality
        changeNewIconImage(self.propIcon, rewardIcon, _quality)
    end

end

function PVStageEntry:setLuanruHeroNameSp(sprite,heroName)
    if heroName == "李元霸" then
        sprite:setSpriteFrame("ui_instance_word_liyuanba.png.png")
    elseif heroName == "刘邦" then
        sprite:setSpriteFrame("ui_instance_word_liubang.png")
    elseif heroName == "项羽" then
        sprite:setSpriteFrame("ui_instance_word_xiangyu.png")
    elseif heroName == "李广" then
        sprite:setSpriteFrame("ui_instance_word_liguang.png")
    elseif heroName == "荆轲" then
        sprite:setSpriteFrame("ui_instance_word_jingke.png")
    else
        print("PVStageDetails:setLuanruHeroNameSp(sprite,heroName) ：不是有效的乱入武将名字")
    end
end

function PVStageEntry:initTable()
    self.layerSize = self.listLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.listLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVStageEntry:initTouchListener()
    --前往
    local function onGoClick()
        self:onHideView()
    end

    --关闭面板
    local function onCloseClick()
        self:onHideView()
    end

    local function onItemClick()
        getAudioManager():playEffectButton2()
        print(" ------------------ onItemClick =============== ")
        local rewardTab = self.break_data.reward
        local rewardId = ""
        for k,v in pairs(rewardTab) do
            if k == "106" then
                rewardId = v[3]
            end
        end
        local nowPatchNum = self.c_SoldierData:getPatchNumById(rewardId)
        local smallBagIds = getTemplateManager():getDropTemplate():getSmallBagIds(rewardId)
        local smallItem = nil
        for k,v in pairs(smallBagIds) do
            smallItem = getTemplateManager():getDropTemplate():getSmallBagById(v)
        end
        getOtherModule():showOtherView("PVCommonChipDetail", 1, smallItem.detailID, nowPatchNum)
    end

    self.UILuanRuView["UILuanRuView"] = {}

    self.UILuanRuView["UILuanRuView"]["onGoClick"] = onGoClick
    self.UILuanRuView["UILuanRuView"]["onCloseClick"] = onCloseClick
    self.UILuanRuView["UILuanRuView"]["onItemClick"] = onItemClick
end

function PVStageEntry:scrollViewDidScroll(view)
end

function PVStageEntry:scrollViewDidZoom(view)
end

function PVStageEntry:tableCellTouched(table, cell)
end

function PVStageEntry:cellSizeForTable(table, idx)
    return 100, 551
end

function PVStageEntry:tableCellAtIndex(tabl, idx)
    local cell = nil
    if nil == cell then
        --获取
        local function onGetClick()
            isEntry = true
            print("乱入条件类型 ============= ")
            local index = cell:getIdx()
            -- local typeIndex = self.conditionItems[index + 1].typeIndex
            local typeIndex = 1
            -- local curCondition = self.conditionItems[index + 1].condition
            -- local aimLinkItem = self._soldierTemplate:getLinkById(curCondition[])

            for k,v in pairs(self.conditionItems[index + 1]) do
                if k == "condition" then
                    for k,v in pairs(v) do
                        typeIndex = tonumber(k)
                    end
                end
            end

            if typeIndex == 1 or typeIndex == 2 or typeIndex == 5 then
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVShopPage", 1)
            elseif typeIndex == 3 or typeIndex == 4 then
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVShopPage", 2)
            end
        end

        cell = cc.TableViewCell:new()
        cell.UILuanRuItem = {}
        cell.UILuanRuItem["UILuanRuItem"] = {}

        cell.UILuanRuItem["UILuanRuItem"]["onGetClick"] = onGetClick

        local proxy = cc.CCBProxy:create()
        local luanruItem = CCBReaderLoad("instance/ui_luanru_item.ccbi", proxy, cell.UILuanRuItem)

        cell.detailLabel = cell.UILuanRuItem["UILuanRuItem"]["detailLabel"]
        cell.itemMenuItem = cell.UILuanRuItem["UILuanRuItem"]["itemMenuItem"]
        cell.tipLabel = cell.UILuanRuItem["UILuanRuItem"]["tipLabel"]
        cell.getLayer = cell.UILuanRuItem["UILuanRuItem"]["getLayer"]

        cell:addChild(luanruItem)
    end

    if table.nums(self.conditionItems) > 0 then

        local text_id = self.conditionItems[idx + 1].text_id
        print("text_id ================== 乱入 =========== ", text_id)
        local descibe_chinese = self.c_LanguageTemplate:getLanguageById(text_id)
        local odds_value = self.conditionItems[idx + 1].odds
        cell.detailLabel:setString(descibe_chinese)
        cell.tipLabel:setString(odds_value * 100 .. "%")
        local  _isFullCondition = self.conditionItems[idx + 1].isFullCondition

        if _isFullCondition == true then
            -- cell.getLayer:setVisible(false)
            cell.detailLabel:setColor(cc.c3b(28,252,252))
            cell.tipLabel:setColor(cc.c3b(28,252,252))
        else
            -- cell.getLayer:setVisible(true)
            cell.detailLabel:setColor(ui.COLOR_DARK_GREY)
            cell.tipLabel:setColor(ui.COLOR_DARK_GREY)
        end
    end

    return cell
end

function PVStageEntry:numberOfCellsInTableView(table)
    return self.itemCount
end

return PVStageEntry
