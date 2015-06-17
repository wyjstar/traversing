
-- 炼化
-- 武将献祭、装备熔炼、符文熔炼
-- 传参，1：武将献祭  2：装备熔炼   3：符文熔炼
local PVSmeltView = class("PVSmeltView", BaseUIView)

function PVSmeltView:ctor(id)
    self.super.ctor(self, id)


    self.isMenuCanTouch = true
    -- 装备熔炼
    self.numAdded = 0

    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.equipData = getDataManager():getEquipmentData()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()  -- 中文
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.lineupData = getDataManager():getLineupData()
    self.commonData = getDataManager():getCommonData()
    self.c_runeData = getDataManager():getRuneData()
    self.c_runeNet = getNetManager():getRuneNet()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    self.c_Calculation = getCalculationManager():getCalculation()

    -- 清下选择的熔炼物品
    self.equipData:setSmeltIDs({})
end

function PVSmeltView:onMVCEnter()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_smelt.plist")
    -- 符文炼化
    -- self:registerDataBack()

    self.UISmeltView = {}
    -- 武将献祭
    self:showAttributeView()
    self.UISacrificeView = {}
    self.herosData = {}
    self.soldierData = getDataManager():getLineupData():getChangeCheerSoldier()
    self.SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.commonData = getDataManager():getCommonData()
    self.HeroSacrificeResponse = {}
    self.generalHead = {}
    self.totalSelect = {}
    self.addOneKey = false

    -- 装备熔炼
    -- self:showAttributeView()
    self.UIEquipment = {}
    -- self.currSubMenuIdx = 1


    self:initTouchListener()
    --加载本界面的ccbi
    self:loadCCBI("soul/ui_smelt_view.ccbi", self.UISmeltView)

    self:initView()
    self:initData()
    -- 武将献祭
    self:initRegisterNetCallBack()      -- 网络协议回调
    self:updateUIData()

    self.c_runeData:setSelectRunes(nil)
    self.orderRunes = {}

    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end
    -- self:registerScriptHandler(onNodeEvent)

    -- 装备熔炼
end

function PVSmeltView:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
    getDataManager():getResourceData():clearResourcePlistTexture()
end


function PVSmeltView:initView()
    self.stone1Num = self.c_runeData:getStone1()
    self.stone2Num = self.c_runeData:getStone2()

    self.soldierNode = self.UISmeltView["UISmeltView"]["soldierNode"]
    self.smeltLayer = self.UISmeltView["UISmeltView"]["smeltLayer"]
    self.runeNode = self.UISmeltView["UISmeltView"]["runeNode"]

    self.bg_wujiang = self.UISmeltView["UISmeltView"]["bg_wujiang"]
    self.bg_zhuangbei = self.UISmeltView["UISmeltView"]["bg_zhuangbei"]
    self.bg_fuwen = self.UISmeltView["UISmeltView"]["bg_fuwen"]

    self.soldierSelect = self.UISmeltView["UISmeltView"]["soldierSelect"]
    self.soldierNormal = self.UISmeltView["UISmeltView"]["soldierNormal"]
    self.equipSelect = self.UISmeltView["UISmeltView"]["equipSelect"]
    self.equipNor = self.UISmeltView["UISmeltView"]["equipNor"]
    self.runeSelect = self.UISmeltView["UISmeltView"]["runeSelect"]
    self.runeNormal = self.UISmeltView["UISmeltView"]["runeNormal"]

    self.oweEquipsoul = self.UISmeltView["UISmeltView"]["owe_equipsoul_num"]     --拥有的装备精华
    self.oweCoin = self.UISmeltView["UISmeltView"]["owe_coin"]              --拥有的银两
    self.oweSpari = self.UISmeltView["UISmeltView"]["owe_spari"]                --拥有的晶石
    self.oweRaw = self.UISmeltView["UISmeltView"]["owe_raw"]                --拥有的原石

    self.menuTable = {} --4个按钮
    self.menuA = self.UISmeltView["UISmeltView"]["soldierBtn"]
    self.menuB = self.UISmeltView["UISmeltView"]["equipBtn"]
    self.menuC = self.UISmeltView["UISmeltView"]["runeBtn"]
    table.insert(self.menuTable, self.menuA)
    table.insert(self.menuTable, self.menuB)
    table.insert(self.menuTable, self.menuC)

    for k,v in pairs(self.menuTable) do
        v:setAllowScale(false)
    end


--武将献祭
    -- self.soulNumber = self.UISmeltView["UISmeltView"]["soulNumber"]

    -- for i=1,5 do
    --     self.generalHead[i] = {}
    --     local  strName = string.format("headImg%d", i)
    --     self.generalHead[i].headImg = self.UISmeltView["UISmeltView"][strName]

    --     strName = string.format("headImg%d_q", i)
    --     self.generalHead[i].headImgq = self.UISmeltView["UISmeltView"][strName]
    --     self.generalHead[i].isSelect = false
    --     self.generalHead[i].hero = {}
    --     --来创建一个类型来判断是武将还是碎片
    --     self.generalHead[i].headImgq:setVisible(false)
    --     self.generalHead[i].type = nil
    -- end
     for i=1,8 do
        self.generalHead[i] = {}
        local  strName = string.format("headImg%d", i)
        self.generalHead[i].headImg = self.UISmeltView["UISmeltView"][strName]

        strName = string.format("headImg%d_q", i)
        self.generalHead[i].headImgq = self.UISmeltView["UISmeltView"][strName]

        strName = string.format("menuCancle%d", i)
        self.generalHead[i].menuCancle = self.UISmeltView["UISmeltView"][strName]

        self.generalHead[i].isSelect = false
        self.generalHead[i].hero = {}
        --来创建一个类型来判断是武将还是碎片
        self.generalHead[i].headImg:setVisible(false)
        self.generalHead[i].headImgq:setVisible(false)
        self.generalHead[i].menuCancle:setVisible(false)
        self.generalHead[i].type = nil
    end

    self.gainSoulNumLabel = self.UISmeltView["UISmeltView"]["gainSoulNumLabel"]
    self.expProNum = self.UISmeltView["UISmeltView"]["expProNum"]
    self.totalSoulNumLabel = self.UISmeltView["UISmeltView"]["totalSoulNumLabel"]

    self.exp_node = self.UISmeltView["UISmeltView"]["exp_node"]
    self.exp_node:setVisible(false)
    self.gain_exp = self.UISmeltView["UISmeltView"]["gain_exp"]
    -- self.gain_soul = self.UISmeltView["UISmeltView"]["gain_soul"]

    -- self.item1 = self.UISmeltView["UISmeltView"]["item1"]
    -- self.item2 = self.UISmeltView["UISmeltView"]["item2"]

    -- self.item1:setAllowScale(false)
    -- self.item2:setAllowScale(false)

    self.sacrificeMenuItem = self.UISmeltView["UISmeltView"]["sacrificeMenuItem"]
    self.oneAddKey = self.UISmeltView["UISmeltView"]["oneAddKey"]
     -- SpriteGrayUtil:drawSpriteTextureGray(self.sacrificeMenuItem:getNormalImage())
    self.animationNode = self.UISmeltView["UISmeltView"]["animationNode"]



-- 装备熔炼
    self.qitaNode = self.UISmeltView["UISmeltView"]["qita"]

    self.equipSoulNum = self.UISmeltView["UISmeltView"]["equipsoul_num"]
    self.coinStreng = self.UISmeltView["UISmeltView"]["coinStreng"]
    -- self.equipSoulNum:setString( self.commonData:getEquipSoul() )
    self.equipSoulNum:setString(0)
    self.coinStreng:setString(0)
    
    -- self.smeltTouchLayer = self.UISmeltView["UISmeltView"]["smelt_touchlayer"]

    self.smeltMenu = self.UISmeltView["UISmeltView"]["menu_equip_smelt"]
    -- self.smeltMenu:getSelectedImage():setScale(1.3)
    self.menuOneKeyAdd = self.UISmeltView["UISmeltView"]["smeltInputItem"]
    self.menuSmeltShop = self.UISmeltView["UISmeltView"]["menu_smelt_shop"]

    self.nodeNumber = self.UISmeltView["UISmeltView"]["num_node"]   --数量label的Node

    self.menuAddSmelt = {}
    self.imgAdd = {}
    self.equipImg = {}
    self.menuCancelEquip = {}
    for i=1,8 do
        local strname = "addEquipMenu"..tostring(i)
        table.insert(self.menuAddSmelt, self.UISmeltView["UISmeltView"][strname])
        strname = "equipAdd"..tostring(i)
        table.insert(self.imgAdd, self.UISmeltView["UISmeltView"][strname])
        strname = "equipImg"..tostring(i)
        table.insert(self.equipImg, self.UISmeltView["UISmeltView"][strname])
        strname = "menuCancleEquip"..tostring(i)
        table.insert(self.menuCancelEquip, self.UISmeltView["UISmeltView"][strname])
    end

    self.ronglianNode = self.UISmeltView["UISmeltView"]["ronglian"]
    self.animationNodeEquip = self.UISmeltView["UISmeltView"]["animationNodeEquip"]
    self.smeltEffectFrame = self.UISmeltView["UISmeltView"]["effect_frame"]
    self.smeltEffectFrame:setVisible(false)
    self.smeltEffectFire = self.UISmeltView["UISmeltView"]["img_eff_smelt"]


    local node = UI_ZhuangbeironglianHode()
    -- node:setPosition(cc.p(500,800))
    self.ronglianNode:addChild(node)

    local action1 = cc.FadeTo:create(1, 50)
    local action2 = cc.FadeTo:create(1, 255)
    local seq = cc.Sequence:create(action1, action2)
    self.smeltEffectFire:runAction(cc.RepeatForever:create(seq))


