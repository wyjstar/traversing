--查看武将
local PVSoldierMyLookDetail = class("PVSoldierMyLookDetail",BaseUIView)
local PVDetail = import(".PVDetail")

function PVSoldierMyLookDetail:ctor(id)
    PVSoldierMyLookDetail.super.ctor(self, id)
end

function PVSoldierMyLookDetail:onMVCEnter()


    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    self.isMusic = false

    self.UISoldierMyDetail = {}
    self.starTable = {}
    self.soldierId = nil --英雄id
    self.c_ChipTemplate = getTemplateManager():getChipTemplate()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.c_lineUpData = getDataManager():getLineupData()

    self:initTouchListener()

    self:loadCCBI("soldier/ui_soldier_attribute.ccbi", self.UISoldierMyDetail)

    self:initView()
    self:initData()
    self:createScrollView()
    self:createBasicAttribute()
    --self:createTableView()

    self:updateData()

    --武将觉醒相关
    self.TYPE_MOVE_NONE = 0
    self.TYPE_MOVE_LEFT = 1
    self.TYPE_MOVE_RIGHT = 2
end

function PVSoldierMyLookDetail:onExit()

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    -- getDataManager():getResourceData():clearResourcePlistTexture()
end

function PVSoldierMyLookDetail:stopMusicHero()
    if self.isMusic then
        print("关闭音效")
        -- cc.SimpleAudioEngine:getInstance():stopMusic(true)
        -- cc.SimpleAudioEngine:getInstance():stopEffect(self.musicEffect)
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        self.isMusic = false
    else
    end
end

function PVSoldierMyLookDetail:initData()
    local soldierId = nil
    self.data = {}  -- {tag, title, content} : tag: 1 技能 2 羁绊 3 突破 4 简介
    self.selectIndex = self:getTransferData()[1]
    g_lastSelectType = self.funcTable[3]     --阵容使用
    g_fromType = self.funcTable[4]           --阵容使用 -- 自己的符文秘境过来
    ----------
    if self.selectIndex > 0 then
        local res = self.c_SoldierTemplate:getHeroAudio(self.selectIndex)
        if res == 0 then
            print("没有音效")
            self.effectOnBtn:setVisible(false)
            self.labadiSp:setVisible(false)
        else
            print("播放音效")
            self.effectOnBtn:setVisible(true)
            self.labadiSp:setVisible(true)
            self.isMusic = true
            self.musicEffect = res
            getAudioManager():playHeroEffect(res)
        end

        print("删除武将新列表"..self.selectIndex)
        self.c_SoldierData:removeSoldierIsNewList(self.selectIndex)
    end
    ----------

    print("self.selectIndex ----------------- ", self.selectIndex)
    self.curType = self:getTransferData()[2]
    self.curLevel = self:getTransferData()[3]
    self.isInstance = self:getTransferData()[4]
    if self.curType == nil or self.curType == 1 or self.curType == 0 then
        soldierId = self.selectIndex

        local curQuality = self.c_SoldierTemplate:getHeroQuality(soldierId)                             --觉醒相关
        if curQuality == 5 or curQuality == 6 then
            self.curSoldierId = soldierId
            --获取当前的武将的战斗力
            local soldierDataItem = self.c_SoldierData:getSoldierDataById(soldierId)
            local curPower = self.c_Calculation:CombatPowerSoldierSelf(soldierDataItem)
            curPower = math.floor(curPower)
            self.curPowerNum:setString(curPower)
            local needPower, ratio = self.c_SoldierTemplate:getChangeNeedPower(self.curSoldierId, curPower)         --变身所需要的战斗力(百分百变身)
            self.changeId = self.c_SoldierTemplate:getSoldierChangeInfo(self.curSoldierId)
            self.curId = self.curSoldierId
            --当前战队战斗力数值
            if self.changeId ~= nil then
                --获取当前武将的战斗力
                -- self:changePowerShow(curPower, needPower, ratio)
                self.powerDes:setString(ratio * 100 .. "%几率觉醒所需战力")
                if ratio == 1 then
                    self.powerNum:setColor(ui.COLOR_WHITE)
                else
                    self.powerNum:setColor(ui.COLOR_RED)
                end
                self.powerNum:setString(curPower)
                self.nextPowerNum:setString("/" .. needPower)
                self.expPrgress:setPercentage(ratio * 100)
                self.curId = self.curSoldierId
                self.soldierAddPowerLayer:setVisible(true)
                self:initHeroLayerTouch()
            else
                self.soldierAddPowerLayer:setVisible(false)
                self.btnSoldierAddPower:setVisible(true)
            end
        else
            self.btnSoldierAddPower:setVisible(true)
            self.soldierAddPowerLayer:setVisible(false)
        end
        self.buttonLayer:setVisible(true)
    end
    -- else

    soldierId = self.selectIndex
    self.soldierDataItem = self.c_SoldierData:getSoldierDataById(soldierId)
    local jobId = self.c_SoldierTemplate:getHeroTypeId(self.soldierDataItem.hero_no)
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
    -- print("------self.soldierDataItem--------")
    -- table.print(self.soldierDataItem)


    if self.curType ~= nil then
        if self.curType == 0 then         -- 传承
            self.inheritLayer:setVisible(true)
            self.buttonLayer:setVisible(false)
            self.btnSoldierLT:setVisible(false)
            self.btnSoldierFW:setVisible(false)
            self.btnSoldierAddPower:setVisible(false)  --提升战力
            self.btnSoldierAddPower2:setVisible(false)
        elseif self.curType == 1 then      --阵容进来
            self.buttonLayer:setVisible(false)
            self.btnSoldierChange:setVisible(false)
            self.btnSoldierDown:setVisible(false)
            self.btnSoldierLT:setVisible(false)
            self.btnSoldierFW:setVisible(false)
        end
    end





    self.c_SoldierData:loadHeroImage(soldierId)
    if self.changeId ~= nil then
        self.c_SoldierData:loadHeroImage(self.changeId)
    end

    --是否从关卡界面跳转
    if self.isInstance == nil then
        self.getButton:setVisible(false)
    else
        self.getButton:setVisible(true)
    end
    --skill
    self:initSkillData(soldierId)
    --更新羁绊
    self:initLinkData(soldierId)
    --更新技能突破
    self:initBreakData(soldierId)
    --更新简介
    self:initSummary(soldierId)

    self:initAction()
