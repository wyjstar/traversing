BOSS_INFO = 1701                    --获取战斗开始前的所有信息， command:1701
BOSS_PLAYER_INFO = 1702             --请求pvb玩家信息, command:1702
BOSS_INSPIRE = 1703                 --鼓舞， command:1703
BOSS_RELIVE = 1704                  --使用元宝复活, command:1704
BOSS_FIGHT_START = 1705             --战斗开始
BOSS_DEAD = 1706
BOSS_REWARD_GET = 1708              --Pvb奖品:参与奖、累积伤害奖、排行奖、最后击杀奖励 command:1708

BossNet = class("BossNet", BaseNetWork)

function BossNet:ctor()
    self.super.ctor(self, "BossNet")
    self:init()
end

function BossNet:init()
    self.c_bossData = getDataManager():getBossData()
    self:registerChatCallBack()
end

------=======发送协议=======------

--获取战斗结束的相关信息
function BossNet:sendGetBossInfoForFight()
    exitFightScene()
    -- self:sendMsg(BOSS_INFO)
    -- self:sendGetBossInfo()
    --发送1706的协议
    self:sendGetBossDeadInfo()
end

--获取战斗开始之前的相关信息 1701
function BossNet:sendGetBossInfo(data)
    -- local data = { boss_id = "world_boss" }
    cclog("---------------sendGetBossInfo-------------")
    self:sendMsg(BOSS_INFO, "PvbRequest", data)
end

--战斗结束协议发送 --1706
function BossNet:sendGetBossDeadInfo()
    print("世界boss被打死之后发送 ================= 1706")

    local data = { boss_id = "world_boss" }
    self:sendMsg(BOSS_DEAD, "PvbRequest", data)
end

--玩家相关信息
function BossNet:sendGetTeamInfo(rankNo)
    local data =
                {
                    rank_no = rankNo,
                    boss_id = "world_boss"
                }
    self:sendMsg(BOSS_PLAYER_INFO, "PvbPlayerInfoRequest", data)
end

--鼓舞
function BossNet:sendSliverInspire(cost_type, cost_value)
    local data =
                {
                    finance_type = cost_type,
                    finance_num = cost_value,
                    boss_id = "world_boss"
                }
    self:sendMsg(BOSS_INSPIRE, "EncourageHerosRequest", data)
end

--复活
function BossNet:sendRelive()
    local data = { boss_id = "world_boss" }
    self:sendMsg(BOSS_RELIVE, "PvbRequest", data)
end

--战斗开始
function BossNet:sendFigthStart(data)
    print("战斗开始 ================ ")
    table.print(data)
    self:sendMsg(BOSS_FIGHT_START, "PvbStartRequest" ,data)
end

--世界Boss奖励获取
function BossNet:sendPvbAward()
    print("[QPrint:]BossNet:sendPvbAward")
    self:sendMsg(BOSS_REWARD_GET)
end

------=======协议返回=======------

function BossNet:registerChatCallBack()
    --boss相关信息
    local function bossInfoCallBack(data)

        print("世界boss信息返回 -===================== ", data)
        table.print(data)
        self.c_bossData:setIsOpen(data.open_or_not)

        self.c_bossData:setHurtRankList(data.rank_items)                --对boss伤害前十名的玩家排行信息

        -- local hightHero = data.lucky_high_heros                                --高级武将1
        -- local middleHeros = data.lucky_middle_heros                            --中级武将2
        -- local lowHeros = data.lucky_low_heros                                  --低级武将3
        -- local luckyHeros = {}
        -- table.insert(luckyHeros, 1, hightHero)

        -- table.insert(luckyHeros, 2, middleHeros)

        -- table.insert(luckyHeros, 3, lowHeros)


        self.c_bossData:setLuckyHeros(data.lucky_heros)                       --幸运武将列表

        print("data.lucky_heros ========== ")
        table.print(data.lucky_heros)

        self.c_bossData:setAdventure(data.debuff_skill_no)              --奇遇

        self.c_bossData:setCurStageId(data.stage_id)                    --当前关卡id

        self.c_bossData:setBloodValue(data.hp_left)                     --boss当前剩余的血量

        self.c_bossData:setLastShotList(data.last_shot_item)            --上轮击杀boss的玩家

        self.c_bossData:setFightTimes(data.fight_times)                 --战斗次数

        self.c_bossData:setSliverEncourageTime(data.encourage_coin_num) --银币鼓舞次数

        self.c_bossData:setGoldEncourageTimes(data.encourage_gold_num)  --金币鼓舞次数

        self.c_bossData:setRankNo(data.rank_no)                         --当前排名

        self.c_bossData:setDamageHp(data.demage_hp)                     --对boss的伤害数值

        self.c_bossData:setLastFightTime(data.last_fight_time)          --上次战斗结束时间

        if g_toBoss == 1 then
            g_toBoss = 0
            local isDead = self.c_bossData:getBossIsDead()
            if not isDead then
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeWorldBoss")
            end
        end
    end
    self:registerNetMsg(BOSS_INFO, "PvbBeforeInfoResponse", bossInfoCallBack)
    --1706 协议发送返回
    self:registerNetMsg(BOSS_DEAD, "PvbBeforeInfoResponse", bossInfoCallBack)
    --战队信息查看
    local function getInfoCallBack(data)
        local c_arenaData = getDataManager():getArenaData()
        c_arenaData:setRankCheckInfo(data.slot)
        c_arenaData:setOtherPlayerLineUp(data)
    end

    self:registerNetMsg(BOSS_PLAYER_INFO, "LineUpResponse", getInfoCallBack)

    --鼓舞
    local function getInspireCallBack(data)
        self.c_bossData:setInspireData(data)
    end

    self:registerNetMsg(BOSS_INSPIRE, "CommonResponse", getInspireCallBack)

    --复活
    local function getReliveCallBack(data)
        self.c_bossData:setReliveData(data)
    end

    self:registerNetMsg(BOSS_RELIVE, "CommonResponse", getReliveCallBack)

    --战斗开始协议返回
    local function getFightStartCallBack(data)
        print("世界boss 返回 ========= ")
        table.print(data)
    end

    self:registerNetMsg(BOSS_FIGHT_START, "PvbFightResponse", getFightStartCallBack)

    local function getBossRewardCallBack(data)
        table.print(data)
        self.c_bossData:setRewardInfo(data)
    end

    self:registerNetMsg(BOSS_REWARD_GET, "PvbAwardResponse", getBossRewardCallBack)
end

return BossNet
