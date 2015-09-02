local LineupData = class("LineupData")

function LineupData:ctor(id)
    self.TYPE_LINK_HERO = 1
    self.TYPE_LINK_EQUIP = 2

    self.selectSoldier = {}
    self.cheerSoldier = {}
    self.embattleOrder = {}
    self.TravelItemChapter = {}
    self.legionLevel = 0
    -- self.selectSoldierEquip = {}
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_mineData = getDataManager():getMineData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_EquipmentData = getDataManager():getEquipmentData()

    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
end
--初始化布阵阵容
function LineupData:setEmbattleOrder(data)
    self.embattleOrder = data
end
--获得布阵的阵容
function LineupData:getEmbattleOrder()
    return self.embattleOrder
end

--保存设置布阵中的阵容，主要用于检测可用的无双
function LineupData:setEmbattleArray(data)
    self.embattleArray = data
end
function LineupData:getEmbattleArray()
    return self.embattleArray
end

--布阵中设置已选的无双
function LineupData:setEmbattleUnpar(data)
    cclog("--------setEmbattleUnpar-----"..data)
    self.unparId = data

end
--布阵中得到已选的无双的ID
function LineupData:getEmbattleUnpar()
    -- cclog("布阵中设置已选的无双".. self.unparId)
    return self.unparId
end
--获得当前上阵人数
function LineupData:getOnLineUpNum()
    local onLineUpNum = 0
    if self.selectSoldier ~= nil then
        for k,v in pairs(self.selectSoldier) do
            if v.hero.hero_no ~= 0 then
                onLineUpNum = onLineUpNum + 1
            end
        end
        return onLineUpNum
    end
end

--获得当前上阵武将装备
function LineupData:getOnLineUpEquip()
    local tab = {}
    if self.selectSoldier ~= nil then
        for k,v in pairs(self.selectSoldier) do
            if v.hero.hero_no ~= 0 then
                table.insert(tab, v.equs)
            end
        end
        return tab
    end
end

--获得当前上阵的英雄中是否含有军官套装
function LineupData:getOnLineUpEquipSuit(suitMaping)
    print("进入 ============ ")
    local isHave = false
    local tagNum = 0
    if self.selectSoldier ~= nil then
        for k,v in pairs(self.selectSoldier) do
            for m,n in pairs(v.equs) do
                if n.equ.no ~= 0 then
                    print("n.equ.no =================== ", n.equ.no)
                    for i,j in pairs(suitMaping) do
                        print("j ================ ", j)
                        if n.equ.no == j then
                            print("相等 ================ ")
                            tagNum = tagNum + 1
                            print("相加得出 ================ ", tagNum)
                        end
                    end
                    print("一次比较结束 tagNum ============== ", tagNum)
                end
            end
            if tagNum == table.getn(suitMaping) then
                print("装备齐全 ============ ")
                isHave = true
                break
            else
                print("进行下一次循环 ============= ")
                tagNum = 0
            end
        end
    end
    return isHave
end

--获得当前上阵武将列表
function LineupData:getOnLineUpList()
    local soldierList = {}
    if self.selectSoldier ~= nil then
        for k,v in pairs(self.selectSoldier) do
            if v.hero.hero_no ~= 0 then
                print("上阵的武将信息 ================= ")
                -- table.print(v.hero)
                table.insert(soldierList, v.hero)
            end
        end
        return soldierList
    end
end

--获得该武将装备在哪个武将
--equipId  == gid
function LineupData:getEquipTo(equipId)
    for k, v in pairs(self.selectSoldier) do
        local slotEquipment = v.equs
        for m, n in pairs(slotEquipment) do
            local id = n.equ.id
            if equipId == id then
                local heroId = v.hero.hero_no
                local heroName = self.c_SoldierTemplate:getHeroName(heroId)
                local quality = self.c_SoldierTemplate:getHeroQuality(heroId)
                local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
                return heroName, color
            end
        end
    end
    return Localize.query("equip.1")  -- 为找到有人装备了