end

--动画
function PVSoldierMyLookDetail:initAction()

    -- print("!~~~~~~~~~~")

    -- local kInAngleZ = 270
    -- local kInDeltaZ = 90

    -- local kOutAngleZ = 0
    -- local kOutDeltaZ = 90

    -- self.m_openAnimIn = cc.Sequence:create(cc.DelayTime:create(0.5),  cc.OrbitCamera:create(0.5, 1, 0, kInAngleZ, kInDeltaZ, 0, 0), cc.Show:create())
    ----
    -- self.m_openAnimIn = cc.Sequence:create(cc.OrbitCamera:create(1, 1, 0, 270, 90, 0, 0))
    -- self.m_openAnimIn:retain()

    -- self.m_openAnimOut = cc.Sequence:create( cc.OrbitCamera:create(1, 1, 0, 0, 90, 0, 0))
    ----
    -- self.m_openAnimOut = cc.Sequence:create(cc.OrbitCamera:create(0.5, 1, 0, kOutAngleZ, kOutDeltaZ, 0, 0), cc.Hide:create(),cc.DelayTime:create(0.5))
    -- self.m_openAnimOut = cc.Sequence:create(cc.DelayTime:create(0.5),  cc.Hide:create(), cc.OrbitCamera:create(0.5, 1, 0, kOutAngleZ, kOutDeltaZ, 0, 0))

    -- local fadeInAction = cc.FadeIn:create(1)
    -- local fadeOutAction = cc.FadeOut:create(1)
    -- self.m_openAnimIn = cc.Sequence:create(fadeOutAction, fadeInAction)
    -- self.m_openAnimIn:retain()
    -- self.m_openAnimOut = cc.Sequence:create(fadeInAction, fadeOutAction)

    -- self.m_openAnimOut:retain()
end

function PVSoldierMyLookDetail:initSkillData(soldierId)

    local function setSkillAttri(str)
        local _describeLanguage = str
        for findStr in string.gmatch(str, "%$%d+:%w+%$") do  -- 模式匹配“$id:字段$”
            cclog("-------PVSoldierMyLookDetail:initSkillData----"..findStr)
            local repStr = nil
            for _var in string.gmatch(findStr, "%d+:%w+") do
                cclog("-------PVSoldierMyLookDetail:initSkillData----".._var)
                local _pos, _end = string.find(_var, ":")
                local buffId = string.sub(_var, 1, _pos-1)
                local key = string.sub(_var, _end+1)
                print("^^^^^^^^^^^", buffId)
                local buffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(tonumber(buffId))
                -- table.print(buffItem)
                local value = buffItem[key]
                repStr = value
                cclog("-------PVSoldierMyLookDetail:initSkillData----"..repStr)
            end
            _describeLanguage = string.gsub(_describeLanguage, "%$%d+:%w+%$", repStr, 1)
        end
        return _describeLanguage
    end

    local soliderItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local normalSkill = soliderItem.normalSkill --普通技能
    local rageSkill = soliderItem.rageSkill  --怒气技能

    --普通技能
    local normalSkillItem = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local normalName = normalSkillItem.name
    local normalDescribe = normalSkillItem.describe
    local nameLanguage = self.c_LanguageTemplate:getLanguageById(normalName)
    local describeLanguage = self.c_LanguageTemplate:getLanguageById(normalDescribe)
    describeLanguage = setSkillAttri(describeLanguage)

    self:createOneDataItem(1, nameLanguage, describeLanguage)

    --怒气技能
    local rageSkillItem = self.c_SoldierTemplate:getSkillTempLateById(rageSkill)
    local rageName = rageSkillItem.name
    local rageDescribe = rageSkillItem.describe
    nameLanguage = self.c_LanguageTemplate:getLanguageById(rageName)
    describeLanguage = self.c_LanguageTemplate:getLanguageById(rageDescribe)
    describeLanguage = setSkillAttri(describeLanguage)

    self:createOneDataItem(1, nameLanguage, describeLanguage)
end

