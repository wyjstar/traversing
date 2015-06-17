ADD_POS = 8

local PVSmeltPanel = class("PVSmeltPanel", BaseUIView)

function PVSmeltPanel:ctor(id)
    self.super.ctor(self, id)
end

function PVSmeltPanel:onMVCEnter()
    self.c_runeData = getDataManager():getRuneData()

    self.c_runeNet = getNetManager():getRuneNet()

    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()


    self:registerDataBack()

    self:initData()
    self:initView()

end

--网络返回
function PVSmeltPanel:registerDataBack()
    --炼化返回
    local function smeltCallBack(id, data)
        --stone1 原石  stone2 晶石
        if data.res.result then
            --弹出恭喜获得原石符石界面
            local stones = {}
            if data.stone1 > 0 then
                local stoneItem = {}
                stoneItem.stone_type = 1
                stoneItem.stone_id = 14
                stoneItem.stone_num = data.stone1
                table.insert(stones, stoneItem)
            end
            if data.stone2 > 0 then
                local stoneItem2 = {}
                stoneItem2.stone_type = 1
                stoneItem2.stone_id = 15
                stoneItem2.stone_num = data.stone2
                table.insert(stones, stoneItem2)
            end

            if data.runt ~= nil then
                if table.getn(data.runt) > 0 then
                    for k,v in pairs(data.runt) do
                        self.c_runeData:updateNumById(1, v)
                        local stoneItem3 = {}
                        stoneItem3.stone_type = 2
                        stoneItem3.stone_id = data.runt.runt_id
                        stoneItem3.stone_num = 1
                        table.insert(stones, stoneItem3)
                    end
                end
            end
            local function callBack()
                getOtherModule():showOtherView("PVCongratulationsGainDialog", 3, stones)
            end
            self:runAction(cc.Sequence:create(cc.DelayTime:create(2.1),cc.CallFunc:create(callBack)))


            self.c_runeData:updateStone1Num(1, data.stone1)
            self.c_runeData:updateStone2Num(1, data.stone2)
            --背包数据相关更新
            for k, v in pairs(self.selectRunes) do
                self.c_runeData:updateNumById(2, v)
            end
            -- self.effectSprite2:setVisible(true)
            self.effectKuang:setVisible(true)
            self.animationManager:runAnimationsForSequenceNamed("effect2")
            -- self.animationManager:runAnimationsForSequenceNamedTweenDuration("effect2", 10)

            -- local node = UI_liantijiemian()
            -- node:setPosition(cc.p(-100,-200))
            -- self.effectLayer:addChild(node)
            local node  = UI_lianHuajiemian()
            node:setPosition(cc.p(0,50))
            self.effectLayer:addChild(node)

            self:updateSmeltBack()
        end
    end

    self:registerMsg(RUNE_SMELT, smeltCallBack)
end

--相关数据初始化
function PVSmeltPanel:initData()
    self.curIndex = 1
    self.smeltRunes = {}
end

