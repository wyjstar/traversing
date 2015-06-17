--关卡详情页面
--可由玩家选择 难度 扫荡

local PVStageDetails = class("PVStageDetails", BaseUIView)

function PVStageDetails:ctor(id)
    PVStageDetails.super.ctor(self, id)

    self.baseTemp = getTemplateManager():getBaseTemplate()
    self._stageTemp = getTemplateManager():getInstanceTemplate()
    self._languageTemp = getTemplateManager():getLanguageTemplate()
    self._stageData = getDataManager():getStageData()
    self._dropTemp = getTemplateManager():getDropTemplate()
    self._resourceTemp = getTemplateManager():getResourceTemplate()
    self._soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.lineUpData = getDataManager():getLineupData()
    self.squipTemp = getTemplateManager():getSquipmentTemplate()
    self._chipTemp = getTemplateManager():getChipTemplate()
    self.commonData = getDataManager():getCommonData()
    self._instanceNet = getNetManager():getInstanceNet()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_EquipmentData = getDataManager():getEquipmentData()

    self:registerNetCallback()

    self.SAO_TYPE_ONE = 10000
    self.SAO_TYPE_TEN = 10001
    self.saoType = nil
    self.saoTimes = 0
    self._stageData:setIsMopUpOrResetStage(false)
end

function PVStageDetails:registerNetCallback()
    local function receivePopUpCallBack(id, data)
        print("mopup call back : id====" .. id)
        table.print(data)
        local stageId = self:getStageId()

        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVMopUp", stageId, self.saoType)
    end

    local function receiveResetStageCallBack()
        local _stageId = self:getStageId()
        print("----回调后---" .. _stageId)
        self:updateViewData(_stageId)
    end

    self:registerMsg(INST_FIGHT_SWEEP_CODE, receivePopUpCallBack)
    self:registerMsg(INST_STAGE_RESET_CODE, receiveResetStageCallBack)
end

function PVStageDetails:onMVCEnter()
    self:showAttributeView()
    assert(self.funcTable, "PVStageDetails must have stage's id !")
    self.data = self.funcTable[1]  -- simple stage id
    self.ccbiNode = {}
    self:initTouchListener()

    self:loadCCBI("instance/ui_stage_details.ccbi", self.ccbiNode)

    self:initData()
    self:initView()

    self:createDiffModel()
    self:createDropList(self.simpleId)
end

function PVStageDetails:initData()

    self.simpleId = self.data
    self.chapterIdx, self.stageIdx = self._stageTemp:getIndexofStage(self.simpleId)
    self.simpleState = self._stageData:getStageState(self.simpleId)
    if self.chapterIdx >= 2 then
        self.normalId = self._stageTemp:getNormalStage(self.chapterIdx, self.stageIdx)
        self.normalState = self._stageData:getStageState(self.normalId)
    end
    if self.chapterIdx >= 3 then
        self.diffcultId = self._stageTemp:getDiffcultStage(self.chapterIdx, self.stageIdx)
        self.diffcultState = self._stageData:getStageState(self.diffcultId)
    end

    self:initEntryData(self.simpleId)
end

function PVStageDetails:initEntryData(cur_break_id)
    -- --乱入信息获取
    local break_id = self._stageTemp:getTemplateById(cur_break_id).stage_break_id
    self.break_data = self._stageTemp:getConditionDetail(break_id)
    self.conditionItems = {}
    self.curProbability = 0
    if self.break_data ~= nil then
        for i = 1, 7 do
            local condition_key = "condition" .. tostring(i)
            local text_id_key = "text_id" .. tostring(i)
            local odds_key = "odds" .. tostring(i)
            local text_id = self.break_data[text_id_key]
            if text_id ~= 0 then
                local conditionItem = {}
                conditionItem.condition = self.break_data[condition_key]
                conditionItem.text_id = self.break_data[text_id_key]
                conditionItem.odds = self.break_data[odds_key]
                conditionItem.typeIndex = i
                local result = true
                print("conditionItem ============= ", i,     self.break_data[odds_key])
                table.print(conditionItem.condition)
                for k,v in pairs(conditionItem.condition) do
                    local ref = self:isFullConditionMethod(tostring(i), v, k)
                    if ref == false then result = false break end
                end
                conditionItem.isFullCondition = result
                table.insert(self.conditionItems, conditionItem)
            end
        end
    end
end


