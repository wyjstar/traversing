--武将升级详细页面
local PVSoldierUpgradeDetail = class("PVSoldierUpgradeDetail", BaseUIView)

function PVSoldierUpgradeDetail:ctor(id)
    PVSoldierUpgradeDetail.super.ctor(self, id)
end
function PVSoldierUpgradeDetail:onMVCEnter()
    self.UISoldierUpgradeDetail = {}
    self.starTable = {}
    self.eXPItemData = {} --经验丹数据
    self.useItemId = nil --使用的经验丹的id
    self.useItemNum = nil --使用的经验丹数量
    ONE_KEY_USE_ITEM = 1  --一键升级
    USE_ITEM = 2          --升级 
    self.useType = ONE_KEY_USE_ITEM
    self:initTouchListener()
    self:regeisterNetCallBack()
    self:loadCCBI("soldier/ui_soldier_upgrade_detail.ccbi", self.UISoldierUpgradeDetail)
    self.c_SodierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()

    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_SoldierNet = getNetManager():getSoldierNet()
    self.bagData = getDataManager():getBagData()
    self.c_CommonData = getDataManager():getCommonData()
    self.c_BagTemplate = getTemplateManager():getBagTemplate()
    self.stageData = getDataManager():getStageData()
    self.c_ChipTemplate = getTemplateManager():getChipTemplate()


    self:initView()
    self:createListView()
    self:createExpProgress()

    self:updateData()
    self:updateAttributeView(self.level)
    self:updateSelectData(1)
    -- 初始化的赋值
    local curLevelMaxExp = self.c_SoldierTemplate:getHeroExpByLevel(self.level)
    self.labelHeroExp:setString(tostring(self.exp).."/"..tostring(curLevelMaxExp))
    self.expPrgress:setPercentage(self.exp/curLevelMaxExp * 100)

end

--注册网络回调
function PVSoldierUpgradeDetail:regeisterNetCallBack()

    local function onSoldierUpgradeCallBack(id, data)

        if data.res.result == true then
            print("upgrade ..", data.level, data.exp)
            local preLevel = self.level
            self.level = data.level
            self.exp = data.exp
            print("level: ", preLevel, self.level)
            print("-------------self.useItemNum:------------- ", self.useItemNum)
            self.bagData:updatePropItem(self.useItemId, self.useItemNum)
            self.c_SodierData:changeSoldierExp(self.soldierId, self.level, self.exp)
            getDataManager():getLineupData():changeSelectSoldierExp(self.soldierId, self.level, self.exp)
            getDataManager():getLineupData():changeCheerSoldierExp(self.soldierId, self.level, self.exp)
        
            self.__menu_enable = false
            self:updateExp(preLevel, self.level)  -- 更新经验条
            if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30012 then
                print("addChild ShieldLayer")
                self:createTopShieldLayer()
                local guidInfo = getNewGManager():getCurrentInfo()
                getNewGManager():sendGuidProtocol(true,guidInfo["skip_to"])
            end

            self:updateData()
        end
    end

    self:registerMsg(NET_ID_HERO_UPGRADE, onSoldierUpgradeCallBack)
end

