
-- 查看自己占领和别人占领的矿点信息

local PVSecretPlaceSeizeMineInfo = class("PVSecretPlaceSeizeMineInfo", BaseUIView)

function PVSecretPlaceSeizeMineInfo:ctor(id)
    self.super.ctor(self, id)
end

function PVSecretPlaceSeizeMineInfo:onMVCEnter()
    self:showAttributeView()

    self.UISecretMySeizeMine = {}
    self.baseRuneSprite = {}
    self.luckyRuneSprite = {}
    self.mine = getDataManager():getMineData():getCurrentMine()
    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.stageData = getDataManager():getStageData()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.runeData = getDataManager():getRuneData()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.c_MineData = getDataManager():getMineData()

    self.detailInfo = getDataManager():getMineData()

    self:initTouchListener()

    self:loadCCBI("secretTerritory/ui_secret_mySeizeMine.ccbi", self.UISecretMySeizeMine)

    self:initView()

    self:initRegisterNetCallBack()

    local function onNodeEvent(event)
        if "exit" == event then
            if self.onExit ~= nil then
                self:onExit()
            end
        end
    end

    self:registerScriptHandler(onNodeEvent)
    print("---------PVSecretPlaceSeizeMineInfo:onMVCEnter==========")
    print("PVSecretPlaceSeizeMineInfo",self.mine)
    print("number of self.mine"..table.nums(self.mine))
    -- table.print(self.mine)    
    self.tem = {}
    for k,v in pairs(self.mine) do
        if k ~= "lineup" then
           self.tem[k]=v
        end
    end
    table.print(self.tem)
    print("---------PVSecretPlaceSeizeMineInfo:onMVCEnter==========")
  
end

function PVSecretPlaceSeizeMineInfo:onExit()
    cclog("-----PVSecretPlaceSeizeMineInfo--onExit----")
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_secretTerritory.plist")

    if self._scheduerSeizeMineLeftTime ~= nil then
         timer.unscheduleGlobal(self._scheduerSeizeMineLeftTime)
         self._scheduerSeizeMineLeftTime = nil
    end
end

