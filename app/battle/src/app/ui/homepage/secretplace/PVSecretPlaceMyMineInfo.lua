
-- 查看自己矿点信息

local PVSecretPlaceMyMineInfo = class("PVSecretPlaceMyMineInfo", BaseUIView)

function PVSecretPlaceMyMineInfo:ctor(id)
    self.super.ctor(self, id)
end

function PVSecretPlaceMyMineInfo:onMVCEnter()
    self.runeData = getDataManager():getRuneData()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self:showAttributeView()

    self.UISecretMyMineInformation = {}
    self.baseRuneSprite = {}
    self.luckyRuneSprite = {}

    self:initTouchListener()

    self:loadCCBI("secretTerritory/ui_secret_myMineInformation.ccbi", self.UISecretMyMineInformation)

    self:initData()

    self:initView()

    self:initRegisterNetCallBack()

    local function onNodeEvent(event)
        if "exit" == event then
            if self.onExit ~= nil then
                self:onExit()
            end
        end
    end

    self:registerScriptHandler(onNodeEvent)
  
end

function PVSecretPlaceMyMineInfo:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    if __scheduerMineOutputTime ~= nil then
         timer.unscheduleGlobal(__scheduerMineOutputTime)
         __scheduerMineOutputTime = nil
    end
end

function PVSecretPlaceMyMineInfo:initView()
    self.baseRuneSprite = {}   -- 基础产出 符文
    self.luckyRuneSprite = {}   -- 幸运产出 符文
    self.luckyRuneMenuItem = {}   -- 幸运产出 符文
    self.baseRuneMenuItem = {}   -- 幸运产出 符文
    
    for i=1,4 do
        local _baseName = string.format("baseRuneSprite%d", i)
        local _baseRuneSprite = self.UISecretMyMineInformation["UISecretMyMineInformation"][_baseName]
        _baseRuneSprite:setVisible(false)
        table.insert(self.baseRuneSprite, _baseRuneSprite)

        local _baseItemName = string.format("baseOutput%d", i)
        local _baseRuneItem = self.UISecretMyMineInformation["UISecretMyMineInformation"][_baseItemName]
        _baseRuneItem:setVisible(true)
        _baseRuneItem:getNormalImage():setOpacity(0)
        table.insert(self.baseRuneMenuItem, _baseRuneItem)

        local _luckyName = string.format("luckyRuneSprite%d", i)
        local _luckyRuneSprite = self.UISecretMyMineInformation["UISecretMyMineInformation"][_luckyName]
        _luckyRuneSprite:setVisible(false)
        table.insert(self.luckyRuneSprite, _luckyRuneSprite)

        local _luckyItemName = string.format("luckyMenuItem%d", i)
        local _luckyRuneItem = self.UISecretMyMineInformation["UISecretMyMineInformation"][_luckyItemName]
        _luckyRuneItem:setVisible(false)
        _luckyRuneItem:getNormalImage():setOpacity(0)
        table.insert(self.luckyRuneMenuItem, _luckyRuneItem)
    end

    self.addOutput = self.UISecretMyMineInformation["UISecretMyMineInformation"]["addOutput"]  -- 单位量产
    self.addOutput:setVisible(false)
    self.untilOutput = self.UISecretMyMineInformation["UISecretMyMineInformation"]["untilOutput"]  -- 单位量产
    self.baseMaxOutput = self.UISecretMyMineInformation["UISecretMyMineInformation"]["baseMaxOutput"]  -- 最大储量
    self.luckyMaxOutput = self.UISecretMyMineInformation["UISecretMyMineInformation"]["luckyMaxOutput"]  -- 幸运最大储量

    self.increasePrice = self.UISecretMyMineInformation["UISecretMyMineInformation"]["zengchanPrice"] --增产价格
    self.increaseContent = self.UISecretMyMineInformation["UISecretMyMineInformation"]["tarvelBottomLabel"] --增产说明

    self.increaseTime = self.UISecretMyMineInformation["UISecretMyMineInformation"]["increaseTime"] --增产剩余时间
    self.increaseTime:setVisible(false)

    self.getonBtn = self.UISecretMyMineInformation["UISecretMyMineInformation"]["getonBtn"] --收获按钮
    -- self.notice = self.UISecretMyMineInformation["UISecretMyMineInformation"]["notice"] --红点

    -- self.getonBtn:setVisible(true)

    SpriteGrayUtil:drawSpriteTextureGray(self.getonBtn:getNormalImage())
    self.getonBtn:setEnabled(false)
    -- self.notice:setVisible(false)

    self:displayView()

    -- 产出量大于0 收获按钮显示
    if self.detailInfo:getNormalNum(0)>0 then
        -- self.getonBtn:setVisible(true)
        SpriteGrayUtil:drawSpriteTextureColor(self.getonBtn:getNormalImage())
        self.getonBtn:setEnabled(true)
        -- self.notice:setVisible(true)
    end