end

--获得更换装备
function LineupData:getChangeEquip(seat)
    local typeTable = {1,2,3,4,5,6}
    local _equipTemp = getTemplateManager():getEquipTemplate()

    local equipmentTable = self.c_EquipmentData:getEquipList()

    local newEquipTable = {}
    for k, v in pairs(equipmentTable) do
        local equipGid = v.id
        local _type = _equipTemp:getTypeById(v.no)
        if _type == typeTable[seat] then
            local isIn = false
            for m, n in pairs(self.selectSoldier) do
                for p, q in pairs(n.equs) do
                    local equipmentPB = q.equ
                    local soldierGid = equipmentPB.id

                    if equipGid == soldierGid then
                        isIn = true
                    end
                end
            end
            if isIn == false then
                table.insert(newEquipTable, v)
            end
        end
    end

    return newEquipTable
end

function LineupData:filterMineSelectedEquipment(seat)
    local _equipmentData = self:getChangeEquip(seat)
    local _mineHeros = self.c_mineData:getMineGuardRequestHeros()


      for k1,v1 in pairs(_mineHeros) do  -- 武将信息
            for k2,v2 in pairs(v1.equipment_slots) do

                local k3 = 1
                while true do
                    local v3 = _equipmentData[k3]
                    if v3 == nil then
                        break
                    end

                    if v2.equipment_id == v3.id then
                        table.remove(_equipmentData, k3)
                        break
                    end

                    k3 = k3 + 1
                end

            end
        end

    return _equipmentData
end

--设置助威英雄
function LineupData:setCheerData(data)

    self.cheerSoldier = data
end

--改变英雄突破等级
function LineupData:changeSoldierBreakLV(soldierId, breakLV)
    local success = false
    for k, v in pairs(self.selectSoldier) do
        if v.hero.hero_no == soldierId then
            v.hero.break_level = breakLV
            success = true
        end
    end
    return success
end

--改变英雄突破等级
function LineupData:changeCheerSoldierBreakLV(soldierId, breakLV)
    local success = false
    for k, v in pairs(self.cheerSoldier) do
        if v.hero.hero_no == soldierId then
            v.hero.break_level = breakLV
            success = true
        end
    end
    return success
end

--改变英雄等级,经验
function LineupData:changeSelectSoldierExp(soldierId, level, exp)
    local success = false
    for k, v in pairs(self.selectSoldier) do
        if v.hero.hero_no == soldierId then
            v.hero.level = level
            v.hero.exp = exp
            success = true
            print("----success", exp, level)
        end
    end
    return success
end

--改变英雄等级,经验
function LineupData:changeCheerSoldierExp(soldierId, level, exp)
    local success = false
    for k, v in pairs(self.cheerSoldier) do
        if v.hero.hero_no == soldierId then
            v.hero.level = level
            v.hero.exp = exp
            success = true
            print("----success", exp, level)
        end
    end
    return success
end

--设置选择英雄数据
function LineupData:setSelectSoldierData(data)
    self.selectSoldier = data
    cclog(">>>>>>>>setSelectSoldierData>>>>>>>>>>>")
    -- table.print(self.selectSoldier)
    for k, v in pairs(data) do
        if v.hero ~= nil then
            local id = v.hero.hero_no
            local slot_no = v.slot_no
            print("slot_no=====" .. slot_no)
            print("id=========" .. id)
        end
    end
    print(">>>>>>>>>setSelectSoldierData>>>>>>>>>>")
end

--获得选择的英雄
function LineupData:getSelectSoldier()
    return self.selectSoldier
end

--获得助威英雄
function LineupData:getCheerSoldier()
    return self.cheerSoldier
end

--获得阵容上得英雄by id
function LineupData:getSelectSoldierById(id)

    for k, v in pairs(self.selectSoldier) do
        if v.hero.hero_no == id then
            return v
        end
    end
    return nil