function PVSecretPlaceSeizeMineInfo:initView()
    self.baseRuneSprite = {}   -- 基础产出 符文
    self.luckyRuneSprite = {}   -- 幸运产出 符文
    self.luckyRuneMenuItem = {}   -- 幸运产出 符文
    self.baseRuneMenuItem = {}   -- 幸运产出 符文
    
    for i=1,4 do
        local _baseName = string.format("baseRuneSprite%d", i)
        local _baseRuneSprite = self.UISecretMySeizeMine["UISecretMySeizeMine"][_baseName]
        _baseRuneSprite:setVisible(false)
        table.insert(self.baseRuneSprite, _baseRuneSprite)

        local _baseItemName = string.format("baseMenuItem%d", i)
        local _baseRuneItem = self.UISecretMySeizeMine["UISecretMySeizeMine"][_baseItemName]
        _baseRuneItem:setVisible(false)
        _baseRuneItem:getNormalImage():setOpacity(0)
        table.insert(self.baseRuneMenuItem, _baseRuneItem)


        local _luckyName = string.format("luckyRuneSprite%d", i)
        local _luckyRuneSprite = self.UISecretMySeizeMine["UISecretMySeizeMine"][_luckyName]
        _luckyRuneSprite:setVisible(false)
        table.insert(self.luckyRuneSprite, _luckyRuneSprite)

        local _luckyItemName = string.format("luckyMenuItem%d", i)
        local _luckyRuneItem = self.UISecretMySeizeMine["UISecretMySeizeMine"][_luckyItemName]
        _luckyRuneItem:setVisible(false)
        _luckyRuneItem:getNormalImage():setOpacity(0)
        table.insert(self.luckyRuneMenuItem, _luckyRuneItem)
    end

    self.addOutput = self.UISecretMySeizeMine["UISecretMySeizeMine"]["addOutput"]  -- 单位量产
    self.maxOutput = self.UISecretMySeizeMine["UISecretMySeizeMine"]["maxOutput"]  -- 最大储量
    self.proTime = self.UISecretMySeizeMine["UISecretMySeizeMine"]["proTime"]  -- 产出时间
    self.fightNum = self.UISecretMySeizeMine["UISecretMySeizeMine"]["fightNum"]  -- 战力
    self.normalCurrOutput = self.UISecretMySeizeMine["UISecretMySeizeMine"]["normalCurrOutput"]  -- 基础当前产出
    self.luckyCurrOutputLabel = self.UISecretMySeizeMine["UISecretMySeizeMine"]["luckyCurrOutput"]  -- 产出时间


    self.wushuangName = self.UISecretMySeizeMine["UISecretMySeizeMine"]["wushuangName"]  -- 无双名字
    self.wushuangIcon = self.UISecretMySeizeMine["UISecretMySeizeMine"]["WushuangIconSprite"]  -- 无双图标
    self.wushuangDes = self.UISecretMySeizeMine["UISecretMySeizeMine"]["wushuangDes"]  -- 无双描述

    self.baohuTime = self.UISecretMySeizeMine["UISecretMySeizeMine"]["baohuTime"]  -- 保护剩余时间

    self.robRuneLabel = self.UISecretMySeizeMine["UISecretMySeizeMine"]["robRuneLabel"]  -- 可抢夺多少符文
    self.changeLineupLabel = self.UISecretMySeizeMine["UISecretMySeizeMine"]["changeLineupLabel"]  

    self.otherMineLayer = self.UISecretMySeizeMine["UISecretMySeizeMine"]["otherMineLayer"] -- 其他人占领的layer
    self.meMineLayer = self.UISecretMySeizeMine["UISecretMySeizeMine"]["meMineLayer"] -- 自己占领的layer
    self.yeguaiMainLayer = self.UISecretMySeizeMine["UISecretMySeizeMine"]["yeguaiMainLayer"] -- 野怪占领的layer

    self.shouhuoBtn = self.UISecretMySeizeMine["UISecretMySeizeMine"]["shouhuoBtn"] -- 自己占领的layer

    self.heroSpriteA = self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroSpriteA"] -- 武将头像
    self.heroSpriteB = self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroSpriteB"] -- 武将头像
    self.heroSpriteC = self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroSpriteC"] -- 武将头像
    self.heroSpriteD = self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroSpriteD"] -- 武将头像
    self.heroSpriteE = self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroSpriteE"] -- 武将头像
    self.heroSpriteF = self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroSpriteF"] -- 武将头像

    self.tarvelBottomLabel = self.UISecretMySeizeMine["UISecretMySeizeMine"]["tarvelBottomLabel"] -- 武将头像

    self.outputLefttime = self.UISecretMySeizeMine["UISecretMySeizeMine"]["outputLefttime"] -- 产出剩余时间
    self.labelTime = self.UISecretMySeizeMine["UISecretMySeizeMine"]["labelTime"]

    self:updateUIInfo()
end

function PVSecretPlaceSeizeMineInfo:getMineType()
    --1野怪，2，其他玩家占领，3自己占领
    if self.mine.type == 2 then
        return 1
    else
        if self.mine.nickname == getDataManager():getCommonData():getUserName() then
            return 3
        else
            return 2
        end
    end
end

