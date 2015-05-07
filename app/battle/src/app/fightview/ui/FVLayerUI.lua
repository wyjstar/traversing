
local FVLayerUI = class("FVLayerUI", mvc.ViewBase)

local FVFriend = import(".FVFriend")
local FVEntry = import(".FVEntry")
local FVUnpara = import(".FVUnpara")
local FVDrop = import(".FVDrop")
local ActionEditorLayer = import("...editor.ActionEditorLayer")
-- local FVFightWinUI = import(".FVFightWinUI")
-- local FVFightMineWinUI = import(".FVFightMineWinUI")
-- local FVFightFailUI = import(".FVFightFailUI")
-- local FVFightMineFailUI = import(".FVFightMineFailUI")

local FVFightResult = import(".FVFightResult") --战斗结果页

function FVLayerUI:ctor(id)
    FVLayerUI.super.ctor(self, id)
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.unparaConfig = self.c_BaseTemplate:getBaseInfoById("wushang_value_config")
    self.boddyConfig = self.c_BaseTemplate:getBaseInfoById("huoban_value_config")
    self.fvActionSpec = getFVActionSpec()
    self.process = getFCProcess()
    self.fightUitl = getFightUitl()

    self.isPausing = false --暂停标志位
    self.isBegining = false
    self.isKillOvered = false
    self.isBoddyFull = false
    self.unparaIcon = nil
    self.isClickUnpara = true
    self:init()
end

function FVLayerUI:onMVCEnter()
    getAudioManager():playFightBgMusic()
    --显示攻击效果
    self:listenEvent(const.EVENT_SHOW_COMBO, self.onPlayHitImpact, nil)
    self:listenEvent(const.EVENT_FIGHT_VICTORY, self.onFightOver, nil)
    self:listenEvent(const.EVENT_START_KO, self.onKillOverBegin, nil)
    --无双动画
    self:listenEvent(const.EVENT_START_UNPARA_ANI, self.startUnparaView, nil)
    --小伙伴动画
    self:listenEvent(const.EVENT_START_BODDY_ANI, self.loadFriendCCBI, nil)
    -- 更新小伙伴点击状态
    self:listenEvent(const.EVENT_BEGIN_STATE_CHANGE, self.startBeginStateChange, nil)
    --回合动画
    self:listenEvent(const.EVENT_PLAY_ROUND_ANI, self.startRoundView, nil)
    --创建无双
    self:listenEvent(const.EVENT_UPDATA_UNPARA_DATA, self.updateUnparaData, nil)
    self:listenEvent(const.EVENT_SOLDIER_ENTRY_ANI, self.startEntryAni, nil)
    --显示小伙伴
    self:listenEvent(const.EVENT_BUDDY_MAKE_BUDDY, self.updateBuddyData, nil)
    --无双释放完成
    self:listenEvent(const.EVENT_UNPATA_STOP, self.unparaStop, nil)
    --显示掉落
    self:listenEvent(const.EVENT_PLAY_DROPPING, self.playDropping, nil)
    --自动释放无双
    self:listenEvent(const.EVENT_UNPARA_BE_AUTO_EXE, self.unparaBeAutoExe, nil)
    --更新大回合显示
    self:listenEvent(const.EVENT_UPDATE_UI_ROUND, self.updateRoundUI, nil)
    --更新ui显示
    self:listenEvent(const.EVENT_UPDATE_UI_VIEW, self.updateView, nil)
    --更新小回合显示
    self:listenEvent(const.EVENT_UPDATE_UI_SROUND, self.updateSRoundUI, nil)
end

function FVLayerUI:updateBuddyData(friend)
    cclog("updateBuddyData==========")
    if not self.process.buddy_skill then return end
    self.boddySprite:setVisible(true)
    self.boddyMenu:setEnabled(true)
    self:updateBuddyView() 
end

function FVLayerUI:updateUnparaData()
    cclog("updateUnparaData===========")
    local unpara_skill = self.process:getRedUnparaSkill()
    if unpara_skill.unpara_info then
        self.unparaMenu:setEnabled(true)
        self.unparaSprite:setVisible(true)
        local instanceTemplate = getTemplateManager():getInstanceTemplate()

        local icon = unpara_skill.unpara_info.icon
        self.unparaIcon = icon
        self.resourceTemplate = getTemplateManager():getResourceTemplate()
        local res = self.resourceTemplate:getResourceById(icon)
        print("FVLayerUI:updateUnparaData===============>", res)
        self.unparaSprite:setTexture(res)
    end
    self.fvUnpara:initData()
end
--更改小伙伴是否可点击
function FVLayerUI:startBeginStateChange(state)
    cclog("FVLayerUI:startBeginStateChange=======")
    self.isBegining = state
    self:updateBoddySprite()
