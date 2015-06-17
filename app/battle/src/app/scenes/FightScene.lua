
local FCMain = import("..fightview.controller.FCMain")
local FCProcess = import("..fightview.controller.FCProcess")

local FVMain = import("..fightview.execute.FVMain")

----------------------------------------------------------
local FVBackground = import("..fightview.view.background.FVBackground")
local FVLayerBullet = import("..fightview.view.bullet.FVLayerBullet")
local FVLayerDead = import("..fightview.view.carddead.FVLayerDead")
local FVLayerDeadS = import("..fightview.view.carddead.FVLayerDeadS")
local FVLayerFlash = import("..fightview.view.flash.FVLayerFlash")
local FVLayerShadow = import("..fightview.view.shadow.FVLayerShadow")
local FVCardLayer = import("..fightview.view.card.FVCardLayer")

----------------------------------------------------------
local FVLayerPrelude = import("..fightview.Prelude.FVLayerPrelude")
local FVLayerUI = import("..fightview.ui.FVLayerUI")
-- local FEControl = import("..fightview.execute.FEControl")

local FVParticleManager = import("..fightview.modeldata.FVParticleManager")
local FightUitl = import("..fightview.modeldata.FightUitl")

local FightScene = class("FightScene", function()
    return game.newScene("FightScene")
end)

function FightScene:ctor()
    print("FightScene:ctor-----")
    --动作控制器，用于播放场景动画
    self.fvActionSpec = getFVActionSpec()
    --粒子管理器
    g_FVParticleManager = FVParticleManager.new()
    self:addChild(g_FVParticleManager)
    --战斗工具类
    g_FightUitl = FightUitl.new()
    self:addChild(g_FightUitl)
    --模型层，战斗逻辑处理，由王振普完成，做成全局是因为在各层次均有直接调用，先初始化是因为控制层有调用
    g_FCProcess = FCProcess.new("FCProcess")  
    --控制层
    self.fcMain = FCMain.new()
  
    self.fcMain:addModel(g_FCProcess)
    --控制器，将功能移到FCMain
    -- self.FEControl = FEControl.new("FEControl")
    --显示层
    self.fvMain = FVMain.new("fvMain")
    self.fcMain:addView(self.fvMain)
    ---------------------适配层-------------------------------------
    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()
    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))
    ----------------------------------------------------------
    self.fvBackGround = FVBackground.new("fvBackGround")--背景
    -- self.fvLayerShadow = FVLayerShadow.new("fvLayerShadow")
    self.fvLayerDead = FVLayerDead.new("fvLayerDead")--死亡
    self.fvCardLayer = FVCardLayer.new("fvCardLayer")--卡牌层
    self.fvLayerDeadS = FVLayerDeadS.new("fvLayerDeadS")--死亡
    self.fvLayerPrelude = FVLayerPrelude.new("fvLayerPrelude")--进入场景动画
    self.fvLayerFlash = FVLayerFlash.new("fvLayerFlash")--刀光
    self.fvLayerBullet = FVLayerBullet.new("fvLayerBullet")--子弹
    self.fvLayerUI = FVLayerUI.new("fvLayerUI")--UI层    
    ----------------------------------------------------------    
    self.fvMain:addSubView(self.fvBackGround, -100)
    -- self.fvMain:addSubView(self.fvLayerShadow, -20)
    self.fvMain:addSubView(self.fvLayerDead, -10)
    self.fvMain:addSubView(self.fvCardLayer, 20)
    self.fvMain:addSubView(self.fvLayerDeadS, 45)
    self.fvMain:addSubView(self.fvLayerPrelude, 50)        
    self.fvMain:addSubView(self.fvLayerFlash, 60)
    self.fvMain:addSubView(self.fvLayerBullet, 70)

    -- self.fcMain:addView(self.FEControl)
    --将layerui层加入到fvMain外是因为适配问题
    self.fcMain:addView(self.fvLayerUI)
    --调用模型层，显示层中的onMvcEnter方法,初始化消息监听
    self.fcMain:doMVCEnter()
    --
    self.adapterLayer:addChild(self.fvMain)
    self:addRootChild(self.adapterLayer)
    --ui层显示在最上面
    self:addRootChild(self.fvLayerUI)
    -- self:addRootChild(self.FEControl)

    local layer = createBlockLayer()
    if layer then
        self:addRootChild(layer)
    end
    self.fcMain:initData()
    cclog("FightScene-------over----")
end

function FightScene:runSceneShake(frequency)
    local action_fight = self.fvActionSpec:makeActionShake_card(frequency)

    if action_fight then self:runAction(action_fight) end
end

function FightScene:runSceneAction()
    --self.adapterLayer:setScale(0.45)
    local scaleTo = cc.ScaleTo:create(1.09, 0.8)
    local easeOutScaleTo = cc.EaseOut:create(scaleTo, 1)
    local delayTime = cc.DelayTime:create(0.26)
    local scaleBack = cc.ScaleTo:create(0.02, 1)
    local sequenceAction = cc.Sequence:create(scaleTo, delayTime, scaleBack)
    -- BUG CHUANYUE-3350 QGW 背景黑框问题
    self.adapterLayer:runAction(delayTime)
end

function FightScene:runRepeatAction(dur)
    print("runRepeatAction==========")
    local action = self.fvActionSpec:makeShakeRepeatAction()
    action:setTag(100001)
    --makeShakeRepeatAction
    local delayTimeAction = cc.DelayTime:create(dur)
    local function callBack(sender)
    print("callBack==========")
        --sender:removeAction(100001, action)
        sender:stopActionByTag(100001)
    end

    local sequence2 = cc.Sequence:create(delayTimeAction, cc.CallFunc:create(callBack))
    self:runAction(action)
    self:runAction(sequence2)
end

function FightScene:onSceneExit()
    print("--FightScene:onSceneExit---")
    self.fcMain:doMVCExit()
    self.fcMain:removeAllModels()
    self.fcMain:removeAllViews()
    self.fcMain:removeCollect()

    --fightctrl
    self.fcMain = nil

    --fightmodel
    self.fightUtil = nil
    self.fvMain = nil
    self.fvBackGround = nil
    self.fvCardLayer = nil
    self.fvLayerDead = nil
    self.fvLayerDeadS = nil
    self.fvLayerShadow = nil
    self.fvLayerPrelude = nil

    g_FCProcess = nil
    g_FVParticleManager = nil
    g_FightUitl = nil
    print("--FightScene:onSceneExit---over")
end


return FightScene
