framework = framework or {}
framework.PACKAGE_NAME = "app.battle."
require(framework.PACKAGE_NAME.."src.framework.debug")
require(framework.PACKAGE_NAME.."src.framework.functions")
--require("src.app.util.Util")
--require("src.app.controller.GameController")
--require("src.app.fightview.init")
--require("src.app.fightview.init_after")
--g_FightScene = {}
--g_FightScene.fightType = TYPE_GUIDE
local FCProcess = import(framework.PACKAGE_NAME.."src.app.fightview.controller.ServerProcess")
local TemplateManager = import(framework.PACKAGE_NAME.."src.app.datacenter.template.TemplateManager")
local CalculationManager = import(framework.PACKAGE_NAME.."src.app.datacenter.calculation.CalculationManager")
local DataManager = import(framework.PACKAGE_NAME.."src.app.datacenter.bean.DataManager")
cc = cc or {}
function cc.pAdd(t, t1)
    print(data)
end
function cc.p(p1, p2)
    print(data)
end
import(framework.PACKAGE_NAME.."src.app.Constants")

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
--计算中心
function getCalculationManager()
    if g_CalculationManager == nil then
        g_CalculationManager = CalculationManager.new()
    end
    return g_CalculationManager
end

function getActionUtil()
    return nil
end
function createFile()
    --local filename = cc.FileUtils:getInstance():getWritablePath().."output"
    local filename = "output"
    local f = io.open(filename, "w")
    f:close()
end

function appendFile2(message, tab_num)
    --local filename = cc.FileUtils:getInstance():getWritablePath().."output"
    local filename = "output"
    f = io.open(filename, "a")

    if not tab_num then
        tab_num = 0
    end
    local tab = ""
    for i=1,tab_num do
        tab = tab.."\t"
    end
    if message ~= nil then 
        f:write(tab..message.."\n") 
    end    
    f:close()
end

function cclog(data)
    print(data)
end
local fcProcess = FCProcess.new("FCProcess")

function setData(fightData, fightType)
    -- 初始化数据
    -- fightData: 战斗数据
    -- fightType: 战斗类型
    getDataManager():getFightData():setFightType(fightType)
    getDataManager():getFightData():setData(fightData)
end

function pvp_start()
    -- 开始pvp战斗
    print("pvp start======")
    fcProcess:init()
    return fcProcess:pvp_start()
end

function pve_start(steps)
    -- 开始pve战斗
    print("pve start======")
    fcProcess:init()
    return fcProcess:pve_start(steps)
end