function PVSoldierMyLookDetail:initLinkData(soldierId)

    local function getBuffInfo(buff)
        local strEffect = ""
        for i,v in ipairs(buff) do
            local buffInfo = self.c_SoldierTemplate:getSkillBuffTempLateById(buff[i])
            local buffEffectId = buffInfo.effectId
            local buffType = buffInfo.valueType
            local buffValue = buffInfo.valueEffect
            local strValue = nil
            if buffType == 1 then strValue = tostring(buffValue)
            elseif buffType == 2 then strValue = tostring(buffValue) .. "%"
            end
            strEffect = strEffect .. self.c_SoldierTemplate:getSkillBuffEffectName(buffEffectId) .. strValue
        end
        return strEffect
    end

    local linkItem = self.c_SoldierTemplate:getLinkTempLateById(soldierId)
    for i=1, 5 do
        if self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, i) then
            local strName = "linkname"..tostring(i)
            local strText = "linktext"..tostring(i)
            local strSkill = "link"..tostring(i)
            local name = linkItem[strName]
            local text = linkItem[strText]
            local skillId = linkItem[strSkill]
            local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
            local textLanguage = self.c_LanguageTemplate:getLanguageById(text)
            local skillInfo = self.c_SoldierTemplate:getSkillTempLateById(skillId)
            local buff = skillInfo.group
            textLanguage = string.gsub(textLanguage, "s%%", "")
            textLanguage = textLanguage .. getBuffInfo(buff)

            self:createOneDataItem(2, nameLanguage, textLanguage)
        end
    end
end

function PVSoldierMyLookDetail:initBreakData(soldierId)

    local breakItem = self.c_SoldierTemplate:getBreakupTempLateById(soldierId)
    for i=1, 7 do
        local strBreak = "break"..tostring(i)
        local breakId = breakItem[strBreak]
        if breakId ~= 0 then
            local skillItem = self.c_SoldierTemplate:getSkillTempLateById(breakId) --突破技能item
            local name = skillItem.name
            local describe = skillItem.describe

            local nameLanguage = i  -- 突破无名
            local describeLanguage = self.c_LanguageTemplate:getLanguageById(describe)

            self:createOneDataItem(3, nameLanguage, describeLanguage)
        end
    end
end

function PVSoldierMyLookDetail:initSummary(soldierId)

    local heroItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local describeId = heroItem.describeStr ---- 简介无名
    local describeLanguage = self.c_LanguageTemplate:getLanguageById(describeId)
    self:createOneDataItem(4, "", describeLanguage)
end

