
-- 抽取道具的第2个界面，输入要抽取的数量

local PVShopPropNum = class("PVShopPropNum", BaseUIView)


function PVShopPropNum:ctor(id)
    self.super.ctor(self, id)
end


function PVShopPropNum:onMVCEnter()

    --初始化属性
    self:init()
    
    --绑定事件
    self:initTouchListener()
    
    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI("shop/ui_shop_chest2.ccbi", self.ccbiNode)

    --获取控件
    self:initVariable()
end


function PVShopPropNum:init()
    
    self.ccbiNode = {}
    self.ccbiRootNode = {}
    
    self.bgIn = nil   -- 外围空白区域，点击将推出

    self.labelNum = nil

end

function PVShopPropNum:initTouchListener()
    
    local function menuClickOK()  --
        print("menuclick OK ")
    end

    local function menuClickSub() --
        print("sub ...")
        local value = self.slider:getValue()
        self.slider:setValue(value-1)
    end

    local function menuClickAdd()
        print("add ...")
        local value = self.slider:getValue()
        self.slider:setValue(value+1)
    end

    self.ccbiNode["UIChestTwo"] = {}
    self.ccbiNode["UIChestTwo"]["onSureClick"] = menuClickOK
    self.ccbiNode["UIChestTwo"]["onReduceClick"] = menuClickSub
    self.ccbiNode["UIChestTwo"]["onAddClick"] = menuClickAdd
end


function PVShopPropNum:initVariable()

    self.ccbiRootNode = self.ccbiNode["UIChestTwo"]

    self.labelNum = self.ccbiRootNode["numberLabel"]
    self.labelNum:setString("1")
    self.progressLayer = self.ccbiRootNode["progressLayer"]
    self.bgIn = self.ccbiRootNode["laycolor_bg"]

    -- 赋值



    ----点击到区域外则关闭窗口
    local posX,posY = self.bgIn:getPosition()
    local size = self.bgIn:getContentSize()

    local rectArea = cc.rect(posX, posY, size.width, size.height)
    self.bgIn:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.bgIn:setTouchEnabled(true)
    local function onTouchEvent(eventType, x, y)
        local isInRect = cc.rectContainsPoint(rectArea, cc.p(x,y))
        if eventType == "began" then
            if isInRect then
                return false
            end
            return true
        elseif  eventType == "ended" then
            if isInRect == false then 
                self:onHideView()  -- 关闭窗口
            end 
        end
    end
    self.bgIn:registerScriptTouchHandler(onTouchEvent)

    ----添加滑动bar
    local sprite1 = game.newSprite("#ui_bag_slider1.png")
    local sprite2 = game.newSprite("#ui_bag_slider2.png")
    local sprite3 = game.newSprite("#ui_bag_sliderb.png")
    local sprite4 = game.newSprite("#ui_bag_sliderb.png")
    
    self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setMinimumValue(1)
    self.slider:setMaximumValue(self.funcTable[1])  --最大是10个
    self.slider:setPosition(0, self.slider:getContentSize().height/2 - 5)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.slider:registerControlEventHandler(function(pSender) self:sliderCallback(pSender)  end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.progressLayer:addChild(self.slider)


end

--滑动条回调事件
function PVShopPropNum:sliderCallback(pSender)
    self.curNumber = pSender:getValue()
    local curValue = math.floor(self.curNumber)
    self.labelNum:setString(math.ceil(curValue))
end


--@return 
return PVShopPropNum