end


--初始化
function FVLayerUI:init()

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()
    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))
    self:addChild(self.adapterLayer)

    self.PVFightView = {}
    self.FightViewUI = {}
    
    self.UIAniFriendView = {}
    self.UIAniSoldierView = {}

    self:initTouchListener()

    self.fvFriend = FVFriend.new()
    self.fvFriend:setTarget(self)
    self.adapterLayer:addChild(self.fvFriend)

    self.fvEntry = FVEntry.new()
    self.fvEntry:setTarget(self)
    self.adapterLayer:addChild(self.fvEntry)

    self.fvUnpara = FVUnpara.new()
    self.fvUnpara:setTarget(self)
    self.adapterLayer:addChild(self.fvUnpara)
    print("Before:self:initView1")
    local proxy = cc.CCBProxy:create()
    self.fightUIView = CCBReaderLoad("fight/ui_fight_scene.ccbi", proxy, self.FightViewUI)
    print("Before:self:initView2")
    self:initCombo()
    if TEST_ISSHOW_EDIT then
        self.actionEditorLayer = ActionEditorLayer.new()
        self.adapterLayer:addChild(self.actionEditorLayer)
        self.actionEditorLayer:setVisible(false)
    end
    
    self.adapterLayer:addChild(self.fightUIView)
    --
    self.fvDrop = FVDrop.new()
    self.fvDrop:setTarget(self)
    self.adapterLayer:addChild(self.fvDrop)

    self:initView()
end

--初始化点击事件
function FVLayerUI:initTouchListener()
    --无双点击
    local function unparaClick()
        self:startUnpara()
    end

    --小伙伴点击
    local function buddyClick()
        --if self.isBegining then
        if true then
            self.process:doBuddySkill()
            if self.process.buddy_skill:is_ready() then
                local node = UI_Xiaohuobananniudianji()
                node:setTag(100002)
                self.animationNode:addChild(node)
                self.isBegining = false
                self:dispatchEvent(const.EVENT_BODDY_ROUND_START)             
            end
        end
    end

    local function editClick()
        if self.actionEditorLayer:isVisible() then
            self.actionEditorLayer:setVisible(false)
        else
            self.actionEditorLayer:setVisible(true)
        end
    end

    --暂停
    local function pauseClick()
        if self.isPausing then
            self.isPausing = false
        else
            self.isPausing = true
        end

        self:dispatchEvent(const.EVENT_PAUSE, self.isPausing)
    end

    local function exitClick()
        exitFightScene()
    end

    local function testClick2()
        --exitFightScene()
        self:dispatchEvent(const.EVENT_ON_test2click)
    end 

    local function quickSpeedClick()
        -- print("=================>SPEED:"..self.actionTimes)
        if self.actionTimes < MAX_ACTION_TIMES then
            self.actionTimes = self.actionTimes + 1
        else
            self.actionTimes = 1
        end
        ACTION_SPEED = NORMAL_ACTION_SPEED * self.actionTimes
        self.actionSpeed_label:setString(string.format("%d",self.actionTimes))
    end

    local function skipClick( )
        --跳过战斗
        local fightData =  getDataManager():getFightData()
        local fightType = getDataManager():getFightData():getFightType()
        if fightType == TYPE_STAGE_NORMAL then
            self:dispatchEvent(const.EVENT_BATTLE_RESULT, true)
        else
            if fightType == TYPE_WORLD_BOSS then -- or fightType == TYPE_PVP or TYPE_MINE_OTHERUSER
                if self.c_BaseTemplate:getVipBossFightSkip() == 1 then
                    self:dispatchEvent(const.EVENT_BATTLE_RESULT, fightData:getFightResult())
                else
                    getOtherModule():showToastView(string.format(Localize.query("stage.vipLevel.noEnough"), self.c_BaseTemplate:getBossFightSkipVipLevel()))
                end
            else
                if self.c_BaseTemplate:getVipFightSkip() == 1 then
                    self:dispatchEvent(const.EVENT_BATTLE_RESULT, fightData:getFightResult())
                else
                    getOtherModule():showToastView(string.format(Localize.query("stage.vipLevel.noEnough"), self.c_BaseTemplate:getFightSkipVipLevel()))
                end
            end 
        end
    end

    self.FightViewUI["FightViewUI"] = {}
    self.FightViewUI["FightViewUI"]["unparaClick"] = unparaClick
    self.FightViewUI["FightViewUI"]["buddyClick"] = buddyClick
    self.FightViewUI["FightViewUI"]["editClick"] = editClick
    self.FightViewUI["FightViewUI"]["pauseClick"] = pauseClick
    self.FightViewUI["FightViewUI"]["exitClick"] = exitClick
    self.FightViewUI["FightViewUI"]["testClick2"] = testClick2
    self.FightViewUI["FightViewUI"]["quickSpeedClick"] = quickSpeedClick
    self.FightViewUI["FightViewUI"]["skipClick"] = skipClick
