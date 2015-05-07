local PVMopUp = class("PVMopUp", BaseUIView)

function PVMopUp:ctor(id)
    PVMopUp.super.ctor(self, id)
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
    self._stageTemp = getTemplateManager():getInstanceTemplate()
    self.commonData = getDataManager():getCommonData()
    self.c_EquipmentData = getDataManager():getEquipmentData()
end

function PVMopUp:onMVCEnter()
    -- self:showAttributeView()
    self.touchEvent = false
    self:initData()
    self:initView()
    self:createTableView()
end

function PVMopUp:registerDataBack()

end

function PVMopUp:initData()
    --self.data = self.funcTable[1]
    self.stageId = self.funcTable[1]
    self.saoType = self.funcTable[2]
    self.drops = self.stageData:getMopUpData()

    self.dropLists = self:createDropLists()
    print("-----self.dropLists------")
    table.print(self.dropLists)
    self.heroExpLists = self:createHeroExpList()
    self:preFerFinance()

    --
    local stageTempItem = self._stageTemp:getTemplateById(self.stageId)

    local dropSize = table.nums(self.drops)
    local _useVigor = stageTempItem.vigor --消耗体力
    -- function CommonData:setStamina(cur_stamina)
    -- self:setFinance(7, cur_stamina)
    -- getHomeBasicAttrView():updateStamina()

    local nowStamina = self.commonData:getStamina()
    print("_useVigor======", _useVigor)
    self.commonData:setStamina(nowStamina - dropSize * _useVigor)
end

function PVMopUp:preFerFinance()
    local times = table.nums(self.drops)

    local teamExp = self.instanceTemp:getClearanceExp(self.stageId)
    local teamMoney = self.instanceTemp:getClearanceMoney(self.stageId)

    teamExp = teamExp * times
    teamMoney = teamMoney * times

    self.commonData:setLevel(self.commonData.level)

    print("-----teamExp-----",teamExp)
    local exp = self.commonData:getExp()
    local money = self.commonData:getCoin()
    local level = self.commonData:getLevel()
    local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
    if exp + teamExp > maxExp then
        local  addLevels = 1
        local remainExp = exp + teamExp - maxExp
        maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level+addLevels)
        while remainExp > maxExp do
            addLevels = addLevels + 1
            remainExp = remainExp - maxExp
            maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level+addLevels)
            print("-----maxExp--------",maxExp)
            print("-----remainExp--------",remainExp)
        end

        self.commonData:setLevel(level+addLevels)
        self.commonData:setExp(remainExp)
        --self.commonData:setExp(exp + teamExp - maxExp)
        --升级
    else
        self.commonData:setExp(exp + teamExp)
    end
    self.commonData:setCoin(money + teamMoney)
end

