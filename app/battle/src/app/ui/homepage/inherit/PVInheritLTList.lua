-- 传承
-- 选择炼体  武将列表

local PVInheritLTList = class("PVInheritLTList", BaseUIView)


function PVInheritLTList:ctor(id)
    self.super.ctor(self, id)

    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_SoldierNet = getNetManager():getSoldierNet()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.heroTemp = getTemplateManager():getSoldierTemplate()
    self.c_lineupData = getDataManager():getLineupData()
    self.c_Calculation = getCalculationManager():getCalculation()

    self.onLineUpList = self.c_lineupData:getOnLineUpList()
    self.cheerSoldierList = self.c_lineupData:getCheerSoldier()
end

function PVInheritLTList:onMVCEnter()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_inherit.plist")
    
    self.UiInheriteSoldier = {}
    self.soldierData = {} --英雄数据
    self:initTouchListener()

    self.level = self.funcTable[1]

    self:loadCCBI("inherit/ui_inherit_LTList.ccbi", self.UiInheriteSoldier)

    self:initData()

    self:initView()
    self.doTableViewAction = true
    self:updateSoldierData(1)
end


function PVInheritLTList:initView()

    self.subMenuTable = {}
    for i=1,6 do
        local strMenu = "subMenu"..tostring(i)
        local menu = self.UiInheriteSoldier["UiInheriteSoldier"][strMenu]  --底部小按钮   
        table.insert(self.subMenuTable, menu)
    end

    self.jobImgSelect = {1,2,3,4,5,6}
    self.jobImgNormal = {1,2,3,4,5,6}
    --全部
    self.jobImgSelect[1] = self.UiInheriteSoldier["UiInheriteSoldier"]["selected1"]
    self.jobImgNormal[1] = self.UiInheriteSoldier["UiInheriteSoldier"]["normal1"]
    --猛将
    self.jobImgSelect[2] = self.UiInheriteSoldier["UiInheriteSoldier"]["selected2"]
    self.jobImgNormal[2] = self.UiInheriteSoldier["UiInheriteSoldier"]["normal2"]
    --禁卫
    self.jobImgSelect[3] = self.UiInheriteSoldier["UiInheriteSoldier"]["selected3"]
    self.jobImgNormal[3] = self.UiInheriteSoldier["UiInheriteSoldier"]["normal3"]
    --游侠
    self.jobImgSelect[4] = self.UiInheriteSoldier["UiInheriteSoldier"]["selected4"]
    self.jobImgNormal[4] = self.UiInheriteSoldier["UiInheriteSoldier"]["normal4"]
    --谋士
    self.jobImgSelect[5] = self.UiInheriteSoldier["UiInheriteSoldier"]["selected5"]
    self.jobImgNormal[5] = self.UiInheriteSoldier["UiInheriteSoldier"]["normal5"]
    --方士
    self.jobImgSelect[6] = self.UiInheriteSoldier["UiInheriteSoldier"]["selected6"]
    self.jobImgNormal[6] = self.UiInheriteSoldier["UiInheriteSoldier"]["normal6"]

    self.listLayer = self.UiInheriteSoldier["UiInheriteSoldier"]["listLayer"]
    self.layerSize = self.listLayer:getContentSize()

    self.labelItemNum = self.UiInheriteSoldier["UiInheriteSoldier"]["hero_num"]

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("inherit/ui_inherit_lt_item.ccbi", proxy, tempTable)
    local sizeLayer = tempTable["UIInheritSoldierMy"]["sizeLayer"]
    self.itemSize = sizeLayer:getContentSize()

    self:createMySoldierListView()

end

--更新英雄数据
function PVInheritLTList:initData(idx)
    print("-----------  initData  ------------------")
    self.soldierDataAll = self.c_SoldierData:getSoldierData()
    -- 设置hero上阵属性
    for k,v in pairs(self.soldierDataAll) do
        v.is_cheer = false
        v.is_online = false
        for _k,_v in pairs(self.onLineUpList) do
            if v.hero_no == _v.hero_no then
                v.is_online = true
                break
            end
        end
        -- 设置助威
        for _k,_v in pairs(self.cheerSoldierList) do
            if _v.activation then
                if _v.hero ~= nil then
                    if v.hero_no == _v.hero.hero_no then
                        v.is_online = true
                        v.is_cheer = true
                        break
                    end
                end
            end
        end
    end
    self.soldierData = {}
    for k,v in pairs(self.soldierDataAll) do

        local seal = getDataManager():getSoldierData():getSealById(v.hero_no)
        local allNum = self.heroTemp:getAllInt(seal)
        -- print("############### allNum", allNum)
        if self.level == 0 then
            if allNum > 0 then 
                table.insert(self.soldierData, v) 
            end
        else
            if allNum < self.level then 
                table.insert(self.soldierData, v) 
            end
        end
    end 

    self.soldierListData = self.soldierData

    -- 排序
    self:sortList()
