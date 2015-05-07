--
-- 商城获得物品展示界面
-- self.type = 1 : 一个按钮的模式
-- to do 未处理 道具 礼包

local PVShopShowCards = class("PVShopShowCards", BaseUIView)


function PVShopShowCards:ctor(id)

    self.isMusic = false

    self.super.ctor(self, id)

    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.equipData = getDataManager():getEquipmentData()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()

    local function onNodeEvent(event)
        if "exit" == event then
            self:onExit()
        end
    end

    self:registerScriptHandler(onNodeEvent)

    self:registerNetCallback()
end

function PVShopShowCards:onExit()
    cclog("------PVShopShowCards:onExit------------")
    getDataManager():getShopData():setShopRecruitType(0)
end
function PVShopShowCards:onMVCEnter()
    self.cardList = {}
    --初始化属性
    self:init()
    --绑定事件
    self:initTouchListener()
    --加载本界面的ccbi ui_shop.ccbi
    self:loadCCBI("shop/ui_shop_show.ccbi", self.ccbiNode)
    --获取控件
    self:initView()

    --TODO: 先注释掉有问题打开重写
    -- local guidId = getNewGManager():getCurrentGid()
    -- if(guidId == G_GUIDE_20103) then
    --     getNewGManager():startGuide()
    -- end

end

-- 初始化数据
function PVShopShowCards:init()

    self.ccbiNode = {}
    self.ccbiRootNode = {}

    assert(self.funcTable, "show page must have data !")
    self.data = self.funcTable[1]  -- 所有物品数据, GameResourcesResponse
    ---self.type = self.funcTable[2]  -- 模式类型，type == 1 : 一个按钮模式
    self.type = self.funcTable[2]  --根据self.type判断时良将招募还是神将招募，1代表良将，2代表将
    -- 统计卡数量,信息 self.cardNum, self.cardList = {}
    self:countAllCard()

end

-- 统计卡的信息
function PVShopShowCards:countAllCard()
    --self.cardList = {}
    local index = 1
    -- cclog("这里是抽卡世界")
    print("所有物品数据 ===================== ")
    -- table.print(self.data)
    -- cclog("-------------------------------")
    for k,v in pairs(self.data) do
        if k == "heros" then
            for _key,_hero in pairs(v) do
                local _name = self.soldierTemp:getHeroName(_hero.hero_no)
                local heroImg, _img = self.soldierTemp:getSoldierImageName(_hero.hero_no)
                -- local _img = self.soldierTemp:getSoldierImageName(_hero.hero_no)
                -- addHeroHDSpriteFrame(_hero.hero_no)
                _img = string.gsub(_img, "all", "2.png", 1)
                -- print(_img)

                local _num = self.soldierTemp:getHeroQuality(_hero.hero_no)
                self.cardList[index] = {type = 1, name = _name, img = _img, starNum = _num, eleNo = _hero.hero_no}
                index = index + 1
            end
            self.bgType = 1
        elseif k == "equipments" then
            for _key,_equip in pairs(v) do
                local _name = self.equipTemp:getEquipName(_equip.no)
                local _img = self.equipTemp:getEquipResHD(_equip.no)
                local _num = self.equipTemp:getQuality(_equip.no)
                self.cardList[index] = {type = 2, name = _name, img = _img, starNum = _num, eleNo = _equip.no}
                index = index + 1
            end
            self.bgType = 2
        elseif k == "items" then
            for _key,_item in pairs(v) do
                local _itemData = self.bagTemp:getItemById(_item.item_no)
                local _name = self.languageTemp:getLanguageById(_itemData.name)
                local _img = self.bagTemp:getItemResIcon(_item.item_no)
                local _num = self.bagTemp:getItemQualityById(_item.item_no)
                self.cardList[index] = {type = 3, name = _name, img = _img, starNum = _num}
                index = index + 1
            end
            self.bgType = 3
        elseif k == "hero_chips" then
            for _key,_chip in pairs(v) do
                local _name = self.chipTemp:getChipName(_chip.hero_chip_no)
                _name = _name .. " X " .. _chip.hero_chip_num
                local _quality = self.chipTemp:getTemplateById(_chip.hero_chip_no).quality
                local _img = self.chipTemp:getChipIconById(_chip.hero_chip_no)
                cclog("英雄碎片".._img)
                self.cardList[index] = {type = 4, name = _name, img = _img, starNum = _quality, num = _chip.hero_chip_num, eleNo = _chip.hero_chip_no}
                index = index + 1
            end
            self.bgType = 1
        elseif k == "equipment_chips" then
            for _key,_chip in pairs(v) do
                local _name = self.chipTemp:getChipName(_chip.equipment_chip_no)
                _name = _name .. " X " .. _chip.equipment_chip_num
                local _quality = self.chipTemp:getTemplateById(_chip.equipment_chip_no).quality
                local _img = self.chipTemp:getChipIconById(_chip.equipment_chip_no)
                self.cardList[index] = {type = 5, name = _name, img = _img, starNum = _quality, eleNo = _chip.equipment_chip_no}
                index = index + 1
            end
            self.bgType = 2
        elseif k == "finance" then
            print("商城抽取 为甚么会由finance抽到？？？ ")
        end
    end
    self.cardNum = index - 1