--界面加载以及初始化
function PVSmeltPanel:initView()
    self.UISmeltPanel = {}
    self:initTouchListener()
    self:loadCCBI("rune/ui_rune_smelt.ccbi", self.UISmeltPanel)

    self.smeltRuneLayer = self.UISmeltPanel["UISmeltPanel"]["smeltRuneLayer"]
    self.effectLayer = self.UISmeltPanel["UISmeltPanel"]["effectLayer"]

    self.addRuneMenu = {}                   --添加符文按钮

    self.addRuneMenu[1] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu1"]
    self.addRuneMenu[2] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu2"]
    self.addRuneMenu[3] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu3"]
    self.addRuneMenu[4] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu4"]
    self.addRuneMenu[5] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu5"]
    self.addRuneMenu[6] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu6"]
    self.addRuneMenu[7] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu7"]
    self.addRuneMenu[8] = self.UISmeltPanel["UISmeltPanel"]["addRuneMenu8"]

    self.addRuneSprite = {}                 --添加符文图片表

    self.addRuneSprite[1] = self.UISmeltPanel["UISmeltPanel"]["runeAdd1"]
    self.addRuneSprite[2] = self.UISmeltPanel["UISmeltPanel"]["runeAdd2"]
    self.addRuneSprite[3] = self.UISmeltPanel["UISmeltPanel"]["runeAdd3"]
    self.addRuneSprite[4] = self.UISmeltPanel["UISmeltPanel"]["runeAdd4"]
    self.addRuneSprite[5] = self.UISmeltPanel["UISmeltPanel"]["runeAdd5"]
    self.addRuneSprite[6] = self.UISmeltPanel["UISmeltPanel"]["runeAdd6"]
    self.addRuneSprite[7] = self.UISmeltPanel["UISmeltPanel"]["runeAdd7"]
    self.addRuneSprite[8] = self.UISmeltPanel["UISmeltPanel"]["runeAdd8"]

    self.tabNormalImage = {}                 --标签图标列表
    self.tabSelectImage = {}

    self.tabSelectImage[1] = self.UISmeltPanel["UISmeltPanel"]["smeltRuneSelect"]
    self.tabNormalImage[1] = self.UISmeltPanel["UISmeltPanel"]["smeltRuneNor"]

    self.tabSelectImage[2] = self.UISmeltPanel["UISmeltPanel"]["smeltShopSelect"]
    self.tabNormalImage[2] = self.UISmeltPanel["UISmeltPanel"]["smeltShopNor"]

    self.tabMenu = {}                       --tab标签按钮

    self.runeMenuItem = self.UISmeltPanel["UISmeltPanel"]["runeMenuItem"]
    self.shopMenuItem = self.UISmeltPanel["UISmeltPanel"]["shopMenuItem"]

    self.animationManager = self.UISmeltPanel["UISmeltPanel"]["mAnimationManager"]

    self.effectSprite2 = self.UISmeltPanel["UISmeltPanel"]["effectSprite2"]
    self.effectKuang = self.UISmeltPanel["UISmeltPanel"]["effectKuang"]

    self.menuLayer = self.UISmeltPanel["UISmeltPanel"]["menuLayer"]

    self.effectNode = self.UISmeltPanel["UISmeltPanel"]["effectNode"]

    table.insert(self.tabMenu, self.runeMenuItem)
    table.insert(self.tabMenu, self.shopMenuItem)

    --menu标签页没有缩放效果
    for k,v in pairs(self.tabMenu) do
        v:setAllowScale(false)
    end

    self.effectKuang:setVisible(false)

    self.yuanValue = self.UISmeltPanel["UISmeltPanel"]["yuanValue"]                 --原石数量
    self.spariValue = self.UISmeltPanel["UISmeltPanel"]["spariValue"]               --晶石数量

    self.smeltMenuItem = self.UISmeltPanel["UISmeltPanel"]["smeltMenuItem"]

    --初始化原石和晶石的数量
    self.yuanValue:setString(self.c_runeData:getStone1())
    self.spariValue:setString(self.c_runeData:getStone2())

    --默认设置生命标签
    self:updateMenuByIndex(1)

    --初始化添加符文槽
    self:initAddRuneMenu()

end

--初始化添加符文槽
function PVSmeltPanel:initAddRuneMenu()
    for k,v in pairs(self.addRuneMenu) do
        v.isHave = false
        v.index = k
        v.curType = 0
        v.runeId = nil
        v.runtNo = nil
        self.addRuneSprite[k]:removeAllChildren()
        self.addRuneSprite[k]:setScale(1)
        self.addRuneSprite[k]:setSpriteFrame("ui_rune_add.png")
    end
end

--添加符文事件
function PVSmeltPanel:onAddRuneClick(index)
    self.curIndex = index
    local curRuneAdd = self.addRuneSprite[index]
    local posX, posY = curRuneAdd:getPosition()
    for k,v in pairs(self.addRuneMenu) do
        if k == index then
            if v.isHave then
                local runeItem = self:getCurItem(v.runtNo)
                print("runeItem =========== ", runeItem)

                -- local runeItem = {}
                -- runeItem.runt_id = v.runeId
                -- runeItem.runeType = v.curType
                -- runeItem.runePos = nil
                -- getOtherModule():showOtherView("PVRuneCheck", posX, posY, runeItem, 2)
                getOtherModule():showOtherView("PVRuneLook", runeItem, 2)
            else
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", 2)
            end
        end
    end
end

--标签页点击 更新标签状态
function PVSmeltPanel:updateMenuByIndex(index)
    local menuCount = table.getn(self.tabNormalImage)
    for  i = 1, menuCount do
        if i == index then
            self.tabNormalImage[i]:setVisible(false)
            self.tabSelectImage[i]:setVisible(true)
            self.tabMenu[i]:setEnabled(false)
        else
            self.tabNormalImage[i]:setVisible(true)
            self.tabSelectImage[i]:setVisible(false)
            self.tabMenu[i]:setEnabled(true)
        end
    end
end

function PVSmeltPanel:updateTabContent(index)
end