function PVSoldierMyLookDetail:initTouchListener()
    local function onBackClick()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        --self:onHideView(1)
        self:onHideView()
    end
    local function effectOnClick()
        self:stopMusicHero()
        ----------
        if self.selectIndex > 0 then
            local res = self.c_SoldierTemplate:getHeroAudio(self.selectIndex)
            if res == 0 then
                print("没有音效")
            else
                print("播放音效")
                self.isMusic = true
                self.musicEffect = res
                getAudioManager():playHeroEffect(res)
            end
        end
        ----------

    end
    local function changeViewMenuClick()
        self:stopMusicHero()
        cclog("changeViewMenuClick")
    end
    local function soldierChangeMenuClick()
        -- self:stopMusicHero()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierBreakDetail", self.selectIndex)
    end
    local function skillUpgradeMenuClick()
        -- self:stopMusicHero()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierUpgradeDetail", self.selectIndex)
    end
    local function headMenuClick()
    end
    local function onBreakClick()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        g_selectIndex = self.selectIndex
        -- self:onHideView()
        self.heroLayer:setTouchEnabled(false)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierBreakDetail", g_selectIndex)
    end
    local function onUpgradeClick()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        g_selectIndex = self.selectIndex
        -- self:onHideView()
        self.heroLayer:setTouchEnabled(false)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierUpgradeDetail", g_selectIndex)
    end
    local function onGetSoldierClick()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        -- print(self.selectIndex .. "获取途径")
        -- local soldierDataItem = self.c_SoldierData:getSoldierDataById(self.selectIndex)
        -- local soldierId = soldierDataItem.hero_no
        -- local soldierToGetId = self.c_SoldierTemplate:getHeroTempLateById(soldierId).toGet
        -- local _data =  self.c_ChipTemplate:getDropListById(soldierToGetId)
        -- table.print(_data)
        -- -- if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
        -- --     and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
        -- --     and _data.arenaShop == 0 and _data.stageBreak == 0  then
        -- if _data and type(_data) == "table" and table.nums(_data) == 0 then
        --     local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
        --     getOtherModule():showToastView(tipText)
        -- else
        --     getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVChipGetDetail", _data)
        --     --getOtherModule():showOtherView("PVChipGetDetail", _data)
        --     --getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVChipGetDetail", _data)

        local soldierId = self.selectIndex --soldierDataItem.hero_no
        local soldierToGetId = self.c_SoldierTemplate:getHeroTempLateById(soldierId).toGet
        local _data =  self.c_ChipTemplate:getDropListById(soldierToGetId)
        if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
            and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
            and _data.arenaShop == 0 and _data.stageBreak == 0  then
        -- if _data and type(_data) == "table" and table.nums(_data) == 0 then
            local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
            -- getOtherModule():showToastView(tipText)
            getOtherModule():showAlertDialog(nil, tipText)

        else

            getOtherModule():showOtherView("PVChipGetDetail", _data , soldierId, 1)
        end
    end

    --武将觉醒相关 (提升战力)
    local function onbtnSoldierAddPower()
        self:stopMusicHero()
        self.blackCL:setVisible(true)
        local curSoldierIndex = self.selectIndex
        getOtherModule():showOtherView("PVPromoteForce", curSoldierIndex)

    end
    --符文
    local function onbtnSoldierFW()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        g_selectIndex = self.selectIndex
        self.c_runeNet = getNetManager():getRuneNet()
        self.c_runeNet:sendBagRunes()

        --当前武将符文相关信息的初始化
        print(" -------------------- ", self.selectIndex)
        table.print(self.soldierDataItem)
        self.c_runeData = getDataManager():getRuneData()
        self.c_runeData:setCurSoliderId(self.selectIndex)
        --self.c_runeData:setSoldierRunse(heroPb.runt_type)

        self:onHideView()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRunePanel")
        g_selectIndex = nil
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRunePanel",g_selectIndex)
        --getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVRunePanel", g_selectIndex)
    end
    --炼体
    local function onbtnSoldierLT()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        g_selectIndex = self.selectIndex
        self:onHideView()
        getModule(MODULE_NAME_LINEUP):showUIView("PVSoldierChain",g_selectIndex)
        g_selectIndex = nil
        --getModule(MODULE_NAME_LINEUP):showUIViewAndInTop("PVSoldierChain", g_selectIndex)

    end

    ----------------  传承 ---------------
    --更换武将
    local function ltMenuChange()
        self:stopMusicHero()

        local _inherit = self.funcTable[3]
        -- if _inherit == nil then
        --     _inherit = 0
        -- end

        if _inherit == 0 then
            local lt = {}
            getDataManager():getInheritData():setlt2(lt)
            self:onHideView()
            -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritltList", 0)
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritLTList", 0)
        else
            _inherit = self.funcTable[3]
            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritLTList", _inherit)
            _inherit = nil
        end
    end

    --上阵武将更换
    local function onbtnSoldierChange()
        self:stopMusicHero()
        -- g_lastSelectType = self.funcTable[3]     --阵容使用
        -- g_fromType = self.funcTable[4]           --阵容使用
        self.btnSoldierChange:setEnabled(false)
        self:onHideView(-1)
        getModule(MODULE_NAME_LINEUP):showUIViewAndInTop("PVSelectSoldier", g_lastSelectType, g_fromType)
        g_lastSelectType = nil
        g_fromType = nil
    end

    --武将下阵
    local function onbtnSoldierDown()
        self:stopMusicHero()
        if g_fromType == FROM_TYPE_MINE or g_fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
            self:onHideView(0)
            g_fromType = nil
        else
            local _onLineUpList = self.c_lineUpData:getOnLineUpList()
            if g_lastSelectType == 1 then
                if table.nums(_onLineUpList) > 1 then
                    self:onHideView(0)
                    g_lastSelectType = nil
                else
                    getOtherModule():showAlertDialog(nil, Localize.query("lineup.8"))
                end
            else
                self:onHideView(0)
                g_lastSelectType = nil
            end
        end
    end
    --------------------------------------


    --切换武将形象
    local function onChangeClick()
        if self.curId == self.curSoldierId then
            self.curSoldierId = self.changeId
            self.changeId = self.curId
        elseif self.curId == self.changeId then
            self.changeId = self.curSoldierId
            self.curSoldierId = self.curId
        end
        self:changeHeroImage(self.curSoldierId, self.changeId)
        print("切换武将形象 ============ ")
    end

    self.UISoldierMyDetail["UISoldierMyDetail"] = {}
    self.UISoldierMyDetail["UISoldierMyDetail"]["onBackClick"] = onBackClick
    self.UISoldierMyDetail["UISoldierMyDetail"]["changeViewMenuClick"] = changeViewMenuClick
    self.UISoldierMyDetail["UISoldierMyDetail"]["soldierChangeMenuClick"] = soldierChangeMenuClick
    self.UISoldierMyDetail["UISoldierMyDetail"]["skillUpgradeMenuClick"] = skillUpgradeMenuClick

    self.UISoldierMyDetail["UISoldierMyDetail"]["ltMenuChange"] = ltMenuChange

    self.UISoldierMyDetail["UISoldierMyDetail"]["headMenuClick"] = headMenuClick
    self.UISoldierMyDetail["UISoldierMyDetail"]["onBreakClick"] = onBreakClick
    self.UISoldierMyDetail["UISoldierMyDetail"]["onUpgradeClick"] = onUpgradeClick
    self.UISoldierMyDetail["UISoldierMyDetail"]["onGetSoldierClick"] = onGetSoldierClick

    --武将觉醒相关 (提升战力)
    self.UISoldierMyDetail["UISoldierMyDetail"]["onbtnSoldierAddPower"] = onbtnSoldierAddPower
    self.UISoldierMyDetail["UISoldierMyDetail"]["onbtnSoldierFW"] = onbtnSoldierFW
    self.UISoldierMyDetail["UISoldierMyDetail"]["onbtnSoldierLT"] = onbtnSoldierLT
    self.UISoldierMyDetail["UISoldierMyDetail"]["onChangeClick"] = onChangeClick

    self.UISoldierMyDetail["UISoldierMyDetail"]["effectOnClick"] = effectOnClick

    --阵容 武将更换上阵及下镇阵
    self.UISoldierMyDetail["UISoldierMyDetail"]["onbtnSoldierChange"] = onbtnSoldierChange
    self.UISoldierMyDetail["UISoldierMyDetail"]["onbtnSoldierDown"] = onbtnSoldierDown

end

