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
ui = ui or {}
EventProtocol = EventProtocol or {}
function EventProtocol.extend(...)
    -- body
end
function cc.pAdd(t, t1)
end
function cc.p(p1, p2)
end
import(framework.PACKAGE_NAME.."src.app.Constants")

SERVER_CODE = 1


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

-- 数值处理小数点的数值
function roundNumber(number)
    -- return math.round(number)        -- 四舍五入
    return math.floor(number)           -- 舍去小数点
end


function cclog(data)
end
function print(...)
end
local fcProcess = FCProcess.new("FCProcess")

function setData(fightData, fightType, level)
    -- 初始化数据
    -- fightData: 战斗数据
    -- fightType: 战斗类型
    getDataManager():getFightData():setFightType(fightType)
    getDataManager():getFightData():setData(fightData)
    getDataManager():getCommonData():setPlayerLevel(level)
    print("seed1============"..fightData.seed1)
    print("seed2============"..fightData.seed2)
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

function reload_lua_config()
    -- body
    local baseTemplate = getTemplateManager():getBaseTemplate()
    print("reload lua config============")
    print("demoHero",baseTemplate:getBaseInfoById("demoHero"))
    package.loaded[ '.app.battle.src.app.datacenter.template.config.monster_config'] = nil
    require( '.app.battle.src.app.datacenter.template.config.monster_config')
    package.loaded[ '.app.battle.src.app.datacenter.template.config.base_config'] = nil
    require( '.app.battle.src.app.datacenter.template.config.base_config')

    package.loaded[ '.app.battle.src.app.datacenter.template.config.hero_config'] = nil
    require( '.app.battle.src.app.datacenter.template.config.hero_config')

    package.loaded[ '.app.battle.src.app.datacenter.template.config.monster_group_config'] = nil
    require( '.app.battle.src.app.datacenter.template.config.monster_group_config')

    package.loaded[ '.app.battle.src.app.datacenter.template.config.formula_config'] = nil
    require( '.app.battle.src.app.datacenter.template.config.formula_config')

    package.loaded[ '.app.battle.src.app.datacenter.template.config.skill_config'] = nil
    require( '.app.battle.src.app.datacenter.template.config.skill_config')

    package.loaded[ '.app.battle.src.app.datacenter.template.config.skill_buff_config'] = nil
    require( '.app.battle.src.app.datacenter.template.config.skill_buff_config')
    print("demoHero",baseTemplate:getBaseInfoById("demoHero"))
end
