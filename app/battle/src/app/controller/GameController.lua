--游戏控制类

--local MenuScene = import("..scenes.MenuScene")
local PlayerScene = import("..scenes.PlayerScene")


local DataProcessor = import("..netcenter.DataProcessor")

local DataManager = import("..datacenter.bean.DataManager")
local AudioManager = import("..datacenter.bean.AudioManager")
-- local NetManage = import("..netcenter.NetManage")
local TemplateManager = import("..datacenter.template.TemplateManager")
local CalculationManager = import("..datacenter.calculation.CalculationManager")
local OtherModule = import("..procedure.OtherModule.OtherModule")
--local PlatformLuaManager = import("..platform.PlatformLuaManager")
local PVAttributes = import("..ui.home.PVAttributes")
import("..Constants")
-- import("..util.Util")

local NewGManager = import("..newbieguide.NewGManager")
local StoryDialogManager = import("..newbieguide.StoryDialogManager")
--local LevelUpOpen = import("..newbieguide.LevelUpOpen")
local StagePassOpen = import("..newbieguide.StagePassOpen")
local PVFinashView = import("..newbieguide.PVFinashView")
local CorpsUpgrade = import("..commview.CorpsUpgrade")
-- local DataBaseHelper = import("..database.DataBaseHelper")


require("src.app.util.XParticleDefine")
require("src.app.util.XParticleDefine2")
require("src.app.util.XParticleAnimation")
require("src.app.fightview.controller.FCFightController")

local FightScene = import("..scenes.FightScene")

g_loadLazy = true
g_schedulerLoadResource = 0

g_isLoadResource = true

function autoLoadResource()
    coroutine.resume(g_coroutineLoadResource)
    if coroutine.status(g_coroutineLoadResource) == "dead" then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(g_schedulerLoadResource)
        g_coroutineLoadResource = nil
    end
end

-- 初始化加载资源
function initLoadRes()

    return getDataManager():getResourceData():loadResourceData()
end

-- 初始化网络
function initConnectNet()
    getNetManager():connectNet()
end

-- 关闭网络
function closeConnectNet()
    getNetManager():closeConnect()
end

function enterMenuScene()
    -- game.popScene()

    -- local scene = game.getRunningScene()
    if s_player_scene ~= nil then
        s_player_scene:onExit()
    end

    clear()

    clearUIResource()

    cc.Director:getInstance():popToRootScene()

    local MenuScene = require("src.app.scenes.MenuScene")
    game.replaceScene(MenuScene.new())


end

-- 退出
function logout()

    getNetManager():loginout()
    clear()
    clearGlobalObject()
end

function clear()

    s_player_scene = nil
    g_FightScene = nil
    ISPAUSEING = false
    g_homeBasicView = nil
    g_NewGManager = nil
    g_CorpsUpgrade = nil
    g_DataProcessor = nil

    OtherModule:clear()
    getNetManager():clear()
    getCalculationManager():clear()
    getTempFightData():clearData()
    -- fightClear()

    if g_StoryDialogManager then
        -- g_StoryDialogManager:clearView()
        g_StoryDialogManager = nil
    end

end

----启动初始化
function initialize()
    print("initialize()")
    -- getDataManager():getResourceData():loadResourceData()
    -- getNetManager():connectNet()
    enterPlayerScene()

    getNetManager():sendPreLoadNet()

end

function getStoryDialogManager()
    if g_StoryDialogManager == nil then
        g_StoryDialogManager = StoryDialogManager.new()
    end

    return g_StoryDialogManager
end

s_player_scene = nil
function getPlayerScene()
    if s_player_scene == nil then
        s_player_scene = PlayerScene.new()
    end

    return s_player_scene
end

--静态数据管理中心
function getTemplateManager()
    if g_TemplateManager == nil then
        g_TemplateManager = TemplateManager.new()
    end
    return g_TemplateManager
end

--数据中心
function getDataManager()
    if g_DataManager == nil then
        g_DataManager = DataManager.new()
    end
    return g_DataManager
end

--音效管理中心
function getAudioManager()
    if g_AudioManager == nil then
        g_AudioManager = AudioManager.new()
    end

    return g_AudioManager
end

--网络中心
function getNetManager()
    -- if g_NetManager == nil then
    --     g_NetManager = NetManage.new()
    -- end
    return g_NetManager
end

-- function getDataBaseHelper()
--     if g_DataBaseHelper == nil then
--         g_DataBaseHelper = DataBaseHelper.new()
--     end

--     return g_DataBaseHelper
-- end

--新手引导
function getNewGManager()
    if g_NewGManager == nil then
        g_NewGManager = NewGManager.new()
    end

    return g_NewGManager
end

--等级奖励

--[[function getLevelUpOpen()
    if g_LevelUpOpen == nil then
        g_LevelUpOpen = LevelUpOpen.new()
    end

    return g_LevelUpOpen
end]]--

--关卡开启功能奖励
function getStagePassOpen()
    if g_StagePassOpen == nil then
        g_StagePassOpen = StagePassOpen.new()
    end

    return g_StagePassOpen
end

--战队升级
function getCorpsUpgrade()
    if g_CorpsUpgrade == nil then
        g_CorpsUpgrade = CorpsUpgrade.new()
    end
    return g_CorpsUpgrade
end

--PVFinashView
function getPVFinashView()
    if g_PVFinashView == nil then
        g_PVFinashView = PVFinashView.new()
    end
    return g_PVFinashView
end

--计算中心
function getCalculationManager()
    if g_CalculationManager == nil then
        g_CalculationManager = CalculationManager.new()
    end
    return g_CalculationManager