end

--开始无双
function FVLayerUI:startUnpara()
    if self.isClickUnpara then
        self.process:doUnparaSkill()
        
        if self.process.red_unpara_skill:is_ready() then
            self.isClickUnpara=false
        end

        if self.process.red_unpara_skill:is_full() then
            local node = UI_Zhandouwushuanganniudianji()
            node:setTag(100001)
            self.animationNode:addChild(node)         
        end        
    end
end

--是否可以跳过战斗
function FVLayerUI:isFightSkip()
    
    local fightType = getDataManager():getFightData():getFightType()
    print("FVLayerUI:isFightSkip========>fightType:",fightType)
    if fightType == TYPE_WORLD_BOSS or fightType == TYPE_PVP or fightType == TYPE_MINE_OTHERUSER then  -- 差坏蛋反击
        return true
    elseif fightType == TYPE_STAGE_NORMAL then
        local fightStageId = getDataManager():getFightData():getFightingStageId()
        
        local startNum = getDataManager():getStageData():getStageState(fightStageId)
        print("=================>StageId",fightStageId,startNum)
        if startNum == 1 then --剧情关卡胜利过一次
            return true
        end
    end
    return false
end

function FVLayerUI:unparaBeAutoExe()
end

function FVLayerUI:initView()

    self.actionTimes = NORMAL_ACTION_TIME
    ACTION_SPEED = self.actionTimes * NORMAL_ACTION_SPEED --重新调整倍数

    self.actionSpeed_label = cc.LabelAtlas:_create(string.format("%d",self.actionTimes), "res/ui/ui_fight_speed_num.png", 22, 33, string.byte("0"))
    self.actionSpeed_label:setAnchorPoint({x = 0, y = 0.5})

    self.fightValue1 = self.FightViewUI["FightViewUI"]["fightValue1"]
    self.fightValue2 = self.FightViewUI["FightViewUI"]["fightValue2"]
    self.fightValue3 = self.FightViewUI["FightViewUI"]["fightValue3"]

    self.bloodValue1 = self.FightViewUI["FightViewUI"]["bloodValue1"]
    self.bloodValue2 = self.FightViewUI["FightViewUI"]["bloodValue2"]
    self.bloodValue3 = self.FightViewUI["FightViewUI"]["bloodValue3"]
    self.bloodValue4 = self.FightViewUI["FightViewUI"]["bloodValue4"]
    self.bloodValue5 = self.FightViewUI["FightViewUI"]["bloodValue5"]
    self.unparaMenu = self.FightViewUI["FightViewUI"]["unparaMenu"]
    self.unparaNode = self.FightViewUI["FightViewUI"]["unparaNode"]
    self.boddyNode = self.FightViewUI["FightViewUI"]["boddyNode"]
    self.bloodView = self.FightViewUI["FightViewUI"]["bloodView"]

    self.unparaMenu:setEnabled(false)
    self.unparaMenu:setAllowScale(false)

    self.unparaSprite = self.FightViewUI["FightViewUI"]["unparaSprite"]
    self.boddySprite = self.FightViewUI["FightViewUI"]["boddySprite"]
    self.bloodNode = self.FightViewUI["FightViewUI"]["bloodNode"]
    self.boddySprite:setVisible(false)

    self.unparaSprite:setVisible(false)
    self.pauseMenu = self.FightViewUI["FightViewUI"]["pauseMenu"]
    self.testMenu2 = self.FightViewUI["FightViewUI"]["testMenu2"]
    
    self.editMenu = self.FightViewUI["FightViewUI"]["editMenu"]
    self.exitMenu = self.FightViewUI["FightViewUI"]["exitMenu"]
    self.boddyMenu = self.FightViewUI["FightViewUI"]["boddyMenu"]
    self.boddyMenu:setEnabled(false)
    self.boddyMenu:setAllowScale(false)

    self.pauseMenu:setVisible(TEST)
    self.testMenu2:setVisible(TEST)
    self.exitMenu:setVisible(TEST)
    self.editMenu:setVisible(TEST)
    self.barNode = self.FightViewUI["FightViewUI"]["barNode"]
    self.animationNode = self.FightViewUI["FightViewUI"]["animationNode"]

    local sprite1 = game.newSprite("#ui_fight_wstiao_bg.png")
    local sprite2 = game.newSprite("#ui_fight_wstiao.png")
    local sprite3 = game.newSprite()

    self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setEnabled(false)
    self.slider:setMinimumValue(0)
    self.slider:setMaximumValue(100)
    self.slider:setValue(0)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.barNode:addChild(self.slider)

    self.skipMenu = self.FightViewUI["FightViewUI"]["skipMenu"]
    self.quickSpeedMenu = self.FightViewUI["FightViewUI"]["quickSpeedMenu"]

    self.quickSpeedNum = self.FightViewUI["FightViewUI"]["quickSpeedNum"]
    self.quickSpeedNum:addChild(self.actionSpeed_label)
    self.quickSpeedNode = self.FightViewUI["FightViewUI"]["quickSpeed"]

    if self.process.fight_type == TYPE_WORLD_BOSS then --非世界BOSS 不显示进度条 
        self.FightViewUI["FightViewUI"]["boss_progress"]:setVisible(true)
        self:addProgress()
    else
        self.FightViewUI["FightViewUI"]["boss_progress"]:setVisible(false)
    end
    local blSkip = self:isFightSkip()

    self.quickSpeedNode:setVisible(not blSkip)
    self.quickSpeedMenu:setVisible(not blSkip)
    self.quickSpeedMenu:setEnabled(not blSkip)
    self.skipMenu:setVisible(blSkip)
    self.skipMenu:setEnabled(blSkip)

