--武将页面
local PVRuneChangeSoldier = class("PVRuneChangeSoldier", BaseUIView)


function PVRuneChangeSoldier:ctor(id)
    PVRuneChangeSoldier.super.ctor(self, id)
    self.tableViewTable = {}
    self.menuTable = {}
    self.current_type = 1
    self.doTableViewAction = true

    self.c_lineupData = getDataManager():getLineupData()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_SoldierNet = getNetManager():getSoldierNet()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.c_baseTemplate = getTemplateManager():getBaseTemplate()
end

function PVRuneChangeSoldier:onMVCEnter()
    self:initBaseUI()
    self:showAttributeView()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_soldier.plist")

    self.UISelectSoldier = {}
    self:initTouchListener()
    self:loadCCBI("lineup/ui_select_soldoer.ccbi", self.UISelectSoldier)

    self.goTabIndex = self.funcTable[1]
    self.soldierData = self.c_SoldierData:getSoldierData()
    self.onLineUpList = self.c_lineupData:getOnLineUpList()
    self.cheerSoldierList = self.c_lineupData:getCheerSoldier()
    self.player_level_max = self.c_baseTemplate:getMaxLevel( )

    self:initView()

    self:regeisterNetCallBack()


    if self.goTabIndex ~= nil then
        self:goTableList(self.goTabIndex)
    else
        self:firstMenuClick()
    end

end

function PVRuneChangeSoldier:onExit()
    getDataManager():getResourceData():clearResourcePlistTexture()

end

function PVRuneChangeSoldier:goTableList( tabIndex )
    self:updateMenuIndex(tabIndex)
end

function PVRuneChangeSoldier:firstMenuClick()
    self:updateSoldierData(1)
end

function PVRuneChangeSoldier:initView()
    self.animationManager = self.UISelectSoldier["UISelectSoldier"]["mAnimationManager"]

    self.selectSoldierLayer = self.UISelectSoldier["UISelectSoldier"]["selectSoldierLayer"]

    self.labelItemNum = self.UISelectSoldier["UISelectSoldier"]["hero_num"]

    self.jobImgSelect = {1,2,3,4,5,6}
    self.jobImgNormal = {1,2,3,4,5,6}
    --全部
    self.jobImgSelect[1] = self.UISelectSoldier["UISelectSoldier"]["selected1"]
    self.jobImgNormal[1] = self.UISelectSoldier["UISelectSoldier"]["normal1"]
    --猛将
    self.jobImgSelect[2] = self.UISelectSoldier["UISelectSoldier"]["selected2"]
    self.jobImgNormal[2] = self.UISelectSoldier["UISelectSoldier"]["normal2"]
    --禁卫
    self.jobImgSelect[3] = self.UISelectSoldier["UISelectSoldier"]["selected3"]
    self.jobImgNormal[3] = self.UISelectSoldier["UISelectSoldier"]["normal3"]
    --游侠
    self.jobImgSelect[4] = self.UISelectSoldier["UISelectSoldier"]["selected4"]
    self.jobImgNormal[4] = self.UISelectSoldier["UISelectSoldier"]["normal4"]
    --谋士
    self.jobImgSelect[5] = self.UISelectSoldier["UISelectSoldier"]["selected5"]
    self.jobImgNormal[5] = self.UISelectSoldier["UISelectSoldier"]["normal5"]
    --方士
    self.jobImgSelect[6] = self.UISelectSoldier["UISelectSoldier"]["selected6"]
    self.jobImgNormal[6] = self.UISelectSoldier["UISelectSoldier"]["normal6"]


    for k,v in pairs(self.menuTable) do
        v:setAllowScale(false)
    end

    self.subMenuTable = {}
    for i=1,6 do
        local strMenu = "subMenu"..tostring(i)
        local menu = self.UISelectSoldier["UISelectSoldier"][strMenu]  --底部小按钮
        table.insert(self.subMenuTable, menu)
    end

    self.layerSize = self.selectSoldierLayer:getContentSize()
    -- self.posX, self.posY = self.listLayer:getPosition()

    -- 设置hero上阵属性
    for k,v in pairs(self.soldierData) do
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

    --初始化排序
    self:initSort()
    self:createMySoldierListView()

    if self.goTabIndex == 4 then
        self:createUpgradeListView()
    elseif self.goTabIndex == 3 then
        self:createBreakListView()
    end
    self.itemSize = {height=140, width=550}