-- 更新UI
function PVSecretPlaceSeizeMineInfo:updateUIInfo()
    -- 更新基础产出和幸运产出
    local _nomals = self.detailInfo:getNormals()
    for k,v in pairs(_nomals) do
        -- print(k,v.stone_id)
        local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.stone_id)

        self:setItemImage(self.baseRuneSprite[k], _respng, _quality)
        self.baseRuneSprite[k]:setVisible(true)
        self.baseRuneMenuItem[k]:setVisible(true)
    end

    local _luckys = self.detailInfo:getLuckys()
    for k,v in pairs(_luckys) do
        local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.stone_id)
        self:setItemImage(self.luckyRuneSprite[k], _respng, _quality)
        self.luckyRuneSprite[k]:setVisible(true)
        self.luckyRuneMenuItem[k]:setVisible(true)
    end

    stype = self.mine.type
    nickname = self.mine.nickname

    if stype == 2 then
        self.yeguaiMainLayer:setVisible(true)
        self.otherMineLayer:setVisible(false)
        self.meMineLayer:setVisible(false)
        local strGen = string.format("%d/%s", self.detailInfo:getUnit(self.mine.position), Localize.query("PVSecretPlaceMyMineInfo.1"))
        self.addOutput:setString(strGen)
        self.proTime:setString(self.mine.gen_time..Localize.query("PVSecretPlaceMyMineInfo.1"))
    else
        if nickname == getDataManager():getCommonData():getUserName() then
            self.yeguaiMainLayer:setVisible(false)
            self.otherMineLayer:setVisible(false)
            self.meMineLayer:setVisible(true)
            self.shouhuoBtn:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.shouhuoBtn:getNormalImage())
            
            local strGen = string.format("%d/%s", self.detailInfo:getUnit(self.mine.position), Localize.query("PVSecretPlaceMyMineInfo.1"))
            self.addOutput:setString(strGen)
            -- self.maxOutput:setString(self.detailInfo:getNormalNum(self.mine.position)..'/'..self.detailInfo:getLimit(self.mine.position))
            self.maxOutput:setString(self.detailInfo:getNormalNum(self.mine.position)..'/200')
            self.proTime:setString(self.mine.gen_time..Localize.query("PVSecretPlaceMyMineInfo.1"))
            -- print(self.mine.guard_time)
            self.ltime = self.mine.guard_time - getDataManager():getCommonData():getTime()
            cclog("self.mine.guard_time"..self.mine.guard_time.."getDataManager():getCommonData():getTime()"..getDataManager():getCommonData():getTime().."产出时间："..self.ltime)
            if self.ltime <= 0 then self.ltime = 0 end
                -- local str = string.format('%d'..Localize.query("PVSecretPlaceMyMineInfo.1"), ltime/60)
                -- self.baohuTime:setString(str)
            self.baohuTime:setString(string.format("%02d:%02d:%02d",math.floor(self.ltime/3600), math.floor(self.ltime%3600/60), self.ltime%60))
            
            self.labelTime:setString(string.format("攻占成功后，会获得%02d分钟的保护哦！很贴心吧",getTemplateManager():getSecretplaceTemplate():getMineProtectTimeFree()))
            self.outputLtime = self.mine.last_time - getDataManager():getCommonData():getTime()
            -- if self.outputLtime <= 0 then self.outputLtime = 0 end
            if self.outputLtime <= 0 then 
                self.outputLtime = 0 
                self.shouhuoBtn:setEnabled(true)
                SpriteGrayUtil:drawSpriteTextureColor(self.shouhuoBtn:getNormalImage())
            end

            -- if self.mine.status == 2 then
            --     self.shouhuoBtn:setEnabled(true)
            --     SpriteGrayUtil:drawSpriteTextureColor(self.shouhuoBtn:getNormalImage())
            -- else
            --     self.shouhuoBtn:setEnabled(false)
            --     SpriteGrayUtil:drawSpriteTextureGray(self.shouhuoBtn:getNormalImage())
            -- end

            self.outputLefttime:setString(string.format("%02d:%02d:%02d",math.floor(self.outputLtime/3600), math.floor(self.outputLtime%3600/60), self.outputLtime%60))

            -- 开启保护剩余时间
            self:startLeftTime()
        else
            self.yeguaiMainLayer:setVisible(false)
            --self.meMineLayer:setVisible(true)
            self.meMineLayer:setVisible(false)
            self.otherMineLayer:setVisible(true)
            local strGen = string.format("%d/%s", self.detailInfo:getUnit(self.mine.position), Localize.query("PVSecretPlaceMyMineInfo.1"))
            self.addOutput:setString(strGen)
            self.baohuTime:setVisible(false)
            self.luckyCurrOutputLabel:setString("当前产量:")
            self.proTime:setString(self.detailInfo:getLuckyNum(self.mine.position))
            self.normalCurrOutput:setString(self.detailInfo:getNormalNum(self.mine.position))
            -- self.maxOutput:setVisible(true)
            -- self.maxOutput:setString(self.detailInfo:getNormalNum(self.mine.position)..'/'..self.detailInfo:getLimit(self.mine.position))
            self.robRuneLabel:setString(roundNumber(self.detailInfo:getNormalNum(self.mine.position)*base_config["warFogLootRatio"])..Localize.query("PVSecretPlaceSeizeMineInfo.1")..' '..roundNumber(self.detailInfo:getLuckyNum(self.mine.position)*base_config["warFogLootRatio"])..Localize.query("PVSecretPlaceSeizeMineInfo.2"))
        end
    end

    -- 更新武将头像
    local _mineType = self:getMineType()
    if _mineType == 1 then
        self:updateMonsterHeadIconInfo()
    else
        self:updateHeroHeadIconInfo()
        self.tarvelBottomLabel:setVisible(false)
    end