end


function FVLayerUI:addProgress()
    self.progressSprite = self.FightViewUI["FightViewUI"]["progress_value"]
    self.progressSprite:setVisible(false)
    self.hurtPrgress = cc.ProgressTimer:create(self.progressSprite)
    self.hurtPrgress:setScaleY(1.6)
    self.hurtPrgress:setAnchorPoint(cc.p(0.5, 0))
    self.hurtPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.hurtPrgress:setBarChangeRate(cc.p(0, 1))
    self.hurtPrgress:setMidpoint(cc.p(0, 0))
    self.hurtPrgress:setLocalZOrder(0)
    self.hurtPrgress:setPosition(self.progressSprite:getPosition())
    self.progressSprite:getParent():addChild(self.hurtPrgress)

    local late =  getTemplateManager():getBaseTemplate():getBaseInfoById("worldbossAccumulatedReward")
    print("worldbossAccumulatedReward======>")
    self.maxValue = 0
    self.minValue = 1
    local n = 0
    for k,v in pairs(late) do 
        if self.maxValue < v[1] then
            self.maxValue = v[1]
        end
        if self.minValue > v[1] then
            self.minValue = v[1]
        end
        n = n + 1
    end
    self.boxArray = {}
    self.boss_hp = 10000000
    for k,v in pairs(late) do
        local proxy = cc.CCBProxy:create()
        local boxView = {}
        local boxNode = CCBReaderLoad("fight/ui_fight_progress_box.ccbi", proxy, boxView)
        boxNode.boxView = boxView
        boxNode.boxView["PROBOX"]["PROVALUE"]:setString(self.boss_hp * v[1])
        table.insert(self.boxArray,boxNode)
        boxNode.value = v[1]
        boxNode:setPosition(24,510 + (v[1]) / (self.maxValue) * 396)
        self.progressSprite:getParent():addChild(boxNode)
    end
    self:updatehurtProgressTest()
end

function FVLayerUI:updateHurtProgress()
    local per = self.hurtPrgress:getPercentage() + 2
    self.hurtPrgress:setPercentage(per)


    local perValue = per / 100

    if per >= 80 then
        timer.unscheduleGlobal(self.updateHandler)
    end

    for _,v in pairs(self.boxArray) do
        if not v.valuetrue and v.value / self.maxValue <= perValue then
            v.boxView["PROBOX"]["PROVALUE"]:setString(Localize.query("fight.1"))
            v.boxView["PROBOX"]["PROVALUE"]:setColor(ui.COLOR_YELLOW )
        end
    end
end

function FVLayerUI:updatehurtProgressTest()
    self.updateHandler = timer.scheduleGlobal(function ()
        self:updateHurtProgress()
    end,1)
end

function FVLayerUI:unparaStop()
    cclog("FVLayerUI:unparaStop================================>")
    self:stopActionByTag(1050)
    self.isClickUnpara = true    
end

function FVLayerUI:playDropping(point)
    self.fvDrop:playDropping(point)
end

function FVLayerUI:playDroppingOver()
    self.fightValue1:setString(tostring(self.process:getHadDropNum()))
end

function FVLayerUI:updateRoundUI()
    local currentRound = self.process:getCurrentRound()
    local roundMax = self.process:getMaxRound()
    self.fightValue3:setString(tostring(currentRound) .. "/" .. tostring(roundMax))
end