function PVSoldierUpgradeDetail:initTouchListener()
    local function backMenuClick()
        getAudioManager():playEffectButton2()
        groupCallBack(GuideGroupKey.BTN_CLOSE_WUJIANG_UP)
        self:onHideView()
    end

    local function getMenuClick()
        -- self:toastShow("商城道具购买未开放")
        -- getOtherModule():showAlertDialog(nil, "商城道具购买未开放")
        getModule(MODULE_NAME_SHOP):showUIView("PVShopPage", 3)
       -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGetSoldier", 1)  -- to do
    end

    -- 获取
    local function getItemClick()
        getAudioManager():playEffectButton2()
        local itemId = self.useItemId
        -- getOtherModule():showOtherView("PVCommonDetail", 1, itemId, 2)
        if itemId == nil then 
            getModule(MODULE_NAME_SHOP):showUIView("PVShopPage", 3)
            return
        end
        
        if itemId == 2 then
            getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
        elseif itemId == 3 then
            local _stageId = self.c_BagTemplate:getHeroSacrificeOpenStage()
            local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
            if _isOpen then
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSmeltView")
            else
                getStageTips(_stageId)
                return
            end 
        elseif itemId == 13 then                                             --煮酒
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActivityPage", 5)
        else
            local itemToGetId = self.c_BagTemplate:getToGetById(itemId)
            local _data =  self.c_ChipTemplate:getDropListById(itemToGetId)
            if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
                and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
                and _data.arenaShop == 0 and _data.stageBreak == 0 and _data.isStage == 0 and (type(_data.isEliteStage) == "table" and table.nums(_data.isEliteStage) == 0)
                and _data.isActiveStage then
                    print("false ----------------------- ")
                    local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
                    getOtherModule():showAlertDialog(nil, tipText)
            else
                getOtherModule():showOtherView("PVChipGetDetail", _data, itemId)
            end
        end
    end

    -- 使用
    local function useMenuClick()
        self.useType = USE_ITEM
        getAudioManager():playEffectButton2()
        if self.useItemNum <= 0 then
            getOtherModule():showAlertDialog(nil, Localize.query("soldier.13"))
        else
            local limitLevel = getDataManager():getCommonData():getLevel()
            local hero_no = self.soldierDataItem.hero_no
            local exp_item_no = self.useItemId
            local exp_item_num = 1
            self.useItemNum = exp_item_num
            if self.level >= limitLevel then
                local _needTotalExp = self.c_SoldierTemplate:getHeroExpByLevel(self.level) - self.exp
                if _needTotalExp == 0 then
                    getOtherModule():showAlertDialog(nil, Localize.query("soldier.3"))
                else
                    self.c_SoldierNet:sendSoldierUpgrade(hero_no, exp_item_no, exp_item_num)
                end
            else
                self.c_SoldierNet:sendSoldierUpgrade(hero_no, exp_item_no, exp_item_num)
            end
        end
    end

    -- 一键使用
    local function useAllClick()
        self.useType = ONE_KEY_USE_ITEM
        getAudioManager():playEffectButton2()
        if self.useItemNum <= 0 then
            getOtherModule():showAlertDialog(nil, Localize.query("soldier.13"))
        else
            local limitLevel = getDataManager():getCommonData():getLevel()
            local hero_no = self.soldierDataItem.hero_no
            local exp_item_no = self.useItemId
            local exp_item_num = self.useItemNum
            --升级到当前战队等级所需经验
            local propItem = self.c_BagTemplate:getItemById(exp_item_no)
            local _addExp = tonum(propItem.funcArg1)
            local _totalExp = tonum(_addExp) * tonum(exp_item_num)
            if self.level >= limitLevel then
                local _needTotalExp = self.c_SoldierTemplate:getHeroExpByLevel(self.level) - self.exp
                if _needTotalExp == 0 then
                    getOtherModule():showAlertDialog(nil, Localize.query("soldier.3"))
                    groupCallBack(GuideGroupKey.BTN_QUICK_USE, hero_no) 
                else
                    if _needTotalExp < _totalExp then
                        local _needPropNum = math.ceil(_needTotalExp / _addExp)
                        self.useItemNum = _needPropNum
                        exp_item_num = _needPropNum
                    end
                    self.c_SoldierNet:sendSoldierUpgrade(hero_no, exp_item_no, exp_item_num)
                end
            else
                local  _needTotalExp = 0
                for i = 1, limitLevel - self.level + 1 do
                    if i == 1 then
                        _needTotalExp = self.c_SoldierTemplate:getHeroExpByLevel(self.level+1) - self.exp
                    else
                        _needTotalExp = _needTotalExp + self.c_SoldierTemplate:getHeroExpByLevel(self.level+i)
                    end
                end
                if _needTotalExp < _totalExp then
                    local _needPropNum = math.ceil(_needTotalExp / _addExp)
                    self.useItemNum = _needPropNum
                    exp_item_num = _needPropNum
                end
                self.c_SoldierNet:sendSoldierUpgrade(hero_no, exp_item_no, exp_item_num)
            end 
        end
    end

    self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"] = {}
    self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["backMenuClick"] = backMenuClick
    self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["getMenuClick"] = getMenuClick
    self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["useAllClick"] = useAllClick
    self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["useMenuClick"] = useMenuClick
    self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["getItemClick"] = getItemClick

end