-- 符文炼化

    self.smeltRuneLayer = self.UISmeltView["UISmeltView"]["smeltRuneLayer"]
    self.effectLayer = self.UISmeltView["UISmeltView"]["effectLayer"]

    self.addRuneMenu = {}                   --添加符文按钮
    self.addRuneMenu[1] = self.UISmeltView["UISmeltView"]["addRuneMenu1"]
    self.addRuneMenu[2] = self.UISmeltView["UISmeltView"]["addRuneMenu2"]
    self.addRuneMenu[3] = self.UISmeltView["UISmeltView"]["addRuneMenu3"]
    self.addRuneMenu[4] = self.UISmeltView["UISmeltView"]["addRuneMenu4"]
    self.addRuneMenu[5] = self.UISmeltView["UISmeltView"]["addRuneMenu5"]
    self.addRuneMenu[6] = self.UISmeltView["UISmeltView"]["addRuneMenu6"]
    self.addRuneMenu[7] = self.UISmeltView["UISmeltView"]["addRuneMenu7"]
    self.addRuneMenu[8] = self.UISmeltView["UISmeltView"]["addRuneMenu8"]

    self.addRuneSprite = {}                 --添加符文图片表
    self.addRuneSprite[1] = self.UISmeltView["UISmeltView"]["runeAdd1"]
    self.addRuneSprite[2] = self.UISmeltView["UISmeltView"]["runeAdd2"]
    self.addRuneSprite[3] = self.UISmeltView["UISmeltView"]["runeAdd3"]
    self.addRuneSprite[4] = self.UISmeltView["UISmeltView"]["runeAdd4"]
    self.addRuneSprite[5] = self.UISmeltView["UISmeltView"]["runeAdd5"]
    self.addRuneSprite[6] = self.UISmeltView["UISmeltView"]["runeAdd6"]
    self.addRuneSprite[7] = self.UISmeltView["UISmeltView"]["runeAdd7"]
    self.addRuneSprite[8] = self.UISmeltView["UISmeltView"]["runeAdd8"]

    self.cancelRuneMenu = {}                 --删除符文按钮
    self.cancelRuneMenu[1] = self.UISmeltView["UISmeltView"]["menuCancleRune1"]
    self.cancelRuneMenu[2] = self.UISmeltView["UISmeltView"]["menuCancleRune2"]
    self.cancelRuneMenu[3] = self.UISmeltView["UISmeltView"]["menuCancleRune3"]
    self.cancelRuneMenu[4] = self.UISmeltView["UISmeltView"]["menuCancleRune4"]
    self.cancelRuneMenu[5] = self.UISmeltView["UISmeltView"]["menuCancleRune5"]
    self.cancelRuneMenu[6] = self.UISmeltView["UISmeltView"]["menuCancleRune6"]
    self.cancelRuneMenu[7] = self.UISmeltView["UISmeltView"]["menuCancleRune7"]
    self.cancelRuneMenu[8] = self.UISmeltView["UISmeltView"]["menuCancleRune8"]

    self.animationManager = self.UISmeltView["UISmeltView"]["mAnimationManager"]

    self.effectSprite2 = self.UISmeltView["UISmeltView"]["effectSprite2"]
    self.effectKuang = self.UISmeltView["UISmeltView"]["effectKuang"]

    self.menuLayer = self.UISmeltView["UISmeltView"]["menuLayer"]

    self.effectNode = self.UISmeltView["UISmeltView"]["effectNode"]


    self.effectKuang:setVisible(false)

    self.yuanValue = self.UISmeltView["UISmeltView"]["yuanValue"]                 --原石数量
    self.spariValue = self.UISmeltView["UISmeltView"]["spariValue"]               --晶石数量

    self.smeltMenuItem = self.UISmeltView["UISmeltView"]["smeltMenuItem"]
    self.smeltInputItem1 = self.UISmeltView["UISmeltView"]["smeltInputItemRune"]


    --初始化原石和晶石的数量
    self.yuanValue:setString(0)
    self.spariValue:setString(0)
    self.oweRaw:setString(self.stone1Num)
    self.oweSpari:setString(self.stone2Num)

    --初始化添加符文槽
    self:initAddRuneMenu()
end
--初始化添加符文槽
function PVSmeltView:initAddRuneMenu()
    for k,v in pairs(self.addRuneMenu) do
        v.isHave = false
        v.index = k
        v.curType = 0
        v.runt_id = nil
        v.runt_no = nil
        self.addRuneSprite[k]:removeAllChildren()
        self.addRuneSprite[k]:setScale(1)
        self.cancelRuneMenu[k]:setVisible(false)
        -- self.addRuneSprite[k]:setSpriteFrame("ui_rune_add.png")
    end
end

-- 添加符文 事件
function PVSmeltView:onAddRuneClick(index)
    self.curIndex = index
    local curRuneAdd = self.addRuneSprite[index]
    local posX, posY = curRuneAdd:getPosition()
    for k,v in pairs(self.addRuneMenu) do
        if k == index then
            if v.isHave then
                local runeItem = self:getCurItem(v.runt_no)
                local runeType = self.c_StoneTemplate:getStoneItemById(v.runt_id).type
                runeItem.runeType = runeType
                runeItem.runePos = index
                getOtherModule():showOtherView("PVRuneLook", runeItem, 2)
            else
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", 2)
            end
        end
    end
end


function PVSmeltView:initData()
    self.curIndex = self:getTransferData()[1]

    if self.curIndex == nil then self:onSlidingMenuChange(1)
    else self:onSlidingMenuChange(self.curIndex) end

    -- 武将献祭
    self.gainSoulNumLabel:setString("0")
    self.expProNum:setString("")
    self.totalSoulNumLabel:setString(self.commonData:getFinance(3))

    self.allEquipments = self.equipData:getEquipList()

    self.curIndex = 1
    self.smeltRunes = {}

end

function PVSmeltView:getIsEquip(id)
    local _equipedWho = self.lineupData:getEquipTo(id)
    if _equipedWho == Localize.query("equip.1") then
        return 0
    else
        return 1
    end
end

function PVSmeltView:initRegisterNetCallBack()
    function onReciveMsgCallBack(_id)
        if _id == NET_ID_HERO_REQUEST then -- 获取武将列表
            self:updateUIData(_id)
        elseif _id == HERO_SACRIFICE_REQUEST then -- 献祭
            self.diaFlag = true
            self:onUpdateSacrificeUI()
        end
    end

    local function responseComposeCallback(id, data)
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            local _equip = data.equ

            local _useNum = self.chipTemp:getTemplateById(self.request_chipNo).needNum
            self.equipData:subChips(self.request_chipNo, _useNum) -- 在DataCetner中减去消耗掉的碎片
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipShowCard", {_equip})
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", _equip) --合成了装备，采用跳转到装备详情界面
        end
    end
    local function responseMeltingCallback(id, data)
        --显示被溶解后的东西
        if data.res.result ~= true then
            print("!!! 数据返回错误")
            self.menuSmeltShop:setEnabled(true)
            self.smeltMenu:setEnabled(true)
        else
            local _list = self.equipData:getSmeltIDs()

             local function callbackProcessEquipData()   --  为了熔炼后的UI显示不能立马清除装备
                self.equipData:setSmeltIDs({})  -- 情空
                for k,v in pairs(_list) do
                    local _no = self.equipData:getEquipById(v).no
                    self.lineupData:removeEquipOnHero(_no)  -- 阵容上移除装备
                    self.equipData:removeEquip(v)  -- 移除后将查不到了，所以先传值显示，再删除
                end
            end
            local function callback()
                local _list = self.equipData:getSmeltIDs()
                self.equipData:setSmeltIDs({})  -- 情空

                local function showDialog()
                    if table.nums(_list) ~= 0 then
                        SpriteGrayUtil:drawSpriteTextureColor(self.menuSmeltShop:getNormalImage())
                        SpriteGrayUtil:drawSpriteTextureColor(self.smeltMenu:getNormalImage())
                        SpriteGrayUtil:drawSpriteTextureColor(self.menuOneKeyAdd:getNormalImage())
                        self.menuOneKeyAdd:setEnabled(true)
                        self.menuSmeltShop:setEnabled(true)
                        self.smeltMenu:setEnabled(true)

                        getOtherModule():showOtherView("PVEquipmentSmelting", _list, data.cgr)
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipmentSmelting", self.melting_equipList, data.cgr)

                        -- 处理熔炼后的装备数据
                        callbackProcessEquipData()

                        local function setTouchedInAni()
                            --self.smeltAnimation = false
                            print("remove ShieldLayer")
                            self:removeTopShieldLayer()
                        end

                        if getNewGManager():getCurrentGid()==GuideId.G_GUIDE_40072 then
                            local seq = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(setTouchedInAni))
                            self:runAction(seq)
                        end

                        groupCallBack(GuideGroupKey.BTN_CLICK_LIANHUA)
                    end

                    for k,v in pairs(_list) do
                        local _no = self.equipData:getEquipById(v).no
                        self.lineupData:removeEquipOnHero(_no)  -- 阵容上移除装备

                        self.equipData:removeEquip(v)  -- 移除后将查不到了，所以先传值显示，再删除
                    end

                    self.oweCoin:setString(self.commonData:getFinance(1))
                    self.oweEquipsoul:setString(self.commonData:getFinance(21))
                end

                self.smeltEffectFrame:setVisible(true)
                self.smeltEffectFrame:setOpacity(255)
                local action1 = cc.FadeTo:create(0.5, 0)
                local action2 = cc.CallFunc:create(showDialog)
                local seq = cc.Sequence:create(action1, action2)
                self.smeltEffectFrame:runAction(seq)
            end

            local node = UI_zhuangbeironglian(callback)
            -- local node = UI_zhuangbeironglian()
            self.animationNodeEquip:addChild(node)
        end
    end
    --符文炼化返回
    local function smeltCallBack(id, data)
        if data.res.result then
            local stones = {}
            --stone1 原石
            if data.stone1 > 0 then
                local stoneItem = {}
                stoneItem.stone_type = 1
                stoneItem.stone_id = 14
                stoneItem.stone_num = data.stone1
                table.insert(stones, stoneItem)
            end
            --stone2 晶石
            if data.stone2 > 0 then
                local stoneItem2 = {}
                stoneItem2.stone_type = 1
                stoneItem2.stone_id = 15
                stoneItem2.stone_num = data.stone2
                table.insert(stones, stoneItem2)
            end
            --炼化获取的符文
            if data.runt ~= nil then
                if table.getn(data.runt) > 0 then
                    for k,v in pairs(data.runt) do
                        self.c_runeData:updateNumById(1, v)
                        local stoneItem3 = {}
                        stoneItem3.stone_type = 2
                        stoneItem3.stone_id = v.runt_id
                        stoneItem3.stone_no = v.runt_no
                        stoneItem3.stone_num = 1
                        table.insert(stones, stoneItem3)
                    end
                end
            end

            local function callBack()
                getOtherModule():showOtherView("PVCongratulationsGainDialog", 3, stones)
            end

            local function callBack1()
                self.smeltInputItem1:setEnabled(true)
            end
            self:runAction(cc.Sequence:create(cc.DelayTime:create(2.1),cc.CallFunc:create(callBack)))
            self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(callBack1)))

            self.c_runeData:updateStone1Num(1, data.stone1)
            self.c_runeData:updateStone2Num(1, data.stone2)
            --背包数据相关更新
            for k, v in pairs(self.selectRunes) do
                self.c_runeData:updateNumById(2, v)
            end

            -- self.effectKuang:setVisible(true)
            self.animationManager:runAnimationsForSequenceNamed("effect2")

            local node  = UI_lianHuajiemian()
            node:setPosition(cc.p(0,50))
            self.effectLayer:addChild(node)
            self:updateSmeltBack()
        end
    end
    local function responseRuntBag()
        self.oweRaw:setString(self.c_runeData:getStone1())
        self.oweSpari:setString(self.c_runeData:getStone2())
    end
    -- 符文炼化
    self:registerMsg(RUNE_SMELT, smeltCallBack)
    -- 武将炼化界面 self.selectRunes =============
    self:registerMsg(HERO_SACRIFICE_REQUEST, onReciveMsgCallBack)
    self:registerMsg(NET_ID_HERO_REQUEST, onReciveMsgCallBack)
    -- 装备
    self:registerMsg(EQU_COMPOSE_CODE, responseComposeCallback)
    self:registerMsg(EQU_MELTING_CODE, responseMeltingCallback)
    self:registerMsg(BAG_RUNES, responseRuntBag)
