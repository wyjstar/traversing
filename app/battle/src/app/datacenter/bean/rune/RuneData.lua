--符文相关数据
local RuneData = class("RuneData")

function RuneData:ctor()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self.selectRunes = {}                       --当前选中的符文列表
    self.menuData = {}
    self.soldierRunes = {}                      --当前武将镶嵌的符文信息
    self.soldierId = nil                        --当前操作的武将id
    self.curRuneItem = nil                       --当前操作的符文对象
    self.bagRunes = {}                          --武将含有的符文列表（背包中得）
    self.orderRunes = {}                        --按照顺序排列的符文列表
    self.refresh_item = nil                       --打造刷新符文id
    self.refreshTimes = nil                     --免费刷新的次数

    self.stone1Num = 0                          --原石数量
    self.stone2Num = 0                          --晶石数量

    self.changeItem = nil                       --替换符文
    self.preRuneItem = nil                      --被替换的符文
end

--设置当前武将镶嵌的符文信息（镶嵌相关）
function RuneData:setSoldierRune(data)
    self.soldierRunes = clone(data)
end

--获取武将镶嵌的符文信息（镶嵌相关）
function RuneData:getSoldierRunes()
    return self.soldierRunes
end

--根据不同类型的符文获取当前类型的符文列表（镶嵌相关）
function RuneData:getRunesByType(cur_type)
    if self.soldierRunes ~= nil then
        for k,v in pairs(self.soldierRunes) do
            print(v.runt_type.."b----"..cur_type)
            if v.runt_type == cur_type then
                return v.runt
            end
        end
    end
    return {}
end
--设置当前符文操作的武将id（镶嵌相关）
function RuneData:setCurSoliderId(curSoldierId)
    self.soldierId = curSoldierId
end

--获取当前操作的武将的id（镶嵌相关）
function RuneData:getCurSoliderId()
    return self.soldierId
end

--设置当前镶嵌或者删除的符文的id（镶嵌相关）
function RuneData:setCurRuneItem(runItem)
    self.curRuneItem = runItem
end

--获取当前的镶嵌或者删除的符文的id（镶嵌相关）
function RuneData:getCurRuneItem()
    return self.curRuneItem
end

--当前选中的符文(炼化相关)
function RuneData:setSelectRunes(data)
    if data ~= nil then
        self.selectRunes = data
    else
        self.selectRunes = {}
    end
end

function RuneData:addSelectRune(data)
    self.selectRunes[#self.selectRunes + 1] =data
end 

--获取当前选中的符文(炼化相关)
function RuneData:getSelectRunes()
    return self.selectRunes
end

--一键置入获取低阶符文(炼化相关)
function RuneData:getSmeltRunes()
    self.orderRunes = clone(self.bagRunes)

    local function mySort(member1, member2)
        local quality1 = self.c_StoneTemplate:getStoneItemById(member1.runt_id).quality
        local quality2 = self.c_StoneTemplate:getStoneItemById(member2.runt_id).quality
        return quality1 < quality2
    end

    table.sort(self.orderRunes, mySort)

    local runes = {}
    --需要个数
    local needCount = 8 - #self.selectRunes

    for _, rune in pairs(self.orderRunes) do
        
        if needCount == 0 then
            break
        end
        --过滤掉已添加的
        for _, v in pairs(self.selectRunes) do
            if rune.runt_no ~= v.runt_no then
                table.insert(runes, rune)
                needCount = needCount -1
                break
            end
        end
    end

    return runes
end

--炼化获取原石数量设置(炼化相关)
function RuneData:setStone1(stoneNum)
    self.stone1Num = stoneNum
end

--获取炼化原石数量(炼化相关)
function RuneData:getStone1()
    return self.stone1Num
end

--炼化获取晶石数量设置(炼化相关)
function RuneData:setStone2(stoneNum)
    self.stone2Num = stoneNum
end

--获取炼化晶石数量(炼化相关)
function RuneData:getStone2()
    return self.stone2Num
end

--原石数量变化更新(炼化相关) 1 获得  2 消耗
function RuneData:updateStone1Num(curType, num)
    if curType == 1 then
        self.stone1Num = self.stone1Num + num
    elseif curType == 2 then
        self.stone1Num = self.stone1Num - num
    end
    return self.stone1Num
end

--晶石数量变化更新(炼化相关)
function RuneData:updateStone2Num(curType, num)
    if curType == 1 then
        self.stone2Num = self.stone2Num + num
    elseif curType == 2 then
        self.stone2Num = self.stone2Num - num
    end
    return self.stone2Num
end


--初始化刷新得到的符文(打造符文)
function RuneData:setRefreshRuneItem(refreshItem)
    self.refresh_item = refreshItem
end

--获取打造刷新符文id(打造符文)
function RuneData:getRefreshRuneItem()
    return self.refresh_item
end

--获取符文免费刷新次数
function RuneData:setRefreshFreeTimes(refresh_times)
    local total = self.c_BaseTemplate:getFreeRefreshTimes()
    print("刷新次数 ========== ", refresh_times)
    self.refreshTimes = total - refresh_times
end

--获取当前拥有的免费刷新的次数
function RuneData:getRefreshFreeTimes()
    return self.refreshTimes
end

--更改刷新次数
function RuneData:updateRefreshFreeTimes(num)
    if self.refreshTimes ~= nil then
        self.refreshTimes = self.refreshTimes - num
    end
    return self.refreshTimes
end

--符文背包数据 (符文背包相关)
function RuneData:setBagRunes(data)
    self.bagRunes = data
end

--获取背包数据 (符文背包)
function RuneData:getBagRunes()
    return self.bagRunes
end

--背包中符文数量的变化（符文背包） 1 获取到符文 2 消耗符文
function RuneData:updateNumById(updateType, runeItem)
    if updateType == 1 then
        local isExits = false
        for k, v in pairs(self.bagRunes) do
            if runeItem.runt_no == v.runt_no then
                -- v.num = v.num + runeItem.runeNum
                isExits = true
            end
        end
        if not isExits then
            table.insert(self.bagRunes, runeItem)
        end
    elseif updateType == 2 then
        for k, v in pairs(self.bagRunes) do
            -- if v.num > 1 then
            --     if v.runt_id == runeItem.runeId then
            --         v.num = v.num - runeItem.runeNum
            --     end
            -- else
            --     table.remove(self.bagRunes, k)
            -- end
            if v.runt_no == runeItem.runt_no then
                table.remove(self.bagRunes, k)
            end

        end
    end
end

--替换符文缓存
function RuneData:setChangeRune(curRuneItem)
    self.changeItem = curRuneItem
end

--获取替换符文
function RuneData:getChangeRune()
    if self.changeItem ~= nil then
        return self.changeItem
    end
end


--要被替换的符文缓存
function RuneData:setPreRuneItem(runeItem)
    print("RuneData:setPreRuneItem================>")
    table.print(runeItem)
    self.preRuneItem = clone(runeItem)
end

--获取被替换的符文
function RuneData:getPreRuneItem()
    return self.preRuneItem
end

function RuneData:setItemImage(sprite, res, quality)
    sprite:removeAllChildren()
    game.setSpriteFrame(sprite, res)
    local bgSprite = cc.Sprite:create()
    -- sprite:addChild(bgSprite)
    if quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_kuang.png")
    elseif quality == 3 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

return RuneData
