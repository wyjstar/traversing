--战斗数据层
--require(framework.PACKAGE_NAME.."src.app.fightview.controller.InitData")
import(".InitData")
local FightProcess = import(".zhengpu_process")
local FCProcess = class("FCProcess")

function FCProcess:ctor(id)
    self.id = id
    --self.red_units = {}--我方阵容
    --self.blue_units = {}--敌方阵容
    --self.red_unpara_skill = nil--我方无双
    --self.blue_unpara_skill = nil--敌方无双
    --self.buddy_skill = nil--小伙伴
    ----BaseTemplate.lua 获取基本信息
    --self.baseTemplate = getTemplateManager():getBaseTemplate()
    ----战斗数据对象
    --self.fightData = getDataManager():getFightData()    
    ----初始值
    --self.red_step = 1--我方步数
    --self.blue_step = 1--敌方步数
    --self.current_round = 1--当前回合数
    --self.current_fight_times = 1--当前战斗回合数
    ----最大战斗回合数
    --self.fight_times_max = self.baseTemplate:getBaseInfoById("max_times_fight")
    --战斗逻辑
    self.fightProcess = FightProcess.new(handler(self, self.send_message))
end

-- 初始化数据，测试阶段目前为假值
function FCProcess:init()
    cclog("FCProcess:init=====================>")
    --self.fight_type = TYPE_GUIDE
    local fight_type = getDataManager():getFightData():getFightType()
    self.fightProcess:init(fight_type)

    --self.red_units, self.blue_groups, self.red_unpara_skill, self.blue_unpara_skill, self.buddy_skill = initData(self)
    --self.blue_units = self.blue_groups[self.current_round]
    --总回合数
    --self.max_round = table.nums(self.blue_groups)
    --self.blue_hp_total = self:get_blue_hp_total()
    --self.back_skill_buff = nil -- 保存反击buff
end


--开始战斗 
function FCProcess:start()
    print("FCProcess:start============")
    while self.fightProcess:check_result() == 0 do
        self.fightProcess:perform_one_step()
    end
    return self.fightProcess:check_result() == 1
end

-- 
function FCProcess:send_message()
end


return FCProcess
