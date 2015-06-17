
game = game or {}

local sharedDirector         = cc.Director:getInstance()
local sharedTextureCache     = cc.Director:getInstance():getTextureCache()
local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local sharedAnimationCache   = cc.AnimationCache:getInstance()

function game.pause()
    sharedDirector:pause()
end

function game.resume()
    sharedDirector:resume()
end

function game.newNode()
    return cc.Node:create()
end

function game.newSprite(filename)
    local sprite

    local t = type(filename)
    if t == "userdata" then t = tolua.type(filename) end

    if not filename then
        sprite = cc.Sprite:create()
    elseif t == "string" then
        if string.byte(filename) == 35 then -- first char is #
            local frame = game.newSpriteFrame(string.sub(filename, 2))
            if frame then
                sprite = cc.Sprite:createWithSpriteFrame(frame)
            else
                sprite = cc.Sprite:create()
            end
        else
            sprite = cc.Sprite:create(filename)
        end
    elseif t == "cc.SpriteFrame" then
        sprite = cc.Sprite:createWithSpriteFrame(filename)
    else
        sprite = cc.Sprite:create()
    end

    return sprite
end

--更换sprite纹理
function game.setSpriteFrame(_sprite, filename)
    local t = type(filename)
    if t == "userdata" then t = tolua.type(filename) end
    if t == "string" then
        if string.byte(filename) == 35 then -- first char is #
            local frame = game.newSpriteFrame(string.sub(filename, 2))
            if frame then
                _sprite:setSpriteFrame(frame)
                return
            end
        else
            _sprite:setTexture(filename)
        end
    end

end

function game.newScale9Sprite(filename, size)
    local sprite

    local t = type(filename)
    if t ~= "string" then return end

    if string.byte(filename) == 35 then -- first char is #
        local frame = game.newSpriteFrame(string.sub(filename, 2))
        if frame then
            sprite = cc.Scale9Sprite:createWithSpriteFrame(frame)
        end
    else
        sprite = cc.Scale9Sprite:create(filename)
    end

    if size then sprite:setContentSize(size) end

    return sprite
end

function game.newLayer()
    return cc.Layer:create()
end

function game.newColorLayer(color)
    return cc.LayerColor:create(color)
end

function game.newBatchNode(image, capacity)
    return cc.SpriteBatchNode:create(image, capacity or 100)
end

function game.newClippingNode()
    return cc.ClippingNode:create()
end

function game.addImageAsync(imagePath, callback)
    sharedTextureCache:addImageAsync(imagePath, callback)
end

function game.addSpriteFramesWithFile(plistFilename, image)
    if image then
        sharedSpriteFrameCache:addSpriteFrames(plistFilename, image)
    else
        sharedSpriteFrameCache:addSpriteFrames(plistFilename)
    end
end

function game.removeSpriteFramesWithFile(plistFilename, imageName)
    sharedSpriteFrameCache:removeSpriteFramesFromFile(plistFilename)
    if imageName then
        game.removeSpriteFrameByImageName(imageName)
    end
end

function game.removeSpriteFrameByImageName(imageName)
    sharedSpriteFrameCache:removeSpriteFrameByName(imageName)
    sharedTextureCache:removeTextureForKey(imageName)
end

function game.newSpriteFrame(frameName)
    return sharedSpriteFrameCache:getSpriteFrame(frameName)
end

