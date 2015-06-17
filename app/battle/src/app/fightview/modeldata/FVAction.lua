
local FVAction = class("FVAction")

function FVAction:ctor()
    self.actionUtil = getActionUtil()
    self.fvParticleManager = getFVParticleManager()
end


function FVAction:makeActionArmy_idle()
    --cclog("FVAction:makeActionArmy_idle=============>")
    local m_move1 = cc.MoveBy:create(1.0, {x = 0, y = -10})
    local m_scale1 = cc.ScaleBy:create(1.0, 0.9)
    local m_move2 = m_move1:reverse()
    local m_scale2 = m_scale1:reverse()

    local m_spawn1 = cc.Spawn:create(m_move1, m_scale1)
    local m_spawn2 = cc.Spawn:create(m_move2, m_scale2)

    local action_m = {m_spawn1, m_spawn2}

    return action_m, nil
end

function FVAction:makeActionEnemy_idle()
    --cclog("FVAction:makeActionEnemy_idle=============>")    
    local m_scale1 = cc.ScaleBy:create(1.0, 0.9)
    local m_scale2 = m_scale1:reverse()

    local action_m = {m_scale1, m_scale2}

    return action_m, nil
end

function FVAction:makeAction_json_ease(a, act)
    --cclog("FVAction:makeAction_json_ease=============>")    
    if a.easein then return cc.EaseIn:create(act, a.easein) end
    if a.easeout then return cc.EaseOut:create(act, a.easeout) end
    if a.easeinout then return cc.EaseInOut:create(act, a.easeinout) end
    if a.easesinein then return cc.EaseSineIn:create(act) end
    if a.easesineout then return cc.EaseSineOut:create(act) end
    if a.easesineinout then return cc.EaseSineInOut:create(act) end
    if a.easeexpin then return cc.EaseExponentialIn:create(act) end
    if a.easeexpout then return cc.EaseExponentialOut:create(act) end
    if a.easeexpinout then return cc.EaseExponentialInOut:create(act) end

    return act
end

