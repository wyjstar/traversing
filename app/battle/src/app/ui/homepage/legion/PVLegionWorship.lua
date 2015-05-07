
local PVLegionWorship = class("PVLegionWorship", BaseUIView)

function PVLegionWorship:ctor(id)
    PVLegionWorship.super.ctor(self, id)
end

function PVLegionWorship:onMVCEnter()
    self.curType = nil
    self.addMoney = nil
    self.addExp = nil
    self.costValue = nil
    self.curWorshipTimes = 0

    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.commonData = getDataManager():getCommonData()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self:registerDataBack()

    self:initView()
    self:initData()
end

function PVLegionWorship:registerDataBack()
    --膜拜后返回
    local function getWorshipBack()
        local responsData = self.legionData:getLegionResultData()
        self.result = responsData.result
        self.message = responsData.message
        if self.result then
            self.curWorshipTimes = self.curWorshipTimes + 1
            getOtherModule():showAlertDialog(nil, self.message)
            self.legionData:setWorshipData(self.addMoney, self.addExp)
            if self.curType == 1 or curType == 2 then
                local curCoinValue = self.commonData:getCoin()
                self.commonData:setCoin(curCoinValue - self.costValue)
            else
                local curGoldValue = self.commonData:getGold()
                self.commonData:setGold(curGoldValue - self.costValue)
            end
        else
            getOtherModule():showAlertDialog(nil, self.message)
        end
    end
    self:registerMsg(LEGION_WORSHIP, getWorshipBack)
end

function PVLegionWorship:initView()
    self.UILegionWorshipView = {}
    self:initTouchListener()

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    local colorLayer = game.newColorLayer(cc.c4b(0, 0, 0, 180))

    colorLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    colorLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:loadCCBI("legion/ui_legion_worship.ccbi", self.UILegionWorshipView)
    self:addChild(colorLayer, -100)

    -- self.sliverLayer = self.UILegionWorshipView["UILegionWorshipView"]["sliverLayer"]   --目前拥有银元宝
    -- self.goldLayer = self.UILegionWorshipView["UILegionWorshipView"]["goldLayer"]       --目前拥有金元宝

    -- self.expLayer1 = self.UILegionWorshipView["UILegionWorshipView"]["expLayer1"]       --普通膜拜守护经验值
    -- self.repuation1 = self.UILegionWorshipView["UILegionWorshipView"]["repuation1"]     --普通膜拜提升贡献值
    -- self.costMoney1 = self.UILegionWorshipView["UILegionWorshipView"]["costMoney1"]     --普通膜拜消耗元宝值

    -- self.expLayer2 = self.UILegionWorshipView["UILegionWorshipView"]["expLayer2"]       --虔诚膜拜守护经验值
    -- self.repuation2 = self.UILegionWorshipView["UILegionWorshipView"]["repuation2"]     --虔诚膜拜提升贡献值
    -- self.costMoney2 = self.UILegionWorshipView["UILegionWorshipView"]["costMoney2"]     --虔诚膜拜消耗元宝值

    -- self.expLayer3 = self.UILegionWorshipView["UILegionWorshipView"]["expLayer3"]       --顶礼膜拜守护经验值
    -- self.repuation3 = self.UILegionWorshipView["UILegionWorshipView"]["repuation3"]     --顶礼膜拜提升贡献值
    -- self.costMoney3 = self.UILegionWorshipView["UILegionWorshipView"]["costMoney3"]     --顶礼膜拜消耗元宝值

    -- self.moneyValue = self.UILegionWorshipView["UILegionWorshipView"]["moneyValue"]                 --目前拥有银元宝
    -- self.superMoneyValue = self.UILegionWorshipView["UILegionWorshipView"]["superMoneyValue"]       --目前拥有金元宝

    self.expValue1 = self.UILegionWorshipView["UILegionWorshipView"]["expValue1"]                   --普通膜拜守护经验值
    self.repuationValue1 = self.UILegionWorshipView["UILegionWorshipView"]["repuationValue1"]       --普通膜拜提升贡献值
    self.costMoneyValue1 = self.UILegionWorshipView["UILegionWorshipView"]["costMoneyValue1"]       --普通膜拜消耗元宝值

    self.expValue2 = self.UILegionWorshipView["UILegionWorshipView"]["expValue2"]                   --虔诚膜拜守护经验值
    self.repuationValue2 = self.UILegionWorshipView["UILegionWorshipView"]["repuationValue2"]       --虔诚膜拜提升贡献值
    self.costMoneyValue2 = self.UILegionWorshipView["UILegionWorshipView"]["costMoneyValue2"]       --虔诚膜拜消耗元宝值

    self.expValue3 = self.UILegionWorshipView["UILegionWorshipView"]["expValue3"]                   --顶礼膜拜守护经验值
    self.repuationValue3 = self.UILegionWorshipView["UILegionWorshipView"]["repuationValue3"]       --顶礼膜拜提升贡献值
    self.costMoneyValue3 = self.UILegionWorshipView["UILegionWorshipView"]["costMoneyValue3"]       --顶礼膜拜消耗元宝值