end

--网络返回数据处理器
function getDataProcessor()
    if g_DataProcessor == nil then
        g_DataProcessor = DataProcessor.new()
    end
    return g_DataProcessor
end

--平台管理
function getPlatformLuaManager()
    if g_PlatformLuaManager == nil then
        g_PlatformLuaManager = PlatformLuaManager.new()
    end

    return g_PlatformLuaManager
end

--otherModule
function getOtherModule()
    if g_OtherModule == nil then
        g_OtherModule = OtherModule.new()
    end
    return g_OtherModule
end

function enterFightScene()
    clearUIResource()

    local scene = getFightScene()
    game.pushScene(scene)

    -- clearUIResource()
end

function newEnterFightScene()
    clearUIResource()
    getDataManager():getResourceData():clearResourcePlistTexture2()

    getNewGManager():clearView()

    local scene = getFightScene()
    game.replaceScene(scene)

    -- clearUIResource()
end

--根据战斗类型和战斗Type
function enterFightByStageIdAndType(stageId,type)

    local _data = {}
    local _hasHero = false
    local lineup = {}  -- for fightData
    _data.stage_id = stageId
    _data.stage_type = type
    _data.lineup = {}

    local lineUpList = getDataManager():getLineupData():getSelectSoldier()
    local embattleOrder = getDataManager():getLineupData():getEmbattleOrder()

    for k,v in pairs(lineUpList) do
        _data.lineup[v.slot_no] = embattleOrder[k]
        if v.hero.hero_no ~= 0 then _hasHero = true end
    end

    _data.unparalleled = getDataManager():getFightData():getData().hero_unpar --:getUnparalleled()
    if getDataManager():getFightData():getData().friend ~= nil then
        _data.fid =  getDataManager():getFightData():getData().friend.no
    end

    if _hasHero == true then

        timer.delayGlobal(function ()
            print("continue Battle===========>")
            table.print(_data)
            getNetManager():getInstanceNet():sendStartFight(_data)
        end,0.2)

        exitFightScene()
        
    end
end

function getFightScene()
    if g_FightScene == nil then
        print("getFightScene-------------")
        g_FightScene = FightScene.new()
    end

    return g_FightScene
end

function newExitFightScene()
    getTempFightData():clearData()
    getActionUtil():clearData()
    g_FightScene = nil
    enterPlayerScene()
end

function exitFightScene(...)
    game.popScene()
    getTempFightData():clearData()
    getActionUtil():clearData()
    g_FightScene = nil

    clearUIResource()

    getAudioManager():playBgMusic()
    getPlayerScene().firstEnter=false

    -- 打开此参数用于符文秘境
    print("exitFightScene firstEnter ", getPlayerScene().firstEnter)
    -- -- 刷新下一个界面
    local transTable = ...
    -- print("------刷新下一个界面=======")
    -- print(transTable)

    -- __refreshCurrentView = nil

    local ___refreshCurrent = function()

        timer.unscheduleGlobal(___refreshCurrentView)

        -- local gId = getNewGManager():getCurrentGid()
        -- if gId == G_RECEIVE_HERO then
            -- getNewGManager():checkGuide()
        -- end

        getPlayerScene():updateCurrentView(transTable)
        ___refreshCurrentView = nil
        -- stepGuideNext()

    end
    ___refreshCurrentView = timer.scheduleGlobal(___refreshCurrent, 0.1)

end

function enterPlayerScene()

    clearUIResource()

    local playerScene = getPlayerScene()

    --加载home
    playerScene:onEnter()
    game.replaceScene(playerScene)
    playerScene.firstEnter=true
    showModuleView(MODULE_NAME_HOMEPAGE)

    -- 清除资源
    clearUIResource()

    print("enterPlayerScene firstEnter ", playerScene.firstEnter)
    -- local __refreshCurrent = function()

    -- timer.unscheduleGlobal(_checkGuide)
    --     -- stepGuideNext()
    -- getNewGManager():checkGuide()
    -- print("checkGuide")

    -- end
    -- _checkGuide = timer.scheduleGlobal(__refreshCurrent, 0.01)
end

--根据module的name获取module的实例
function getModule(_moduleName)
    local playerScene = getPlayerScene()
    return playerScene:getModule(_moduleName)
end

function showModuleView(_moduleName)
    local playerScene = getPlayerScene()
    playerScene:showModuleView(_moduleName)
end


--获取与创建主界面的玩家属性栏-singleton
function getHomeBasicAttrView()
    if g_homeBasicView == nil then
        g_homeBasicView = PVAttributes.new()
    end
    return g_homeBasicView
end

--创建基础属性战斗力view
function createBasicAttributeView()
    local PVAttributes = PVAttributes.new()
    return PVAttributes
end

function onNetMsgUpdate(id, data)
    getPlayerScene():onNetMsgUpdateUI(id, data)
end

-- 清除全局对象
function clearGlobalObject()
    g_homeBasicView = nil

end

function stepCallBack(step)
    if ISSHOW_GUIDE then
        getNewGManager():startGuideForGuideId(step)
    end
end

function groupCallBack(step, params)
    if ISSHOW_GUIDE then
        getNewGManager():startGuideForGroupId(step, params)
    end
end

function clearUIResource()
    getDataManager():getResourceData():clearResourcePlistTexture()
end

function touchNotice(noticeId, state)
    local scene = game.getRunningScene()
    if scene.notice then
        scene:notice(noticeId, state)
    end
    --getPlayerScene():notice(noticeId, state)
end

function getHomePageView()
    return getPlayerScene().homeModuleView.moduleView
end






