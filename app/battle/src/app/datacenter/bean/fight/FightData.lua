--存放战斗的相关数值

local FightData = class("FightData")

function FightData:ctor()

	-- 当前打的关卡id
	self.fightingStageId = nil
	-- 打当前关卡我方使用的阵型: 格式：{[1]={pos=1,hero_id=11101,activation=false},...}
	self.lineup = nil
	-- 打当前关卡我方使用的无双技能id
	self.unparalleled = nil
	-- 打当前关卡我方雇佣的好友id
	self.friendId = nil
	-- 当前关卡掉落数，服务器903的response: optional int32 drop_num = 2;  //掉落数量
	self.drop_num = nil
	-- 打当前关卡己方数据，服务器903的response: repeated BattleUnit red = 4; //红方数据 自己
	self.red = nil
	-- 打当前关对方数据，服务器903的response: repeated BattleUnitGrop blue = 5; //对方数据
	self.blue = nil
	 -- optional BattleUnit friend = 6; // 好友
	self.friend = nil
    -- optional Skill monster_unpara = 7; // 怪物无双
    self.monster_unpara = nil

    self.replace_no = nil
    self.replace = nil

    self.data = nil --战场数据

    self.isWin = nil

    self.fight_result = nil
end

	-- required CommonResponse res = 1;
	-- optional int32 drop_num = 2;  //掉落数量
	-- repeated BattleUnit red = 4; //红方数据 自己
	-- repeated BattleUnitGrop blue = 5; //对方数据
	-- optional BattleUnit friend = 6; // 好友
	-- optional Skill monster_unpara = 7; // 怪物无双
	-- optional BattleUnit replace = 8; //
	-- optional int32 replace_index = 9;
	
function FightData:setData(data)
	self.data = data
end

function FightData:getData()
	return self.data
end

function FightData:getSeat(heroId)
	print("--------------FightData:getSeat------------"..heroId)
	table.print(self.lineup)
	--self.lineup[k] = {pos = _seat, hero_id = infor.id
	for k, v in pairs(self.lineup) do
		if heroId == v.hero_id then
			print(heroId.."========"..v.pos)
			return v.pos
		end
	end
	return 0
end

function FightData:setReplace(replace)
	self.replace = replace
end

function FightData:getReplace()
	return self.replace
end

function FightData:resetAllData()
	self.fightingStageId = nil
	self.lineup = nil
	self.unparalleled = nil
	self.friendId = nil
	self.drop_num = nil
	self.red = nil
	self.blue = nil
	self.replace = nil
	self.isWin = nil
end

function FightData:getIsWin()
  	return self.isWin
end

function FightData:setIsWin(flag)
	if type(flag) == "boolean" then
		self.isWin = flag
	elseif type(flag) == "number" then
		if flag == 0 then self.isWin = false
		else self.isWin = true
		end
	end
end


function FightData:setFightResult(result)
	self.fight_result = result
end

function FightData:getFightResult()

	return self.fight_result
end

function FightData:setFriend(friend)
	self.friend = friend
end

function FightData:getFriend()
	return self.friend
end

function FightData:setMonsterUnpara(monster_unpara)
	self.monster_unpara = monster_unpara
end

function FightData:getMonsterUnpara()
	return self.monster_unpara
end

function FightData:setFightingStageId(stageId)
	assert(stageId ~= nil, "stageId can not be nil !")
	self.fightingStageId = stageId
	local number = math.floor(self.fightingStageId / 100000)
	if number <= 5 and number >= 1 then  -- 剧情
        self:setFightType(TYPE_STAGE_NORMAL)
    elseif number == 9 then
    	self:setFightType(TYPE_TRAVEL)
    elseif number == 7 then  -- 精英
        self:setFightType(TYPE_STAGE_ELITE)
    elseif number == 6 then  -- 活动
        self:setFightType(TYPE_STAGE_ACTIVITY)
    else
        -- do nothing
    end

end

function FightData:setFightType( fightType ) self.fightingType = fightType  end
function FightData:getFightType() return self.fightingType end

function FightData:getFightingStageId() return self.fightingStageId end

function FightData:setLineup(data)
	assert(data ~= nil, "lineup can not be nil !")
	self.lineup = data
end

function FightData:getLineup() return self.lineup end

function FightData:setUnparalleled(unparId)  -- wu shuang
	print("unparalleled is nil !!! 你可能没有选择无双")
	self.unparalleled = unparId
end

function FightData:getUnparalleled() return self.unparalleled end

function FightData:setDropNum(data)
	-- assert(data ~= nil, "drop number can not be nil !")
	self.drop_num = data
end

function FightData:getDropNum() return self.drop_num end

-- 缓存掉落物品
function FightData:setDrops(drops)
	self.drops = drops
end
function FightData:getDrops() return self.drops end

function FightData:setRed(data)
	-- assert(data ~= nil, "drop number can not be nil !")
	self.red = data
end

function FightData:getRed() return self.red end

function FightData:setBlue(data)
	-- assert(data ~= nil, "drop number can not be nil !")
	self.blue = data
end

function FightData:getBlue() return self.blue end

function FightData:setArmyAfterInit(prop)
    self.army = prop
end

function FightData:getArmyAfterInit()
    return self.army
end

function FightData:setEnemyAfterInit(prop)
    self.enemy = prop
end

function FightData:getEnemyAfterInit()
    return self.enemy
end

return FightData