end

function PVLegionWorship:initData()
    --当前可以膜拜的次数
    self.worshipTimes = self.c_BaseTemplate:getWorshipTimes()

    local worshipList = self.c_BaseTemplate:getBaseInfoById("worship")
    if worshipList ~= nil then
        self.expValue1:setString(worshipList["1"][3])
        self.costMoneyValue1:setString(worshipList["1"][2])
        self.repuationValue1:setString(worshipList["1"][5])

        self.expValue2:setString(worshipList["2"][3])
        self.costMoneyValue2:setString(worshipList["2"][2])
        self.repuationValue2:setString(worshipList["2"][5])

        self.expValue3:setString(worshipList["3"][3])
        self.costMoneyValue3:setString(worshipList["3"][2])
        self.repuationValue3:setString(worshipList["3"][5])
    end
end

--膜拜数据获取
function PVLegionWorship:setWorshipValue(cur_type)
    local worshipList = self.c_BaseTemplate:getBaseInfoById("worship")
    self.costValue = worshipList[cur_type][2]
    self.addExp = worshipList[cur_type][3]
    self.addMoney = worshipList[cur_type][4]
end

function PVLegionWorship:initTouchListener()
    --返回
    local function onBackClick()
        cclog("onBackClick")
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --普通膜拜
    local function onWorshipFirstClick()
        cclog("onWorshipFirstClick")
        getAudioManager():playEffectButton2()
        self.curType = 1
        self:setWorshipValue("1")
        print("self.curWorshipTimes ======================== ", self.curWorshipTimes)
        print("self.worshipTimes ======================== ", self.worshipTimes)
        if self.curWorshipTimes < self.worshipTimes then
            print("膜拜 ========== -----------------------")
            self.legionNet:sendWorship(1)
        else
            print("禁止膜拜 ========== -------------------")
            getOtherModule():showAlertDialog(nil, Localize.query("legion.11"))

        end
    end

    --虔诚膜拜
    local function onWorshipSecondClick()
        cclog("onWorshipSecondClick")
        getAudioManager():playEffectButton2()
        self.curType = 2
        self:setWorshipValue("2")
        if self.curWorshipTimes < self.worshipTimes then
            self.legionNet:sendWorship(2)
        else
            print("禁止膜拜 ========== -------------------")
            getOtherModule():showAlertDialog(nil, Localize.query("legion.11"))

        end
    end

    --顶礼膜拜
    local function onWorshipThirdClick()
        cclog("onWorshipThirdClick")
        getAudioManager():playEffectButton2()
        self.curType = 3
        self:setWorshipValue("3")
        if self.curWorshipTimes < self.worshipTimes then
            self.legionNet:sendWorship(3)
        else
            print("禁止膜拜 ========== -------------------")
            getOtherModule():showAlertDialog(nil, Localize.query("legion.11"))
        end
    end

    self.UILegionWorshipView["UILegionWorshipView"] = {}
    self.UILegionWorshipView["UILegionWorshipView"]["backMenuClick"] = onBackClick
    self.UILegionWorshipView["UILegionWorshipView"]["onWorshipFirstClick"] = onWorshipFirstClick
    self.UILegionWorshipView["UILegionWorshipView"]["onWorshipSecondClick"] = onWorshipSecondClick
    self.UILegionWorshipView["UILegionWorshipView"]["onWorshipThirdClick"] = onWorshipThirdClick
end

return PVLegionWorship