function FVLayerUI:updateSRoundUI()
    local totleSRound = self.process:getCurrentFightTimes()
    local max_times_fight = self.process:getFightTimesMax()
    self.fightValue2:setString(tostring(totleSRound) .. "/" .. tostring(max_times_fight))
end

function FVLayerUI:updateUnparaView()
    if self.unparaIcon == nil then
        return
    end
    local unparaValue = self.process:get_red_unpara_value()
    local _unparaLv = self.process.red_unpara_skill.level

    local Value3 = self.unparaConfig[3]
    local Value4 = self.unparaConfig[4]
    local Value5 = self.unparaConfig[5]
    print("updateUnparaView--------------------------", unparaValue, Value5)
    local per1 = 9.5 / (9.5 + 9.5 + 8)
    local per2 = 17.5 / (9.5 + 9.5 + 8)
    local per3 = 1
    local value = 0
    local unparaType = 0


    if _unparaLv == 1 and unparaValue > Value3 then
        unparaValue = Value3
    elseif _unparaLv == 2 and unparaValue > Value4 then
        unparaValue = Value4
    elseif _unparaLv == 3 and unparaValue > Value5 then
        unparaValue = Value5
    end

    if unparaValue > Value4 then
        unparaType = 3
        value = unparaValue * 100 / Value5
    elseif unparaValue > Value3 then
        unparaType = 2
        value = unparaValue * 100 * per2/ Value4
    else
        unparaType = 1
        value = unparaValue * 100 * per1 / Value3
    end

    -- local value = unparaValue * 100 / Value5
    print("value=====" , value, unparaType)
    self.slider:setValue(value)

    if unparaValue >= Value5 then
        local node5 = self.unparaNode:getChildByTag(1005)
        if node5 == nil then
            local node5 = UI_Zhandouwushuangsanji()
            self.unparaNode:addChild(node5)
            node5:setTag(1005)

            local node55 = getUnparaNode(self.unparaIcon)
            self.unparaNode:addChild(node55)
            node55:setTag(2005)
        end

    elseif unparaValue >= Value4 then
        local node4 = self.unparaNode:getChildByTag(1004)
        if node4 == nil then
            node4 = UI_Zhandouwushuangerji()
            self.unparaNode:addChild(node4)
            node4:setTag(1004)

            local node44 = getUnparaNode(self.unparaIcon)
            self.unparaNode:addChild(node44)
            node44:setTag(2004)
        end
        local node5 = self:getChildByTag(1005)
        if node5 then
            node5:removeFromParent(true)
        end

        local node55 = self:getChildByTag(2005)
        if node55 then
            node55:removeFromParent(true)
        end
    elseif unparaValue >= Value3 then
        local node3 = self.unparaNode:getChildByTag(1003)
        if node3 == nil then
            node3 = UI_Zhandouwushuangyiji()
            self.unparaNode:addChild(node3)
            node3:setTag(1003)

            local node33 = getUnparaNode(self.unparaIcon)
            self.unparaNode:addChild(node33)
            node33:setTag(2003)
        end
        local node5 = self:getChildByTag(1005)
        if node5 then
            node5:removeFromParent(true)
        end

        local node55 = self:getChildByTag(2005)
        if node55 then
            node55:removeFromParent(true)
        end

        local node4 = self:getChildByTag(1004)
        if node4 then
            node4:removeFromParent(true)
        end

        local node44 = self:getChildByTag(2004)
        if node44 then
            node44:removeFromParent(true)
        end
    else
        self.unparaNode:removeAllChildren()
    end
end

function FVLayerUI:updateBuddyView()

    local baseValue = self.boddyConfig[3]
    local baseItem = baseValue / 5
    local boddyValue = self.process:getBuddyValue()
    if boddyValue >= baseItem * 1 then
        self.bloodValue1:setVisible(true)
        local action = self.fvActionSpec:makeBloodAction()
        self.bloodValue1:runAction(action)
    else
        self.bloodValue1:setVisible(false)
    end

    if boddyValue >= baseItem * 2 then
        self.bloodValue2:setVisible(true)
        local action = self.fvActionSpec:makeBloodAction()
        self.bloodValue2:runAction(action)
    else
        self.bloodValue2:setVisible(false)
    end

    if boddyValue >= baseItem * 3 then
        self.bloodValue3:setVisible(true)
        local action = self.fvActionSpec:makeBloodAction()
        self.bloodValue3:runAction(action)
    else
        self.bloodValue3:setVisible(false)
    end

    if boddyValue >= baseItem * 4 then
        self.bloodValue4:setVisible(true)
        local action = self.fvActionSpec:makeBloodAction()
        self.bloodValue4:runAction(action)
    else
        self.bloodValue4:setVisible(false)
    end

    if boddyValue >= baseItem * 5 then
        self.bloodValue5:setVisible(true)
        local action = self.fvActionSpec:makeBloodAction()
        self.bloodValue5:runAction(action)
        self:boddyFull()
    else
        self.bloodValue5:setVisible(false)
        self.isBoddyFull = false
    end

    cclog("----FVLayerUI:updateBuddyView------")
    
    self:updateBoddySprite()