function PVSoldierMyLookDetail:initView()
    self.animationManager = self.UISoldierMyDetail["UISoldierMyDetail"]["mAnimationManager"]
    self.heroNameLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["heroNameLabel"]
    self.heroLevelLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["heroLevelLabel"]

    self.attributeLabelA = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelA"]
    self.attributeLabelB = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelB"]
    self.attributeLabelC = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelC"]
    self.attributeLabelD = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelD"]
    self.attributeLabelE = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelE"]
    self.attributeLabelF = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelF"]
    self.attributeLabelG = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelG"]
    self.attributeLabelH = self.UISoldierMyDetail["UISoldierMyDetail"]["attributeLabelH"]

    self.heroName = self.UISoldierMyDetail["UISoldierMyDetail"]["label_heroname"]
    self.heroBreakNumImg = self.UISoldierMyDetail["UISoldierMyDetail"]["img_rightNum"]

    -- self.heroCardImg = self.UISoldierMyDetail["UISoldierMyDetail"]["heroImageSprite"]
    self.skillListLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["skillListLayer"]
    self.otherSkillListLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["otherSkillListLayer"]

    self.playerSprite = self.UISoldierMyDetail["UISoldierMyDetail"]["playerSprite"]     --英雄image
    self.typeSprite = self.UISoldierMyDetail["UISoldierMyDetail"]["typeSprite"]         --类型图片
    -- self.heroTypeBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["heroTypeBMLabel"]

    self.playerChangeSprite = self.UISoldierMyDetail["UISoldierMyDetail"]["playerChangeSprite"]

    self.powerBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["powerBMLabel"]     --攻击力
    self.physicalDefenseLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["physicalDefenseLabel"]
    self.hpBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["hpBMLabel"]
    self.magicDefenseLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["magicDefenseLabel"]

    self.levelBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["levelBMLabel"]
    -- self.lvBMLabel = self.UISoldierMyDetail["UISoldierMyDetail"]["lvBMLabel2"]
-- 
    self.contentLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["contentLayer"]

    self.effectOnBtn = self.UISoldierMyDetail["UISoldierMyDetail"]["effectOnBtn"]
    self.btnSoldierAddPower2 = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierAddPower"]
    self.btnSoldierAddPower = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierAddPower1"]
    self.btnSoldierLT = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierLT"]
    self.btnSoldierFW = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierFW"]


    --阵容 武将更换上阵及下镇阵
    self.btnSoldierChange = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierChange"]
    self.btnSoldierDown = self.UISoldierMyDetail["UISoldierMyDetail"]["btnSoldierDown"]

    local starSelect1 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect1"]
    local starSelect2 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect2"]
    local starSelect3 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect3"]
    local starSelect4 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect4"]
    local starSelect5 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect5"]
    local starSelect6 = self.UISoldierMyDetail["UISoldierMyDetail"]["starSelect6"]

    self.buttonLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["buttonLayer"]

    self.inheritLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["inheritLayer"]

    self.getButton = self.UISoldierMyDetail["UISoldierMyDetail"]["getButton"]
    self.blackCL = self.UISoldierMyDetail["UISoldierMyDetail"]["blackCL"]

    --武将觉醒相关
    self.soldierAddPowerLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["soldierAddPowerLayer"]
    self.heroLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["heroLayer"]
    self.animationNode = self.UISoldierMyDetail["UISoldierMyDetail"]["animationNode"]
    --未觉醒武将
    self.curSoldierLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["curSoldierLayer"]
    self.curPowerNum = self.UISoldierMyDetail["UISoldierMyDetail"]["curPowerNum"]
    --觉醒武将相关
    self.awakeSoldierLayer = self.UISoldierMyDetail["UISoldierMyDetail"]["awakeSoldierLayer"]
    self.powerDes = self.UISoldierMyDetail["UISoldierMyDetail"]["powerDes"]
    self.powerNum = self.UISoldierMyDetail["UISoldierMyDetail"]["powerNum"]
    self.nextPowerNum = self.UISoldierMyDetail["UISoldierMyDetail"]["nextPowerNum"]

    self.expSprite = self.UISoldierMyDetail["UISoldierMyDetail"]["expSprite"]

    self.labadiSp = self.UISoldierMyDetail["UISoldierMyDetail"]["labadiSp"]

    table.insert(self.starTable, starSelect1)
    table.insert(self.starTable, starSelect2)
    table.insert(self.starTable, starSelect3)
    table.insert(self.starTable, starSelect4)
    table.insert(self.starTable, starSelect5)
    table.insert(self.starTable, starSelect6)

    local parent = self.expSprite:getParent()
    local posX, posY = self.expSprite:getPosition()
    self.expSprite:removeFromParent(false)
    self.expPrgress = cc.ProgressTimer:create(self.expSprite)
    self.expPrgress:setAnchorPoint(cc.p(0, 0.5))
    self.expPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.expPrgress:setBarChangeRate(cc.p(1, 0))
    self.expPrgress:setMidpoint(cc.p(0, 0))
    self.expPrgress:setPosition(posX, posY)
    self.expPrgress:setLocalZOrder(1)
    parent:addChild(self.expPrgress)

    self.curSoldierLayer:setVisible(true)
    self.awakeSoldierLayer:setVisible(false)
end