end

--更新英雄数据
function PVInheritLTList:updateSoldierData(idx)  

    self:updateSubMenuState(idx)  -- 按职业过滤数据
    
    
    self.tableViewMy:reloadData()
    if self.doTableViewAction then
        self:tableViewItemAction(self.tableViewMy)
    else
        self:resetTabviewContentOffset(self.tableViewMy)
        self.doTableViewAction = true
    end

    self:updateItemNumber()

end

function PVInheritLTList:sortList()

    -- local function cmp1(a,b)  -- 按照等级大>小，品质大>小 降序排序,

    --     local _levelA = a.level
    --     local _levelB = b.level
    --     local _qualityA = self.c_SoldierTemplate:getHeroQuality(a.hero_no)
    --     local _qualityB = self.c_SoldierTemplate:getHeroQuality(b.hero_no)
    --     -- print(a.level.." -------------- "..b.level)
    --     -- print(_qualityA.."    -------   ".._qualityB)
    --     if _levelA > _levelB then return true
    --     elseif _levelA == _levelB then
    --         if _qualityA > _qualityB then return true
    --         else return false
    --         end
    --     else return false
    --     end
    -- end

    for _, v in pairs(self.soldierData) do
        local template = self.c_SoldierTemplate:getHeroTempLateById(v.hero_no)
        v.power = self.c_Calculation:CombatPowerSoldierSelf(v)
        v.quality = template.quality
        v.level = v.level
        v.id = v.hero_no
    end

    --武将列表排序
    local function cmp1(item1, item2)
        --武将品质(星级)
        local quality1 = item1.quality
        local quality2 = item2.quality
        --战斗力
        local power1 = item1.power
        local power2 = item2.power
        --等级
        local level1 = item1.level
        local level2 = item2.level
        --id
        local id1 = item1.id
        local id2 = item2.id

        print(level1.."------"..level2.."------"..id1.."------"..id2)

        if item1.is_online == true and item2.is_online == true then
            if item1.is_cheer == false and item2.is_cheer == false then
                -- if power1 == power2 then
                --     return quality1 > quality2
                -- else
                --     return power1 > power2
                -- end
                if quality1 == quality2 then
                    if power1 == power2 then
                        if level1 == level2 then 
                            return id1 > id2 
                        else
                            return level1 > level2 
                        end
                    else
                        return power1 > power2
                    end
                else
                    return quality1 > quality2
                end
            elseif item1.is_cheer == false and item2.is_cheer == true then
                return true
            elseif item1.is_cheer == true and item2.is_cheer == false then
                return false
            elseif item1.is_cheer == true and item2.is_cheer == true then
                -- if power1 == power2 then
                --     return quality1 > quality2
                -- else
                --     return power1 > power2
                -- end
                if quality1 == quality2 then
                    if power1 == power2 then
                        if level1 == level2 then 
                            return id1 > id2 
                        else
                            return level1 > level2 
                        end
                    else
                        return power1 > power2
                    end
                else
                    return quality1 > quality2
                end
            end
        elseif item1.is_online == true and item2.is_online == false then
            return true
        elseif item1.is_online == false and item2.is_online == true then
            return false
        elseif item1.is_online == false and item2.is_online == false then
            -- if power1 == power2 then
            --     return quality1 > quality2
            -- else
            --     return power1 > power2
            -- end
            if quality1 == quality2 then
                if power1 == power2 then
                    if level1 == level2 then 
                        return id1 > id2 
                    else
                        return level1 > level2 
                    end
                else
                    return power1 > power2
                end
            else
                return quality1 > quality2
            end
        end
    end
    table.sort(self.soldierData, cmp1)
end

--更新子tab，进行分类 
function PVInheritLTList:updateSubMenuState(idx)
    if idx ~= nil then
        self.currSubMenuIdx = idx
    end

    print("self.currSubMenuIdx", self.currSubMenuIdx)

    --更新界面
    local size = table.getn(self.subMenuTable)
    for i = 1, size do 
        local item = self.subMenuTable[i]
        if i == self.currSubMenuIdx then
            item:setEnabled(false)
            self.jobImgSelect[i]:setVisible(true)
            self.jobImgNormal[i]:setVisible(false)
        else
            item:setEnabled(true)
            self.jobImgSelect[i]:setVisible(false)
            self.jobImgNormal[i]:setVisible(true)
        end
    end

    --更新数据 self.soldierData, self.patchData
    self.soldierListData = {}

    if self.currSubMenuIdx == 1 then 
        local index = 1
        for k,v in pairs(self.soldierData) do        
            self.soldierListData[index] = v
            index = index + 1
        end
    else 
        local index = 1
        for k,v in pairs(self.soldierData) do        
            local jobId = self.c_SoldierTemplate:getHeroTypeId(v.hero_no)
            print("jobId", jobId)
            if jobId == self.currSubMenuIdx - 1 then
                self.soldierListData[index] = v
                index = index + 1
            end
        end
    end
