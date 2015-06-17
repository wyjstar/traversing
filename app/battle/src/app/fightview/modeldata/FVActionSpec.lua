
local FVActionSpec = class("FVActionSpec")

function FVActionSpec:ctor()
   
end

function FVActionSpec:makeActionShake_1(target_pos, home)
    local dlt_x, dlt_y = home.point.x - target_pos.x, home.point.y - target_pos.y
    local move_x, move_y = 0, 0

    if dlt_x ~= 0 or dlt_y ~= 0 then
        local l = 6000 / math.max(120, math.sqrt(dlt_x * dlt_x + dlt_y * dlt_y))
        local angle = math.atan2(dlt_y, dlt_x)
        move_x, move_y = l * math.cos(angle), l * math.sin(angle)
    end

    return cc.Sequence:create({
        cc.MoveBy:create(0.1, {x = move_x, y = move_y}),
        cc.MoveBy:create(0.1, {x = -move_x, y = -move_y}),
        })
end

function FVActionSpec:makeActionShake_2()
    local angle = math.random(-5, 5)

    return cc.Sequence:create({
        cc.EaseSineOut:create(cc.Spawn:create({
            cc.ScaleBy:create(0.15, 1.1),
            cc.RotateBy:create(0.15, angle),
            })),
        cc.EaseSineIn:create(cc.Spawn:create({
            cc.ScaleBy:create(0.15, 1.0/1.1),
            cc.RotateBy:create(0.15, -angle),
            })),
        })
end

function FVActionSpec:makeShakeRepeatAction()
    --local repeatMove = createRepeatAction(cc.Sequence:create(act1, act2))
    local t = 0.3
    local sequence =  cc.Sequence:create({
        cc.MoveBy:create(t * 0.16, {x = 6, y = 0}),
        cc.MoveBy:create(t * 0.32, {x = -11, y = 0}),
        cc.MoveBy:create(t * 0.24, {x = 9, y = 0}),
        cc.MoveBy:create(t * 0.16, {x = -7, y = 0}),
        cc.MoveBy:create(t * 0.12, {x = 3, y = 0}),
        })
    local repeatAction = createRepeatAction(sequence)

    return repeatAction
end

function FVActionSpec:makeActionShake_card(frequency)
    if frequency == 1 then
        local t = 0.15
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.25, {x = 6, y = 0}),
            cc.MoveBy:create(t * 0.5, {x = -10, y = 0}),
            cc.MoveBy:create(t * 0.25, {x = 4, y = 0}),
            })
    end
    
    if frequency == 2 then
        local t = 0.3
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.16, {x = 6, y = 0}),
            cc.MoveBy:create(t * 0.32, {x = -11, y = 0}),
            cc.MoveBy:create(t * 0.24, {x = 9, y = 0}),
            cc.MoveBy:create(t * 0.16, {x = -7, y = 0}),
            cc.MoveBy:create(t * 0.12, {x = 3, y = 0}),
            })
    end

    if frequency == 3 then
        local t = 0.4
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.11, {x = 6, y = 0}),
            cc.MoveBy:create(t * 0.22, {x = -12, y = 0}),
            cc.MoveBy:create(t * 0.22, {x = 12, y = 0}),
            cc.MoveBy:create(t * 0.17, {x = -10, y = 0}),
            cc.MoveBy:create(t * 0.11, {x = 8, y = 0}),
            cc.MoveBy:create(t * 0.11, {x = -6, y = 0}),
            cc.MoveBy:create(t * 0.06, {x = 2, y = 0}),
            })
    end

    if frequency == 4 then
        local t = 0.5
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.08, {x = 6, y = 0}),
            cc.MoveBy:create(t * 0.16, {x = -12, y = 0}),
            cc.MoveBy:create(t * 0.16, {x = 12, y = 0}),
            cc.MoveBy:create(t * 0.16, {x = -12, y = 0}),
            cc.MoveBy:create(t * 0.14, {x = 12, y = 0}),
            cc.MoveBy:create(t * 0.12, {x = -10, y = 0}),
            cc.MoveBy:create(t * 0.1, {x = 8, y = 0}),
            cc.MoveBy:create(t * 0.05, {x = -6, y = 0}),
            cc.MoveBy:create(t * 0.03, {x = 2, y = 0}),
            })
    end

    return nil
end

