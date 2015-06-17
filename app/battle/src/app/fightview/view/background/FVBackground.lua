

local FVBackground = class("FVBackground", mvc.ViewBase)

function FVBackground:ctor(id)
    FVBackground.super.ctor(self, id)
    local stageResId = nil
    local gId = getNewGManager():getCurrentGid()
    --if gId == G_SRART_GUIDE_ANI then
    if true then
        local demoFightRes = getTemplateManager():getBaseTemplate():getBaseInfoById("demoFightRes")
        stageResId = demoFightRes
    else
        self.fightData = getDataManager():getFightData()
        local curStageId = self.fightData:getFightingStageId()
        local curStageType = self.fightData:getFightType()
        
        self.stageTemp = getTemplateManager():getInstanceTemplate()

        
        if curStageType == TYPE_STAGE_NORMAL or curStageType == TYPE_MINE_MONSTER then 

            stageResId = self.stageTemp:getStageResId(curStageId)
        elseif curStageType == TYPE_TRAVEL then

            stageResId = self.stageTemp:getTravelResId(curStageId)
        elseif curStageType == TYPE_STAGE_ELITE or curStageType == TYPE_STAGE_ACTIVITY or curStageType == TYPE_WORLD_BOSS  then
           cclog("curStageId=======" .. curStageId)
            stageResId = self.stageTemp:getSpecialStageById(curStageId).res
        elseif curStageType == TYPE_PVP or curStageType == TYPE_MINE_OTHERUSER then

            local baseTemplate = getTemplateManager():getBaseTemplate()
            stageResId = baseTemplate:getBaseInfoById("arenaRes")
        end
    end
    
    self.resourceTemplate = getTemplateManager():getResourceTemplate()
    local pathName = self.resourceTemplate:getPathNameById(stageResId)

    local ccbiName = "fight/" .. pathName .. ".ccbi"

    self.stageNode = {}
    local proxy = cc.CCBProxy:create()
    self.curScene = CCBReaderLoad(ccbiName, proxy, self.stageNode)

    self:addChild(self.curScene)
    self.height = 1789 - 960 
    self.fvActionSpec = getFVActionSpec()
end

function FVBackground:onMVCEnter()
    self:listenEvent(const.EVENT_INTERLUDE_BEGIN, self.onInterludeBegin, nil)
    self:listenEvent(const.EVENT_ATTACK_ITEM_SHAKE, self.onAttackShake, nil)
end

function FVBackground:onInterludeBegin(maxRoundNum)
    print("FVBackground:onInterludeBegin======================",maxRoundNum)
    local dis = self.height / (maxRoundNum - 1)
    local action = self.fvActionSpec:makeActionInterlude_bg(dis)

    self.curScene:runAction(action)
end

function FVBackground:onAttackShake(target_pos, frequency, aspect)
    local action_bg = self.fvActionSpec:makeActionShake_bg(frequency)

    if action_bg then self.curScene:runAction(action_bg) end
end

return FVBackground
