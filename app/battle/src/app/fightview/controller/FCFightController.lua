
local FMTempFightData = import("src.app.fightview.modeldata.FMTempFightData")
-- local FMProcess = import("src.app.fightview.modeldata.FMProcess")
--local FCProcess = import("..FCProcess")
local ActionUtil = import("src.app.fightview.controller.ActionUtil")

local FVAction = import("src.app.fightview.modeldata.FVAction")

local FVActionSpec = import("src.app.fightview.modeldata.FVActionSpec")

require("src.app.fightview.modeldata.XFightParticle")
require("src.app.fightview.modeldata.FightUitl")

--正常的速度
NORMAL_ACTION_SPEED = 1.5
--正常的倍数
NORMAL_ACTION_TIME = 1
--最大的倍数
MAX_ACTION_TIMES = 3

ACTION_SPEED = NORMAL_ACTION_SPEED * NORMAL_ACTION_TIME


-- TEST = true
TEST = false

EFFECT_TEST = false
-- EFFECT_TEST = true

TEST_WUSHUANG = false
-- TEST_WUSHUANG = true
--[11006121,11006122,11006123]
--[12006121,12006122,12006123]
WIN_TIME = 1
function autoLoadResource()
    coroutine.resume(g_coroutineLoadResource)
    if coroutine.status(g_coroutineLoadResource) == "dead" then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(g_schedulerLoadResource)
        g_coroutineLoadResource = nil
    end
end

function loadAniResource()
    local function load()
        cclog("load------start")
        getTempFightData():loadAnimation()
        cclog("load------over")
    end
    g_coroutineLoadResource = coroutine.create(load)
    g_schedulerLoadResource = cc.Director:getInstance():getScheduler():scheduleScriptFunc(autoLoadResource, 0.1, false)
end

function getTempFightData()
    if g_FMTempFightData == nil then
        g_FMTempFightData = FMTempFightData.new()
    end
    return g_FMTempFightData
end

--逻辑改到了FCProcess
-- function getFMProcess()
--     if g_FMProcess == nil then
--         g_FMProcess = FMProcess.new()
--     end
--     return g_FMProcess
-- end

function getFCProcess()
    return g_FCProcess
end

function getActionUtil()
    if g_ActionUtil == nil then
        g_ActionUtil = ActionUtil.new()
    end
    return g_ActionUtil
end

function getFVAction()
    if g_FVAction == nil then
        g_FVAction = FVAction.new()
    end
    return g_FVAction
end

function getFVActionSpec()
    if g_FVActionSpec == nil then
        g_FVActionSpec = FVActionSpec.new()
    end
    return g_FVActionSpec
end

function getFVParticleManager()
    -- if g_FVParticleManager == nil then
    --     g_FVParticleManager = FVParticleManager.new()

    -- end
    return g_FVParticleManager
end

function getFightUitl()
    -- if g_FightUitl == nil then
    --     g_FightUitl = FightUitl.new()
    -- end
    return g_FightUitl
end

function getFEControl()
    return getFightScene().FEControl
end








