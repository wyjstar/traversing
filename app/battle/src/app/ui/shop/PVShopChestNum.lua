

---------- 新版本被放弃 ------------

-- 抽取宝箱的第2个界面，输入要抽取的数量

local PVShopChestNum = class("PVShopChestNum", BaseUIView)


function PVShopChestNum:ctor(id)
    self.super.ctor(self, id)
    self:registerNetCallback()

    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
end


function PVShopChestNum:onMVCEnter()
    --初始化属性
    self:init()
    --绑定事件
    self:initTouchListener()
    --加载本界面的ccbi
    self:loadCCBI("shop/ui_shop_bxcq.ccbi", self.ccbiNode)
    --获取控件
    self:initVariable()
end

function PVShopChestNum:registerNetCallback()

    local function responseCallback(id, data)  
        print(" $$$$ ui response recruit hero", id, data)
        -- 统一 只 处理 抽取宝箱，武将抽取的由招募界面类处理
        if data.res.result == true then
            local commonData = getDataManager():getCommonData()
            local shopTemplate = getTemplateManager():getShopTemplate()
            -- 扣钱
            local _num = getDataManager():getShopData():getBuyEquipmentNumber()
            getDataManager():getShopData():setBuyEquipmentNumber(0)
            if SHOP_EQUIP_TYPE == 11 then
                if self.type == "free" then
                    commonData:setFineEquipment(commonData:getTime())
                else
                    commonData:subCoin(shopTemplate:getEquipUseMoney() * _num)  -- 扣除相应的钱
                end
            end
            if SHOP_EQUIP_TYPE == 12 then
                if self.type == "free" then
                    commonData:setExcellentEquipment(commonData:getTime())
                else
                    local gold = shopTemplate:getGodEquipUseMoney() * _num
                    commonData:subGold(gold)
                end
            end 
            -- 解析出购得的装备
            self:getAllEquipment(data.gain)

            -- 播放特效 
            local function callback()
                getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVShopShowCards", data.gain, 1)
            end
            -- 发光
            self:playAnimation( callback )
        else
            print("数据返回错误，CommomResponse.result = false")
            self:popStone() -- 弹出来
            self.__flag = false
        end

    end
    self:registerMsg(SHOP_REQUEST_ITEM_CODE, responseCallback)  -- 宝箱抽取的Response调用显示卡牌

end

-- 解析获取的物件
function PVShopChestNum:getAllEquipment(data)
    self.cardList = {}
    local index = 1
    for k,v in pairs(data) do
        if k == "equipments" then
            for _key,_equip in pairs(v) do
                local _name = self.equipTemp:getEquipName(_equip.no)
                local _img = self.equipTemp:getEquipResIcon(_equip.no)
                local _num = self.equipTemp:getQuality(_equip.no)
                self.cardList[index] = {type = 2, img = _img, starNum = _num}
                index = index + 1
            end
        elseif k == "equipment_chips" then
            for _key,_chip in pairs(v) do
                local _name = self.chipTemp:getChipName(_chip.equipment_chip_no)
                _name = _name .. " X " .. _chip.equipment_chip_num
                local _img = self.chipTemp:getChipIconById(_chip.equipment_chip_no)
                local _quality = self.chipTemp:getTemplateById(_chip.equipment_chip_no).quality
                self.cardList[index] = {type = 1, img = _img, starNum = _quality}
                index = index + 1
            end
        end
    end
    self.cardNumber = index - 1
end


