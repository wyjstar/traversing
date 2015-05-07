local PVStarAwardView = class("PVStarAwardView", BaseUIView)

function PVStarAwardView:ctor(id)
    PVStarAwardView.super.ctor(self, id)
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

    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.commonData = getDataManager():getCommonData()
    self.dropTemp = getTemplateManager():getDropTemplate()
end

function PVStarAwardView:onMVCEnter()
    self:registerNetCallback()
    self:initData()
    self:initView()
    self:updateView()
    self:initTouchListener()
    -- self:startRunEffect()
end

function PVStarAwardView:initView()
    self.UIPrizeView = {}
    self:initTouchListener()
    self:loadCCBI("instance/ui_prize_view.ccbi", self.UIPrizeView)


    self.prizeSp1 = self.UIPrizeView["UIPrizeView"]["prizeSp1"]
    self.prizeSp2 = self.UIPrizeView["UIPrizeView"]["prizeSp2"]
    self.prizeSp3 = self.UIPrizeView["UIPrizeView"]["prizeSp3"]
    self.prizeSp4 = self.UIPrizeView["UIPrizeView"]["prizeSp4"]
    self.prizeSp5 = self.UIPrizeView["UIPrizeView"]["prizeSp5"]
    self.prizeSp6 = self.UIPrizeView["UIPrizeView"]["prizeSp6"]


    self.prizeKuang1 = self.UIPrizeView["UIPrizeView"]["prizeKuang1"]
    self.prizeKuang2 = self.UIPrizeView["UIPrizeView"]["prizeKuang2"]
    self.prizeKuang3 = self.UIPrizeView["UIPrizeView"]["prizeKuang3"]
    self.prizeKuang4 = self.UIPrizeView["UIPrizeView"]["prizeKuang4"]
    self.prizeKuang5 = self.UIPrizeView["UIPrizeView"]["prizeKuang5"]
    self.prizeKuang6 = self.UIPrizeView["UIPrizeView"]["prizeKuang6"]

    self.itemNumber1 = self.UIPrizeView["UIPrizeView"]["itemNumber1"]
    self.itemNumber2 = self.UIPrizeView["UIPrizeView"]["itemNumber2"]
    self.itemNumber3 = self.UIPrizeView["UIPrizeView"]["itemNumber3"]
    self.itemNumber4 = self.UIPrizeView["UIPrizeView"]["itemNumber4"]
    self.itemNumber5 = self.UIPrizeView["UIPrizeView"]["itemNumber5"]
    self.itemNumber6 = self.UIPrizeView["UIPrizeView"]["itemNumber6"]

    self.travelMenuItem = self.UIPrizeView["UIPrizeView"]["travelMenuItem"]

    self.prizeSpTable = {}
    table.insert(self.prizeSpTable, self.prizeSp1)
    table.insert(self.prizeSpTable, self.prizeSp2)
    table.insert(self.prizeSpTable, self.prizeSp3)
    table.insert(self.prizeSpTable, self.prizeSp4)
    table.insert(self.prizeSpTable, self.prizeSp5)
    table.insert(self.prizeSpTable, self.prizeSp6)

    self:updateMenuState(true)
    self.travelMenuItem:setEnabled(true)

    self.prizeKuangTable = {}
    table.insert(self.prizeKuangTable, self.prizeKuang1)
    table.insert(self.prizeKuangTable, self.prizeKuang2)
    table.insert(self.prizeKuangTable, self.prizeKuang3)
    table.insert(self.prizeKuangTable, self.prizeKuang4)
    table.insert(self.prizeKuangTable, self.prizeKuang5)
    table.insert(self.prizeKuangTable, self.prizeKuang6)

    self.itemNumber = {}
    table.insert(self.itemNumber, self.itemNumber1)
    table.insert(self.itemNumber, self.itemNumber2)
    table.insert(self.itemNumber, self.itemNumber3)
    table.insert(self.itemNumber, self.itemNumber4)
    table.insert(self.itemNumber, self.itemNumber5)
    table.insert(self.itemNumber, self.itemNumber6)

    self.startGetAward = self.UIPrizeView["UIPrizeView"]["startGetAward"]
    self.prizeHuaSp = self.UIPrizeView["UIPrizeView"]["prizeHuaSp"]
    self.lightSprite = self.UIPrizeView["UIPrizeView"]["lightSprite"]
    self.animationNode = self.UIPrizeView["UIPrizeView"]["animationNode"]

    self.starMenuTouch = self.UIPrizeView["UIPrizeView"]["starMenuTouch"]
    self.starMenuTouch:setTouchEnabled(false)
    self.posTable = {}
    for k, v in pairs(self.prizeKuangTable) do
        local x, y = v:getPosition()
        table.insert(self.posTable, cc.p(x, y))
    end