end


function PVInheritLTList:initTouchListener()

    local function clickSubMenuA()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(1)
    end
    local function clickSubMenuB()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(2)
    end
    local function clickSubMenuC()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(3)
    end
    local function clickSubMenuD()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(4)
    end
    local function clickSubMenuE()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(5)
    end
    local function clickSubMenuF()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(6)
    end
    self.UiInheriteSoldier["UiInheriteSoldier"] = {}
    self.UiInheriteSoldier["UiInheriteSoldier"]["subMenuClickA"] = clickSubMenuA
    self.UiInheriteSoldier["UiInheriteSoldier"]["subMenuClickB"] = clickSubMenuB
    self.UiInheriteSoldier["UiInheriteSoldier"]["subMenuClickC"] = clickSubMenuC
    self.UiInheriteSoldier["UiInheriteSoldier"]["subMenuClickD"] = clickSubMenuD
    self.UiInheriteSoldier["UiInheriteSoldier"]["subMenuClickE"] = clickSubMenuE
    self.UiInheriteSoldier["UiInheriteSoldier"]["subMenuClickF"] = clickSubMenuF

    local function backMenuClick()
        self:onHideView()
    end

    self.UiInheriteSoldier["UiInheriteSoldier"]["backMenuClick"] = backMenuClick

end