function PVShopChestNum:sendNetMsg()

    local _shopTemplate = getTemplateManager():getShopTemplate()

    print("抽宝箱，个数：", self.currIndex)
    if SHOP_EQUIP_TYPE == 11 then
        if self.type == "free" then 
            getNetManager():getShopNet():sendBuyEquipMsg(1)
        else 
            if self:checkIsCanBuy( _shopTemplate:getEquipUseMoney()*self.currIndex,1 ) == true then  -- 买得起，才发送协议
                getDataManager():getShopData():setBuyEquipmentNumber(self.currIndex)
                getNetManager():getShopNet():sendBuyEquipMsg(self.currIndex)
            else
                print("!!!!!!!!!!! coin is not enough")
            end
        end
    end
    if SHOP_EQUIP_TYPE == 12 then 
        if self.type == "free" then 
            getNetManager():getShopNet():sendBuyEquipMsg(1)
        else 
            if self:checkIsCanBuy( _shopTemplate:getGodEquipUseMoney()*self.currIndex,2 ) == true then 
                getDataManager():getShopData():setBuyEquipmentNumber(self.currIndex)
                getNetManager():getShopNet():sendBuyGodEquipMsg(self.currIndex)
            else
                print("!!!!!!!!!!! gold is not enough")
            end
        end
    end

end

function PVShopChestNum:init()
    
    self.ccbiNode = {}
    self.ccbiRootNode = {}
    
    self.bgIn = nil   -- 外围空白区域，点击将推出

    self.type = self.funcTable[1]  -- "free":免费

end

function PVShopChestNum:initTouchListener()
    
    local function menuClick1()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(1)
    end
    local function menuClick2()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(2)
    end
    local function menuClick3()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(3)
    end
    local function menuClick4()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(4)
    end
    local function menuClick5()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(5)
    end
    local function menuClick6()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(6)
    end
    local function menuClick7()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(7)
    end
    local function menuClick8()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(8)
    end
    local function menuClick9()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(9)
    end
    local function menuClick10()
        getAudioManager():playEffectButton2()
        self:pushMenuBtn(10)
    end
    local function menuClickCancle()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    self.ccbiNode["UIShopBXCQ"] = {}
    self.ccbiNode["UIShopBXCQ"]["menuClick1"] = menuClick1
    self.ccbiNode["UIShopBXCQ"]["menuClick2"] = menuClick2
    self.ccbiNode["UIShopBXCQ"]["menuClick3"] = menuClick3
    self.ccbiNode["UIShopBXCQ"]["menuClick4"] = menuClick4
    self.ccbiNode["UIShopBXCQ"]["menuClick5"] = menuClick5
    self.ccbiNode["UIShopBXCQ"]["menuClick6"] = menuClick6
    self.ccbiNode["UIShopBXCQ"]["menuClick7"] = menuClick7
    self.ccbiNode["UIShopBXCQ"]["menuClick8"] = menuClick8
    self.ccbiNode["UIShopBXCQ"]["menuClick9"] = menuClick9
    self.ccbiNode["UIShopBXCQ"]["menuClick10"] = menuClick10
    self.ccbiNode["UIShopBXCQ"]["menuClickBack"] = menuClickCancle
end