end

function PVSecretPlaceSeizeMineInfo:setItemImage(sprite, res, quality)
    sprite:removeAllChildren()
    game.setSpriteFrame(sprite, res)
    local bgSprite = cc.Sprite:create()
    sprite:addChild(bgSprite)
    if quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_kuang.png")
    elseif quality == 3 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 4 then 
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    elseif quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end


function PVSecretPlaceSeizeMineInfo:startLeftTime()

    local function updateTimer(dt)

        self.ltime = self.ltime - dt
        self.outputLtime = self.outputLtime - dt
            
        if self.ltime <= 0 then self.ltime = 0 end

        if self.outputLtime <= 0 then 
            self.outputLtime = 0 

            if self._scheduerSeizeMineLeftTime ~= nil then
                 timer.unscheduleGlobal(self._scheduerSeizeMineLeftTime)
                 self._scheduerSeizeMineLeftTime = nil
            end

            self.shouhuoBtn:setEnabled(true)
            SpriteGrayUtil:drawSpriteTextureColor(self.shouhuoBtn:getNormalImage())
            self.outputLefttime:setString(string.format("%02d:%02d:%02d",math.floor(self.outputLtime/3600), math.floor(self.outputLtime%3600/60), self.outputLtime%60))
            return
        end

        self.outputLefttime:setString(string.format("%02d:%02d:%02d",math.floor(self.outputLtime/3600), math.floor(self.outputLtime%3600/60), self.outputLtime%60))
        self.baohuTime:setString(string.format("%02d:%02d:%02d",math.floor(self.ltime/3600), math.floor(self.ltime%3600/60), self.ltime%60))

    end

    if self.outputLtime > 0 then
        self._scheduerSeizeMineLeftTime = timer.scheduleGlobal(updateTimer, 1.0)
    end
end