function PVStageDetails:isFullConditionMethod(type_key, type_value, curType)
    if type_key == "1" then
        self.onLineupNum = self.lineUpData:getOnLineUpNum()
        if self.onLineupNum == type_value then
            self.curProbability = self.curProbability + self.break_data.odds1
            -- print("self.curProbability === self.break_data.odds1 ======= ", self.curProbability ,    self.break_data.odds1)
            return true
        end
    elseif type_key == "2" then
        for k,v in pairs(self.lineUpData.selectSoldier) do
            if v.hero.hero_no == type_value then
                self.curProbability = self.curProbability + self.break_data.odds2
                -- print("self.curProbability === self.break_data.odds2 ======= ", self.curProbability ,    self.break_data.odds2)
                return true
            end
        end
    elseif type_key == "3" then
        --装备
        local equips = self.lineUpData:getOnLineUpEquip()
        for k,v in pairs(equips) do
            for m, n in pairs(v) do
                if  type_value == n.equ.no then
                    self.curProbability = self.curProbability + self.break_data.odds3
                    -- print("self.curProbability === self.break_data.odds3 ======= ", self.curProbability ,    self.break_data.odds3)
                    return true
                end
            end
        end
    elseif type_key == "4" then
        -- if curType == "4" then
        --     --装备套装
        --     local suitTable = self.squipTemp:getTemplateById(type_value).suitMapping
        --     local isHave = self.lineUpData:getOnLineUpEquipSuit(suitTable)
        --     if isHave then
        --         self.curProbability = self.curProbability + self.break_data.odds4
        --         return true
        --     end
        -- else
        if curType == "3" then
            --装备
            local equips = self.lineUpData:getOnLineUpEquip()
            for k,v in pairs(equips) do
                for m, n in pairs(v) do
                    if  type_value == n.equ.no then
                        self.curProbability = self.curProbability + self.break_data.odds4
                        -- print("self.curProbability === self.break_data.odds4 ======= ", self.curProbability ,    self.break_data.odds4)
                        return true
                    end
                end
            end
        end
    elseif type_key == "5" then
        -- if curType == "4" then
        --     --装备套装
        --     local suitTable = self.squipTemp:getTemplateById(type_value).suitMapping
        --     local isHave = self.lineUpData:getOnLineUpEquipSuit(suitTable)
        --     if isHave then
        --         self.curProbability = self.curProbability + self.break_data.odds5
        --         return true
        --     end
        -- else
        if curType == "3" then
            --装备
            local equips = self.lineUpData:getOnLineUpEquip()
            for k,v in pairs(equips) do
                for m, n in pairs(v) do
                    if  type_value == n.equ.no then
                        self.curProbability = self.curProbability + self.break_data.odds5
                        -- print("self.curProbability === self.break_data.odds5 ======= ", self.curProbability ,    self.break_data.odds5)
                        return true
                    end
                end
            end
        elseif curType == "5" then
            local curResult = true
            local curNum = 0
            local linkNum = 0
            for k,v in pairs(self.lineUpData.selectSoldier) do
                if v.hero.hero_no ~= 0 then
                    local linkItem = self._soldierTemplate:getLinkTempLateById(v.hero.hero_no)
                    for i=1, 5 do
                        local link_key = "link" .. i
                        local trigger_key = "trigger" .. i
                        local link_value = linkItem[link_key]
                        local trigger_value = linkItem[trigger_key]
                        if link_value == type_value then
                            linkNum = table.getn(trigger_value)
                            for m, n in pairs(self.lineUpData.selectSoldier) do
                                for h, g in pairs(trigger_value) do
                                    if n.hero.hero_no == g then
                                        curNum = curNum + 1
                                    end
                                end
                            end

                        end
                    end
                end
            end

            if curNum == linkNum and curNum > 0 and  linkNum > 0 then
                self.curProbability = self.curProbability + self.break_data.odds5
                return true
            end
        end
    elseif type_key == "6" then
        local curResult = true
        local curNum = 0
        local linkNum = 0
        for k,v in pairs(self.lineUpData.selectSoldier) do
            if v.hero.hero_no ~= 0 then
                local linkItem = self._soldierTemplate:getLinkTempLateById(v.hero.hero_no)
                for i=1, 5 do
                    local link_key = "link" .. i
                    local trigger_key = "trigger" .. i
                    local link_value = linkItem[link_key]
                    local trigger_value = linkItem[trigger_key]
                    if link_value == type_value then
                        linkNum = table.getn(trigger_value)
                        for m, n in pairs(self.lineUpData.selectSoldier) do
                            for h, g in pairs(trigger_value) do
                                if n.hero.hero_no == g then
                                    curNum = curNum + 1
                                    -- self.curProbability = self.curProbability + self.break_data.odds6
                                    -- print("self.curProbability === self.break_data.odds6 ======= ", self.curProbability ,    self.break_data.odds6)
                                end
                            end
                        end
                        -- if curNum == linkNum then
                        --     self.curProbability = self.curProbability + self.break_data.odds6
                        --     return true
                        -- end
                    end
                end
            end
        end

        if curNum == linkNum and curNum > 0 and  linkNum > 0 then
            self.curProbability = self.curProbability + self.break_data.odds6
            return true
        end
    end
    return false
end

function PVStageDetails:initView()
    self.ccbiRootNode = self.ccbiNode["UIStageDetails"]

    self.labelStageName = self.ccbiRootNode["font_stage_name"]      -- 关卡名字
    self.labelFightTimes = self.ccbiRootNode["fightTimeslabel"]     -- 当天挑战次数label
    self.labelBodyPower = self.ccbiRootNode["label_body_power"]     -- 一次挑战消耗体力

    self.nodeLR = self.ccbiRootNode["node_lr"]                      -- 乱入节点
    self.spriteNoLR = self.ccbiRootNode["sprite_no_lr"]             -- 无乱入时该显示的图片
    self.labelLR_Name = self.ccbiRootNode["label_lr_name"]          -- 乱入武将名
    self.propIconNode = self.ccbiRootNode["propIconNode"]                   --乱入武将的头像
    self.labelLR_Percent = self.ccbiRootNode["label_lr_percent"]    -- 乱入几率
    self.heroNameSp = self.ccbiRootNode["heroNameSp"]               -- 乱入武将名字图

    self.layerItems = self.ccbiRootNode["layer_items"]      -- 掉落物品层
    self.layerModel = self.ccbiRootNode["layer_model"]      -- 难易模式层
    self.menuRight = self.ccbiRootNode["arrow_right"]
    self.menuLeft = self.ccbiRootNode["arrow_left"]
    self.menuRight:setAllowScale(false)
    self.menuLeft:setAllowScale(false)

    self.menuSaoTen = self.ccbiRootNode["sao_ten"]         -- 底部扫荡
    self.menuSaoOne = self.ccbiRootNode["sao_one"]
    self.menuFightWar = self.ccbiRootNode["start_war"]      -- 开干
    self.animationNode = self.ccbiRootNode["animationNode"]
    self.expLabel = self.ccbiRootNode["exp_label"]
    self.coinLabel = self.ccbiRootNode["coin_label"]

    self:setSaoEnabled(false)

    ---- 赋值 ----
    local _stageNameId = self._stageTemp:getTemplateById(self.simpleId).name
    local chapterStr = self._stageTemp:getTemplateById(self.simpleId).chapter
    local sectionStr = self._stageTemp:getTemplateById(self.simpleId).section
    local _stateName = self._languageTemp:getLanguageById(_stageNameId)
    self.labelStageName:setString(chapterStr .. "-" .. sectionStr .. " " .. _stateName)

    -- self.labelLR_Name:setString(self.soldier_name)

    self:updateViewData(self.simpleId)
    self:updateSweepEnabled(self.simpleId)
    self:updateEntryView(self.simpleId)
