--武将页面
-- local PVScrollBar = import("..scrollbar.PVScrollBar")
local PVSoldierMain = class("PVSoldierMain", BaseUIView)


function PVSoldierMain:ctor(id)
    PVSoldierMain.super.ctor(self, id)
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

function PVSoldierMain:onMVCEnter()
    self:initBaseUI()
    self:showAttributeView()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_soldier.plist")

    self.UISoldier = {}
    -- self.soldierData = {} --英雄数据
    -- self.patchData = {}
    self:initTouchListener()
    self.goTabIndex = self.funcTable[1]
    self.soldierData = self.c_SoldierData:getSoldierData()
    self.onLineUpList = self.c_lineupData:getOnLineUpList()
    self.cheerSoldierList = self.c_lineupData:getCheerSoldier()
    self.player_level_max = self.c_baseTemplate:getMaxLevel( ) 
    print("-----self.cheerSoldierList----")
    --table.print(self.cheerSoldierList)
    self:loadCCBI("soldier/ui_soldier_main.ccbi", self.UISoldier)

    -- self:initData()
    --ProFi:start()
    self:initView()
    --ProFi:stop()
    --ProFi:writeReport( 'MyProfilingReport.txt' )
    self:regeisterNetCallBack()


    if self.goTabIndex ~= nil then
        self:goTableList(self.goTabIndex)
    else
        self:firstMenuClick()
    end

end

function PVSoldierMain:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    getDataManager():getResourceData():clearResourcePlistTexture()

end

function PVSoldierMain:goTableList( tabIndex )
    self:updateMenuIndex(tabIndex)
end

function PVSoldierMain:firstMenuClick()
    self:updateSoldierData(1)
end

function PVSoldierMain:initView()
    self.animationManager = self.UISoldier["UISoldier"]["mAnimationManager"]
    self.listLayer = self.UISoldier["UISoldier"]["listLayer"]

    self.labelItemNum = self.UISoldier["UISoldier"]["hero_num"]

    self.imgSelect = {1,2,3,4}
    self.imgNormal = {1,2,3,4}
    --武将
    self.imgSelect[1] = self.UISoldier["UISoldier"]["soldierSelect"]
    self.imgNormal[1] = self.UISoldier["UISoldier"]["soldierNor"]
    --合成
    self.imgSelect[2] = self.UISoldier["UISoldier"]["combineSelect"]
    self.imgNormal[2] = self.UISoldier["UISoldier"]["combineNor"]
    --突破
    self.imgSelect[3] = self.UISoldier["UISoldier"]["breakSelect"]
    self.imgNormal[3] = self.UISoldier["UISoldier"]["breakNor"]
    --升级
    self.imgSelect[4] = self.UISoldier["UISoldier"]["upgradeSelect"]
    self.imgNormal[4] = self.UISoldier["UISoldier"]["upgradeNor"]

    self.jobImgSelect = {1,2,3,4,5,6}
    self.jobImgNormal = {1,2,3,4,5,6}
    --全部
    self.jobImgSelect[1] = self.UISoldier["UISoldier"]["selected1"]
    self.jobImgNormal[1] = self.UISoldier["UISoldier"]["normal1"]
    --猛将
    self.jobImgSelect[2] = self.UISoldier["UISoldier"]["selected2"]
    self.jobImgNormal[2] = self.UISoldier["UISoldier"]["normal2"]
    --禁卫
    self.jobImgSelect[3] = self.UISoldier["UISoldier"]["selected3"]
    self.jobImgNormal[3] = self.UISoldier["UISoldier"]["normal3"]
    --游侠
    self.jobImgSelect[4] = self.UISoldier["UISoldier"]["selected4"]
    self.jobImgNormal[4] = self.UISoldier["UISoldier"]["normal4"]
    --谋士
    self.jobImgSelect[5] = self.UISoldier["UISoldier"]["selected5"]
    self.jobImgNormal[5] = self.UISoldier["UISoldier"]["normal5"]
    --方士
    self.jobImgSelect[6] = self.UISoldier["UISoldier"]["selected6"]
    self.jobImgNormal[6] = self.UISoldier["UISoldier"]["normal6"]

    for i=1,6 do
        self.jobImgSelect[i]:setScale(0.9)
        self.jobImgNormal[i]:setScale(0.9)
    end

    self.menuA = self.UISoldier["UISoldier"]["menuA"]
    self.menuB = self.UISoldier["UISoldier"]["menuB"]
    self.menuC = self.UISoldier["UISoldier"]["menuC"]
    self.menuD = self.UISoldier["UISoldier"]["menuD"]
    table.insert(self.menuTable, self.menuA)
    table.insert(self.menuTable, self.menuB)
    table.insert(self.menuTable, self.menuC)
    table.insert(self.menuTable, self.menuD)

    self.soldier_com_notice = self.UISoldier["UISoldier"]["soldier_com_notice"]
    self.soldier_new_notice = self.UISoldier["UISoldier"]["soldier_new_notice"]
    local isCanNewHero = getDataManager():getSoldierData():getIsHaveNewSoldier()   -- 是否有新武将
    self.soldier_new_notice:setVisible(isCanNewHero)

    for k,v in pairs(self.menuTable) do
        v:setAllowScale(false)
    end
    self.menuA:setEnabled(false)

    self.subMenuTable = {}
    for i=1,6 do
        local strMenu = "subMenu"..tostring(i)
        local menu = self.UISoldier["UISoldier"][strMenu]  --底部小按钮
        table.insert(self.subMenuTable, menu)
    end

    self.layerSize = self.listLayer:getContentSize()
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

    print("----self:createUpgradeListView()------")
    print(self.goTabIndex)

    if self.goTabIndex == 4 then
        self:createUpgradeListView()
    elseif self.goTabIndex == 3 then
        self:createBreakListView()
    end
    --self:createComposeListView()
    --self:createBreakListView()
    --self:createUpgradeListView()

    -- local tempTable = {}
    -- local proxy = cc.CCBProxy:create()
    -- local node = CCBReaderLoad("soldier/ui_soldier_compose_item.ccbi", proxy, tempTable)
    -- local sizeLayer = tempTable["UISoldierCompose"]["sizeLayer"]
    self.itemSize = {height=140, width=550}