function PVSoldierMyLookDetail:createTableView()

    local function tableCellTouched(tbl, cell)
        print("tableView cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.data)
    end
    local function cellSizeForTable(tbl, idx)
        return self.itemSize.height, self.itemSize.width
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, cell.cardinfo)

            cell.tagImg = cell.cardinfo["UIAttriItem"]["tagSprite"]
            cell.title = cell.cardinfo["UIAttriItem"]["soldierName"]
            cell.detail = cell.cardinfo["UIAttriItem"]["detailLabel"]
            cell.pos = cell.cardinfo["UIAttriItem"]["pos_node"]
            cell.item = cell.cardinfo["UIAttriItem"]["itemNode"]

            cell:addChild(node)
        end

        -- 设置数据
        local itemData = self.data[idx+1]
        local tag = itemData.tag
        local title = itemData.title
        local content = itemData.content
        if tag == 1 then
            cell.title:setVisible(true)
            cell.item:removeChildByTag(10)
            cell.tagImg:setSpriteFrame("ui_soldier_jineng.png")
        elseif tag == 2 then
            cell.title:setVisible(true)
            cell.item:removeChildByTag(10)
            cell.tagImg:setSpriteFrame("ui_soldier_jiban.png")
        elseif tag == 3 then
            local rect = cc.rect(title*30, 0, 30, 46)
            local sprite = cc.Sprite:createWithTexture(self.texture, rect)
            local posx, posy = cell.pos:getPosition()
            sprite:setPosition(posx,posy)
            sprite:setTag(10)
            cell.item:removeChildByTag(10)
            cell.item:addChild(sprite)
            cell.tagImg:setSpriteFrame("ui_soldier_tupo.png")
            cell.title:setVisible(false)
        elseif tag == 4 then
            cell.title:setVisible(true)
            cell.item:removeChildByTag(10)
            cell.tagImg:setSpriteFrame("ui_soldier_jianjie.png")
        end
        cell.title:setString(title)
        cell.detail:setString(content)

        return cell
    end

    self.texture = cc.Director:getInstance():getTextureCache():addImage("res/ui/ui_tuponumber.png")

    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, tempTable)
    self.itemSize = tempTable["UIAttriItem"]["itemNode"]:getContentSize()
    self.layerSize = self.contentLayer:getContentSize()

    self.tableView = cc.TableView:create(self.layerSize)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.tableView)
    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end



--创建scrollview
function PVSoldierMyLookDetail:createScrollView()
    -- local function scrollView2DidScroll()
    --     print("scrollView2DidScroll")
    -- end
    self.scrollView = cc.ScrollView:create()
    local screenSize = self.contentLayer:getContentSize()
    if nil ~= self.scrollView then
        self.scrollView:setViewSize(cc.size(screenSize.width, screenSize.height))
        self.scrollView:ignoreAnchorPointForPosition(true)

        self.svContaner = cc.Layer:create()
        self.svContaner:setAnchorPoint(cc.p(0,0))
        self.scrollView:setContainer(self.svContaner)
        self.scrollView:updateInset()

        self.scrollView:setDirection(1)
        self.scrollView:setClippingToBounds(true)
        self.scrollView:setBounceable(true)
        self.scrollView:setDelegate()
    end

    self.contentLayer:addChild(self.scrollView)
    -- self.scrollView:registerScriptHandler(scrollView2DidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
end

--用scrollview实现列表的创建
function PVSoldierMyLookDetail:createBasicAttribute()


    self.nodeToContain = game.newNode()  -- 存放部件的node
    self.svContaner:addChild(self.nodeToContain)
    theHight = 0
    local dataNum = table.getn(self.data)
    for k,v in pairs(self.data) do
        if v.tag == 1 then
            if (k-1) ~= 0 and v.tag == self.data[k-1].tag then
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item2.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem2"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem2"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem2"]["boundarySprite"]
                labelName:setString(v.title)
                labelAtt:setString(v.content)
                local nodeSize = self.attrNode["UIAttriItem2"]["itemNode"]:getContentSize()
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)
                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            else
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem"]["boundarySprite"]
                labelName:setString(v.title)
                labelAtt:setString(v.content)
                local tagSprite = self.attrNode["UIAttriItem"]["tagSprite"]
                local nodeSize = self.attrNode["UIAttriItem"]["itemNode"]:getContentSize()
                tagSprite:setSpriteFrame("ui_soldier_jineng.png")
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)

                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            end
        elseif v.tag ==2 then
            if (k-1) ~= 0 and v.tag == self.data[k-1].tag then
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item2.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem2"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem2"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem2"]["boundarySprite"]
                labelName:setString(v.title)
                labelAtt:setString(v.content)
                local nodeSize = self.attrNode["UIAttriItem2"]["itemNode"]:getContentSize()
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)

                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            else
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem"]["boundarySprite"]
                labelName:setString(v.title)
                labelAtt:setString(v.content)
                local tagSprite = self.attrNode["UIAttriItem"]["tagSprite"]
                local nodeSize = self.attrNode["UIAttriItem"]["itemNode"]:getContentSize()
                tagSprite:setSpriteFrame("ui_soldier_jiban.png")
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)

                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            end
        elseif v.tag == 3 then
          if (k-1) ~= 0 and v.tag == self.data[k-1].tag then
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item2.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem2"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem2"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem2"]["boundarySprite"]
                local title = "突破"..v.title
                labelName:setString(title)
                labelAtt:setString(v.content)
                local nodeSize = self.attrNode["UIAttriItem2"]["itemNode"]:getContentSize()
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)

                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            else
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem"]["boundarySprite"]
                local title = "突破"..v.title
                labelName:setString(title)
                labelAtt:setString(v.content)
                local tagSprite = self.attrNode["UIAttriItem"]["tagSprite"]
                local nodeSize = self.attrNode["UIAttriItem"]["itemNode"]:getContentSize()
                tagSprite:setSpriteFrame("ui_soldier_tupo.png")
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)

                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            end
        elseif v.tag ==4 then
            if (k-1) ~= 0 and v.tag == self.data[k-1].tag then
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item2.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem2"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem2"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem2"]["boundarySprite"]
                labelName:setString(v.title)
                labelAtt:setString(v.content)
                local nodeSize = self.attrNode["UIAttriItem2"]["itemNode"]:getContentSize()
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)

                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            else
                self.attrNode = {}
                local proxy = cc.CCBProxy:create()
                local node = CCBReaderLoad("soldier/ui_soldier_attri_item.ccbi", proxy, self.attrNode)
                local labelName = self.attrNode["UIAttriItem"]["soldierName"]
                local labelAtt = self.attrNode["UIAttriItem"]["detailLabel"]
                -- local boundarySpr = self.attrNode["UIAttriItem"]["boundarySprite"]
                labelName:setString(v.title)
                labelAtt:setString(v.content)
                local tagSprite = self.attrNode["UIAttriItem"]["tagSprite"]
                local nodeSize = self.attrNode["UIAttriItem"]["itemNode"]:getContentSize()
                tagSprite:setSpriteFrame("ui_soldier_jianjie.png")
                theHight = nodeSize.height + theHight
                self.nodeToContain:addChild(node)
                node:setPositionY(-theHight)

                -- if k < dataNum and v.tag == self.data[k+1].tag then
                --     boundarySpr:setVisible(true)
                -- else
                --     boundarySpr:setVisible(false)
                -- end
            end
        end
    end

    self.nodeToContain:setPositionY(theHight)
    self.svContaner:setContentSize( cc.size(self.contentLayer:getContentSize().width, theHight) )
    self.scrollView:setContentSize( cc.size(self.contentLayer:getContentSize().width, theHight) )

    -- self.scrollView:updateInset()
    self.scrollView:setContentOffset(self.scrollView:minContainerOffset())