end

-- 绑定事件
function PVShopShowCards:initTouchListener()

    local function menuClickBack()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        print("menuclickBack ...")
        calFlag = false
        godFlag = false
        SHOP_PAST_PAGE_HIDEVIEW = true
        self:onHideView()
        groupCallBack(GuideGroupKey.BTN_CLICK_SHOP_BACK)
        -- stepCallBack(G_GUIDE_20120)
        --stepCallBack(G_GUIDE_20084)
    end

    local function menuClickRecruit()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        print("menuclickRecruit ...")
        ---SHOP_PAST_PAGE_HIDEVIEW = false
        ---self:onHideView()
        self:cntRecSingle()
    end
    local function menuClickBefore()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()

        print("menuclick before")
        if self.currCardIdx > 1 then
            self.currCardIdx = self.currCardIdx - 1
            self:showCard()
            self.menuRightArr:setVisible(true)
        end
        if self.currCardIdx == 1 then
            self.menuLeftArr:setVisible(false)
        end
    end
    local function menuClickNext()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        print("menu click next")
        if self.currCardIdx < self.cardNum then
            self.currCardIdx = self.currCardIdx + 1
            self:showCard()
            self.menuLeftArr:setVisible(true)
        end
        if self.currCardIdx == self.cardNum then
            self.menuRightArr:setVisible(false)
        end
    end
    --产看全部
    local function menuClickLookAll()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        print("menu click look all")
        self:lookAll()

    end
    --继续招募十个
    local function menuClickRecruitTen()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        print("menuclickRecruit ten ...")
        ---SHOP_PAST_PAGE_HIDEVIEW = false
        ---self:onHideView()
        self:cntRecTen()
    end


    local function onCheckClick()
        print("onCheckClick ============== ", self.cardList[self.currCardIdx].eleNo)
        self:onCheckDetail(self.currCardIdx)
    end

    local function onCheckClick1()
        self:onCheckDetail(1)
    end

    local function onCheckClick2()
        self:onCheckDetail(2)
    end

    local function onCheckClick3()
        self:onCheckDetail(3)
    end

    local function onCheckClick4()
        self:onCheckDetail(4)
    end

    local function onCheckClick5()
        self:onCheckDetail(5)
    end

    local function onCheckClick6()
        self:onCheckDetail(6)
    end

    local function onCheckClick7()
        self:onCheckDetail(7)
    end

    local function onCheckClick8()
        self:onCheckDetail(8)
    end

    local function onCheckClick9()
        self:onCheckDetail(9)
    end

    local function onCheckClick10()
        self:onCheckDetail(10)
    end

    self.ccbiNode["UIShopRcFirst"] = {}
    self.ccbiNode["UIShopRcFirst"]["menuClickBack"] = menuClickBack
    self.ccbiNode["UIShopRcFirst"]["menuClickAgain"] = menuClickRecruit
    self.ccbiNode["UIShopRcFirst"]["beforeClick"] = menuClickBefore
    self.ccbiNode["UIShopRcFirst"]["nextClick"] = menuClickNext
    self.ccbiNode["UIShopRcFirst"]["menuClickLookAll"] = menuClickLookAll
    self.ccbiNode["UIShopRcFirst"]["menuClickAgainTen"] = menuClickRecruitTen

    self.ccbiNode["UIShopRcFirst"]["onCheckClick"] = onCheckClick
    self.ccbiNode["UIShopRcFirst"]["onCheckClick1"] = onCheckClick1
    self.ccbiNode["UIShopRcFirst"]["onCheckClick2"] = onCheckClick2
    self.ccbiNode["UIShopRcFirst"]["onCheckClick3"] = onCheckClick3
    self.ccbiNode["UIShopRcFirst"]["onCheckClick4"] = onCheckClick4
    self.ccbiNode["UIShopRcFirst"]["onCheckClick5"] = onCheckClick5
    self.ccbiNode["UIShopRcFirst"]["onCheckClick6"] = onCheckClick6
    self.ccbiNode["UIShopRcFirst"]["onCheckClick7"] = onCheckClick7
    self.ccbiNode["UIShopRcFirst"]["onCheckClick8"] = onCheckClick8
    self.ccbiNode["UIShopRcFirst"]["onCheckClick9"] = onCheckClick9
    self.ccbiNode["UIShopRcFirst"]["onCheckClick10"] = onCheckClick10
