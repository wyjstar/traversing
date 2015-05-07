--数据计算类

local LineUpCalculation = LineUpCalculation or class("LineUpCalculation")

function LineUpCalculation:ctor()
    self.c_LineupData = getDataManager():getLineupData()

    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self.c_SoldierCalculation = getCalculationManager():getSoldierCalculation()
end

--获得助威加成 hp
--1攻击2  2， hp,3pdef 4 mdef
function LineUpCalculation:getAddition()
    local cheerSoldier = self.c_LineupData:getCheerSoldier()
    local attAddValue = 0
    local hpAddValue = 0
    local pdefAddValue = 0
    local mdefAddValue = 0

    for k, v in pairs(cheerSoldier) do
        local seat = v.slot_no
        local heroId = v.hero.hero_no

        if heroId ~= 0 then
            -- print("=====seat="..seat)
            local cheerAdd = self.c_BaseTemplate:getCheerAddBySeat(seat)
            for m, n in pairs(cheerAdd) do
                if m == "1" then --攻击
                    local tempAtk = self.c_SoldierCalculation:getHeroAtkByHeroPB(v.hero)
                    attAddValue = attAddValue + tempAtk * n
                elseif m == "2" then
                    local tempHp = self.c_SoldierCalculation:getHeroHpByHeroPB(v.hero)
                    -- print("tempHp========" .. tempHp)
                    hpAddValue = hpAddValue + tempHp * n
                elseif m == "3" then
                    local tempPDef = self.c_SoldierCalculation:getHeroPDefByHeroPB(v.hero)
                    pdefAddValue = pdefAddValue + tempPDef * n
                elseif m == "4" then
                    local tempMDef = self.c_SoldierCalculation:getHeroMDefByHeroPB(v.hero)
                    mdefAddValue = mdefAddValue + tempMDef * n
                end
            end
        end
    end

    return roundNumber(attAddValue), roundNumber(hpAddValue), roundNumber(pdefAddValue), roundNumber(mdefAddValue)
end


return LineUpCalculation