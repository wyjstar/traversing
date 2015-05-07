--数据处理器
--负责将服务器接收的数据统一往DataCenter存取

local DataProcessor = class("DataProcessor")

function DataProcessor:ctor()
    self.soldierData = getDataManager():getSoldierData()
    self.equipData = getDataManager():getEquipmentData()
    self.bagData = getDataManager():getBagData()
    self.commonData = getDataManager():getCommonData()
    self.commonResponseData = {}
    self.tempNetData = {} --存储发送过的协议
    self.createResult = nil                     --战队创建结果
end

function DataProcessor:pushNetData(id, data)
    self.tempNetData[id] = data
end

function DataProcessor:getNetData(id)
    return self.tempNetData[id]
end

--战队创建返回数据
function DataProcessor:setCreateResult(data)
    self.createResult = data
    --assert(self.createResult.result == true)
end
--创建战队结果
function DataProcessor:getCreateResult()
    return self.createResult
end

--其他
function DataProcessor:setCommonResponse(data)
    self.commonResponseData = data
end

--其他
function DataProcessor:getCommonResponse()
    if self.commonResponseData ~= nil then
        return self.commonResponseData
    else
        return nil
    end
end

--增加GameResourcesResponse参数数据到DataCenter
function DataProcessor:gainGameResourcesResponse( data )
    -- print("------------gainGameResourcesResponse-----------------")
    -- -- table.print(data)
    -- print("------------gainGameResourcesResponse-----------------")
    print("<<<== 处理GameResourcesResponse ==>>>")
    local heros = data.heros                --武将
    local equips = data.equipments          --装备
    local items = data.items                --道具
    local h_chips = data.hero_chips         --英雄灵魂石
    local e_chips = data.equipment_chips    --装备碎片
    local finance = data.finance            --finance
    local stamina = data.stamina
    local teamExp = data.team_exp
    -- local equip_soul = finances[1].item_num

    if heros ~= nil and table.nums(heros)>0  then
        for k,var in pairs(heros) do
            print("process ... heros data ", k, var)
            print(var.hero_no)
            self.soldierData:addData(var)
        end
    end
    if equips ~= nil and table.nums(equips)>0 then
        for k,var in pairs(equips) do
            print("process ... equipment data ", k, var)
            self.equipData:addEquip(var)
        end
    end
    if items ~= nil and table.nums(items)>0  then
        cclog("道具输出 ========================== ")
        self.bagData = getDataManager():getBagData()
        -- print(self.bagData)
        -- table.print(items)
        self.bagData:setItemByOtherWay(items)  --添加背包中的道具数据
    end
    if h_chips ~= nil and table.nums(h_chips)>0  then
        for k,var in pairs(h_chips) do
            print("process ... hero chips data ", k, var)
            self.soldierData:addPatchItem(var)  -- addSoldierChips
        end
    end

    if e_chips ~= nil and table.nums(e_chips)>0 then
        -- for k,var in pairs(e_chips) do
        --     print("process ... equipment chips data ", k, var)
        --     print("---e_chips----"..var.equipment_chip_no.."---"..var.equipment_chip_num)
        --     -- self.equipData:addChip(var)
        -- end
         self.equipData:addGroupEquipChip(e_chips)
    end
    if stamina~= nil and stamina ~= 0 and stamina>0 then
        getDataManager():getCommonData():addStamina(stamina)
        -- getHomeBasicAttrView():updateStamina()
    end

    if teamExp ~= nil and teamExp ~= 0 and teamExp > 0 then
        getDataManager():getCommonData():addExp(teamExp)
    end

    if finance ~= nil then
        cclog("-------------------")
        self.commonData = getDataManager():getCommonData()
        print("%%%%%%%% coin", finance.coin)
        print("%%%%%%%% gold", finance.gold)
        if finance.coin ~= nil and finance.coin>0 then self.commonData:addCoin(finance.coin) end
        if finance.gold ~= nil and finance.gold>0 then self.commonData:addGold(finance.gold) end
        if finance.hero_soul ~= nil then self.commonData:addFinance(3, finance.hero_soul) end
        if finance.junior_stone ~= nil and finance.junior_stone>0 then self.commonData:addJuniorStone(finance.junior_stone) end
        if finance.middle_stone ~= nil and finance.middle_stone>0 then self.commonData:addMiddleStone(finance.middle_stone) end
        if finance.high_stone ~= nil and finance.high_stone>0 then self.commonData:addHighStone(finance.high_stone) end
        -- if finance.stamina -- to do
        if finance.finance_changes ~= nil then
            for k,v in pairs(finance.finance_changes) do
                print("DataProcessor finance: ",v.item_type, v.item_no, v.item_num)
                self.commonData:addFinance(v.item_no, v.item_num)
                -- if v.item_no == 3 then
                --     print("DataProcessor finance 武魂: ",v.item_type, v.item_no, v.item_num)
                --     print(self.commonData:getFinance(3))
                -- end
                -- if v.item_type == 107 and v.item_no == 16 then
                --     --self.commonData:addFinance(v.item_no, v.item_num)
                --     self.commonData:addStamina(v.item_num)
                -- end
                -- if v.item_type == 107 and v.item_no == 21 then
                --     --self.commonData:addFinance(v.item_no, v.item_num)
                --     self.commonData:addEquipSoul(v.item_num)
                -- end
            end
        end
    end
    print("<<<== 处理GameResourcesResponse over________==>>>")