--创建武将列表
function PVInheritLTList:createMySoldierListView()
    print("===========  createMySoldierListView   ================")

    local function tableCellTouched(tbl, cell)
        print("PVSoldierMy cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.soldierListData)
    end
    local function cellSizeForTable(tbl, idx)
        return self.itemSize.height,self.itemSize.width
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function inheritMenuClick()
                cclog("======= 点击选择 =======")
                getAudioManager():playEffectButton2()

                local lt = self.soldierListData[cell.index + 1]
                table.print(lt)
                
                -- 判断是否已上阵
                local isHave = true
                local changerCheerSoldierList = getDataManager():getLineupData():getChangeCheerSoldier()
                for k,v in pairs(changerCheerSoldierList) do
                    if lt.hero_no == v.hero_no then
                        isHave = false
                    end
                end
                if isHave == true then
                    -- print("该武将为上阵状态，确定选择？")
                    local  sure = function()
                        -- 确定
                        -- print("确定")
                        if self.level == 0 then
                            getDataManager():getInheritData():setlt1(lt)
                        else
                            getDataManager():getInheritData():setlt2(lt)
                        end

                        local event = cc.EventCustom:new(UPDATE_VIEW)
                        self:getEventDispatcher():dispatchEvent(event)

                        self:onHideView()
                        -- getNetManager():getSacrificeNet():sendHeroSacrificeRequest("HeroSacrificeRequest", data)
                    end
                    local cancel = function()
                        -- 取消
                        -- print("取消")
                        getOtherModule():clear()
                    end
                    getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVInheritLTList.1"))
                    return
                else
                    if self.level == 0 then
                        getDataManager():getInheritData():setlt1(lt)
                    else
                        getDataManager():getInheritData():setlt2(lt)
                    end

                    local event = cc.EventCustom:new(UPDATE_VIEW)
                    self:getEventDispatcher():dispatchEvent(event)

                    self:onHideView()
                end
            end

            cell.cardinfo = {}
            cell.starTable = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIInheritSoldierMy"] = {}
            cell.cardinfo["UIInheritSoldierMy"]["inheritMenuClick"] = inheritMenuClick
            local node = CCBReaderLoad("inherit/ui_inherit_lt_item.ccbi", proxy, cell.cardinfo)

            local starSelect1 = cell.cardinfo["UIInheritSoldierMy"]["starSelect1"]
            local starSelect2 = cell.cardinfo["UIInheritSoldierMy"]["starSelect2"]
            local starSelect3 = cell.cardinfo["UIInheritSoldierMy"]["starSelect3"]
            local starSelect4 = cell.cardinfo["UIInheritSoldierMy"]["starSelect4"]
            local starSelect5 = cell.cardinfo["UIInheritSoldierMy"]["starSelect5"]
            local starSelect6 = cell.cardinfo["UIInheritSoldierMy"]["starSelect6"]
            table.insert(cell.starTable, starSelect1)
            table.insert(cell.starTable, starSelect2)
            table.insert(cell.starTable, starSelect3)
            table.insert(cell.starTable, starSelect4)
            table.insert(cell.starTable, starSelect5)
            table.insert(cell.starTable, starSelect6)
            cell:addChild(node)

        end

        cell.index = idx

        self.soldierDataItem = self.soldierListData[cell.index + 1]

        local soldierId = self.soldierDataItem.hero_no
        cell.soldierId = soldierId
        local break_level = self.soldierDataItem.break_level

        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
        local nameStr = soldierTemplateItem.nameStr
        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local level = self.soldierDataItem.level
        local quality = soldierTemplateItem.quality
        local res = soldierTemplateItem.res

        local finnalLevel = "等级" .. string.format(level)

        -- 武将列表显示武将是否已上阵
        local soldierOnlineLabel = cell.cardinfo["UIInheritSoldierMy"]["busySoldierState"]     --已上阵label

        local soldierDataItem = self.soldierListData[cell.index + 1]

        
        -- 设置hero上阵属性
        local changerCheerSoldierList = getDataManager():getLineupData():getChangeCheerSoldier()
        soldierOnlineLabel:setVisible(true)
        
        for k,v in pairs(changerCheerSoldierList) do
            if soldierId == v.hero_no then
                print("上阵")
                soldierOnlineLabel:setVisible(false)
            end
        end
      


        local sodierName = cell.cardinfo["UIInheritSoldierMy"]["soldierName"]  --名称
        local lvBMLabel2 = cell.cardinfo["UIInheritSoldierMy"]["lvBMLabel2"]     --等级
        local headIcon = cell.cardinfo["UIInheritSoldierMy"]["headIcon"]       --头像
        cell.itemBg = cell.cardinfo["UIInheritSoldierMy"]["itemBg"]
        local soldierKindSp = cell.cardinfo["UIInheritSoldierMy"]["soldierKindSp"]

        local jobId = self.c_SoldierTemplate:getHeroTypeId(soldierId)
        setNewHeroTypeName(soldierKindSp,jobId)
      
        local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)
        changeNewSoldierIconImage(headIcon, resIcon, quality, cell.itemBg) --新版更新icon

        sodierName:setString(name)
        lvBMLabel2:setString(finnalLevel)
        updateStarLV(cell.starTable, quality)

        local levelNum = cell.cardinfo["UIInheritSoldierMy"]["levelNum"]       --炼体 sp
        local fightNum = cell.cardinfo["UIInheritSoldierMy"]["fightNum"]       --战斗力
        
        local seal = getDataManager():getSoldierData():getSealById(soldierId)
        print("############### seal", seal)
        levelNum:setSpriteFrame(self:updateBreakLv(break_level))
        if break_level < 1 then
            levelNum:setVisible(false)
        else
            levelNum:setVisible(true)
        end

        local allNum = self.heroTemp:getAllInt(seal)
        fightNum:setString(allNum)

        return cell
    end

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("inherit/ui_inherit_lt_item.ccbi", proxy, tempTable)
    local sizeLayer = tempTable["UIInheritSoldierMy"]["sizeLayer"]
    self.itemSize = sizeLayer:getContentSize()

    self.tableViewMy = cc.TableView:create(self.layerSize)

    self.tableViewMy:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewMy:setDelegate()
    self.tableViewMy:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.tableViewMy)
    self.tableViewMy:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableViewMy:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewMy:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewMy:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableViewMy,1)
    local layerSize = self.listLayer:getContentSize()
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

end

function PVInheritLTList:updateItemNumber()
    -- 更新列表中的数量
    local _num = table.nums(self.soldierListData)
    self.labelItemNum:setString(string.format(_num))
end


function PVInheritLTList:updateBreakLv(level)
    local _img = "ui_lineup_number1.png"
    if level == 1 then
    elseif level == 2 then
        _img = "ui_lineup_number2.png"
    elseif level == 3 then
        _img = "ui_lineup_number3.png"
    elseif level == 4 then
        _img = "ui_lineup_number4.png"
    elseif level == 5 then
        _img = "ui_lineup_number5.png"
    elseif level == 6 then
        _img = "ui_lineup_number6.png"
    elseif level == 7 then
        _img = "ui_lineup_number7.png"
    elseif level == 8 then
        _img = "ui_lineup_number8.png"
    elseif level == 9 then
        _img = "ui_lineup_number9.png"
    end

    return _img
end

return PVInheritLTList