end

--注册网络回调
function PVSoldierMain:regeisterNetCallBack()
    local function getSoldierCallBack(id, data)
        if data.res.result == true then
            print("getSoldierCallBack")
            self:updateSoldierData()
        else
            -- self:toastShow(data.res.message)
            getOtherModule():showAlertDialog(nil, data.res.message)
        end
    end
    local function getPatchCallBack(id, data)
        if data.res.result == true then
            print("getPatchCallBack")
            self:updateSoldierData()
        else
            -- self:toastShow(data.res.message)
            getOtherModule():showAlertDialog(nil, data.res.message)
        end
    end
    local function getComposeCallBack(id, data)
        -- print("^^^^^^^^^^^^^^^^^^^^^")
        -- table.print(data)
        if data.res.result == true then
            -- ljr
            local isCanNewHero = getDataManager():getSoldierData():getIsHaveNewSoldier()   -- 是否有新武将
            self.soldier_new_notice:setVisible(isCanNewHero)

            self.c_SoldierData:changeChipNum(self.patchNo, self.needComposeNum)              --消耗碎片
            -- self.patchData = self.c_SoldierData:getPatchData()
            self.patchData = self.c_SoldierData:updatePatchData()
            self.tableViewCompose:reloadData()
            self:resetTabviewContentOffset(self.tableViewCompose)
            -- self:toastShow("恭喜获得武将")
            local no = self.chipTemp:getTemplateById(self.patchNo).combineResult
            -- print("---------------- 合成 ---------------------------")
            -- print(no)
            -- print("---------------- 合成 ---------------------------")
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierShowCard", no)

            groupCallBack(GuideGroupKey.BTN_WUJIANG_COMPOSE)
        else
            -- self:toastShow(data.res.message)
            if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30038 then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_30039)
                groupCallBack(GuideGroupKey.BTN_CLOSE_CARD)
            end
            getOtherModule():showAlertDialog(nil, data.res.message)
        end
    end
    self:registerMsg(NET_ID_HERO_COMPOSE, getComposeCallBack)
    self:registerMsg(NET_ID_HERO_REQUEST, getSoldierCallBack)
    self:registerMsg(NET_ID_HERO_GET_PATCH, getPatchCallBack)
end

--更新英雄数据
function PVSoldierMain:updateSoldierData(idx)
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
    -- self.patchData = self.c_SoldierData:updatePatchData()

    self:updateSubMenuState(idx)  -- 按职业过滤数据


    -- self:sortList()

    -- 更新tableView数据
    local nowTableView = self.tableViewTable[self.current_type]
    nowTableView:reloadData()
    if self.doTableViewAction then
        self:tableViewItemAction(nowTableView)
    else
        self:resetTabviewContentOffset(nowTableView)
        self.doTableViewAction = true
    end


    local isCanCom = self.c_SoldierData:getIsCanCom()
    self.soldier_com_notice:setVisible(isCanCom)
    self:updateItemNumber()
end

function PVSoldierMain:subChNoticeState(noticeId, state)
    if noticeId == NOTICE_COM_HERO then
        self.soldier_com_notice:setVisible(state)
        self:updateSoldierData()
        self:updateItemNumber()
    end
end
--武将排序更新
function PVSoldierMain:updateSort(curSoliderList)
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
--武将碎片排序更细
function PVSoldierMain:updatePatchSort(curPatch)
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

    table.sort(curPatch, compare2)
end

function PVSoldierMain:initSort()
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
function PVSoldierMain:onSlidingMenuChange(state)
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
            --v:setTouchEnabled(false)
            v:setVisible(false)
        end
    end
    
end

