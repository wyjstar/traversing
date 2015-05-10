--装备计算类

local CommonCalculation = CommonCalculation or class("CommonCalculation")

function CommonCalculation:ctor()

    self.c_EquipTemp = getTemplateManager():getEquipTemplate()
    self.c_LineupData = getDataManager():getLineupData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.heroTemp = getTemplateManager():getSoldierTemplate()
    self.soldierData = getDataManager():getSoldierData()
end

--获得总战力
function SoldierCalculation:getTotleForce()
    self:getHPHero()
end

function CommonCalculation:getHPHero(heroId)
    --hpHero
    --hp:基础生命值,growHp:生命值成长,heroLevel:武将等级,
    --hpB:突破技能增加面板生命值,parameters:突破系数,hpSeal:炼体增加的生命值,hpStone:符文增加的生命值
    --return  ( k1 + k2 * k3 ) * ( 1 + 0.01*k4 ) + k5
--    local 

end

--获得炼体信息
function CommonCalculation:getLTInfo(heroId)
    local seal = self.soldierData:getSealById(heroId)
    if seal == 0 then seal = self.heroTemp:getFirstSealId()
    else seal = self.heroTemp:getNextSealId(seal)
    end
    local allAttributes = self.heroTemp:getAllAttribute(seal)
    
    --     self.AttNumTable[1]:setString("+"..roundNumber(allAttributes["hp"]))
    -- self.AttNumTable[2]:setString("+"..roundNumber(allAttributes["atk"]))
    -- self.AttNumTable[3]:setString("+"..roundNumber(allAttributes["physicalDef"]))
    -- self.AttNumTable[4]:setString("+"..roundNumber(allAttributes["magicDef"]))
    -- self.AttNumTable[5]:setString("+"..allAttributes["hit"])
    -- self.AttNumTable[6]:setString("+"..allAttributes["dodge"])
    -- self.AttNumTable[7]:setString("+"..allAttributes["cri"])
    -- self.AttNumTable[8]:setString("+"..allAttributes["ductility"])
    -- self.AttNumTable[9]:setString("+"..allAttributes["criCoeff"])
    -- self.AttNumTable[10]:setString("+"..allAttributes["criDedCoeff"])
    -- self.AttNumTable[11]:setString("+"..allAttributes["block"])
end
return CommonCalculation
