function PVSoldierUpgradeDetail:initView()
    self.animationManager = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["mAnimationManager"]
    self.lvBMLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["lvBMLabel"]
    -- self.nameLayer = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["nameLayer"]
    self.atkLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["atkLabel"]
    self.pdefLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["pdefLabel"]
    self.hpLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["hpLabel"]
    self.mdefLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["mdefLabel"]

    self.addAtkLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["addAtkLabel"]
    self.addPdefLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["addPdefLabel"]
    self.addHpLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["addHpLabel"]
    self.addMdefLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["addMdefLabel"]

    self.expLayer = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["expLayer"]
    self.labelHeroExp = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["label_heroexp"]
    self.contentLayer = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["contentLayer"]
    self.heroNode = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["heroNode"]
    self.getItemNode = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["getItemNode"]
    self.animationNode = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["animationNode"]
    self.typeSprite = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["typeSprite"]
    self.heroNameLabel = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["heroNameLabel"]
    self.itemDesc = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["itemDesc"]
    self.breakLvBg = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["breakLvBg"]
    self.effectOnBtn = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["effectOnBtn"]

    local starSelect1 = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["starSelect1"]
    local starSelect2 = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["starSelect2"]
    local starSelect3 = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["starSelect3"]
    local starSelect4 = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["starSelect4"]
    local starSelect5 = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["starSelect5"]
    local starSelect6 = self.UISoldierUpgradeDetail["UISoldierUpgradeDetail"]["starSelect6"]
    table.insert(self.starTable, starSelect1)
    table.insert(self.starTable, starSelect2)
    table.insert(self.starTable, starSelect3)
    table.insert(self.starTable, starSelect4)
    table.insert(self.starTable, starSelect5)
    table.insert(self.starTable, starSelect6)


    self.effectOnBtn:setVisible(false)
    -- self.itemDesc:setVisible(false)
    self.__menu_enable = true
end

function PVSoldierUpgradeDetail:updateSoldierImage()
    local soldierId = self.soldierDataItem.hero_no
    addHeroHDSpriteFrame(soldierId)
    --更新英雄大图
    self.heroNode:removeAllChildren()
    local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(soldierId)
    self.heroNode:addChild(heroImageNode)
end

-- 创建经验条
function PVSoldierUpgradeDetail:createExpProgress()

    local expImgBg = game.newSprite("#ui_soldier_pro_lan.png")
    expImgBg:setAnchorPoint(cc.p(0, 0.5))
    local expGressImg = game.newSprite("#ui_soldier_up_slider2.png")
    expGressImg:setAnchorPoint(cc.p(0, 0.5))
    self.expPrgress = cc.ProgressTimer:create(expGressImg)
    self.expPrgress:setAnchorPoint(cc.p(0, 0.5))
    self.expPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.expPrgress:setBarChangeRate(cc.p(1, 0))
    self.expPrgress:setMidpoint(cc.p(0, 0))
    self.expLayer:addChild(expImgBg, 0)
    local _posx,_posy = self.expPrgress:getPosition()
    self.expPrgress:setPosition(cc.p(_posx+8,_posy))
    self.expLayer:addChild(self.expPrgress, 1)
end