end


function PVSmeltView:onReloadView()
    print("--------- onReloadView onReloadView  ----------")
    self.isMenuCanTouch = true

    -- print("当前self.curTab = "..self.curTab)
    if self.curTab == 1 then
        self.addOneKey = false
        self.totalSoulNumLabel:setString(self.commonData:getHeroSoul())  --self.GameLoginResponse.hero_soul)
        self:updateSoulIconAndNum()
    end
    if self.curTab == 2 then
        self:updateSmeltView()
        if COMMON_TIPS_BOOL_RETURN == true then
            getNetManager():getEquipNet():sendMeltingMsg(self.equipData:getSmeltIDs())
        elseif COMMON_TIPS_BOOL_RETURN == false then
            SpriteGrayUtil:drawSpriteTextureColor(self.menuSmeltShop:getNormalImage())
            SpriteGrayUtil:drawSpriteTextureColor(self.smeltMenu:getNormalImage())
            SpriteGrayUtil:drawSpriteTextureColor(self.menuOneKeyAdd:getNormalImage())
            self.menuOneKeyAdd:setEnabled(true)
            self.menuSmeltShop:setEnabled(true)
            self.smeltMenu:setEnabled(true)

        end
        COMMON_TIPS_BOOL_RETURN = nil
        self.curType = nil
    end
    if self.curTab == 3 then
        if COMMON_TIPS_BOOL_RETURN then
            self.smeltInputItem1:setEnabled(false)
            self.c_runeNet:sendSmeltRunes(self.smeltRunes)
        end
        if self.funcTable[1] == "cancel_selected_rune" then
            print("=====================================>cancel_selected_rune")
            table.print(self.funcTable)
            self:cancelRuneSelected(self.funcTable[2])
            return
        end
        self:onBackUpdateView()
    end
end
--取消所选择的装备
function PVSmeltView:cancelEquipSelected(posIdx)
    local _list = self.equipData:getSmeltIDs()
    if _list[posIdx] == nil then return end
    table.remove(_list,posIdx)
    self.equipData:setSmeltIDs(_list)

    self:updateSmeltView()
end
-- 更新装备熔炼界面的
function PVSmeltView:updateSmeltView()
    print("--------  更新装备熔炼界面的  ---------"..self.curTab)
    -- self.equipSoulNum:setString( self.commonData:getEquipSoul() )

    local _list = self.equipData:getSmeltIDs()
    -- table.print(_list)
    local smeltGain = 0
    local coinStreng = 0
    if _list ~= nil then
        -- table.print(_list)
        self.numAdded = 0
        for i=1,8 do
            local v = _list[i]
            if v ~= nil then
                local equip_no = self.equipData:getEquipById(v).no
                -- local _icon = self.equipTemp:getEquipResIcon(equip_no)  -- 资源名
                local equipmentItem = self.equipTemp:getTemplateById(equip_no)
                local _quality = equipmentItem.quality
                local _icon = self.equipTemp:getEquipResHD(equip_no)  
                print(_icon)
                -- local _quality = self.equipTemp:getQuality(equip_no)    -- 装备品质
                -- local img = game.newSprite()
                -- changeEquipIconImageBottom(img, _icon, _quality)  -- 设置卡的图片
                setNewEquipCardWithFrame(self.equipImg[i], _icon, _quality)  -- 新版本路径
                self.equipImg[i]:setVisible(true)
                self.menuCancelEquip[i]:setVisible(true)
                
                -- self.menuAddSmelt[i]:setNormalImage(img)
                self.imgAdd[i]:setVisible(false)

                self.numAdded = self.numAdded + 1

                local gain = self.equipTemp:getGains(equip_no)
                smeltGain = smeltGain + gain["107"][1]
                coinStreng = coinStreng + self.equipData:getStrengCoin(v)
            else
                -- local img = game.newSprite("#ui_rune_kuang.png")
                -- self.menuAddSmelt[i]:setNormalImage(img)
                self.equipImg[i]:setVisible(false)
                self.imgAdd[i]:setVisible(true)
                self.menuCancelEquip[i]:setVisible(false)
            end
        end
    end

    self.coinStreng:setString(tostring(coinStreng))
    self.equipSoulNum:setString(tostring(smeltGain))
    -- if self.numAdded == 8 then
    --     SpriteGrayUtil:drawSpriteTextureGray(self.menuOneKeyAdd:getNormalImage())
    --     self.menuOneKeyAdd:setEnabled(false)
    -- else
    --     SpriteGrayUtil:drawSpriteTextureColor(self.menuOneKeyAdd:getNormalImage())
    --     self.menuOneKeyAdd:setEnabled(true)
    -- end
end

-- 武将献祭
-- 获取武将列表
function PVSmeltView:updateUIData()
    self.soldierData = getDataManager():getLineupData():getChangeCheerSoldier()

    self.herosData = {}
    -- local len = table.nums(self.soldierData)
    for k,v in pairs(self.soldierData) do
        self.herosData[k] = {}
        self.herosData[k].HeroPB = v
        local _quality = self.SoldierTemplate:getHeroQuality(v.hero_no)
        self.herosData[k].power = self.c_Calculation:CombatPowerSoldierSelf(v)
        self.herosData[k].quality = _quality
        self.herosData[k].type = 1
    end

    -- print("武将献祭-------PVSmeltView:updateUIData--------")
    local function sortByHeroQuality(item1, item2)
        --return item1.quality < item2.quality
        if item1.HeroPB.level == item2.HeroPB.level then
            if item1.quality == item2.quality then
                return item1.power < item2.power

            end
            return item1.quality < item2.quality
        end
        return item1.HeroPB.level < item2.HeroPB.level
    end
    table.sort(self.herosData, sortByHeroQuality)

    local function sortByChipQuality(item1, item2)
        return item1.quality < item2.quality
        -- if item1.HeroPB.level == item2.HeroPB.level then
        --     if item1.quality == item2.quality then
        --         return item1.power < item2.power

        --     end
        --     return item1.quality < item2.quality
        -- end
        -- return item1.HeroPB.level < item2.HeroPB.level
    end

    --获取武将碎片列表
    self.chipData = getDataManager():getSoldierData():getPatchData()
    self.chipItems = {}
    for k, v in pairs(self.chipData) do
        self.chipItems[k] = {}
        local tabTemp = {["hero_chip_no"] = tonumber(v.hero_chip_no),["hero_chip_num"] = tonumber(v.hero_chip_num)}
        self.chipItems[k].hero = tabTemp
        local _quality = getTemplateManager():getSoldierTemplate():getChipTempLateById(v.hero_chip_no).quality
        self.chipItems[k].quality = _quality
        self.chipItems[k].type = 2
    end
    table.sort(self.chipItems, sortByChipQuality)
