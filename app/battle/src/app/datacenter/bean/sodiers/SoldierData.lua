SoldierData = SoldierData or class("SoldierData")

function SoldierData:ctor()
    self.soldierData = {} --从网络接受来的数据
    self.soldierIsNewData = {}
    self.patchData = {} --碎片数据
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_ResourceData = getDataManager():getResourceData()
end

--设置从网络过来的协议
function SoldierData:setSoldierData(soldierDataTable)
    self.soldierData = soldierDataTable
    --加载plist文件
    -- for k, v in pairs(soldierDataTable) do
    --     -- v.isNew = false
    --     print(v.hero_no.."-------")
    --     print(v.is_guard)
    -- end
    -- print("setSoldierData")
    self:updatePatchData()
end

function SoldierData:loadHeroImage(soldierId)
    local heroItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local resPicture = heroItem.resPicture

    local imageName = self.c_ResourceTemplate:getPathNameById(resPicture)
    self.c_ResourceData:loadHeroImageDataById(imageName)
end

function SoldierData:clearHeroImagePlist()
    for k, v in pairs(self.soldierData) do

        local heroItem = self.c_SoldierTemplate:getHeroTempLateById(v.hero_no)
        local resPicture = heroItem.resPicture

        local imageName = self.c_ResourceTemplate:getPathNameById(resPicture)
        self.c_ResourceData:removeHeroImageDataById(imageName)
    end
end

function SoldierData:clearHeroImagePVR()
    for k, v in pairs(self.soldierData) do

        local heroItem = self.c_SoldierTemplate:getHeroTempLateById(v.hero_no)
        local resPicture = heroItem.resPicture

        local imageName = self.c_ResourceTemplate:getPathNameById(resPicture)
        self.c_ResourceData:removeHeroImagePVRDataById(imageName)
    end
end

--减少一个武将
function SoldierData:subData(itemData)
    -- print("－－－－－－－－－－ 减少一个武将 －－－－－－－－ －－－－－－－－  "..itemData.hero_no)
    for k, v in pairs(self.soldierData) do
        if v.hero_no == itemData.hero_no then
            table.remove(self.soldierData, k)
        end
    end

    self:removeSoldierIsNewList(itemData.hero_no)
    
    self:updatePatchData()
end

--增加一个武将
function SoldierData:addData(itemData)

    for k,v in pairs(self.soldierData) do
        if itemData.hero_no == v.hero_no then
            print("重复添加相同武将")
            return
        end
    end
    table.insert(self.soldierData, itemData)

    local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(itemData.hero_no)
    if  quality == 5 or quality == 6 then
        -- print("－－－－－－－－－－ 添加头像列表 －－－－－－－－ －－－－－－－－".. itemData.hero_no)
        getDataManager():getCommonData():addHeadLIstId(itemData.hero_no) 
    end
    -- print("－－－－－－－－－－ 添加武将 －－－－－－－－ －－－－－－－－")
    self:addSoldierIsNewList(itemData.hero_no, true)

    -- print("addData====")
    self:updatePatchData()
end

--设置碎片数据
function SoldierData:setPatchData(_patchData)
    self.patchData = nil
    self.patchData = _patchData
    -- print("setPatchData====")
    self:updatePatchData()
end

--改变英雄突破等级
function SoldierData:changeSoldierBreakLV(soldierId, breakLV)
    local success = false
    for k, v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            v.break_level = breakLV
            success = true
        end
    end
    return success
end
--改变英雄突破等级
function SoldierData:getSoldierBreakLV(soldierId)
    local level = 0
    for k, v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            level = v.break_level
        end
    end
    return level
end
-- self.soldierIsNewData = {}
--新武将列表中添加武将
function SoldierData:addSoldierIsNewList(soldierId, isNew)
    local data = {}
    data.hero_no = soldierId
    data.isNew =  isNew
    table.insert(self.soldierIsNewData , data)
    -- print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   self.soldierIsNewData   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    -- table.print(self.soldierIsNewData)
end
--新武将列表中删除武将
function SoldierData:removeSoldierIsNewList(soldierId)
    -- print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   self.soldierIsNewData   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    -- table.print(self.soldierIsNewData)
    for k, v in pairs(self.soldierIsNewData) do
        if v.hero_no == soldierId then
            -- print("删除武将新列表"..v.hero_no)
            table.remove(self.soldierIsNewData, k)
        end
    end
    table.print(self.soldierIsNewData)
    -- print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   self.soldierIsNewData   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
