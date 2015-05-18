local SecretPlaceData = class("SecretPlaceData")



function SecretPlaceData:ctor(id)
    self.mines = {}                 --玩家矿点信息
    self.resetToday = 0             --已重置次数
    self.resetFree = 0              --免费可重置次数
    self.resetCount = 0             --可重置次数
    self.drawStones = nil           --
    self.boxReward = nil
    self.current = 0
    self.MineGuardRequest = {}
    self.MineGuardRequest.line_up_slots = {}
    self.battleResponse = {}
    self.CommonResponse = {}
    self.MineBossResponse  = {}
end

--[[
//矿点信息
message mineData
{
required int32 position = 1;//地图位置, 0玩家自己的初始矿
required int32 type = 2; //矿点类型 1玩家占领的野怪矿，2野外矿，3神秘商人，4巨龙宝箱，5副本
required int32 status = 3;//矿点状态1生产中，2可收获，3已枯竭，4空闲，5已领取，6副本已进入
optional string nickname = 4;//昵称
optional int32 last_time = 5;//倒计时
}
]]

function SecretPlaceData:setMineBossResponse(data)

    self.MineBossResponse = data
end

function SecretPlaceData:getMineBossResponse()
    
    return self.MineBossResponse
end

function SecretPlaceData:setSettle(data)
    print("----SecretPlaceData:setSettle----")
    table.print(data)
    self.CommonResponse = data
end

function SecretPlaceData:getSettle(data)
    
    return self.CommonResponse
end

-- 判断是否有可收获的符文石
function SecretPlaceData:isHaveHavest()

    for k,v in pairs(self.mines) do
        if self:isOwer(v) and v.type == 1 then 
            local  _leftTime = v.last_time - getDataManager():getCommonData():getTime()
            -- print("======isHaveHavest===========")
            -- print(_leftTime)
            if _leftTime <= 0 then
                return true
            end
        end
    end

    if self:getNormalNum(0)>0 then
        return true
    end

    return false
end

function SecretPlaceData:isOwer(mine)
    if mine==nil or mine.nickname==nil then return false end

   return mine.nickname == getDataManager():getCommonData():getUserName() 
end

--获取玩家昵称
function SecretPlaceData:getNickName()
   return  self.mines[self.current].nickname
end

--获取矿点基本信息
function SecretPlaceData:getBaseInfo()
    return self.mines
end

function SecretPlaceData:setMineInfo(data)
    print("==SecretPlaceData:setMineInfo=====")
    table.print(data)
    self.resetToday = data.reset_today
    self.resetFree = data.reset_free
    self.resetCount = data.reset_count
    for k, v in pairs(data.mine) do
        -- if v.position ~= 0 then

            self.mines[v.position] = v
        -- end
        print("----------------"..k)
        table.print(v)
    end

    local data = {}
    data.position = 0
    data.mine = {}
    data.mine.position = 0

    data.normal = {}

    self.mines[data.position].position = 0
    self.mines[data.position] = data
    self.mines[data.position].normal = data.normal


    -- table.print(self.mines)

    print("=======self.mines==========")
    -- for k,v in pairs(self.mines) do
    --     print("----------------"..k)
    --     table.print(v)
    -- end

end

function SecretPlaceData:setOneMineInfo(data)
    if data.res.result == true then
        print(data.position)
        -- table.print(data.mine)
        print("---------setOneMineInfo--------")
        self.mines[data.position] = data.mine
        table.print(self.mines[data.position])
    end
end

function SecretPlaceData:setDetailInfo(data)
    self.current = data.position
    self.mines[data.position] = data
    self.mines[data.position].position = data.mine.position
    self.mines[data.position].type = data.mine.type
    self.mines[data.position].status = data.mine.status
    self.mines[data.position].nickname = data.mine.nickname
    self.mines[data.position].last_time = data.mine.last_time
    self.mines[data.position].gen_time = data.mine.gen_time
    self.mines[data.position].lineup = data.lineup
    self.mines[data.position].normal = data.normal
    self.mines[data.position].lucky = data.lucky
    self.mines[data.position].increase = data.increase

    print("---data.increase------")
     -- table.print(data.lineup)
     -- table.print(data.normal)
     -- table.print(data.lucky)
    print("----=-====---=====---===")