function game.newFrames(pattern, begin, last, isReversed)
    local frames = {}
    local step = 1
    if isReversed then
        --last, begin = begin, last
        step = -1
    end
    for index = begin, last, step do
        local frameName = string.format(pattern, index)

        local frame = sharedSpriteFrameCache:getSpriteFrame(frameName)
        if frame then
            frames[#frames + 1] = frame
        end

    end
    return frames
end

function game.newAnimation(frames, time)
    return cc.Animation:createWithSpriteFrames(frames, time)
end

function game.setAnimationCache(name, animation)
    sharedAnimationCache:addAnimation(animation, name)
end

function game.getAnimationCache(name)
    return sharedAnimationCache:animationByName(name)
end

function game.removeAnimationCache(name)
    sharedAnimationCache:removeAnimationByName(name)
end

function game.removeUnusedSpriteFrames()
    sharedSpriteFrameCache:removeUnusedSpriteFrames()
    sharedTextureCache:removeUnusedTextures()
end

function game.newProgressTimer(image, progresssType)
    if type(image) == "string" then
        image = game.newSprite(image)
    end

    local progress = cc.ProgressTimer:create(image)
    progress:setType(progresssType)
    return progress
end

function game.newScene(name)
    local scene = cc.Scene:create()

    scene.scenename = name

    scene.sceneRoot = game.newNode()
    -- scene.sceneRoot:setPosition(scr.sceneRootPoint)
    -- scene.sceneRoot:setRotation(scr.sceneRootRotate)

    scene.addRootChild = function(self, ...)
        self.sceneRoot:addChild(...)
    end

    scene:addChild(scene.sceneRoot)

    local function sceneEventHandler(event)
        cclog("sceneEventHandler [%s] [%s]", scene.scenename, event)
        if event == "enter" then
            if scene.onSceneEnter then scene:onSceneEnter() end
        elseif event == "exit" then
            if scene.onSceneExit then scene:onSceneExit() end
        elseif event == "enterTransitionFinish" then
            if scene.onSceneEnterTransitionDidFinish then scene:onSceneEnterTransitionDidFinish() end
        elseif event == "exitTransitionStart" then
            if scene.onSceneExitTransitionDidStart then scene:onSceneExitTransitionDidStart() end
        elseif event == "cleanup" then
            if scene.onSceneCleanUp then 
                print("cleanup")
                scene:onSceneCleanUp() 
            end
        end
    end

    scene:registerScriptHandler(sceneEventHandler)

    return scene
end

function game.runWithScene(newScene)
    print("runWithScene")
    sharedDirector:runWithScene(newScene)
end

function game.pushScene(newScene)
    print("pushScene")
    sharedDirector:pushScene(newScene)
end

function game.popScene()
    print("popScene")
    sharedDirector:popScene()
end

function game.replaceScene(newScene)
    print("replaceScene")
    sharedDirector:replaceScene(newScene)
end

function game.getRunningScene()
    return sharedDirector:getRunningScene()
end

function game.createShieldLayer()
    -- local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), 640, 960)
    -- layer:setOpacity(125)
    local layer = game.newLayer()
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            return true
        end
    end
    layer:setTouchEnabled(false)
    layer:registerScriptTouchHandler(onTouchEvent)
    return layer
end

--更新table是否和滑动，heghtA,layer的高度,heightB,cell 的高度,numL: cell num

----cocostudio上的ui----

--imageview
function game.newImageView(filename)
    local img = ccui.ImageView:create()
    img:setTouchEnabled(false) -- 默认为不可点击
    local t = type(filename)
    if t == "string" then
        if string.byte(filename) == 35 then -- first char is #
            local frame = string.sub(filename, 2)
            if frame then
                img:loadTexture(frame, 1)
            end
        else
            img:loadTexture(filename)
        end
    end
    return img
end

--uibutton
function game.newButton(normal, selected, disabled)
    local btn = ccui.Button:create()
    if type(normal) == "string" then
        if string.byte(normal) == 35 then
            local frame = string.sub(normal, 2)
            if frame then
                btn:loadTextureNormal(frame, 1)
            end
        else
            btn:loadTextureNormal(normal)
        end
    else
        btn:loadTextureNormal("")
    end
    if type(selected) == "string" then
        if string.byte(selected) == 35 then
            local frame = string.sub(selected, 2)
            if frame then
                btn:loadTexturePressed(frame, 1)
            end
        else
            btn:loadTexturePressed(selected)
        end
    else
        btn:loadTexturePressed("")
    end
    if type(disabled) == "string" then
        if string.byte(disabled) == 35 then
            local frame = string.sub(disabled, 2)
            if frame then
                btn:loadTextureDisabled(frame, 1)
            end
        else
            btn:loadTextureDisabled(disabled)
        end
    else
        btn:loadTextureDisabled("")
    end
    return btn
end

--uitext
function game.newText(text, fontname, fontsize)
    local text = ccui.Text:create(text, fontname, fontsize)
    text:setTouchEnabled(false)
    return text
end

--uilayout
function game.newLayout(width, height)
    local layout = ccui.Layout:create()
    layout:setSize(cc.size(width, height))
    layout:setTouchEnabled(false)
    return layout
end

--panel with color
function game.newPanel(width, height, color)
    local layout = ccui.Layout:create()
    layout:setSize(cc.size(width, height))
    layout:setBackGroundColor(color)
    layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layout:setTouchEnabled(false)
    return layout
end

function game.newClippingRegionNode(rect)
    if rect then
        return cc.ClippingRectangleNode:create(rect)
    else
        return cc.ClippingRectangleNode:create()
    end
end

function game.newCCBNode(_name, _table)
    local proxy = cc.CCBProxy:create()
    return CCBReaderLoad(_name, proxy, _table)
end

