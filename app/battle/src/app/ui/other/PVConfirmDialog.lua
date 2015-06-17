-- 公共 confirm dialog
-- 需要三个参数，1， 确定（回调函数） 2，取消（回调函数） 3，文子内容

local PVConfirmDialog = class("PVConfirmDialog", BaseUIView)

function PVConfirmDialog:ctor(id)
    PVConfirmDialog.super.ctor(self, id)

end

function PVConfirmDialog:onMVCEnter()
    self:initBaseUI()
    
    local s = cc.Director:getInstance():getWinSize()
    local bg_color = cc.LayerColor:create(cc.c4b(0,0,0,150))

    bg_color:setContentSize(cc.size(s.width, s.height))
    bg_color:ignoreAnchorPointForPosition(true)
    self:addChild(bg_color, -1)

	self.ccbiNode = {}
	self:initTouchListener()
    self:loadCCBI("common/ui_common_tips.ccbi", self.ccbiNode)
    self:initView()
    self:initData()
end

function PVConfirmDialog:initData()
    self.labelTips:setString(self.text)
end

function PVConfirmDialog:initParams(sureCallfunc, cancelCallfunc, text, callfunc)
    self.sureCallfunc = sureCallfunc
    self.cancelCallfunc = cancelCallfunc
    self.text = text
    self.callfunc = callfunc
end

function PVConfirmDialog:initTouchListener()

    local function onMenuClickOk()
        if self.sureCallfunc then
            self.sureCallfunc()
            
        end
        if self.callfunc then
            self.callfunc()
        end
        self:removeFromParent()
    end

    local function onMenuClickCancle()
        if self.cancelCallfunc then
            self.cancelCallfunc()
        end
        if self.callfunc then
            self.callfunc()
        end
        self:removeFromParent()
    end

    local function onMenuClickOk_1()

    	self:removeFromParent()
    end

    self.ccbiNode["UICommonTipsView"] = {}
    self.ccbiNode["UICommonTipsView"]["onSureClick"] = onMenuClickOk
    self.ccbiNode["UICommonTipsView"]["onCancleClick"] = onMenuClickCancle
    self.ccbiNode["UICommonTipsView"]["onMenuOk"] = onMenuClickOk_1
    self.ccbiNode["UICommonTipsView"]["menuClickOk"] = onMenuClickOk_1
    self.ccbiNode["UICommonTipsView"]["onCloseClick"] = onMenuClickCancle

    local function onRelease( code,event )
        print("PVConfirmDialog,onRelease:",code)
        if code == 6 then --Click Back Key
            if not getNewGManager():checkStageGuide() then --非新手引导过程中
                onMenuClickCancle()
            end
        end
    end

    local function onKeyPressed( code,event )
    end

    local key_listener = cc.EventListenerKeyboard:create()
    key_listener:retain()
    key_listener:registerScriptHandler(onRelease,cc.Handler.EVENT_KEYBOARD_RELEASED)
    key_listener:registerScriptHandler(onKeyPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(key_listener,self)
end

function PVConfirmDialog:initView()
	self.labelTips = self.ccbiNode["UICommonTipsView"]["detailLabel1"]

    self.menuCloseBtn = self.ccbiNode["UICommonTipsView"]["menu_close"]  -- close btn
	self.layerOneButton = self.ccbiNode["UICommonTipsView"]["oneBtnLayer"]
	self.layerTwoButton = self.ccbiNode["UICommonTipsView"]["twoBtnLayer"]

    self.menuCloseBtn:setVisible(false)
    self.layerOneButton:setVisible(false)
end


return PVConfirmDialog