end

-- 增产剩余时间，单位：秒
-- function SecretPlaceData:getIncrease()

--     return self.mines[self.current].increase
-- end

function SecretPlaceData:getDetailInfo(position)
    
    return self.mines[position]
end

function SecretPlaceData:getNormals(position)
    print(self.current)
    cclog("-------getNormals-------")
    table.print(self.mines[self.current].normal)
    return self.mines[self.current].normal
end

function SecretPlaceData:getBaseNormals(position)
    
    print(self.mines[position])

    return  table.nums(self.mines[position].normal)
end

function SecretPlaceData:getLuckys(position)
    cclog("--------SecretPlaceData:getLuckys----------")
    table.print(self.mines[self.current].lucky)
    return self.mines[self.current].lucky
end

function SecretPlaceData:clearNormal(position)
    self.mines[position].normal = {}
end
function SecretPlaceData:clearLucky(position)
    self.mines[position].lucky = {}
end

function SecretPlaceData:getNormalNum(position)
    
    -- print("--getNormalNum----")

    -- table.print(self.mines[0])

    if self.mines[position] == nil or self.mines[position].normal == nil then return 0 end
    local num = 0
    for k, v in pairs(self.mines[position].normal) do
        num = num + v.stone_num
    end
    return num
end

function SecretPlaceData:getLuckyNum(position)
    local num = 0
    for k, v in pairs(self.mines[position].lucky) do

        num = num + v.stone_num
    end
    return num
end

function SecretPlaceData:getUnit(position)

    -- table.print(self.mines)

    print(self.mines[position].genUnit)
    return self.mines[position].genUnit
end

function SecretPlaceData:getIncrease(position)
    cclog("------getIncrease-----"..self.mines[position].increase)
    return self.mines[position].increase
end

function SecretPlaceData:getLimit(position)
    return self.mines[position].limit
end

function SecretPlaceData:getRate(position)
    return self.mines[position].rate
end

function SecretPlaceData:getPrice(position)
    return self.mines[position].incrcost
end

function SecretPlaceData:setIncrease(data)
    if data.res.result == true then
        self.mines[data.position].increase = data.last_time
        local cost = data.consume.finance.gold
        if cost >= 0 then
            getDataManager():getCommonData():subGold(cost)
        end
    end

end

function SecretPlaceData:setBoxReward(data)
    print("setBoxReward====")
    table.print(data)
    self.mines[data.position].status = 5

    self.boxReward = data
    local runt = self.boxReward.data.gain.runt
    local runtNum = table.getn(runt)
    if runtNum ~= 0 then
        getDataManager():getRuneData():updateNumById(1, runt)
    else
        getDataProcessor():gainGameResourcesResponse(self.boxReward.data.gain)
    end
end

function SecretPlaceData:getBoxReward()
    
    return self.boxReward
end

function SecretPlaceData:procHarvest(data)
    if data.res.result == true then
        self.drawStones = data
        getDataManager():getRuneData():setBagRunes(self.drawStones.runt)
    end
end

function SecretPlaceData:getDrawStones()
    
    return self.drawStones
end

function SecretPlaceData:getLastTimes()
    return self.resetCount - self.resetToday
end

function SecretPlaceData:setMapInfo(data)
    if data.res.result == true then
        self.mines = {}
        self:setMineInfo(data.mine)
        if data.free == 2 then
            local cost = data.consume.finance.gold
            if cost >= 0 then
                getDataManager():getCommonData():subGold(cost)
            end
        end
    end
end

function SecretPlaceData:getMineType(position)
    print('SecretPlaceData:getMineType--'..position)
    -- table.print(self.mines[position])
    print(self.mines[position].mine.type)
    return self.mines[position].mine.type
end

function SecretPlaceData:getSlotItemBySeat(pos)
    local _slots = self.MineGuardRequest.line_up_slots
    for k,v in pairs(_slots) do
        if v.slot_no == pos then
           return v.hero_no
        end
    end
end


function SecretPlaceData:getEquipDataSeat(selectSeat, equipSeat)
    local _equipment_slots = self:getEquipsSlotItemByHeroSeat(selectSeat)

    -- table.print(_equipment_slots)

    for k, v in pairs(_equipment_slots) do
        if v.slot_no == equipSeat then

            return v.equipment_id
        end
    end

    return ""
