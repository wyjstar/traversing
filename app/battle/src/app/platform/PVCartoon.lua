
local PVCartoon = class("PVCartoon", function ()
    return cc.Node:create()
end)

function PVCartoon:ctor(id)
    -- print("设置数值 ========================= ")

    self:initView()

     local function onNodeEvent(event)
        if "exit" == event then
            self:onExit()
        end
    end

    self:registerScriptHandler(onNodeEvent)
end

function PVCartoon:onExit()
    cclog("----PVCartoon:onExit----")
    self:unregisterScriptHandler()
    timer.unscheduleGlobal(self.sendTimeTickScheduler)
end


function PVCartoon:initView()
    game.addSpriteFramesWithFile("res/ccb/manhua/ui_kaitoumanhuan16.plist")
    game.addSpriteFramesWithFile("res/ccb/manhua/ui_kaitoumanhuan79.plist")

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()

    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))

    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:addChild(self.adapterLayer)

    self.UIAniCartoonView = {}
    self.UIAniCartoonView["UIAniCartoonView"] = {}

    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("effect/ui_cartoon.ccbi", proxy, self.UIAniCartoonView)
    if node == nil then
        cclog("Error: in loadCCBI _name==" .. _name)
        return
    end

    self.animationManager = self.UIAniCartoonView["UIAniCartoonView"]["mAnimationManager"]

    self.adapterLayer:addChild(node)

    -- print("执行action ========================= ")
    -- local sequenceAction = cc.Sequence:create(cc.DelayTime:create(30), cc.CallFunc:create(enterPlayerScene()))
    -- self:runAction(sequenceAction)
    self:afterAction()
end

function PVCartoon:afterAction()

    local function CallFunc()
        cc.UserDefault:getInstance():setBoolForKey("first_login", true)
        cc.UserDefault:getInstance():flush()

        self:stopAllActions()
        timer.unscheduleGlobal(self.sendTimeTickScheduler)

        if ISSHOW_GUIDE then
            getNewGManager():startGuideForGuideId(GuideId.G_START_GUIDE_FIGHT)
        else
            enterPlayerScene()
        end
    end

    self:runAction(cc.Sequence:create(cc.DelayTime:create(19.9),cc.CallFunc:create(CallFunc)))

    local __sendTimeTick = function ()

        if ISPAUSEING == true then
            print("---------afterAction-------")
            self:stopAllActions()
            timer.unscheduleGlobal(self.sendTimeTickScheduler)

            self.animationManager:stopAllAnimations()
        end
    end

    self.sendTimeTickScheduler = timer.scheduleGlobal(__sendTimeTick, 1)

end

return PVCartoon