function PVSoldierMain:initTouchListener()
    local function menuClickA()
        local _table = self.tableViewTable[1]
        if _table == nil then 
            self:createMySoldierListView()
        end
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(1)
    end

    local function menuClickB()
        local _table = self.tableViewTable[2]
        if _table == nil then 
            self:createComposeListView()
        end
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(2)

        groupCallBack(GuideGroupKey.BTN_WUJIANG_UP_ATTACK)
    end

    local function menuClickC()
        -- 如果新手引导突破步骤走到这里需要把要突破的武将置顶
        local gId = getNewGManager():getCurrentGid()
        if gId == GuideId.G_GUIDE_40004 then
            self:sortForNew()
        end
        local _table = self.tableViewTable[3]
        if _table == nil then 
            self:createBreakListView()
        end
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(3)
        groupCallBack(GuideGroupKey.BTN_WUJIANG_UP_ATTACK)
        --stepCallBack(G_GUIDE_50004)
    end

    local function menuClickD()
        local _table = self.tableViewTable[4]
        if _table == nil then 
            self:createUpgradeListView()
        end
        getAudioManager():playEffectButton2()

        self:updateMenuIndex(4)

        groupCallBack(GuideGroupKey.BTN_WUJIANG_UP_ATTACK)
    end

    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UISoldier["UISoldier"] = {}
    self.UISoldier["UISoldier"]["menuClickA"] = menuClickA
    self.UISoldier["UISoldier"]["menuClickB"] = menuClickB
    self.UISoldier["UISoldier"]["menuClickC"] = menuClickC
    self.UISoldier["UISoldier"]["menuClickD"] = menuClickD
    self.UISoldier["UISoldier"]["backMenuClick"] = backMenuClick

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
    self.UISoldier["UISoldier"]["subMenuClickA"] = clickSubMenuA
    self.UISoldier["UISoldier"]["subMenuClickB"] = clickSubMenuB
    self.UISoldier["UISoldier"]["subMenuClickC"] = clickSubMenuC
    self.UISoldier["UISoldier"]["subMenuClickD"] = clickSubMenuD
    self.UISoldier["UISoldier"]["subMenuClickE"] = clickSubMenuE
    self.UISoldier["UISoldier"]["subMenuClickF"] = clickSubMenuF
end

function PVSoldierMain:updateMenuIndex(index)
    if index ~= nil then
        ---------------ljr
        if index == 3 then
            self.playerLevel = getDataManager():getCommonData():getLevel()
            self.breakupOpenLeve = getTemplateManager():getBaseTemplate():getBreakupOpenLeve()

            local _stageId = getTemplateManager():getBaseTemplate():getBreakupOpenStage()
            local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
            if isOpen then   --self.playerLevel >= self.breakupOpenLeve
                
            else
                --支援
                --功能等级开放提示
                -- self:removeChildByTag(1000)
                -- self:addChild(getLevelTips(self.breakupOpenLeve), 0, 1000)
                getStageTips(_stageId)
                return
            end
        end

        if index == 1 then
            self.soldier_new_notice:stopActionByTag(100)
            local scaleToAction1 = cc.ScaleTo:create(0.05, 1.5)
            local scaleToAction2 = cc.ScaleTo:create(0.05, 1)
            local sequenceAction = cc.Sequence:create(scaleToAction1, scaleToAction2)
            sequenceAction:setTag(100)
            self.soldier_new_notice:runAction(sequenceAction)
        elseif index == 2 then
            
            self.soldier_com_notice:stopActionByTag(100)
            local scaleToAction1 = cc.ScaleTo:create(0.05, 1.5)
            local scaleToAction2 = cc.ScaleTo:create(0.05, 1)
            local sequenceAction = cc.Sequence:create(scaleToAction1, scaleToAction2)
            sequenceAction:setTag(100)
            self.soldier_com_notice:runAction(sequenceAction)
        end
        ----------------

        self.currMenuIdx = index
    else
        index = 1
    end

    self:removeChildByTag(1000)
    --武将
    for i=1,4 do
        if i == index then
            self.imgSelect[i]:setVisible(true)
            self.imgNormal[i]:setVisible(false)
        else
            self.imgSelect[i]:setVisible(false)
            self.imgNormal[i]:setVisible(true)
        end
    end
    self:updateSoldierData(1)
    self:onSlidingMenuChange(index)
end