--界面监听事件
function PVSmeltPanel:initTouchListener()
    --炼化符文
    local function onSmeltRuneClick()
        getAudioManager():playEffectButton2()
        self.smeltRuneLayer:setVisible(true)
        self:updateMenuByIndex(1)
    end

    --炼化商人
    local function onSmeltShopClick()
        getAudioManager():playEffectButton2()
        -- getOtherModule():showToastView("暂未开放...")
    end

    --置入符文
    local function onInputRuneClick()
        getAudioManager():playEffectButton2()
        self.orderRunes = self.c_runeData:getSmeltRunes()
        self.selectRunes = self.orderRunes
        self.smeltRunes = {}
        local curAddMenus = {}
        if table.getn(self.orderRunes) > 0 then
            cclog("置入符文 ================= ")
            for k,v in pairs(self.orderRunes) do
                curAddMenus[k] = {}
                curAddMenus[k].runeId = v.runt_id
                curAddMenus[k].isHave = true
                curAddMenus[k].runtNo = v.runt_no
                table.insert(self.smeltRunes, v.runt_no)
            end
            self:updateRuneShow(curAddMenus)
        else
            -- getOtherModule():showToastView(Localize.query("rune.3"))
            getOtherModule():showAlertDialog(nil, Localize.query("rune.3"))

        end
    end

    --添加事件
    local function onAddRuneClick1()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(1)
    end

    local function onAddRuneClick2()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(2)
    end

    local function onAddRuneClick3()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(3)
    end

    local function onAddRuneClick4()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(4)
    end

    local function onAddRuneClick5()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(5)
    end

    local function onAddRuneClick6()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(6)
    end

    local function onAddRuneClick7()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(7)
    end

    local function onAddRuneClick8()
        getAudioManager():playEffectButton2()
        self:onAddRuneClick(8)
    end

    --符文背包
    local function onRuneBagClick()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", 2)
    end

    --打造符文
    local function onBuildRuneClick()
        cclog("打造符文 ================= ")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBuildPanel")
    end

    --点击熔炼
    local function onSmeltClick()
        getAudioManager():playEffectButton2()
        if self.selectRunes ~= nil then
            if table.getn(self.selectRunes) > 0 then
                local isSmelt = false
                for k,v in pairs(self.selectRunes) do
                    local quality = self.c_StoneTemplate:getStoneItemById(v.runt_id).quality
                    if quality >= 6 then
                        isSmelt = true
                    end
                end
                if isSmelt then
                    getOtherModule():showOtherView("SystemTips", Localize.query("rune.2"))
                else
                    -- self.menuLayer:setVisible(false)
                    self.c_runeNet:sendSmeltRunes(self.smeltRunes)
                end
            else
                -- getOtherModule():showToastView(Localize.query("rune.3"))
                getOtherModule():showAlertDialog(nil, Localize.query("rune.3"))

            end
        else
            -- getOtherModule():showToastView(Localize.query("rune.3"))
            getOtherModule():showAlertDialog(nil, Localize.query("rune.3"))

        end
    end

    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self.c_runeData:setSelectRunes(nil)
        self:onHideView()
    end

    self.UISmeltPanel["UISmeltPanel"] = {}

    self.UISmeltPanel["UISmeltPanel"]["onSmeltRuneClick"] = onSmeltRuneClick                    --炼化符文
    self.UISmeltPanel["UISmeltPanel"]["onSmeltShopClick"] = onSmeltShopClick                    --炼化商人
    self.UISmeltPanel["UISmeltPanel"]["onInputRuneClick"] = onInputRuneClick

    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick1"] = onAddRuneClick1
    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick2"] = onAddRuneClick2
    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick3"] = onAddRuneClick3
    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick4"] = onAddRuneClick4
    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick5"] = onAddRuneClick5
    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick6"] = onAddRuneClick6
    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick7"] = onAddRuneClick7
    self.UISmeltPanel["UISmeltPanel"]["onAddRuneClick8"] = onAddRuneClick8

    self.UISmeltPanel["UISmeltPanel"]["onRuneBagClick"] = onRuneBagClick                        --符文背包
    self.UISmeltPanel["UISmeltPanel"]["onBuildRuneClick"] = onBuildRuneClick                    --打造符文

    self.UISmeltPanel["UISmeltPanel"]["onSmeltClick"] = onSmeltClick                            --点击炼化

    self.UISmeltPanel["UISmeltPanel"]["onCloseClick"] = onCloseClick                            --关闭
end

function PVSmeltPanel:getCurItem(runtNo)
    for k, v in pairs(self.selectRunes) do
        if v.runt_no == runtNo then
            return v
        end
    end
end

--炼化后更新界面
function PVSmeltPanel:updateSmeltBack()
    local function CallFunc()
        self:stopAllActions()
        self.menuLayer:setVisible(true)
        self.effectSprite2:setVisible(false)
        self.effectKuang:setVisible(false)
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(CallFunc)))

    COMMON_TIPS_BOOL_RETURN = nil
    self.smeltRunes = {}
    self.c_runeData:setSelectRunes(nil)

    self:initAddRuneMenu()
    self.selectRunes = nil
    --原石和晶石数据更新
    self.yuanValue:setString(self.c_runeData:getStone1())
    self.spariValue:setString(self.c_runeData:getStone2())