end

-- 注册网络response回调
function PVShopShowCards:registerNetCallback()

    local function responseCallback(id, data)
        print(" --------$$ responseCallback $$----------", id, data)
        -- table.print(data)

        local commonData = getDataManager():getCommonData()
        local shopTemplate = getTemplateManager():getShopTemplate()

        if SHOP_EQUIP_TYPE == 1 then
            if _heroUseMoney == 0 then
                commonData:setFineHero(commonData:getTime())  -- 本次免费，将本次抽取的时间放入DataCenter
            else
                commonData:subCoin( shopTemplate:getHeroUseMoney() )  -- 扣除相应的钱
            end

        elseif SHOP_EQUIP_TYPE == 2 then
            commonData:subCoin( shopTemplate:getTenHeroUseMoney() )  -- 扣除相应的钱
        elseif SHOP_EQUIP_TYPE == 3 then
            if self.godHeroUseMoney == 0 then
                commonData:setExcellentHero(commonData:getTime())
            else
                commonData:subGold( shopTemplate:getGodHeroUseMoney())  -- 扣除相应的钱
            end

        elseif SHOP_EQUIP_TYPE == 4 then
            commonData:subGold( shopTemplate:getTenGodHeroUseMoney() )
        end
        self:updateCard(data.gain)

    end
    self:registerMsg(SHOP_REQUEST_HERO_CODE, responseCallback)
end
--单个继续招募
function PVShopShowCards:cntRecSingle()
    local shopTemplate = getTemplateManager():getShopTemplate()
    if self.type == 1 then
        local _heroUseMoney = shopTemplate:getHeroUseMoney()
        if self:checkIsCanBuy( _heroUseMoney ) == true then  -- 买得起，才发送协议
            SHOP_EQUIP_TYPE = 1
            cclog("发送1号协议")
            getDataManager():getShopData():setShopRecruitType(3)
            getNetManager():getShopNet():sendBuyHeroMsg()
            ---self.__flag = true
        else
            -- self:toastShow( Localize.query("shop.10") )
            getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
        end
    elseif self.type == 2 then
        local _useMoney = shopTemplate:getGodHeroUseMoney()
        if self:checkIsCanBuy( _useMoney ) == true then -- 买得起，才发送协议
            SHOP_EQUIP_TYPE = 3
            cclog("发送3号协议")
            getDataManager():getShopData():setShopRecruitType(3)
            getNetManager():getShopNet():sendBuyGodHeroMsg()
        else
            print("!!! gold is not enough")
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
        end
    end