end
--返回 武将是否为新武将
function SoldierData:getSoldierIsNew(soldierId)
    local _isNew = false
    for k, v in pairs(self.soldierIsNewData) do
        if v.hero_no == soldierId then
            _isNew = v.isNew
        end
    end
    return _isNew
end


--改变英雄等级,经验
function SoldierData:changeSoldierExp(soldierId, level, exp)
    local success = false
    for k, v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            v.level = level
            v.exp = exp
            success = true
            print("-----success---",exp,    level)
        end
    end
    return success
end

-- 获得武将的经验
function SoldierData:getSoldierExp(soldierId)
    for k, v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            return v
        end
    end
    return "@@@@@@@"
end


---------------------------
--炼体

-- 获得武将当前练体到达的穴道ID
function SoldierData:getSealById(soldierId)
    for k, v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            return v.refine
        end
    end
    return "@@@@@@@"
end

function SoldierData:setSealById(soldierId, refineId)
    for k, v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            v.refine = refineId
        end
    end
end

--获得炼体HP附加属性
function SoldierData:getHPFromSeal(soldierId)
    local ref = 0
    local sealId = nil
    for k,v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            sealId = v.refine
        end
    end
    if sealId == nil then return 0 end
    for k,v in pairs(seal_config) do
        if v.id <= sealId then
            if v.hp ~= 0 then ref = ref + v.hp end
        end
    end
    return ref
end
--获得炼体Attacks附加属性
function SoldierData:getAtkFromSeal(soldierId)
    local ref = 0
    local sealId = nil
    for k,v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            sealId = v.refine
        end
    end
    if sealId == nil then return 0 end
    for k,v in pairs(seal_config) do
        if v.id <= sealId then
            if v.atk ~= 0 then ref = ref + v.atk end
        end
    end
    return ref
end

--获得炼体Pdef附加属性
function SoldierData:getPdefFromSeal(soldierId)
    local ref = 0
    local sealId = nil
    for k,v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            sealId = v.refine
        end
    end
    if sealId == nil then return 0 end
    for k,v in pairs(seal_config) do
        if v.id <= sealId then
            if v.physicalDef ~= 0 then ref = ref + v.physicalDef end
        end
    end
    return ref
end

--获得炼体Mdef附加属性
function SoldierData:getMdefFromSeal(soldierId)
    local ref = 0
    local sealId = nil
    for k,v in pairs(self.soldierData) do
        if v.hero_no == soldierId then
            sealId = v.refine
        end
    end
    if sealId == nil then return 0 end
    for k,v in pairs(seal_config) do
        if v.id <= sealId then
            if v.magicDef ~= 0 then ref = ref + v.magicDef end
        end
    end
    return ref
end

---------------------------
--符文




--获得碎片数据
function SoldierData:getPatchData()
    return self.patchData
end

--添加一组武将碎片
function SoldierData:addGroupPatchItem(items)
    for k,v in pairs(items) do
        self:addPatchItem(v)
    end
end

--添加武将碎片
function SoldierData:addPatchItem(item)
--[[
    message HeroChipPB{
    required int32 hero_chip_no = 1;  //编号
    required int32 hero_chip_num = 2;  //数量
}]]
    for k,v in pairs(self.patchData) do
        if v.hero_chip_no == item.hero_chip_no then
            v.hero_chip_num = v.hero_chip_num + item.hero_chip_num
            return
        end
    end
    table.insert(self.patchData, item)
    print("addPatchItem")
    self:updatePatchData()
end

--根据ID获取武将碎片数量
function SoldierData:getPatchItemById(item)
--[[
    message HeroChipPB{
    required int32 hero_chip_no = 1;  //编号
    required int32 hero_chip_num = 2;  //数量
}]]
    for k,v in pairs(self.patchData) do
        if v.hero_chip_no == item.hero_chip_no then
            v.hero_chip_num = v.hero_chip_num + item.hero_chip_num
            return
        end
    end
    table.insert(self.patchData, item)
    print("addPatchItem")
    self:updatePatchData()