function FVAction:makeAction_moveto(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_moveto=============>")     
    if not a.moveto then return nil end

    local pos
    if turn then 
        pos = cc.pSymm(a.moveto.pos)
    else 
        pos = a.moveto.pos
    end
    local tempAction = nil 
    if a.moveto.flag == 1 then
        tempAction = self:makeAction_json_ease(a.moveto, cc.MoveTo:create(dur, cc.pAdd(target_pos, pos)))
    elseif a.moveto.flag == 10 then
        local ratio = a.moveto.ratio or 0
        local pos2 = cc.p(home.point.x + (target_pos.x - home.point.x) * ratio, home.point.y + (target_pos.y - home.point.y) * ratio)
        tempAction = self:makeAction_json_ease(a.moveto, cc.MoveTo:create(dur, cc.pAdd(pos2, pos)))
    elseif a.moveto.flag == 99 then
        local finalPoint = cc.pAdd(home.point, pos)

        tempAction = self:makeAction_json_ease(a.moveto, cc.MoveTo:create(dur, finalPoint))
    end

    local function needFunction(card)

    end

    --local sequenceAction = cc.Sequence:create(cc.CallFunc:create(needFunction), tempAction)
    return tempAction
end

function FVAction:makeAction_moveby(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_moveby=============>")      
    if not a.moveby then return nil end

    local pos
    if turn then 
        pos = cc.pSymm(a.moveby.pos)
    else 
        pos = a.moveby.pos
    end

    if a.moveby.flag == 1 then
        return self:makeAction_json_ease(a.moveby, cc.MoveBy:create(dur, pos))
    end

    return nil
end

function FVAction:makeAction_bezierto(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_bezierto=============>")     
    if not a.bezierto then return nil end

    local pos1, pos2, pose
    if turn then 
        pos1 = cc.pSymm(a.bezierto.pos1)
        pos2 = cc.pSymm(a.bezierto.pos2)
        pose = cc.pSymm(a.bezierto.pose)
    else 
        pos1 = a.bezierto.pos1
        pos2 = a.bezierto.pos2
        pose = a.bezierto.pose
    end

    if a.bezierto.flag == 1 then
        return self:makeAction_json_ease(a.bezierto, cc.BezierTo:create(dur, 
            {cc.pAdd(target_pos, pos1), cc.pAdd(target_pos, pos2), cc.pAdd(target_pos, pose)}))
    elseif a.bezierto.flag == 99 then
        return self:makeAction_json_ease(a.bezierto, cc.BezierTo:create(dur, 
            {cc.pAdd(home.point, pos1), cc.pAdd(home.point, pos2), cc.pAdd(home.point, pose)}))
    end

    return nil
end

function FVAction:makeAction_bezierby(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_bezierby=============>")     
    if not a.bezierby then return nil end

    local pos1, pos2, pose
    if turn then 
        pos1 = cc.pSymm(a.bezierby.pos1)
        pos2 = cc.pSymm(a.bezierby.pos2)
        pose = cc.pSymm(a.bezierby.pose)
    else 
        pos1 = a.bezierby.pos1
        pos2 = a.bezierby.pos2
        pose = a.bezierby.pose
    end

    if a.bezierby.flag == 1 then
        return self:makeAction_json_ease(a.bezierby, cc.BezierBy:create(dur, {pos1, pos2, pose}))
    end

    return nil

end

function FVAction:makeAction_scaleto(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_scaleto=============>")    
    if not a.scaleto then return nil end

    if a.scaleto.flag == 99 then
        return self:makeAction_json_ease(a.scaleto, cc.ScaleTo:create(dur, home.scale))
    end
end

function FVAction:makeAction_scaleby(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_scaleby=============>")     
    if not a.scaleby then return nil end

    if a.scaleby.flag == 1 then
        return self:makeAction_json_ease(a.scaleby, cc.ScaleBy:create(dur, a.scaleby.scale.x, a.scaleby.scale.y))
    end
end

function FVAction:makeAction_rotateto(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_rotateto=============>")     
    if not a.rotateto then return nil end

    local rotate
    if turn then 
        rotate = a.rotateto.rotate.z
    else 
        rotate = a.rotateto.rotate.z
    end

    if a.rotateto.flag == 1 then
        return self:makeAction_json_ease(a.rotateto, cc.RotateTo:create(dur, rotate))
    elseif a.rotateto.flag == 99 then
        return self:makeAction_json_ease(a.rotateto, cc.RotateTo:create(dur, 0))
    end
end

function FVAction:makeAction_rotateby(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_rotateby=============>")    
    if not a.rotateby then return nil end

    local rotate
    if turn then 
        rotate = a.rotateby.rotate.z
    else 
        rotate = a.rotateby.rotate.z
    end

    if a.rotateby.flag == 1 then
        return self:makeAction_json_ease(a.rotateby, cc.RotateBy:create(dur, rotate))
    end
end

function FVAction:makeAction_orbitcamera(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_orbitcamera=============>")     
    if not a.orbitcamera then return nil end

    local ocz, oczd, ocx, ocxd
    if turn then 
        ocz, oczd, ocx, ocxd = -a.orbitcamera.orbit.z, -a.orbitcamera.orbit.zd, -a.orbitcamera.orbit.x, -a.orbitcamera.orbit.xd
    else 
        ocz, oczd, ocx, ocxd = a.orbitcamera.orbit.z, a.orbitcamera.orbit.zd, a.orbitcamera.orbit.x, a.orbitcamera.orbit.xd
    end

    if a.orbitcamera.flag == 1 then
        return self:makeAction_json_ease(a.orbitcamera, cc.OrbitCamera:create(dur, 
            a.orbitcamera.orbit.r, a.orbitcamera.orbit.rd, ocz, oczd, ocx, ocxd))
    end
end

function FVAction:makeAction_aminate(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_aminate=============>")  
    if not a.animate then return nil end

    local pos, rotate
    if turn then
        pos = cc.p(-a.animate.x, -a.animate.y)
        rotate = 180
    else
        pos = cc.p(a.animate.x, a.animate.y)
        rotate = 0
    end

    local frames = {}
    local spriteframe = cc.SpriteFrameCache:getInstance()

    local name = string.sub(a.animate.file, 1, -3)

    for i = 1, a.animate.num do
        frames[#frames + 1] = spriteframe:getSpriteFrame(string.format("%s%02d.png", a.animate.file, i))
        if frames[1] == nil then
            print("makeAction_aminate============================>", string.format("%s%02d.png", a.animate.file, i))
        end
    end
    -- print("a.animate.file=====", a.animate.file)
    -- table.print(frames)
    -- print("a.animate.file=====", a.animate.file)
    local function needFunction(sprite, args)
        if args.frames[1] == nil then
            return
        end
        local card =  mvc.ViewSprite()
        card:setPositionX(card:getPositionX() + args.pos.x)
        card:setPositionY(card:getPositionY() + args.pos.y)

        card:setScaleX(card:getScaleX() * args.scale)
        card:setScaleY(card:getScaleY() * args.scale)
        
        card:setRotation(card:getRotation() + args.rotate)
        card:setFlippedX(args.flip)
        card:setVisible(true)
        table.print(args)
        print("makeAction_aminate set frame=======================>", args.frames[1])
        card:setSpriteFrame(args.frames[1])
   
        local animationAnimation = cc.Animation:createWithSpriteFrames(args.frames)

        local totalDelayUnits = animationAnimation:getTotalDelayUnits()
        --local time = a.animate.num / 30 / a.animate.num
        if a.animate.delayTimes == nil then
            a.animate.delayTimes = 1
        end
        local time = 1 / 30 * a.animate.delayTimes / ACTION_SPEED
        animationAnimation:setDelayPerUnit(time)
        local loops = a.animate.num / totalDelayUnits

        animationAnimation:setLoops(loops)
        local animateAction = cc.Animate:create(animationAnimation)
        sprite:setVisible(true)
        sprite:addChild(card)
        local file = a.animate.file
        card.file = file
        local function callBack(tag)

        end
        card:runAction(cc.Sequence:create({
            animateAction,
            
            cc.Hide:create(),
            }))
        local posx, posy = sprite:getPosition()

    end
    return cc.Sequence:create({
        cc.DelayTime:create(a.animate.delta),
        cc.CallFunc:create(needFunction, {frames = frames, pos = pos, scale = a.animate.scale, rotate = rotate, flip = (a.animate.flip == 1), }),

        cc.DelayTime:create(dur - a.animate.delta),
        })
end

function FVAction:makeAction_aminateS(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_aminateS=============>")    
    if not a.animateS then return nil end

    local pos, rotate
    if turn then
        pos = cc.p(-a.animateS.x, -a.animateS.y)
        rotate = 180
    else
        pos = cc.p(a.animateS.x, a.animateS.y)
        rotate = 0
    end

    local frames = game.newFrames(string.format("%s%%02d.png", a.animateS.file), 1, a.animateS.num)

    return cc.Sequence:create({
        cc.DelayTime:create(a.animateS.delta),
        cc.CallFunc:create(function(card, args)
            local x, y = card:getPosition()
            card:dispatchEvent(const.EVENT_ATTACK_FLASH, args.frames, cc.pAdd(cc.p(x, y), args.pos), args.scale, args.rotate, args.flip)
        end, {frames = frames, pos = pos, scale = a.animateS.scale, rotate = rotate, flip = (a.animateS.flip == 1), }),
        cc.DelayTime:create(dur - a.animateS.delta),
        })
end

function FVAction:makeAction_particle(a, dur, target_pos, home, turn,scaleY)
      
    if not a.particle then return nil end

    local spawn = {}
    cclog("FVAction:makeAction_particle=============>")   
    for _, part in pairs(a.particle) do
        spawn[#spawn + 1] = cc.Sequence:create({
            cc.DelayTime:create(part.delta),
            cc.CallFunc:create(function(card)
                local part1 = getFVParticleManager():make(part.file, part.life / ACTION_SPEED, part.free == 1)
                if not part1 then return end
                part1:setPosition(part.x, part.y)
                part1:setScale(part.scale)
                card:addChild(part1, 100)
                card:setVisible(true)
                -- 是否需要将效果倒置，主要是为了无双技能
                scaleY = scaleY or 1
                part1:setScaleY(part.scale * scaleY) --ture 时 -1 ，false 时 1 
                if part.rotate == 1 then
                    local pos = nil
                    if turn then 
                        pos = cc.pSymm(a.moveto.pos)
                    else
                        if a.moveto then
                            pos = a.moveto.pos
                        else
                            pos = cc.p(0, 0)
                        end
                       
                    end
                    local point = cc.p(0, 0)
                    if a.moveto then
                        if a.moveto.flag == 1 then
                            point = cc.pAdd(target_pos, pos)
                        elseif a.moveto.flag == 10 then
                            local ratio = a.moveto.ratio or 0
                            local pos2 = cc.p(home.point.x + (target_pos.x - home.point.x) * ratio, home.point.y + (target_pos.y - home.point.y) * ratio)
                            point = cc.pAdd(pos2, pos)
                        elseif a.moveto.flag == 99 then
                            point = cc.pAdd(home.point, pos)
                        end

                        local posX, posY = card:getPosition()
                        local ratation = 0
                        if target_pos.x == point.x and target_pos.y == point.y then
                        else
                            local at = math.atan( (target_pos.y - posY) / (target_pos.x -  posX)) / math.pi * 180.0
                            ratation = 90 - at
                        end
                        part1:setStartSpin(ratation)
                        part1:setStartSizeVar(0)
                        part1:setEndSpin(ratation)
                        part1:setEndSpinVar(0)
                    end

                end

            end),
            cc.DelayTime:create(dur - part.delta),
            })
    end

    return cc.Spawn:create(spawn)
end

function FVAction:makeAction_shake(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_shake=============>")        
    if not a.shake then return nil end

    return cc.Sequence:create({
        cc.DelayTime:create(a.shake.delta / ACTION_SPEED),
        cc.CallFunc:create(function(card, args)
        card:dispatchEvent(const.EVENT_ATTACK_ITEM_SHAKE, target_pos, args.frequency, args.aspect)
        end, {frequency = a.shake.frequency, aspect = a.shake.flag}),
        cc.DelayTime:create(dur - a.shake.delta),
        })
end

function FVAction:makeAction_shook(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_shook=============>")     
    if not a.shook then return nil end

    local function shookFunction(card, args)
        local rotateActionA = cc.RotateTo:create(args._time / ACTION_SPEED, args.frequency)

        local rotateActionB = cc.RotateTo:create(args._time / ACTION_SPEED, -args.frequency)
        local sequenceAction = cc.Sequence:create(rotateActionA, rotateActionB)
 
        local repeatAction = cc.RepeatForever:create(sequenceAction)
        
        repeatAction:setTag(100)
        local function removeAction(card)
            card:stopActionByTag(100)
            local rotateAction= cc.RotateTo:create(0, 0)
            card:runAction(rotateAction)
        end

        local deltaAction = cc.Sequence:create(cc.DelayTime:create(args.duration / ACTION_SPEED), cc.CallFunc:create(removeAction))
        card:runAction(repeatAction)
        card:runAction(deltaAction)
    end

    --local time = dur - a.shook.delta - a.shook.duration
    local time = dur - a.shook.delta
    if time < 0 then
        time = 0
    end

    return cc.Sequence:create({
        cc.DelayTime:create(a.shook.delta),

        cc.CallFunc:create(shookFunction, {frequency = a.shook.frequency, duration = a.shook.duration, _time = a.shook.time}),
        cc.DelayTime:create(time),

        })

    -- data.shook = {}
    --     data.shook.flag = shookFlag
    --     data.shook.delta = tonumber(self.editShookDlt:getText()) or 0
    --     data.shook.frequency = tonumber(self.editShookFrequency:getText()) or 0

end

function FVAction:makeAction_slow(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_slow=============>")     
    if not a.slow then return nil end

    return cc.Sequence:create({
        cc.DelayTime:create(a.slow.delta),
        cc.CallFunc:create(function(card, args)
            card:dispatchEvent(const.EVENT_SLOW_DOWN, a.slow.dur, a.slow.speed)
        end),
        cc.DelayTime:create(dur - a.slow.delta),
        })
end

function FVAction:makeAction_focus(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_focus=============>")    
    if not a.focus then return nil end

    local pos
    if turn then
        pos = cc.p(-a.focus.x, -a.focus.y)
    else
        pos = cc.p(a.focus.x, a.focus.y)
    end

    return cc.Sequence:create({
        cc.DelayTime:create(a.focus.delta),
        cc.CallFunc:create(function(card, args)
            local x, y = card:getPosition()
            card:dispatchEvent(const.EVENT_CAMERA_FOCUS, args.dur, cc.pAdd(cc.p(x, y), args.pos), args.scale)
        end, {pos = pos, dur = a.focus.dur, scale = a.focus.scale}),
        cc.DelayTime:create(dur - a.focus.delta),
        })
end

function FVAction:makeAction_fadeto(a, dur, target_pos, home, turn)
    --cclog("FVAction:makeAction_fadeto=============>")    
    if not a.fadeto then return nil end

    if a.fadeto.flag == 1 then
        return self:makeAction_json_ease(a.fadeto, cc.FadeTo:create(dur, a.fadeto.opacity))
    end
end

function FVAction:makeAction_json(action_c, target_pos, home, turn,scaleY)
    -- cclog("FVAction:makeAction_json=============>")     
    local action_m = {}
    local action_n = {}
    local action_a = {}
    local delta_m = 0
    local delta_n = 0
    local delta_a = 0
    
    table.print(action_c)
    scaleY = scaleY or 1
    for i=1, #action_c do
        local spawn_m = {}
        local spawn_n = {}
        local spawn_a = {}
        local action_tmp = nil

        local a = action_c[i]
        local dur = a.dur / ACTION_SPEED
    
        action_tmp = self:makeAction_moveto(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end

        action_tmp = self:makeAction_moveby(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_bezierto(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_bezierby(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
    
        action_tmp = self:makeAction_scaleto(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_scaleby(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_rotateto(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_rotateby(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_orbitcamera(a, dur, target_pos, home, turn)
        if action_tmp then spawn_n[#spawn_n + 1] = action_tmp end

        action_tmp = self:makeAction_aminate(a, dur, target_pos, home, turn)
        if action_tmp then spawn_a[#spawn_a + 1] = action_tmp end
     
        action_tmp = self:makeAction_aminateS(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end

        action_tmp = self:makeAction_particle(a, dur, target_pos, home, turn,scaleY)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end

        action_tmp = self:makeAction_shake(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end

        action_tmp = self:makeAction_shook(a, dur, target_pos, home, turn) ----------
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_slow(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
        
        action_tmp = self:makeAction_focus(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end

        action_tmp = self:makeAction_fadeto(a, dur, target_pos, home, turn)
        if action_tmp then spawn_m[#spawn_m + 1] = action_tmp end
  
        if #spawn_m == 0 then
            delta_m = delta_m + dur
        else
            action_m[#action_m + 1] = cc.Sequence:create({
                cc.DelayTime:create(delta_m),
                cc.Spawn:create(spawn_m),
                })
            delta_m = 0
        end

        if #spawn_n == 0 then
            delta_n = delta_n + dur
        else
            action_n[#action_n + 1] = cc.Sequence:create({
                cc.DelayTime:create(delta_n),
                cc.Spawn:create(spawn_n),
                })
            delta_n = 0
        end

        if #spawn_a == 0 then
            delta_a = delta_a + dur
        else
            action_a[#action_a + 1] = cc.Sequence:create({
                cc.DelayTime:create(delta_a),
                cc.Spawn:create(spawn_a),
                })
            delta_a = 0
        end
     
    end

    delta_min = math.min(delta_m, delta_n, delta_a)
    if delta_min ~= 0 then
        if delta_min == delta_m then
            action_m[#action_m + 1] = cc.DelayTime:create(delta_m)
        elseif delta_min == delta_n then
            action_n[#action_n + 1] = cc.DelayTime:create(delta_n)
        else
            action_a[#action_a + 1] = cc.DelayTime:create(delta_a)
        end
    end

    return cc.Sequence:create(action_m), cc.Sequence:create(action_n), cc.Sequence:create(action_a)
end
--组织红方特效
function FVAction:makeActionFront(no, target_pos, home)
    --cclog("FVAction:makeActionFront=============>")       
    local actions = self.actionUtil.data
    if not actions[no] then return {} end

    local ret = {}

    ret.actionm_card, ret.actionn_card, ret.actiona_card = self:makeAction_json(actions[no].card, target_pos, home, false)

    ret.actionm_board, ret.actionn_board, ret.actiona_board = self:makeAction_json(actions[no].board, target_pos, home, false)
    ret.actionm_hero, ret.actionn_hero, ret.actiona_hero = self:makeAction_json(actions[no].hero, target_pos, home, false)

    ret.actionm_bullet1, ret.actionn_bullet1, ret.actiona_bullet1 = self:makeAction_json(actions[no].bullet1, target_pos, home, false)
    ret.actionm_bullet2, ret.actionn_bullet2, ret.actiona_bullet2 = self:makeAction_json(actions[no].bullet2, target_pos, home, false)
    ret.actionm_bullet3, ret.actionn_bullet3, ret.actiona_bullet3 = self:makeAction_json(actions[no].bullet3, target_pos, home, false)

    return ret
end

--组织蓝方特效
function FVAction:makeActionHind(dataTable)
    --cclog("FVAction:makeActionHind=============>") 
    local actEffect = dataTable.actEffect
    local no = dataTable.no
    local target_pos = dataTable.target_pos
    local home = dataTable.home

    local actions = self.actionUtil.data
    if not actions[no] then return {} end

    local ret = {}
    local isTurn = self:getIsTurn(actEffect)
    print("Action Effect ===========>",actEffect,no)
    local scale = self:getEffectScaleY(actEffect)
    ret.actionm_card, ret.actionn_card, ret.actiona_card = self:makeAction_json(actions[no].card, target_pos, home, isTurn,scale)
    ret.actionm_board, ret.actionn_board, ret.actiona_board = self:makeAction_json(actions[no].board, target_pos, home, isTurn,scale)
    ret.actionm_hero, ret.actionn_hero, ret.actiona_hero = self:makeAction_json(actions[no].hero, target_pos, home, isTurn,scale)
    ret.actionm_bullet1, ret.actionn_bullet1, ret.actiona_bullet1 = self:makeAction_json(actions[no].bullet1, target_pos, home, isTurn,scale)
    ret.actionm_bullet2, ret.actionn_bullet2, ret.actiona_bullet2 = self:makeAction_json(actions[no].bullet2, target_pos, home, isTurn,scale)
    ret.actionm_bullet3, ret.actionn_bullet3, ret.actiona_bullet3 = self:makeAction_json(actions[no].bullet3, target_pos, home, isTurn,scale)

    return ret
end

function FVAction:getIsTurn(actEffect)   
    local result = true
    if actEffect >= 90021 and actEffect <= 90024 then
        result = false
    end

    if actEffect >= 30001 and actEffect <= 30036 then
        result = false
    end

    return result
end

--判断是否为无双ID,无双在蓝方需要翻转
function FVAction:getEffectScaleY(actEffect)
    local scaleY = 1
    if actEffect >= 40001 and actEffect < 40026 then
        scaleY = -1
    end
    return scaleY
end

return FVAction









