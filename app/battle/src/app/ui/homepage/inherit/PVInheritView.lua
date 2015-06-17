

--传承

local RgTableView = import("..equipment.PVEquipShuxTableView")

local PVFounctionNotOpen = import("...other.PVFounctionNotOpen")

--传承

UPDATE_VIEW = "UPDATE_VIEW"

local PVInheritView = class("PVInheritView", BaseUIView)

function PVInheritView:ctor(id)
    self.super.ctor(self, id)

    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()  -- 中文
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.lineupData = getDataManager():getLineupData()
    self.heroTemp = getTemplateManager():getSoldierTemplate()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_CommonData = getDataManager():getCommonData()
    self.c_Calculation = getCalculationManager():getCalculation()
end

function PVInheritView:onMVCEnter()
    -- game.addSpriteFramesWithFile("res/ccb/resource/ui_travel2.plist")
    self.UIInheritView = {}
    self:initTouchListener()
    --加载本界面的ccbi
    self:loadCCBI("inherit/ui_inherit_view.ccbi", self.UIInheritView)
    
    --协议
    self:initRegisterNetCallBack()

    self:initView()  
    self:initData()

    local function fwzhcallFunc()
        self:updateData2()
    end

    self.listener = cc.EventListenerCustom:create(UPDATE_VIEW, fwzhcallFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

end


function PVInheritView:onExit()
    cclog("---PVInheritView:onExit----")

    local equ = {}
    getDataManager():getInheritData():setlt1(equ)
    getDataManager():getInheritData():setlt2(equ)
    getDataManager():getInheritData():setequId1(equ)
    getDataManager():getInheritData():setequId2(equ)
    getDataManager():getInheritData():setws1(equ)
    getDataManager():getInheritData():setws2(equ)
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel2.plist")

    self:getEventDispatcher():removeEventListener(self.listener)

    getDataManager():getResourceData():clearResourcePlistTexture()
end

function PVInheritView:initView()
    self.priceNum = self.UIInheritView["UIInheritView"]["priceNum"]

    self.menuTable = {} --4个按钮
    self.menuA = self.UIInheritView["UIInheritView"]["liantiBtn"]
    self.menuB = self.UIInheritView["UIInheritView"]["equBtn"]
    self.menuC = self.UIInheritView["UIInheritView"]["wshBtn"]
    self.menuA:setAllowScale(false)
    self.menuB:setAllowScale(false)
    self.menuC:setAllowScale(false)
    table.insert(self.menuTable, self.menuA)
    table.insert(self.menuTable, self.menuB)
    table.insert(self.menuTable, self.menuC)

    self.allGoldLabel = self.UIInheritView["UIInheritView"]["allGoldLabel"]
    local goldNUm = self.c_CommonData:getGold()
    self.allGoldLabel:setString(goldNUm)


    self.menuANormal = self.UIInheritView["UIInheritView"]["soldierNormal"]
    self.menuASelect = self.UIInheritView["UIInheritView"]["soldierSelect"]

    self.menuBNormal = self.UIInheritView["UIInheritView"]["upNormal"]
    self.menuBSelect = self.UIInheritView["UIInheritView"]["upSelect"]

    self.menuCNormal = self.UIInheritView["UIInheritView"]["ws_normal"]
    self.menuCSelect = self.UIInheritView["UIInheritView"]["ws_select"]

    -- 三个标签的3个layer 
    self.layer1 = self.UIInheritView["UIInheritView"]["layer1"]
    self.layer2 = self.UIInheritView["UIInheritView"]["layer2"]
    self.layer3 = self.UIInheritView["UIInheritView"]["layer3"]
    -- 是否已经选择需要传承的卡牌
    self.ltNoLayer = self.UIInheritView["UIInheritView"]["ltNoLayer"]
    self.zbNoLayer = self.UIInheritView["UIInheritView"]["zbNoLayer"]
    self.wsNoLayer = self.UIInheritView["UIInheritView"]["wsNoLayer"]
    -- 左右
    self.ltHaveLayerL = self.UIInheritView["UIInheritView"]["ltHaveLayerL"]
    self.ltHaveLayerR = self.UIInheritView["UIInheritView"]["ltHaveLayerR"]
    self.zbHaveLayerL = self.UIInheritView["UIInheritView"]["zbHaveLayerL"]
    self.zbHaveLayerR = self.UIInheritView["UIInheritView"]["zbHaveLayerR"]
    self.wsHaveLayerL = self.UIInheritView["UIInheritView"]["wsHaveLayerL"]
    self.wsHaveLayerR = self.UIInheritView["UIInheritView"]["wsHaveLayerR"]
    
--  1  --
    
    -- 材料卡牌的信息
    self.iconSpriteCailiaoLT = self.UIInheritView["UIInheritView"]["iconSpriteCailiaoLT"]
    self.cailiaoLTName = self.UIInheritView["UIInheritView"]["cailiaoLTName"]
    self.jieL1 = self.UIInheritView["UIInheritView"]["jieL1"]
    self.ltLayerLeft = self.UIInheritView["UIInheritView"]["ltLayerLeft"]
    self.sodDesLeft = self.UIInheritView["UIInheritView"]["sodDesLeft"]   -- 描述
    self.ltlabel_lv1 = self.UIInheritView["UIInheritView"]["ltlabel_lv1"]
    self.noLTLeft = self.UIInheritView["UIInheritView"]["noLTLeft"] 

    self.starTable = {} 

    local starSelect1 = self.UIInheritView["UIInheritView"]["starSelect1"]
    local starSelect2 = self.UIInheritView["UIInheritView"]["starSelect2"]
    local starSelect3 = self.UIInheritView["UIInheritView"]["starSelect3"]
    local starSelect4 = self.UIInheritView["UIInheritView"]["starSelect4"]
    local starSelect5 = self.UIInheritView["UIInheritView"]["starSelect5"]
    local starSelect6 = self.UIInheritView["UIInheritView"]["starSelect6"]

    table.insert(self.starTable, starSelect1)
    table.insert(self.starTable, starSelect2)
    table.insert(self.starTable, starSelect3)
    table.insert(self.starTable, starSelect4)
    table.insert(self.starTable, starSelect5)
    table.insert(self.starTable, starSelect6)

    -- 传承卡牌的信息
    self.iconSpriteInheritLT = self.UIInheritView["UIInheritView"]["iconSpriteInheritLT"]
    self.inheritLTName = self.UIInheritView["UIInheritView"]["inheritLTName"]
    self.jieR1 = self.UIInheritView["UIInheritView"]["jieR1"]
    self.ltLayerRight = self.UIInheritView["UIInheritView"]["ltLayerRight"]
    self.sodDesRight = self.UIInheritView["UIInheritView"]["sodDesRight"]   -- 描述
    self.ltlabel_lv2 = self.UIInheritView["UIInheritView"]["ltlabel_lv2"]
    self.noLTRight = self.UIInheritView["UIInheritView"]["noLTRight"]

    self.cailiaoNameBg = self.UIInheritView["UIInheritView"]["cailiaoNameBg"]
    self.inheritNameBg = self.UIInheritView["UIInheritView"]["inheritNameBg"]

    self.starTable2 = {} 

    local starSelect21 = self.UIInheritView["UIInheritView"]["starSelect21"]
    local starSelect22 = self.UIInheritView["UIInheritView"]["starSelect22"]
    local starSelect23 = self.UIInheritView["UIInheritView"]["starSelect23"]
    local starSelect24 = self.UIInheritView["UIInheritView"]["starSelect24"]
    local starSelect25 = self.UIInheritView["UIInheritView"]["starSelect25"]
    local starSelect26 = self.UIInheritView["UIInheritView"]["starSelect26"]

    table.insert(self.starTable2, starSelect21)
    table.insert(self.starTable2, starSelect22)
    table.insert(self.starTable2, starSelect23)
    table.insert(self.starTable2, starSelect24)
    table.insert(self.starTable2, starSelect25)
    table.insert(self.starTable2, starSelect26)
    

--  2  --
    
    -- 材料卡牌的信息
    self.iconSpriteCailiaoZB = self.UIInheritView["UIInheritView"]["iconSpriteCailiaoZB"]
    self.cailiaoZBName = self.UIInheritView["UIInheritView"]["cailiaoZBName"]
    self.zhuL1 = self.UIInheritView["UIInheritView"]["zhuL1"]
    self.zbLayerLeft = self.UIInheritView["UIInheritView"]["zbLayerLeft"]
    self.ciL1 = self.UIInheritView["UIInheritView"]["ciL1"]
    self.label_lv1 = self.UIInheritView["UIInheritView"]["label_lv1"]
    self.noZBLeft = self.UIInheritView["UIInheritView"]["noZBLeft"]         -- 
    self.equipPrefixLeft = self.UIInheritView["UIInheritView"]["equipPrefixLeft"] 

    

    -- 传承卡牌的信息
    self.iconSpriteInheritZB = self.UIInheritView["UIInheritView"]["iconSpriteInheritZB"]
    self.inheritZBName = self.UIInheritView["UIInheritView"]["inheritZBName"]
    self.zhuL2 = self.UIInheritView["UIInheritView"]["zhuL2"]
    self.zbLayerRight = self.UIInheritView["UIInheritView"]["zbLayerRight"]
    self.ciL2 = self.UIInheritView["UIInheritView"]["ciL2"]
    self.label_lv2 = self.UIInheritView["UIInheritView"]["label_lv2"]
    self.noZBRight = self.UIInheritView["UIInheritView"]["noZBRight"]       --
    self.equipPrefixRight = self.UIInheritView["UIInheritView"]["equipPrefixRight"] 

    self.addLayer = self.UIInheritView["UIInheritView"]["addLayer"]
    self.addLabel = self.UIInheritView["UIInheritView"]["addLabel"]

    self.zbInheritNameBg = self.UIInheritView["UIInheritView"]["zbInheritNameBg"]
    self.zbCailiaoNameBg = self.UIInheritView["UIInheritView"]["zbCailiaoNameBg"]
    

--  3  --
    
    -- 材料卡牌的信息
    self.wsSpriteCailiaoWS = self.UIInheritView["UIInheritView"]["wsSpriteCailiaoWS"]
    self.cailiaoWSName = self.UIInheritView["UIInheritView"]["cailiaoWSName"]
    self.wsLayerLeft = self.UIInheritView["UIInheritView"]["wsLayerLeft"]
    self.wsDesL1 = self.UIInheritView["UIInheritView"]["wsDesL1"]
    self.noWSLeft = self.UIInheritView["UIInheritView"]["noWSLeft"]
    self.wslabel_lv1 = self.UIInheritView["UIInheritView"]["wslabel_lv1"]


    -- 传承卡牌的信息
    self.wsSpriteinheritWS = self.UIInheritView["UIInheritView"]["wsSpriteinheritWS"]
    self.inheritWSName = self.UIInheritView["UIInheritView"]["inheritWSName"]
    self.wsDesL2 = self.UIInheritView["UIInheritView"]["wsDesL2"]
    self.noWSRight = self.UIInheritView["UIInheritView"]["noWSRight"]
    self.wslabel_lv2 = self.UIInheritView["UIInheritView"]["wslabel_lv2"]


    self.texiaoSp = self.UIInheritView["UIInheritView"]["texiaoSp"]
    self.texiaoSp9 = self.UIInheritView["UIInheritView"]["texiaoSp9"]

    self.animationNode = self.UIInheritView["UIInheritView"]["animationNode"]

    self.noInheritNoOpen = self.UIInheritView["UIInheritView"]["noInheritNoOpen"]
    print("555", self.noInheritNoOpen)

    -- local view = PVFounctionNotOpen.new()
-- common/ui_function_not_open.ccbi
    local proxy = cc.CCBProxy:create()
    local UIAniView = {}
    self.entryView = CCBReaderLoad("common/ui_function_not_open.ccbi", proxy, UIAniView)
    -- self:addChild(self.entryView)
    self.entryView:setVisible(false)

    self.UIInheritView["UIInheritView"]["isNoOpen"]:addChild(self.entryView)

    self.texiaoSp:setVisible(false)
end

function PVInheritView:initData()

    local equ = {}
    getDataManager():getInheritData():setlt1(equ)
    getDataManager():getInheritData():setlt2(equ)
    getDataManager():getInheritData():setequId1(equ)
    getDataManager():getInheritData():setequId2(equ)
    getDataManager():getInheritData():setws1(equ)
    getDataManager():getInheritData():setws2(equ)
    

    self.lt1, self.lt2, self.equ1, self.equ2, self.ws1, self.ws2 = getDataManager():getInheritData():getInheritInit()
    self.lt1Num = table.nums(self.lt1)
    self.lt2Num = table.nums(self.lt2)
    print("~~~~~~"..self.lt1Num)
    print("~~~~~~"..self.lt2Num)
    -- self.equ1, self.equ2, self.ws1, self.ws2 = getDataManager():getInheritData():getInheritInit()
    self.equ1Num = table.nums(self.equ1)
    self.equ2Num = table.nums(self.equ2)
    print("~~~~~~"..self.equ1Num)
    print("~~~~~~"..self.equ2Num)
    self.ws1Num = table.nums(self.ws1)
    self.ws2Num = table.nums(self.ws2)
    print("~~~~~~"..self.ws1Num)
    print("~~~~~~"..self.ws2Num)

    self.paiIsHave = {}                   --材料卡牌是否已经选择
    self.paiIsHave[1] = {}
    self.paiIsHave[1].cailiao = false
    self.paiIsHave[1].inherit = false
    self.paiIsHave[2] = {}
    self.paiIsHave[2].cailiao = false
    self.paiIsHave[2].inherit = false
    self.paiIsHave[3] = {}
    self.paiIsHave[3].cailiao = false
    self.paiIsHave[3].inherit = false


    if self.lt1Num == 0 then
        self.paiIsHave[1].cailiao = false
    else
        self.paiIsHave[1].cailiao = true
        self.ltNo1 = self.lt1.hero_no
        local seal = getDataManager():getSoldierData():getSealById(self.ltNo1)
        self.ltNum1 = self.heroTemp:getAllInt(seal)
        print("-----------   "..self.ltNum1)
        self.ltStep1 = self.heroTemp:getStep(seal) 
        self:initCaiLiaoCard()
    end
    if self.lt2Num == 0 then
        self.paiIsHave[1].inherit = false
    else
        self.paiIsHave[1].inherit = true

        self.ltNo2 = self.lt2.hero_no
        local seal = getDataManager():getSoldierData():getSealById(self.ltNo2)
        self.ltNum2 = self.heroTemp:getAllInt(seal)
        print("-----------   "..self.ltNum2)
        self.ltStep2 = self.heroTemp:getStep(seal)
        self:initInheritCard()
    end

    
    if self.equ1Num == 0 then
        
        self.paiIsHave[2].cailiao = false
    else
        
        self.paiIsHave[2].cailiao = true
        self.equNo1 = self.equ1.no
        self.equLv1 = self.equ1.strengthen_lv
        self:initCaiLiaoCard()
    end
    if self.equ2Num == 0 then
        
        self.paiIsHave[2].inherit = false
    else
        -- print("~~~~~~"..self.equ2)
        self.paiIsHave[2].inherit = true
        self.equNo2 = self.equ2.no
        self.equLv2 = self.equ2.strengthen_lv
       
        self:initInheritCard()
    end

    if self.ws1Num == 0 then 
        self.paiIsHave[3].cailiao = false
    else
        self.paiIsHave[3].cailiao = true
        self.wsNo1 = self.ws1.id
        self:initCaiLiaoCard()
    end
    if self.ws2Num == 0 then 
        self.paiIsHave[3].inherit = false
    else
        self.paiIsHave[3].inherit = true
        self.wsNo2 = self.ws2.id
        self:initInheritCard()
    end


    self.menuIdx = 1                     --按钮选择：1，2，3（默认为1）
    local heroInheritPrice = getTemplateManager():getBaseTemplate():getheroInheritPrice()
    self.priceNum:setString(heroInheritPrice)
    self.inheritPrice = heroInheritPrice  --完美传承需要花费的元宝数

    self.menuA:setEnabled(false)
    self.menuB:setEnabled(true)
    self.menuC:setEnabled(true)

    self:changeView()
end

function PVInheritView:updateData2()
    print("----------------- updateData2 -----------------")
    self.lt1, self.lt2, self.equ1, self.equ2, self.ws1, self.ws2 = getDataManager():getInheritData():getInheritInit()
    self.lt1Num = table.nums(self.lt1)
    self.lt2Num = table.nums(self.lt2)
    print("~~~~~~"..self.lt1Num)
    print("~~~~~~"..self.lt2Num)
    self.equ1Num = table.nums(self.equ1)
    self.equ2Num = table.nums(self.equ2)
    print("~~~~~~"..self.equ1Num)
    print("~~~~~~"..self.equ2Num)
    self.ws1Num = table.nums(self.ws1)
    self.ws2Num = table.nums(self.ws2)
    print("~~~~~~"..self.ws1Num)
    print("~~~~~~"..self.ws2Num)



    if self.lt1Num == 0 then
        self.paiIsHave[1].cailiao = false
    else
        self.paiIsHave[1].cailiao = true
        self.ltNo1 = self.lt1.hero_no
        local seal = getDataManager():getSoldierData():getSealById(self.ltNo1)
        self.ltNum1 = self.heroTemp:getAllInt(seal)
        print("-----------   "..self.ltNum1)
        self.ltStep1 = self.heroTemp:getStep(seal) 
        self:initCaiLiaoCard()
    end
    if self.lt2Num == 0 then
        self.paiIsHave[1].inherit = false
    else
        self.paiIsHave[1].inherit = true

        self.ltNo2 = self.lt2.hero_no
        local seal = getDataManager():getSoldierData():getSealById(self.ltNo2)
        self.ltNum2 = self.heroTemp:getAllInt(seal)
        -- print("self.ltNum2")
        print("-----------   "..self.ltNum2)
        self.ltStep2 = self.heroTemp:getStep(seal)
        self:initInheritCard()
    end
    
    if self.equ1Num == 0 then
        self.paiIsHave[2].cailiao = false
    else
        self.paiIsHave[2].cailiao = true
        self.equNo1 = self.equ1.no
        self.equLv1 = self.equ1.strengthen_lv
        self:initCaiLiaoCard()
    end
    if self.equ2Num == 0 then
        self.paiIsHave[2].inherit = false
    else
        self.paiIsHave[2].inherit = true
        self.equNo2 = self.equ2.no
        self.equLv2 = self.equ2.strengthen_lv
       
        self:initInheritCard()
    end

    if self.ws1Num == 0 then 
        self.paiIsHave[3].cailiao = false
    else
        self.paiIsHave[3].cailiao = true
        self.wsNo1 = self.ws1.id
        print("wsid"..self.wsNo1)
        self:initCaiLiaoCard()
    end
    if self.ws2Num == 0 then 
        self.paiIsHave[3].inherit = false
    else
        self.paiIsHave[3].inherit = true
        self.wsNo2 = self.ws2.id
        print("wsid"..self.wsNo2)
        self:initInheritCard()
    end

    self:changeView()
end

function PVInheritView:initCaiLiaoCard(  )

    if self.menuIdx == 1 then 
        
        local break_level = self.lt1.break_level

        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(self.ltNo1)
        local nameStr = soldierTemplateItem.nameStr
        local name = self.languageTemp:getLanguageById(nameStr)
        self.cailiaoLTName:setString(name)

        self.jieL1:setString(self.ltStep1.."  阶")
        self.ltlabel_lv1:setString("Lv."..self.lt1.level)

        local quality = soldierTemplateItem.quality
        local res = soldierTemplateItem.res
        -- local resIcon = self.c_SoldierTemplate:getSoldierIcon(self.ltNo1)
        -- changeNewIconImage(self.iconSpriteCailiaoLT, resIcon, quality) --更新icon

        local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(self.ltNo1)
        self.iconSpriteCailiaoLT:removeAllChildren()
        self.iconSpriteCailiaoLT:addChild(heroImageNode)
        self.iconSpriteCailiaoLT:setScale(0.8)
        -- game.setSpriteFrame(self.iconSpriteCailiaoLT, heroImageNode)
        
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        self.cailiaoLTName:setColor(color)

        local colorImg = self:getColorImgByQuality(quality)
        game.setSpriteFrame(self.cailiaoNameBg, colorImg)
        -- game.setTexture(self.inheritNameBg, color)

        updateStarLV(self.starTable, quality)
        
        local str = ""
        local seal = getDataManager():getSoldierData():getSealById(self.ltNo1)
        local pulase = self.c_SoldierTemplate:getPulse(seal)       --脉数
        local acupoint = self.c_SoldierTemplate:getAcupoint(seal)  --穴位次序

        local str = ""

        if seal ~= 0 then
            local m1,m2,isA1,isA2,isNum1,isNum2 = self.c_SoldierTemplate:getAllMai(seal)
            if isA1 == true then
                str = str..m1..":已激活所有穴位\n"
            else
                str = str..m1..":已激活"..isNum1.."个穴位\n"
            end

            if isA2 == true then
                str = str..m2..":已激活所有穴位"
            else
                str = str..m2..":已激活"..isNum2.."个穴位"
            end
        end

        self.sodDesLeft:setString(str)
    end

    if self.menuIdx == 2 and self.paiIsHave[2].cailiao == true then 
        print(self.equNo1)
        -- 材料卡牌的信息
        -- local _icon = self.equipTemp:getEquipResIcon(self.equNo1)  -- 资源名
        local _quality = self.equipTemp:getQuality(self.equNo1)    -- 装备品质
        -- changeEquipIconImageBottom(self.iconSpriteCailiaoZB, _icon, _quality)  -- 设置卡的图片

        local _reshd = self.equipTemp:getEquipResHD(self.equNo1)
        self.iconSpriteCailiaoZB:setTexture("res/equipment/".._reshd)

         
        local _name = self.equipTemp:getEquipName(self.equNo1)
        self.cailiaoZBName:setString(_name)
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
        self.cailiaoZBName:setColor(color)

        local colorImg = self:getColorImgByQuality(_quality)
        game.setSpriteFrame(self.zbCailiaoNameBg, colorImg)
        -- game.setTexture(self.inheritNameBg, color)

        self.label_lv1:setString("Lv."..self.equLv1)


        local _equipPrefix = self.equ1.prefix
        local _nameImage = "ui_equip_kind_6"
        if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
        if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
        if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
        if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
        if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
        if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
        local _equipPrefixRes = _nameImage .. ".png"
        game.setSpriteFrame(self.equipPrefixLeft, "#".._equipPrefixRes)
        

        ---------------------------------------------------
        local equipData = self.equ1
        local _descrip = ""
        -- -- table.print(equipData.main_attr)
        -- local main_attr = equipData.main_attr
        -- local mainNum = table.nums(main_attr)
        -- if mainNum == 0 then 
        --     print("没有主属性")
        -- else
        --     local zhuNum =  main_attr[1].attr_value + main_attr[1].attr_increment * equipData.strengthen_lv
        --     zhuNum = math.floor(zhuNum*10)/10
        --     local str = self.equipTemp:setSXName(main_attr[1].attr_type)
        --     _descrip = _descrip .. str .. "   +" .. zhuNum
        -- end
        -- self.zhuL1:setString(_descrip)

        -- 传承前主属性
        local main_attr = self.c_Calculation:EquMainAttr(equipData)
        local nowValue = 0
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then 
            print("没有主属性")
        else
            _descrip = main_attr.AttrName.. "   +" .. main_attr.Value
            nowValue = main_attr.Value
        end
        self.zhuL1:setString(_descrip)


        self.zbLayerLeft:removeAllChildren()
        local rgTableView1 = RgTableView.new()
        rgTableView1:setViewSize(self.zbLayerLeft:getContentSize())
        rgTableView1:initTableView(equipData, 2, false)
        self.zbLayerLeft:addChild(rgTableView1)


    end

    if self.menuIdx == 3 and self.paiIsHave[3].cailiao == true then
        print("--- self.ws1 ------")
        -- table.print(self.ws1)

        local _icon = self.c_ResourceTemplate:getResourceById(self.ws1.icon)
        local _description = self.languageTemp:getLanguageById(self.ws1.discription)
        local _name = self.languageTemp:getLanguageById(self.ws1.name)

        self.wsDesL1:setString(_description)
        self.cailiaoWSName:setString(_name)
        game.setSpriteFrame(self.wsSpriteCailiaoWS, "res/icon/ws/".._icon)
        self.wslabel_lv1:setString("Lv."..self.lineupData:getWSLevel(self.ws1.id)) 
    end
    
end

--更具品质值获取品质颜色值
function PVInheritView:getColorImgByQuality(curQuality)
    local color = "#ui_inherit_bg_lan.png"
    if curQuality == 1 or curQuality == 2 then
        color = "#ui_inherit_bg_lv.png"
    elseif curQuality == 3 or curQuality == 4 then
        color = "#ui_inherit_bg_lan.png"
    elseif curQuality == 5 or curQuality == 6 then
        color = "#ui_inherit_bg_zi.png"
    end
    return color
end

function PVInheritView:initInheritCard( ... )
    
    if self.menuIdx == 1 then 
        local break_level = self.lt2.break_level

        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(self.ltNo2)
        local nameStr = soldierTemplateItem.nameStr
        local name = self.languageTemp:getLanguageById(nameStr)
        self.inheritLTName:setString(name)
        local num = 0
        if self.ltStep1 > self.ltStep2 then
            num = self.ltStep1
        else
            num = self.ltStep2
        end
        self.jieR1:setString(num.."  阶")
        
        self.ltlabel_lv2:setString("Lv."..self.lt2.level)

        local quality = soldierTemplateItem.quality
        local res = soldierTemplateItem.res
        -- local resIcon = self.c_SoldierTemplate:getSoldierIcon(self.ltNo2)
        -- changeNewIconImage(self.iconSpriteInheritLT, resIcon, quality) --更新icon

        local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(self.ltNo2)
        self.iconSpriteInheritLT:removeAllChildren()
        self.iconSpriteInheritLT:addChild(heroImageNode)
        self.iconSpriteInheritLT:setScale(0.8)

        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        self.inheritLTName:setColor(color)

        local colorImg = self:getColorImgByQuality(quality)
        -- game.setTexture(self.zbCailiaoNameBg, colorImg)
        game.setSpriteFrame(self.inheritNameBg, colorImg)

        updateStarLV(self.starTable2, quality)

        local str = ""
        local seal = getDataManager():getSoldierData():getSealById(self.ltNo1)
        if seal == 0 then 
            local seal = getDataManager():getSoldierData():getSealById(self.ltNo2)
            print("/////////////////////"..seal)
            local m1,m2,isA1,isA2,isNum1,isNum2 = self.c_SoldierTemplate:getAllMai(seal)
            if isA1 == true then
                str = str..m1..":已激活所有穴位\n"
            else
                str = str..m1..":已激活"..isNum1.."个穴位\n"
            end

            if isA2 == true then
                str = str..m2..":已激活所有穴位"
            else
                str = str..m2..":已激活"..isNum2.."个穴位"
            end
        else
            local m1,m2,isA1,isA2,isNum1,isNum2 = self.c_SoldierTemplate:getAllMai(seal)
            if isA1 == true then
                str = str..m1..":可激活所有穴位\n"
            else
                str = str..m1..":可激活"..isNum1.."个穴位\n"
            end

            if isA2 == true then
                str = str..m2..":可激活所有穴位"
            else
                str = str..m2..":可激活"..isNum2.."个穴位"
            end
        end
        

        self.sodDesRight:setString(str)
        self.sodDesRight:setColor(ui.COLOR_GREEN)

    end

    if self.menuIdx == 2 and self.paiIsHave[2].inherit == true then 
        -- 材料卡牌的信息
        local _icon = self.equipTemp:getEquipResIcon(self.equNo2)  -- 资源名
        local _quality = self.equipTemp:getQuality(self.equNo2)    -- 装备品质
        local _reshd = self.equipTemp:getEquipResHD(self.equNo2)
        self.iconSpriteInheritZB:setTexture("res/equipment/".._reshd)
        local _name = self.equipTemp:getEquipName(self.equNo2)
        self.inheritZBName:setString(_name)
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
        self.inheritZBName:setColor(color)
        local colorImg = self:getColorImgByQuality(_quality)
        game.setSpriteFrame(self.zbInheritNameBg, colorImg)
        self.label_lv2:setString("Lv."..self.equLv2)

        local _equipPrefix = self.equ2.prefix
        local _nameImage = "ui_equip_kind_6"
        if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
        if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
        if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
        if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
        if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
        if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
        local _equipPrefixRes = _nameImage .. ".png"
        game.setSpriteFrame(self.equipPrefixRight, "#".._equipPrefixRes)

        ---------------------------------------------------
        local equipData = self.equ2
        local _descrip = ""
        local descrip = ""
        table.print(equipData.main_attr)
        -- local main_attr = equipData.main_attr

        -- 传承前主属性
        local main_attr = self.c_Calculation:EquMainAttr(equipData)
        local nowValue = 0
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then 
            print("没有主属性")
        else
            descrip = _descrip .. main_attr.AttrName.. "   +" .. main_attr.Value
            nowValue = main_attr.Value
        end
         -- 传承后主属性
        local _level = equipData.strengthen_lv
        equipData.strengthen_lv = self.equ1.strengthen_lv
        local main_attr = self.c_Calculation:EquMainAttr(equipData)
        equipData.strengthen_lv = _level
        local _nowValue = 0
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then 
            print("没有主属性")
        else
            _descrip = _descrip .. main_attr.AttrName.. "   +" .. main_attr.Value
            _nowValue = main_attr.Value
        end

        local isAdd = true
        if self.equ1.strengthen_lv > equipData.strengthen_lv then          -- 传承前
            self.zhuL2:setString(_descrip)
            self.addLabel:setString(tostring(_nowValue - nowValue))
            self.addLayer:setVisible(true)
        else                                                               -- 传承后
            self.zhuL2:setString(descrip)
            isAdd = false
            self.addLayer:setVisible(false)
        end
        
        -- 次属性
        self.zbLayerRight:removeAllChildren()
        local rgTableView = RgTableView.new()
        rgTableView:setViewSize(self.zbLayerRight:getContentSize())
        rgTableView:initTableView(equipData, 2, isAdd, self.equLv1)
        self.zbLayerRight:addChild(rgTableView)
    end

    if self.menuIdx == 3 and self.paiIsHave[3].inherit == true then

        -- local wsItem = self.ws1
        print("========================================")
        print(self.ws2.icon)
        local _icon = self.c_ResourceTemplate:getResourceById(self.ws2.icon)
        local _description = self.languageTemp:getLanguageById(self.ws2.discription)
        local _name = self.languageTemp:getLanguageById(self.ws2.name)

       
        self.inheritWSName:setString(_name)

        self.wsDesL2:setString(_description)
        game.setSpriteFrame(self.wsSpriteinheritWS, "res/icon/ws/".._icon)
        self.wslabel_lv2:setString("Lv."..self.lineupData:getWSLevel(self.ws2.id)) 
    end
end

function PVInheritView:updateData()

    local heroInheritPrice = getTemplateManager():getBaseTemplate():getheroInheritPrice()
    local equInheritPrice = getTemplateManager():getBaseTemplate():getequInheritPrice()
    local warriorsInheritPrice = getTemplateManager():getBaseTemplate():getwarriorsInheritPrice()
    if self.menuIdx == 1 then self.priceNum:setString(heroInheritPrice) self.inheritPrice = heroInheritPrice end
    if self.menuIdx == 2 then self.priceNum:setString(equInheritPrice) self.inheritPrice = equInheritPrice end
    if self.menuIdx == 3 then self.priceNum:setString(warriorsInheritPrice) self.inheritPrice = warriorsInheritPrice end
    -- self:initCaiLiaoCard(  )
    -- self:initInheritCard(  )
end

function PVInheritView:initTouchListener()
    print("-------PVInheritView:initTouchListener------")

    local function onCloseClick()
        print("退出")
        local equ = {}
        getDataManager():getInheritData():setlt1(equ)
        getDataManager():getInheritData():setlt2(equ)
        getDataManager():getInheritData():setequId1(equ)
        getDataManager():getInheritData():setequId2(equ)
        getDataManager():getInheritData():setws1(equ)
        getDataManager():getInheritData():setws2(equ)

        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    local function liantiMenuClick()
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(1)
    end

    local function equMenuClick()
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(2)
    end

    local function wshMenuClick()
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(3)
    end

    -- 完美传承
    local function perfectInheritOnClick()
        print("----------- 点击完美传承 ----------------" .. self.menuIdx)
        if self:isCanPerfectInherit() == false then return end 

        if self.inheritPrice > self.c_CommonData:getGold() then
            getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
            return
        end

        if self.menuIdx == 1 then 
            if self.ltNum1 < 1 or self.ltNum1 <= self.ltNum2 then
                -- self:toastShow("请重新选择卡牌")
                getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.1"))
                return
            end
            local data = { origin = self.ltNo1, target = self.ltNo2}
            table.print(data)
            getNetManager():getInheritNet():sendGetInheritRefineRequest(data) 
        end 
        
        if self.menuIdx == 2 then 
            if self.equLv1 <=1 or self.equLv1 <= self.equLv2 then
                -- self:toastShow("请重新选择装备")
                getOtherModule():showAlertDialog(nil,  Localize.query("PVInheritView.2"))
                return
            end
            local data = { origin = self.equ1.id, target = self.equ2.id}
            table.print(data)
            getNetManager():getInheritNet():sendGetInheritEquipmentRequest(data) 
        end  
        if self.menuIdx == 3 then 
            print("     -------- 无双传承 --------     ")
            -- print(self.lineupData:getWSLevel(self.ws1.id) .." =========== ".. self.lineupData:getWSLevel(self.ws2.id))
            if self.lineupData:getWSLevel(self.ws1.id) <=1 or self.lineupData:getWSLevel(self.ws1.id) <= self.lineupData:getWSLevel(self.ws2.id) then
                -- self:toastShow("请重新选择无双技能")
                getOtherModule():showAlertDialog(nil,  Localize.query("PVInheritView.3"))
                return
            end
            local data = { origin = self.wsNo1, target = self.wsNo2}
            table.print(data)
            getNetManager():getInheritNet():sendGetInheritUnparaRequest(data) 
        end

        
    end
    
    -- 材料卡牌
    local function cailiaoClic()

        -- print("点击材料卡牌")

        if self.cailiaoIsHave == false then
            -- print("没有材料卡牌，添加")  
            if self.menuIdx == 1 then getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritLTList", 0) end
            if self.menuIdx == 2 then getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritZBList", 0, 0) end  -- 等级 品质
            if self.menuIdx == 3 then getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritWSList", 0) end
            return
        else
            -- print("有材料卡牌，查看")
            if self.menuIdx == 1 then getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", self.lt1.hero_no, 0, 0) end
            if self.menuIdx == 2 then getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", self.equ1, 1, nil, 0, 0) end  -- 等级 品质
            if self.menuIdx == 3 then getModule(MODULE_NAME_LINEUP):showUIViewAndInTop("PVWSDetailPage", self.ws1.id, 0) end
            -- if self.menuIdx == 3 then getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritWSList", self.lineupData:getWSLevel(self.ws1.id)) end
        end
        
    end
    
    -- 传承卡牌
    local function inheritClick()
        if self.cailiaoIsHave == false then  
            if self.menuIdx == 1 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.4")) end
            if self.menuIdx == 2 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.5")) end  -- 等级 品质
            if self.menuIdx == 3 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.6")) end
            return
        end
        if self.inheritIsHave == false then
            -- print("没有传承卡牌，添加")  
            if self.menuIdx == 1 then getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritLTList", self.ltNum1) end
            if self.menuIdx == 2 then getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritZBList", self.equLv1, self.equipTemp:getQuality(self.equNo1)) end  -- 等级 品质
            if self.menuIdx == 3 then getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritWSList", self.lineupData:getWSLevel(self.ws1.id)) end
            return
        else
            -- print("有传承卡牌，查看")                                            --AndInTop
            -- local equipPB = self.equ1
            if self.menuIdx == 1 then getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", self.lt2.hero_no, 0, self.ltNum1) end
            if self.menuIdx == 2 then getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", self.equ2, 1, nil, self.equLv1, self.equipTemp:getQuality(self.equNo1)) end
            if self.menuIdx == 3 then getModule(MODULE_NAME_LINEUP):showUIViewAndInTop("PVWSDetailPage", self.ws2.id, self.lineupData:getWSLevel(self.ws1.id)) end
        end
    
    end

    self.UIInheritView["UIInheritView"] = {}
    self.UIInheritView["UIInheritView"]["onCloseClick"] = onCloseClick
    self.UIInheritView["UIInheritView"]["liantiMenuClick"] = liantiMenuClick   --菜单一
    self.UIInheritView["UIInheritView"]["equMenuClick"] = equMenuClick         --菜单二
    self.UIInheritView["UIInheritView"]["wshMenuClick"] = wshMenuClick         --菜单三
    self.UIInheritView["UIInheritView"]["perfectInheritOnClick"] = perfectInheritOnClick  --完美传承
    self.UIInheritView["UIInheritView"]["cailiaoClic"] = cailiaoClic           --材料卡牌
    self.UIInheritView["UIInheritView"]["inheritClick"] = inheritClick         --传承卡牌
    
end

function PVInheritView:isCanPerfectInherit( )

    if self.cailiaoIsHave == false then 
        if self.menuIdx == 1 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.4")) end
        if self.menuIdx == 2 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.5")) end  -- 等级 品质
        if self.menuIdx == 3 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.6")) end
        return false
    else
        if self.inheritIsHave == false then 
            if self.menuIdx == 1 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.7")) end
            if self.menuIdx == 2 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.8")) end  -- 等级 品质
            if self.menuIdx == 3 then getOtherModule():showAlertDialog(nil, Localize.query("PVInheritView.9")) end
            return false
        end
    end
    return true
end


function PVInheritView:updateMenuIndex( index )
    -- print(">>>>>"..index)

    self.texiaoSp9:removeAllChildren()
    self.animationNode:removeAllChildren()
    -- self.texiaoSp9:setVisible(false)

    self.menuIdx = index
    -- index = index - 1
    for k,v in pairs(self.menuTable) do
        if k == index then
            v:setEnabled(false)
        else
            v:setEnabled(true)
        end
    end
    local ws = {}

    getDataManager():getInheritData():setlt1(ws)
    getDataManager():getInheritData():setlt2(ws)

    getDataManager():getInheritData():setws1(ws)
    getDataManager():getInheritData():setws2(ws)

    getDataManager():getInheritData():setequId1(ws)
    getDataManager():getInheritData():setequId2(ws)

    
    -- 
    self:updateData2()
    self:changeView()
    -- self:initCaiLiaoCard()
end

-- 炼体传承返回
function PVInheritView:inheritLT()

    -- print("----------- 炼体传承返回 ------------")

    self.jieR1:setString(self.ltStep1..Localize.query("PVInheritView.10"))
    self.sodDesRight:setString(self.ltNum1)
    self.jieL1:setString("0"..Localize.query("PVInheritView.10"))
    self.sodDesLeft:setString(0)

    getDataManager():getSoldierData():setSealById(self.ltNo2, self.lt1.refine)
    getDataManager():getSoldierData():setSealById(self.ltNo1, 0)

    getDataManager():getInheritData():setlt1(getDataManager():getSoldierData():getSoldierDataById(self.ltNo1))
    table.print(getDataManager():getSoldierData():getSoldierDataById(self.ltNo1))
    getDataManager():getInheritData():setlt2(getDataManager():getSoldierData():getSoldierDataById(self.ltNo2))
    table.print(getDataManager():getSoldierData():getSoldierDataById(self.ltNo2))

    self:funInherit() 
    self:updateData2()
    self.c_CommonData.updateCombatPower()
end



-- 装备传承返回
function PVInheritView:inheritEquipment()
    -- print("----------- 装备传承返回 ------------")
    -- self:funInherit()
   
    self.label_lv1:setString("Lv.1")
    self.label_lv2:setString(self.equLv1)

    getDataManager():getEquipmentData():setStrengLv(self.equ1.id, 1)
    getDataManager():getEquipmentData():setStrengLv(self.equ2.id, self.equLv1)
    getDataManager():getEquipmentData():changeEnhance(self.equ1.id, {})
    getDataManager():getEquipmentData():changeEnhance(self.equ2.id, self.equ1.data)

    getDataManager():getInheritData():setequId1(getDataManager():getEquipmentData():getEqu(self.equ1.id))
    getDataManager():getInheritData():setequId2(getDataManager():getEquipmentData():getEqu(self.equ2.id))

    self:funInherit()

    self:updateData2()
    self.c_CommonData.updateCombatPower()
end

-- 无双传承返回
function PVInheritView:inheritWS()
    print("----------- 无双传承返回 ------------")
    
    getDataManager():getLineupData():setWSLevel(self.ws2.id, self.lineupData:getWSLevel(self.ws1.id))
    getDataManager():getLineupData():setWSLevel(self.ws1.id, 1)
    local wslocal1 = getTemplateManager():getInstanceTemplate():getWSInfoById(self.ws1.id)
    table.print(wslocal1)
    local wslocal2 = getTemplateManager():getInstanceTemplate():getWSInfoById(self.ws2.id)
    table.print(wslocal2)

   
    getDataManager():getInheritData():setws1(wslocal1)
    getDataManager():getInheritData():setws2(wslocal2)

    self:funInherit()

    self:updateData2()
end



function PVInheritView:initRegisterNetCallBack()

    function onGetInheritResponseCallBack(_id)

        --炼体
        if _id == NET_ID_INHERIT_REFINE then 
            self:inheritLT()  
        end 

        --装备
        if _id == NET_ID_INHERIT_EQUIPMENT then 
            print(" ------  装备 ----------")
            self:inheritEquipment()  
        end  
        --无双
        if _id == NET_ID_INHERIT_UNPARA then 
            print(" ------  wushuang ----------")
            self:inheritWS()  
        end

    end

    self:registerMsg(NET_ID_INHERIT_REFINE, onGetInheritResponseCallBack)
    self:registerMsg(NET_ID_INHERIT_EQUIPMENT, onGetInheritResponseCallBack)
    self:registerMsg(NET_ID_INHERIT_UNPARA, onGetInheritResponseCallBack)
end

function PVInheritView:funInherit()

    local function cardOneHide()
        -- getOtherModule():showToastView("agagagagagagagag")
    end
    local function cardTwoHide()
        -- getOtherModule():showToastView("hahhahahahahah")
    end

    local node1 = UI_chuancheng(cardOneHide, cardTwoHide) --
    
    self.animationNode:addChild(node1)
    cclog("self._meetPrice=%d", self.inheritPrice)
    self.c_CommonData:subGold(tonumber(self.inheritPrice))

    local goldNUm = self.c_CommonData:getGold()
    self.allGoldLabel:setString(goldNUm)
    
    -- self.menuA:setEnabled(false) 
    -- self.menuB:setEnabled(false)
    -- self.menuC:setEnabled(false)

    -- local function callback()
    --     self.menuA:setEnabled(true) 
    --     self.menuB:setEnabled(true)
    --     self.menuC:setEnabled(true)

    --     if self.menuIdx == 1 then self.menuA:setEnabled(false) end
    --     if self.menuIdx == 2 then self.menuA:setEnabled(false) end  -- 等级 品质
    --     if self.menuIdx == 3 then self.menuA:setEnabled(false) end
    -- end

    -- self.texiaoSp9:setVisible(true)
    -- local node2 = UI_chuanchengshanshuo()
    -- node2:setPosition(self.texiaoSp9:getContentSize().width / 2, self.texiaoSp9:getContentSize().height / 2)
    -- self.texiaoSp9:addChild(node2)
    
    -- self.nodeShow:removeFromParent(false)
    -- self.nodeShow:setPosition(cc.p(0, 0))
    -- self.clipNode:addChild(self.nodeShow, 3, 3)
end

function PVInheritView:onReloadView()
   
end

--
function PVInheritView:onAction(sp)
    local fadeInAction = cc.FadeIn:create(1)
    local fadeOutAction = cc.FadeOut:create(1)
    local sequence = cc.Sequence:create(fadeOutAction, fadeInAction)

    self.repeatAction = cc.RepeatForever:create(sequence)
    self.repeatAction:setTag(100)
    sp:runAction(self.repeatAction)
end


function PVInheritView:changeView()
    cclog("------------ changeView --------------")
    if self.menuIdx == 1 then
        cclog("---- 1 -----")

        self.cailiaoIsHave = self.paiIsHave[1].cailiao
        self.inheritIsHave = self.paiIsHave[1].inherit

        self.layer1:setVisible(true)
        self.layer2:setVisible(false)
        self.layer3:setVisible(false)

        if self.paiIsHave[1].cailiao == false then
            self.noLTLeft:setVisible(true)
            self:onAction(self.noLTLeft)
            self.noLTRight:setVisible(true)
            self.ltHaveLayerL:setVisible(false)
            self.ltHaveLayerR:setVisible(false)
        else
            self.noLTLeft:stopActionByTag(100)
            self.noLTLeft:setVisible(false)

            self.ltHaveLayerL:setVisible(true)
            if self.paiIsHave[1].inherit == true then
                self.noLTRight:setVisible(false)
                self.noLTRight:stopActionByTag(100)
                self.ltHaveLayerR:setVisible(true)
            else
                self:onAction(self.noLTRight)
                self.ltHaveLayerR:setVisible(false)
                self.noLTRight:setVisible(true)

                
            end
        end

        self.menuANormal:setVisible(false)
        self.menuASelect:setVisible(true)
        self.menuBNormal:setVisible(true)
        self.menuBSelect:setVisible(false)
        self.menuCNormal:setVisible(true)
        self.menuCSelect:setVisible(false)



    elseif self.menuIdx == 2 then
        cclog("---- 2 -----")
        self.noInheritNoOpen:setVisible(true)
        self.entryView:setVisible(false)

        self.cailiaoIsHave = self.paiIsHave[2].cailiao
        self.inheritIsHave = self.paiIsHave[2].inherit

        self.layer1:setVisible(false)
        self.layer2:setVisible(true)
        self.layer3:setVisible(false)

        if self.paiIsHave[2].cailiao == false then
            self.noZBLeft:setVisible(true)
            self:onAction(self.noZBLeft)
            self.noZBRight:setVisible(true)
            self.zbHaveLayerL:setVisible(false)
            self.zbHaveLayerR:setVisible(false)
        else
            self.noZBLeft:stopActionByTag(100)
            self.noZBLeft:setVisible(false)
            
            self.zbHaveLayerL:setVisible(true)
            if self.paiIsHave[2].inherit == true then
                self.noZBRight:setVisible(false)
                self.noZBRight:stopActionByTag(100)
                self.zbHaveLayerR:setVisible(true)
            else
                self:onAction(self.noZBRight)
                self.zbHaveLayerR:setVisible(false)
                self.noZBRight:setVisible(true)
            end
        end
        self.menuANormal:setVisible(true)
        self.menuASelect:setVisible(false)
        self.menuBNormal:setVisible(false)
        self.menuBSelect:setVisible(true)
        self.menuCNormal:setVisible(true)
        self.menuCSelect:setVisible(false)

    elseif self.menuIdx == 3 then
        cclog("---- 3 -----")
        self.noInheritNoOpen:setVisible(true)
        self.entryView:setVisible(false)

        self.cailiaoIsHave = self.paiIsHave[3].cailiao
        self.inheritIsHave = self.paiIsHave[3].inherit

        self.layer1:setVisible(false)
        self.layer2:setVisible(false)
        self.layer3:setVisible(true)

        if self.paiIsHave[3].cailiao == false then
            -- cclog("---- cailiao false -----")
            self.noWSLeft:setVisible(true)
            self:onAction(self.noWSLeft)
            self.noWSRight:setVisible(true)
            self.wsHaveLayerL:setVisible(false)
            self.wsHaveLayerR:setVisible(false)
        else
            -- cclog("---- cailiao true -----")
            -- print(">>111")
            self.noWSLeft:stopActionByTag(100)
            self.noWSLeft:setVisible(false)

            self.wsHaveLayerL:setVisible(true)
            if self.paiIsHave[3].inherit == true then
                -- cclog("---- inherit true -----")
                -- print(">>"..self.paiIsHave[3].inherit)
                self.noWSRight:setVisible(false)
                self.noWSRight:stopActionByTag(100)
                self.wsHaveLayerR:setVisible(true)
            else
                -- cclog("---- inherit false -----")
                self:onAction(self.noWSRight)
                self.wsHaveLayerR:setVisible(false)
                self.noWSRight:setVisible(true)
            end
        end

        self.menuANormal:setVisible(true)
        self.menuASelect:setVisible(false)
        self.menuBNormal:setVisible(true)
        self.menuBSelect:setVisible(false)
        self.menuCNormal:setVisible(false)
        self.menuCSelect:setVisible(true)
    end
end

return PVInheritView