-- 英雄头像
function PVSecretPlaceSeizeMineInfo:updateHeroHeadIconInfo()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    local _lineUP = getDataManager():getMineData():getLineUp()
    print("--------_lineUP----------")
    print("--------_lineUP---------- ", _lineUP)
    print("--------_lineUP---------- ", table.getn(_lineUP))
    -- table.print(_lineUP.slot)
    --local _heroPower = self.c_Calculation:
    self.fightNum:setString("0")


    self.wushuangName:setVisible(false)
    self.wushuangDes:setVisible(false)
    self.wushuangIcon:setVisible(false)

    if table.nums(_lineUP.unpars)>0 then
        local _unpar = _lineUP.unpars[1]

        if _unpar.unpar_id > 0 then
            local wsTempItem = self.stageTemp:getWSInfoById(_unpar.unpar_id)
            local _name = self.languageTemp:getLanguageById(wsTempItem.name)
            local _info = self.languageTemp:getLanguageById(wsTempItem.discription)
            local _img = self.resourceTemp:getResourceById(wsTempItem.icon)
            self.wushuangName:setString(_name)
            self.wushuangDes:setString(_info)

            local ws = game.newSprite("res/icon/ws/".._img)
            local size = self.wushuangIcon:getContentSize()
            ws:setPosition(size.width/2, size.height/2)
            ws:setTag(50)
            self.wushuangIcon:removeChildByTag(50)
            self.wushuangIcon:addChild(ws)

            self.wushuangName:setVisible(true)
            self.wushuangDes:setVisible(true)
            self.wushuangIcon:setVisible(true)
        end
        
    end
    
    local hero_nos = self.c_MineData:getMineGuardHeroNos()
    for k,v in pairs(_lineUP.slot) do

        if v.hero.hero_no ~= 0 then
            local _temp = self.soldierTemp:getSoldierIcon(v.hero.hero_no)
            local quality = self.soldierTemp:getHeroQuality(v.hero.hero_no)
            -- print(_temp)
            if v.slot_no == 1 then
                changeNewIconImage(self.heroSpriteA, _temp, quality)
                self.heroSpriteA:setScale(0.8)
            elseif v.slot_no == 2 then
                changeNewIconImage(self.heroSpriteB, _temp, quality)
                self.heroSpriteB:setScale(0.8)
            elseif v.slot_no == 3 then
                changeNewIconImage(self.heroSpriteC, _temp, quality)
                self.heroSpriteC:setScale(0.8)
            elseif v.slot_no == 4 then
                changeNewIconImage(self.heroSpriteD, _temp, quality)
                self.heroSpriteD:setScale(0.8)
            elseif v.slot_no == 5 then
                changeNewIconImage(self.heroSpriteE, _temp, quality)
                self.heroSpriteE:setScale(0.8)
            elseif v.slot_no == 6 then
                changeNewIconImage(self.heroSpriteF, _temp, quality)
                self.heroSpriteF:setScale(0.8)
            end
        end
    end
    -- 玩家战力
    self.c_Calculation:setLineUpData(_lineUP)
    local _power = self.c_Calculation:CombatPowerAllSoldierLineUp()
    self.c_Calculation:resetLineUpData()
    self.fightNum:setString(tostring(roundAttriNum(_power)))
end

-- 黄巾军
function PVSecretPlaceSeizeMineInfo:updateMonsterHeadIconInfo()
    
    self.changeLineupLabel:setVisible(false)

    self.wushuangName:setVisible(false)
    self.wushuangDes:setVisible(false)
    self.wushuangIcon:setVisible(false)

    local _stage_id = getDataManager():getMineData():getStageID()
    local _monsterGroup = getTemplateManager():getInstanceTemplate():getMonsterGroupByStageID(_stage_id)
    print("------_monsterGroup-------")
    table.print(_monsterGroup)

    local _monsterGroupPower = 0
    if _monsterGroup.pos1 > 0 then
        local _monsterIcon, quality = getTemplateManager():getSoldierTemplate():getMonsterIcon(_monsterGroup.pos1)
        local _monsterItem = getTemplateManager():getSoldierTemplate():getMonsterTempLateById(_monsterGroup.pos1)
        changeMonsterIconImage(self.heroSpriteA, _monsterIcon, quality)
        _monsterGroupPower = self.c_Calculation:CombatPowerMonster(_monsterItem)
        self.heroSpriteA:setScale(0.8)
    end
    if _monsterGroup.pos2 > 0 then
        local _monsterIcon, quality = getTemplateManager():getSoldierTemplate():getMonsterIcon(_monsterGroup.pos2)
        local _monsterItem = getTemplateManager():getSoldierTemplate():getMonsterTempLateById(_monsterGroup.pos2)
        changeMonsterIconImage(self.heroSpriteB, _monsterIcon, quality)
        _monsterGroupPower = _monsterGroupPower + self.c_Calculation:CombatPowerMonster(_monsterItem)
        self.heroSpriteB:setScale(0.8)
    end
    if _monsterGroup.pos3 > 0 then
        local _monsterIcon, quality = getTemplateManager():getSoldierTemplate():getMonsterIcon(_monsterGroup.pos3)
        local _monsterItem = getTemplateManager():getSoldierTemplate():getMonsterTempLateById(_monsterGroup.pos3)
        changeMonsterIconImage(self.heroSpriteC, _monsterIcon, quality)
        _monsterGroupPower = _monsterGroupPower + self.c_Calculation:CombatPowerMonster(_monsterItem)
        self.heroSpriteC:setScale(0.8)
    end
    if _monsterGroup.pos4 > 0 then
        local _monsterIcon, quality = getTemplateManager():getSoldierTemplate():getMonsterIcon(_monsterGroup.pos4)
        local _monsterItem = getTemplateManager():getSoldierTemplate():getMonsterTempLateById(_monsterGroup.pos4)
        changeMonsterIconImage(self.heroSpriteD, _monsterIcon, quality)
        _monsterGroupPower = _monsterGroupPower + self.c_Calculation:CombatPowerMonster(_monsterItem)
        self.heroSpriteD:setScale(0.8)
    end
     if _monsterGroup.pos5 > 0 then
        local _monsterIcon, quality = getTemplateManager():getSoldierTemplate():getMonsterIcon(_monsterGroup.pos5)
        local _monsterItem = getTemplateManager():getSoldierTemplate():getMonsterTempLateById(_monsterGroup.pos5)
        changeMonsterIconImage(self.heroSpriteE, _monsterIcon, quality)
        _monsterGroupPower = _monsterGroupPower + self.c_Calculation:CombatPowerMonster(_monsterItem)
        self.heroSpriteE:setScale(0.8)
    end
    if _monsterGroup.pos6 > 0 then
        local _monsterIcon, quality = getTemplateManager():getSoldierTemplate():getMonsterIcon(_monsterGroup.pos6)
        local _monsterItem = getTemplateManager():getSoldierTemplate():getMonsterTempLateById(_monsterGroup.pos6)
        changeMonsterIconImage(self.heroSpriteF, _monsterIcon, quality)
        _monsterGroupPower = _monsterGroupPower + self.c_Calculation:CombatPowerMonster(_monsterItem)
        self.heroSpriteF:setScale(0.8)
    end

    self.fightNum:setString(tostring(roundAttriNum(_monsterGroupPower)))