function PVShopChestNum:initVariable()

    self.ccbiRootNode = self.ccbiNode["UIShopBXCQ"]
    self.animationNode = self.ccbiRootNode["animationNode"]
    self.actionManager = self.ccbiRootNode["mAnimationManager"]

    self.labelCoin = self.ccbiRootNode["label_screen"]
    self.labelGold = self.ccbiRootNode["label_gold"]
    self.img_titleLight = self.ccbiRootNode["img_light_xyhf"]
    self.layer_stone = self.ccbiRootNode["layer_stone"]
    self.img_stone = self.ccbiRootNode["img_stone"]
    self.allNode = self.ccbiRootNode["all_node"]

    -- node for liang zi
    self.stoneLight = self.ccbiRootNode["img_stone_light"]
    self.lightYun = self.ccbiRootNode["img_light_yun"]
    self.lightBg = self.ccbiRootNode["img_bg_light"]
    self.nodeFntHalfLight = self.ccbiRootNode["node_liang"]
    self.nodeBtnLight = self.ccbiRootNode["node_light"]
    self.nodeBtnLight:setVisible(true)
    self.nodeWeiAn = self.ccbiRootNode["node_weian"]
    self.nodeWeiAn:setVisible(true)
    
    self.menuBtn = {} -- 按钮集
    self.imgFntLight = {} -- 按钮高亮字集
    self.btnLight = {}
    self.imgSlot = {} -- 槽
    for i=1, 10 do
        local menuStr = "menu_" .. tostring(i)
        local fntStr = "fnt_light" .. tostring(i)
        local slotStr = "slot_" .. tostring(i)
        local btnLightStr = "btn_light" .. tostring(i) 
        table.insert(self.menuBtn, self.ccbiRootNode[menuStr])
        table.insert(self.imgFntLight, self.ccbiRootNode[fntStr])
        table.insert(self.imgSlot, self.ccbiRootNode[slotStr])
        table.insert(self.btnLight, self.ccbiRootNode[btnLightStr])
    end

    for k,v in pairs(self.menuBtn) do
        v:getSelectedImage():setVisible(false)
        v:setAllowScale(false)
    end

    -- 文字高亮取消
    for k,v in pairs(self.imgFntLight) do
        v:setVisible(false)
    end

    -- 设置属性
    self.labelCoin:setString(0)
    self.labelGold:setString(0)

    -- 为中心stone设置点击事件
    local size = self.layer_stone:getContentSize()
    local rectArea = cc.rect(0, 0, size.width, size.height)
    self.layer_stone:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.layer_stone:setTouchEnabled(true)
    self.__flag = false
    local function onTouchEvent(eventType, x, y)
        local _pos = self.layer_stone:convertToNodeSpace(cc.p(x,y))
        local isInRect = cc.rectContainsPoint(rectArea, _pos)
        if eventType == "began" and self.__flag == false then
            if isInRect and self.isCanPlayLight == true then
                getAudioManager():playEffectButton2()
                self.__flag = true
                -- 按下效果
                self:pushStone()
                -- 不能再点击menu了
            end
        end
    end
    self.layer_stone:registerScriptTouchHandler(onTouchEvent)

    -- 初始状态特效都未开启
    self:hideLightEffect()
    self:hideSlot()

    if self.type == "free" then self:goFree() end -- 直接进入
end

--启动特效
function PVShopChestNum:playAnimation(callback)
    self:showSlotEffect()
    local function stoneShow()
        print("play animtion over ...")
        self.img_stone:setVisible(true)
        self.img_stone:setScale(1,1)
        self.img_stone:setPosition(317, 626)
    end
    local function playOver()
        -- 展示抽到的奖励
        print("play showcard ")
        for i=1, self.cardNumber do
            local _curIdx = self._randList[i]
            self:showCard(_curIdx)
            local cardInfo = self.cardList[i]
            local card = game.newSprite()
            -- setItemImage(card, cardInfo.img, cardInfo.starNum)
            changeEquipIconImageBottom(card, cardInfo.img, cardInfo.starNum)
            local size = self.imgSlot[_curIdx]:getContentSize()
            card:setPosition(size.width/2, size.height/2)
            self.imgSlot[_curIdx]:addChild(card)
        end
        self:hideLightEffect()
        self:runAction( cc.Sequence:create(cc.DelayTime:create(1.2), createCallFun(callback)) )
    end

    local node = UI_Zhuangbeichouqu(stoneShow, playOver) -- 播放例子效果 
    self.animationNode:addChild(node)

    local function stoneHide()
        self.img_stone:setVisible(false)
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), createCallFun(stoneHide)))
end

function PVShopChestNum:showCard(index)
    -- print("!!!!!!!!!!!!!!!!:", index)
    local posX, posY = self.imgSlot[index]:getPosition()
    local node = UI_ZhuangbeichouquShowCard(posX, posY)
    self.animationNode:addChild(node)
end

--产生随机序列
function PVShopChestNum:createRandomList(len)
    math.randomseed(tostring(os.time()):reverse():sub(1,6))
    math.random(1, len)
    local tab = {}
    for i=1,len do
        tab[i] = i
    end
    for i=1,len do
        local x = math.random(i, len)
        local temp = tab[i]
        tab[i] = tab[x]
        tab[x] = temp
    end
    for k,v in pairs(tab) do
        print(v)
    end
    return tab