end

function PVStarAwardView:registerNetCallback()

    local function callBack(id, data)
        if data.res.result then
            self.dropData = data.drops
            self.awardInfo.dragon_gift = 1
            self:updateMenuState(false)
            self.travelMenuItem:setEnabled(false)
            self:startRunEffect()
        end
    end

    self:registerMsg(INST_STAR_RAFFLES_FULL, callBack)
end

function PVStarAwardView:initTouchListener()

    local function onCloseClick()
       self:onHideView()

       --stepCallBack(G_GUIDE_40115)     -- 40023 点击关闭
       groupCallBack(GuideGroupKey.BTN_CLOSE_REWARD)
    end

    local function onClick()
        self.startGetAward:setVisible(false)
        self.isFullStar = false
       getNetManager():getInstanceNet():sendStarRafflesFull(self.chapperIndex)
    end

    self.UIPrizeView["UIPrizeView"] = {}
    self.UIPrizeView["UIPrizeView"]["onCloseClick"] = onCloseClick
    self.UIPrizeView["UIPrizeView"]["onClick"] = onClick


    local function prizeOnClick1()
        self:onItemClick(1)
    end

    local function prizeOnClick2()
        self:onItemClick(2)
    end

    local function prizeOnClick3()
        self:onItemClick(3)
    end

    local function prizeOnClick4()
        self:onItemClick(4)
    end

    local function prizeOnClick5()
        self:onItemClick(5)
    end

    local function prizeOnClick6()
        self:onItemClick(6)
    end
    self.UIPrizeView["UIPrizeView"]["prizeOnClick1"] = prizeOnClick1
    self.UIPrizeView["UIPrizeView"]["prizeOnClick2"] = prizeOnClick2
    self.UIPrizeView["UIPrizeView"]["prizeOnClick3"] = prizeOnClick3
    self.UIPrizeView["UIPrizeView"]["prizeOnClick4"] = prizeOnClick4
    self.UIPrizeView["UIPrizeView"]["prizeOnClick5"] = prizeOnClick5
    self.UIPrizeView["UIPrizeView"]["prizeOnClick6"] = prizeOnClick6
end