end

--获得该座位号是否开启
function LineupData:getSelectIsOpenBySeat(seat)
    for k, v in pairs(self.selectSoldier) do
        local seatIndex = v.slot_no
        if seatIndex == seat then
            local activation = v.activation
            return activation
        end
    end
    return false
end

--获得该助威座位号是否开启
function LineupData:getCheerIsOpenBySeat(seat)

    for k, v in pairs(self.cheerSoldier) do
        local seatIndex = v.slot_no
        if seatIndex == seat then
            local activation = v.activation
            return activation
        end
    end
    return false
end

--获取当前装备位上的装备id，如果id == "" 则无装备
function LineupData:getEquipDataSeat(selectSeat, equipSeat)
    local slotItem = self:getSlotItemBySeat(selectSeat)
    local equs = slotItem.equs
    for k, v in pairs(equs) do
        local no = v.no
        if no == equipSeat then
            return v.equ.id
        end
    end

    return nil
end

--根据座位号获取英雄的heropb
function LineupData:getSlotItemBySeat(seatIndex)
    for k, v in pairs(self.selectSoldier) do
        local seat = v.slot_no
        if seat == seatIndex then
            return v
        end
    end
    return nil
end

--根据座位号获取助威英雄的heropb
function LineupData:getSlotCheerItemBySeat(seatIndex)
    for k, v in pairs(self.cheerSoldier) do
        local seat = v.slot_no
        if seat == seatIndex then
            return v
        end
    end
    return nil
end

--根据座位号获取英雄的heropb
function LineupData:getSlotItemBySeatfromSoldierData(hero_no)
    -- local changeSoldier = self:getChangeSoldier()
    -- table.print(changeSoldier)
    local changeSoldier = self.c_SoldierData:getSoldierData()
    -- table.print(changeSoldier)
    -- print("-----changeSoldier-----",table.nums(changeSoldier))
    for k, v in pairs(changeSoldier) do

        -- print("v.hero_no"..v.hero_no)

        if v.hero_no == hero_no then

            return v
        end
    end
    return nil
end

--根据装备id移除阵容里的装备
function LineupData:removeEquipOnHero(equipNo)

    print("################remove hero equip", equipNo)
    -- table.print(self.selectSoldier)

    for k, v in pairs(self.selectSoldier) do
        for _k,_v in pairs(v.equs) do
            if _v.equ.no == equipNo then _v = nil; return; end
        end
    end
end


--获得更换武将
--先获得所有武将，再除去已选择的武将
function LineupData:getChangeSoldier()
    local changeSoldierData = {}
    local soldierData = getDataManager():getSoldierData():getSoldierData()
    -- print("soldierData=="..table.nums(soldierData))
    local selectSoldierData = self:getSelectSoldier()
    for k, v in pairs(soldierData) do
        local isIn = false
        local soldierId = v.hero_no

        for m, n in pairs(selectSoldierData) do
            local activation = n.activation
            if activation == true then
                local hero = n.hero
                local heroId = hero.hero_no
                if soldierId == heroId then
                     isIn = true
                end
            end
        end

        if isIn == false then
            table.insert(changeSoldierData, v)
        end
    end

    return changeSoldierData
end

--获得更换助威英雄
--先获得更换武将，再除去已选助威武将
function LineupData:getChangeCheerSoldier()
    local changeSoldier = self:getChangeSoldier()
    --self.cheerSoldier
    print("changeSoldier=="..table.nums(changeSoldier))
    local changeCheerSoldier = {}
    for k, v in pairs(changeSoldier) do
        local isIn = false
        local soldierId = v.hero_no
        for m, n in pairs(self.cheerSoldier ) do
            local activation = n.activation
            if activation == true then
                local hero = n.hero
                local heroId = hero.hero_no
                if soldierId == heroId then
                     isIn = true
                end
            end
        end
        if isIn == false then
            table.insert(changeCheerSoldier, v)
        end
    end

    return changeCheerSoldier