end

function FVLayerUI:updateBoddySprite()
    local baseValue = self.boddyConfig[3]
    local isFull = false
    local boddyValue = self.process:getBuddyValue()
    if boddyValue >= baseValue then
        isFull = true
    end
    local name = nil
    if isFull then
        if self.isBegining then
            name = "#ui_fight_boddy_icon1.png"
        else
            name = "#ui_fight_boddy_icon3.png"
        end
    else
        name = "#ui_fight_boddy_icon4.png"
        self:stopActionByTag(1000)
        self.boddyNode:removeAllChildren()
    end
    self.boddySprite:setVisible(true)
    game.setSpriteFrame(self.boddySprite, name)
end

function FVLayerUI:boddyFull()
    if self.isBoddyFull then
        return
    end
    self.isBoddyFull = true
    local node = UI_Xiaohuobananniu()
    self.boddyNode:addChild(node)

    local delayAction = cc.DelayTime:create(0.5)

    local function callBack()
        local node = UI_Xiaohuobantaoxin()
        self.boddyNode:addChild(node)
    end

    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(callBack))
    local action = cc.RepeatForever:create(sequenceAction)
    action:setTag(1000)
    self:runAction(action)
end

--界面更新
function FVLayerUI:updateView()
    self:updateUnparaView()
    self:updateBuddyView()
    self:updateRoundUI()
    self:updateSRoundUI()
end

function FVLayerUI:initCombo()
    self.comboNode = self.FightViewUI["FightViewUI"]["comboNode"]
    self.comboBg = self.FightViewUI["FightViewUI"]["comboBg"]
    self.cpmboDoubleHit = self.FightViewUI["FightViewUI"]["cpmboDoubleHit"]
    self.comboLabelNode = self.FightViewUI["FightViewUI"]["comboLabelNode"]

    self.comboBg:setScale(0.2)
    self.cpmboDoubleHit:setScale(0.2)
    self.comboLabelNode:setScale(0.2)

    --self.comboNode:setRotation(-10)

    self.combo_num_old = cc.LabelAtlas:_create("", "res/ui/ui_combo.png", 52, 70, string.byte("0"))
    self.combo_num_new = cc.LabelAtlas:_create("", "res/ui/ui_combo.png", 52, 70, string.byte("0"))
    self.combo_num_old:setAnchorPoint({x = 0.5, y = 0.5})
    self.combo_num_new:setAnchorPoint({x = 0.5, y = 0.5})


    self.comboLabelNode:addChild(self.combo_num_old)
    self.comboLabelNode:addChild(self.combo_num_new)


    self.comboNode:setVisible(false)
    self.comboLabelNode:setVisible(false)
end

-- 连击
function FVLayerUI:playComboAll(combo)
    print("FVLayerUI:playComboAll============>",combo)
    if combo == 0 then return end
    self:updateBloodShow(combo)
    if self.comboNode:isVisible() then
        self.comboBg:stopAllActions()
        self.cpmboDoubleHit:stopAllActions()
        self.comboLabelNode:stopAllActions()
    end
    self.comboLabelNode:setVisible(true)
    self.comboNode:setVisible(true)

    self.combo_num_new:setString(tostring(combo))

    local scale = 0.6 + (combo - 1 ) * 0.1
    if scale > 1 then
        scale = 1
    end

    local scaleAction1 = cc.ScaleTo:create(0.06, scale * 1.5)
    local scaleAction2 = cc.ScaleTo:create(0.03, scale)
    local delayTime = cc.DelayTime:create(1.0)
    local delayTime2 = cc.DelayTime:create(0.05)

    local function callBack()
        local fadeTo = cc.FadeTo:create(0.05, 0)
        self.comboBg:runAction(fadeTo:clone())
        self.cpmboDoubleHit:runAction(fadeTo:clone())
        self.combo_num_new:runAction(fadeTo:clone())
    end

    local function callBack2()
        local fadeTo = cc.FadeTo:create(0, 255)
        self.comboBg:runAction(fadeTo:clone())
        self.cpmboDoubleHit:runAction(fadeTo:clone())
        self.combo_num_new:runAction(fadeTo:clone())
        self.comboNode:setVisible(false)
    end

    local sequenceAction1 = cc.Sequence:create(scaleAction1, scaleAction2, delayTime, cc.CallFunc:create(callBack),
        delayTime2, cc.CallFunc:create(callBack2))
    self.comboLabelNode:runAction(sequenceAction1)

    local scale2 = 0.6 + (combo - 1 ) * 0.04
    local scaleAction7 = cc.ScaleTo:create(0.03, scale2 * 0.8)
    local scaleAction3 = cc.ScaleTo:create(0.06, scale2 * 1.65)
    local scaleAction4 = cc.ScaleTo:create(0.03, scale2)
    local sequenceAction2 = cc.Sequence:create(scaleAction7, scaleAction3, scaleAction4)
    self.comboBg:runAction(sequenceAction2)

    local scale3 = 0.6 + (combo - 1 ) * 0.02
    local scaleAction5 = cc.ScaleTo:create(0.06, scale3 * 1.2)
    local scaleAction6 = cc.ScaleTo:create(0.03, scale3)
    local sequenceAction3 = cc.Sequence:create(scaleAction5, scaleAction6)
    self.cpmboDoubleHit:runAction(sequenceAction3)