end

function PVSecretPlaceMyMineInfo:displayView()
    local strGen = string.format("%d/%s", self.detailInfo:getUnit(0), Localize.query("PVSecretPlaceMyMineInfo.1"))
    print("------PVSecretPlaceMyMineInfo:displayView----"..self.detailInfo:getUnit(0))  
    -- if getDataManager():getCommonData():getTime() - self.detailInfo:getIncrease(0) < 0 then
    --     local strIncr = Localize.query("PVSecretPlaceMyMineInfo.2")
    --     -- local dis = string.format(strIncr.."%d%%)", self.detailInfo:getRate(0)*100)
    --     self.untilOutput:setString(strGen)
    --     -- self.addOutput:setString(dis)
    --     self.addOutput:setVisible(true)
    -- else
    --     self.addOutput:setString(strGen)
    --     self.addOutput:setVisible(true)
    -- end
    self.untilOutput:setString(strGen)
    -- self.addOutput:setVisible(true)
    if getDataManager():getCommonData():getTime() - self.detailInfo:getIncrease(0) < 0 then
        local strIncr = Localize.query("PVSecretPlaceMyMineInfo.2")
        self.addOutput:setVisible(true)
    else
        self.addOutput:setVisible(false)
    end
    if self.detailInfo:getNormalNum(0) <= self.detailInfo:getLimit(0) then 
        self.baseMaxOutput:setString(self.detailInfo:getNormalNum(0)..'/'..self.detailInfo:getLimit(0))
    else
        self.baseMaxOutput:setString(self.detailInfo:getLimit(0)..'/'..self.detailInfo:getLimit(0))
    end
    -- self.luckyMaxOutput:setString(self.detailInfo:getLuckyNum(0)..'/'..self.detailInfo:getLimit(0))
    self.luckyMaxOutput:setString(self.detailInfo:getLuckyNum(0))
    self.increasePrice:setString(self.detailInfo:getPrice(0))

    local cont1 = Localize.query("PVSecretPlaceMyMineInfo.3")
    local cont2 = Localize.query("PVSecretPlaceMyMineInfo.4")
    local discont = string.format(cont1.."%d%%"..cont2, self.detailInfo:getRate(0)*100)
    self.increaseContent:setString(discont)

    -- self.addOutput:setVisible(true)
    self.baseMaxOutput:setVisible(true)
    self.luckyMaxOutput:setVisible(true)
    self.increasePrice:setVisible(true)
    self.increaseContent:setVisible(true)


    local _nomals = self.detailInfo:getNormals(0)
    for k,v in pairs(_nomals) do
        print(k,v.stone_id)
        local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.stone_id)
        self:setItemImage(self.baseRuneSprite[k], _respng, _quality)
        self.baseRuneSprite[k]:setVisible(true)
    end

    local _luckys = self.detailInfo:getLuckys(0)
    for k,v in pairs(_luckys) do
        local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.stone_id)
        self:setItemImage(self.luckyRuneSprite[k], _respng, _quality)
        self.luckyRuneSprite[k]:setVisible(true)
        self.luckyRuneMenuItem[k]:setVisible(true)
    end

    -- 更新增产倒计时
    self:updateincrease()
end

function PVSecretPlaceMyMineInfo:setItemImage(sprite, res, quality)
    sprite:removeAllChildren()
    game.setSpriteFrame(sprite, res)
    local bgSprite = cc.Sprite:create()
    sprite:addChild(bgSprite)
    if quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_kuang.png")
    elseif quality == 3 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 4 then 
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    elseif quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
        -- local effect = createEffect(90,90)
        -- effect:setLocalZOrder(1)
        -- sprite:addChild(effect)
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

-- 更新增产时间
function PVSecretPlaceMyMineInfo:updateincrease()
    local _increase = self.detailInfo:getIncrease(0)
    if getDataManager():getCommonData():getTime()-_increase >= 0 then
        return
    end

    if __scheduerMineOutputTime ~= nil then
         timer.unscheduleGlobal(__scheduerMineOutputTime)
         __scheduerMineOutputTime = nil
    end
    
    print("-------------------")
    print(getDataManager():getCommonData():getTime())
    print(_increase)

    self.__leftTime = math.abs(getDataManager():getCommonData():getTime()-_increase)
 
    self.increaseTime:setVisible(true)
    self:startincreaseTimer()

