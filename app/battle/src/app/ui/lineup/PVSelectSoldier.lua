--选择英雄页面
local PVSelectSoldier = class("PVSelectSoldier", BaseUIView)

function PVSelectSoldier:ctor(id)
    PVSelectSoldier.super.ctor(self, id)
    self.selectId = -1
    self.selectType = -1
end

function PVSelectSoldier:onMVCEnter()
    self.UISelectSoldier = {}
    self.soldierData = {} --选择武将数据
    self:initTouchListener()

    self:loadCCBI("lineup/ui_select_soldoer.ccbi", self.UISelectSoldier)

    -- self.basicAttributeView = createBasicAttributeView()
    -- self:addChild(self.basicAttributeView)
    -- self.basicAttributeView:showView()

    self:initView()
    self.sodierData = getDataManager():getSoldierData()
    self.lineupData = getDataManager():getLineupData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()

    self:createListView()
    self:initData()
end

function PVSelectSoldier:initView()
    self.animationManager = self.UISelectSoldier["UISelectSoldier"]["mAnimationManager"]

    self.selectSoldierLayer = self.UISelectSoldier["UISelectSoldier"]["selectSoldierLayer"]
    self.hero_num = self.UISelectSoldier["UISelectSoldier"]["hero_num"]
end



function PVSelectSoldier:initData()
    self.selectType = self.funcTable[1]
    self.fromType = self.funcTable[2]

    if self.selectType == TYPE_SELECT_HERO then

        -- self.soldierData = self.lineupData:getChangeSoldier()

        self.soldierData = self.lineupData:getChangeCheerSoldier()

    elseif self.selectType == TYPE_SELECT_CHEER_HERO then
        self.soldierData = self.lineupData:getChangeCheerSoldier()

    end

    -- 如果是符文秘境进入的阵容
    if self.fromType ~= nil and (self.fromType == FROM_TYPE_MINE or  self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP) then
        self.soldierData = self.lineupData:filterMineSelectedSolider()
    end

    -- self.soldierData = self.lineupData:filterMineSelectedSolider()

     for k,v in pairs(self.soldierData) do
        local _quality = self.c_SoldierTemplate:getHeroQuality(v.hero_no)
        v.power = self.c_Calculation:CombatPowerSoldierSelf(v)
        v.quality = _quality

    end


    -- 如果是符文秘境进入的阵容
    if self.fromType ~= nil and (self.fromType == FROM_TYPE_MINE or  self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP) then
        local function sortByHeroIsGuard(itemA, itemB)
            --武将驻守
            local is_guardA = itemA.is_guard
            local is_guardB = itemB.is_guard
            if is_guardA == true and is_guardB == false then
                return true
            elseif is_guardA == false and is_guardB == true  then
                return false
            elseif is_guardA == is_guardB then
                 --武将品质(星级)
                local quality1 = itemA.quality
                local quality2 = itemB.quality
                --战斗力
                local power1 = itemA.power
                local power2 = itemB.power

                if power1 == power2 then
                    return quality1 > quality2
                else
                    return power1 > power2
                end
            end
        end
        table.sort(self.soldierData, sortByHeroIsGuard)
    else
        local function sortByHeroQuality(itemA, itemB)
            --武将品质(星级)
            local quality1 = itemA.quality
            local quality2 = itemB.quality
            --战斗力
            local power1 = itemA.power
            local power2 = itemB.power

            if power1 == power2 then
                return quality1 > quality2
            else
                return power1 > power2
            end
        end

        table.sort(self.soldierData, sortByHeroQuality)
    end
    local _num = table.nums(self.soldierData)
    self.hero_num:setString(tostring(_num))

    self.tableView:reloadData()
end

function PVSelectSoldier:initTouchListener()
    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self.selectData = -1
        self:hideView()
    end

    self.UISelectSoldier["UISelectSoldier"] = {}
    self.UISelectSoldier["UISelectSoldier"]["backMenuClick"] = backMenuClick
end