end

--按下某按钮的效果
function PVShopChestNum:pushMenuBtn(index)

    if self.__flag == true then print("运行期间不允许再改") ; return end

    self.currIndex = index

    for i=1,10 do
        self.menuBtn[i]:setEnabled(true)
        self.imgFntLight[i]:setVisible(false)
        if self.isLight == true then self.btnLight[index]:setVisible(true) end
    end

    self.menuBtn[index]:setEnabled(false)
    self.imgFntLight[index]:setVisible(true)
    self.btnLight[index]:setVisible(false)

    local shopTemplate = getTemplateManager():getShopTemplate()
    -- 统计钱
    if SHOP_EQUIP_TYPE == 11 then 
        local _money = shopTemplate:getEquipUseMoney() * self.currIndex
        self.labelCoin:setString(_money)
    elseif SHOP_EQUIP_TYPE == 12 then
        local _money = shopTemplate:getGodEquipUseMoney() * self.currIndex
        self.labelGold:setString(_money)
    end

    if self._isStartPop ~= true then
        self:runShookAction()
    end

    self:showLightEffect()
end

--漂浮效果
function PVShopChestNum:runFloatAction()
    local act1 = cc.ScaleTo:create(0.5, 1.09) --cc.MoveBy:create(0.4, cc.p(0, -20))
    local act2 = cc.ScaleTo:create(1.4/3, 1.08) --cc.MoveBy:create(0.4, cc.p(0,  20))
    local repeatMove = createRepeatAction(cc.Sequence:create(act1, act2))
    repeatMove:setTag(100)
    self.img_stone:runAction(repeatMove)
end

--抖动效果
function PVShopChestNum:runShookAction()
    self._isStartPop = true

    local function callback()
        self.isCanPlayLight = true
        self:runFloatAction()
    end
    self.actionManager:runAnimationsForSequenceNamed("stone_out_act")
    local delayAct = cc.DelayTime:create(2.5)
    local callbackAct = createCallFun(callback)
    self.img_stone:runAction(cc.Sequence:create(
        delayAct,callbackAct))
end

--按下stone，停下石头的悬浮效果
function PVShopChestNum:pushStone()
    -- 停下悬浮
    self.img_stone:stopAllActions()
    -- 添加被按下的效果
    local function callBack()
        self:sendNetMsg()
        local move1 = cc.MoveTo:create(1/30*2, cc.p(2,0))
        local move2 = cc.MoveTo:create(1/30*2, cc.p(1,2))
        local move3 = cc.MoveTo:create(1/30*2, cc.p(-1,0))
        local move4 = cc.MoveTo:create(1/30*2, cc.p(1,2))
        local move5 = cc.MoveTo:create(1/30*2, cc.p(-1,2))
        local move6 = cc.MoveTo:create(1/30*2, cc.p(1,-2))
        local move7 = cc.MoveTo:create(1/30*2, cc.p(-1,2))
        local move8 = cc.MoveTo:create(1/30*2, cc.p(1,-2))
        local move9 = cc.MoveTo:create(1/30*2, cc.p(-1,2))
        local move10 = cc.MoveTo:create(1/30*2, cc.p(2,-3))
        local move11 = cc.MoveTo:create(1/30*2, cc.p(2,2))
        local move12 = cc.MoveTo:create(1/30*2, cc.p(1,-3))
        local move13 = cc.MoveTo:create(1/30*2, cc.p(-2,4))
        local move14 = cc.MoveTo:create(1/30*2, cc.p(3,-2))
        local move15 = cc.MoveTo:create(1/30*2, cc.p(0,0))
        local seqAct = cc.Sequence:create(move1,move2,move3,move4,move5,move6,move7,move8,move9,move10,move11,
            move12,move13,move14,move15)
        self.allNode:runAction(seqAct)

    end
    local scaleAct = cc.ScaleTo:create(0.2, 1)
    local moveAct = cc.MoveTo:create(0.2, cc.p(315, 606))
    local act1 = cc.Spawn:create({scaleAct, moveAct})
    local scale1 = cc.ScaleTo:create(0.1, 0.9)
    local scale2 = cc.ScaleTo:create(0.1, 1)
    local seqAct = cc.Sequence:create(act1, scale1, scale2, createCallFun(callBack))
    self.img_stone:runAction(seqAct)
