
local FVCardImage = class("FVCardImage", function()
    return mvc.ViewNode()
end)

function FVCardImage:ctor(prop, no)
    self:init(prop, no)
end

function FVCardImage:init(prop, no)
    self.unit = prop
    if self.unit == nil then
        return
    end
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.resourceData = getDataManager():getResourceData()
    --local pictureName = prop.pictureName
    local is_awake = self.unit.is_awake
    local is_break = self.unit.is_break
    local soldierId = no or self.unit.no
    -- local pictureName, res = self.soldierTemplate:getHeroImageName(soldierId)
    local pictureName = self.unit.pictureName
    local res = self.unit.resFrame
    cclog("FVCardImage========pictureName====" .. pictureName)
    -- self.heroN = self.soldierTemplate:getBigImageByResName(pictureName, soldierId)

    self.heroN = self.soldierTemplate:getBigImageByResName(pictureName)
    local effect_idle = cc.RepeatForever:create(cc.Sequence:create({
            cc.EaseSineInOut:create(cc.Spawn:create({
                cc.MoveBy:create(1, {x = 6, y = 1}),
                cc.ScaleBy:create(1, 1.06, 1.0),
                })),
            cc.EaseSineInOut:create(cc.Spawn:create({
                cc.MoveBy:create(1, {x = -6, y = -1}),
                cc.ScaleBy:create(1, 1.0/1.06, 1.0),
                })),
        }))
    local effecta = self.heroN:getChildByTag(1)
    local effectb = self.heroN:getChildByTag(2)

    local is_boss = prop.is_boss
    if effecta then 
        if is_boss then
           cclog("effecta-------------")
        end
        effecta:runAction(effect_idle)
    end
    if effectb then 
        if is_boss then
           cclog("effectbbbbbbbbbbbbb-------------")
        end
        effectb:runAction(effect_idle:clone())
    end

    self.heroA = mvc.ViewSprite()
    self.heroA:setVisible(false)
    self.heroA:setCascadeOpacityEnabled(true)

    self:setCascadeOpacityEnabled(true)

    self:addChild(self.heroN, 10)

    self:addChild(self.heroA, 20)

    self:setVisible(true)
    local node = nil
    if is_awake or is_break then
        local node = self:getMEffect(soldierId)
        node:setScale(1.5)
        self.heroN:addChild(node, 30)
        node:setPosition(160, 155)
    end
end

function FVCardImage:addBossEffect()
    local node = UI_bosslaixichixu()
    node:setScaleX(1.5)
    node:setPosition(0, -80)
    self:addChild(node, 40)
end

function FVCardImage:isShowEffect(state)
    local effecta = self.heroN:getChildByTag(1)
    local effectb = self.heroN:getChildByTag(2)
    if effecta then
        effecta:setVisible(state)
    end
    if effectb then
        effectb:setVisible(state)
    end
end

function FVCardImage:setCardClean()
    self.heroA:stopAllActions()
    self.heroA:setPosition(0, 0)
    self.heroA:setScale(1)
    self.heroA:setRotation(0)

    self.heroN:setRotation(0)
    self.heroN:setAdditionalTransform({a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 0})
end

function FVCardImage:stopMNAction()
    self:stopAllActions()
    self.heroN:stopAllActions()
end

-----
function FVCardImage:playAction_idle()
    self:stopAllActions()

    self:setPosition(self.home.point)
    self:setScale(self.home.scale)
    self:setRotation(0)
    self:setAdditionalTransform({a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 0})

    local dlt = 1 + math.random() * 0.2

    local action1 = cc.ScaleBy:create(dlt, 1.06)
    local action = cc.RepeatForever:create(cc.Sequence:create({action1, action1:reverse(), }))

    self:runAction(action)
end

-------
function FVCardImage:playAction_shake(target_pos, aspect)
    if aspect == 1 then
        local action = FVActionSpec.makeActionShake_1(target_pos, self.home)

        self:runAction(action)
    elseif aspect == 2 then
        local action = FVActionSpec.makeActionShake_2()

        self:runAction(action)
    end
end

function FVCardImage:getMEffect(heroId)
    local item = self.soldierTemplate:getHeroTempLateById(heroId)

    local node = game.newNode()
    if item ~= nil then
        print("heroId=======" .. heroId)
        if heroId == 10065 then --魔赵云
            return UI_mozhaoyun()

        elseif heroId == 30051 then --魔项羽

            return UI_moxiangyu()
        -- elseif heroId == 20046 then --魔关羽
        --     return UI_moguanyu()
        elseif heroId == 20048 then  --吕布
            return UI_molvbu()
        -- elseif heroId == 10069 then --魔貂蝉
        --     return UI_modiaochan()
        elseif heroId == 20041 then --圣张合
            return UI_shengzhanghe()

        elseif heroId == 20042 then --圣小乔
            return UI_shengxiaoqiao()

        elseif heroId == 20043 then --圣大乔
            return UI_shengdaqiao()
            
        elseif heroId == 20044 then --圣刘备
            return UI_shengliubei()

        elseif heroId == 20045 then --圣关羽
            return UI_shengguanyu()

        elseif heroId == 20055 then --圣太史慈
            return UI_shengtaishici()

        elseif heroId == 20053 then --圣典韦
            return UI_shengdianwei()
        elseif heroId == 20061 then --圣貂蝉
            return UI_shengdiaochan()

        elseif heroId == 20056 then --圣赵云
            return UI_shengzhaoyun()

        elseif heroId == 20046 then --圣张飞
            return UI_shengzhangfei()

        elseif heroId == 20055 then --圣太史慈
            return UI_shengtaishici()

        elseif heroId == 30057 then --魔李元霸
            return UI_moliyuanba()

        elseif heroId == 30060 then --魔李广
            return UI_moliguang()
        elseif heroId == 20047 then --圣张角
           return UI_shengzhangjiao()

        elseif heroId == 20049 then --圣张辽
           return UI_shengzhangliao()
        elseif heroId == 20052 then --圣周瑜
           return UI_shengzhouyu()
        elseif heroId == 20054 then --圣孙坚
           return UI_shengsunjian()
        elseif heroId == 20058 then --圣袁绍
           return UI_shengyuanshao()
        elseif heroId == 20062 then --圣黄月英
           return UI_shenghuangyueying()
        elseif heroId == 30059 then --魔荆轲
           return UI_mojingke()
        elseif heroId == 30063 then --魔刘邦
           return UI_moliubang()
        end
    end

    return node
end

return FVCardImage
