
-- local processor = import("...netcenter.DataProcessor")

local PVUseItemTips = class("PVUseItemTips", BaseUIView)

function PVUseItemTips:ctor(id)
    PVUseItemTips.super.ctor(self, id)
    -- self.shieldlayer:setTouchEnabled(false)

    -- self.shieldlayer1 = game.createShieldLayer()
    -- self.shieldlayer1:setContentSize(cc.size(600, 380))
    -- self.shieldlayer1:setPosition(cc.p(320, 480))
    -- self:addChild(self.shieldlayer1, -100)
    -- self.shieldlayer1:setTouchEnabled(true)
end

function PVUseItemTips:onMVCEnter()
    -- self:registerDataBack()             --注册网络数据更新ui回调

    self.bagNet = getNetManager():getBagNet()
    self.bagData = getDataManager():getBagData()

    self:initView()
    self:initData(self.funcTable[1], self.funcTable[2])
end

function PVUseItemTips:registerDataBack()
    --道具使用结果
    local function getUseResult()
        -- local resultData = processor:getCommonResponse()
        -- if resultData.result then
        --     print("道具使用成功 ======== resultData.result  ========= ", resultData.result)
        -- elseif resultData.result_no == 107 then
        --     print("关联道具不足 ============== ")
        --     local tipWord = "关联道具不足"
        --     -- self.labelCommon:initAction(tipWord)
        --     self:toastShow(tipWord)
        -- end
        self:onHideView()
    end
    self:registerMsg(PROP_USE, getUseResult)
end

function PVUseItemTips:initView()
    --load ccbi
    self.UIUseItemPanel = {}
    self:initTouchListener()
    self:loadCCBI("bag/ui_useItem_panel.ccbi", self.UIUseItemPanel)

    --ui使用变量绑定
    self.numberLabel = self.UIUseItemPanel["UIUseItemPanel"]["numberLabel"]
    self.progressLayer = self.UIUseItemPanel["UIUseItemPanel"]["progressLayer"]
    self.animationManager = self.UIUseItemPanel["UIUseItemPanel"]["mAnimationManager"]

    --slider动态创建
    local sprite1 = game.newSprite("#ui_bag_slider1.png")
    local sprite2 = game.newSprite("#ui_bag_slider2.png")
    local sprite3 = game.newSprite("#ui_bag_sliderb.png")
    local sprite4 = game.newSprite("#ui_bag_sliderb.png")

    self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setMinimumValue(1)
    self.slider:setMaximumValue(100)
    self.slider:setPosition(0, self.slider:getContentSize().height/2 - 5)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.slider:registerControlEventHandler(function(pSender) self:sliderCallback(pSender)  end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.progressLayer:addChild(self.slider)


end

function PVUseItemTips:initTouchListener()
    --self:onHideView()
    --数值减小
    local function onReduceClick()
        self.curNumber = self.curNumber - self.perAddNumber
        if self.curNumber < self.perAddNumber then
            self.slider:setValue(self.perAddNumber)
        else
            self.slider:setValue(self.curNumber)
        end
    end

    --数值增加
    local function onAddClick()
        self.curNumber = self.curNumber + self.perAddNumber
        self.slider:setValue(self.curNumber)
    end

    --确定
    local function onSureClick()
        local useNum = math.ceil(self.numberLabel:getString())
        if useNum <= 10 then
            self.maxNumber = self.maxNumber - useNum
        end

        self.bagData:setUseNum(useNum)

        self.bagNet:sendUseProp(self.cur_item_no, useNum)        --发送道具使用协议

        self:onHideView()
    end

    local function onCloseClick()
        self:onHideView()
    end

    self.UIUseItemPanel["UIUseItemPanel"] = {}
    self.UIUseItemPanel["UIUseItemPanel"]["onReduceClick"] = onReduceClick
    self.UIUseItemPanel["UIUseItemPanel"]["onAddClick"] = onAddClick
    self.UIUseItemPanel["UIUseItemPanel"]["onSureClick"] = onSureClick
    self.UIUseItemPanel["UIUseItemPanel"]["onCloseClick"] = onCloseClick
end

function PVUseItemTips:sliderCallback(pSender)
    self.curNumber = pSender:getValue()
    if self.maxNumber ~= nil then
        local curValue = math.floor(self.curNumber) * self.maxNumber / 100
        self.numberLabel:setString(math.ceil(curValue))
    end
end

function PVUseItemTips:initData(item_num, item_no)
    self.slider:setEnabled(true)
    self.cur_item_no = item_no
    if item_num ~= nil then
        -- if item_num > 10 then
        --     self.maxNumber = 10
        -- else
        --     self.maxNumber = item_num
        -- end
        self.maxNumber = item_num
    end
    if self.maxNumber ~= nil then
        self.perAddNumber = 100 / self.maxNumber

        if tonumber(item_num) >= 1 then
            self.slider:setValue(self.perAddNumber)
            self.numberLabel:setString(1)
            self:setVisible(true)
            self.animationManager:runAnimationsForSequenceNamed("showAnimation")
        end
    end
end

return PVUseItemTips