-- 更新exp动画
function PVSoldierUpgradeDetail:updateExp(preLevel, curLevel)
    if preLevel > curLevel then return end

    self.animationNode:removeChildByTag(121)
    self._upgradeFlag = true
    self.__start_effect = true


    self.tableView:setTouchEnabled(false)

    local times = curLevel - preLevel
    local dt = nil
    if times >= 4 then dt = 5 / times
    else dt = 1
    end
    -- 播放升级特效
    local function upgradeEffects()
        if self._upgradeFlag == false then return end
        local node = UI_Wujiangshengjirenwushengjiyijian(upgradeEffects)

        node:setTag(121)
        self.animationNode:removeChildByTag(121)
        self.animationNode:addChild(node)
    end

    local progress = {}
    for i=1, times do
        local function CallbackTo() -- 升级特效，更换等级，经验更改，经验条值为0
             if self.__start_effect == true then
                upgradeEffects()
                self._upgradeFlag = false
                self.__start_effect = false
            end

            local curLevelMaxExp = self.c_SoldierTemplate:getHeroExpByLevel(preLevel)
            -- print(tostring(curLevelMaxExp).."/"..tostring(curLevelMaxExp))
            self.labelHeroExp:setString(tostring(curLevelMaxExp).."/"..tostring(curLevelMaxExp))

            preLevel = preLevel + 1
            self:updateAttributeView(preLevel)
        end
        local to1 = cc.ProgressTo:create(dt, 100)
        local to2 = cc.ProgressTo:create(0.001, 0)
        local callback = cc.CallFunc:create(CallbackTo)
        table.insert(progress, to1)
        table.insert(progress, to2)
        table.insert(progress, callback)
    end
     ----战力提升
    self.c_CommonData.updateCombatPower()

    local function setBtnEnabled()
        self._upgradeFlag = false
        self.tableView:setTouchEnabled(true)

        self.__menu_enable = true
        self.tableView:reloadData()

        local curLevelMaxExp = self.c_SoldierTemplate:getHeroExpByLevel(curLevel)

        self.expPrgress:setPercentage(self.exp/curLevelMaxExp * 100)
        self.labelHeroExp:setString(tostring(self.exp).."/"..tostring(curLevelMaxExp))

        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30012 then
            print("remove ShieldLayer")
            self:removeTopShieldLayer()
        end

        groupCallBack(GuideGroupKey.BTN_QUICK_USE, hero_no)
    end

    local from = nil
    if preLevel == curLevel then
        from = self.expPrgress:getPercentage()
    else from = 0 end

    local lastRadio = self.exp / self.c_SoldierTemplate:getHeroExpByLevel(curLevel)
    local lastProTo = cc.ProgressFromTo:create( dt * lastRadio, from, lastRadio*100 )
    local callback1 = cc.CallFunc:create(setBtnEnabled)

    table.insert(progress, lastProTo)
    table.insert(progress, callback1)

    self.expPrgress:runAction(cc.Sequence:create(progress))

end

function PVSoldierUpgradeDetail:updateData()

    -- self.soldierDataItem = self.c_SodierData:getSoldierItemByIndex(self.index)
    soldierId = self:getTransferData()[1]
    print("soldierId", soldierId)
    if soldierId ~= nil then
        self.soldierDataItem = self.c_SodierData:getSoldierDataById(soldierId)

        self.soldierId = self.soldierDataItem.hero_no

        if self.level == nil and self.exp == nil then
            self.level = self.soldierDataItem.level
            self.exp = self.soldierDataItem.exp
        end
        -- 武将职业
        local jobId = self.c_SoldierTemplate:getHeroTypeId(self.soldierId)
        local _spriteJob = nil
        print("----jobId-----",jobId)
        if jobId == 1 then
            _spriteJob = "ui_comNew_kind_001.png"
        elseif jobId == 2 then
            _spriteJob = "ui_comNew_kind_002.png"
        elseif jobId == 3 then
            _spriteJob = "ui_comNew_kind_003.png"
        elseif jobId == 4 then
            _spriteJob = "ui_comNew_kind_004.png"
        elseif jobId == 5 then
            _spriteJob = "ui_comNew_kind_005.png"
        end
        self.typeSprite:setSpriteFrame(_spriteJob)
        -- 武将名
        local _name = self.c_SoldierTemplate:getHeroName(self.soldierId)
        self.heroNameLabel:setString(_name)
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(self.soldierId)
        local quality = soldierTemplateItem.quality
        updateStarLV(self.starTable, quality) --更新星级
        local color = ui.COLOR_GREEN
        if quality == 1 or quality == 2 then
            color = ui.COLOR_GREEN
        elseif quality == 3 or quality == 4 then
            color = ui.COLOR_BLUE
        elseif quality == 5 or quality == 6 then
            color = ui.COLOR_PURPLE
        end
        self.heroNameLabel:setColor(color)
        -- 突破等级
        local break_level = self.soldierDataItem.break_level
        if break_level == 0 then 
            self.breakLvBg:setVisible(false)
        else
            local strImg = "ui_lineup_number"..tostring(break_level)..".png"
            self.breakLvBg:setSpriteFrame(strImg)
            self.breakLvBg:setVisible(true)
        end


        self:updateSoldierImage()
        self:updateItemList()
        self.tableView:reloadData()
    end    
end