end

--当没有能抽奖时，弹起
function PVShopChestNum:popStone()
    -- 停下悬浮
    self.img_stone:stopAllActions()
    -- 添加效果
    local function callBack()
        self:runFloatAction()
    end
    local scaleAct = cc.ScaleTo:create(1/30*4, 1.1)
    local scaleAct2 = cc.ScaleTo:create(1/30*3, 1.13)
    -- local moveAct = cc.MoveTo:create(1/30*3, cc.p(315, 626))
    local scaleAct3 = cc.ScaleTo:create(1/30*1, 1)
    local seqAct = cc.Sequence:create(scaleAct, scaleAct2, scaleAct3, createCallFun(callBack))
    self.img_stone:runAction(seqAct)
end

--显示光效
function PVShopChestNum:showLightEffect()
    self.isLight = true
    self:runLighting(self.nodeFntHalfLight)
    for k,v in pairs(self.btnLight) do
        self:runLighting(v)
    end
    self:runLighting(self.img_titleLight)
    self:runLighting(self.stoneLight)
    self:runLighting(self.lightBg)
    self:runLighting(self.lightYun)

    if self.currIndex then self.btnLight[self.currIndex]:setVisible(false) end

    -- 中央石头闪光特效
    local node = UI_Zhuangbeichouqudianji()
    self.animationNode:addChild(node)
end

--关闭光效
function PVShopChestNum:hideLightEffect()
    self.isLight = false
    self.nodeFntHalfLight:setVisible(false)
    for k,v in pairs(self.btnLight) do
        v:setVisible(false)
    end
    self.img_titleLight:setVisible(false)
    self.stoneLight:setVisible(false)
    self.lightBg:setVisible(false)
    self.lightYun:setVisible(false)
end

-- 为node运行光效
function PVShopChestNum:runLighting(node)
    node:setVisible(true)
    node:setOpacity(0)
    local act1 = cc.FadeIn:create(0.2)
    node:runAction(cc.Sequence:create(act1))
end

-- 为node运行消除光效
function PVShopChestNum:stopLighting(node)
    node:runAction(cc.FadeOut:create(1.5))
    node:setVisible(false)
end

--隐藏槽
function PVShopChestNum:hideSlot()
    for k,v in pairs(self.imgSlot) do
        v:setVisible(false)
    end
end

--显示槽效果
function PVShopChestNum:showSlotEffect()
    for k,v in pairs(self.imgSlot) do
        v:setVisible(true)
        v:setOpacity(0)
    end
    self._randList = self:createRandomList(10)
    local _delayTime = 1.5
    for i,v in ipairs(self._randList) do
        self.imgSlot[v]:runAction(cc.Sequence:create({
            cc.DelayTime:create(_delayTime),
            cc.FadeIn:create(0.2)}) )
        _delayTime = _delayTime + 0.3 - 0.03*i
    end
end

--检查是否可以购买
--@param type: 1 coin, 2 gold
function PVShopChestNum:checkIsCanBuy(money, type)

    local commonData = getDataManager():getCommonData()
    if type == 1 then 
        if commonData:getCoin() < money then return false
        else return true end
    else
        if commonData:getGold() < money then return false
        else return true end
    end
end

--对免费情况直接进入产生装备
function PVShopChestNum:goFree()
    self.currIndex = 1
    self.__flag = true
    self._isStartPop = true
    self:showLightEffect()
    self:pushStone()
end

-- 更新界面
function PVShopChestNum:onReloadView()

    if SHOP_PAST_PAGE_HIDEVIEW == true then
        self:onHideView()
    else
        
    end

end

--@return 
return PVShopChestNum