function PVStarAwardView:initData()
    --self.data = self.funcTable[1]
    self.chapperIndex = self.funcTable[1]
    self.isFullStar = self.funcTable[2]

    local chapterItem = self.stageTemp:getChapterItemByChapterNo(self.chapperIndex)

    self.awardInfo = self.stageData:getAwardInfoByNo(self.chapperIndex)

    local dragon_gift = self.awardInfo.dragon_gift

    -- //龙纹奖励 -1:奖励没达成 0：奖励达成没有领取 1：已经领取
    if dragon_gift == 1 then
        self.isFullStar = false
    end

    local dragonGift = chapterItem.dragonGift

    local bagBagItem = self.dropTemp:getBigBagById(dragonGift)
    local smallBagIdList = bagBagItem.smallPacketId
    self.itemList = {}
    for k, smallDropId in pairs(smallBagIdList) do

        local smallBagItemList = self.dropTemp:getAllItemsByDropId(smallDropId)
        for m, n in pairs(smallBagItemList) do
            self.itemList[#self.itemList + 1] = n
        end
    end
    self.itemListSize = #self.itemList

    -- createDropLists()
end

function PVStarAwardView:updateMenuState(state)
     for i = 1, 6 do
        local prizeSp = self.prizeSpTable[i]
        prizeSp:setEnabled(state)
    end
end

function PVStarAwardView:updateView()
    for k, v in pairs(self.prizeKuangTable) do
        v:setVisible(false)
    end

    for i = 1, 6 do
        local itemData = self.itemList[i]
        local prizeSp = self.prizeSpTable[i]
        local normalSprite = self:createItemSprite(itemData)
        prizeSp:setNormalImage(normalSprite)
        self.itemNumber[i]:setString("X" .. itemData.count)
    end
    -- if self.isFullStar then

    -- end
    self.startGetAward:setVisible(self.isFullStar)
    self.prizeHuaSp:setVisible(false)
    self.lightSprite:setVisible(false)
end

function PVStarAwardView:createItemSprite(data)
    local v = data
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
            changeHeroChipIcon(sprite,_icon, _quality)
        elseif v.type == 104 then -- equipment chips
            _temp = self.chipTemp:getTemplateById(v.detailId).resId
            local _icon = self._resourceTemp:getResourceById(_temp)
            local _quality = self.chipTemp:getTemplateById(v.detailId).quality
            changeEquipChipIconImageBottom(sprite,_icon, _quality)
        elseif v.type == 105 then  -- item
            _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
            local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
            setItemImage3(sprite,_temp,quality)
        elseif v.type == 107 then  -- 资源 元气...
            local _icon = self._resourceTemp:getResourceById(v.detailId)
            setItemImageClick(sprite,"res/icon/resource/".._icon,1)
        elseif v.type == 108 then  -- 符文
            local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.detailId)
            setItemImageClick(sprite, _respng, _quality)
        end
    end
    return sprite
end

function PVStarAwardView:startRunEffect()
    
    local index = self:getSelectIndex()
    
    if index == nil then return end

    self.lightSprite:setVisible(true)
    self.prizeHuaSp:setVisible(true)

    local rotateBy1 = cc.RotateBy:create(1, 365)
    local rotateBy2 = cc.RotateBy:create(0.5, 365)

    local num = 10
    local tempDur = 1

    local actionTable = {}
    local timeTable = {}
    local tempDurTable = {1, 0.75, 0.7, 0.8, 1}
    local finalTimeTable = {0.5, 0.5, 0.7, 0.7, 0.8, 0.8}
    -- local tempDurTable = {0.7}
    local tempIndex = 1

    for i = 1, #tempDurTable do
        local rotateBy = cc.RotateBy:create(tempDurTable[i], 365)
        table.insert(actionTable, rotateBy)
    end
    if index ~= nil then
        for i = 1, index do
            local item = finalTimeTable[i]
            local rotateBy = cc.RotateBy:create(item, 60)
            table.insert(actionTable, rotateBy)
        end
    end

    local function finalShowCallBack()
        self.startGetAward:setVisible(false)
        self.prizeHuaSp:setVisible(false)
        self.lightSprite:setVisible(false)
        self.animationNode:removeAllChildren()
        local function callBack()
            self:updateMenuState(true)
            self.travelMenuItem:setEnabled(true)
            getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVStarAwardResult", self.dropData)
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(callBack)))
    end

    table.insert(actionTable, cc.CallFunc:create(finalShowCallBack))

    local sequenceAction = cc.Sequence:create(actionTable)

    self.lightSprite:runAction(sequenceAction)

    self.animationNode:removeAllChildren()
    self.animationNode:addChild(UI_Manxingchoujiang1())
    ------------------
    self:createKRun(tempDurTable, finalTimeTable, index)
end