end



-- 如果是符文秘境进入的过滤掉符文秘境中已选中的武将

function LineupData:filterMineSelectedSolider()
    -- local _soldierData = self:getChangeCheerSoldier()
    local _soldierData = self.c_SoldierData:getSoldierData()
    local _mineHeros = self.c_mineData:getMineGuardRequestHeros()
    -- local _soldierDataTem = clone(_soldierData)    is_guard
    -- print("-------_soldierData-----")
    -- table.print(_soldierData)
    for k,v in pairs(_mineHeros) do
        local k1 = 1
        while true do
            local v1 = _soldierData[k1]
            if v1 == nil then
                break
            end

            if v.hero_no == v1.hero_no then
                print(v.hero_no.."======_mineHeros===="..v1.hero_no)
                v1.is_guard = true
                -- table.remove(_soldierData, k1)
                break
            end

            k1 = k1 + 1
        end
    end
    return _soldierData
end

--根据英雄的id,获取羁绊信息
function LineupData:getLink(soldierId)
    local linkItem = self.c_SoldierTemplate:getLinkTempLateById(soldierId)
    if linkItem == nil then return nil end
    local linkTable = {}
    for i = 1, 5 do
        local triggerStr = "trigger" .. i       --触发条件
        local trigger = linkItem[triggerStr]
        local isTrigger = self:getIsTrigger(soldierId, trigger)

        if isTrigger then  --当前羁绊号，羁绊上了
            local linkItemTable = {}
            local nameStr = "linkname" .. i
            local name = linkItem[nameStr]

            local textStr = "linktext" .. i
            local text = linkItem[textStr]

            local linkStr = "link" .. i
            local link = linkItem[linkStr]

            linkItemTable.name = name
            linkItemTable.text = text
            linkItemTable.link = link
            linkItemTable.trigger = trigger
            table.insert(linkTable, linkItemTable)
        end
    end

    return linkTable--[soldierId]
end

function LineupData:setLinkForSoldier(soldierId, linkItem)
    if self.linkTable == nil then self.linkTable = {} end
    self.linkTable[soldierId] = linkItem
end

--判断是否触发羁绊
function LineupData:getIsTrigger(soldierId, trigger)
    if table.nums(trigger) == 0 then return false end
    for k, v in pairs(trigger) do
        -- print("getIsTrigger pairs", k, v)
        if v == 0 then
            return false
        end

        local tempRef = self:getIsLinkById(soldierId, v)   -- bug 应该为全满足才你能为true
        --如果有一个没有link上，就算没有link
        if tempRef == false then return false end
    end
    return true
end

--是否羁绊上
function LineupData:getIsLinkById(soldierId, id)

    local linkType = self:getNeedLinkType(id)
    if linkType == self.TYPE_LINK_EQUIP then --装备,判断该武将身上是否穿着有该装备
        --print("soldierId======" .. soldierId)
        local selectSoldierItem = self:getSelectSoldierById(soldierId)
        local equipTable = selectSoldierItem.equs
        for k, v in pairs(equipTable) do
            if v.equ.no == id then
                return true
            end
        end
    elseif linkType == self.TYPE_LINK_HERO then   --武将，判断阵容里是否有该武将，或者助威里是否有该武将
        --阵容里
        local selectSoldier = self:getSelectSoldier()
        for k, v in pairs(selectSoldier) do
            if v.hero ~= nil then
                if v.hero.hero_no == id then
                    return true
                end
            end
        end
        --助威里
        local cheerSoldier = self:getCheerSoldier()
        for k,v in pairs(cheerSoldier) do
            if v.hero.hero_no == id then
                return true
            end
        end
    end
    return false
end