--更新子tab，进行分类
function PVSoldierMain:updateSubMenuState(idx)
    if idx ~= nil then
        self.currSubMenuIdx = idx
    else
        idx = 1
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

    -- --职业
    -- for i=1,6 do
    --     if i == idx then
    --         self.jobImgSelect[i]:setVisible(true)
    --         self.jobImgNormal[i]:setVisible(false)
    --     else
    --         self.jobImgSelect[i]:setVisible(false)
    --         self.jobImgNormal[i]:setVisible(true)
    --     end
    -- end

    -- 更新数据 self.soldierData, self.patchData
    -- self.soldierListData = {}
    -- self.patchListData = {}
    self.soldierListData = clone(self.soldierData)
    self.patchListData = clone(self.patchData)

    if self.currSubMenuIdx == 1 then
        --优化
        self.soldierListData = clone(self.soldierData)
        self.patchListData = clone(self.patchData)
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
        self.patchListData = {}
        for k,v in pairs(self.patchData) do
            local patchTempLate = self.c_SoldierTemplate:getChipTempLateById(v.hero_chip_no)
            local hero_no = patchTempLate.combineResult
            local jobId = self.c_SoldierTemplate:getHeroTypeId(hero_no)
            if jobId == self.currSubMenuIdx - 1 then
                self.patchListData[index] = v
                index = index + 1
            end
        end
    end

    self:updatePatchSort(self.patchListData)
    -- self:updateSort(self.soldierListData)
end

function PVSoldierMain:updateItemNumber()
    -- 更新列表中的数量
    if self.currMenuIdx == 2 then
        local _num = table.nums(self.patchListData)
        self.labelItemNum:setString(string.format(_num))
    else
        local _num = table.nums(self.soldierListData)
        self.labelItemNum:setString(string.format(_num))
    end
end

--创建武将列表
function PVSoldierMain:createMySoldierListView()
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
        
        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

        if nil == cell then
            cell = cc.TableViewCell:new()

            local function lookMenuClick()
                getAudioManager():playEffectButton2()
                -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", cell.index + 1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", cell.soldierId)

                --stepCallBack(G_GUIDE_40107)   -- 滑动查看觉醒后武将

            end

            local function onItemClick()
                getAudioManager():playEffectButton2()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", cell.soldierId)
            end
            
            
            cell.cardinfo = {}
            cell.starTable = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISoldierMy"] = {}
            cell.cardinfo["UISoldierMy"]["lookMenuClick"] = lookMenuClick
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

        -- self.soldierDataItem = self.c_SoldierData:getSoldierItemByIndex(cell.index + 1)
        local soldierDataItem = self.soldierListData[cell.index+1]

        local soldierId = soldierDataItem.hero_no
        cell.soldierId = soldierId
        local break_level = soldierDataItem.break_level
        local soldier_level = soldierDataItem.level
        -- print("-------soldierDataItem-----")
        -- table.print(soldierDataItem)
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
        -- fightNum:setVisible(false)

        -- if not soldierDataItem.isNew then
        --     newSp:setVisible(false)
        local isNew = getDataManager():getSoldierData():getSoldierIsNew(soldierId)
        -- print("+++++++++++++++++++++++  isNew  +++++++++++++++++++++++++++++")
        -- print(isNew)
        if isNew == false then
            newSp:setVisible(false)
        else
            newSp:setVisible(true)
            self.c_SoldierData:removeSoldierIsNewList(soldierId)
            local isCanNewHero = getDataManager():getSoldierData():getIsHaveNewSoldier()   -- 是否有新武将
            self.soldier_new_notice:setVisible(isCanNewHero)
        end


        -- 武将列表显示武将是否已上阵
        -- local soldierOnlineSprite = cell.cardinfo["UISoldierMy"]["busyStateBg"]         --已上阵bg
        local soldierOnlineLabel = cell.cardinfo["UISoldierMy"]["busySoldierState"]     --已上阵label
        -- soldierOnlineSprite:setVisible(soldierDataItem.is_online)
        soldierOnlineLabel:setVisible(soldierDataItem.is_online)

        if soldierDataItem.is_online and  soldierDataItem.is_cheer then
            -- soldierOnlineLabel:setString(Localize.query("soldier.9"))
        elseif soldierDataItem.is_online and  soldierDataItem.is_cheer == false then
            -- soldierOnlineLabel:setString(Localize.query("soldier.8"))
        end

        local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)

        -- changeNewIconImage(headIcon, resIcon, quality) --更新icon
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
        levelNum:setSpriteFrame(self:updateBreakLv(break_level))
        if break_level < 1 then
            levelNum:setVisible(false)
        else
            levelNum:setVisible(true)
        end

        updateStarLV(cell.starTable, quality)

        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

        -- local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
        -- print(_info)

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
    self.listLayer:addChild(self.tableViewMy)
    self.tableViewMy:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableViewMy:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewMy:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewMy:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.listLayer:removeChildByTag(999)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(999)
    scrBar:init(self.tableViewMy,1)
    scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    self.tableViewTable[1] = self.tableViewMy

    
end