function PVStarAwardView:createKRun(tempDurTable, finalTimeTable, index)

    local function changeLight(spender, args)
        --print("args.index====" .. args.index)
        self:changeLightKuang(args.index)
    end

    local function finalCallBack()
        local tempActionTable = {}
        for i = 1, index do
            local time = finalTimeTable[i]
            table.insert(tempActionTable, cc.CallFunc:create(changeLight, {index = i}))
            local delayTimeAction = cc.DelayTime:create(time)
            table.insert(tempActionTable, delayTimeAction)
        end
        local sequenceAction3 = cc.Sequence:create(tempActionTable)
        self:runAction(sequenceAction3)
    end


    local smallActionTable = {}
    for i = 1, #tempDurTable do
        local time = tempDurTable[i]

        local smallDur = time / 6

        local delayTimeAction = cc.DelayTime:create(smallDur)
        for i = 1, 6 do
            table.insert(smallActionTable, cc.CallFunc:create(changeLight, {index = i}))
            table.insert(smallActionTable, delayTimeAction:clone())
        end

    end
    table.insert(smallActionTable, cc.CallFunc:create(finalCallBack))
    local sequenceAction2 = cc.Sequence:create(smallActionTable)
    self:runAction(sequenceAction2)
end

function PVStarAwardView:changeLightKuang(index)
    self.prizeKuang1:setPosition(self.posTable[index])
    self.prizeKuang1:setVisible(true)

    self.prizeSpTable[index]:addChild(UI_Manxingchoujiang2())

    -- for i = 1, 6 do
    --     local item = self.posTable[i]

    --     -- if index == i then
    --     --     item:setVisible(true)
    --     -- else
    --     --     item:setVisible(false)
    --     -- end
    --     if index == i then
    --         self.prizeSp1:setPosition(item)
    --     end
    -- end
end

function PVStarAwardView:getSelectIndex()
    local heros = self.dropData.heros                --武将
    local equips = self.dropData.equipments          --装备
    local items = self.dropData.items                --道具
    local hero_chips = self.dropData.hero_chips         --英雄灵魂石
    local equip_chips = self.dropData.equipment_chips    --装备碎片
    local finance = self.dropData.finance            --finance
    local stamina = self.dropData.stamina
    -- local hero_chips = self.dropData.hero_chips
    local runt = self.dropData.runt                      --符文
    --武将碎片
    if hero_chips then
        print("hero_chips ================ ")
        table.print(hero_chips)
        for k, v in pairs(hero_chips) do
            local hero_chip_no = v.hero_chip_no
            local chipItem = self.soldierTemplate:getChipTempLateById(hero_chip_no)
            local combineResult = chipItem.combineResult
            for i = 1, #self.itemList do
                local item = self.itemList[i]
                local detailId = item.detailId
                if detailId == combineResult then
                    print("detailId ================ ", detailId,        i)
                    return i
                end
            end
        end
    end
    --武将
    if heros then
        print("heros ================ ")
        table.print(heros)
        for k, v in pairs(heros) do
            local hero_no = v.hero_no
            for i = 1, #self.itemList do
                local item = self.itemList[i]
                local detailId = item.detailId
                if detailId == hero_no then
                    print("detailId ================ ", detailId,        i)
                    return i
                end
            end
        end
    end

    --装备
    if equips then
        print("equips ================ ")
        table.print(equips)
        for k, v in pairs(equips) do
            local equip_id = v.id
            for i = 1, #self.itemList do
                local item = self.itemList[i]
                local detailId = item.detailId
                if detailId == equip_id then
                    print("detailId ================ ", detailId,        i)
                    return i
                end
            end
        end
    end

    --装备碎片
    if equip_chips then
        print("equip_chips ================ ")
        table.print(equip_chips)
        for k, v in pairs(equip_chips) do
            local equip_chip_no = v.equipment_chip_no
            local chipItem = self.soldierTemplate:getChipTempLateById(equip_chip_no)
            local combineResult = chipItem.combineResult
            for i = 1, #self.itemList do
                local item = self.itemList[i]
                local detailId = item.detailId
                if detailId == combineResult then
                    print("detailId ================ ", detailId,        i)
                    return i
                end
            end
        end
    end


    --道具
    if items then
        print("items ================ ")
        table.print(items)
        for k, v in pairs(items) do
            local item_id = v.item_no
            for i = 1, #self.itemList do
                local item = self.itemList[i]
                local detailId = item.detailId
                if detailId == item_id then
                    print("detailId ================ ", detailId,        i)
                    return i
                end
            end
        end
    end

    --元宝
    if finance then
        print("finance ================ ", finance)
        -- table.print(finance)
        for k, v in pairs(finance) do
            for i = 1, #self.itemList do
                local item = self.itemList[i]
                local detailId = item.detailId
                if detailId == 0 then
                    return i
                end
            end
        end

    end

    --符文
    if runt ~= nil then
        for k,v in pairs(runt) do
            local runt_id = v.runt_id
            for i = 1, #self.itemList do
                local item = self.itemList[i]
                local detailId = item.detailId
                if detailId == runt_id then
                    return i
                end
            end
        end
    end

    return nil
