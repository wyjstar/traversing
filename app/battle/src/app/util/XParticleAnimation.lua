
--创建粒子
-- @pram _particleFile 粒子名称
-- @pram _isFree 是否拖尾
function createParticle(_particleFile, _pt, _isFree)
    --local baseNode = BaseAnimation.new()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    local part = cc.ParticleSystemQuad:create(string.format("res/part/%s.plist", _particleFile))
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    if _isFree == nil then
        _isFree = true
    end
    part:setAnchorPoint(cc.p(0.5, 0.5))

    if _isFree then
        part:setPositionType(cc.POSITION_TYPE_FREE)
    else
        part:setPositionType(cc.POSITION_TYPE_RELATIVE)
    end
    
    --baseNode:addChild(part)
    if _pt ~= nil then
        part:setPosition(_pt)
    end

    return part
end

--创建totle 重复动作
--delta 间隔
--times 次数
--_function 方法名
function createTotleNodeAction(tempNode, _function, delta, times)
    local tempTimes = 1

    local function runTheAction()

        local node = _function()
        tempNode:addChild(node)
    end

    local sequenceAction = createSequence(createCallFun(runTheAction), createParticleDelay(delta))

    local repeatAction = createRepeatAction(sequenceAction)
    repeatAction:setTag(100)


    local function removeFunction(node)
        node:stopActionByTag(100)
    end

    local removeSequenceAction = createSequence(createParticleDelay(delta * times - 1), createCallFun(removeFunction))

    tempNode:runAction(repeatAction)
    tempNode:runAction(removeSequenceAction)
end

--水平翻转
function createFlipXAction(dur)
    return cc.FlipX3D:create(dur)
end

--垂直翻转
function createFlipYAction(dur)
    return cc.FlipY3D:create(dur)
end

--创建重复动作
function createRepeatAction(action)
    return cc.RepeatForever:create(action)
end

 -- 粒子移动动作
 -- @parm _to 到哪里去
 -- @parm _duration 需要移动的时间
 -- @parm _removeDelay 移动完成后，多少秒消失
function createParticleMove(_to, _duration, _removeDelay)

    local actionMove = cc.MoveTo:create(_duration, _to)
    local actionDelayTime = cc.DelayTime:create(_removeDelay)
    local sequenceAction =  cc.Sequence:create(actionMove, actionDelayTime)
    return sequenceAction
end

-- 粒子显示动作
-- @pram _particleFile 粒子名称
-- @pram _pt 在哪里显示
-- @parm _duration 显示多长时间
-- @parm _removeDelay 显示duration时间后，多少秒消失
function createParticleShow( _duration, _removeDelay, _pt)

    local actionDuration = cc.DelayTime:create(_duration)
    local removeDelayDuration = cc.DelayTime:create(_removeDelay)

    local sequenceAction =  cc.Sequence:create(actionDuration, removeDelayDuration)
    return sequenceAction
end

function createTotleAction( ... )
    local node = cc.Node:create()
    local nodeTable = { ... }

    local size = table.getn(nodeTable)
    local index = 1
    --print("createTotleAction==========")
    --table.printKey(nodeTable)

    while(index < size) do
        --print("index=====" .. index)
        local nodeItem = nodeTable[index]
        local actionItem = nodeTable[index + 1]
        nodeItem:runAction(actionItem)
        node:addChild(nodeItem)

        index = index + 2
    end

    return node
end

--重新运行动作
function createRestartAction()
    --resetSystem
    local function restartFunction( particle )
        if particle ~= nil and particle.resetSystem ~= nil then
            particle:resetSystem()
        end
    end
    return cc.CallFunc:create(restartFunction)
end

 -- 创建序列帧
 -- @parm fileName 文件名字
 -- @parm num  资源张数
 -- @parm delayTimes 倍率