--创建武将合成列表
function PVSoldierMain:createComposeListView()

    local function tableCellTouched(tbl, cell)
        print("PVSoldierCompose cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       --return table.nums(self.patchListData)
       return #self.patchListData
    end
    local function cellSizeForTable(tbl, idx)

        return self.itemSize.height,self.itemSize.width
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()

        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

        if nil == cell then
            cell = cc.TableViewCell:new()

            --
            local function getSoldierMenuClick()
                getAudioManager():playEffectButton2()
                -- local patchItem = self.c_SoldierData:getPatchDataByIndex(cell:getIdx() + 1)

                local patchItem = self.patchListData[cell:getIdx() + 1]


                local patchNo = patchItem.hero_chip_no
                local _data = getTemplateManager():getChipTemplate():getAllDropPlace(patchNo)

                if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
                    and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
                    and _data.arenaShop == 0 and _data.stageBreak == 0  then
                    local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
                    -- getOtherModule():showToastView(tipText)
                    getOtherModule():showAlertDialog(nil, tipText)

                else
                    getOtherModule():showOtherView("PVChipGetDetail", _data, patchNo, 2)
                    -- getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVChipGetDetail", _data)
                end
            end

            local function recruitSoldierMenuClick() --招募
                getAudioManager():playEffectButton2()
                self.needComposeNum = cell.needComposeNum
                self.patchNo = cell.patchNo
                self.c_SoldierNet:sendComposeSoldierMsg(cell.patchNo)
            end

            local function onItemClick()
                getAudioManager():playEffectButton2()
                local patchItem = self.patchListData[cell:getIdx() + 1]
                local patchNum = patchItem.hero_chip_num
                local patchNo = patchItem.hero_chip_no
                getOtherModule():showOtherView("PVCommonChipDetail", 1, patchNo, patchNum)
            end

            cell.cardinfo = {}
            cell.starTable = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISoldierCompose"] = {}
            cell.cardinfo["UISoldierCompose"]["getSoldierMenuClick"] = getSoldierMenuClick
            cell.cardinfo["UISoldierCompose"]["recruitSoldierMenuClick"] = recruitSoldierMenuClick
            cell.cardinfo["UISoldierCompose"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("soldier/ui_soldier_compose_item.ccbi", proxy, cell.cardinfo)
            cell:addChild(node)

            local starSelect1 = cell.cardinfo["UISoldierCompose"]["starSelect1"]
            local starSelect2 = cell.cardinfo["UISoldierCompose"]["starSelect2"]
            local starSelect3 = cell.cardinfo["UISoldierCompose"]["starSelect3"]
            local starSelect4 = cell.cardinfo["UISoldierCompose"]["starSelect4"]
            local starSelect5 = cell.cardinfo["UISoldierCompose"]["starSelect5"]
            local starSelect6 = cell.cardinfo["UISoldierCompose"]["starSelect6"]
            table.insert(cell.starTable, starSelect1)
            table.insert(cell.starTable, starSelect2)
            table.insert(cell.starTable, starSelect3)
            table.insert(cell.starTable, starSelect4)
            table.insert(cell.starTable, starSelect5)
            table.insert(cell.starTable, starSelect6)

            cell.sodierName = cell.cardinfo["UISoldierCompose"]["heroName"]  --名称
            cell.numBMLabel = cell.cardinfo["UISoldierCompose"]["numBMLabel"]  --碎片数量
            cell.headIcon = cell.cardinfo["UISoldierCompose"]["headIcon"]       --头像
            cell.comNotice = cell.cardinfo["UISoldierCompose"]["comNotice"]      --是否可合成
            cell.itemMenuItem = cell.cardinfo["UISoldierCompose"]["itemMenuItem"]
            cell.itemBg = cell.cardinfo["UISoldierCompose"]["itemBg"]
            cell.numBMNode = cell.cardinfo["UISoldierCompose"]["numBMNode"]

            cell.composeMenu = cell.cardinfo["UISoldierCompose"]["recruitSoldierMenu"]
            -- local _node = UI_Hechenganniu()
            cell.texiaoNode = cell.cardinfo["UISoldierCompose"]["texiaoNode"]

            
            cell.itemMenuItem:setAllowScale(false)
            cell.comNotice:setVisible(false)
        end

        cell.index = idx

        -- local patchItem = self.c_SoldierData:getPatchDataByIndex(cell.index + 1)

        local patchItem = self.patchListData[idx + 1]


        local patchNum = patchItem.hero_chip_num
        local patchNo = patchItem.hero_chip_no
        cell.patchNo = patchNo

        print("item-----------", idx + 1)
        table.print(patchItem)
        -- print("item-----------")
        -- table.print(self.patchListData)
        -- print("item-----------end")

        local patchTempLate = self.c_SoldierTemplate:getChipTempLateById(patchNo)

        local nameStr = patchTempLate.language   --碎片名称

        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local combineResult = patchTempLate.combineResult
        local needNum = patchTempLate.needNum
        cell.needComposeNum = needNum

        cell.sodierName:setString(name)

        local numStr = string.format(patchNum) .. "/" .. string.format(needNum)
        cell.numBMLabel:setString(numStr)
        if patchNum >= needNum then cell.numBMLabel:setColor(ui.COLOR_GREEN)
        else cell.numBMLabel:setColor(ui.COLOR_WHITE) end   
        cell.numBMLabel:setVisible(false) 
        cell.numBMNode:removeChildByTag(1001)
        if patchItem.isCombin then
            if patchNum >= needNum then
                cell.comNotice:setVisible(true)
                cell.composeMenu:setEnabled(true)
                local _node = UI_Hechenganniu()
                cell.texiaoNode:removeAllChildren()
                cell.texiaoNode:addChild(_node)
            else
                cell.comNotice:setVisible(false)
                cell.composeMenu:setEnabled(false)
                cell.texiaoNode:removeAllChildren()
            end
        else
            cell.comNotice:setVisible(patchItem.isCombin) 
            cell.composeMenu:setEnabled(patchItem.isCombin)
            cell.texiaoNode:removeAllChildren() 
        end


        local richtext = ccui.RichText:create()
        richtext:setAnchorPoint(cc.p(0,0.5))
        richtext:setTag(1001)
        local re0 = ccui.RichElementText:create(1, ui.COLOR_BLUE2, 255, string.format(patchNum), "res/ccb/resource/Berlin.ttf", 22)
        richtext:pushBackElement(re0)
        local re1 = ccui.RichElementText:create(1, ui.COLOR_YELLOW, 255, tostring("/" .. needNum), "res/ccb/resource/Berlin.ttf", 22)
        richtext:pushBackElement(re1)
        cell.numBMNode:addChild(richtext)

        -----
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(combineResult)
        local quality = soldierTemplateItem.quality
        updateStarLV(cell.starTable, quality)

        -- local resIcon = self.chipTemp:getChipIconById(patchNo)
        -- setChipWithFrame(cell.headIcon, resIcon, quality) --更新icon
        local resIcon = self.c_SoldierTemplate:getSoldierIcon(combineResult) --新版icon
        setNewChipWithFrame(cell.headIcon, resIcon, quality, cell.itemBg) --更新icon  新版
        
        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)



        return cell
    end

    self.tableViewCompose = cc.TableView:create(self.layerSize)

    self.tableViewCompose:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewCompose:setDelegate()
    self.tableViewCompose:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.tableViewCompose)
    self.tableViewCompose:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableViewCompose:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewCompose:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewCompose:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.listLayer:removeChildByTag(999)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(999)
    scrBar:init(self.tableViewCompose,1)
    scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    self.tableViewTable[2] = self.tableViewCompose