end

function PVStarAwardView:onItemClick(index)
    local v = self.itemList[index]
    -- local v = _itemList[cell:getIdx()+1]
    -- if v.type == 101 then -- 武将
    --     -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", v.detailId, 2, nil, 1)
    --     getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v.detailId, 2, nil, 1)
    -- elseif v.type == 102 then -- 装备
    --     local equipment = getTemplateManager():getEquipTemplate():getTemplateById(v.detailId)
    --     getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2)
    -- elseif v.type == 103 then -- 武将碎片
    --     local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(v.detailId)
    --     getOtherModule():showOtherView("PVCommonChipDetail", 1, v.detailId, nowPatchNum)
    -- elseif v.type == 104 then -- 装备碎片
    --     local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(v.detailId)
    --     getOtherModule():showOtherView("PVCommonChipDetail", 2, v.detailId, nowPatchNum)
    -- elseif v.type == 105 then  -- 道具
    --     getOtherModule():showOtherView("PVCommonDetail", 1, v.detailId, 1)
    -- elseif v.type == 107 then
    --     getOtherModule():showOtherView("PVCommonDetail", 2, v.detailId, 2)
    -- elseif v.type == 108 then
    --     local runeItem = {}
    --     runeItem.runt_id = v.detailId
    --     runeItem.inRuneType = getTemplateManager():getStoneTemplate():getStoneItemById(v.detailId)
    --     runeItem.runePos = 0
    --     getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
    -- end
    checkCommonDetail(v.type, v.detailId)
end

function PVStarAwardView:createDropLists()
    local dropItemLists = {}
    for k, dropItem in pairs(self.dropData) do
        local heros = dropItem.heros                --武将
        local equips = dropItem.equipments          --装备
        local items = dropItem.items                --道具
        local h_chips = dropItem.hero_chips         --英雄灵魂石
        local e_chips = dropItem.equipment_chips    --装备碎片
        local finance = dropItem.finance            --finance
        local stamina = dropItem.stamina
        local runt = dropItem.runt

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
                _itemList[_index] = {type = 102, detailId = var.no, nums = 1}
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

        --其他
        if finance ~= nil then
            -- local gold = finance.gold

            -- if gold and gold ~= 0 then

            --     _itemList[_index] = {type = 2, detailId = 0, nums = tonumber(gold)}
            --     _index = _index + 1
            -- end

            --更改获取资源数据结构
            local finance_changes = finance.finance_changes
            for k,v in pairs(finance_changes) do
                if v.item_no ~= nil then
                    _itemList[_index] = {type = v.item_type, detailId = v.item_no, nums = v.item_num}
                    _index = _index + 1
                end
            end
        end
        --符文
        if runt ~= nil then
            for k, var in pairs(runt) do
                _itemList[_index] = {type = 108, detailId = var.runt_no, nums = 1}
                _index = _index + 1
            end
        end

        dropItemLists[#dropItemLists + 1] = _itemList


    end
    return dropItemLists
end

return PVStarAwardView

