end
--十个继续招募
function PVShopShowCards:cntRecTen()
    local _shopTemplate = getTemplateManager():getShopTemplate()
    if self.type == 1 then
        if self:checkIsCanBuy( _shopTemplate:getTenHeroUseMoney() ) == true then  -- 买得起，才发送协议
            SHOP_EQUIP_TYPE = 2
            cclog("发送2号协议")
            getNetManager():getShopNet():sendBuyHero10Msg()
            getDataManager():getShopData():setShopRecruitType(3)
            --self.__flag = true
        else
            -- self:toastShow( Localize.query("shop.10") )
            getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
        end
    elseif self.type == 2 then
        --local _useMoney = shopTemplate:getGodHeroUseMoney()
        if self:checkIsCanBuy( _shopTemplate:getTenGodHeroUseMoney() ) == true then -- 买得起，才发送协议
            SHOP_EQUIP_TYPE = 4
            cclog("发送4号协议")
            getNetManager():getShopNet():sendBuyGodHero10Msg()
            getDataManager():getShopData():setShopRecruitType(3)
        else
            print("!!! gold is not enough")
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
        end
    end
end
--检查是否可以购买
function PVShopShowCards:checkIsCanBuy(money)
    local commonData = getDataManager():getCommonData()
    if self.type == 1 then
        print("-------用户的银两--------"..commonData:getCoin().."消耗："..money)
        if commonData:getCoin() < money then return false
        else return true end
    elseif self.type ==2 then
        print("-------用户的元宝--------"..commonData:getGold().."消耗："..money)
        if commonData:getGold() < money then return false
        else return true end
    end
end
--获取控件
function PVShopShowCards:initView()

    self.ccbiRootNode = self.ccbiNode["UIShopRcFirst"]
    self.actionManager = self.ccbiRootNode["mAnimationManager"]
    self.ImgBg = self.ccbiRootNode["imgBg"]
    self.imgStarBg = self.ccbiRootNode["star_bg"]
    self.labelCardName = self.ccbiRootNode["labelName"]
    self.menuLeftArr = self.ccbiRootNode["menu_left_arr"]
    self.menuRightArr = self.ccbiRootNode["menu_right_arr"]
    --self.imgFntAgain = self.ccbiRootNode["sprite_fnt_call"]
    --self.imgFntBack = self.ccbiRootNode["sprite_fnt_back"]
    self.menuBack = self.ccbiRootNode["menuBack"]
    self.menuAgain = self.ccbiRootNode["menuAgain"]
    self.imgLight = self.ccbiRootNode["sprite_light"]
    self.imgFrame = self.ccbiRootNode["img_frame"]
    self.imgFrameColor = self.ccbiRootNode["frame_color"]
    self.ImgChip = self.ccbiRootNode["imgChip"]
    self.Bg = self.ccbiRootNode["bg"]
    self.menuLookAll = self.ccbiRootNode["menuLookAll"]
    --self.imgFntLookAll = self.ccbiRootNode["sprite_fnt_lookall"]
    self.menuFlaunt = self.ccbiRootNode["menuFlaunt"]
    --self.imgFntFlaunt = self.ccbiRootNode["sprite_fnt_flaunt"]
    self.layerShowAll = self.ccbiRootNode["allLayer"]
    self.menuAginTen = self.ccbiRootNode["menuAgainTen"]
    self.nodeBlackbg = self.ccbiRootNode["black_bg"]
    self.nodeLabel = self.ccbiRootNode["suipianSp"]
    self.suipianNum = self.ccbiRootNode["suipianNum"]

    self.imagBgTab = {}
    self.nameLabelTab = {}
    for i=1,10 do
        local strImg = "imgBg"..tostring(i)
        local strLab = "nameNumLabel"..tostring(i)
        table.insert(self.imagBgTab, self.ccbiRootNode[strImg])
        table.insert(self.nameLabelTab, self.ccbiRootNode[strLab])
    end

    self.menuLeftArr:setVisible(false)

    -- 按类型更换按钮布局---------添加这个是因为什么呢----------------------------
    -- if self.type == 1 then
    --     self:setOneBtnModel()
    -- end

    --更改－－－－

    if self.cardNum == 1 then
        self:hideArrows() -- 隐藏左右按钮
        self.menuLookAll:setVisible(false)
        --self.imgFntLookAll:setVisible(false)
        self.menuAginTen:setVisible(false)
    else
        self:lookAllOrNot(false)
    end

    -- background
    if self.bgType == 1 then
        self.Bg:setTexture("res/ccb/effectpng/ui_soldier_bg.jpg")
    elseif self.bgType == 2 then
        self.Bg:setTexture("res/ccb/effectpng/ui_equip_bg.jpg")
    end

    -- 将第一张卡显示
    self.currCardIdx = 1
    self:showCard()