end

--创建武将突破列表
function PVSoldierMain:createBreakListView()

    local function tableCellTouched(tbl, cell)
        print("PVSoldierBreak cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
        return table.nums(self.soldierListData)
    end
    local function cellSizeForTable(tbl, idx)

        return self.itemSize.height,self.itemSize.width
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()

        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

        if nil == cell then
            cell = cc.TableViewCell:new()

            local function breakMenuClick()
                getAudioManager():playEffectButton2()
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierBreakDetail", cell.soldierId)
                --stepCallBack(G_GUIDE_50005)
                groupCallBack(GuideGroupKey.BTN_WUJIANG_TUPO)
            end

            local function onItemClick()
                getAudioManager():playEffectButton2()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", cell.soldierId)
            end

            cell.cardinfo = {}
            cell.starTable = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISoldierMy"] = {}
            cell.cardinfo["UISoldierMy"]["breakMenuClick"] = breakMenuClick
            cell.cardinfo["UISoldierMy"]["lookMenuClick"] = breakMenuClick
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

        -- self.soldierDataItem = self.c_SoldierData:getSoldierItemByIndex(cell.index + 1)
        local soldierDataItem = self.soldierListData[cell.index+1]

        local soldierId = soldierDataItem.hero_no
        cell.soldierId = soldierId
        local break_level = soldierDataItem.break_level
        local soldier_level = soldierDataItem.level
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
        local nameStr = soldierTemplateItem.nameStr
        local name = self.c_LanguageTemplate:getLanguageById(nameStr)
        local quality = soldierTemplateItem.quality
        local level = soldierDataItem.level
        local atkValue = soldierDataItem.power --战斗力
        local sodierName = cell.cardinfo["UISoldierMy"]["soldierName"]  --名称
        local lvBMLabel = cell.cardinfo["UISoldierMy"]["lvBMLabel2"]  --突破等级
        local headIcon = cell.cardinfo["UISoldierMy"]["headIcon"]       --头像
        local levelNum = cell.cardinfo["UISoldierMy"]["levelNum"]       --炼体 sp
        local fightNum = cell.cardinfo["UISoldierMy"]["fightNum"]       --战斗力
        local fightCapacity = cell.cardinfo["UISoldierMy"]["fightCapacity"]  ----战斗力
        local soldierUpgrade = cell.cardinfo["UISoldierMy"]["soldierUpgrade"]       --升级按钮
        local soldierLook = cell.cardinfo["UISoldierMy"]["soldierLook"]          --查看按钮
        local soldierBreak = cell.cardinfo["UISoldierMy"]["soldierBreak"]           --突破按钮
        local itemBg = cell.cardinfo["UISoldierMy"]["itemBg"]           --品质背景
        local soldierKindSp = cell.cardinfo["UISoldierMy"]["soldierKindSp"]           --武将职业
        soldierBreak:setVisible(true)
        soldierLook:setVisible(false)
        -- fightNum:setVisible(false)

        local comNotice = cell.cardinfo["UISoldierMy"]["comNotice"]
        local limitLevel = self.c_SoldierTemplate:getMaxBreakLv(cell.soldierId)

        -- print(";;;;;;;;;;;;;    "..limitLevel)
        if break_level >= limitLevel then
            comNotice:setVisible(false)
            soldierBreak:setVisible(false)
            soldierLook:setVisible(true)
            -- soldierBreak:setEnabled(false)
            -- SpriteGrayUtil:drawSpriteTextureGray(soldierBreak:getNormalImage())  
        else
            comNotice:setVisible(false)
            soldierBreak:setEnabled(true)
            soldierBreak:setVisible(true)
            soldierLook:setVisible(false)
            -- SpriteGrayUtil:drawSpriteTextureColor(soldierBreak:getNormalImage())
        end


        -- 武将列表显示武将是否已上阵
        -- local soldierOnlineSprite = cell.cardinfo["UISoldierMy"]["busyStateBg"]         --已上阵bg
        local soldierOnlineLabel = cell.cardinfo["UISoldierMy"]["busySoldierState"]     --已上阵label
        -- soldierOnlineSprite:setVisible(soldierDataItem.is_online)
        soldierOnlineLabel:setVisible(soldierDataItem.is_online)
        if soldierDataItem.is_online and  soldierDataItem.is_cheer then
            -- soldierOnlineLabel:setString(Localize.query("soldier.9"))
        elseif soldierDataItem.is_online and  soldierDataItem.is_cheer == false then
            -- soldierOnlineLabel:setString(Localize.query("soldier.8"))
        end

        sodierName:setString(name)

        fightNum:setString(string.format(roundAttriNum(atkValue)))
        lvBMLabel:setString(string.format("等级%d", level))
        if self.player_level_max == soldier_level then
            lvBMLabel:setVisible(false)
            comNotice:setVisible(true)
        else
            lvBMLabel:setVisible(true)
            comNotice:setVisible(false)
        end
        levelNum:setSpriteFrame(self:updateBreakLv(break_level))
        if break_level < 1 then
            levelNum:setVisible(false)
        else
            levelNum:setVisible(true)
        end
        updateStarLV(cell.starTable, quality)

        local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)
        -- changeNewIconImage(headIcon, resIcon, quality) --更新icon
        changeNewSoldierIconImage(headIcon, resIcon, quality, itemBg) --新版更新icon
        local jobId = self.c_SoldierTemplate:getHeroTypeId(soldierId)
        setNewHeroTypeName(soldierKindSp,jobId)

        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

        return cell
    end

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("soldier/ui_soldier_my_item.ccbi", proxy, tempTable)

    local sizeLayer = tempTable["UISoldierMy"]["sizeLayer"]

    self.itemSize = sizeLayer:getContentSize()

    self.tableViewBreak = cc.TableView:create(self.layerSize)

    self.tableViewBreak:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewBreak:setDelegate()
    self.tableViewBreak:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.tableViewBreak)

    self.tableViewBreak:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableViewBreak:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewBreak:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewBreak:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.listLayer:removeChildByTag(999)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(999)
    scrBar:init(self.tableViewBreak,1)
    scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    self.tableViewTable[3] = self.tableViewBreak