end



function PVSoldierMyLookDetail:updateData()

    local soldierId = self.soldierDataItem.hero_no
    local break_level = self.soldierDataItem.break_level

    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(soldierId)
    local level = self.soldierDataItem.level
    local quality = soldierTemplateItem.quality
    updateStarLV(self.starTable, quality) --更新星级
    -- self.levelBMLabel:setString(string.format(level)) --更新等级
    local levelNode = getLevelNode(level)
    self.levelBMLabel:addChild(levelNode)
    -- self.lvBMLabel:setString("Lv."..level)
    print("soldierId soldierId ================= ", soldierId)
    self:initHeroImage(soldierId)
    self:updateSoldierAttr()
    --self:initHeroImage(soldierId)

    local _name = self.c_SoldierTemplate:getHeroName(soldierId)
    self.heroName:setString(_name)

    if break_level == 0 then self.heroBreakNumImg:setVisible(false)
    else
        -- print("break break_level img", break_level)
        local strImg = "ui_lineup_number"..tostring(break_level)..".png"
        self.heroBreakNumImg:setSpriteFrame(strImg)
        self.heroBreakNumImg:setVisible(true)
    end
    local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
    self.heroName:setColor(color)

    -- local quality = soldierTemplateItem.quality
    -- local resIcon = self.c_SoldierTemplate:getSoldierIcon(soldierId)
    -- changeNewIconImage(self.heroCardImg, resIcon, quality)

    local _type = soldierTemplateItem.job
    -- local strType = getHeroTypeName(_type)
    -- self.heroTypeBMLabel:setString(strType)
    --更新战斗力
    --获取当前的武将的战斗力
    local soldierDataItem = self.c_SoldierData:getSoldierDataById(soldierId)
    local curPower = self.c_Calculation:CombatPowerSoldierSelf(soldierDataItem)
    curPower = math.floor(curPower)
    self.curPowerNum:setString(curPower)
end

--更新人物图像
function PVSoldierMyLookDetail:initHeroImage(heroId)
    --武将觉醒相关
    self.curTypeIndex = 1
    --更新英雄大图
    addHeroHDSpriteFrame(heroId)

    self.playerSprite:removeAllChildren()
    local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(heroId)--getHeroBigImageById(heroId)

    -- print("++++++++++++++++++++++ 英雄大图 ++++++++++++++++++++++++++++++++")
    -- print(heroImageNode)
    self.playerSprite:addChild(heroImageNode)
    self.playerChangeSprite:setVisible(false)
    heroImageNode:setPosition(self.playerSprite:getContentSize().width / 2, self.playerSprite:getContentSize().height / 2)


end

function PVSoldierMyLookDetail:createOneDataItem(tag, title, content)
    local _data = {}
    _data.tag = tag
    _data.title = title
    _data.content = content
    table.insert(self.data, _data)
end

--武将觉醒 更改英雄大图
function PVSoldierMyLookDetail:changeHeroImage(heroId1, heroId2)
    print("切换觉醒的图片================== ")
    print("changeHeroImage : ", heroId1, heroId2)
    addHeroHDSpriteFrame(heroId1)
    addHeroHDSpriteFrame(heroId2)

    self.playerSprite:removeAllChildren()
    local heroImageNode1 = self.c_SoldierTemplate:getHeroBigImageById(heroId1)
    self.playerSprite:addChild(heroImageNode1)
    heroImageNode1:setPosition(self.playerSprite:getContentSize().width / 2, self.playerSprite:getContentSize().height / 2)
    -- self.playerSprite:setVisible(false)
    self.playerChangeSprite:removeAllChildren()
    local heroImageNode2 = self.c_SoldierTemplate:getHeroBigImageById(heroId2)
    self.playerChangeSprite:addChild(heroImageNode2)
    heroImageNode2:setPosition(self.playerChangeSprite:getContentSize().width / 2, self.playerChangeSprite:getContentSize().height / 2)

    local function callBack()
        local fadeInAction = cc.FadeIn:create(1)
        local fadeOutAction = cc.FadeOut:create(1)
        local action2 = cc.Sequence:create(fadeInAction, fadeOutAction)
        heroImageNode2:runAction(action2)
    end

    local fadeInAction = cc.FadeIn:create(1)
    local fadeOutAction = cc.FadeOut:create(1)
    local action = cc.Sequence:create(fadeOutAction, fadeInAction, cc.CallFunc:create(callBack))

    -- heroImageNode1:runAction(action)

    if self.curId ~= self.curSoldierId then
        local effect = UI_Wujiangzhuanhuanzise()
        self.animationNode:addChild(effect)
        self.curSoldierLayer:setVisible(false)
        self.awakeSoldierLayer:setVisible(true)
    else
        self.curSoldierLayer:setVisible(true)
        self.awakeSoldierLayer:setVisible(false)
    end
    -- self:updateData()
    self:updateSoldierAttr()