function PVSoldierUpgradeDetail:updateItemList()
    self.eXPItemData = {}
    self.selectIDTable = {} 
    local _eXPItemData = self.bagData:getEXPItemData()
    -- print("----------_eXPItemData----------")
    -- table.print(_eXPItemData)
    for k,v in pairs(_eXPItemData) do
        table.insert(self.eXPItemData,v)
    end

    local function comp(a,b)
        if a.item.id < b.item.id then
            return true
        end
    end 
    table.sort(self.eXPItemData,comp)
    local index = 0
    for k,v in pairs(self.eXPItemData) do
        index = index + 1
        if self.useItemId ~= nil then
            if self.useItemId == v.item.id then self.useItemNum = v.itemNum end
            self.selectIDTable[v.item.id] = {["index"] = index,["selected"] = false,["describe"] = v.item.describe}
        else
            if index == 1 then
                self.useItemId = v.item.id
                self.useItemNum = v.itemNum 
                self.selectIDTable[v.item.id] = {["index"] = index,["selected"] = true,["describe"] = v.item.describe}
            else
                self.selectIDTable[v.item.id] = {["index"] = index,["selected"] = false,["describe"] = v.item.describe}
            end
        end
    end

    -- local size = table.getn(self.eXPItemData)
    -- if size == 0 then 
    --     self.getItemNode:setVisible(true)
    --     self.itemDesc:setVisible(false)
    -- else 
    --     self.getItemNode:setVisible(false)
    --     self.itemDesc:setVisible(true) 
    -- end
end

--更新属性
function PVSoldierUpgradeDetail:updateAttributeView(levelTo)
    local soldierId = self.soldierDataItem.hero_no
    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)

    local break_level = self.soldierDataItem.break_level
    local nameStr = soldierTemplateItem.nameStr

    local level = levelTo

    local attr = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
    self.atkLabel:setString(string.format(roundAttriNum(attr.atkHero)))
    self.pdefLabel:setString(string.format(roundAttriNum(attr.physicalDefHero)))
    self.hpLabel:setString(string.format(roundAttriNum(attr.hpHero)))
    self.mdefLabel:setString(string.format(roundAttriNum(attr.magicDefHero)))
    local _maxLevel =  getTemplateManager():getBaseTemplate():getMaxLevel()
    if level >= _maxLevel then
        self.addAtkLabel:setVisible(false)
        self.addPdefLabel:setVisible(false)
        self.addHpLabel:setVisible(false)
        self.addMdefLabel:setVisible(false)
    else
        self.soldierDataItem.level = self.soldierDataItem.level + 1
        local attr_next = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
        self.soldierDataItem.level = self.soldierDataItem.level - 1
        self.addAtkLabel:setString("+ " .. string.format(roundAttriNum(attr_next.atkHero - attr.atkHero)))
        self.addPdefLabel:setString("+ " .. string.format(roundAttriNum(attr_next.physicalDefHero - attr.physicalDefHero)))
        self.addHpLabel:setString("+ " .. string.format(roundAttriNum(attr_next.hpHero - attr.hpHero)))
        self.addMdefLabel:setString("+ " .. string.format(roundAttriNum(attr_next.magicDefHero - attr.magicDefHero)))
        self.addAtkLabel:setVisible(true)
        self.addPdefLabel:setVisible(true)
        self.addHpLabel:setVisible(true)
        self.addMdefLabel:setVisible(true)
    end

    --更新等级
    print("-------level------",level)
    local levelNode = getLevelNode(level)
    self.lvBMLabel:removeAllChildren()
    self.lvBMLabel:addChild(levelNode)
end

-- 更新选框
function PVSoldierUpgradeDetail:updateSelectData(tag)
    for k,v in pairs(self.selectIDTable) do
        if v.index ~= tag then
            v.selected = false
            -- v.selectMenu:setVisible(false)
        else
            local descibe_chinese = self.c_LanguageTemplate:getLanguageById(v.describe)
            self.itemDesc:setString(descibe_chinese)
            print("--------descibe_chinese---------",descibe_chinese)
        end
    end
end