end

--注册网络回调
function PVRuneChangeSoldier:regeisterNetCallBack()
end

--更新英雄数据
function PVRuneChangeSoldier:updateSoldierData(idx)
    -- 设置hero上阵属性
    for k,v in pairs(self.soldierData) do
        v.is_cheer = false
        v.is_online = false
        for _k,_v in pairs(self.onLineUpList) do
            if v.hero_no == _v.hero_no then
                v.is_online = true
                break
            end
        end
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

--武将排序更新
function PVRuneChangeSoldier:updateSort(curSoliderList)
    for _, v in pairs(self.soldierData) do
        local template = self.c_SoldierTemplate:getHeroTempLateById(v.hero_no)
        v.power = self.c_Calculation:CombatPowerSoldierSelf(v)
        v.quality = template.quality
        v.level = v.level
        v.id = v.hero_no
    end

    --武将列表排序
    local function compare1(item1, item2)
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

    table.sort(curSoliderList, compare1)
end

function PVRuneChangeSoldier:initSort()
    self.patchData = self.c_SoldierData:updatePatchData()
    self.soldierData = self.c_SoldierData:getSoldierData()
    self.soldierListData = clone(self.soldierData)
    self.patchListData = clone(self.patchData)

    for k,v in pairs(self.patchData) do
        local patchNum = v.hero_chip_num
        local patchNo = v.hero_chip_no
        local patchTempLate = self.c_SoldierTemplate:getChipTempLateById(patchNo)
        local needNum = patchTempLate.needNum
        if v.isCombin then
            if patchNum >= needNum then
                v.isCombin = true
            else
                v.isCombin = false
            end
        end
    end

    for _, v in pairs(self.soldierData) do
        local template = self.c_SoldierTemplate:getHeroTempLateById(v.hero_no)
        v.power = self.c_Calculation:CombatPowerSoldierSelf(v)
        v.quality = template.quality
        -- v.power = self.c_Calculation:CombatPowerSoldierSelf(v)
        -- v.quality = template.quality
        v.level = v.level
        v.id = v.hero_no
    end

    --武将列表排序
    local function compare1(item1, item2)
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
            if item1.is_cheer == true and item2.is_cheer == true then
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
            elseif item1.is_cheer == false and item2.is_cheer == false then
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

    table.sort(self.soldierData, compare1)

    --武将碎片排序
    local function compare2(a,b)  -- 按照可合成>不可合成，碎片品阶 降序排序
        local _qualityA = self.chipTemp:getTemplateById(a.hero_chip_no).quality
        local _qualityB = self.chipTemp:getTemplateById(b.hero_chip_no).quality

        if a.isCombin == true and b.isCombin == true then
            return _qualityA > _qualityB
        elseif a.isCombin  == true and b.isCombin == false then
            return true
        elseif a.isCombin  == false and b.isCombin == true then
            return false
        elseif a.isCombin  == false and b.isCombin == false then
            return _qualityA > _qualityB
        end
    end

    local tempFinalPatchData = {}
    for k, v in pairs(self.patchListData) do
        local isCombin = v.isCombin
        if isCombin then
            tempFinalPatchData[#tempFinalPatchData + 1] = v
        end
    end
    for k, v in pairs(self.patchListData) do
        local isCombin = v.isCombin
        if isCombin == false then
            tempFinalPatchData[#tempFinalPatchData + 1] = v
        end
    end
    self.patchListData = tempFinalPatchData

    table.sort(self.patchListData, compare2)
    -- 更新武将数量
    self:updateItemNumber()
end

--tab点击
function PVRuneChangeSoldier:onSlidingMenuChange(state)
    self.current_type = state
    for k,v in pairs(self.menuTable) do
        if k == state then
            v:setEnabled(false)
        else
            v:setEnabled(true)
        end
    end

    for k,v in pairs(self.tableViewTable) do
        if k == state then
            self.listLayer:removeChildByTag(999)
            local scrBar = PVScrollBar:new()
            scrBar:setTag(999)
            scrBar:init(v,1)
            scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
            self.listLayer:addChild(scrBar,2)

            v:reloadData()
            v:setVisible(true)
            self:tableViewItemAction(v)
        else
            v:setVisible(false)
        end
    end
end

function PVRuneChangeSoldier:initTouchListener()
    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UISelectSoldier["UISelectSoldier"] = {}
    self.UISelectSoldier["UISelectSoldier"]["backMenuClick"] = backMenuClick

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
    self.UISelectSoldier["UISelectSoldier"]["subMenuClickA"] = clickSubMenuA
    self.UISelectSoldier["UISelectSoldier"]["subMenuClickB"] = clickSubMenuB
    self.UISelectSoldier["UISelectSoldier"]["subMenuClickC"] = clickSubMenuC
    self.UISelectSoldier["UISelectSoldier"]["subMenuClickD"] = clickSubMenuD
    self.UISelectSoldier["UISelectSoldier"]["subMenuClickE"] = clickSubMenuE
    self.UISelectSoldier["UISelectSoldier"]["subMenuClickF"] = clickSubMenuF
end

--更新子tab，进行分类
function PVRuneChangeSoldier:updateSubMenuState(idx)
    if idx ~= nil then
        self.currSubMenuIdx = idx
    else
        idx = 1
    end

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

    self.soldierListData = clone(self.soldierData)

    if self.currSubMenuIdx == 1 then
        --优化
        self.soldierListData = clone(self.soldierData)
    else
        local index = 1
        self.soldierListData = {}
        for k,v in pairs(self.soldierData) do
            local jobId = self.c_SoldierTemplate:getHeroTypeId(v.hero_no)
            if jobId == self.currSubMenuIdx - 1 then
                self.soldierListData[index] = v
                index = index + 1
            end
        end
        index = 1
    end
end

function PVRuneChangeSoldier:updateItemNumber()
    -- 更新列表中的数量
    local _num = table.nums(self.soldierListData)
    self.labelItemNum:setString(string.format(_num))
end

--创建武将列表
function PVRuneChangeSoldier:createMySoldierListView()
    local function tableCellTouched(tbl, cell)
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

            local function onChooseClick()
                getAudioManager():playEffectButton2()
                local soldierDataItem = self.soldierListData[cell.index+1]
                local soldierId = soldierDataItem.hero_no

                local heroPb = self.c_SoldierData:getSoldierDataById(soldierId)
                --当前武将符文相关信息的初始化
                print("heroPb ========== ")
                table.print(heroPb)
                getDataManager():getRuneData():setCurSoliderId(heroPb.hero_no)

                getDataManager():getRuneData():setSoldierRune(heroPb.runt_type)
                self:onHideView(1)
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRunePanel", getDataManager():getRuneData():getCurSoliderId())
            end

            local function onItemClick()
                getAudioManager():playEffectButton2()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", cell.soldierId)
            end

            cell.cardinfo = {}
            cell.starTable = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISoldierMy"] = {}
            cell.cardinfo["UISoldierMy"]["onChooseClick"] = onChooseClick
            cell.cardinfo["UISoldierMy"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("soldier/ui_soldier_my_item.ccbi", proxy, cell.cardinfo)

            local starSelect1 = cell.cardinfo["UISoldierMy"]["starSelect1"]
            local starSelect2 = cell.cardinfo["UISoldierMy"]["starSelect2"]
            local starSelect3 = cell.cardinfo["UISoldierMy"]["starSelect3"]
            local starSelect4 = cell.cardinfo["UISoldierMy"]["starSelect4"]
            local starSelect5 = cell.cardinfo["UISoldierMy"]["starSelect5"]
            local starSelect6 = cell.cardinfo["UISoldierMy"]["starSelect6"]
            table.insert(cell.starTable, starSelect1)
            table.insert(cell.starTable, starSelect2)
            table.insert(cell.starTable, starSelect3)
            table.insert(cell.starTable, starSelect4)
            table.insert(cell.starTable, starSelect5)
            table.insert(cell.starTable, starSelect6)

            local itemMenuItem = cell.cardinfo["UISoldierMy"]["itemMenuItem"]
            itemMenuItem:setAllowScale(false)

            cell:addChild(node)
        end

        cell.index = idx

        local soldierDataItem = self.soldierListData[cell.index+1]

        local soldierId = soldierDataItem.hero_no
        cell.soldierId = soldierId
        local break_level = soldierDataItem.break_level
        local soldier_level = soldierDataItem.level

        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
        local nameStr = soldierTemplateItem.nameStr
        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local level = soldierDataItem.level
        local quality = soldierTemplateItem.quality
        local res = soldierTemplateItem.res
        local atkValue = soldierDataItem.power --战斗力
        local finnalLevel = "等级" .. string.format(level)
        local sodierName = cell.cardinfo["UISoldierMy"]["soldierName"]  --名称
        local lvBMLabel = cell.cardinfo["UISoldierMy"]["lvBMLabel2"]     --等级
        local headIcon = cell.cardinfo["UISoldierMy"]["headIcon"]       --头像
        local levelNum = cell.cardinfo["UISoldierMy"]["levelNum"]       --炼体 sp
        local fightNum = cell.cardinfo["UISoldierMy"]["fightNum"]       --战斗力
        local fightCapacity = cell.cardinfo["UISoldierMy"]["fightCapacity"]  ----战斗力
        local soldierUpgrade = cell.cardinfo["UISoldierMy"]["soldierUpgrade"]       --升级按钮
        local soldierLook = cell.cardinfo["UISoldierMy"]["soldierLook"]          --查看按钮
        local soldierBreak = cell.cardinfo["UISoldierMy"]["soldierBreak"]           --突破按钮
        local newSp = cell.cardinfo["UISoldierMy"]["newSp"]           --突破按钮
        local itemBg = cell.cardinfo["UISoldierMy"]["itemBg"]           --品质背景
        local soldierKindSp = cell.cardinfo["UISoldierMy"]["soldierKindSp"]           --武将职业
        local comNotice = cell.cardinfo["UISoldierMy"]["comNotice"]
        local soldierMainBtn = cell.cardinfo["UISoldierMy"]["soldierMainBtn"]
        soldierMainBtn:setVisible(false)
        local chooseMenu = cell.cardinfo["UISoldierMy"]["chooseMenu"]
        chooseMenu:setVisible(true)
        local isNew = getDataManager():getSoldierData():getSoldierIsNew(soldierId)

        if isNew == false then
            newSp:setVisible(false)
        else
            newSp:setVisible(true)
            self.c_SoldierData:removeSoldierIsNewList(soldierId)
            local isCanNewHero = getDataManager():getSoldierData():getIsHaveNewSoldier()   -- 是否有新武将
            self.soldier_new_notice:setVisible(isCanNewHero)
        end

        local soldierOnlineLabel = cell.cardinfo["UISoldierMy"]["busySoldierState"]     --已上阵label
        soldierOnlineLabel:setVisible(soldierDataItem.is_online)

        local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)
        changeNewSoldierIconImage(headIcon, resIcon, quality, itemBg) --新版更新icon

        local jobId = self.c_SoldierTemplate:getHeroTypeId(soldierId)
        setNewHeroTypeName(soldierKindSp,jobId)

        fightNum:setString(string.format(roundAttriNum(atkValue)))

        sodierName:setString(name)

        lvBMLabel:setString(finnalLevel)

        if self.player_level_max == soldier_level then
            lvBMLabel:setVisible(false)
            comNotice:setVisible(true)
        else
            lvBMLabel:setVisible(true)
            comNotice:setVisible(false)
        end

        updateStarLV(cell.starTable, quality)

        return cell
    end

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("soldier/ui_soldier_my_item.ccbi", proxy, tempTable)

    local sizeLayer = tempTable["UISoldierMy"]["sizeLayer"]

    self.itemSize = sizeLayer:getContentSize()

    self.tableViewMy = cc.TableView:create(self.layerSize)

    self.tableViewMy:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewMy:setDelegate()
    self.tableViewMy:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.selectSoldierLayer:addChild(self.tableViewMy)
    self.tableViewMy:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableViewMy:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewMy:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewMy:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    -- self.listLayer:removeChildByTag(999)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(999)
    scrBar:init(self.tableViewMy,1)
    scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
    self.selectSoldierLayer:addChild(scrBar,2)

    -- self.tableViewTable[1] = self.tableViewMy
end

--返回更新
function PVRuneChangeSoldier:onReloadView()
    local data = self.funcTable[1]

    if data == 80 then
        return
    end

    if data == 1 then
        self.doTableViewAction = false
    end
    self:initSort()
    self:updateSoldierData() -- 重上一个界面回来，更新下数据
end

return PVRuneChangeSoldier