end

-- 设置一个按钮的界面模式
function PVShopShowCards:setOneBtnModel()
    local _winSize = cc.Director:getInstance():getWinSize()
    self.menuBack:setPositionX(320)
    --self.imgFntBack:setPositionX(320)
    self.menuAgain:setVisible(false)
    --self.imgFntAgain:setVisible(false)
end

-- 隐藏左右箭头按钮
function PVShopShowCards:hideArrows()
    self.menuLeftArr:setVisible(false)
    self.menuRightArr:setVisible(false)
end

function PVShopShowCards:stopMusicHero()
    print("------------- stopMusicHero -----------------------")
    print(self.isMusic)
    if self.isMusic == true then
        print("关闭音效")
        -- cc.SimpleAudioEngine:getInstance():stopEffect(self.musicEffect)
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        self.isMusic = false
        -- cc.SimpleAudioEngine:getInstance():stopMusic(true)
    else
    end
end

-- 显示卡牌
function PVShopShowCards:showCard()
    print("显示卡牌 =============== ")
    if self.cardList == nil then 
        print("self.cardList是空值")
        return
    end

    -- table.print(self.cardList)
    
    self.labelCardName:setString(self.cardList[self.currCardIdx].name)
    local color = getTemplateManager():getStoneTemplate():getColorByQuality(self.cardList[self.currCardIdx].starNum)
    self.labelCardName:setColor(color)
    local imgPicName = self.cardList[self.currCardIdx].img
    local cardType = self.cardList[self.currCardIdx].type
    local starNum = self.cardList[self.currCardIdx].starNum
    self.nodeLabel:setVisible(false)
-- print("show card, ", starNum)
    if cardType == 1 then
        self.imgFrameColor:setSpriteFrame(getNewIconByQuality(starNum))
        self:showStar(starNum)
        self.ImgBg:setVisible(true)
        self.ImgBg:removeAllChildren()
        self.ImgBg:setSpriteFrame(imgPicName)
        self.ImgChip:setVisible(false)
        self.ImgBg:setScale(1.2,1.2)

        ------------------------
        local soldierId = self.cardList[self.currCardIdx].eleNo

        if soldierId > 0 then
            local res = getTemplateManager():getSoldierTemplate():getHeroAudio(soldierId)
            if res == 0 then
                print("没有音效")
            else
                print("播放音效")
                self.isMusic = true
                self.musicEffect = res
                getAudioManager():playHeroEffect(res)
            end
        end
        ------------------------

    elseif cardType == 2 then
        -- self.imgFrameColor:setSpriteFrame(getIconHDByQuality(starNum))
        self.ImgBg:setVisible(true)
        self.ImgBg:removeAllChildren()
        self.ImgBg:setTexture("res/equipment/"..imgPicName)
        self.ImgChip:setVisible(false)
        self.ImgBg:setScale(1.2,1.2)
        self:hideStar()
        self:isHideFrame(false)
    elseif cardType == 3 then
        self.ImgBg:setVisible(false)
        self.ImgChip:setVisible(true)
        setCardWithFrame(self.ImgChip, "res/icon/item/"..imgPicName, starNum)
        self:hideStar()
        self:isHideFrame(false)
    elseif cardType == 4 then
        local num = self.cardList[self.currCardIdx].num
        self.ImgBg:setVisible(false)
        self.ImgChip:setVisible(true)
        setChipWithFrame(self.ImgChip, "res/icon/hero/"..imgPicName, starNum)
        self.suipianNum:setString(num)
        self.nodeLabel:setVisible(true)
        self:hideStar()
        self:isHideFrame(false)
    elseif cardType == 5 then
        self.ImgBg:setVisible(false)
        self.ImgChip:setVisible(true)
        setChipWithFrame(self.ImgChip, "res/icon/equipment/"..imgPicName, starNum)
        self:hideStar()
        self:isHideFrame(false)
    end