--获得需要羁绊条件的类型
--id.int类型
function LineupData:getNeedLinkType(id)
    if id > 9999 then
        return self.TYPE_LINK_HERO
    elseif id > 999 then
        return self.TYPE_LINK_EQUIP
    end
    return -1
end

--无双列表数据
function LineupData:setWSListData(data)

    if data == nil then return end

    local list = getTemplateManager():getInstanceTemplate():getWSList()
    self.wsListData = {}
    for k,v in pairs(list) do
        self.wsListData[v.id] = {unpar_id=v.id, unpar_level=1}
    end

    for k,v in pairs(data) do
        if v.unpar_id and v.unpar_id ~= 0 then
            self.wsListData[v.unpar_id].unpar_level = v.unpar_level
        end
    end
end

function LineupData:getWS(wsId)
    local ref = self.wsListData[wsId]
    assert(ref, "无双Id不存在")
    return ref --table.getValueByIndex(self.wsListData, wsId)
end

function LineupData:getWSLevel(wsId)
    return self.wsListData[wsId].unpar_level
end

function LineupData:setWSLevel(wsId, level)
    local ref = self.wsListData[wsId]
    assert(ref, "无双Id不存在")
    self.wsListData[wsId].unpar_level = level
end

-- 获取阵容上的武将nos
function LineupData:getHeroNos()
    local hero_nos = {}
    for k, slot in pairs(self.selectSoldier) do
        table.insert(hero_nos, slot.hero.hero_no)
    end
    for k, slot in pairs(self.cheerSoldier) do
        table.insert(hero_nos, slot.hero.hero_no)
    end
    return hero_nos
end

-- 获取阵容槽上所有装备ids
function LineupData:getEquipIds(slot_no)
    local equ_ids = {}
    local line_up_slot = self:getSelectSoldierBySlotNo(slot_no)
    for _, equ_slot in pairs(line_up_slot.equs) do
        table.insert(equ_ids, equ_slot.equ.id)
    end
    return equ_ids
end

-- 获取阵容槽上所有装备nos
function LineupData:getEquipNos(line_up_slot)
    local equ_nos = {}
    for _, equ_slot in pairs(line_up_slot.equs) do
        local equ_no = equ_slot.equ.no
        if equ_no ~= nil and equ_no ~= 0 then
            table.insert(equ_nos, equ_slot.equ.no)
        end
    end
    return equ_nos
end
-- 获取阵容槽
function LineupData:getSelectSoldierBySlotNo(slot_no)
    for _, v in pairs(self.selectSoldier) do
        if v.slot_no == slot_no then
            return v
        end
    end
    return nil
end

-- 获取所有存在武将的阵容槽
function LineupData:getAllLineUpSlotHasHeros()
    local all = {}
    for _, slot in pairs(self.selectSoldier) do
        if slot ~= nil and slot.hero ~= nil and slot.hero.hero_no ~= 0 then
            table.insert(all, slot)
        end
    end
    return all

end

-- 获取所有存在武将的助威阵容槽
function LineupData:getAllCheerLineUpSlotHasHeros()
    local all = {}
    for _, slot in pairs(self.cheerSoldier) do
        if slot ~= nil and slot.hero ~= nil and slot.hero.hero_no ~= 0 then
            table.insert(all, slot)
        end
    end
    return all

end

-- 阵容中移除英雄 及全身装备
function LineupData:removeHeroOnline(soldierId)
    print("################remove hero online", soldierId)
    local onLineUpList = self:getOnLineUpList()
    local equipList = self:getOnLineUpEquip()
    for k, v in pairs(onLineUpList) do
        if v.hero.hero_no == soldierId then
            for m, n in pairs(v.hero.equs) do
                self:removeEquipOnHero(v.hero.equs.no)
            end
            v.hero = nil
        end
    end
end


-- 游历
function LineupData:setTravelItemChapter(data)
    self.TravelItemChapter = data
end