end


function PVSmeltView:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self.c_runeData:setSelectRunes(nil)
        self.orderRunes = {}
        
        self:onHideView()
    end
    local function menuClickA()
        getAudioManager():playEffectButton2()
        self:onSlidingMenuChange(1)
    end

    local function menuClickB()
        getAudioManager():playEffectButton2()
        self:onSlidingMenuChange(2)  
        local tempEquipSoul = getDataManager():getCommonData():getEquipSoul()
        print("tempEquipSoul ",tempEquipSoul)
        if tempEquipSoul>0 and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40040 then
            getNewGManager():setCurrentGID(GuideId.G_GUIDE_40073)
            groupCallBack(GuideGroupKey.BTN_WUHUN)
        else
            groupCallBack(GuideGroupKey.BTN_EQUIP_IN_LIANHUA)
        end
        
    end

    local function menuClickC()
        getAudioManager():playEffectButton2()
        getNetManager():getRuneNet():sendBagRunes()
        self:onSlidingMenuChange(3)
    end


-- 武将献祭
    local function onShopClick()
        cclog("onShopClick")
        if self.isMenuCanTouch == false then
            return
        end

        getAudioManager():playEffectButton2()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSecretShop")
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretShop")

        -- stepCallBack(G_GUIDE_30118)                 -- 30022 点击武魂商店
        local temp = getDataManager():getCommonData():getHeroSoul()
        if temp>0 and temp<50 and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30022 then
            getNewGManager():setCurrentGID(GuideId.G_GUIDE_30033)
            groupCallBack(GuideGroupKey.BTN_CLICK_WUHUN_SHOP)
            return
        end
        groupCallBack(GuideGroupKey.BTN_CLICK_WUHUN_SHOP)
    end

    local function onHead1Click()
        cclog("onHead1Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 1)
    end

    local function onHead2Click()
        cclog("onHead2Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 2)
    end

    local function onHead3Click()
        cclog("onHead3Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 3)
    end

    local function onHead4Click()
        cclog("onHead4Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 4)
    end

    local function onHead5Click()
        cclog("onHead5Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 5)
    end

    local function onHead6Click()
        cclog("onHead5Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 6)
    end

    local function onHead7Click()
        cclog("onHead5Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 7)
    end

    local function onHead8Click()
        cclog("onHead5Click")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVGeneralList", self.generalHead, self.curSoulNum, 8)
    end

    local function onCancle1Click()
        cclog("onCancle1Click")
        getAudioManager():playEffectButton2()
        -- self:imageChange(self.generalHead[1])
        self:cancelHeroSelected(1)
    end

    local function onCancle2Click()
        cclog("onCancle2Click")
        getAudioManager():playEffectButton2()
        -- self:imageChange(self.generalHead[2])
        self:cancelHeroSelected(2)
    end

    local function onCancle3Click()
        cclog("onCancle3Click")
        getAudioManager():playEffectButton2()
        -- self:imageChange(self.generalHead[3])
        self:cancelHeroSelected(3)
    end

    local function onCancle4Click()
        cclog("onCancle4Click")
        getAudioManager():playEffectButton2()
        -- self:imageChange(self.generalHead[4])
        self:cancelHeroSelected(4)
    end

    local function onCancle5Click()
        cclog("onCancle5Click")
        getAudioManager():playEffectButton2()
        -- self:imageChange(self.generalHead[5])
        self:cancelHeroSelected(5)
    end
    local function onCancle6Click()
        cclog("onCancle6Click")
        getAudioManager():playEffectButton2()
        self:cancelHeroSelected(6)
    end
    local function onCancle7Click()
        cclog("onCancle7Click")
        getAudioManager():playEffectButton2()
        self:cancelHeroSelected(7)
    end
    local function onCancle8Click()
        cclog("onCancle8Click")
        getAudioManager():playEffectButton2()
        self:cancelHeroSelected(8)
    end

    local function onSacrificeClick()

        cclog("onSacrificeClick")
        getAudioManager():playEffectButton2()
        self:totalSelectHead()
        if table.nums(self.totalSelect) <=0 then
            getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.3"))
            return
        end

        --local  data = { hero_nos=self.totalSelect}
        local dataHero = {}
        dataHero["hero_nos"] = {}
        dataHero["hero_chips"] = {}
        for k,v in pairs(self.totalSelect) do
            if v[2] == 1 then
                table.insert(dataHero["hero_nos"],v[1].hero_no)
            elseif v[2] == 2 then
                table.insert(dataHero["hero_chips"],v[1])
            end
        end

        cclog("onSacrificeClick   11111111111111")
        -- for k,v in pairs(self.totalSelect) do
        --     if v[2] == 2 then
        --         table.insert(dataHero["hero_chips"],v[1])
        --     end
        -- end

        self.isMenuCanTouch = false


        -- 添加紫色英雄献祭的二次确认提示
        local _isContainsPurpleSoldier = false

        for k,v in pairs(self.totalSelect) do
            local hero_quality = 0
            local chip_quality = 0
            if v[2] == 1 then
                hero_quality = self.SoldierTemplate:getHeroQuality(v[1].hero_no)
                local _soldierName = self.SoldierTemplate:getHeroName(v[1].hero_no)
            elseif v[2] == 2 then
                --chip_quality = self.SoldierTemplate:getChipTempLateById(v[1].hero_chip_no).quality
            end
            if hero_quality >= 5 or chip_quality >= 5 then
                _isContainsPurpleSoldier = true

                print("－－－－－包含紫色武将－－－－－－")
                print(_soldierName)
                local  sure = function()
                    -- 确定
                    -- getNetManager():getSacrificeNet():sendHeroSacrificeRequest("HeroSacrificeRequest", data)
                    self.dataHero = dataHero
                    getNetManager():getSacrificeNet():sendHeroSacrificeRequest("HeroSacrificeRequest", dataHero)
                end

                local cancel = function()
                    -- 取消
                    getOtherModule():clear()
                end
                getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVSmeltView.7"))
                break
            end

        end

        cclog("onSacrificeClick   2222222222222")

        if _isContainsPurpleSoldier == false then
            self.sacrificeMenuItem:setEnabled(false)
            self.oneAddKey:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.sacrificeMenuItem:getNormalImage())
            SpriteGrayUtil:drawSpriteTextureGray(self.oneAddKey:getNormalImage())
            -- getNetManager():getSacrificeNet():sendHeroSacrificeRequest("HeroSacrificeRequest", data)
            self.dataHero = dataHero
            getNetManager():getSacrificeNet():sendHeroSacrificeRequest("HeroSacrificeRequest", dataHero)
            cclog("onSacrificeClick   33333333333333")
        end
        -- stepCallBack(G_GUIDE_30007)
    end

    local function isExistsIngeneralHead(item)
        -- cclog("----------isExistsIngeneralHead=============")
        -- table.print(item)
        for i=1,8 do
            if self.generalHead[i].headImg:isVisible() and self.generalHead[i].type ~= nil then
                if self.generalHead[i].type == 1 and item.type == 1 and self.generalHead[i].hero.hero_no == item.HeroPB.hero_no then
                    return true
                elseif self.generalHead[i].type == 2 and item.type == 2 and self.generalHead[i].hero.hero_chip_no == item.hero.hero_chip_no then
                    return true
                end
            end
        end

        return false
    end

    local  function onAddAllClick()
        cclog("onAddAllClick")
        table.print(self.generalHead)
        getAudioManager():playEffectButton2()
        -- 用户点击一键添加，无需打开献祭武将列表，按照武将品质（绿、蓝3星、蓝4星、紫5星、紫6星）自动添加武将至置放武将位置。

        local  totalNum = table.nums(self.herosData) + table.nums(self.chipItems)
        if totalNum <=0 then
            getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.4"))
            return
        elseif self.addOneKey and totalNum < 8 then
            getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.4"))
            return
        elseif self.addOneKey  then
            getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.5"))
            return
        end

        for k, v in pairs(self.herosData) do
            local _isExist = isExistsIngeneralHead(v)

            if not _isExist then
                for i=1,8 do
                    if not self.generalHead[i].headImg:isVisible() then
                        self.generalHead[i].headImg:setVisible(true)
                        self.generalHead[i].isSelect = true
                        self.generalHead[i].hero = v.HeroPB
                        self.generalHead[i].type = 1
                        -- game:setSpriteFrame(self.generalHead[k], "#ui_common_pro.png")
                        break
                    end
                end

            end
        end

        for k, v in pairs(self.chipItems) do

            local _isExist = isExistsIngeneralHead(v)

            if not _isExist then
                for i=1,8 do
                    if not self.generalHead[i].headImg:isVisible() then
                        self.generalHead[i].headImg:setVisible(true)
                        self.generalHead[i].isSelect = true
                        self.generalHead[i].hero = v.hero
                        self.generalHead[i].type = 2
                        -- game:setSpriteFrame(self.generalHead[k], "#ui_common_pro.png")
                        break
                    end
                end

            end
        end

        self.addOneKey = true

        self:updateSoulIconAndNum()

        groupCallBack(GuideGroupKey.BTN_LIANHUA_ALL)
    end

-- 装备熔炼

    local function onOneKeyMenuClick()
        getAudioManager():playEffectButton2()

        print("可以再添加的个数 ", self.numAdded)

        local _list = {}
        local _haveList = self.equipData:getSmeltIDs()

        ---------------ljr
        local  haveNum = table.nums(_haveList)
        local  totalNum = table.nums(self.allEquipments)
        print("------- table.nums(_haveList) ----------"..haveNum)
        print("------- table.nums(self.allEquipments) ----------"..totalNum)
        if totalNum <=0 then
            getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.1"))

            local tempEquipSoul = getDataManager():getCommonData():getEquipSoul()
             print("tempEquipSoul ",tempEquipSoul)

            if tempEquipSoul>0 and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40070 then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_40073)
                groupCallBack(GuideGroupKey.BTN_WUHUN)
            end
            return
        -- elseif totalNum < 8 then
        --     getOtherModule():showAlertDialog(nil, "暂无可炼化装备")
        --     return
        elseif haveNum >= 8 then
            getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.2"))
            return
        end
        --------------

        -- self:onAllSmeltSelected()

        for k,v in pairs(self.allEquipments) do
            local etype = self.equipTemp:getTypeById(v.no)
            --local fvalue = getCalculationManager():getEquipCalculation():getFightValue(v.id)
            local fvalue = self.equipTemp:getQuality(v.no)
            local tvalue = self.equipTemp:getTypeById(v.no)
            if tvalue == 5 or tvalue == 6 then
                fvalue = fvalue + 0.5
            end
            -- print("@ no, level, value", v.no, v.strengthen_lv, fvalue)
            local ishave = true
            for _k,_v in pairs(_haveList) do
                if v.id == _v then ishave = false; break end
            end
            if ishave and self:getIsEquip(v.id)==0 then
                table.insert(_list, {v.id,v.no,fvalue})
            end
        end

        table.sort(_list, function (a,b) return a[3] < b[3] end)

        -- table.print(_list)
        local max
        if table.nums(_list) < 8 then
            max = table.nums(_list)
        else
            max = 8-self.numAdded
        end
        --------------------
        print("----------table.nums(_list) ",max)
        print("----------max ",max)
        if max <= 0 then
            getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.1"))
            return
        end
        --------------------

        for i=1, max do
            self.equipData:addSmeltID(_list[i][1])
        end


        self:updateSmeltView()

        groupCallBack(GuideGroupKey.BTN_LIANHUA_ALL)
    end

    local function addOneEquipToSmelt(posIdx)
        print(posIdx)
        self.currSelectPos = posIdx
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSelectSmeltEquip")
    end
    local function addKey1() addOneEquipToSmelt(1) end
    local function addKey2() addOneEquipToSmelt(2) end
    local function addKey3() addOneEquipToSmelt(3) end
    local function addKey4() addOneEquipToSmelt(4) end
    local function addKey5() addOneEquipToSmelt(5) end
    local function addKey6() addOneEquipToSmelt(6) end
    local function addKey7() addOneEquipToSmelt(7) end
    local function addKey8() addOneEquipToSmelt(8) end

    local function cancelOneEquipToSmelt(posIdx)
        self:cancelEquipSelected(posIdx)
    end
    local function cancelKey1() cancelOneEquipToSmelt(1) end
    local function cancelKey2() cancelOneEquipToSmelt(2) end
    local function cancelKey3() cancelOneEquipToSmelt(3) end
    local function cancelKey4() cancelOneEquipToSmelt(4) end
    local function cancelKey5() cancelOneEquipToSmelt(5) end
    local function cancelKey6() cancelOneEquipToSmelt(6) end
    local function cancelKey7() cancelOneEquipToSmelt(7) end
    local function cancelKey8() cancelOneEquipToSmelt(8) end

    local function oneKeyAdd()
        print("one key add ..")
    end
    local function onEquipmentStore()
        print("equipment store ..")
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipShop")

        local tempEquipSoul = getDataManager():getCommonData():getEquipSoul()
        print("tempEquipSoul ",tempEquipSoul)

        if tempEquipSoul>0 and tempEquipSoul<80 and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_40041 then
            getNewGManager():setCurrentGID(GuideId.G_GUIDE_40074)
            groupCallBack(GuideGroupKey.BTN_EQUIPATTR_IN_EXCHANGE)
        else
            groupCallBack(GuideGroupKey.BTN_EXCHANGE_SHOP)
        end
    end

    local function onSmeltClick()
        print("equipment store ..")
        self:smeltMenuClick()
    end

-- 符文炼化
    --置入符文
    local function onInputRuneClick()
        print("－－－－－置入符文－－－－－")
        getAudioManager():playEffectButton2()

        if self.smeltRunes then
            print("--------- table.getn(self.smeltRunes) -------------"..table.getn(self.smeltRunes))
            if table.getn(self.smeltRunes) >= 8 then
                getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.3"))
            end
        end
        --从背包中获取到的符文
        local orderRunes = self.c_runeData:getSmeltRunes()
        local selectedRunes = clone(orderRunes)
        -- self.smeltRunes = {}--存放要炼化的符文no
        if table.getn(orderRunes) > 0 then
            cclog("置入符文 ================= ")
            for k,v in  pairs(self.addRuneMenu) do
                if not v.isHave then
                    local runeStone = table.remove(orderRunes,1)
                    v.runt_id = runeStone.runt_id
                    v.runt_no = runeStone.runt_no
                    v.isHave = true
                    --编号用于发送协议
                    table.insert(self.smeltRunes, v.runt_no)
                    --加入已选择容器
                    self.c_runeData:addSelectRune(runeStone)
                end
            end
            
            self.selectRunes = self.c_runeData:getSelectRunes()

            self:updateRuneShow(self.addRuneMenu)
        else
            getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.4"))
        end
    end


    local function cancelOneRuneToSmelt(posIdx)
        self:cancelRuneSelected(posIdx)
    end
    local function cancelRuneKey1() cancelOneRuneToSmelt(1) end
    local function cancelRuneKey2() cancelOneRuneToSmelt(2) end
    local function cancelRuneKey3() cancelOneRuneToSmelt(3) end
    local function cancelRuneKey4() cancelOneRuneToSmelt(4) end
    local function cancelRuneKey5() cancelOneRuneToSmelt(5) end
    local function cancelRuneKey6() cancelOneRuneToSmelt(6) end
    local function cancelRuneKey7() cancelOneRuneToSmelt(7) end
    local function cancelRuneKey8() cancelOneRuneToSmelt(8) end

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
    -- local function onRuneBagClick()
    --     getAudioManager():playEffectButton2()
    --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", 2)
    -- end

    --打造符文
    local function onBuildRuneClick()
        cclog("打造符文 ================= ")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBuildPanel")
    end

    --点击熔炼
    local function onRuneSmeltClick()
        print("----------- 点击符文熔炼 ------------")
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
                    if table.getn(self.smeltRunes) > 0 then
                        self.smeltInputItem1:setEnabled(false)
                        self.c_runeNet:sendSmeltRunes(self.smeltRunes)
                    else
                        getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.5"))
                    end
                end
            else
                getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.5"))
            end
        else
            getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.5"))
        end
    end


--
    self.UISmeltView["UISmeltView"] = {}
    self.UISmeltView["UISmeltView"]["backMenuClick"] = onCloseClick
    self.UISmeltView["UISmeltView"]["soldierMenuClick"] = menuClickA
    self.UISmeltView["UISmeltView"]["equipMenuClick"] = menuClickB
    self.UISmeltView["UISmeltView"]["runeMenuClick"] = menuClickC
    -- 武将献祭
    -- self.UISmeltView["UISmeltView"]["onBackClick"] = onCloseClick
    self.UISmeltView["UISmeltView"]["onShopClick"] = onShopClick
    self.UISmeltView["UISmeltView"]["onHead1Click"] = onHead1Click
    self.UISmeltView["UISmeltView"]["onHead2Click"] = onHead2Click
    self.UISmeltView["UISmeltView"]["onHead3Click"] = onHead3Click
    self.UISmeltView["UISmeltView"]["onHead4Click"] = onHead4Click
    self.UISmeltView["UISmeltView"]["onHead5Click"] = onHead5Click
    self.UISmeltView["UISmeltView"]["onHead6Click"] = onHead6Click
    self.UISmeltView["UISmeltView"]["onHead7Click"] = onHead7Click
    self.UISmeltView["UISmeltView"]["onHead8Click"] = onHead8Click
    self.UISmeltView["UISmeltView"]["onCancle1Click"] = onCancle1Click
    self.UISmeltView["UISmeltView"]["onCancle2Click"] = onCancle2Click
    self.UISmeltView["UISmeltView"]["onCancle3Click"] = onCancle3Click
    self.UISmeltView["UISmeltView"]["onCancle4Click"] = onCancle4Click
    self.UISmeltView["UISmeltView"]["onCancle5Click"] = onCancle5Click
    self.UISmeltView["UISmeltView"]["onCancle6Click"] = onCancle6Click
    self.UISmeltView["UISmeltView"]["onCancle7Click"] = onCancle7Click
    self.UISmeltView["UISmeltView"]["onCancle8Click"] = onCancle8Click
    self.UISmeltView["UISmeltView"]["onSacrificeClick"] = onSacrificeClick
    self.UISmeltView["UISmeltView"]["onAddAllClick"] = onAddAllClick
    -- 装备熔炼
    self.UISmeltView["UISmeltView"]["onAddEquipClick1"] = addKey1
    self.UISmeltView["UISmeltView"]["onAddEquipClick2"] = addKey2
    self.UISmeltView["UISmeltView"]["onAddEquipClick3"] = addKey3
    self.UISmeltView["UISmeltView"]["onAddEquipClick4"] = addKey4
    self.UISmeltView["UISmeltView"]["onAddEquipClick5"] = addKey5
    self.UISmeltView["UISmeltView"]["onAddEquipClick6"] = addKey6
    self.UISmeltView["UISmeltView"]["onAddEquipClick7"] = addKey7
    self.UISmeltView["UISmeltView"]["onAddEquipClick8"] = addKey8
    self.UISmeltView["UISmeltView"]["onCancleEquip1Click"] = cancelKey1
    self.UISmeltView["UISmeltView"]["onCancleEquip2Click"] = cancelKey2
    self.UISmeltView["UISmeltView"]["onCancleEquip3Click"] = cancelKey3
    self.UISmeltView["UISmeltView"]["onCancleEquip4Click"] = cancelKey4
    self.UISmeltView["UISmeltView"]["onCancleEquip5Click"] = cancelKey5
    self.UISmeltView["UISmeltView"]["onCancleEquip6Click"] = cancelKey6
    self.UISmeltView["UISmeltView"]["onCancleEquip7Click"] = cancelKey7
    self.UISmeltView["UISmeltView"]["onCancleEquip8Click"] = cancelKey8
    self.UISmeltView["UISmeltView"]["onOneKeyAdd"] = onOneKeyMenuClick
    self.UISmeltView["UISmeltView"]["onEquipmentStoreClick"] = onEquipmentStore
    self.UISmeltView["UISmeltView"]["SmeltClick"] = onSmeltClick
    -- 符文炼化
    -- self.UISmeltView["UISmeltView"]["onSmeltRuneClick"] = onSmeltRuneClick                    --炼化符文
    -- self.UISmeltView["UISmeltView"]["onSmeltShopClick"] = onSmeltShopClick                    --炼化商人
    self.UISmeltView["UISmeltView"]["onInputRuneClick"] = onInputRuneClick
    self.UISmeltView["UISmeltView"]["onAddRuneClick1"] = onAddRuneClick1
    self.UISmeltView["UISmeltView"]["onAddRuneClick2"] = onAddRuneClick2
    self.UISmeltView["UISmeltView"]["onAddRuneClick3"] = onAddRuneClick3
    self.UISmeltView["UISmeltView"]["onAddRuneClick4"] = onAddRuneClick4
    self.UISmeltView["UISmeltView"]["onAddRuneClick5"] = onAddRuneClick5
    self.UISmeltView["UISmeltView"]["onAddRuneClick6"] = onAddRuneClick6
    self.UISmeltView["UISmeltView"]["onAddRuneClick7"] = onAddRuneClick7
    self.UISmeltView["UISmeltView"]["onAddRuneClick8"] = onAddRuneClick8
    self.UISmeltView["UISmeltView"]["onCancleRune1Click"] = cancelRuneKey1
    self.UISmeltView["UISmeltView"]["onCancleRune2Click"] = cancelRuneKey2
    self.UISmeltView["UISmeltView"]["onCancleRune3Click"] = cancelRuneKey3
    self.UISmeltView["UISmeltView"]["onCancleRune4Click"] = cancelRuneKey4
    self.UISmeltView["UISmeltView"]["onCancleRune5Click"] = cancelRuneKey5
    self.UISmeltView["UISmeltView"]["onCancleRune6Click"] = cancelRuneKey6
    self.UISmeltView["UISmeltView"]["onCancleRune7Click"] = cancelRuneKey7
    self.UISmeltView["UISmeltView"]["onCancleRune8Click"] = cancelRuneKey8
    -- self.UISmeltView["UISmeltView"]["onRuneBagClick"] = onRuneBagClick                        --符文背包
    self.UISmeltView["UISmeltView"]["onBuildRuneClick"] = onBuildRuneClick                    --打造符文
    self.UISmeltView["UISmeltView"]["onSmeltClick"] = onRuneSmeltClick                        --点击炼化
end

--符文
function PVSmeltView:getCurItem(runtNo)
    if self.selectRunes ~= nil then
        for k, v in pairs(self.selectRunes) do
            if v.runt_no == runtNo then
                return v
            end
        end
    end
end

--炼化后更新界面
function PVSmeltView:updateSmeltBack()
    local function CallFunc()
        self:stopAllActions()
        self.menuLayer:setVisible(true)
        self.effectSprite2:setVisible(false)
        self.effectKuang:setVisible(false)
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(CallFunc)))

    COMMON_TIPS_BOOL_RETURN = nil
    self.smeltRunes = {}
    self.c_runeData:setSelectRunes(nil)
    self.orderRunes = {}
    self:initAddRuneMenu()
    self.selectRunes = nil
    --原石和晶石数据更新
    -- self.yuanValue:setString(self.c_runeData:getStone1())
    -- self.spariValue:setString(self.c_runeData:getStone2())

    self.oweRaw:setString(self.c_runeData:getStone1())
    self.oweSpari:setString(self.c_runeData:getStone2())
end

--添加符文后回调
-- function PVSmeltView:updateAddRuneMenu(index, curRuneSprite, type, runeId)
--     for k,v in pairs(self.addRuneSprite) do
--         if k == index then
--             v:setScale(0.9)
--             setItemImage(v, "#" .. curRuneSprite, 2)            --更新icon
--         end
--     end

--     for k,v in pairs(self.addRuneMenu) do
--         if k == index then
--             v.isHave = true
--             v.curType = type
--             v.runeId = runeId
--         end
--     end
-- end

--符文界面返回更新
function PVSmeltView:onBackUpdateView()
    self.selectRunes = self.c_runeData:getSelectRunes()
    print("self.selectRunes =============== ", #self.selectRunes)
    table.print(self.selectRunes)
    -- --熔炼符文列表初始化
    if table.getn(self.selectRunes) > 0 then
        self.smeltRunes = {}
        for k,v in pairs(self.selectRunes) do
            table.insert(self.smeltRunes, v.runt_no)
        end
    end
    --
    local selectedRunes = clone(self.selectRunes)
    --过滤掉已经添加的
    for _, v in pairs(self.addRuneMenu) do
        if v.isHave then
            local isSelected = false
            for i = 1, #selectedRunes do
                if v.runt_no == selectedRunes[i].runt_no then --已添加
                    table.remove(selectedRunes, i)--移除被选符文
                    isSelected = true
                    break
                end
            end
            if not isSelected then --没被选择，则重置
                v.isHave = false
                v.runt_id = nil
                v.runt_no = nil
            end
        end
    end
    --添加剩下的符文
    if #selectedRunes > 0 then
        print("=====================================>")        
        table.print(selectedRunes)
        for _, v in pairs(self.addRuneMenu) do
            if not v.isHave and #selectedRunes > 0 then
                local runeStone = table.remove(selectedRunes,1)--选择一个符文
                v.isHave = true            
                v.runt_id = runeStone.runt_id
                v.runt_no = runeStone.runt_no
            end
        end        
    end
    --添加完后，选择的符文集合大小应为0
    assert(#selectedRunes == 0, "添加符文数据不正确，剩余:"..#selectedRunes)

    -- -- table.print(self.selectRunes)
    -- local selectRunes = clone(self.selectRunes)
    -- local addMenus = self.addRuneMenu
    -- self.deleteAddMenus = {}
    -- -- print("selectRunes ========= selectRunes ===== ", selectRunes)
    -- --过滤点应经镶嵌上的符文
    -- if selectRunes ~= nil then
    --     for k, v in pairs(addMenus) do
    --         if v.isHave then
    --             local result = self:isInSelectRunes(v.runt_no)
    --             if result ~= nil then
    --                 local curRes = 0
    --                 if result > 1 then
    --                     curRes = result - (k - 1)
    --                 else
    --                     curRes = result
    --                 end
    --                 table.insert(self.deleteAddMenus, k)
    --                 table.remove(selectRunes, 1)
    --             end
    --         end
    --     end

    --     for i = self.curIndex, 8 do
    --         local addMenuItem = addMenus[i]
    --         local flag = self:isInDeletMenus(i)                                     --是否存在于应经镶嵌的按钮列表中
    --         --不存在时
    --         if not flag then
    --             if addMenuItem ~= nil then
    --                 if addMenuItem.isHave == true then                              --标记是有符文、id已经不存在时
    --                     addMenuItem.isHave = false
    --                     addMenuItem.rune_id = nil
    --                     addMenuItem.runt_no = nil
    --                 end

    --                 if addMenuItem.isHave == false then                             --标记是没有符文，id也不存在时
    --                     if table.getn(selectRunes) > 0 then
    --                         addMenuItem.runt_id = selectRunes[1].runt_id
    --                         addMenuItem.isHave = true
    --                         addMenuItem.runt_no = selectRunes[1].runt_no
    --                         table.remove(selectRunes, 1)
    --                     end
    --                 end
    --             end
    --         end
    --         i = i + 1

    --         if i > 8 then                                                       --添加个数满足8个时，遍历全部的找出未镶嵌的，按照顺序镶嵌
    --             for k,v in pairs(addMenus) do
    --                 local flag = self:isInDeletMenus(i)
    --                 if not flag then
    --                     if v.isHave == false then
    --                         if table.getn(selectRunes) > 0 then
    --                             v.rune_id = selectRunes[1].runt_id
    --                             v.runt_no = selectRunes[1].runt_no
    --                             v.isHave = true
    --                             table.remove(selectRunes, 1)
    --                         end
    --                     else
    --                         local result = self:isInSelectRunes(v.runtNo)
    --                         if result == nil then
    --                             v.isHave = false
    --                             v.runeId = nil
    --                             v.runtNo = nil
    --                         end
    --                     end
    --                 end

    --                 if k == self.curIndex then
    --                     break
    --                 end
    --             end
    --         end
    --     end
    -- else
    --     for k, v in pairs(addMenus) do
    --         self.addRuneSprite[k]:setScale(1)
    --         -- setItemImage(self.addRuneSprite[k], "#ui_rune_add.png", 0)
    --     end
    -- end

    --更新界面显示
    self:updateRuneShow(self.addRuneMenu)
end

function PVSmeltView:cancelRuneSelected(posIdx)
    if self.addRuneMenu[posIdx] == nil then return end
    local selectRunes = self.c_runeData:getSelectRunes()
    for k,v in pairs(selectRunes) do 
        if v.runt_no == self.addRuneMenu[posIdx].runt_no then
            table.remove(selectRunes,k)
            break
        end
    end
 
    for _k,_v in pairs(self.smeltRunes) do
        if _v == self.addRuneMenu[posIdx].runt_no then
            table.remove(self.smeltRunes,_k)
            break
        end
    end

    self.c_runeData:setSelectRunes(selectRunes)

    self.addRuneMenu[posIdx].isHave = false
    -- self.addRuneMenu[posIdx].curType = 0
    self.addRuneMenu[posIdx].runt_id = nil
    self.addRuneMenu[posIdx].runt_no = nil

    self:onBackUpdateView()
end

function PVSmeltView:updateRuneShow(addMenus)
    print("updateRuneShow ============= ")
    local stone1Num = 0 
    local stone2Num = 0 
    --更新界面显示
    for k,v in pairs(addMenus) do
        if v.isHave and v.runt_id ~= nil then
            local quality = self.c_StoneTemplate:getStoneItemById(v.runt_id).quality
            local resId = self.c_StoneTemplate:getStoneItemById(v.runt_id).res
            local resIcon = self.c_ResourceTemplate:getResourceById(resId)
            -- self.addRuneSprite:removeAllChildren()
            self.addRuneSprite[k]:setScale(0.9)
            setItemImageNew(self.addRuneSprite[k], "res/icon/rune/" .. resIcon, quality)
            self.cancelRuneMenu[k]:setVisible(true)

            stone1Num = stone1Num + self.c_StoneTemplate:getStone1ById(v.runt_id)
            stone2Num = stone2Num + self.c_StoneTemplate:getStone2ById(v.runt_id)
        else
            self.addRuneSprite[k]:removeAllChildren()
            self.addRuneSprite[k]:setScale(1)
            self.cancelRuneMenu[k]:setVisible(false)
            -- setItemImage(self.addRuneSprite[k], "#ui_rune_add.png", 0)
        end
    end
    self.yuanValue:setString(tostring(stone1Num))
    self.spariValue:setString(tostring(stone2Num))
end

function PVSmeltView:isInSelectRunes(no)
    for k, v in pairs(self.selectRunes) do
        if v.runt_no == no then
            return k
        end
    end
    return  nil
end

function PVSmeltView:isInDeletMenus(index)
    if table.getn(self.deleteAddMenus) > 0 then
        for k, v in pairs(self.deleteAddMenus) do
            if index == v then
                return true
            end
        end
    end
    return  false
end



-- 装备熔炼
function PVSmeltView:smeltMenuClick()
    local _list = self.equipData:getSmeltIDs()

    if _list == nil or table.getn(_list) == 0 then
        -- self:toastShow("未选择熔炼装备！")
        getOtherModule():showAlertDialog(nil, Localize.query("PVSmeltView.6"))
        return
    else

        self.isMenuCanTouch = false

        SpriteGrayUtil:drawSpriteTextureGray(self.menuSmeltShop:getNormalImage())
        SpriteGrayUtil:drawSpriteTextureGray(self.smeltMenu:getNormalImage())
        SpriteGrayUtil:drawSpriteTextureGray(self.menuOneKeyAdd:getNormalImage())
        self.menuOneKeyAdd:setEnabled(false)
        self.menuSmeltShop:setEnabled(false)
        self.smeltMenu:setEnabled(false)
    end

    local hasSpecialEquip = false
    local hasPurpleEquip = false
    for k,v in pairs(_list) do
        local equip_no = self.equipData:getEquipById(v).no
        local _quality = self.equipTemp:getQuality(equip_no)
        local _type = self.equipTemp:getTypeById(equip_no)
        if _type >= 5 then hasSpecialEquip = true end
        if _quality >= 5 then hasPurpleEquip = true end
    end
    if hasSpecialEquip and hasPurpleEquip then
        getOtherModule():showOtherView("SystemTips", Localize.query("shop.17"))
    elseif hasSpecialEquip and not hasPurpleEquip then
        getOtherModule():showOtherView("SystemTips", Localize.query("shop.16"))
    elseif hasPurpleEquip and not hasSpecialEquip then
        getOtherModule():showOtherView("SystemTips", Localize.query("shop.6"))
    else
        getNetManager():getEquipNet():sendMeltingMsg(_list)
    end

end

function PVSmeltView:removeHeroByID(item)
    if item.type == 1 then
        local data = getDataManager():getSoldierData():getSoldierData()
        for k,v in pairs(data) do
            if v.hero_no == item.hero.hero_no then
                table.remove(data, k)
            end
        end
    elseif item.type == 2 then
        local data = getDataManager():getSoldierData():getPatchData()
        for k,v in pairs(data) do
            if v.hero_chip_no == item.hero.hero_chip_no then
                table.remove(data, k)
            end
        end
    end
end

-- 根据献祭之后返回数据更新UI
function PVSmeltView:onUpdateSacrificeUI()
    self.addOneKey = false

    self.HeroSacrificeResponse = getDataManager():getSacrificeData():getHeroSacrificeResponseData()
    cclog("------------------PVSmeltView:onUpdateSacrificeUI----------")
    table.print(self.HeroSacrificeResponse.gain)
    if self.HeroSacrificeResponse.res.result then

        for k,v in pairs(self.dataHero) do
            if k == "hero_nos" and v ~= nil then
                for k1,v1 in pairs(v) do
                    -- print("---------------------")
                    -- print(v1)
                    local hero = getDataManager():getSoldierData():getSoldierDataById(v1)
                    table.print(hero)
                    getDataManager():getSoldierData():subData(hero)
                end
            elseif k == "hero_chips" then
            end
        end

        table.print(self.HeroSacrificeResponse.gain.items)
        -- print(table.nums(self.HeroSacrificeResponse.gain.items))

        if table.nums(self.HeroSacrificeResponse.gain.items) >0 then
            getDataManager():getBagData():setItemByOtherWay(self.HeroSacrificeResponse.gain.items)               -- 经验药水添加到背包里
        end
        -- print("添加的数量 ============= ", self.HeroSacrificeResponse.gain.items[1].item_num)
        getDataManager():getCommonData():addHero_soul(self.HeroSacrificeResponse.gain.finance.hero_soul)     -- 增加武魂总值


        local ret = false
        cclog("-------献祭返回----------")
        table.print(self.generalHead)

        local actionEnd = function()

            self.gain_exp:setOpacity(255)
            SpriteGrayUtil:drawSpriteTextureColor(self.sacrificeMenuItem:getNormalImage())
            SpriteGrayUtil:drawSpriteTextureColor(self.oneAddKey:getNormalImage())
            self.sacrificeMenuItem:setEnabled(true)
            self.oneAddKey:setEnabled(true)
           if self.diaFlag then                 --利用一个标志位来防止献祭多个弹出多个弹框
                -- 献祭成功后，获得物品提示
                print("------献祭成功------")
                table.print(self.HeroSacrificeResponse)
                self.HeroSacrificeResponse.gain.items[1].icon = self.icon
                getOtherModule():showOtherView("PVCongratulationsGainDialog",2,self.HeroSacrificeResponse.gain)
                self.diaFlag = false
                
                groupCallBack(GuideGroupKey.BTN_CLICK_LIANHUA)
            end
        end

        local node = UI_Xianji(actionEnd)
        self.animationNode:addChild(node)

        for k, v in pairs(self.generalHead) do
            if v.isSelect and v.hero then
                -- add card 献祭特效
                -- local actionEnd = function()

                --     -- self.isMenuCanTouch = true

                --     self.gain_exp:setOpacity(255)
                --     -- self.gain_soul:setOpacity(255)

                --     SpriteGrayUtil:drawSpriteTextureColor(self.sacrificeMenuItem:getNormalImage())
                --     SpriteGrayUtil:drawSpriteTextureColor(self.oneAddKey:getNormalImage())
                --     self.sacrificeMenuItem:setEnabled(true)
                --     self.oneAddKey:setEnabled(true)
                --    -- if k == table.getn(self.totalSelect) then      --十三妹。。这个作用是什么呢，
                --    --      -- 献祭成功后，获得物品提示
                --    --      print("------献祭成功------")
                --    --      table.print(self.HeroSacrificeResponse)
                --    --      self.HeroSacrificeResponse.gain.items[1].icon = self.icon
                --    --      getOtherModule():showOtherView("PVCongratulationsGainDialog",2,self.HeroSacrificeResponse.gain)
                --    --      stepCallBack(G_GUIDE_30007)
                --    --  end
                --    if self.diaFlag then                 --利用一个标志位来防止献祭多个弹出多个弹框
                --         -- 献祭成功后，获得物品提示
                --         print("------献祭成功------")
                --         table.print(self.HeroSacrificeResponse)
                --         self.HeroSacrificeResponse.gain.items[1].icon = self.icon
                --         getOtherModule():showOtherView("PVCongratulationsGainDialog",2,self.HeroSacrificeResponse.gain)
                --         self.diaFlag = false
                        
                --         groupCallBack(GuideGroupKey.BTN_CLICK_LIANHUA)
                --     end
                -- end
                -- local posx, posy = v.headImg:getPosition()
                -- cclog("posx, posy", posx, posy)

                -- if self.exp_node:isVisible() then
                --     ret = true
                -- end
                -- local node = UI_Xianji(posx, posy, actionEnd, ret)
                -- self.animationNode:addChild(node)

                --self:removeHeroByID(v.hero.hero_no)
                self:removeHeroByID(v)
                -- break
            end
        end
        self:updateUIData()
    else
        -- self.isMenuCanTouch = true
        getOtherModule():showAlertDialog(nil, Localize.query("SacrificePanel.2"))
    end

    for k, v in pairs(self.generalHead) do
        self.generalHead[k].headImg:setVisible(false)
        self.generalHead[k].headImgq:setVisible(false)
        self.generalHead[k].menuCancle:setVisible(false)
        self.generalHead[k].isSelect = false
        self.generalHead[k].hero = nil
    end

    self.totalSoulNumLabel:setString(self.commonData:getHeroSoul())--self.GameLoginResponse.hero_soul)
end

function PVSmeltView:totalSelectHead()
    self.totalSelect = {}
    local idx = 1
    for k,v in pairs(self.generalHead) do
        if v.isSelect == true then
           --table.insert(self.totalSelect, v.hero)
           self.totalSelect[idx] = {v.hero,v.type}
           idx = idx + 1
        end
    end
    -- cclog("-=-=-=-=-=-=-=totalSelectHead-=-=-=-=-==-=-=-=")
    -- table.print(self.totalSelect)
    -- cclog("-=-=-=-=-=-=-=totalSelectHead-=-=-=-=-==-=-=-=")
end
--取消所选择的武将
function PVSmeltView:cancelHeroSelected(idx)
    if self.generalHead[idx] == nil then return end

    self.generalHead[idx].isSelect = false
    self.generalHead[idx].hero = {}
    self.generalHead[idx].type = nil

    self.addOneKey = false
    self:updateSoulIconAndNum()
end
-- 更新献祭的武魂数量和图标
function PVSmeltView:updateSoulIconAndNum()
    -- 武魂
    local totalSoulNum = self:getTotalSoulNum()
    if totalSoulNum > 0 then
        -- self.gainSoulNumLabel:setString(string.format("%d%s",totalSoulNum, Localize.query("SacrificePanel.6")))
        self.gainSoulNumLabel:setString(string.format("%d",totalSoulNum))
    else
        self.gainSoulNumLabel:setString(string.format("0"))
    end

    -- if totalSoulNum > 0 then
    --     self.gain_soul:setTexture("res/icon/resource/resource_3.png")
    --     self.gain_soul:setVisible(true)
    --     self.gain_soul:setOpacity(150)
    -- else
    --     self.gain_soul:setVisible(false)
    -- end

    -- 经验
    local status, totalExp = self:getTotalHeroExp()
    cclog("--------炼化获得的经验数据--------"..totalExp)
    if totalExp > 0 then
        -- self.gain_exp:setSpriteFrame(icon)
        self.exp_node:setVisible(true)
        self.gain_exp:setVisible(true)
        self.gain_exp:setOpacity(150)

        local num, icon = getTemplateManager():getBagTemplate():getExpIconAndNum(totalExp)
        self.icon = "res/icon/item/"..icon    --存储icon为恭喜获得使用
        if num >0 then
            self.expProNum:setString(string.format(num))
        else
            self.expProNum:setString(string.format(""))
        end

        self.gain_exp:setTexture("res/icon/item/"..icon)
        self.expProNum:setVisible(true)
    else
        self.exp_node:setVisible(false)
        self.expProNum:setVisible(false)
    end

    -- 显示和隐藏头像
    for k,v in pairs(self.generalHead) do
        print("--------"..k)

        if v.isSelect == true then
            v.headImg:setVisible(true)
            v.headImgq:setVisible(false)
            -- cclog("显示和隐藏头像")
            -- table.print(v)
            -- cclog("显示和隐藏头像")
            if  v.type == 1 then
                local quality = self.SoldierTemplate:getHeroQuality(v.hero.hero_no)
                local resIcon = self.SoldierTemplate:getSoldierIcon(v.hero.hero_no)
                print("---resIcon-----")
                print(resIcon)
                -- changeNewIconImage(v.headImg, resIcon, quality) --更新icon
                changeNewIconImage(v.headImg, resIcon, quality)
            elseif v.type == 2 then
                v.headImgq:setVisible(true)
                local patchTempLate = self.SoldierTemplate:getChipTempLateById(v.hero.hero_chip_no)
                local quality = patchTempLate.quality
                local resIcon = self.chipTemp:getChipIconById(v.hero.hero_chip_no)
                -- setChipWithFrame(v.headImg, resIcon, quality)
                changeNewIconImage(v.headImg, resIcon, quality)
            end
            v.menuCancle:setVisible(true)
        else
            v.headImg:setVisible(false)
            v.headImgq:setVisible(false)
            v.menuCancle:setVisible(false)
        end
    end
end

-- 获得献祭武将总共兑换的经验值
function PVSmeltView:getTotalHeroExp()
    local totalExp = 0
    for k,v in pairs(self.generalHead) do
        --xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        -- if v.isSelect == true and v.hero.level > 1 then
        --     totalExp = totalExp + self.SoldierTemplate:getHeroAllExpByLevel(v.hero.level)
        -- end
        if v.isSelect == true and v.type == 1 and v.hero.level > 1 then
            totalExp = totalExp + self.SoldierTemplate:getHeroAllExpByLevel(v.hero.level)
        end
    end

    local status = 4
    if math.modf(totalExp/10^5) > 0 then
        status = 1
    elseif math.modf(totalExp/10^4) > 0 then
        status = 2
    elseif math.modf(totalExp/10^3) > 0 then
        status = 3
    end

    return  status, totalExp
end

function PVSmeltView:getTotalSoulNum()
    local totalSoulNum = 0
    --xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    -- for k,v in pairs(self.generalHead) do
    --     if v.isSelect == true then
    --         totalSoulNum = totalSoulNum + self.SoldierTemplate:getSoulNum(v.hero.hero_no)
    --     end
    -- end
    for k,v in pairs(self.generalHead) do
        if v.isSelect == true and v.type == 1 then
            totalSoulNum = totalSoulNum + self.SoldierTemplate:getSoulNum(v.hero.hero_no)
        elseif v.isSelect == true and v.type == 2 then
            totalSoulNum = totalSoulNum + self.SoldierTemplate:getChipSoulNum(v.hero.hero_chip_no) * v.hero.hero_chip_num
        end
    end

    return totalSoulNum
end



function PVSmeltView:clearResource()

    cclog("--PVSmeltView:clearResource--")
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
end

function PVSmeltView:onShowSacrificeView()
    self.shieldlayer:setTouchEnabled(true)
    self:setVisible(true)
end

--tab点击
function PVSmeltView:onSlidingMenuChange(state)
    if self.isMenuCanTouch == false then
        return
    end
    ---------------ljr
    if state == 2 then
        self.oweCoin:setString(self.commonData:getFinance(1))
        self.oweEquipsoul:setString(self.commonData:getFinance(21))
        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.breakupOpenLeve = getTemplateManager():getBaseTemplate():getEquRefundOpenLeve()

        local _stageId = getTemplateManager():getBaseTemplate():getEquRefundOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if  isOpen then    ---self.playerLevel >= self.breakupOpenLeve

        else
            --功能等级开放提示
            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.breakupOpenLeve), 0, 1000)
            getStageTips(_stageId)
            return
        end
    end

    if state == 3 then
        -- self.oweRaw:setString(self.c_runeData:getStone1())
        -- self.oweSpari:setString(self.c_runeData:getStone2())
        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.breakupOpenLeve = getTemplateManager():getBaseTemplate():getRuneOpenLeve()

        local _stageId = getTemplateManager():getBaseTemplate():getTotemOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then     --self.playerLevel >= self.breakupOpenLeve

        else
            --功能等级开放提示
            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.breakupOpenLeve), 0, 1000)
            getStageTips(_stageId)
            return
        end
    end
    ----------------
    self:removeChildByTag(1000)

    self:onMenuChange(state)

    self.current_type = state
    for k,v in pairs(self.menuTable) do
        if k == state then
            v:setEnabled(false)
        else
            v:setEnabled(true)
        end
    end

    self.curTab = state