end

--武将觉醒 滑动查看武将信息
function PVSoldierMyLookDetail:initHeroLayerTouch()
    local posX,posY = self.heroLayer:getPosition()
    local size = self.heroLayer:getContentSize()

    local rectArea = cc.rect(posX, posY, size.width, size.height)

    local moveType = self.TYPE_MOVE_NONE
    local MAGIN = 40
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            local isInRect = cc.rectContainsPoint(rectArea, cc.p(x,y))
            moveType = self.TYPE_MOVE_NONE
            if isInRect then
                self.touchBeginX = x
                return true
            else
                return false
            end

        elseif  eventType == "moved" then
            local length = self.touchBeginX - x
            if math.abs(length) > MAGIN then
                if length > 0 then
                    moveType = self.TYPE_MOVE_LEFT
                else
                    moveType = self.TYPE_MOVE_RIGHT
                end
            else
                moveType = self.TYPE_MOVE_NONE
            end
        elseif  eventType == "ended" then
        print("moveType ========== ", moveType)
            self:onLayerTouchCallBack(moveType)
        end
    end
    self.heroLayer:registerScriptTouchHandler(onTouchEvent)
    self.heroLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.heroLayer:setTouchEnabled(true)
end

function PVSoldierMyLookDetail:onLayerTouchCallBack(moveType)
    if self.curId == self.curSoldierId then
        self.curSoldierId = self.changeId
        self.changeId = self.curId
    elseif self.curId == self.changeId then
        self.changeId = self.curSoldierId
        self.curSoldierId = self.curId
    end

    if moveType == self.TYPE_MOVE_RIGHT then
        self:OnTouchMoveRight()
    elseif moveType == self.TYPE_MOVE_LEFT then
        self:OnTouchMoveLeft()
    end
end
--往左滑动
function PVSoldierMyLookDetail:OnTouchMoveLeft()
    -- if self.curTypeIndex == 1 and self.changeId ~= nil then
        -- print("向左 ====================== ")
        -- self.playerSprite:setVisible(false)
        -- self.playerChangeSprite:setVisible(false)
        -- self.curTypeIndex = 2
        -- self:changeHeroImage(self.changeId, self.curSoldierId)                            --变身之后的图片
    -- end
    self:changeHeroImage(self.curSoldierId, self.changeId)
end

--往右滑动
function PVSoldierMyLookDetail:OnTouchMoveRight()
    -- if self.curTypeIndex == 2 then
        -- print("向右 ================== ")
        -- self.playerChangeSprite:setVisible(false)
        -- self.playerSprite:setVisible(false)
        -- self.curTypeIndex = 1                               --原图
        -- self:changeHeroImage(self.curSoldierId, self.changeId)
    -- end
    self:changeHeroImage(self.curSoldierId, self.changeId)
end

--武将觉醒 战斗力显示更新
function PVSoldierMyLookDetail:changePowerShow(power)
    local needPower = tonumber(self.needPowerChange)
    if needPower == nil then return end
    if power > needPower then
        self.powerDes:setString(Localize.query("soldier.4"))
        self.powerNum:setString(needPower)
        self.powerDes:setColor(ui.COLOR_WHITE)
        self.powerNum:setColor(ui.COLOR_WHITE)
    else
        self.powerDes:setString(Localize.query("soldier.5"))
        self.powerNum:setString(needPower)
        self.powerDes:setColor(ui.COLOR_RED)
        self.powerNum:setColor(ui.COLOR_RED)
    end
end

function PVSoldierMyLookDetail:onReloadView()
    -- local power = getDataManager():getCommonData():getCombatPower()                 --获取战斗数值
    -- self:changePowerShow(power)
    self.blackCL:setVisible(false)
    self:updateData()
end

function PVSoldierMyLookDetail:updateSoldierAttr(hero)
    local attr = {}
    table.print(self.soldierDataItem)
    if self.curId == self.curSoldierId then
        attr = self.c_Calculation:SoldierSelfAttr(self.soldierDataItem)
    else
        attr = self.c_Calculation:AwakeSoldierSelfAttr(self.soldierDataItem)
    end
    print(attr)
    print(self.curTypeIndex)
    print("-----------------")
    self.powerBMLabel:setString(string.format(roundAttriNum(attr.atkHero)))
    self.hpBMLabel:setString(string.format(roundAttriNum(attr.hpHero)))
    self.physicalDefenseLabel:setString(string.format(roundAttriNum(attr.physicalDefHero)))
    self.magicDefenseLabel:setString(string.format(roundAttriNum(attr.magicDefHero)))

    -- local soldierId = self.soldierDataItem.hero_no
    -- self:initHeroImage(soldierId)
end



return PVSoldierMyLookDetail