function PVSelectSoldier:createListView()
    local function tableCellTouched(tbl, cell)
        cclog("PVSelectSoldier cell touched at index: " .. cell:getIdx())
    end

    local function numberOfCellsInTableView(tab)
       return table.getn(self.soldierData)
    end

    local function cellSizeForTable(tbl, idx)

        return self.itemSize.height,self.itemSize.width
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = nil --tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function menuClick()
                getAudioManager():playEffectButton2()
                self.selectData = cell.selectSoldierId
                self:hideView(self.selectData)
                groupCallBack(GuideGroupKey.BTN_ADD_LINEUP, self.selectData)
            end

            local function onHeadClick()
                self.soldierDataItem = table.getValueByIndex(self.soldierData, cell.index + 1)
                local soldierId = self.soldierDataItem.hero_no
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", soldierId, 2, nil, 1)
            end
            --符文查看选择
            local function onChooseClick()
                print("onChooseClick ============ ")
            end

            cell.cardinfo = {}
            cell.starTable = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISelectItem"] = {}
            cell.cardinfo["UISelectItem"]["menuClick"] = menuClick
            cell.cardinfo["UISelectItem"]["onHeadClick"] = onHeadClick
            cell.cardinfo["UISelectItem"]["onChooseClick"] = onChooseClick
            local node = CCBReaderLoad("lineup/ui_select_soldier_item.ccbi", proxy, cell.cardinfo)

            local starSelect1 = cell.cardinfo["UISelectItem"]["starSelect1"]
            local starSelect2 = cell.cardinfo["UISelectItem"]["starSelect2"]
            local starSelect3 = cell.cardinfo["UISelectItem"]["starSelect3"]
            local starSelect4 = cell.cardinfo["UISelectItem"]["starSelect4"]
            local starSelect5 = cell.cardinfo["UISelectItem"]["starSelect5"]
            local starSelect6 = cell.cardinfo["UISelectItem"]["starSelect6"]

            table.insert(cell.starTable, starSelect1)
            table.insert(cell.starTable, starSelect2)
            table.insert(cell.starTable, starSelect3)
            table.insert(cell.starTable, starSelect4)
            table.insert(cell.starTable, starSelect5)
            table.insert(cell.starTable, starSelect6)

            cell:addChild(node)
        end

        cell.index = idx

        self.soldierDataItem = table.getValueByIndex(self.soldierData, cell.index + 1)
        local soldierId = self.soldierDataItem.hero_no
        cell.selectSoldierId = soldierId

        local break_level = self.soldierDataItem.break_level
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
        local nameStr = soldierTemplateItem.nameStr

        local name = self.c_LanguageTemplate:getLanguageById(nameStr)

        local quality = soldierTemplateItem.quality
        local level = self.soldierDataItem.level
        local finnalLevel = "Lv." .. string.format(level)
        local sodierName = cell.cardinfo["UISelectItem"]["sodierName"]  --名称
        local lvBMLabel = cell.cardinfo["UISelectItem"]["lvBMLabel"]     --等级
        local headIcon = cell.cardinfo["UISelectItem"]["headIcon"]       --头像
        local itemBg = cell.cardinfo["UISelectItem"]["itemBg"]       --头像
        local fightNum = cell.cardinfo["UISelectItem"]["fightNum"]       --战力
        

        local yiZhuShouSprite = cell.cardinfo["UISelectItem"]["yiZhuShouSprite"]
        local zhuangbeiBtn = cell.cardinfo["UISelectItem"]["selectBtn"]

        local selectMenu = cell.cardinfo["UISelectItem"]["selectMenu"]              --上阵

        local chooseMenu = cell.cardinfo["UISelectItem"]["chooseMenu"]              --选择

        if  self.fromType ~=nil and (self.fromType == FROM_TYPE_MINE or self.fromType==FROM_TYPE_MINE_CHANGE_LINEUP) and self.soldierDataItem.is_guard~= nil and self.soldierDataItem.is_guard == true then
            yiZhuShouSprite:setVisible(true)
            zhuangbeiBtn:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(zhuangbeiBtn:getNormalImage())
        end

        fightNum:setString(roundAttriNum(self.soldierDataItem.power))
        sodierName:setString(name)
        lvBMLabel:setString(finnalLevel)
        updateStarLV(cell.starTable, quality)
        -- print("--------sodierName--------",name)
        -- print("-----------power--------------",self.soldierDataItem.power)
        local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)
        changeNewSoldierIconImage(headIcon, resIcon, quality, itemBg) --更新icon

        return cell
    end

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("lineup/ui_select_soldier_item.ccbi", proxy, tempTable)

    local sizeLayer = tempTable["UISelectItem"]["sizeLayer"]

    self.itemSize = sizeLayer:getContentSize()

    local layerSize = self.selectSoldierLayer:getContentSize()
    self.tableView = cc.TableView:create(layerSize)

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.selectSoldierLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.tableView:setTouchEnabled(true)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.selectSoldierLayer:addChild(scrBar,2)

    -- local posX,posY = self.selectSoldierLayer:getPosition()
    -- local size = self.selectSoldierLayer:getContentSize()

    -- local rectArea = cc.rect(posX, posY, size.width, size.height)
    -- self.selectSoldierColorLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    -- self.selectSoldierColorLayer:setTouchEnabled(true)
    -- local function onTouchEvent(eventType, x, y)
    --     if eventType == "began" then
    --         local isInRect = cc.rectContainsPoint(rectArea, cc.p(x,y))
    --         if isInRect then
    --             return false
    --         end
    --         return true
    --     elseif  eventType == "ended" then
    --         local isInRect = cc.rectContainsPoint(rectArea, cc.p(x,y))
    --         if isInRect == false then
    --             self.selectId = -1
    --             self:hideView()
    --         end
    --     end
    -- end
    -- self.selectSoldierColorLayer:registerScriptTouchHandler(onTouchEvent)
end

function PVSelectSoldier:hideView()
    self:onHideView(self.selectData)
end

--更新星级
function PVSelectSoldier:updateStarLV(starTable, level)
    for k, v in pairs(starTable) do
        if k > level then
            v:setVisible(false)
        else
            v:setVisible(true)
        end
    end
end

return PVSelectSoldier
