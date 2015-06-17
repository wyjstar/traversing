
local FVCombo = class("FVCombo", function()
    return game.newNode()
end)

function FVCombo:ctor(id)
    self.target = nil
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.fightUitl = getFightUitl()
end

function FVCombo:setTarget(target)
    self.target = target
end


return FVCombo