end

function SoldierData:updatePatchData()
    self.newPatchData = {}
    local function getIsCombined(hero_chip_no)
        for m, n in pairs(self.soldierData) do
            if hero_chip_no == n.hero_no then
                return true
            end
        end
        return false
    end

    for k, v in pairs(self.patchData) do
        local item = self.c_SoldierTemplate:getChipTempLateById(v.hero_chip_no)
        if item ~= nil then
            local combineResult = item.combineResult
            local isCombined = getIsCombined(combineResult)
            v.isCombin = not isCombined
            self.newPatchData[#self.newPatchData + 1] = v
        end
    end
    return self.newPatchData
end

function SoldierData:getIsCanCom()
    -- local isCanCom = false
    for k, v in pairs(self.newPatchData) do
        if v.isCombin then
            -- isCanCom = true
            local patchTempLate = self.c_SoldierTemplate:getChipTempLateById(v.hero_chip_no) 
            local _needNum = patchTempLate.needNum
            if tonumber(v.hero_chip_num) >= tonumber(_needNum) then
                return true
            else 
                return false
            end
        end
    end

    return false
end

-- 是否有新武将
function SoldierData:getIsHaveNewSoldier()
    if self.soldierIsNewData == nil then
        return false
    else
        local num = table.nums(self.soldierIsNewData)
        if num == 0 then 
            return false
        else
            -- print("-------------------- 新武将 ------------------------"..num)
            -- table.print(self.soldierIsNewData)
            -- print("-------------------- 新武将 ------------------------")
            return true
        end
    end
end

--
function SoldierData:getSoldierData()
    -- for k,v in pairs(self.soldierData) do
    --      v.isNew = false 
    -- end
    return self.soldierData
end


function SoldierData:getSoldierDataById(id)
    -- print("------getSoldierDataById--------"..id)
    for k,v in pairs(self.soldierData) do
        -- print(v.hero_no)
        if v.hero_no == id then
            print("xiangtong ")
            return v
        end
    end
    -- print("----------------------------")

    return nil
end

-- 根据id获取数量
function SoldierData:getSoldierNumById(id)
    for k,v in pairs(self.soldierData) do
        if v.hero_no == id then
            print("xiangtong ")
            return 1
        end
    end
    return 0
end

--获得index的item,form 0
function SoldierData:getSoldierItemByIndex(index)
    local data =  self.soldierData[index]
    if data == nil then
        cclog("ERROR__can not found data by index=" .. index)
        -- table.print(self.soldierData)
    end

    return data
end
  -- required int32 hero_chip_no = 1;  //编号
  --   required int32 hero_chip_num = 2;  //数量
function SoldierData:getPatchDataByIndex(index)
    local item = self.patchData[index]
    return item

end

 --获取碎片的数量
function SoldierData:getPatchNumById(id)
    for k, v in pairs(self.patchData) do
        if v.hero_chip_no == id then
            return v.hero_chip_num
        end
    end
    return 0
end

--获得碎片数据
function SoldierData:getPatchData()
    return self.patchData
end

--更改碎片的数量
function SoldierData:changeChipNum(chipId, num)
    for k, v in pairs(self.patchData) do
        if v.hero_chip_no == chipId then
            local nowNum = v.hero_chip_num
            if nowNum == num then
                table.remove(self.patchData, k)
                return
            else
                v.hero_chip_num = nowNum - num
            end
        end
    end
    self:updatePatchData()
    local isCanCom = self:getIsCanCom()
    touchNotice(NOTICE_COM_HERO, isCanCom)
end

--武将镶嵌符文设置
function SoldierData:setRuneData(hero, slotId, data)
    if hero == nil then
        print("hero no exists!")
        return 
    end
    local temp = nil
    for _,runt_type in pairs(hero.runt_type) do
        if slotId == runt_type.runt_type then
            temp = runt_type
            runt_type.runt = data
        end
    end
    if temp == nil then
        temp = {}
        temp.runt_type = slotId
        temp.runt = data
        if hero.runt_type == nil or table.nums(hero.runt_type)==0 then
            hero.runt_type = {}
        end
        table.insert(hero.runt_type, temp)
    end
    -- todo: sync lineup data
end


return SoldierData