function FVActionSpec:makeActionShake_bg(frequency)
    if frequency == 1 then
        local t = 0.15
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.2, {x = 4, y = 0}),
            cc.MoveBy:create(t * 0.35, {x = -7, y = 0}),
            cc.MoveBy:create(t * 0.15, {x = 3, y = 0}),
            })
    end

    if frequency == 2 then
        local t = 0.3
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.13, {x = 4, y = 0}),
            cc.MoveBy:create(t * 0.25, {x = -8, y = 0}),
            cc.MoveBy:create(t * 0.19, {x = 7, y = 0}),
            cc.MoveBy:create(t * 0.13, {x = -5, y = 0}),
            cc.MoveBy:create(t * 0.09, {x = 2, y = 0}),
            })
    end

    if frequency == 3 then
        local t = 0.4
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.09, {x = 4, y = 0}),
            cc.MoveBy:create(t * 0.18, {x = -8, y = 0}),
            cc.MoveBy:create(t * 0.15, {x = 7, y = 0}),
            cc.MoveBy:create(t * 0.09, {x = -5, y = 0}),
            cc.MoveBy:create(t * 0.05, {x = 2, y = 0}),
            })
    end

    if frequency == 4 then
        local t = 0.5
        return cc.Sequence:create({
            cc.MoveBy:create(t * 0.06, {x = 4, y = 0}),
            cc.MoveBy:create(t * 0.12, {x = -8, y = 0}),
            cc.MoveBy:create(t * 0.12, {x = 8, y = 0}),
            cc.MoveBy:create(t * 0.12, {x = -8, y = 0}),
            cc.MoveBy:create(t * 0.10, {x = 6, y = 0}),
            cc.MoveBy:create(t * 0.06, {x = -4, y = 0}),
            cc.MoveBy:create(t * 0.03, {x = 2, y = 0}),
            })
    end

    return nil
end

--友方前进
function FVActionSpec:makeActionInterlude_army()
    return cc.Sequence:create({
        cc.DelayTime:create(0.5 / ACTION_SPEED),
        cc.Spawn:create({
            cc.MoveBy:create(0.3 / ACTION_SPEED, cc.p(0, -20)),
            cc.ScaleBy:create(0.3, 1.1),
            cc.OrbitCamera:create(0.3, 1, 0, 0, -25, 90, 0),
            }),
        cc.DelayTime:create(0.2 / ACTION_SPEED),
        cc.Spawn:create({
            cc.MoveBy:create(0.1 / ACTION_SPEED, cc.p(0, 20)),
            cc.ScaleBy:create(0.1 / ACTION_SPEED, 1.0/1.1),
            cc.OrbitCamera:create(0.1 / ACTION_SPEED, 1, 0, -25, 25, 90, 0),
            }),
        cc.Spawn:create({
            cc.MoveBy:create(0.2 / ACTION_SPEED, cc.p(0, 30)),
            }),
        cc.Spawn:create({
            cc.ScaleBy:create(0.3 / ACTION_SPEED, 1.2),
            cc.OrbitCamera:create(0.3 / ACTION_SPEED, 1, 0, 0, 25, 90, 0)
            }),
        cc.Spawn:create({
            cc.MoveBy:create(0.1 / ACTION_SPEED, cc.p(0, -30)),
            cc.ScaleBy:create(0.1 / ACTION_SPEED, 1.0/1.2),
            cc.OrbitCamera:create(0.1 / ACTION_SPEED, 1, 0, 25, -25, 90, 0),
            }),
        })
end

--敌方进来
function FVActionSpec:makeActionInterlude_enemy()
    return cc.Sequence:create({
        cc.DelayTime:create(0.6),
        cc.MoveBy:create(0.0, cc.p(0, 500)),
        cc.Show:create(),
        cc.DelayTime:create(0.1),
        cc.EaseSineInOut:create(cc.MoveBy:create(0.3, cc.p(0, -500))),
        })
end

function FVActionSpec:makeActionInterlude_bg(dis)
    return cc.Sequence:create({
        cc.DelayTime:create(1.0 / ACTION_SPEED),
        cc.EaseSineInOut:create(cc.MoveBy:create(0.6, cc.p(0, -dis))),
        })
end