end

function SecretPlaceData:getEquipsSlotItemByHeroSeat(seatIndex)
    local  _line_upSlots = self.MineGuardRequest.line_up_slots

    for k, v in pairs(_line_upSlots) do
    local seat = v.slot_no
        if seat == seatIndex then

            return v.equipment_slots
        end
    end

    return nil
end

-- 获取阵容上的武将nos
function SecretPlaceData:getMineGuardHeroNos()
    local hero_nos = {}
    for k, slot in pairs(self.MineGuardRequest.line_up_slots) do
        table.insert(hero_nos, slot.hero_no)
    end
    return hero_nos
end

-- 获取驻守阵容上武将信息
function SecretPlaceData:getMineGuardRequestHeros()
    
    return self.MineGuardRequest.line_up_slots
end

-- 设置阵容
function SecretPlaceData:setMineGuardRequest(pos, hero_no)

    local _isexists = false
    local _slots = self.MineGuardRequest.line_up_slots
    print("-----------_slots---------------")
    table.print(_slots)
    for k,v in pairs(_slots) do
        if v.slot_no == pos then
            v.hero_no = hero_no
            _isexists = true
            print("---exists====")
            break
        end
    end

    if not _isexists then
        print("-------00000000----------",hero_no)
        local _MineLineUpSlot = {}
        _MineLineUpSlot.slot_no = pos
        _MineLineUpSlot.hero_no = hero_no
        _MineLineUpSlot.equipment_slots = {}
        -- table.print(_MineLineUpSlot)

        table.insert(self.MineGuardRequest.line_up_slots, _MineLineUpSlot)
    end
    print("---self.MineGuardRequest.line_up_slots----")
    -- table.print(self.MineGuardRequest.line_up_slots)


end
-- 设置无双技能
function SecretPlaceData:setBestSkillId(best_skill_id)
    
    self.MineGuardRequest.best_skill_id = best_skill_id
end

function SecretPlaceData:setHeroEquip(hero_pos, equip_pos, equipid)
    
    print("===SecretPlaceData:setHeroEquip====")

    local _slots = self.MineGuardRequest.line_up_slots

    -- table.print(_slots)

    for k,v in pairs(_slots) do
        if v.slot_no == hero_pos then
            local _isexists = false
            for k1,v1 in pairs(v.equipment_slots) do
                if v1.slot_no == equip_pos then
                    v1.equipment_id = equipid

                    _isexists = true
                    break
                end
            end

            if not _isexists then
                local _MineEquipmentSlot = {}
                _MineEquipmentSlot.slot_no = equip_pos
                _MineEquipmentSlot.equipment_id = equipid
                

                table.insert(v.equipment_slots, _MineEquipmentSlot)
            end

            table.print(v.equipment_slots)

            break
        end
    end 
end

-- message MineGuardRequest
-- {
--     required int32 pos = 1;                    // 矿在地图上的位置
--     repeated MineLineUpSlot line_up_slots = 2; // 阵容
--     optional int32 best_skill_id = 3;          // 无双id
-- }
-- //秘境相关，卡牌位
-- message MineLineUpSlot
-- {
--     required int32 slot_no = 1;                    // 阵容位置
--     required int32 hero_no  = 2;                   // 武将编号
--     repeated MineEquipmentSlot equipment_slots = 3; // 装备
-- }

-- message LineUpResponse{
--     repeated LineUpSlot slot = 1;
--     repeated LineUpSlot sub = 2;
--     repeated Unpar unpars = 3;
--     optional CommonResponse res = 4;
-- }

-- // 阵容格子
-- message LineUpSlot{
--     required int32 slot_no = 1; // 位置编号
--     optional bool activation = 2; //是否激活
--     optional HeroPB hero = 3; //英雄
--     repeated SlotEquipment equs = 4; //装备
-- }

