BAG_GET_DATA = 301
PROP_USE = 302

--背包相关数据
local BagData = class("BagData")


function BagData:ctor()
    self.c_BagTemplate = getTemplateManager():getBagTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.propItems = {}     --道具集合
    self.useData = {}       --使用道具返回数据
    self.curItemNum = nil
    self.useNum = 0         --使用的道具的数量
    self.maxBagNum = getTemplateManager():getBaseTemplate():getItemMaxNum()
end

--服务端对道具的数据初始化(点击背包请求的数据)
function BagData:setData(data)
    --真实数据操作
    local curItemList = data.items
    if curItemList ~= nil then
        for k,v in pairs(curItemList) do
            local propItem = self.c_BagTemplate:getItemById(v.item_no)
            local itemNum = v.item_num
            local curItem = {}
            curItem.item = propItem
            -- if itemNum > self.maxBagNum then
            --     curItem.itemNum = self.maxBagNum
            -- else
                curItem.itemNum = itemNum
            -- end

            table.insert(self.propItems, curItem)
        end
    end

    for k,v in pairs(self.propItems) do
        if v.item == nil then
            table.remove(self.propItems, k)
        end
    end
    table.print(self.propItems)
end

--其他方式获得的道具(打关卡、副本、抽卡获得道具)
function BagData:setItemByOtherWay(data)
    print("背包增加道具 --=============== ")
    -- table.print(data)
    for k,v in pairs(data) do
        print(v.item_no)
        if v.item_no > 0 then
            print("道具的id ============ ", v.item_no)
            local propItem = self.c_BagTemplate:getItemById(v.item_no)
            local isHave = false
            for m,n in pairs(self.propItems) do
                if n.item.id == v.item_no then
                    isHave = true
                    local nowItemNum = n.itemNum + v.item_num
                    -- if nowItemNum > self.maxBagNum then
                    --     n.itemNum = self.maxBagNum
                    --     -- getOtherModule():showAlertDialog(nil, "道具数量已达到上限")
                    --     -- break
                    -- else
                        n.itemNum = nowItemNum
                    -- end
                    -- n.itemNum = n.itemNum + v.item_num
                end
            end

            if not isHave then
                local curItem = {}
                curItem.item = propItem
                -- if v.item_num > self.maxBagNum then
                --     curItem.itemNum = self.maxBagNum
                -- else
                    curItem.itemNum = v.item_num
                -- end
                table.insert(self.propItems, curItem)
            end

        end
    end
end

--客户端获取道具列表数据的方法
function BagData:getData()
    if self.propItems ~= nil then
        for k,v in pairs(self.propItems) do
            if v.itemNum == 0 then
                table.remove(self.propItems, k)
                v = nil
            end
        end
        return self.propItems
    else
        return nil
    end
end

--获得经验丹数据
function BagData:getEXPItemData()
    --10001 10002 10003
    local tempTable = {}
    for k, v in pairs(self.propItems) do
        local item = v.item
        local func = item.func
        if func == 1 then
            table.insert(tempTable, v)
        end
    end

    local function isExist(item_id)
        for k,v in pairs(tempTable) do
            if v.item.id == item_id then
                return true
            end
        end
        return false
    end

    if table.getn(tempTable) < 3 then
        local result1 = isExist(10001)
        local result2 = isExist(10002)
        local result3 = isExist(10003)
        if not result1 then
            local curItem = {}
            local propItem = self.c_BagTemplate:getItemById(10001)
            curItem.item = propItem
            curItem.itemNum = 0
            table.insert(tempTable, curItem)
        end

        if not result2 then
            local curItem = {}
            local propItem = self.c_BagTemplate:getItemById(10002)
            curItem.item = propItem
            curItem.itemNum = 0
            table.insert(tempTable, curItem)
        end

        if not result3 then
            local curItem = {}
            local propItem = self.c_BagTemplate:getItemById(10003)
            curItem.item = propItem
            curItem.itemNum = 0
            table.insert(tempTable, curItem)
        end
    end

    print("输出最终的列表 ================= ")
    -- table.print(tempTable)

    return tempTable
end

function BagData:getItemNumById(itemId)
    for k, v in pairs(self.propItems) do
        local id = v.item.id
        if id == itemId then
            return v.itemNum
        end
    end
end

function BagData:getSubNumById(itemId, num)
    for k, v in pairs(self.propItems) do
        local id = v.item.id
        if id == itemId then
            v.itemNum = v.itemNum - num
            return v.itemNum
        end
    end
end

--获取当前背包中道具的总数量
function BagData:getTotalItems()
    if self.propItems ~= nil then
        return table.nums(self.propItems)
    else
        return nil
    end
end

--配置文件中读取物品数据
function BagData:getDataById(item_no)
    if self.propItems ~= nil then
        for k,v in pairs(self.propItems) do
            if k == item_no then
                return self.propItems[k]
            end
        end
    end
end

--道具使用更新
function BagData:updatePropItem(id, num)
    -- print("===="..table.nums(self.propItems))
    for k, v in pairs(self.propItems) do
        -- print(v.itemNum.."==updatePropItem=="..num.."=="..id.."---"..v.item.id)
        if v.item.id == id then
            local _n = v.itemNum - num
            cclog("-n=".._n)
            if _n <= 0 then
                table.remove(self.propItems, k)
                self.curItemNum = nil
            else
                v.itemNum = _n
                self.curItemNum = _n
            end

            break
        end

        -- if v.item.id == id  and v.itemNum - num > 1 then
        --     self.propItems[k].itemNum = self.propItems[k].itemNum - num
        --     self.curItemNum = self.propItems[k].itemNum
        -- elseif v.item.id == id and v.itemNum - num <= 0 then
        --     table.remove(self.propItems, k)
        --     self.curItemNum = nil
        -- end
    end
    -- print("==2222=="..table.nums(self.propItems))
end

--道具使用后数量值更新
function BagData:getItemNum()
    if self.curItemNum ~= nil then
        return self.curItemNum
    else
        return nil
    end
end

--道具使用数量
function BagData:setUseNum(num)
    self.useNum = num
end

function BagData:getUseNum()
    return self.useNum
end

return BagData