end

-- 初始化矿点信息
function PVSecretPlaceSeizeMineInfo:initData()

    self.mine = getDataManager():getMineData():getCurrentMine()

    self.mineNet = getDataManager():getSecretPlaceNet()
end


function PVSecretPlaceSeizeMineInfo:initRegisterNetCallBack()
    function onReciveMsgCallBack(_id)
        if _id == MINE_BATTLE then -- 攻占
           if not self:handelCommonResResult() then

                return
            end


            
        end
    end

    function onReceiveHarvestCallBack() -- 收获符文石
        local _drawStones = self.detailInfo:getDrawStones()
        print("-----收获符文石---PVSecretPlaceSeizeMineInfo==========")
        print("_drawStones",_drawStones)
        table.print(_drawStones)
        print("--------------------------")
        table.print(_drawStones.runt)
        if _drawStones == nil or table.nums(_drawStones.runt)<=0 then
            -- self:toastShow(Localize.query("PVSecretPlaceMyMineInfo.6"))
            getOtherModule():showAlertDialog(nil, Localize.query("PVSecretPlaceMyMineInfo.6"))
            return
        end

        for k,v in pairs(_drawStones.runt) do
            -- local runeType = self.c_StoneTemplate:getStoneItemById(v.runt_id).type
            -- self.runeData:updateNumById(runeType, v)
            self.runeData:updateNumById(1, v)
        end
        
        SpriteGrayUtil:drawSpriteTextureColor(self.shouhuoBtn:getNormalImage())
        self.shouhuoBtn:setEnabled(false)

        -- getOtherModule():showOtherView("PVCongratulationsGainDialog", 1, _drawStones.runt)
        getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", _drawStones.runt,1)
        self.maxOutput:setString('0'..'/200')

        -- 获取地图信息，并刷新地图
        getNetManager():getSecretPlaceNet():getMineBaseInfo()
    end


    self:registerMsg(MINE_HARVEST, onReceiveHarvestCallBack)

    self:registerMsg(MINE_BATTLE, onReciveMsgCallBack)
end

function PVSecretPlaceSeizeMineInfo:alertBaseTips(index)
    local _nomals = self.detailInfo:getNormals()

    local runeType = self.c_StoneTemplate:getStoneItemById(_nomals[index].stone_id).type

    local runeItem = {}
    runeItem.runt_id = _nomals[index].stone_id
    runeItem.inRuneType = runeType
    runeItem.runePos = 0

    getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)

    -- getOtherModule():showOtherView("PVTravelPropItem", 2, _nomals[index].stone_id)