function FVActionSpec:makeActionDead()
    local function r(a)
        return a * (BIG_SCALE + math.random() * 0.6)
    end

    local action0 = cc.Sequence:create({
        cc.ScaleBy:create(0.0, 1),
        })

    local action1 = cc.Sequence:create({
        cc.DelayTime:create(0.0),
        cc.EaseOut:create(cc.Spawn:create({
            cc.MoveBy:create(0.15, cc.p(0, r(15))),
            }), 7),
        })

    local action2 = cc.Sequence:create({
        cc.DelayTime:create(0.0),
        cc.EaseOut:create(cc.Spawn:create({
            cc.MoveBy:create(0.2, cc.p(r(-15), r(-10))),
            cc.RotateBy:create(0.2, r(-5)),
            }), 7),
        })

    local action3 = cc.Sequence:create({
        cc.DelayTime:create(0.0),
        cc.EaseOut:create(cc.Spawn:create({
            cc.MoveBy:create(0.15, cc.p(r(10), r(-20))),
            cc.RotateBy:create(0.15, r(20)),
            }), 7),
        })

    local action4 = cc.Sequence:create({
        cc.DelayTime:create(0.0),
        cc.EaseOut:create(cc.Spawn:create({
            cc.MoveBy:create(0.15, cc.p(r(30), r(20))),
            cc.RotateBy:create(0.15, r(10)),
            }), 7),
        })

    local action5 = cc.Sequence:create({
        cc.DelayTime:create(0.0),
        cc.EaseOut:create(cc.Spawn:create({
            cc.MoveBy:create(0.2, cc.p(r(-20), r(-40))),
            cc.RotateBy:create(0.2, r(10)),
            }), 7),
        })

    return action0, action1, action2, action3, action4, action5
end

function FVActionSpec:makeBoddyComeIn()
    
end

function FVActionSpec:makeArmyFirstIn()
    local function callBack1(sender)
        sender:setVisible(true)
    end

    local scaleToAction = cc.ScaleTo:create(0, 0.65)
    local scaleToAction1 = cc.ScaleTo:create(0.15, 0.68)
    local scaleTo1 = cc.EaseOut:create(scaleToAction1, 0.8)
    local delayAction = cc.DelayTime:create(0.16)
    local scaleToAction2 = cc.ScaleTo:create(0.05, BIG_SCALE)
    local scaleTo2 = cc.EaseOut:create(scaleToAction2, 0.8)

    local sequenceAction = cc.Sequence:create(cc.CallFunc:create(callBack1), scaleToAction, scaleTo1, delayAction, scaleTo2)
    return sequenceAction
end

function FVActionSpec:makeBloodAction()
    local scaleToAction1 = cc.ScaleTo:create(0.1, 1.3)
    local scaleToAction2 = cc.ScaleTo:create(0.1, 1)
    return cc.Sequence:create(scaleToAction1, scaleToAction2)
end

function FVActionSpec:makeBossInAction()
    local sequence1 = cc.Sequence:create({
        cc.ScaleTo:create(0, 0.3),
        cc.MoveBy:create(0.0, cc.p(0, 500)),
        cc.Show:create(),
        --cc.DelayTime:create(0.5),
        cc.EaseSineInOut:create(cc.MoveBy:create(0.3, cc.p(0, -500))),
        cc.DelayTime:create(0.2),
        cc.ScaleTo:create(0.1, 0.4),
        -- cc.Hide:create(),
        })
 
    -- local dur = 0.1
    -- local times = 10
    -- local finalDur = 0

    -- local rotateBy = cc.RotateBy:create(dur , 360)
    -- local actionTable = {}
    -- for i = 1, times do
    --     table.insert(actionTable, rotateBy:clone())
    --     finalDur = finalDur + dur
    -- end
    --cclog("finalDur=======" .. finalDur)
    -- local sequence2 = cc.Sequence:create(actionTable)
    -- local scaleTo2 = cc.ScaleTo:create(finalDur, BOSS_SCALE + 0.5)
    -- local spwnAction = cc.Spawn:create(sequence2, scaleTo2)

    -- local delayTimeAction = cc.DelayTime:create(0.3)
    -- local scaleTo3 = cc.ScaleTo:create(0.05, BOSS_SCALE)
    -- local finalAction = cc.Sequence:create(sequence1, spwnAction, delayTimeAction, scaleTo3)
    local function callBack(sender)
        sender:addBossEffect()
    end

    local delayTimeAction = cc.DelayTime:create(1.8)
    local scaleTo2 = cc.ScaleTo:create(0, BIG_SCALE)

    local finalAction = cc.Sequence:create(sequence1, delayTimeAction, scaleTo2, cc.CallFunc:create(callBack))
    return finalAction


end

return FVActionSpec