end

function PVSecretPlaceMyMineInfo:startincreaseTimer()
    local function updateTimer(dt)

        self.__leftTime = self.__leftTime-dt

        if self.__leftTime <= 0 then
            -- v.outPutLayer:setVisible(false)
            -- v.noOutPutLayer:setVisible(true)
            SpriteGrayUtil:drawSpriteTextureColor(self.getonBtn:getNormalImage())
            self.getonBtn:setEnabled(true)

            if __scheduerMineOutputTime ~= nil then
                 timer.unscheduleGlobal(__scheduerMineOutputTime)
                 __scheduerMineOutputTime = nil
            end
        end

        self.increaseTime:setString(string.format("%02d:%02d:%02d",math.floor(self.__leftTime/3600), math.floor(self.__leftTime%3600/60), self.__leftTime%60))

    end

    __scheduerMineOutputTime = timer.scheduleGlobal(updateTimer, 1.0)
end


-- 初始化矿点信息
function PVSecretPlaceMyMineInfo:initData()
    self.detailInfo = getDataManager():getMineData()


end

function PVSecretPlaceMyMineInfo:initRegisterNetCallBack()

    function onReceiveIncreaseCallBack() -- 增产
        self:toastShow(Localize.query("PVSecretPlaceMyMineInfo.5"))
        self:displayView()
    end
    
    function onReceiveHarvestCallBack() -- 收获符文石
        local _drawStones = self.detailInfo:getDrawStones()
        table.print("-------PVSecretPlaceMyMineInfo----收获符文石＝＝＝＝＝＝"..table.nums(_drawStones))
        table.print(_drawStones)
        -- if _drawStones == nil or table.nums(_drawStones)<=0 then
        --     -- self:toastShow(Localize.query("PVSecretPlaceMyMineInfo.6"))
        --     getOtherModule():showAlertDialog(nil, Localize.query("PVSecretPlaceMyMineInfo.6"))
        --     return
        -- end
        if _drawStones == nil or table.nums(_drawStones.runt)<=0 then
            -- self:toastShow(Localize.query("PVSecretPlaceMyMineInfo.6"))
            getOtherModule():showAlertDialog(nil, Localize.query("PVSecretPlaceMyMineInfo.6"))
            return
        end

        self.detailInfo:clearNormal(0)
        self.detailInfo:clearLucky(0)

        for k,v in pairs(_drawStones.runt) do
            -- local runeType = self.c_StoneTemplate:getStoneItemById(v.runt_id).type
            -- self.runeData:updateNumById(runeType, v)
            self.runeData:updateNumById(1, v)
        end
        
        SpriteGrayUtil:drawSpriteTextureColor(self.getonBtn:getNormalImage())
        self.getonBtn:setEnabled(false)
        -- self.notice:setVisible(fa)

        -- 更新红点
        local event = cc.EventCustom:new(UPDATE_MINE_NOTICE)
        self:getEventDispatcher():dispatchEvent(event)
        print("-------------收获符文石------------")
        table.print(_drawStones.runt)
        -- getOtherModule():showOtherView("PVCongratulationsGainDialog", 1, _drawStones.runt)
        getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", _drawStones.runt,1)

        if self.detailInfo:getNormalNum(0) <= self.detailInfo:getLimit(0) then 
            self.baseMaxOutput:setString(self.detailInfo:getNormalNum(0)..'/'..self.detailInfo:getLimit(0))
        else
            self.baseMaxOutput:setString(self.detailInfo:getLimit(0)..'/'..self.detailInfo:getLimit(0))
        end
        self.luckyMaxOutput:setString(self.detailInfo:getLuckyNum(0))
    end

    self:registerMsg(MINE_ACC, onReceiveIncreaseCallBack)
    self:registerMsg(MINE_HARVEST, onReceiveHarvestCallBack)
end


function PVSecretPlaceMyMineInfo:alertBaseTips(index)
    local _nomals = self.detailInfo:getNormals()

    local runeType = self.c_StoneTemplate:getStoneItemById(_nomals[index].stone_id).type

    local runeItem = {}
    runeItem.runt_id = _nomals[index].stone_id
    runeItem.inRuneType = runeType
    runeItem.runePos = 0

    getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)

    -- getOtherModule():showOtherView("PVTravelPropItem", 2, _nomals[index].stone_id)
end