end

function PVShopShowCards:hideStar()
    self.imgStarBg:setVisible(false)
end

function PVShopShowCards:isHideFrame(flag)
    self.imgFrameColor:setVisible(flag)
    self.imgFrame:setVisible(flag)
end

-- 显示星级
function PVShopShowCards:showStar(number)

    self.imgStarBg:setVisible(true)
    self.imgFrameColor:setVisible(true)
    self.imgFrame:setVisible(true)

    -- 先清空
    self.imgStarBg:removeAllChildren()

    local _starTable = {}
    for i=1,number do
        local _star = game.newSprite("#ui_common_startup.png")
        self.imgStarBg:addChild(_star)
        table.insert(_starTable, _star)
    end

    -- 找到第一颗星星的初始点，之后的往后面移位
    local _starSize = _starTable[1]:getContentSize()
    local _bgSize = self.imgStarBg:getContentSize()
    local posX = self.imgStarBg:getPositionX()
    if number%2 == 0 then  -- 偶数
        posX = _bgSize.width/2 - math.floor(number/2) * _starSize.width + _starSize.width/2
    else    -- 奇数
        posX = _bgSize.width/2 - math.floor(number/2) * _starSize.width
    end

    for i,v in ipairs(_starTable) do
        v:setPositionX( posX + (i-1)*_starSize.width )
        v:setPositionY( _bgSize.height/2 )
        -- print("v:getPositionX()", v:getPositionX())
    end
end

function PVShopShowCards:updateCard(data)
    cclog("更新卡片显示")
    self.data = data
    --self.type = data[2]

    self:countAllCard()

    if self.cardNum == 1 then
        self:hideArrows() -- 隐藏左右按钮
        self.menuLookAll:setVisible(false)
        --self.imgFntLookAll:setVisible(false)
        self.menuAginTen:setVisible(false)
    else
        self.menuLeftArr:setVisible(true)
        self.menuRightArr:setVisible(true)
        self.menuLeftArr:setVisible(false)
        self:lookAllOrNot(false)
    end

    -- background
    if self.bgType == 1 then
        self.Bg:setTexture("res/ccb/effectpng/ui_soldier_bg.jpg")
    elseif self.bgType == 2 then
        self.Bg:setTexture("res/ccb/effectpng/ui_equip_bg.jpg")
    end
    -- 将第一张卡显示
    self.currCardIdx = 1
    self:showCard()
end
--是否全部展示
function PVShopShowCards:lookAllOrNot(flag)
    if flag then
        self:hideArrows() -- 隐藏左右按钮
        self.menuLookAll:setVisible(not flag)
        --self.imgFntLookAll:setVisible(not flag)
        self.imgFrame:setVisible(not flag)
        self.imgFrameColor:setVisible(not flag)
        self.imgStarBg:setVisible(not flag)
        self.ImgBg:setVisible(not flag)
        self.ImgChip:setVisible(not flag)
        self.Bg:setVisible(not flag)
        self.labelCardName:setVisible(not flag)
        self.menuFlaunt:setVisible(flag)
        --self.imgFntFlaunt:setVisible(flag)
        self.menuAgain:setVisible(not flag)
        self.menuAginTen:setVisible(flag)
        --self.imgFntAgain:setVisible(flag)
        --self.imgFntBack:setVisible(flag)
        self.menuBack:setVisible(flag)
        self.layerShowAll:setVisible(flag)
        self.nodeBlackbg:setVisible(not flag)

    else
        --self:hideArrows() -- 隐藏左右按钮
        self.menuLookAll:setVisible(not flag)
        --self.imgFntLookAll:setVisible(not flag)
        self.imgFrame:setVisible(not flag)
        self.imgFrameColor:setVisible(not flag)
        self.imgStarBg:setVisible(not flag)
        self.ImgChip:setVisible(not flag)
        self.Bg:setVisible(not flag)
        self.labelCardName:setVisible(not flag)
        self.ImgBg:setVisible(not flag)
        self.menuFlaunt:setVisible(flag)
        --self.imgFntFlaunt:setVisible(flag)
        self.menuAgain:setVisible(flag)
        --self.imgFntAgain:setVisible(flag)
        --self.imgFntBack:setVisible(flag)
        self.menuBack:setVisible(flag)
        self.layerShowAll:setVisible(flag)
        self.menuAginTen:setVisible(flag)
        self.nodeBlackbg:setVisible(not flag)
    end