end

--添加符文后回调
function PVSmeltPanel:updateAddRuneMenu(index, curRuneSprite, type, runeId)
    for k,v in pairs(self.addRuneSprite) do
        if k == index then
            v:setScale(0.9)
            setItemImage(v, "#" .. curRuneSprite, 2)            --更新icon
        end
    end

    for k,v in pairs(self.addRuneMenu) do
        if k == index then
            v.isHave = true
            v.curType = type
            v.runeId = runeId
        end
    end
end

--界面返回更新
function PVSmeltPanel:onBackUpdateView()
    self.selectRunes = self.c_runeData:getSelectRunes()
    print("self.selectRunes ============= ", table.getn(self.selectRunes))
    --熔炼符文列表初始化
    for k,v in pairs(self.selectRunes) do
        table.insert(self.smeltRunes, v.runt_no)
    end

    local selectRunes = clone(self.selectRunes)

    local addMenus = self.addRuneMenu
    self.deleteAddMenus = {}

    --过滤点应经镶嵌上的符文
    for k, v in pairs(addMenus) do
        if v.isHave then
            local result = self:isInSelectRunes(v.runeId)
            if result ~= nil then
                local curRes = 0
                if result > 1 then
                    curRes = result - (k - 1)
                else
                    curRes = result
                end
                table.insert(self.deleteAddMenus, k)
                table.remove(selectRunes, 1)
            end
        end
    end

    for i = self.curIndex, 8 do
        local addMenuItem = addMenus[i]
        local flag = self:isInDeletMenus(i)                                     --是否存在于应经镶嵌的按钮列表中
        --不存在时
        if not flag then
            if addMenuItem ~= nil then
                if addMenuItem.isHave == true then                              --标记是有符文、id已经不存在时
                    addMenuItem.isHave = false
                    addMenuItem.runeId = nil
                    addMenuItem.runtNo = nil
                end

                if addMenuItem.isHave == false then                             --标记是没有符文，id也不存在时
                    if table.getn(selectRunes) > 0 then
                        addMenuItem.runeId = selectRunes[1].runt_id
                        addMenuItem.isHave = true
                        addMenuItem.runtNo = selectRunes[1].runt_no
                        table.remove(selectRunes, 1)
                    end
                end
            end
        end
        i = i + 1

        if i > 8 then                                                       --添加个数满足8个时，遍历全部的找出未镶嵌的，按照顺序镶嵌
            for k,v in pairs(addMenus) do
                local flag = self:isInDeletMenus(i)
                if not flag then
                    if v.isHave == false then
                        if table.getn(selectRunes) > 0 then
                            v.runeId = selectRunes[1].runt_id
                            v.runtNo = selectRunes[1].runt_no
                            v.isHave = true
                            table.remove(selectRunes, 1)
                        end
                    else
                        local result = self:isInSelectRunes(v.runeId)
                        if result == nil then
                            v.isHave = false
                            v.runeId = nil
                            v.runtNo = nil
                        end
                    end
                end

                if k == self.curIndex then
                    break
                end
            end
        end
    end
    --更新界面显示
    self:updateRuneShow(addMenus)
end

function PVSmeltPanel:updateRuneShow(addMenus)
    --更新界面显示
    for k,v in pairs(addMenus) do
        if v.isHave and v.runeId ~= nil then
            local quality = self.c_StoneTemplate:getStoneItemById(v.runeId).quality
            local resId = self.c_StoneTemplate:getStoneItemById(v.runeId).res
            local resIcon = self.c_ResourceTemplate:getResourceById(resId)
            self.addRuneSprite[k]:setScale(0.9)
            self.c_runeData:setItemImage(self.addRuneSprite[k], "res/icon/rune/" .. resIcon, quality)
        else
            print("elf.addRuneSprite[k]:setScale(1) ============= ")
            self.addRuneSprite[k]:setScale(1)
            setItemImage(self.addRuneSprite[k], "#ui_rune_add.png", 0)
        end
    end
end

function PVSmeltPanel:onReloadView()
    if COMMON_TIPS_BOOL_RETURN then
        self.c_runeNet:sendSmeltRunes(self.smeltRunes)
    end
    if self.smeltRunes ~= nil then
        self.smeltRunes = {}
    end
    self:onBackUpdateView()
end

function PVSmeltPanel:isInSelectRunes(id)
    for k, v in pairs(self.selectRunes) do
        if v.runt_id == id then
            return k
        end
    end
    return  nil
end

function PVSmeltPanel:isInDeletMenus(index)
    if table.getn(self.deleteAddMenus) > 0 then
        for k, v in pairs(self.deleteAddMenus) do
            if index == v then
                return true
            end
        end
    end
    return  false
end



function PVSmeltPanel:clearResource()
end

return PVSmeltPanel