function PVSecretPlaceMyMineInfo:alertLuckyTips(index)
    local _luckys = self.detailInfo:getLuckys()

    local runeType = self.c_StoneTemplate:getStoneItemById(_luckys[index].stone_id).type

    local runeItem = {}
    runeItem.runt_id = _luckys[index].stone_id
    runeItem.inRuneType = runeType
    runeItem.runePos = 0
    getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
    
    -- local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(v.stone_id)

    -- setItemImage(self.baseRuneSprite[index], _respng, _quality)

    -- getOtherModule():showOtherView("PVTravelPropItem", 2, _luckys[index].stone_id)
end

function PVSecretPlaceMyMineInfo:initTouchListener()
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        MY_MINE_BACK = true
        groupCallBack(GuideGroupKey.BTN_CLOSE_IN_MIJING)
        -- stepCallBack(G_GUIDE_50124)    -- 50042 点击关闭
        
        self:onHideView()

    end

    local function zengchanOnClick() -- 增产
        cclog("zengchanOnClick")
        getAudioManager():playEffectButton2()
        -- reductionGlod
        local vipNo = getDataManager():getCommonData():getVip()
        if getTemplateManager():getBaseTemplate():isCanMineIncrease(vipNo) == false then
            getOtherModule():showAlertDialog(nil, Localize.query("PVSecretPlaceMyMineInfo.8"))
            return
        end
        local _gold = getDataManager():getCommonData():getGold()
        local _Price = self.detailInfo:getPrice(0)

        if _gold < _Price then
            -- self:toastShow(Localize.query("SecretShop.1"))
            getOtherModule():showAlertDialog(nil, Localize.query("SecretShop.1"))
            return
        end

        data = {}
        data.position = 0
        -- getNetManager():getSecretPlaceNet():increase(data)
        if self.__leftTime ~= nil and self.__leftTime/3600 + 4 > 24 then
            cclog("---------增产上限－－－－－"..(self.__leftTime/3600 + 4))
            getOtherModule():showAlertDialog(nil, Localize.query("PVSecretPlaceMyMineInfo.7"))
        else
            getNetManager():getSecretPlaceNet():increase(data)
        end
    end

    local function getOnClick() --获取
        cclog("getOnClick")
        getAudioManager():playEffectButton2()
        -- if self.detailInfo:getNormalNum(0) + self.detailInfo:getLuckyNum(0) > 0 then
            data = {}
            data.position = 0
            getNetManager():getSecretPlaceNet():harvestStones(data)
        -- end
    end

    local function jichuOne()
        cclog("jichuOne")
        getAudioManager():playEffectButton2()

       local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 1 then
            return
        end

        self:alertBaseTips(1)
    end
    local function jichuTwo()
        cclog("jichuTwo")
        getAudioManager():playEffectButton2()
        local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 2 then
            return
        end

        self:alertBaseTips(2)
    end
    local function jichuThree()
        cclog("jichuThree")
        getAudioManager():playEffectButton2()
        local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 3 then
            return
        end

        self:alertBaseTips(3)
    end
    local function jichuFour()
        cclog("jichuThree")
        getAudioManager():playEffectButton2()
        local _nomals = self.detailInfo:getNormals()
        if table.nums(_nomals) < 4 then
            return
        end

        self:alertBaseTips(4)
    end
    
    local function luckyOne()
        cclog("luckyOne")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 1 then
            return
        end

        self:alertLuckyTips(1)
    end
    local function luckyTwo()
        cclog("luckyTwo")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 2 then
            return
        end

        self:alertLuckyTips(2)
    end
    local function luckyThree()
        cclog("luckyThree")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 3 then
            return
        end

        self:alertLuckyTips(3)
    end
    local function luckyFour()
        cclog("luckyFour")
        getAudioManager():playEffectButton2()
        local _luckys = self.detailInfo:getLuckys()
        if table.nums(_luckys) < 4 then
            return
        end

        self:alertLuckyTips(4)
    end

    self.UISecretMyMineInformation["UISecretMyMineInformation"] = {}

    self.UISecretMyMineInformation["UISecretMyMineInformation"]["zengchanOnClick"] = zengchanOnClick
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["getOnClick"] = getOnClick
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["onCloseClick"] = onCloseClick

    self.UISecretMyMineInformation["UISecretMyMineInformation"]["jichuOne"] = jichuOne
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["jichuTwo"] = jichuTwo
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["jichuThree"] = jichuThree
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["jichuFour"] = jichuFour

    self.UISecretMyMineInformation["UISecretMyMineInformation"]["luckyOne"] = luckyOne
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["luckyTwo"] = luckyTwo
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["luckyThree"] = luckyThree
    self.UISecretMyMineInformation["UISecretMyMineInformation"]["luckyFour"] = luckyFour
    
end


return PVSecretPlaceMyMineInfo