end

--创建升级列表
function PVSoldierMain:createUpgradeListView()

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

        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

        if nil == cell then
            cell = cc.TableViewCell:new()

            local function upgradeMenuClick()
                getAudioManager():playEffectButton2()
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierUpgradeDetail", cell.soldierId)

                groupCallBack(GuideGroupKey.BTN_CLICK_UP_ATTACK)
            end

            local function onItemClick()
                getAudioManager():playEffectButton2()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", cell.soldierId)
            end

            cell.cardinfo = {}
            cell.starTable = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISoldierMy"] = {}
            cell.cardinfo["UISoldierMy"]["upgradeMenuClick"] = upgradeMenuClick
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

        -- self.soldierDataItem = self.c_SoldierData:getSoldierItemByIndex(cell.index + 1)
        local soldierDataItem = self.soldierListData[cell.index + 1]

        local soldierId = soldierDataItem.hero_no
        cell.soldierId = soldierId
        local break_level = soldierDataItem.break_level
        local soldier_level = soldierDataItem.level
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
        local nameStr = soldierTemplateItem.nameStr

        local name = self.c_LanguageTemplate:getLanguageById(nameStr)

        local quality = soldierTemplateItem.quality
        local level = soldierDataItem.level
        local finnalLevel = "等级" .. string.format(level)
        local atkValue = soldierDataItem.power --战斗力
        local sodierName = cell.cardinfo["UISoldierMy"]["soldierName"]  --名称
        local lvBMLabel = cell.cardinfo["UISoldierMy"]["lvBMLabel2"]     --等级
        local headIcon = cell.cardinfo["UISoldierMy"]["headIcon"]       --头像
        local levelNum = cell.cardinfo["UISoldierMy"]["levelNum"]       --炼体 sp
        local fightNum = cell.cardinfo["UISoldierMy"]["fightNum"]       --战斗力
        local fightCapacity = cell.cardinfo["UISoldierMy"]["fightCapacity"]  ----战斗力
        local soldierUpgrade = cell.cardinfo["UISoldierMy"]["soldierUpgrade"]       --升级按钮
        local soldierLook = cell.cardinfo["UISoldierMy"]["soldierLook"]          --查看按钮
        local soldierBreak = cell.cardinfo["UISoldierMy"]["soldierBreak"]           --突破按钮
        local itemBg = cell.cardinfo["UISoldierMy"]["itemBg"]           --品质背景
        local soldierKindSp = cell.cardinfo["UISoldierMy"]["soldierKindSp"]           --武将职业
        local comNotice = cell.cardinfo["UISoldierMy"]["comNotice"]
        soldierUpgrade:setVisible(true)
        soldierLook:setVisible(false)
        -- fightNum:setVisible(false)


        -- 武将列表显示武将是否已上阵
        -- local soldierOnlineSprite = cell.cardinfo["UISoldierMy"]["busyStateBg"]         --已上阵bg
        local soldierOnlineLabel = cell.cardinfo["UISoldierMy"]["busySoldierState"]     --已上阵label
        -- soldierOnlineSprite:setVisible(soldierDataItem.is_online)
        soldierOnlineLabel:setVisible(soldierDataItem.is_online)
        if soldierDataItem.is_online and  soldierDataItem.is_cheer then
            -- soldierOnlineLabel:setString(Localize.query("soldier.9"))
        elseif soldierDataItem.is_online and  soldierDataItem.is_cheer == false then
            -- soldierOnlineLabel:setString(Localize.query("soldier.8"))
        end

        sodierName:setString(name)
        lvBMLabel:setString(finnalLevel)
         if self.player_level_max == soldier_level then
            lvBMLabel:setVisible(false)
            comNotice:setVisible(true)
            soldierUpgrade:setEnabled(false)
            -- SpriteGrayUtil:drawSpriteTextureGray(soldierUpgrade:getNormalImage())      
        else
            lvBMLabel:setVisible(true)
            comNotice:setVisible(false)
            soldierUpgrade:setEnabled(true)
            -- SpriteGrayUtil:drawSpriteTextureColor(soldierUpgrade:getNormalImage())
        end
        levelNum:setSpriteFrame(self:updateBreakLv(break_level))
        if break_level < 1 then
            levelNum:setVisible(false)
        else
            levelNum:setVisible(true)
        end
        fightNum:setString(string.format(roundAttriNum(atkValue)))
        updateStarLV(cell.starTable, quality)


        local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)
        -- changeNewIconImage(headIcon, resIcon, quality) --更新icon
        changeNewSoldierIconImage(headIcon, resIcon, quality, itemBg) --新版更新icon
        local jobId = self.c_SoldierTemplate:getHeroTypeId(soldierId)
        setNewHeroTypeName(soldierKindSp,jobId)

        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

        return cell
    end

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("soldier/ui_soldier_my_item.ccbi", proxy, tempTable)

    local sizeLayer = tempTable["UISoldierMy"]["sizeLayer"]

    self.itemSize = sizeLayer:getContentSize()

    self.tableViewUpgrade = cc.TableView:create(self.layerSize)

    self.tableViewUpgrade:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableViewUpgrade:setDelegate()
    self.tableViewUpgrade:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.tableViewUpgrade)

    self.tableViewUpgrade:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableViewUpgrade:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableViewUpgrade:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableViewUpgrade:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.listLayer:removeChildByTag(999)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(999)
    scrBar:init(self.tableViewUpgrade,1)
    scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    self.tableViewTable[4] = self.tableViewUpgrade
end

-- 新手引导特殊处理
function PVSoldierMain:sortForNew( ... )
    local _item = getNewGManager():getNewBeeConfigById(GuideId.G_GUIDE_40003)  --G_GUIDE_40004
    local _itemHeroNo = _item.rewards["101"][3]
    local function comp_new(item1,item2)
        if item1.id == _itemHeroNo then return true end
        if item2.id == _itemHeroNo then return false end
    end 
    table.sort(self.soldierData,comp_new)
end


--返回更新
function PVSoldierMain:onReloadView()
    print("soldier main reloadView ...")
    local data = self.funcTable[1]

    print(data)
    print(type(data))

    if data == 80 then
        return
    end
    -- if data == -1 or data == nil then
    --     return
    -- else
    if data == 1 then
        self.doTableViewAction = false
    end
    self:initSort()
    print("reload view ...")
    self:updateSoldierData() -- 重上一个界面回来，更新下数据

end

function PVSoldierMain:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_soldier.plist")
end
-- 突破级别
function PVSoldierMain:updateBreakLv(level)
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


return PVSoldierMain