function createAnimation(fileName,framename, num, delayTimes, loops)

    local frames = {}
    local spriteframe = cc.SpriteFrameCache:getInstance()
    spriteframe:addSpriteFrames("res/animate/"..fileName)

    for i = 1, num do
        print(string.format("%s%02d.png", framename, i))
        frames[#frames + 1] = spriteframe:getSpriteFrame(string.format("%s%d.png", framename, i))

    end

    local animationAnimation = cc.Animation:createWithSpriteFrames(frames)
    --getLoops
    local totalDelayUnits = animationAnimation:getTotalDelayUnits()
    --local time = a.animate.num / 30 / a.animate.num
    if delayTimes == nil then
        delayTimes = 1
    end

    local time = 1 / 30 * delayTimes
    animationAnimation:setDelayPerUnit(time)

    if loops == nil then
        loops = 1
    end

    animationAnimation:setLoops(loops)

    local animateAction = cc.Animate:create(animationAnimation)
    return animateAction
end

--创建显示或者隐藏
function createVistbleAction(isShow)
    local function setVisibleFunction( particle )
       particle:setVisible(isShow)
    end
    
    return cc.CallFunc:create(setVisibleFunction) 
end

--创建消失
function createParticleOut(delayTime, func)
    local delayAction = nil

    if delayTime ~= nil then
        delayAction = createParticleDelay(delayTime)
    end

    local function outFunction(sprite)
        sprite:removeFromParent()
        if func ~= nil then
            func()
        end
    end
    --
    local function stopFucntion(particle)
        -- particle:setEmissionRate(0 / particle:getLife())
    end

    return cc.Sequence:create(cc.CallFunc:create(stopFucntion), delayAction, cc.CallFunc:create(outFunction))
end


--延时动作
function createParticleDelay(_duration)
    return cc.DelayTime:create(_duration)
end

--创建队列动作
function createSequence( ... )
    return cc.Sequence:create( ... )
end

--动作同时播放
function createSpawn( spawn, ... )
    return cc.Spawn:create( spawn, ... )
end

--创建贝塞尔曲线
function createBezier(dur, ...)
    return cc.BezierTo:create(dur, { ... })
end

--创建随机
--pos1, pos2,两个中间点
--pos3，终点
--rv1：第一个点得随机半径
--rv2：第二个点得随机半径
function createRandomBezier(dur, pos1, pos2, pos3, rv1, rv2)
    if rv1 ~= nil then
        pos1 = getRandomPos(pos1, rv1)
    end

    if rv2 ~= nil then
        pos2 = getRandomPos(pos2, rv2)
    end
    return cc.BezierTo:create(dur, { pos1, pos2, pos3 })
end

--获取随机点
function getRandomPos(_pos, _rv)
    local posX = _pos.x 
    local posY = _pos.y
    local dir = math.random(0, 365)
    local rad = nil
    if _rv < 0 then rad = math.random(_rv, 0)
    else rad = math.random(0, _rv)
    end
    local angle = dir / 180 * math.pi
    local width = math.cos(angle) * rad
    local height = math.sin(angle) * rad
    print("width===" .. width)
    print("height===" .. height)
    return cc.p(posX + width, posY + height)
end

--旋转到
function createRotateTo(_dur, _fl)
    return cc.RotateTo:create(_dur, _fl)
end

--旋转by
function createRotateBy(_dur, _fl)
    return cc.RotateBy:create( _dur, _fl)
end

--回调
function createCallFun(_hander)
    return cc.CallFunc:create(_hander)
end

--放大缩小
function createScaleTo(_duration, _scaleX, _scaleY)
    return cc.ScaleTo:create(_duration, _scaleX, _scaleY)
end

--放大缩小
function createScaleBy(_duration, _scaleX, _scaleY)
    return cc.ScaleBy:create(_duration, _scaleX, _scaleY)
end

--淡入淡出
function createFadeTo(_duration, _opacity)
    return cc.FadeTo:create(_duration, _opacity)
end

--淡出
function createFadeOut(_duration)
    return cc.FadeOut:create(_duration)
end

--淡入
function createFadeIn(_duration)
    return cc.FadeIn:create(_duration)
end


function UI_gongxihuodejiemian()--恭喜获得界面
    -- 战利品
    local particleOne = createParticle("ui_b005301", cc.p(0,3)) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(99999999)--持续时间
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --电边
    local particleTwo = createParticle("ui_b005302", cc.p(0,0)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(99999999)
    local stopActionTwo = createParticleOut(0.5)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)
     
    local node = createTotleAction(particleOne, sequenceActionOne,particleTwo, sequenceActionTwo)
    return node
end