end

function PVStageDetails:updateEntryView(id)
    print("当前的模式 ============== ", id)
    --乱入信息获取
    local break_id = self._stageTemp:getTemplateById(id).stage_break_id
    self.break_data = self._stageTemp:getConditionDetail(break_id)

    self:initEntryData(id)
    self.labelLR_Percent:setString(self.curProbability * 100)
    --乱入英雄信息
    local hero_id = self.break_data.hero_id
    print("乱入英雄的id ================ ", hero_id)
    self.entryHeroId = hero_id
    local resIcon = getTemplateManager():getSoldierTemplate():getSoldierIcon(hero_id)
    local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(hero_id)
    -- changeNewIconImage(self.propIcon, resIcon, quality) --更新icon
    addHeroHDSpriteFrame(hero_id)
    self.propIconNode:removeAllChildren()
    self.propIconNode:addChild(getTemplateManager():getSoldierTemplate():getHeroBigImageById(hero_id))
    self.propIconNode:setScale(2.5)
    self.soldier_name = self._soldierTemplate:getHeroName(hero_id)      --乱入武将的名称
    print("乱入武将的名称 ============== ", self.soldier_name)
    self.labelLR_Name:setString(self.soldier_name)
    self:setLuanruHeroNameSp(self.heroNameSp,self.soldier_name)


    -- self.soldier_icon = self._soldierTemplate:getResIconNo(hero_id)     --乱入武将的头像信息
end

function PVStageDetails:setLuanruHeroNameSp(sprite,heroName)
    if heroName == "李元霸" then
        sprite:setSpriteFrame("ui_instance_word_liyuanba.png.png")
    elseif heroName == "刘邦" then
        sprite:setSpriteFrame("ui_instance_word_liubang.png")
    elseif heroName == "项羽" then
        sprite:setSpriteFrame("ui_instance_word_xiangyu.png")
    elseif heroName == "李广" then
        sprite:setSpriteFrame("ui_instance_word_liguang.png")
    elseif heroName == "荆轲" then
        sprite:setSpriteFrame("ui_instance_word_jingke.png")
    else
        print("PVStageDetails:setLuanruHeroNameSp(sprite,heroName) ：不是有效的乱入武将名字")
    end
end

-- 根据id来update界面上的数据
function PVStageDetails:updateViewData(id)
    self.stageTempItem = self._stageTemp:getTemplateById(id)
    local _currFightNum = self._stageData:getStageFightNum(id)
    local _maxFightNum = self.stageTempItem.limitTimes  --挑战次数
    local _useVigor = self.stageTempItem.vigor --消耗体力
    self.useStamina = _useVigor

    if _maxFightNum ~= 0 then
        self.labelFightTimes:setString(string.format("%d/%d", _maxFightNum-_currFightNum, _maxFightNum))
    else
        self.labelFightTimes:setString(string.format("%d", _currFightNum))
    end


    self.labelBodyPower:setString(string.format(_useVigor))
    -- 超过挑战次数，设置进入战场按钮不可用
    print(" 超过挑战次数，设置进入战场按钮不可用")
    print("_currFightNum====" .. _currFightNum)
    print("_maxFightNum====" .. _maxFightNum)
    -- if _currFightNum >= _maxFightNum then
    --     self.menuFightWar:setEnabled(false)
    -- else
    --     self.menuFightWar:setEnabled(true)
    -- end

    -- 战斗是否可用
    local state = self._stageData:getStageState(id)
    -- if state == 1 then
    --     self.menuFightWar:setEnabled(false)
    -- end

    print("state====" .. state)
    if state == 1 or state == 0 or state == -1 then
        self.menuFightWar:setEnabled(true)
    else
        self.menuFightWar:setEnabled(false)
    end
    -- 扫荡结束刷新pageview
    if self._stageData:getIsMopUpOrResetStage() then
        print("------扫荡结束------")
        print(self.pageView:getCurPageIndex())

        local  _CurPageIndex = self.pageView:getCurPageIndex()
        self.layerModel:removeAllChildren()
        self:createDiffModel()
        self.pageView:scrollToPage(_CurPageIndex)
        self._stageData:setIsMopUpOrResetStage(false)
    end
end