function PVMopUp:createHeroExpList()
    local heroIDs = {}

    local lineUpList = getDataManager():getLineupData():getSelectSoldier()

    local _heroList = {}
    for k,v in pairs(lineUpList) do
        _heroList[v.slot_no] = v.hero.hero_no
    end

    local index = 1
    for k,v in pairs(_heroList) do
        if v ~= 0 then
            heroIDs[index] = v
            index = index + 1
        end
    end

    local dropsSize = 10

    local stageExp = getTemplateManager():getInstanceTemplate():getClearanceHeroExp(self.stageId)



    -- for k, v in pairs(self.drops) do
    --     local heroExpList = {}
    --     for m, heroId in pairs(heroIDs) do
    --         local item = {}
    --         local soldierDataItem = self.soldierData:getSoldierExp(heroId)
    --         local level = soldierDataItem.level
    --         local exp = soldierDataItem.exp

    --         --local curLevelMaxExp = self.soldierTemplate:getHeroExpByLevel(level)
    --         item.fromLevel = level
    --         item.fromExp = exp
    --         item.heroId = heroId
    --         item.stageExp = stageExp
    --         --soldierId, level, exp
    --         -- self.soldierData:changeSoldierExp()
    --         local curLevelMaxExp = self.soldierTemplate:getHeroExpByLevel(level)

    --         local toExp = nil
    --         if stageExp + exp < curLevelMaxExp then   -- 不升级
    --             toExp = exp + stageExp
    --             item.toExp = toExp
    --             item.toLevel = level
    --             self.soldierData:changeSoldierExp(heroId, level, toExp)
    --             self.lineUpData:changeSelectSoldierExp(heroId, level, toExp)
    --             self.lineUpData:changeCheerSoldierExp(heroId, level, toExp)
    --         else  -- 升级的

    --             local allExp = stageExp + exp + self.soldierTemplate:getHeroAllExpByLevel(level-1)  -- 累积量
    --             local curExp = exp

    --             local toLevel, toExp = self.soldierTemplate:getLevelByExpAll(allExp)

    --             local maxLevel = getDataManager():getCommonData():getLevel()
    --             if toLevel > maxLevel then  -- 限定到玩家等级的最大
    --                 toLevel = maxLevel
    --                 toExp = self.soldierTemplate:getHeroExpByLevel(maxLevel)
    --             end

    --             item.toExp = toExp
    --             item.toLevel = toLevel

    --             local curMaxExp = self.soldierTemplate:getHeroExpByLevel(level)
    --             local nextMaxExp = self.soldierTemplate:getHeroExpByLevel(toLevel)

    --             self.soldierData:changeSoldierExp(heroId, toLevel, toExp)
    --             self.lineUpData:changeSelectSoldierExp(heroId, toLevel, toExp)
    --             self.lineUpData:changeCheerSoldierExp(heroId, toLevel, toExp)
    --         end
    --         heroExpList[#heroExpList + 1] = item
    --     end
    --     heroExpLists[#heroExpLists + 1] = heroExpList
    -- end
    local heroExpLists = {}
    local size = table.nums(self.drops)
    stageExp = stageExp * size
    for m, heroId in pairs(heroIDs) do
        local item = {}
        local soldierDataItem = self.soldierData:getSoldierExp(heroId)
        local level = soldierDataItem.level
        local exp = soldierDataItem.exp

        --local curLevelMaxExp = self.soldierTemplate:getHeroExpByLevel(level)
        item.fromLevel = level
        item.fromExp = exp
        item.heroId = heroId
        item.stageExp = stageExp
        --soldierId, level, exp
        -- self.soldierData:changeSoldierExp()
        print("-------level---------",level)
        local curLevelMaxExp = self.soldierTemplate:getHeroExpByLevel(level)

        local toExp = nil
        if stageExp + exp < curLevelMaxExp then   -- 不升级
            toExp = exp + stageExp
            item.toExp = toExp
            item.toLevel = level
            self.soldierData:changeSoldierExp(heroId, level, toExp)
            self.lineUpData:changeSelectSoldierExp(heroId, level, toExp)
            self.lineUpData:changeCheerSoldierExp(heroId, level, toExp)
        else  -- 升级的

            local allExp = stageExp + exp + self.soldierTemplate:getHeroAllExpByLevel(level-1)  -- 累积量
            local curExp = exp

            local toLevel, toExp = self.soldierTemplate:getLevelByExpAll(allExp)

            local maxLevel = getDataManager():getCommonData():getLevel()
            print("tolevel = ",toLevel)
            if toLevel ~= nil and toLevel > maxLevel then  -- 限定到玩家等级的最大
                toLevel = maxLevel
                toExp = self.soldierTemplate:getHeroExpByLevel(maxLevel)
                print("tolevel = ",toLevel)
            end

            item.toExp = toExp
            item.toLevel = toLevel

            local curMaxExp = self.soldierTemplate:getHeroExpByLevel(level)
            local nextMaxExp = self.soldierTemplate:getHeroExpByLevel(toLevel)

            self.soldierData:changeSoldierExp(heroId, toLevel, toExp)
            self.lineUpData:changeSelectSoldierExp(heroId, toLevel, toExp)
            self.lineUpData:changeCheerSoldierExp(heroId, toLevel, toExp)
            ---战力提升
            self.commonData.updateCombatPower()
        end
        heroExpLists[#heroExpLists + 1] = item
    end

    return heroExpLists
end

function PVMopUp:createDropLists()
    local dropItemLists = {}
    for k, dropItem in pairs(self.drops) do
        local heros = dropItem.heros                --武将
        local equips = dropItem.equipments          --装备
        local items = dropItem.items                --道具
        local h_chips = dropItem.hero_chips         --英雄灵魂石
        local e_chips = dropItem.equipment_chips    --装备碎片
        local finance = dropItem.finance            --finance
        local stamina = dropItem.stamina

        local _itemList = {}  -- 将创建物件需要的数据暂存到_itemList中
        local _index = 1
        if heros ~= nil then
            for k,var in pairs(heros) do
                _itemList[_index] = {type = 101, detailId = var.hero_no, nums = 1}
                _index = _index + 1
            end
        end
        if equips ~= nil then
            for k,var in pairs(equips) do
                _itemList[_index] = {type = 102, detailId = var.no, nums = 1 , id = var.id}
                _index = _index + 1
            end
        end
        if h_chips ~= nil then
            for k,var in pairs(h_chips) do
                _itemList[_index] = {type = 103, detailId = var.hero_chip_no, nums = var.hero_chip_num}
                _index = _index + 1
            end
        end
        if e_chips ~= nil then
            for k,var in pairs(e_chips) do
                _itemList[_index] = {type = 104, detailId = var.equipment_chip_no, nums = var.equipment_chip_num}
                _index = _index + 1
            end
        end
        if items ~= nil then
            for k,var in pairs(items) do
                _itemList[_index] = {type = 105, detailId = var.item_no, nums = var.item_num}
                _index = _index + 1
            end
        end
        dropItemLists[#dropItemLists + 1] = _itemList
    end
    return dropItemLists
end

function PVMopUp:initView()
    self.UIMopUpView = {}
    self:initTouchListener()
    self:loadCCBI("instance/ui_mopup_view.ccbi", self.UIMopUpView)
    self.mopUpLayer = self.UIMopUpView["UIMopUpView"]["mopUpLayer"]
    self:initHeroExpView()
end

function PVMopUp:initHeroExpView()
    local cell = {}
    cell.heroImgs = {}
    cell.heroFrames = {}
    cell.heroProgress = {}
    cell.heroExpNums = {}
    cell.heroLevel = {}
    cell.aniNode = {}
    local ccbiRootNode = self.UIMopUpView["UIMopUpView"]
    for i=1, 6 do
        local strHead = "headSprite"..tostring(i)
        local strFrame = "headFrame"..tostring(i)

        local strExpNum = "expVlaue"..tostring(i)
        local strExpPro = "progress"..tostring(i)
        local strLevelVlaue = "levelVlaue"..tostring(i)
        local strAniNode = "aniNode" .. tostring(i)
        table.insert(cell.heroImgs, ccbiRootNode[strHead])
        table.insert(cell.heroFrames, ccbiRootNode[strFrame])
        table.insert(cell.heroExpNums, ccbiRootNode[strExpNum])
        table.insert(cell.heroProgress, ccbiRootNode[strExpPro])

        table.insert(cell.heroLevel, ccbiRootNode[strLevelVlaue])
        table.insert(cell.aniNode, ccbiRootNode[strAniNode])
    end
    self:showHeroWithExp(self.heroExpLists, cell)
end

function PVMopUp:initTouchListener()

    local function makeSureMenuClick()
       self.stageData:setIsMopUpOrResetStage(true)
       self:onHideView(self.saoType)
       --getNewGManager():startLevelUp()
    end

    local function xuanyaoBtnOnClick()
        -- self:onHideView()
    end

    self.UIMopUpView["UIMopUpView"] = {}

    self.UIMopUpView["UIMopUpView"]["makeSureMenuClick"] = makeSureMenuClick
    self.UIMopUpView["UIMopUpView"]["xuanyaoBtnOnClick"] = xuanyaoBtnOnClick
end

--
function PVMopUp:createTableView()
    local function tableCellTouched(tbl, cell)
        if self.touchEvent then
           if self.curDrop.type == 105 then -- item
                getOtherModule():showOtherView("PVCommonDetail", 1, self.curDrop.detailId, 1)
            elseif self.curDrop.type == 101 then --hero
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", self.curDrop.detailId, 101)
            elseif self.curDrop.type == 102 then --equipment
                local _equipment = self.c_EquipmentData:getEquipById(self.curDrop.id)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", _equipment, 101)
            elseif self.curDrop.type == 103 then --heroChip  
                getOtherModule():showOtherView("PVCommonChipDetail", 1, self.curDrop.detailId, self.curDrop.nums, 1) --1 herochip
            elseif  self.curDrop.type == 104 then --equipmentChip
                getOtherModule():showOtherView("PVCommonChipDetail", 2, self.curDrop.detailId, self.curDrop.nums, 1) --2 equipmentchip 
           end
           self.curDrop = nil
        end
    end
    local function numberOfCellsInTableView(tab)
        self.touchEvent = false
       return  table.nums(self.drops)
    end

    local function cellSizeForTable(tbl, idx)
        return 230,585
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local cardinfo = {}
            local proxy = cc.CCBProxy:create()

            local node = CCBReaderLoad("instance/ui_mopup_item.ccbi", proxy, cardinfo)
            cell:addChild(node)
            cell.timesMopUpSp = cardinfo["UIMopUpViewItem"]["timesMopUpSp"]

            -- cell.heroImgs = {}
            -- cell.heroFrames = {}
            -- cell.heroProgress = {}
            -- cell.heroExpNums = {}
            -- cell.heroLevel = {}
            -- cell.aniNode = {}
            -- local ccbiRootNode = cardinfo["UIMopUpViewItem"]
            -- for i=1, 6 do
            --     local strHead = "headSprite"..tostring(i)
            --     local strFrame = "headFrame"..tostring(i)

            --     local strExpNum = "expVlaue"..tostring(i)
            --     local strExpPro = "progress"..tostring(i)
            --     local strLevelVlaue = "levelVlaue"..tostring(i)
            --     local strAniNode = "aniNode" .. tostring(i)
            --     table.insert(cell.heroImgs, ccbiRootNode[strHead])
            --     table.insert(cell.heroFrames, ccbiRootNode[strFrame])
            --     table.insert(cell.heroExpNums, ccbiRootNode[strExpNum])
            --     table.insert(cell.heroProgress, ccbiRootNode[strExpPro])

            --     table.insert(cell.heroLevel, ccbiRootNode[strLevelVlaue])
            --     table.insert(cell.aniNode, ccbiRootNode[strAniNode])
            -- end

            cell.arrow_left = cardinfo["UIMopUpViewItem"]["arrow_left"]
            cell.arrow_right = cardinfo["UIMopUpViewItem"]["arrow_right"]
            cell.expLabel = cardinfo["UIMopUpViewItem"]["expLabel"]
            cell.goldLabel = cardinfo["UIMopUpViewItem"]["goldLabel"]
            cell.itemLayer = cardinfo["UIMopUpViewItem"]["itemLayer"]

        end
        --drops
        local dropList = self.dropLists[idx + 1]
        self:createDropTableView(dropList, cell)
        -- local heroExpList = self.heroExpLists[idx + 1]
        -- self:showHeroWithExp(heroExpList, cell)

        local urlStr = "#ui_mopup_00" .. (idx + 1) .. ".png"
        if idx + 1 == 10 then
            urlStr = "#ui_mopup_010.png"
        end

        game.setSpriteFrame(cell.timesMopUpSp, urlStr)
        local teamExp = self.instanceTemp:getClearanceExp(self.stageId)
        local teamMoney = self.instanceTemp:getClearanceMoney(self.stageId)

        cell.expLabel:setString(tostring(teamExp))
        cell.goldLabel:setString(tostring(teamMoney))
        return cell
    end

    local layerSize = self.mopUpLayer:getContentSize()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setBounceable(true)
    self.dropTableView:setTouchEnabled(true)
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.dropTableView:setDelegate()
    self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.mopUpLayer:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.dropTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.mopUpLayer:addChild(scrBar,2)

    self.dropTableView:reloadData()

end

function PVMopUp:showHeroWithExp(expList, cell)
    local heroImgs = cell.heroImgs
    local heroFrames = cell.heroFrames
    local heroProgress = cell.heroProgress
    local heroExpNums = cell.heroExpNums
    local heroLevel = cell.heroLevel
    local aniNode = cell.aniNode
    local function showHeroCard(pos, expItem) -- pos: 界面上左到右的头像位置
        print("showHeroCard==========", pos, expItem)
        local heroId = expItem.heroId
        local stageExp = expItem.stageExp
        local icon = self.soldierTemplate:getSoldierIcon(heroId)
        local quality = self.soldierTemplate:getHeroQuality(heroId)

        heroImgs[pos]:setTexture("res/icon/hero/"..icon)
        heroFrames[pos]:setSpriteFrame(getHeroIconQuality(quality))
        heroExpNums[pos]:setString("+"..tostring(stageExp))

        heroProgress[pos]:setVisible(false)

        -- exp progress timer
        local expProgress = cc.ProgressTimer:create(heroProgress[pos])
        expProgress:setAnchorPoint(cc.p(0, 0.5))
        expProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        expProgress:setMidpoint(cc.p(0, 0))
        expProgress:setBarChangeRate(cc.p(1, 0))
        expProgress:setPosition(heroProgress[pos]:getPosition())
        heroProgress[pos]:getParent():addChild(expProgress)

        -- exp action
        -- local soldierDataItem = self.soldierData:getSoldierExp(heroId)
        -- local _level = soldierDataItem.level
        -- local exp = soldierDataItem.exp

        local fromLevel = expItem.fromLevel
        local fromExp = expItem.fromExp
        local toLevel = expItem.toLevel
        print("----expItem.toLevel----",expItem.toLevel)
        print("----_level----",_level)
        heroLevel[pos]:setString("Lv." .. tostring(toLevel))

        local curLevelMaxExp = self.soldierTemplate:getHeroExpByLevel(fromLevel)
        local toExp = nil
        if stageExp + fromExp < curLevelMaxExp then   -- 不升级
            toExp = fromExp + stageExp
            local curPer = fromExp / curLevelMaxExp * 100
            local toPer = toExp / curLevelMaxExp * 100

            expProgress:setPercentage(curPer)
            expProgress:runAction(cc.ProgressFromTo:create(3, curPer, toPer))

        else  -- 升级的
            local seqAction = {}
            table.insert(seqAction, cc.DelayTime:create(1))

            local toExp = expItem.toExp
            local toLevel = expItem.toLevel

            local curMaxExp = self.soldierTemplate:getHeroExpByLevel(fromLevel)
            local nextMaxExp = self.soldierTemplate:getHeroExpByLevel(toLevel)

            for i=1, toLevel - fromLevel do
                local curPer = fromExp / curMaxExp * 100
                local toPer = 100
                fromExp = 0
                table.insert(seqAction, cc.ProgressFromTo:create(1, curPer, toPer))
            end
            local toPer = toExp / nextMaxExp * 100
            table.insert(seqAction, cc.ProgressFromTo:create(1, 0, toPer))

            expProgress:runAction(cc.Sequence:create( seqAction ))
            local node = UI_zhandoushengji()
            aniNode[pos]:addChild(node)
            node:setPosition(0, -18)
        end
    end

    for i=1, 6 do
        local expItem = expList[i]
        if expItem then
            showHeroCard(i, expItem)
        else
            heroImgs[i]:setVisible(false)
            heroFrames[i]:setVisible(false)
            heroProgress[i]:getParent():setVisible(false)
            heroExpNums[i]:setVisible(false)
            heroLevel[i]:getParent():setVisible(false)
        end
    end
end

--创建掉落列表
function PVMopUp:createDropTableView(dropList, cell)

    local arrow_left = cell.arrow_left
    local arrow_right = cell.arrow_right
    local itemLayer = cell.itemLayer
    itemLayer:removeAllChildren()
    -- 将dropList用tableView显示 --
    local function tableCellTouched(tbl, cell)
       cclog("cell item", cell:getIdx())
       local _idx = cell:getIdx()
       local _v = dropList[_idx+1]
       print("--_v.type--",_v.type)
       table.print(_v)
       self.curDrop = _v
       self.touchEvent = true
    end
    local function numberOfCellsInTableView(tab)
        self.touchEvent = false
       return table.nums(dropList)
    end
    local function cellSizeForTable(tbl, idx)
        return 110,105
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local cardinfo = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("common/ui_card_withnumber.ccbi", proxy, cardinfo)
            cell:addChild(node)
            cell.card = cardinfo["UICommonGetCard"]["img_card"]
            cell.card:setVisible(false)
            cell.number = cardinfo["UICommonGetCard"]["label_number"]
        end

        cell.number:setString("X "..tostring(dropList[idx+1].nums))
        cell.number:setLocalZOrder(10)

        local v = dropList[idx+1]

        local sprite = game.newSprite()
        if v.type < 100 then  -- 可直接读的资源图
            _temp = v.type
            local _icon = self._resourceTemp:getResourceById(_temp)
            setItemImage(sprite,"#".._icon,1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
                changeNewIconImage(sprite,_temp,quality)
            elseif v.type == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
                local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
                changeEquipIconImageBottom(sprite, _temp, quality)
            elseif v.type == 103 then -- hero chips
                _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(sprite,"res/icon/hero/".._icon, _quality)
            elseif v.type == 104 then -- equipment chips
                _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(sprite,"res/icon/equipment/".._icon, _quality)
            elseif v.type == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
                setCardWithFrame(sprite,"res/icon/item/".._temp,quality)
            end
        end

        cell.card:getParent():addChild(sprite)
        sprite:setPosition(53, 53)

        if self._flag_showArrow == true then
            if tbl:getContentOffset().x >= tbl:maxContainerOffset().x then
                arrow_left:setVisible(true)
                arrow_right:setVisible(false)
            elseif tbl:getContentOffset().x <= tbl:minContainerOffset().x then
                arrow_left:setVisible(false)
                arrow_right:setVisible(true)
            end
        end

        return cell
    end

    local layerSize = itemLayer:getContentSize()

    local dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    dropTableView:setBounceable(true)
    dropTableView:setTouchEnabled(true)
    dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    dropTableView:setDelegate()
    dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    itemLayer:addChild(dropTableView)

    dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    if table.nums(dropList) >= 4 then
        self._flag_showArrow = true
        arrow_left:setVisible(true)
        arrow_right:setVisible(true)
    else
        self._flag_showArrow = false
        arrow_left:setVisible(false)
        arrow_right:setVisible(false)
    end

    dropTableView:reloadData()
end

return PVMopUp