end

function PVSecretPlaceSeizeMineInfo:alertLuckyTips(index)
    local _luckys = self.detailInfo:getLuckys()

    local runeType = self.c_StoneTemplate:getStoneItemById(_luckys[index].stone_id).type

    local runeItem = {}
    runeItem.runt_id = _luckys[index].stone_id
    runeItem.inRuneType = runeType
    runeItem.runePos = 0

    getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
    
    -- local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.stone_id)

    -- setItemImage(self.baseRuneSprite[index], _respng, _quality)

    -- getOtherModule():showOtherView("PVTravelPropItem", 2, _luckys[index].stone_id)
end

function PVSecretPlaceSeizeMineInfo:exchangeLineup(seat)
    self.c_MineData:setMineGuardRequestLineupFromGuardLineup()
    local _nickname = self.mine.nickname 
    local _mineType = self:getMineType()
    if _mineType == 3 then --玩家自己
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLineUp", 3, _mineType)
    else
        local _seatState = self.c_MineData:getIsSeated(seat)
        if _seatState then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaCheckInfo", _nickname, 1)  -- 其他玩家信息
        end
    end
end

function PVSecretPlaceSeizeMineInfo:initTouchListener()
    
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        local stype = self.mine.type
        local nickname = self.mine.nickname 
        if stype == 2 or nickname ~= getDataManager():getCommonData():getUserName() then
            local  sure = function()
                self:onHideView()
            end

            local cancel = function()
            end
            getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVSecretPlaceSeizeMineInfo.4"))
        else
            self:onHideView()
        end
    end

    local function zengchanOnClick()
        cclog("zengchanOnClick")
        getAudioManager():playEffectButton2()
    end

    -- 查看自家矿点 收获按钮触发事件
    local function getOnClick()
        cclog("getOnClick")
        getAudioManager():playEffectButton2()
         data = {}
        data.position = self.mine.position

        getNetManager():getSecretPlaceNet():harvestStones(data)
        -- 
    end

    local function jichuOne()
        cclog("jichuOne")
        getAudioManager():playEffectButton2()
       local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 1 then
            return
        end

        self:alertBaseTips(1)
      
    end
    local function jichuTwo()
        cclog("jichuTwo")
        getAudioManager():playEffectButton2()
         local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 2 then
            return
        end

        self:alertBaseTips(2)
    end
    local function jichuThree()
        cclog("jichuThree")
        getAudioManager():playEffectButton2()
        local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 3 then
            return
        end

        self:alertBaseTips(3)
    end
    local function jichuFour()
        cclog("jichuThree")
        getAudioManager():playEffectButton2()
        local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 4 then
            return
        end

        self:alertBaseTips(4)
    end
    
    local function luckyOne()
        cclog("luckyOne")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 1 then
            return
        end

        self:alertLuckyTips(1)

    end
    local function luckyTwo()
        cclog("luckyTwo")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 2 then
            return
        end

        self:alertLuckyTips(2)
    end
    local function luckyThree()
        cclog("luckyThree")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 3 then
            return
        end

        self:alertLuckyTips(3)
    end
    local function luckyFour()
        cclog("luckyFour")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 4 then
            return
        end

        self:alertLuckyTips(4)
    end

    -- 查看其他玩家时的攻占按钮触发事件
    local function gongzhanOnClickA()
        cclog("gongzhanOnClickA")
        getAudioManager():playEffectButton2()
        self.detailInfo:clearMineGuardRequest()

        local _stage_id = getDataManager():getMineData():getStageID()

        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", _stage_id, "mine_otheruser")

    end

    -- 查看野怪时的攻占按钮触发事件
    local function gongzhanOnClickB()
        cclog("gongzhanOnClickB")
        getAudioManager():playEffectButton2()
        -- 判断是否有玩家在攻占 野怪和攻占其他玩家都需要这么判断？？
        local _stage_id = getDataManager():getMineData():getStageID()
        self.detailInfo:clearMineGuardRequest()

        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", _stage_id, "mine_monster")


        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLineUp", 1)
    end

    local function heroIconClickA()
        cclog("heroIconClickA")
        if self:getMineType() == 1 then
            return
        end
        getAudioManager():playEffectButton2()

        self:exchangeLineup(1)
    end

    local function heroIconClickB()
        cclog("heroIconClickB")
        if self:getMineType() == 1 then
            return
        end
        getAudioManager():playEffectButton2()
        self:exchangeLineup(2)
    end

    local function heroIconClickC()
        cclog("heroIconClickC")
        if self:getMineType() == 1 then
            return
        end
        getAudioManager():playEffectButton2()
        self:exchangeLineup(3)
    end

    local function heroIconClickD()
        cclog("heroIconClickD")
        if self:getMineType() == 1 then
            return
        end
        getAudioManager():playEffectButton2()
        self:exchangeLineup(4)
    end

    local function heroIconClickE()
        cclog("heroIconClickE")
        if self:getMineType() == 1 then
            return
        end
        getAudioManager():playEffectButton2()
        self:exchangeLineup(5)
    end

    local function heroIconClickF()
        cclog("heroIconClickF")
        if self:getMineType() == 1 then
            return
        end
        getAudioManager():playEffectButton2()
        self:exchangeLineup(6)
    end

    self.UISecretMySeizeMine["UISecretMySeizeMine"] = {}

    self.UISecretMySeizeMine["UISecretMySeizeMine"]["zengchanOnClick"] = zengchanOnClick
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["getOnClick"] = getOnClick
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["onCloseClick"] = onCloseClick

    self.UISecretMySeizeMine["UISecretMySeizeMine"]["jichuOne"] = jichuOne
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["jichuTwo"] = jichuTwo
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["jichuThree"] = jichuThree
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["jichuFour"] = jichuFour

    self.UISecretMySeizeMine["UISecretMySeizeMine"]["luckyOne"] = luckyOne
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["luckyTwo"] = luckyTwo
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["luckyThree"] = luckyThree
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["luckyFour"] = luckyFour

    self.UISecretMySeizeMine["UISecretMySeizeMine"]["gongzhanOnClickA"] = gongzhanOnClickA
    self.UISecretMySeizeMine["UISecretMySeizeMine"]["gongzhanOnClickB"] = gongzhanOnClickB


     self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroIconClickA"] = heroIconClickA
     self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroIconClickB"] = heroIconClickB
     self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroIconClickC"] = heroIconClickC
     self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroIconClickD"] = heroIconClickD
     self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroIconClickE"] = heroIconClickE
     self.UISecretMySeizeMine["UISecretMySeizeMine"]["heroIconClickF"] = heroIconClickF
    