end

function PVShopShowCards:lookAll()
        self:lookAllOrNot(true)
        self:showAllCards()
end

-- 显示所有卡牌
function PVShopShowCards:showAllCards()

    print("显示所有卡牌 ================= ")
    if self.cardList == nil then 
        print("self.cardList是空值")
        return
    end
    -- table.print(self.cardList)
    for i=1,10 do
        self.nameLabelTab[i]:setString(self.cardList[i].name)
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(self.cardList[i].starNum)
        self.nameLabelTab[i]:setColor(color)
        local imgPicName = self.cardList[i].img
        local cardType = self.cardList[i].type
        local starNum = self.cardList[i].starNum
        self.nodeLabel:setVisible(false)
    -- print("show card, ", starNum)
        if cardType == 1 then
            --setShopItemImage(self.imagBgTab[i], imgPicName, starNum)
            local elementNo = self.cardList[i].eleNo
            imgPicName = "res/icon/hero/hero_"..tostring(elementNo).."_4.png"
            setShopItemImage(self.imagBgTab[i], imgPicName, starNum)
            -- if self.type == 2 then
            --     local nodeEff = UI_gongxihuodejiemian()
            --     nodeEff:setAnchorPoint(cc.p(0,0))
            --     nodeEff:setPosition(cc.p(62,62))
            --  -- cclog("nodeEff锚点的x坐标为："..nodeEff:getAnchorPoint().x.."锚点的y坐标为"..nodeEff:getAnchorPoint().y)
            --  -- cclog("nodeEff位置的x坐标为："..nodeEff:getPositionX().."位置的y坐标为"..nodeEff:getPositionY())
            --     self.imagBgTab[i]:addChild(nodeEff)
            -- end

        elseif cardType == 2 then
            -- imgPicName = "res/equipment/"..imgPicName
            -- setShopItemImage(self.imagBgTab[i], imgPicName, starNum)
            local elementNo = self.cardList[i].eleNo
            imgPicName = "res/icon/equipment/equ_"..tostring(elementNo).."_2.png"
            setShopItemImage(self.imagBgTab[i], imgPicName, starNum)

        elseif cardType == 3 then
            imgPicName = "res/icon/item/"..imgPicName
            setCardWithFrame(self.imagBgTab[i], imgPicName, starNum)

        elseif cardType == 4 then
            imgPicName = "res/icon/hero/"..imgPicName
            --setShopItemImage(self.imagBgTab[i], imgPicName, starNum)
            setShopHeroChip(self.imagBgTab[i], imgPicName, starNum)
        elseif cardType == 5 then
            imgPicName = "res/icon/equipment/"..imgPicName
            setChipWithFrame(self.imagBgTab[i], imgPicName, starNum)
        end
    end

end
--查看详细信息
function PVShopShowCards:onCheckDetail(index)
    local curType = self.cardList[index].type
    if curType == 1 then
        print("武将查看 ============== ")
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", self.cardList[index].eleNo)
    elseif curType == 4 then
        print("武将碎片查看============ ")
        getOtherModule():showOtherView("PVCommonChipDetail", 1, self.cardList[index].eleNo, self.cardList[index].num)
    end
end

--@return
return PVShopShowCards