--绑定事件
function PVStageDetails:initTouchListener()

    local function backMenuClick()
        -- 重置当前关卡id
        self._stageData:setCurrStageId(nil)
        getAudioManager():playEffectButton2()
        self:onHideView(1)
        --stepCallBack(G_GUIDE_70002)
        --stepCallBack(G_GUIDE_90002)
    end

    local function seeLRMenuClick()
        print("see ......")
        local index = self.pageView:getCurPageIndex()+1
        local _curId = self:getStageId()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVStageEntry", _curId, self.conditionItems, self.curProbability)
    end

    local function sweepTenMenuClick()  -- 扫荡十次
        print("扫荡", self:getStageId())
        getAudioManager():playEffectButton2()

        local vipLevel = getTemplateManager():getBaseTemplate():getSweepTenVip()
        local curVipLevel = getDataManager():getCommonData():getVip()
        if curVipLevel < vipLevel then
            getOtherModule():showAlertDialog(nil, string.format(Localize.query("stage.vipLevel.noEnough"), vipLevel) )
            return
        end


        local isCanSaoTen, times = self:checkIsCanSaoTen()

        print("checkIsCanSaoTen=====" , isCanSaoTen, times)
        if isCanSaoTen then
            self.saoTimes = times
            getNetManager():getInstanceNet():sendSweepTen(self:getStageId(), times)

            self.saoType = self.SAO_TYPE_TEN
        end
    end

    local function sweepMenuClick()  -- 扫荡
        print("sweepMenuClick------扫荡", self:getStageId())

        --vip限制
        --     getOtherModule():showOtherView("SystemTi
        local vipLevel = getTemplateManager():getBaseTemplate():getSweepVip()
        local curVipLevel = getDataManager():getCommonData():getVip()
        if curVipLevel < vipLevel then
            getOtherModule():showAlertDialog(nil, string.format(Localize.query("stage.vipLevel.noEnough"), vipLevel))
            return
        end


        --local freeTime = self:getFreeSweepTime()
        -- if freeTime <= 0 thenps",
        --      string.format(Localize.query("instance.10"), 1 * self.baseTemp:getSweepMoneyOneTime()))
        -- else

        -- local IsCanFight = self:checkIsCanFight()
        local IsCanFight = self:checkIsCanSao()
        print("IsCanFight====", IsCanFight)

        if IsCanFight then
            getAudioManager():playEffectButton2()
            getNetManager():getInstanceNet():sendSweepOne(self:getStageId())


            self.saoType = self.SAO_TYPE_ONE
        end
    end

    local function fightMenuClick()
        getAudioManager():playEffectButton2()
        -- self._stageData:setCurrStageId(self:getStageId())
        -- --挑战次数
        local stageId = self:getStageId()
        print("------stageId--------",stageId)
        self._stageData:setCurrStageId(stageId)
        local stageTempItem = self._stageTemp:getTemplateById(stageId)
        local _currFightNum = self._stageData:getStageFightNum(stageId)
        local _maxFightNum = self.stageTempItem.limitTimes  --挑战次数
        if _currFightNum == _maxFightNum then
            self:resetStageLogic()    -- 挑战次数耗尽，进入战场弹框
        else
            local _useVigor = stageTempItem.vigor
            if getDataManager():getCommonData():getStamina() >= _useVigor then
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", stageId, "normal")
                groupCallBack(GuideGroupKey.BTN_ENTER_LINEUP)
            else
                local left = getTemplateManager():getBaseTemplate():getBuyStaminaLeftTimes()
                if left > 0 then
                    getOtherModule():showOtherView("PVBuyStamina")
                else
                    getOtherModule():showAlertDialog(nil, Localize.query("basic.1"))
                end
            end  
        end
    end

    local function onItemClick()
        getAudioManager():playEffectButton2()
        print(" ------------------ onItemClick =============== ")
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", self.entryHeroId, 2, nil, 1)
    end

    self.ccbiNode["UIStageDetails"] = {}
    self.ccbiNode["UIStageDetails"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UIStageDetails"]["seeLRMenuClick"] = seeLRMenuClick
    self.ccbiNode["UIStageDetails"]["sweepTenMenuClick"] = sweepTenMenuClick
    self.ccbiNode["UIStageDetails"]["sweepMenuClick"] = sweepMenuClick
    self.ccbiNode["UIStageDetails"]["fightMenuClick"] = fightMenuClick
    self.ccbiNode["UIStageDetails"]["onItemClick"] = onItemClick

end

function PVStageDetails:checkIsCanSao()

    --体力
    local nowStamina = self.commonData:getStamina()
    -- self.useStamina = 80000000
    if nowStamina < self.useStamina then --如果体力不足

        local left = getTemplateManager():getBaseTemplate():getBuyStaminaLeftTimes()
        if left > 0 then
            -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVBuyStamina")
            getOtherModule():showOtherView("PVBuyStamina")
        else
            getOtherModule():showAlertDialog(nil, Localize.query("basic.1"))
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("SystemTips", Localize.query("basic.1"), 1)
        end
        return false
    end

    -- --挑战次数
    local stageId = self:getStageId()
    local stageTempItem = self._stageTemp:getTemplateById(stageId)
    local _currFightNum = self._stageData:getStageFightNum(stageId)
    local _maxFightNum = self.stageTempItem.limitTimes  --挑战次数
    if _currFightNum >= _maxFightNum then
        --getOtherModule():showAlertDialog(nil, Localize.query("instance.1"))
        self:resetStageLogic()
        return false
    end
    return true
end

function PVStageDetails:checkIsCanSaoTen()
    --体力
    local nowStamina = self.commonData:getStamina() --当前体力
    local times = 10

    print("nowStamina====" .. nowStamina)
    print(self.useStamina * 10)
    if self.useStamina * 10 > nowStamina then
        -- local times, _ = math.modf(nowStamina / self.useStamina)
        times, _ = math.modf(nowStamina / self.useStamina)
    end
    print("times====" , times)
    --挑战次数
    local stageId = self:getStageId()
    local stageTempItem = self._stageTemp:getTemplateById(stageId)
    local _currFightNum = self._stageData:getStageFightNum(stageId)
    local _maxFightNum = self.stageTempItem.limitTimes  --挑战次数
    if _currFightNum >= _maxFightNum then
        --getOtherModule():showAlertDialog(nil, Localize.query("instance.1"))
        self:resetStageLogic()
        return false
    end
    if times > ( _maxFightNum - _currFightNum ) then
        times = _maxFightNum - _currFightNum
    end
    if times <= 0 then
        local left = getTemplateManager():getBaseTemplate():getBuyStaminaLeftTimes()
        if left > 0 then
            -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVBuyStamina")
            getOtherModule():showOtherView("PVBuyStamina")
        else
            getOtherModule():showAlertDialog(nil, Localize.query("basic.1"))
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("SystemTips", Localize.query("basic.1"), 1)
        end
        return false
    end
    return true, times
end

--创建难易模式
function PVStageDetails:createDiffModel()

    local _size = self.layerModel:getContentSize()

    local MainLayout = ccui.Layout:create()
    MainLayout:setSize( _size )
    MainLayout:setClippingEnabled(true)
    self.layerModel:addChild(MainLayout)

    self.pageView = ccui.PageView:create()
    self.pageView:setTouchEnabled(true)
    self.pageView:setSize( cc.size(_size.width-75,_size.height) )
    self.pageView:setAnchorPoint(cc.p(0.5,0.5))
    self.pageView:setPosition( cc.p(_size.width/2, _size.height/2) )
    self.pageView:setClippingEnabled(false)
    MainLayout:addChild(self.pageView)

    -- local bg_light = {}
    self.starImgTable = {}

    -- 添加三模式
    for i = 1 , 3 do
        local layout = ccui.Layout:create()
        --重置fb次数
        local function onResetClick()
            getAudioManager():playEffectButton2()
            self:resetStageLogic()    -- 挑战次数耗尽，重置弹框 2
        end

        local _ModelItem = {}
         _ModelItem["UIChapterModel"] = {}
         _ModelItem["UIChapterModel"]["onResetClick"] = onResetClick

        local proxy = cc.CCBProxy:create()
        local _ccbNode = CCBReaderLoad("instance/ui_cinstanceModelItem.ccbi", proxy, _ModelItem)


        -- 获取控件
        -- table.insert(bg_light, _ModelItem["UIChapterModel"]["bg_light"])
        local _fontImg = _ModelItem["UIChapterModel"]["fnt_model"]
        local _bgImg = _ModelItem["UIChapterModel"]["bg_sprite"]
        local _starImg = _ModelItem["UIChapterModel"]["img_star"]
        -- local _fightTimes = _ModelItem["UIChapterModel"]["fightTimes_label"]
        local _resetMenu = _ModelItem["UIChapterModel"]["resetMenu"]

        _resetMenu:setEnabled(false)
        --local _fightTimes = _ModelItem["UIChapterModel"]["label_fightTimes"]

        local _nanduImg = _ModelItem["UIChapterModel"]["nanduImg"]
        local _nanduBg = _ModelItem["UIChapterModel"]["nanduBg"]
        local _nanduWord = _ModelItem["UIChapterModel"]["nanduWord"]

        local starAnimateNode = UI_juqingyeqianjiemiandianjiguankajiemianjinxingxiangqian()
        starAnimateNode:setPosition(_starImg:getContentSize().width/2 - 8, _starImg:getContentSize().height/2)
        _starImg:addChild(starAnimateNode)

        layout:setSize(_ccbNode:getContentSize())
        table.insert(self.starImgTable, _starImg)

        local _times = nil
        local _currFightNums = 0
        local _id = nil
        if i == 1 then  -- easy model
            -- bg_light[1]:setVisible(true)
            self.coinLabel:setString(tostring(self._stageTemp:getTemplateById(self.simpleId).currency) )
            self.expLabel:setString(tostring(self._stageTemp:getTemplateById(self.simpleId).playerExp) )
            _times = self._stageTemp:getTemplateById(self.simpleId).limitTimes
            _currFightNums = self._stageData:getStageFightNum(self.simpleId)         -- 当前已挑战次数
            _id = self.simpleId
            if self.simpleState == 1 then _starImg:setVisible(true) end

            _nanduImg:setSpriteFrame("ui_instance_bing_Img.png")
            _nanduBg:setSpriteFrame("ui_instance_bing_bg_highlight.png")
            _nanduWord:setSpriteFrame("ui_instance_bing_word.png")  

            local bingAnimateNode = UI_juqingyeqianjiemiandianjiguankajiemiantubiaochixu002()
            local x,y = _nanduImg:getPosition() 
            bingAnimateNode:setPosition(x-30,y-60)
            _nanduImg:addChild(bingAnimateNode)

        elseif i == 2 then  -- normal model
            _fontImg:setSpriteFrame("ui_instance_common.png")
            -- _bgImg:setSpriteFrame("ui_instance_mode.png")
            -- self.coinLabel:setString(""..self._stageTemp:getTemplateById(self.normalId).currency)
            -- self.expLabel:setString(""..self._stageTemp:getTemplateById(self.normalId).playerExp)
            _times = self._stageTemp:getTemplateById(self.normalId).limitTimes
            _currFightNums = self._stageData:getStageFightNum(self.normalId)         -- 当前已挑战次数
            _id = self.normalId
            if self.normalState == 1 then _starImg:setVisible(true) end

            _nanduImg:setSpriteFrame("ui_instance_yi_Img.png")
            _nanduBg:setSpriteFrame("ui_instance_yi_bg_highlight.png")
            _nanduWord:setSpriteFrame("ui_instance_yi_word.png")
            local yiAnimateNode = UI_juqingyeqianjiemiandianjiguankajiemiantubiaochixu003()
            local x,y = _nanduImg:getPosition() 
            yiAnimateNode:setPosition(x-10,y-20)
            _nanduImg:addChild(yiAnimateNode)

        elseif i == 3 then  -- diffcult model
            _fontImg:setSpriteFrame("ui_instance_diff.png")
            -- _bgImg:setSpriteFrame("ui_instance_mode.png")
            -- self.coinLabel:setString(""..self._stageTemp:getTemplateById(self.diffcultId).currency)
            -- self.expLabel:setString(""..self._stageTemp:getTemplateById(self.diffcultId).playerExp)
            _times = self._stageTemp:getTemplateById(self.diffcultId).limitTimes
            _currFightNums = self._stageData:getStageFightNum(self.diffcultId)       -- 当前已挑战次数
            _id = self.diffcultId
            if self.diffcultState == 1 then _starImg:setVisible(true) end

            _nanduImg:setSpriteFrame("ui_instance_jia_Img.png")
            _nanduBg:setSpriteFrame("ui_instance_jia_bg_highlight.png")
            _nanduWord:setSpriteFrame("ui_instance_jia_word.png.png")

            local jiaAnimateNode = UI_juqingyeqianjiemiandianjiguankajiemiantubiaochixu001()
            local x,y = _nanduImg:getPosition() 
            jiaAnimateNode:setPosition(x+38,y+26)
            _nanduImg:addChild(jiaAnimateNode)
        end

        -- if _times ~= 0 then
        --     _fightTimes:setString(string.format("%d/%d", _times-_currFightNums, _times))
        -- else
        --     _fightTimes:setString(string.format("%d", _currFightNums))
        -- end
        --local _id = self:getStageId()
        local _viplevel = self.commonData:getVip()
        local _resetStageNum = self.baseTemp:getNumResetStageTimes(_viplevel)
        local _currentResetedStageNum = self._stageData:getResetedStageNum(_id)
        if _times ~= 0  and _times-_currFightNums == 0 and _currentResetedStageNum < _resetStageNum then
            _resetMenu:setEnabled(true)
        end

        layout:addChild(_ccbNode)
        local x,y = _ccbNode:getPosition()
        _ccbNode:setPosition(x+80,y+80)

        self.pageView:addPage(layout)

        if self.chapterIdx == 1 then break end
        if self.chapterIdx == 2 and i == 2 then break end
    end

    -- 添加左右滑动指示箭头
    self.arrowLeft = game.newSprite("#ui_shop_arr_l.png")
    self.arrowLeft:setScale(0.4)
    self.arrowLeft:setVisible(false)
    self.arrowRight = game.newSprite("#ui_shop_arr_r.png")
    self.arrowRight:setScale(0.4)
    self.arrowLeft:setPosition( 25, _size.height/2 )
    self.arrowRight:setPosition( _size.width-25, _size.height/2 )
    MainLayout:addChild(self.arrowLeft)
    MainLayout:addChild(self.arrowRight)

    -- pageview滑动事件
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local pageView = sender
            local pageIndex = pageView:getCurPageIndex()
            -- 控制指示箭头
            if self.chapterIdx == 2 then
                if pageIndex == 1 then
                    self.arrowRight:setVisible(false)
                    self.arrowLeft:setVisible(true)
                else
                    self.arrowRight:setVisible(true)
                    self.arrowLeft:setVisible(false)
                end
            elseif self.chapterIdx > 2 then
                if pageIndex == 2 then
                    self.arrowRight:setVisible(false)
                elseif pageIndex == 1 then
                    self.arrowLeft:setVisible(true)
                    self.arrowRight:setVisible(true)
                else
                    self.arrowLeft:setVisible(false)
                end
            end

            if pageIndex == 2 then -- diffcult
                self:updateViewData(self.diffcultId)
                self:updateEntryView(self.diffcultId)
                print("困难模式 ================= ", self.diffcultId)
                self:updateSweepEnabled(self.diffcultId)
                self.coinLabel:setString(tostring(self._stageTemp:getTemplateById(self.diffcultId).currency))
                self.expLabel:setString(tostring(self._stageTemp:getTemplateById(self.diffcultId).playerExp))
            elseif pageIndex == 1 then -- normal
                self:updateViewData(self.normalId)
                self:updateEntryView(self.normalId)
                print("正常模式 ================ ", self.normalId)
                self:updateSweepEnabled(self.normalId)
                self.coinLabel:setString(tostring(self._stageTemp:getTemplateById(self.normalId).currency))
                self.expLabel:setString(tostring(self._stageTemp:getTemplateById(self.normalId).playerExp))
            else -- simple
                self:updateViewData(self.simpleId)
                self:updateEntryView(self.simpleId)
                print("简单模式 ================ ", self.simpleId)
                self:updateSweepEnabled(self.simpleId)
                self.coinLabel:setString(tostring(self._stageTemp:getTemplateById(self.simpleId).currency) )
                self.expLabel:setString(tostring(self._stageTemp:getTemplateById(self.simpleId).playerExp) )
            end

            -- for i,v in ipairs(bg_light) do
            --     if i == pageIndex+1 then v:setVisible(true)
            --     else v:setVisible(false)
            --     end
            -- end
            

            self:createDropList(self:getStageId())
            for k,v in pairs(self.starImgTable) do
                local starAnimateNode = UI_juqingyeqianjiemiandianjiguankajiemianjinxingxiangqian()
                starAnimateNode:setPosition(v:getContentSize().width/2 - 8, v:getContentSize().height/2)
                v:addChild(starAnimateNode)
            end

        end
    end
    self.pageView:addEventListenerPageView(pageViewEvent)

    if self.chapterIdx == 1 then -- 如果为第一章的关卡，将右箭头去掉
        self.arrowRight:setVisible(false)
        self.arrowLeft:setVisible(false)
    end

end

--掉落关卡
function PVStageDetails:getStageId()
    local _modelIndex = self.pageView:getCurPageIndex()+1
    local _id = nil
    if _modelIndex == 1 then _id = self.simpleId
    elseif _modelIndex == 2 then _id = self.normalId
    elseif _modelIndex == 3 then _id = self.diffcultId
    end
    return _id
end

--创建掉落列表
function PVStageDetails:createDropList(id)

    -- 查stage_config的boss掉落, 小怪掉落
    local _bossDropId = self._stageTemp:getTemplateById(id).eliteDrop
    local _monsterDropId = self._stageTemp:getTemplateById(id).commonDrop
    local _bossBagIds = self._dropTemp:getBigBagById(_bossDropId).smallPacketId
    local _itemList = nil
    for i=1,#_bossBagIds do
        local _smallDropId = self._dropTemp:getBigBagById(_bossDropId).smallPacketId[i]
        if i == 1 then
            _itemList = self._dropTemp:getAllItemsByDropId(_smallDropId)
        else
            local _itemListTemp = self._dropTemp:getAllItemsByDropId(_smallDropId)
            for k,v in pairs(_itemList) do
                for _k,_v in pairs(_itemListTemp) do
                    if v.detailId == _v.detailId then
                        table.remove(_itemListTemp,_k)
                    end
                end
            end
            for k,v in pairs(_itemListTemp) do
                table.insert(_itemList, v)
            end
        end
    end
    
    local _monsterDropIds = self._dropTemp:getBigBagById(_monsterDropId).smallPacketId
    print("------#_monsterDropIds-------",#_monsterDropIds)
    for i=1,#_monsterDropIds do
        local _smallDropId2 = self._dropTemp:getBigBagById(_monsterDropId).smallPacketId[i]
        local _itemList2 = self._dropTemp:getAllItemsByDropId(_smallDropId2)
        -- for k,v in pairs(_itemList) do
        --     for _k,_v in pairs(_itemList2) do
        --         if v.detailId == _v.detailId then
        --             -- table.remove(_itemList2,_k)
        --         end
        --     end
        -- end
        -- 怪物掉落：只掉落一种
        for k,v in pairs(_itemList2) do
            table.insert(_itemList, v)
        end
    end
    
    -- print("++droplist++++++++++++++++++++")
    -- table.print(_itemList)
    -- print("++droplist++++++++++++++++++++")

    local function tableCellTouched( tbl, cell )
        print("drop cell touched ..", cell:getIdx())
        local v = _itemList[cell:getIdx()+1]    
        table.print(v)
        if v.type == 101 then -- 武将
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", v.detailId, 2, nil, 1)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v.detailId, 2, nil, 1)
        elseif v.type == 102 then -- 装备
            print("当前点击的装备的id ================ ", v.detailId)
            -- local equipment = getTemplateManager():getEquipTemplate():getTypeById(v.detailId)

            local equipment = getTemplateManager():getEquipTemplate():getTemplateById(v.detailId)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2)
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment, 2)
        elseif v.type == 103 then -- 武将碎片
            local nowPatchNum = self.c_SoldierData:getPatchNumById(v.detailId)
            getOtherModule():showOtherView("PVCommonChipDetail", 1, v.detailId, nowPatchNum)
        elseif v.type == 104 then -- 装备碎片
            local nowPatchNum = self.c_EquipmentData:getPatchNumById(v.detailId)
            getOtherModule():showOtherView("PVCommonChipDetail", 2, v.detailId, nowPatchNum)
        elseif v.type == 105 then  -- 道具
            getOtherModule():showOtherView("PVCommonDetail", 1, v.detailId, 1)
        end
    end
    local function numberOfCellsInTableView(tab)
        print("table.nums(_itemList) ============ ", table.nums(_itemList))
       return table.nums(_itemList)
    end
    local function cellSizeForTable(tbl, idx)
        return 110,110
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
        end

        cell:removeAllChildren()

        local v = _itemList[idx+1]

        local sprite = game.newSprite()
        if v.type < 100 then  -- 可直接读的资源图
            _temp = v.type
            local _icon = self._resourceTemp:getResourceById(_temp)
            setItemImage(sprite,"#".._icon,1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(v.detailId)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(v.detailId)
                changeNewIconImage(sprite,_temp,quality)
            elseif v.type == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(v.detailId)
                local quality = getTemplateManager():getEquipTemplate():getQuality(v.detailId)
                changeEquipIconImageBottom(sprite, _temp, quality)
            elseif v.type == 103 then -- hero chips
                _temp = self._chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self._chipTemp:getTemplateById(v.detailId).quality
                changeHeroChipIcon(sprite,_icon, _quality)
            elseif v.type == 104 then -- equipment chips
                _temp = self._chipTemp:getTemplateById(v.detailId).resId
                local _icon = self._resourceTemp:getResourceById(_temp)
                local _quality = self._chipTemp:getTemplateById(v.detailId).quality
                changeEquipChipIconImageBottom(sprite,_icon, _quality)
            elseif v.type == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(v.detailId)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(v.detailId)
                setItemImage3(sprite,_temp,quality)
            end
        end
        cell:addChild(sprite)
        sprite:setPosition(55, 55)
        sprite:setScale(0.85)
        -- if self._flag_showArrow == true then
        --     if self.fbDropTableView:getContentOffset().x >= self.fbDropTableView:maxContainerOffset().x then
        --         self.imgArrowLeft:setVisible(false)
        --         self.imgArrowRight:setVisible(true)
        --     elseif self.fbDropTableView:getContentOffset().x <= self.fbDropTableView:minContainerOffset().x then
        --         self.imgArrowRight:setVisible(false)
        --         self.imgArrowLeft:setVisible(true)
        --     end
        -- end

        return cell
    end

    local layerSize = self.layerItems:getContentSize()
    self.layerItems:removeAllChildren()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.dropTableView:setDelegate()
    self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layerItems:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    if table.nums(_itemList) > 4 then
    self._flag_showArrow = true
        self.menuLeft:setVisible(true)
        self.menuRight:setVisible(true)
    else
        self._flag_showArrow = false
        self.menuLeft:setVisible(false)
        self.menuRight:setVisible(false)
    end

    self.dropTableView:reloadData()
end

--更新扫荡是否可用
function PVStageDetails:updateSweepEnabled(id)
    local state = self._stageData:getStageState(id)
    if state == 1 then
        self:setSaoEnabled(true)
    else
        self:setSaoEnabled(false)
    end
end

--
function PVStageDetails:getFreeSweepTime()
    local maxTime = self.baseTemp:getFreeSweepTimes()
    local useTime = getDataManager():getStageData():getStageSweepTimes()
    print("getFreeSweepTime function  ---- max ", maxTime, "use :", useTime)
    if useTime <= maxTime then return maxTime - useTime
    else return 0 end
end

--使得扫荡不可以用
function PVStageDetails:setSaoEnabled(flag)
    -- local open = self.baseTemp:getSweepIsOpen()
    -- local openTen = self.baseTemp:getSweepTenIsOpen()
    -- print("setSaoEnabled--------", open, openTen, flag)
    -- if open == true then
        self.menuSaoOne:setEnabled(flag)
    -- else self.menuSaoOne:setEnabled(false)
    -- end
    -- if openTen == true then
        self.menuSaoTen:setEnabled(flag)
    -- else self.menuSaoTen:setEnabled(false)
    -- end
end


-- function function_name( ... )
--     -- body
-- end
--[[
function PVStageDetails:updateView()
     print("stagedetails onReloadView", getDataManager():getFightData():getIsWin())

    -- 更新模式数据
    self:initData()

    -- 更新界面
    self:updateViewData(self:getStageId())

    -- 判断战斗胜利： to do

    -- 如果胜利
    local isWin = getDataManager():getFightData():getIsWin()
    print("isWin", isWin)
    if isWin == true then
        local index = self.pageView:getCurPageIndex()+1
        getDataManager():getFightData():resetAllData()
        if self.starImgTable[index]:isVisible() ~= true then
            self.starImgTable[index]:setVisible(true)
            local node = UI_Jiandanguanka()
            node:setTag(50)
            self.animationNode:removeChildByTag(50)
            self.animationNode:addChild(node)
        end
        self:updateSweepEnabled(self:getStageId())
    end
end
]]
--从上界面返回时update
function PVStageDetails:onReloadView()
    print("stagedetails onReloadView", getDataManager():getFightData():getIsWin())


    print("PVStageDetails onReloadView", self.funcTable[1])
    if self.funcTable[1] == nil or self.funcTable[1] == 10 then
        return
    end
    if self.funcTable[1] == 1 then
        self:onHideView()
        return
    end
    local stageId = self:getStageId()

    if self.funcTable[1] == self.SAO_TYPE_ONE then  --扫荡一次返回
        --更新挑战次数
        local stageTempItem = self._stageTemp:getTemplateById(stageId)
        local _currFightNum = self._stageData:getStageFightNum(stageId)
        local _maxFightNum = stageTempItem.limitTimes
        if _currFightNum + 1 <= _maxFightNum then
            _currFightNum = _currFightNum + 1
            self._stageData:changeFightNum(stageId, _currFightNum)
        end
    elseif self.funcTable[1] == self.SAO_TYPE_TEN then
        local stageTempItem = self._stageTemp:getTemplateById(stageId)
        local _currFightNum = self._stageData:getStageFightNum(stageId)
        local _maxFightNum = stageTempItem.limitTimes
        if _currFightNum + 1 <= _maxFightNum then
            _currFightNum = _currFightNum + self.saoTimes
            self._stageData:changeFightNum(stageId, _currFightNum)
        end
    end
    -- 更新模式数据
    self:initData()


    -- 更新界面
    self:updateViewData(stageId)
    self:updateSweepEnabled(self.simpleId)
    -- 判断战斗胜利：

    -- 如果胜利
    local isWin = getDataManager():getFightData():getIsWin()
    if isWin == true then
        local index = self.pageView:getCurPageIndex()+1
        getDataManager():getFightData():resetAllData()
        if self.starImgTable[index]:isVisible() ~= true then
            self.starImgTable[index]:setVisible(true)
            local node = UI_Jiandanguanka()
            node:setTag(50)
            self.animationNode:removeChildByTag(50)
            self.animationNode:addChild(node)
        end
        self:updateSweepEnabled(self:getStageId())
    end
end

--重置关卡逻辑
function PVStageDetails:resetStageLogic()
    -- 判断元宝是否充足, 获取VIP等级, fb重置次数, 重置fb花费元宝数量
    local _id = self:getStageId()
    local _currentGold = self.commonData:getGold()
    local _viplevel = self.commonData:getVip()
    local _resetStageNum = self.baseTemp:getNumResetStageTimes(_viplevel)
    local _currentResetedStageNum = self._stageData:getResetedStageNum(_id)
    local _stageResetPrice = self.baseTemp:getPriceByResetStageNum(_currentResetedStageNum)
    print("拥有元宝数" .._currentGold .. "重置次数" .. _resetStageNum .. "当前重置次数" .. _currentResetedStageNum) --stageResetPrice
    local sure = function()
        getAudioManager():playEffectButton2()
        -- 确定
        if tonum(_currentGold) < tonum(_stageResetPrice) then
            --元宝不足
            -- self:toastShow(Localize.query("instance.13"))
            getOtherModule():showAlertDialog(nil, Localize.query("instance.13"))

        elseif _currentResetedStageNum >= _resetStageNum then
            --重置次数已用尽
            -- self:toastShow(Localize.query("instance.14"))
            getOtherModule():showAlertDialog(nil, Localize.query("instance.14"))
        else
            self._stageData:setCurrStageId( _id )
            self._instanceNet:sendResetStage(_id)
            print("-----重置关卡----" .. _id)
        end
    end
    local cancel = function()
        -- 取消
        getOtherModule():clear()
    end
    if _stageResetPrice == nil then _stageResetPrice = "" end
    getOtherModule():showConfirmDialog(sure, cancel, string.format(Localize.query("instance.12"),_stageResetPrice))
end

--@return
return PVStageDetails