end

-- 获取GameResources
function DataProcessor:getGameResourcesResponse( data )
    cclog("<<<== getGameResourcesResponse ==>>>")
    local array = {}

    local heros = data.heros                --武将
    local equips = data.equipments          --装备
    local items = data.items                --道具
    local h_chips = data.hero_chips         --英雄灵魂石
    local e_chips = data.equipment_chips    --装备碎片
    local finance = data.finance            --finance
    local stamina = data.stamina
    local _travel_item = data.travel_item
    local _shoes_info = data.shoes_info

    if heros ~= nil and table.nums(heros)>0 then
        heros.type = "heros"
        table.insert(array, heros)
    end
    if equips ~= nil and table.nums(equips)>0 then
        equips.type = "equips"
        table.insert(array, equips)
    end
    if items ~= nil and table.nums(items)>0 then
        items.type = "items"
        table.insert(array, items)
    end
    if h_chips ~= nil and table.nums(h_chips)>0 then
        h_chips.type = "h_chips"
        table.insert(array, h_chips)
    end
    if e_chips ~= nil and table.nums(e_chips)>0 then
        e_chips.type = "e_chips"
        table.insert(array, e_chips)
    end
    if finance ~= nil and (finance.coin>0 or finance.gold>0 or finance.hero_soul>0 or finance.junior_stone>0 or finance.middle_stone>0 or (finance.finance_changes ~= nil and table.nums(finance.finance_changes)>0) ) then
        cclog("--finance.type----")
        print(finance)
        finance.type = "finance"
        table.insert(array, finance)
    end
    if stamina ~= 0 then
        table.insert(array, stamina)
    end
    if _travel_item ~= nil and table.nums(_travel_item)>0 then
         cclog("=======_travel_item ~= nil =========")
        _travel_item.type = "travel_item"
        table.insert(array, _travel_item)
    end
    if _shoes_info ~= nil and table.nums(_shoes_info)>0 then
        _shoes_info.type = "shoes_info"
        table.insert(array, _shoes_info)
    end

    return array
end

--消耗GameResourcesResponse数据
function DataProcessor:consumeGameResourcesResponse( data )

    print("<<<== 处理GameResourcesResponse ==>>>")

    local heros = data.heros                --武将
    local equips = data.equipments          --装备
    local items = data.items                --道具
    local h_chips = data.hero_chips         --英雄灵魂石
    local e_chips = data.equipment_chips    --装备碎片
    local finance = data.finance            --finance

    if heros then
        for k,var in pairs(heros) do
            print("process ... heros data ", k, var)
            self.soldierData:subData(var)
        end
    end
    if equips then
        for k,var in pairs(equips) do
            print("process ... equipment data ", k, var)
            self.equipData:subEquip(var)
        end
    end
    if items then
        for k,v in pairs(items) do
            getDataManager():getBagData():updatePropItem(v.item_no, v.item_num)
        end
    end
    if h_chips then
        for k,v in pairs(h_chips) do
            self.soldierData:changeChipNum(v.hero_chip_no, v.hero_chip_num)
        end
    end
    if e_chips then
        for k,var in pairs(e_chips) do
            self.equipData:subChips(var.equipment_chip_no, var.equipment_chip_num)
        end
    end
    if finance then
        -- to do
        if finance.coin ~= nil and finance.coin>0 then self.commonData:subCoin(finance.coin) end
        if finance.gold ~= nil and finance.gold>0 then self.commonData:subGold(finance.gold) end

    end

end

--[[
function DataProcessor:onDealWithData(data)

    self.heroData = data.heros

    if table.nums(self.heroData) ~= 0 then
        print("heroData =========== update ===========")
    else
        print("heroData =========== no update ===========")
    end

    self.equipmentData = data.equipments

    if table.nums(self.equipmentData) ~= 0 then
        print("equipmentData =========== update ===========")
    else
        print("equipmentData =========== no update ===========")
    end

    self.itemData = data.items

    if table.nums(self.itemData) ~= 0 then
        print("itemData =========== update ===========")
    else
        print("itemData =========== no update ===========")
    end

    self.heroChipData = data.hero_chips

    if table.nums(self.heroChipData) ~= 0 then
        print("heroChipData =========== update ===========")
    else
        print("heroChipData =========== no update ===========")
    end

    self.equipmentChipData = data.equipment_chips

    if table.nums(self.equipmentChipData) ~= 0 then
        print("equipmentChipData =========== update ===========")
    else
        print("equipmentChipData =========== no update ===========")
    end

    self.financeData = data.finance

    if table.nums(self.financeData) ~= 0 then
        print("financeData =========== update ===========")
    else
        print("financeData =========== no update ===========")
    end
end

--获得
function DataProcessor:setResourcesResponseGainData(data)
    self:onDealWithData(data)
end

--消耗
function DataProcessor:setResourcesResponseConsumeData(data)
    self:onDealWithData(data)
end
]]


--@return
return DataProcessor