end

--tab点击
function PVSmeltView:onMenuChange(state)

    self.bg_wujiang:setVisible(false)
    self.bg_zhuangbei:setVisible(false)
    self.bg_fuwen:setVisible(false)

    if state == 1 then
        self.bg_wujiang:setVisible(true)

        self.soldierNode:setVisible(true)
        self.smeltLayer:setVisible(false)
        self.runeNode:setVisible(false)

        self.soldierSelect:setVisible(true)
        self.soldierNormal:setVisible(false)
        self.equipSelect:setVisible(false)
        self.equipNor:setVisible(true)
        self.runeSelect:setVisible(false)
        self.runeNormal:setVisible(true)
    elseif state == 2 then
        self.bg_zhuangbei:setVisible(true)

        self.soldierNode:setVisible(false)
        self.smeltLayer:setVisible(true)
        self.runeNode:setVisible(false)

        self.soldierSelect:setVisible(false)
        self.soldierNormal:setVisible(true)
        self.equipSelect:setVisible(true)
        self.equipNor:setVisible(false)
        self.runeSelect:setVisible(false)
        self.runeNormal:setVisible(true)
    elseif state == 3 then
        self.bg_fuwen:setVisible(true)

        self.soldierNode:setVisible(false)
        self.smeltLayer:setVisible(false)
        self.runeNode:setVisible(true)

        self.soldierSelect:setVisible(false)
        self.soldierNormal:setVisible(true)
        self.equipSelect:setVisible(false)
        self.equipNor:setVisible(true)
        self.runeSelect:setVisible(true)
        self.runeNormal:setVisible(false)
    end
end


return PVSmeltView