end

function FVLayerUI:updateBloodShow(combo)
    if combo == 3 then  
        local node = self.fightUitl:createBloodView(1)
        self.bloodNode:addChild(node)
    elseif combo == 4 then
        local node = self.fightUitl:createBloodView(2)
        self.bloodNode:addChild(node)
    elseif combo == 5 then
        local node = self.fightUitl:createBloodView(3)
        self.bloodNode:addChild(node)
    elseif combo == 6 then
        local node = self.fightUitl:createBloodView(4)
        self.bloodNode:addChild(node)
    end
end

--初始化killover
function FVLayerUI:initKillOver()
    if self.killover == nil then
        self.killover = game.newSprite()
        self.killover_bg = mvc.ViewSprite("#ui_kill_bg.png")
        self.killover_k = mvc.ViewSprite("#ui_kill_zhan.png")
        self.killover_o = mvc.ViewSprite("#ui_kill_sha.png")
        self.killover:addChild(self.killover_k)
        self.killover:addChild(self.killover_o)

        self.killover:setVisible(false)

        self.adapterLayer:addChild(self.killover)
    end
end

function FVLayerUI:onKillOverBegin(seat)
    self:initKillOver()
    if self.isKillOvered == false then
        self.isKillOvered = true

        --self.killover_bg:setPosition(320, 480)
        self.killover_k:setPosition(-100, 1200)
        self.killover_o:setPosition(740, 1200)

        --self.killover_bg:setScale(0)
        self.killover_k:setScale(5)
        self.killover_o:setScale(5)
        self.killover:setVisible(true)
       cclog("CONFIG_KO_SLOW=======" .. CONFIG_KO_SLOW)
        
        local speed = 1
        self.killover_k:runAction(cc.Sequence:create({
            --cc.DelayTime:create(0.05 * CONFIG_KO_SLOW),
            cc.EaseSineOut:create(cc.Spawn:create({
                cc.MoveTo:create(0.1 / speed, cc.p(233, 486)),
                cc.ScaleTo:create(0.1 / speed, 0.97),
                })),
            cc.EaseSineOut:create(cc.Spawn:create({
                cc.MoveTo:create(0.03 / speed, cc.p(233, 480)),
                cc.ScaleTo:create(0.03 / speed, 1),
                })),
            }))

        self.killover_o:runAction(cc.Sequence:create({
            --cc.DelayTime:create(0.25 * CONFIG_KO_SLOW),
            cc.EaseSineOut:create(cc.Spawn:create({
                cc.MoveTo:create(0.1 / speed, cc.p(414, 536)),
                cc.ScaleTo:create(0.1 / speed, 0.97),
                })),
            cc.EaseSineOut:create(cc.Spawn:create({
                cc.MoveTo:create(0.03 / speed, cc.p(414, 536)),
                cc.ScaleTo:create(0.03 / speed, 1),
                })),
            }))

        timer.delayGlobal(function()
            self.killover:setVisible(false)
        end, 2)
    end
end

function FVLayerUI:onFightOver()
    local stageId =  getDataManager():getFightData():getFightingStageId()
    local iswin = getDataManager():getFightData():getIsWin()
    cclog("fight over, isWin ? ", iswin)
    getNetManager():getInstanceNet():sendSettlement(stageId, iswin)
end

--显示战斗胜利界面
function FVLayerUI:showFightVictory()
    -- local node = nil
    local _type = getDataManager():getFightData():getFightType()
    self:showFightReuslt(_type,1)
    -- cclog("FVLayerUI:showFightVictory============>")

    -- if _type == TYPE_MINE_MONSTER or _type == TYPE_MINE_OTHERUSER then --秘境 单独处理
    --     node = FVFightMineWinUI.new()
    -- else
    --     node = FVFightWinUI.new()
    -- end

    -- self.adapterLayer:addChild(node, 100)


