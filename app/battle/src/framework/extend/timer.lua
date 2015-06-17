
timer = timer or {}

local sharedScheduler = cc.Director:getInstance():getScheduler()

function timer.scheduleUpdateGlobal(listener)
    return sharedScheduler:scheduleScriptFunc(listener, 0, false)
end

function timer.scheduleGlobal(listener, interval)
    return sharedScheduler:scheduleScriptFunc(listener, interval, false)
end

function timer.unscheduleGlobal(handle)
    sharedScheduler:unscheduleScriptEntry(handle)
end

function timer.delayGlobal(listener, time)
    local handle
    handle = sharedScheduler:scheduleScriptFunc(function()
        timer.unscheduleGlobal(handle)
        listener()
    end, time, false)
    return handle
end

function timer.delayPlayHit(listener, time, buffIndex, actionIdxAttack, actionsMaxValue)
    local handle
    local function callBack()
        timer.unscheduleGlobal(handle)
        listener(buffIndex, actionIdxAttack, actionsMaxValue)
    end

    handle = sharedScheduler:scheduleScriptFunc(callBack, time, false)
    return handle
end
function timer.delayAction(listener, node, args, time)
    if args then
        node:runAction(cc.Sequence:create({
            cc.DelayTime:create(time),
            cc.CallFunc:create(listener, args),
            }))
    else
        node:runAction(cc.Sequence:create({
            cc.DelayTime:create(time),
            cc.CallFunc:create(listener),
            }))
    end
end
