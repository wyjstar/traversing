local EquipmentData = class("EquipmentData")

function EquipmentData:ctor(id)

    self.equipment = {}
    self.equipmentChips = {}

end

-- 将数据清掉
function EquipmentData:resetData()

    print("!!!!!! Reset Equipment Data ......")
    self.equipment = {}
    self.equipmentChips = {}
end

--
function EquipmentData:getStrengLv(equipId)
    return self.equipment[equipId].strengthen_lv
end
------------------------
function EquipmentData:getMainEquAttr(equipId)
    cclog("----- 主要属性 -------")
    -- table.print(self.equipment[equipId].main_attr)
    return self.equipment[equipId].main_attr
end
function EquipmentData:getMinorEquAttr(equipId)
    cclog("----- 次要属性 -------")
    -- table.print(self.equipment[equipId].minor_attr)
    return self.equipment[equipId].minor_attr
end
-------------------------

function EquipmentData:getStrengCoin(equipId)
    print("@!!!", equipId)
     -- table.print(self.equipment[equipId].data)
    print("@!!!")


    local data = self.equipment[equipId].data
    -- if data[1].cost_coin == nil then return 0 end
    local coin = 0
    local _ratio = getTemplateManager():getBaseTemplate():getReturnCoinRatio()
    print("----_ratio----",_ratio)
    for k,v in pairs(data) do
        -- print("----v.cost_coin-----",v)
        -- tabvle.print(v)
        if v ~= nil then
            if v.cost_coin ~= nil then
                coin = coin + v.cost_coin * _ratio
            end
        else
            coin = 0
        end
    end
    print("----_ratio----",coin)
    return coin
end

function EquipmentData:getEqu(equipId)
    return self.equipment[equipId]
end

-- 升级强化等级
function EquipmentData:setStrengLv(id, level)
    -- print("set string level ..")
    -- table.print(self.equipment)
    -- print(id)
    self.equipment[id].strengthen_lv = level
end

-- --改变装备等级
-- function EquipmentData:changeStrengLv(id, level)
--     -- print("set string level ..")
--     -- table.print(self.equipment)
--     -- print(id)
--     self.equipment[id].strengthen_lv = level
-- end

-- 获取装备前缀
function EquipmentData:getEquipPrefix(id)
    return self.languageTemp:getLanguageById(self.equipment[id].prefix) 
end

-- 改变装备强化过程
function EquipmentData:changeEnhance(id, data)
    -- print("set string level ..")
    -- table.print(self.equipment[id])
    --  print(id)
    local _data = self.equipment[id].data
    for k,v in pairs(_data) do
        table.insert(data,v)
    end
    -- local function sortEquipment(a,b)
    --     if a.cost_coin < b.cost_coin then
    --     return true
    -- end 
    -- print("---data-----")
    -- table.print(data)
    self.equipment[id].data = data
end


-- 添加一个装备数据
function EquipmentData:addEquip(equip)
    -- print("---------addEquip-----------")
    -- table.print(equip)

    self.equipment[equip.id] = equip
end

-- 添加一组装备碎片
function EquipmentData:addGroupEquipChip(equips)
    for k,v in pairs(equips) do
        self:addChip(v)
    end
    self:updateChipData()
end

-- 移除一个装备
function EquipmentData:subEquip(equip)
    print("移除了一个装备: ", equip.id)
    self.equipment[equip.id] = nil
end

-- 移除装备
-- @param id: 移除装备的ID
function EquipmentData:removeEquip(id)
    assert( self.equipment ~= nil, "remove Equipment: the key must exist !" )
    self.equipment[id] = nil
end

-- 获取所有装备数据
function EquipmentData:getEquipList() return self.equipment end

-- 获取某装备的所有属性
-- @param id: 查询的装备的ID
function EquipmentData:getEquipById(id) return self.equipment[id] end

-- 获取所有装备碎片
function EquipmentData:getChipsList() return self.equipmentChips end

-- 添加装备碎片
function EquipmentData:addChip(chip)
    if self.equipmentChips[chip.equipment_chip_no] == nil then
        self.equipmentChips[chip.equipment_chip_no] = chip
    else
        local temp = self.equipmentChips[chip.equipment_chip_no].equipment_chip_num
        self.equipmentChips[chip.equipment_chip_no].equipment_chip_num = temp + chip.equipment_chip_num
    end
    self:updateChipData()
end

-- 根据装备ID获取装备数量
function EquipmentData:getEquipNumById(id) 
    local _nums = 0
    for k,v in pairs(self.equipment) do
        if v.no == id then 
            _nums = _nums + 1
        end
    end
    return _nums
end


function EquipmentData:setEquipChipData(data)
    for k, v in pairs(data) do
        self.equipmentChips[v.equipment_chip_no] = v
    end
    self:updateChipData()
end

function EquipmentData:updateChipData()
    local isCanComOut = false
    for k, v in pairs(self.equipmentChips) do
        if v ~= nil then
            local equipment_chip_no = v.equipment_chip_no
            -- print("chip-crash:"..equipment_chip_no)
            local chipTemplateItem = getTemplateManager():getChipTemplate():getTemplateById(equipment_chip_no)
            local needNum = chipTemplateItem.needNum
            local equipment_chip_num = v.equipment_chip_num
            local isCanCom = equipment_chip_num >= needNum
            v.isCanCom = isCanCom
            if isCanCom then isCanComOut = true end
        end
    end
    local isCanCom = isCanComOut
    touchNotice(NOTICE_COM_EQUIP, isCanCom)
end

function EquipmentData:getIsComEquip()
     --print("getIsComEquip")
     --table.print(self.equipmentChips)
    -- print("getIsComEquip")
    local isCanCom = false
    for k, v in pairs(self.equipmentChips) do
        if v ~= nil then
            if v.isCanCom then
                isCanCom = true
                return isCanCom
            end
        end
    end
    return isCanCom
end

-- 减去碎片一定数量
function EquipmentData:subChips(id, num)
    if self.equipmentChips[id] == nil then print("装备碎片没有此id对应的碎片") return end
    self.equipmentChips[id].equipment_chip_num = self.equipmentChips[id].equipment_chip_num - num
    if self.equipmentChips[id].equipment_chip_num == 0 then -- 正好减完了，除掉本碎片数据
        self.equipmentChips[id] = nil
    elseif self.equipmentChips[id].equipment_chip_num < 0 then
        print("!!! 装备碎片数量为负数了 ！！！")
    end
    self:updateChipData()
end

-- 缓存下选择熔炼的装备的ids
function EquipmentData:setSmeltIDs( data )
    self.equipmentIds = data
end
function EquipmentData:getSmeltIDs()
    return self.equipmentIds
end
function EquipmentData:addSmeltID( id )
    if self.equipmentIds == nil then self.equipmentIds = {} end
    table.insert(self.equipmentIds, id)
end

function EquipmentData:getPatchNumById(id)
    for k, v in pairs(self.equipmentChips) do
        if v.equipment_chip_no == id then
            return v.equipment_chip_num
        end
    end
    return 0
end

--@return
return EquipmentData