end

--显示战斗失败结算页面
function FVLayerUI:showFightDefeat()

    -- local node = nil
    local _type = getDataManager():getFightData():getFightType()
    -- if _type == TYPE_MINE_MONSTER or _type == TYPE_MINE_OTHERUSER then --秘境 单独处理
    --     node = FVFightMineFailUI.new()
    -- else
    --     node = FVFightFailUI.new()
    -- end

    -- self.adapterLayer:addChild(node, 100)
    self:showFightReuslt(_type,0)
end

--显示战斗结果页面
--result 1是win 0是fail
function FVLayerUI:showFightReuslt(fightType,result,...)
    local node = FVFightResult.new()

    node:initViewData(fightType , result)

    self.adapterLayer:addChild(node , 100)
end

function FVLayerUI:startUnparaView(attacker)
    local node = self.animationNode:getChildByTag(100001)
    if node then
        node:removeFromParent(true)
    end

    if attacker.side ~= "blue" then
        local node = UI_Zhandouwushuanganniuchufa()
        self.animationNode:addChild(node)
    end

    self.fvUnpara:startUnparaView(attacker)
    self:loadBloodView()
end

function FVLayerUI:onUnparaAniOver()
    print("[Q]FVLayerUI:onUnparaAniOver()")
    self:dispatchEvent(const.EVENT_UNPARALLELED_ROUND_BEGIN)  
end

function FVLayerUI:onPlayHitImpact(combo)
    if combo and combo ~= 0 then
        self:playComboAll(combo)
    end
end

function FVLayerUI:loadBloodView()
    local delayAction = cc.DelayTime:create(0.5)

    local function callBack()
        local rate = math.random(1, 4)
        local node = self.fightUitl:createBloodView(rate)
        self.bloodNode:addChild(node)
    end

    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(callBack))
    local action = cc.RepeatForever:create(sequenceAction)
    action:setTag(1050)
    self:runAction(action)
end

--小伙伴页面
function FVLayerUI:loadFriendCCBI()
    local node = self.animationNode:getChildByTag(100002)
    if node then
        node:removeFromParent(true)
    end
    self.fvFriend:loadFriendCCBI()
end

function FVLayerUI:onFriendAniOver()
    self:dispatchEvent(const.EVENT_BUDDY_ATTACK)
end

--猛将来袭页面
function FVLayerUI:loadSoldierCCBI()
    local proxy = cc.CCBProxy:create()
    self.soldierView = CCBReaderLoad("effect/ui_soldier_effect.ccbi", proxy, self.UIAniSoldierView)
    self.soldierView:setVisible(true)

    self.shieldlayer = game.createShieldLayer()
    self.soldierView:addChild(self.shieldlayer)
    self.shieldlayer:setTouchEnabled(true)
    self.adapterLayer:addChild(self.soldierView)

    local hideAction = cc.Sequence:create({
    cc.DelayTime:create(2),
    cc.CallFunc:create(function () self.shieldlayer:setTouchEnabled(false)  self.soldierView:removeFromParent() end
    ), nil})

    --猛将来袭动画结束之后，在callFunc里面回调释放技能
    self:runAction(hideAction)
end

function FVLayerUI:startRoundView(roundValue, isBoss)
   cclog("startRoundView=======roundValue===" .. roundValue)
    local proxy = cc.CCBProxy:create()
    self.UIAniRoundView = {}
    self.roundView = CCBReaderLoad("effect/ui_round.ccbi", proxy, self.UIAniRoundView)
    self.roundNum = self.UIAniRoundView["UIAniRoundView"]["roundNum"]
    local frame = nil
    if roundValue == 1 then
        frame = "#ui_round_1.png"
    elseif roundValue == 2 then
        frame = "#ui_round_2.png"
    elseif roundValue == 3 then
        frame = "#ui_round_3.png"
    end

    game.setSpriteFrame(self.roundNum, frame)
    self.adapterLayer:addChild(self.roundView)
    local function removeCallBack()
        if self.roundView ~= nil then 
            self.roundView:removeFromParent(true)
            self.roundView = nil
        end
    end

    local delayAction = cc.DelayTime:create(1.23)
    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(removeCallBack))

    self:runAction(sequenceAction)
end

function FVLayerUI:startEntryAni(hero)
    self.fvEntry:startEntryAni(hero)
end

function FVLayerUI:onEntryAniOver(hero)
    self:dispatchEvent(const.EVENT_ATTACK_ITEM_STOP, hero.viewPos)
end

return FVLayerUI