-- 设置驻守阵容
function SecretPlaceData:setMineGuardRequestLineupFromGuardLineup()
    self:clearMineGuardRequest()

    local _lineup = self:getLineUp()
    
    -- print("----setMineGuardRequestLineupFromGuardLineup----")
    -- -- table.print(_lineup)
    -- print("----setMineGuardRequestLineupFromGuardLineup-1111---")
    -- 设置无双
    if table.nums(_lineup.unpars)>0 then
        local _unpar = _lineup.unpars[1]
        self:setBestSkillId(_unpar.unpar_id)
    end

    print("-----setMineGuardRequestLineupFromGuardLineup-----")

    -- 设置阵容
    for k,v in pairs(_lineup.slot) do

        if v.hero and v.hero.hero_no >0 then
            self:setMineGuardRequest(v.slot_no, v.hero.hero_no)
            
            print("----v.equs----")

            table.print(v.equs)

            for k1,v1 in pairs(v.equs) do
                print(k,v)
                self:setHeroEquip(v.slot_no, v1.no, v1.equ.id)
            end
        end
    end
end

function SecretPlaceData:clearMineGuardRequest()
    cclog("----SecretPlaceData:clearMineGuardRequest----")
    self.MineGuardRequest = {}
    self.MineGuardRequest.line_up_slots = {}
    self.MineGuardRequest.best_skill_id = 0

    -- table.print(self.MineGuardRequest.line_up_slots)
end

function SecretPlaceData:getIsSeated(pos)
    cclog("----SecretPlaceData:getIsSeated----")
    local _slots = self.MineGuardRequest.line_up_slots

    for k,v in pairs(_slots) do
        if v.slot_no == pos then

            return true
        end
    end

    return false
end


function SecretPlaceData:setBattleResponse(data)
    cclog("_+_+_+_+_+_+_____SecretPlaceData:setBattleResponse__+_+_+_+_+_+")
    table.print(data.res)
    self.battleResponse = data
end

function SecretPlaceData:getBattleResponse()
    
    return self.battleResponse
end

function SecretPlaceData:getMineGuardRequest()
    
    return self.MineGuardRequest
end

function SecretPlaceData:setCurrentMap(position)
    self.current = position
end

function SecretPlaceData:getCurrentMine()
    return self.mines[self.current]
end

function SecretPlaceData:getStageID()
    -- print("-----self.current-----", self.current)
    return self.mines[self.current].stage_id
end

-- 获取驻守英雄数据
function SecretPlaceData:getLineUp()
    -- print("--------self.mines[self.current].lineup-------")
    -- table.print(self.mines[self.current].lineup)
    return self.mines[self.current].lineup
end

-- 根据位置获取驻守英雄数据
function SecretPlaceData:getHeroDataBySlot(seat)
    local mines_lineup = self.mines[self.current].lineup.slot
    -- print("-------mines_lineup--seat-----",seat)
    -- table.print(mines_lineup)
    for k,v in pairs(mines_lineup) do
        if seat == v.slot_no then
            return v.hero
        end
    end
    return nil
end

-- 根据位置获取驻守英雄装备数据
function SecretPlaceData:getEquipDataBySlot(seat)
    local mines_lineup = self.mines[self.current].lineup.slot
    -- print("-------mines_lineup--seat-----",seat)
    -- table.print(mines_lineup)
    for k,v in pairs(mines_lineup) do
        if seat == v.slot_no then
            return v.equs
        end
    end
    return nil
end

-- 驻守是阵容否为空
function SecretPlaceData:existMineLineUp()
    local mines_lineup = self.mines[self.current].lineup.slot
    -- print("-------mines_lineup--seat-----",seat)
    -- table.print(mines_lineup)
    for k,v in pairs(mines_lineup) do
        if v.hero ~= nil  then
            return true
        end
    end
    return false
end


function SecretPlaceData:getMapPosition()
    
    return self.current
end

-- 设置生产时间
function SecretPlaceData:setGenTime()
    -- local _mine = self:getCurrentMine()
    -- _mine.gen_time = getDataManager():getCommonData():getTime()
    -- _mine.last_time = getDataManager():getCommonData():getTime()+
end

function SecretPlaceData:setOtherPlayersCanGet(flag)
    self.mineCanGet = flag
    print("--------self.mineCanGet-----",self.mineCanGet)
end
function SecretPlaceData:getOtherPlayersCanGet()
    print("--------getOtherPlayersCanGet-----",self.mineCanGet)
    return self.mineCanGet
end


return SecretPlaceData