end
function PVSecretPlaceSeizeMineInfo:onReloadView()

    local _type = self:getMineType()

    if _type == 1 or _type == 2 then
        self:onHideView()
    else
        -- local data = {}
        -- data.position = getDataManager():getMineData():getMapPosition()

        -- print("------PVSecretPlaceSeizeMineInfo:onReloadView-------")
        -- table.print(data)
        -- getNetManager():getSecretPlaceNet():getDetailInfo(data)
        -- self:onHideView()
    end
end

-- 
function PVSecretPlaceSeizeMineInfo:updateView(params)
    cclog("--------------updateView------------")
    print(params[1])
    -- 判断如果是胜利回来的或者是失败回来的，，
    -- 如果是胜利的 进入阵容界面

    if params[1] == 8 or params[1] == 9 then
        self:onHideView()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLineUp", 1 , 3)
        -- getModule(MODULE_NAME_HOMEPAGE):showUINodeView("PVLineUp", 1)
        
    elseif params[1] == 10 then
        local data = {}
        data.position = getDataManager():getMineData():getMapPosition()
        getNetManager():getSecretPlaceNet():getDetailInfo(data)
        self:onHideView()
    elseif params[1] == nil then      
        getDataManager():getMineData():setOtherPlayersCanGet(false)
        getNetManager():getSecretPlaceNet():getMineBaseInfo()       --攻打其他玩家可收获的矿返回，发送协议从新刷新界面
        self:onHideView()
    end
    
end

return PVSecretPlaceSeizeMineInfo