function PVSoldierUpgradeDetail:createListView()

    local function tableCellTouched(tbl, cell)
        print("PVSoldierUpgradeDetail cell touched at index: " .. cell:getIdx())
        local id = cell.itemId
        self.useItemId = id
        self.useItemNum = self.eXPItemData[cell:getIdx() + 1].itemNum
        self:updateSelectData(self.selectIDTable[id]["index"])
    end
    local function numberOfCellsInTableView(tab)
       return table.getn(self.eXPItemData)
    end
    local function cellSizeForTable(tbl, idx)

        return self.itemSize.height,self.itemSize.width
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()

        if nil == cell then
            cell = cc.TableViewCell:new()
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIPillItem"] = {}
            local node = CCBReaderLoad("soldier/ui_soldier_pill_item.ccbi", proxy, cell.cardinfo)

            cell:addChild(node)

            cell.soldierName = cell.cardinfo["UIPillItem"]["soldierName"]
            cell.numLabel = cell.cardinfo["UIPillItem"]["numLabel"]
            cell.itemDesc = cell.cardinfo["UIPillItem"]["itemDesc"]
            cell.headIcon = cell.cardinfo["UIPillItem"]["headIcon"]
            cell.qualitySprite = cell.cardinfo["UIPillItem"]["qualitySprite"]
            cell.animationNode = cell.cardinfo["UIPillItem"]["animationNode"]
            cell.useMenuItem = cell.cardinfo["UIPillItem"]["useMenuItem"]
            cell.useAllMenuItem = cell.cardinfo["UIPillItem"]["useAllMenuItem"]
            -- cell.selectMenuSprite = cell.cardinfo["UIPillItem"]["selectMenu"]

            cell.itemMenuItem = cell.cardinfo["UIPillItem"]["itemMenuItem"]
            cell.itemMenuItem:setAllowScale(false)
        end

        cell.index = idx
        cell.itemId = self.eXPItemData[idx+1].item.id
        -- cell.selectMenuSprite:setVisible(self.selectIDTable[cell.itemId]["selected"])
        -- self.selectIDTable[cell.itemId].selectMenu = cell.selectMenuSprite
        if self.__menu_enable == true then
            cell.useMenuItem:setEnabled(true)
            cell.useAllMenuItem:setEnabled(true)
            cell.itemMenuItem:setEnabled(true)
        elseif self.__menu_enable == false then
            cell.useMenuItem:setEnabled(false)
            cell.useAllMenuItem:setEnabled(false)
            cell.itemMenuItem:setEnabled(false)
        end

        cell.animationNode:removeAllChildren()
        if self.cur_cell == cell.itemId then  ---idx
            local node = UI_Wujiangshengjidanyao()
            cell.animationNode:addChild(node)
            self.cur_cell = nil
        end

        local cur_item_num = self.eXPItemData[idx+1].itemNum
        cell.numLabel:setString(string.format(cur_item_num))

        if cur_item_num == 0 then
            cell.useMenuItem:setEnabled(false)
            cell.useAllMenuItem:setEnabled(false)
            cell.itemMenuItem:setEnabled(false)
        end

        local name_chinese = self.c_LanguageTemplate:getLanguageById(self.eXPItemData[idx+1].item.name)
        local cur_item_num = self.eXPItemData[idx+1].itemNum
        local descibe_chinese = self.c_LanguageTemplate:getLanguageById(self.eXPItemData[idx+1].item.describe)
        local cur_item_res = self.eXPItemData[idx+1].item.res
        local itemSpriteName = self.c_ResourceTemplate:getResourceById(cur_item_res)

        cell.soldierName:setString(name_chinese)
        cell.numLabel:setString(string.format(cur_item_num))
        cell.itemDesc:setString(descibe_chinese)
        cell.headIcon:setTexture("res/icon/item/"..itemSpriteName)
        setItemImage3(cell.headIcon, itemSpriteName, self.eXPItemData[idx+1].item.quality)
        cell.qualitySprite:setVisible(false)

        return cell
    end

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local item = CCBReaderLoad("soldier/ui_soldier_pill_item.ccbi", proxy, tempTable)
    local itemNode = tempTable["UIPillItem"]["itemNode"]
    local layerSize = self.contentLayer:getContentSize()

    self.itemSize = itemNode:getContentSize()
    self.tableView = cc.TableView:create(layerSize)

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.tableView)
    --self.tableView:reloadData()

    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)
end


return PVSoldierUpgradeDetail