function LineupData:getGroupToItems()
    local group_items = {}
    if self.TravelItemChapter == nil then
        return group_items
    end
    for _, chapter in pairs(self.TravelItemChapter) do
        for _, item in pairs(chapter.travel_item) do
            if item.num > 0 then
                local group = getTemplateManager():getTravelTemplate():getItemGroupByDetailID(item.id)
                if group_items[group] == nil then
                    group_items[group] = {}
                end
                group_items[group][item.id] = item
            end
        end
    end
    return group_items
end


function LineupData:getGroupToItemsByStageID(stage_id)
    local group_items = {}
    if self.TravelItemChapter == nil then
        return group_items
    end
    for _, chapter in pairs(self.TravelItemChapter) do
        if chapter.stage_id == stage_id then
            for _, item in pairs(chapter.travel_item) do
                if item.num > 0 then
                    local group = getTemplateManager():getTravelTemplate():getItemGroupByDetailID(item.id)
                    if group_items[group] == nil then
                        group_items[group] = {}
                    end
                    group_items[group][item.id] = item
                end
            end
        end
    end
    return group_items
end
--
--获取符文
function LineupData:getRunesByType(hero, slotId)
    if hero == nil then
        print("hero no exists!")
        return
    end
    for _,runt_type in pairs(hero.runt_type) do
        if slotId == runt_type.runt_type then
            return runt_type.runt
        end
    end
    return nil
end

-- 同步符文
function LineupData:setRuneData(hero)
    if not hero then
        return
    end
    for k, slot in pairs(self.selectSoldier) do
        if slot.hero.hero_no == hero.hero_no then
            slot.hero = hero
        end
    end
    for k, slot in pairs(self.cheerSoldier) do
        if slot.hero.hero_no == hero.hero_no then
            slot.hero = hero
        end
    end
end
-- 公会等级
function LineupData:setLegionLevel(level)
    self.legionLevel = level
end

function LineupData:getLegionLevel()
    return self.legionLevel
end

-- 同步装备
function LineupData:changeEquipmentById(id)
    local _equip = self.c_EquipmentData:getEquipById(id)
    for k, v in pairs(self.selectSoldier) do
        for _k,_v in pairs(v.equs) do
            if _v.equ.id == id then
                _v.equ = _equip
                break
            end
        end
    end
end

-- 同步英雄
function LineupData:changeSoldierById(id)
    local _soldier = self.c_SoldierData:getSoldierDataById(id)
    for k, slot in pairs(self.selectSoldier) do
        if slot.hero.hero_no == id then
            slot.hero = _soldier
            break
        end
    end
    for k, slot in pairs(self.cheerSoldier) do
        if slot.hero.hero_no == id then
            slot.hero = _soldier
            break
        end
    end
end

-- 根据ID判断英雄是否在阵容或助威中   true 1 阵容  true 2 助威
function LineupData:judgeLineUpBySoldierId(id)
    for k, slot in pairs(self.selectSoldier) do
        if slot.hero.hero_no == id then
            return true , 1
        end
    end
    for k, slot in pairs(self.cheerSoldier) do
        if slot.hero.hero_no == id then
            return true , 2
        end
    end
end

-- 更新装备强化过程
function LineupData:setEquipmentStrengthInfo(data)
    getDataManager():getCommonData():subCoin(data.coin)
    self:setSelectSoldierData(data.line_up.slot)
    self:setCheerData(data.line_up.sub)
    local _equis = self:getEquipIds(data.slot_no)
    local _dataInfo = data.infos
    for k,v in pairs(_dataInfo) do
        if v ~= "" then
            local _index = v.slot_no
            local _id = _equis[_index]
            if _id ~= nil then
                print("---------infos-----------",_id,_index)
                table.print(v)
                local num = #v.data
                getDataManager():getEquipmentData():changeEnhance(_id,v.data)
                getDataManager():getEquipmentData():setStrengLv(_id, v.data[num].after_lv)
            end
        end
    end
end


return LineupData
