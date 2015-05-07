--阵容
local PVLineUp = class("PVLineUp", BaseUIView)


TYPE_SELECT_HERO = 1    --选择英雄类型
TYPE_SELECT_CHEER_HERO = 2  --选择助威英雄类型
TYPE_SELECT_EQUIP = 3  --选择装备

FROM_TYPE_MINE = 1
FROM_TYPE_MINE_CHANGE_LINEUP = 3
FROM_TYPE_INHERITANCE = 2


FROM_TYPE_WS = 11 --点击无双
FROM_TYPE_LIANTI = 19 --直接进入点击提升战力，点击炼体

cheercolor1 = cc.c4b(150, 233, 85, 255)
cheercolor2 = cc.c4b(203, 204, 201, 255)
ONELINE_MAX_NUM = 31

function PVLineUp:ctor(id)
    PVLineUp.super.ctor(self, id)

    self.moveType = 0        --   0 点击    1 向左移     2 向右移

    self.lastSelectHeroIndex = 1   --上次选择的英雄的index
    self.lastSelectCheerHeroIndex = 1   --上次选择的助威英雄的index
    self.lastSelectType = -1
    self.lastSelectEquipSeat = -1  --上一次选择的替换装备座位号

    self.cheerSelectIndex = 1 --选择助威的index,默认第一次选择第一个英雄

    self.maxOpenIndex = nil --最大开启的座位号
    self.TYPE_MOVE_NONE = 0  --滑动类型为无
    self.TYPE_MOVE_LEFT = 1  --滑动类型为向左
    self.TYPE_MOVE_RIGHT = 2  --滑动类型为向右

    self.TYPE_SOLDIER_VIEW = 1
    self.TYPE_CHEER_VIEW = 2
    self.TYPE_WS_VIEW = 3
    self.selectIndex = nil
    self.curIndex = 1
    self.str_type = Localize.query("lineupTypeShow.1")

    self.TYPE_TYPE = self.TYPE_SOLDIER_VIEW
    self:regeisterNetCallBack()

    self.c_CommonData = getDataManager():getCommonData()
    self.c_EquipmentData = getDataManager():getEquipmentData()
    self.c_runeData = getDataManager():getRuneData()
    self.lineupData = getDataManager():getLineupData()
    self.sodierData = getDataManager():getSoldierData()
    self.secretPlaceData = getDataManager():getMineData()
    self.c_LineUpNet = getNetManager():getLineUpNet()
    self.c_runeNet = getNetManager():getRuneNet()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_SoldierCalculation = getCalculationManager():getSoldierCalculation()
    self.c_LineUpCalculation =  getCalculationManager():getLineUpCalculation()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.stageData = getDataManager():getStageData()


    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_equipTemp = getTemplateManager():getEquipTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_CommonData = getDataManager():getCommonData()
    self.c_EquipmentData = getDataManager():getEquipmentData()
    self.c_InstanceTemplate = getTemplateManager():getInstanceTemplate()

    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_ChipTemplate = getTemplateManager():getChipTemplate()
    self.c_LegionNet = getNetManager():getLegionNet()

    self.starTable = {}
    self.selectSoldierData = {}
    self.cheerSoldierData = {}
    self.linkData = {} --自己建立的羁绊数据
    self.totleLinkDataItem = {} --英雄所有的羁绊信息
    self.linkDataItem = {} --当前所选英雄的羁绊数据
    self.size = 0

    self.cheerDiscriptions = {}
    self.iconMenuTable = {} --英雄头像选中效果
    self.cheerIconMenuTable = {} --助威英雄头像选中效果
    -- self.c_LineUpNet:sendGetLineUpMsg()
    -- getNetManager():getSoldierNet():sendGetSoldierMsg()
    self.isClickLianTi = false

end

function PVLineUp:enterTransitionFinish()
    if self.isClickLianTi then --直接点击炼化
        self.UILineUpView["UILineUpView"]["onbtnSoldierAddPower"](nil, 4)
    end
end

function PVLineUp:onMVCEnter()
    self:initBaseUI()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")

    self.fromType = self.funcTable[1]  -- nil 阵容点击进来   1， 符文秘境继续攻打  2，传承
    self.minetype = self.funcTable[2]

    print("-----self.fromType----")
    print(self.fromType)

    self.UILineUpView = {}

    self:initTouchListener()

    self:loadCCBI("lineup/ui_lineup.ccbi", self.UILineUpView)

    self:initView()

    self:initHeroLayerTouch()
    -- self:initLinkLayerTouch()
    self:changeView()

    self:initData()

    -- self:updateData()



    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end

    -- self:registerScriptHandler(onNodeEvent)

end

function PVLineUp:onExit()
    cclog("-------onExit----")
    self.c_Calculation:resetLineUpData()
    -- self.sodierData:clearHeroImagePlist()
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")

    self.lineupData = nil
    self.sodierData = nil
    self.c_LineUpNet = nil
    self.c_SoldierTemplate = nil
    self.c_SoldierCalculation = nil
    self.c_LineUpCalculation =  nil
    self.c_LanguageTemplate = nil
    self.c_equipTemp = nil
    self.c_ResourceTemplate = nil
    self.c_CommonData = nil
    self.c_EquipmentData = nil

    self.starTable = nil
    self.selectSoldierData = nil
    self.cheerSoldierData = nil
    self.linkData = nil --自己建立的羁绊数据
    self.totleLinkDataItem = nil --英雄所有的羁绊信息
    self.linkDataItem = nil --当前所选英雄的羁绊数据
    self.cheerDiscriptions = nil
    self.c_Calculation = nil
    self.c_LegionNet = nil
    self.c_ChipTemplate = nil
    self.c_LineUpCalculation = nil

end

function PVLineUp:initData()
    self.selectSoldierData = self.lineupData:getSelectSoldier()
    self.cheerSoldierData = self.lineupData:getCheerSoldier()
    self.baseTemplate = getTemplateManager():getBaseTemplate()

    self:getMaxopenNum()
    self:updateUnOpenView()
    self:showEmptyView()
    self:clearAttribute()

    -- self.addSoldierNode
    -- self.addSoldierNode

    self.soldierXinxiNode:setVisible(true)
    self.starAndNameNode:setVisible(true)
    self.addSoldierNode:setVisible(false)
    print("-----self.fromType-----")
    print(self.fromType)

    -- 如果新手引导突破步骤走到这里需要把要突破的武将置顶
    local gId = getNewGManager():getCurrentGid()
    if gId == GuideId.G_GUIDE_50022 or gId == GuideId.G_GUIDE_40026 or gId == GuideId.G_GUIDE_60012  then
        for i=1,6 do
            if self:getIsSeated(i) then
                self.lastSelectHeroIndex = i
                self:onSelectAddClick(self.lastSelectHeroIndex)
                break
            end
        end
    end

    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then  -- 符文秘境进来的
        self.lastSelectHeroIndex = 1
        self.secretNoNode:setVisible(false)
        local _posX, _posY = self.soldierNode:getPosition()
        local _height = 60
        self.soldierNode:setPosition(_posX, _posY+_height)

        _posX, _posY = self.SeatNode:getPosition()
        self.SeatNode:setPosition(_posX, _posY+_height)
        self.secretNoMenu:setVisible(false)
        self.linkInfoMenuItem:setEnabled(true)
        self.zhushouMenuitem:setEnabled(true)
        if self.minetype == 3 then  --玩家自己
            self.zsMenuItem:setVisible(true)
        else                        --其他玩家
            self:closeMenuTouch()
        end
        self:updateHeroIcon()
        self:updateOtherView()
        self:updateSoldierEquipment() --更新显示装备
        self:updateSelectSoldierLinkView(self.lastSelectHeroIndex)  --更新武将羁绊

    elseif self.fromType == FROM_TYPE_INHERITANCE then

    else
        self.c_Calculation:resetLineUpData()    --重置阵容信息，防止其他模块阵容出错时影响自身阵容信息
        -- self:updateData()
        self.linkInfoMenuItem:setEnabled(true)
        self.zhushouMenuitem:setEnabled(true)
        self:updateHeroIcon()
        self:updateOtherView()
        self:updateSoldierEquipment() --更新显示装备
        self:updateSelectSoldierLinkView(self.lastSelectHeroIndex)  --更新武将羁绊
        --直接进入阵容界面，并点击提升战力，再点击炼化
        if self.fromType == FROM_TYPE_LIANTI then --直接点击炼体
            self.isClickLianTi = true
            self.fromType = nil
        end
    end
end

function PVLineUp:getMaxopenNum()
    local tempIndex = 0
    local  _selectSoldierData = self.lineupData:getSelectSoldier()
    for k, v in pairs(_selectSoldierData) do
       local activation = v.activation
       if activation == true then
            tempIndex = tempIndex + 1
       end
    end
    self.maxOpenIndex = tempIndex
end

function PVLineUp:updateData()

    self.soldierXinxiNode:setVisible(true)
    self.starAndNameNode:setVisible(true)
    self.addSoldierNode:setVisible(false)

    self.selectSoldierData = self.lineupData:getSelectSoldier()
    self.cheerSoldierData = self.lineupData:getCheerSoldier()

    -- self.baseTemplate = getTemplateManager():getBaseTemplate()

    self:updateHeroIcon()
    self:updateUnOpenView()

    self:updateOtherView()
    self:updateSoldierEquipment() --更新显示装备
    self:updateSelectSoldierLinkView(self.lastSelectHeroIndex)  --更新武将羁绊
    if self.type == 2 then
        self:updateCheerLinkBySeat(self.cheerSelectIndex)       --更新助威羁绊
        self:updateCheerData()
    end
    self.c_CommonData.updateCombatPower()
end

function PVLineUp:onSelectAddClick(selectSeat)
    print("----selectSeat--",selectSeat)

    self.soldierXinxiNode:setVisible(true)
    self.addSoldierNode:setVisible(false)
    self.starAndNameNode:setVisible(true)

    getAudioManager():playEffectButton2()
    self:updateHeroIconLight(selectSeat)
    if self.TYPE_TYPE == self.TYPE_SOLDIER_VIEW then --武将页面

        self.lastSelectHeroIndex = selectSeat

        local isInSeated = false
        if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
           -- self.secretPlaceData:setMineGuardRequestLineupFromGuardLineup()
           isInSeated = self.secretPlaceData:getIsSeated(selectSeat)
           print("--------isInSeated---------",isInSeated,selectSeat)
        else
            isInSeated = self:getIsSeated(selectSeat)
        end

        if isInSeated then
            self.cheerSelectIndex = selectSeat
            self.linkInfoMenuItem:setEnabled(true)
            self.zhushouMenuitem:setEnabled(true)
            self:updateOtherView()
            self:updateSoldierEquipment() --更新显示装备
            self:updateSelectSoldierLinkView(selectSeat) --更新武将页面羁绊信息
            self:updateCheerLinkBySeat(selectSeat)
        else
            -- self.curIndex = self.curIndex - 1
            self.linkInfoMenuItem:setEnabled(false)
            self.zhushouMenuitem:setEnabled(false)
            self.jbSprite:removeAllChildren()
            self.sxSprite:removeAllChildren()
            -- self.lastSelectHeroIndex = 1
            self:updateOtherView()
            self:showEmptyView()
            self:clearAttribute()
            self:updateSoldierEquipment() --更新显示装备
        end

    elseif self.TYPE_TYPE == self.TYPE_CHEER_VIEW then  -- 助威页面
        -- self.cheerSelectIndex = selectSeat
        local isOpen = self:getIsSeated(selectSeat)
        if isOpen then
            self.cheerSelectIndex = selectSeat
            self:updateCheerLinkBySeat(selectSeat)
            self:updateCheerData()
            self:updateOtherView()
        else
            -- self.cheerSelectIndex = 1
            self:clearCheerInfo()
            self:updateCheerLinkBySeat(selectSeat)
            self:updateCheerData()
            self:updateOtherView()
        end
    end
    --更新属性
    if self.scrollView then
        self:createAttrScroll()
        self:createAttributeScollView()
    end
end

function PVLineUp:clearCheerInfo()
    self.cheerHeroName:setString("没有配置此将领")
    self.tableView:setVisible(false)

end

--注册网络回调
function PVLineUp:regeisterNetCallBack()

    local function changeSoldierDataCallBack(id, data)
        self:updateData()
    end

    local function changeEquipmentCallBack(id, data)
        print("---changeMultiEquipmentCallBack11111---")
        self:updateData()
    end

    local function changeMultiEquipmentCallBack(id, data)
        print("---changeMultiEquipmentCallBack---")
        self:updateData()

        groupCallBack(GuideGroupKey.BTN_EQUIPMENT)

    end

    local function onStrengthEquipmentCallBack(id, data)
        self:updateData()
    end

    self:registerMsg(NET_ID_CHANGE_HERO, changeSoldierDataCallBack)
    self:registerMsg(NET_ID_CHANGE_EQUIPMENT, changeEquipmentCallBack)
    self:registerMsg(NET_ID_CHANGE_MULTI_EQUIPMENT, changeMultiEquipmentCallBack)
    self:registerMsg(NET_STRENGTH_EQUIP_LINEUP, onStrengthEquipmentCallBack)
end

--当选择的座位号上没有英雄时
function PVLineUp:showEmptyView()
    --英雄大图
    self.heroNode:removeAllChildren()
    --local imageNode = cc.Sprite:create("icon/ui_lu_user.png")
    --local imageNode = cc.Sprite:create("icon/ui_lu_user.png")
    --self.:addChild(imageNode)

 -- self.imgHeroBg:setVisible(true)
    self.qulityA:setVisible(false)          --武将身上的装备
    self.qulityB:setVisible(false)
    self.qulityC:setVisible(false)
    self.qulityD:setVisible(false)
    self.qulityE:setVisible(false)
    self.qulityF:setVisible(false)

    self.breakLvBg:setVisible(false)
    updateStarLV(self.starTable, 0) --更新星级

    self.heroNameLabel:setString("")   --武将名称
    --self.menuLianti:setVisible(false)
    --self.menuFuwen:setVisible(false)
    self.menuAddPower:setVisible(false)
    self.btnAllEqu:setVisible(false)

    self.heroTypeBMLabel:setString("")  --英雄职业
    self.typeSprite:setVisible(false)

    self.chekLinkLayer:setVisible(false)
    --self.tableView:setTouchEnabled(false)
    self.linkInfoMenuItem:setEnabled(false)
    self.zhushouMenuitem:setEnabled(false)

    self.soldierXinxiNode:setVisible(false)
    self.addSoldierNode:setVisible(true)
    self.starAndNameNode:setVisible(false)

end

function PVLineUp:initView()
    self:showAttributeView()

    self.baseLayer = self.UILineUpView["UILineUpView"]["baseLayer"]
    self.listLayer = self.UILineUpView["UILineUpView"]["listLayer"]
    self.soldierBtn = self.UILineUpView["UILineUpView"]["soldierBtn"]
    self.cheerBtn = self.UILineUpView["UILineUpView"]["cheerBtn"]
    self.wsBtn = self.UILineUpView["UILineUpView"]["wsBtn"]

    self.addSoldierNode = self.UILineUpView["UILineUpView"]["addSoldierNode"]
    self.soldierXinxiNode = self.UILineUpView["UILineUpView"]["soldierXinxiNode"]
    self.starAndNameNode = self.UILineUpView["UILineUpView"]["starAndNameNode"]
    self.soldierXinxiNode:setVisible(true)
    self.addSoldierNode:setVisible(false)
    self.starAndNameNode:setVisible(true)

    self.secretNoNode  = self.UILineUpView["UILineUpView"]["secretNoNode"]
    self.zhushouMenuitem = self.UILineUpView["UILineUpView"]["zhushouMenuitem"]

    self.cheerBtn:setAllowScale(false)
    self.soldierBtn:setAllowScale(false)
    self.wsBtn:setAllowScale(false)

    self.levelLabelA = self.UILineUpView["UILineUpView"]["levelLabelA"]
    self.levelLabelB = self.UILineUpView["UILineUpView"]["levelLabelB"]
    self.levelLabelC = self.UILineUpView["UILineUpView"]["levelLabelC"]
    self.levelLabelD = self.UILineUpView["UILineUpView"]["levelLabelD"]
    self.levelLabelE = self.UILineUpView["UILineUpView"]["levelLabelE"]
    self.levelLabelF = self.UILineUpView["UILineUpView"]["levelLabelF"]

    self.equipLabelA = self.UILineUpView["UILineUpView"]["equipLabelA"]
    self.equipLabelB = self.UILineUpView["UILineUpView"]["equipLabelB"]
    self.equipLabelC = self.UILineUpView["UILineUpView"]["equipLabelC"]
    self.equipLabelD = self.UILineUpView["UILineUpView"]["equipLabelD"]
    self.equipLabelE = self.UILineUpView["UILineUpView"]["equipLabelE"]
    self.equipLabelF = self.UILineUpView["UILineUpView"]["equipLabelF"]

    self.userSpriteA = self.UILineUpView["UILineUpView"]["userSpriteA"]
    self.userSpriteB = self.UILineUpView["UILineUpView"]["userSpriteB"]
    self.userSpriteC = self.UILineUpView["UILineUpView"]["userSpriteC"]
    self.userSpriteD = self.UILineUpView["UILineUpView"]["userSpriteD"]
    self.userSpriteE = self.UILineUpView["UILineUpView"]["userSpriteE"]
    self.userSpriteF = self.UILineUpView["UILineUpView"]["userSpriteF"]

    self.cheerHeroA = self.UILineUpView["UILineUpView"]["cheerHeroA"]
    self.cheerHeroB = self.UILineUpView["UILineUpView"]["cheerHeroB"]
    self.cheerHeroC = self.UILineUpView["UILineUpView"]["cheerHeroC"]
    self.cheerHeroD = self.UILineUpView["UILineUpView"]["cheerHeroD"]
    self.cheerHeroE = self.UILineUpView["UILineUpView"]["cheerHeroE"]
    self.cheerHeroF = self.UILineUpView["UILineUpView"]["cheerHeroF"]

    self.equipMenuA = self.UILineUpView["UILineUpView"]["equipMenuA"]
    self.equipMenuB = self.UILineUpView["UILineUpView"]["equipMenuB"]
    self.equipMenuC = self.UILineUpView["UILineUpView"]["equipMenuC"]
    self.equipMenuD = self.UILineUpView["UILineUpView"]["equipMenuD"]
    self.equipMenuE = self.UILineUpView["UILineUpView"]["equipMenuE"]
    self.equipMenuF = self.UILineUpView["UILineUpView"]["equipMenuF"]

    self.qulityA = self.UILineUpView["UILineUpView"]["qulityA"]  --人物身上的装备
    self.qulityB = self.UILineUpView["UILineUpView"]["qulityB"]
    self.qulityC = self.UILineUpView["UILineUpView"]["qulityC"]
    self.qulityD = self.UILineUpView["UILineUpView"]["qulityD"]
    self.qulityE = self.UILineUpView["UILineUpView"]["qulityE"]
    self.qulityF = self.UILineUpView["UILineUpView"]["qulityF"]

    self.heroSeatMenuTable = {}
    for i=1,6 do
        local str = "hero_seat"..tostring(i)
        table.insert( self.heroSeatMenuTable, self.UILineUpView["UILineUpView"][str] )
    end

    self.starSelect1 = self.UILineUpView["UILineUpView"]["starSelect1"]
    self.starSelect2 = self.UILineUpView["UILineUpView"]["starSelect2"]
    self.starSelect3 = self.UILineUpView["UILineUpView"]["starSelect3"]
    self.starSelect4 = self.UILineUpView["UILineUpView"]["starSelect4"]
    self.starSelect5 = self.UILineUpView["UILineUpView"]["starSelect5"]
    self.starSelect6 = self.UILineUpView["UILineUpView"]["starSelect6"]

    table.insert(self.starTable, self.starSelect1)
    table.insert(self.starTable, self.starSelect2)
    table.insert(self.starTable, self.starSelect3)
    table.insert(self.starTable, self.starSelect4)
    table.insert(self.starTable, self.starSelect5)
    table.insert(self.starTable, self.starSelect6)

    self.upOpenBgA = self.UILineUpView["UILineUpView"]["upOpenBgA"]  --未开启背景
    self.upOpenBgB = self.UILineUpView["UILineUpView"]["upOpenBgB"]  --未开启背景
    self.upOpenBgC = self.UILineUpView["UILineUpView"]["upOpenBgC"]  --未开启背景
    self.upOpenBgD = self.UILineUpView["UILineUpView"]["upOpenBgD"]  --未开启背景
    self.upOpenBgE = self.UILineUpView["UILineUpView"]["upOpenBgE"]  --未开启背景
    self.upOpenBgF = self.UILineUpView["UILineUpView"]["upOpenBgF"]  --未开启背景


    self.addA = self.UILineUpView["UILineUpView"]["addA"]
    self.addB = self.UILineUpView["UILineUpView"]["addB"]
    self.addC = self.UILineUpView["UILineUpView"]["addC"]
    self.addD = self.UILineUpView["UILineUpView"]["addD"]
    self.addE = self.UILineUpView["UILineUpView"]["addE"]
    self.addF = self.UILineUpView["UILineUpView"]["addF"]

    self.topAddA = self.UILineUpView["UILineUpView"]["topAddA"]
    self.topAddB = self.UILineUpView["UILineUpView"]["topAddB"]
    self.topAddC = self.UILineUpView["UILineUpView"]["topAddC"]
    self.topAddD = self.UILineUpView["UILineUpView"]["topAddD"]
    self.topAddE = self.UILineUpView["UILineUpView"]["topAddE"]
    self.topAddF = self.UILineUpView["UILineUpView"]["topAddF"]

    -- self.cheerAttr1 = self.UILineUpView["UILineUpView"]["cheerAttr1"]
    -- self.cheerAttr2 = self.UILineUpView["UILineUpView"]["cheerAttr2"]
    -- self.cheerAttr3 = self.UILineUpView["UILineUpView"]["cheerAttr3"]
    -- self.cheerAttr4 = self.UILineUpView["UILineUpView"]["cheerAttr4"]
    -- self.cheerAttr5 = self.UILineUpView["UILineUpView"]["cheerAttr5"]
    -- self.cheerAttr6 = self.UILineUpView["UILineUpView"]["cheerAttr6"]

    self.bottomAddA = self.UILineUpView["UILineUpView"]["bottomAddA"]
    self.bottomAddB = self.UILineUpView["UILineUpView"]["bottomAddB"]
    self.bottomAddC = self.UILineUpView["UILineUpView"]["bottomAddC"]
    self.bottomAddD = self.UILineUpView["UILineUpView"]["bottomAddD"]
    self.bottomAddE = self.UILineUpView["UILineUpView"]["bottomAddE"]
    self.bottomAddF = self.UILineUpView["UILineUpView"]["bottomAddF"]

    self.attribute1 = self.UILineUpView["UILineUpView"]["attribute1"]
    self.attribute2 = self.UILineUpView["UILineUpView"]["attribute2"]
    self.attribute3 = self.UILineUpView["UILineUpView"]["attribute3"]
    self.attribute4 = self.UILineUpView["UILineUpView"]["attribute4"]
    self.attribute5 = self.UILineUpView["UILineUpView"]["attribute5"]
    self.attribute5_2 = self.UILineUpView["UILineUpView"]["attribute5_2"]
    self.attribute6 = self.UILineUpView["UILineUpView"]["attribute6"]
    self.attribute6_2 = self.UILineUpView["UILineUpView"]["attribute6_2"]

    self.unOpenLabelNodeA = self.UILineUpView["UILineUpView"]["unOpenLabelNodeA"]  --文字的node
    self.unOpenLabelNodeB = self.UILineUpView["UILineUpView"]["unOpenLabelNodeB"]  --文字的node
    self.unOpenLabelNodeC = self.UILineUpView["UILineUpView"]["unOpenLabelNodeC"]  --文字的node
    self.unOpenLabelNodeD = self.UILineUpView["UILineUpView"]["unOpenLabelNodeD"]  --文字的node
    self.unOpenLabelNodeE = self.UILineUpView["UILineUpView"]["unOpenLabelNodeE"]  --文字的node
    self.unOpenLabelNodeF = self.UILineUpView["UILineUpView"]["unOpenLabelNodeF"]  --文字的node

    self.unOpenLevelLabelA = self.UILineUpView["UILineUpView"]["unOpenLevelLabelA"]  --未开启等级文字
    self.unOpenLevelLabelB = self.UILineUpView["UILineUpView"]["unOpenLevelLabelB"]  --未开启等级文字
    self.unOpenLevelLabelC = self.UILineUpView["UILineUpView"]["unOpenLevelLabelC"]  --未开启等级文字
    self.unOpenLevelLabelD = self.UILineUpView["UILineUpView"]["unOpenLevelLabelD"]  --未开启等级文字
    self.unOpenLevelLabelE = self.UILineUpView["UILineUpView"]["unOpenLevelLabelE"]  --未开启等级文字
    self.unOpenLevelLabelF = self.UILineUpView["UILineUpView"]["unOpenLevelLabelF"]  --未开启等级文字

    self.linkLabelA = self.UILineUpView["UILineUpView"]["linkLabelA"]
    self.linkLabelB = self.UILineUpView["UILineUpView"]["linkLabelB"]
    self.linkLabelC = self.UILineUpView["UILineUpView"]["linkLabelC"]
    self.linkLabelD = self.UILineUpView["UILineUpView"]["linkLabelD"]
    self.linkLabelE = self.UILineUpView["UILineUpView"]["linkLabelE"]
    self.linkLabelF = self.UILineUpView["UILineUpView"]["linkLabelF"]
    self.linkLabel = {}
    table.insert(self.linkLabel, self.linkLabelA)
    table.insert(self.linkLabel, self.linkLabelB)
    table.insert(self.linkLabel, self.linkLabelC)
    table.insert(self.linkLabel, self.linkLabelD)
    table.insert(self.linkLabel, self.linkLabelE)
    table.insert(self.linkLabel, self.linkLabelF)

    self.unOpenCheerBgA = self.UILineUpView["UILineUpView"]["unOpenCheerBgA"]  --助威未开启背景
    self.unOpenCheerBgB = self.UILineUpView["UILineUpView"]["unOpenCheerBgB"]  --助威未开启背景
    self.unOpenCheerBgC = self.UILineUpView["UILineUpView"]["unOpenCheerBgC"]  --助威未开启背景
    self.unOpenCheerBgD = self.UILineUpView["UILineUpView"]["unOpenCheerBgD"]  --助威未开启背景
    self.unOpenCheerBgE = self.UILineUpView["UILineUpView"]["unOpenCheerBgE"]  --助威未开启背景
    self.unOpenCheerBgF = self.UILineUpView["UILineUpView"]["unOpenCheerBgF"]  --助威未开启背景

    self.uOCheerLabelNodeA = self.UILineUpView["UILineUpView"]["uOCheerLabelNodeA"]
    self.uOCheerLabelNodeB = self.UILineUpView["UILineUpView"]["uOCheerLabelNodeB"]
    self.uOCheerLabelNodeC = self.UILineUpView["UILineUpView"]["uOCheerLabelNodeC"]
    self.uOCheerLabelNodeD = self.UILineUpView["UILineUpView"]["uOCheerLabelNodeD"]
    self.uOCheerLabelNodeE = self.UILineUpView["UILineUpView"]["uOCheerLabelNodeE"]
    self.uOCheerLabelNodeF = self.UILineUpView["UILineUpView"]["uOCheerLabelNodeF"]

    self.uOCheerLVLabelA = self.UILineUpView["UILineUpView"]["uOCheerLVLabelA"]  --助威开启等级
    self.uOCheerLVLabelB = self.UILineUpView["UILineUpView"]["uOCheerLVLabelB"]  --助威开启等级
    self.uOCheerLVLabelC = self.UILineUpView["UILineUpView"]["uOCheerLVLabelC"]  --助威开启等级
    self.uOCheerLVLabelD = self.UILineUpView["UILineUpView"]["uOCheerLVLabelD"]  --助威开启等级
    self.uOCheerLVLabelE = self.UILineUpView["UILineUpView"]["uOCheerLVLabelE"]  --助威开启等级
    self.uOCheerLVLabelF = self.UILineUpView["UILineUpView"]["uOCheerLVLabelF"]  --助威开启等级

    self.attrValueA = self.UILineUpView["UILineUpView"]["attrValueA"]  --助威加成
    self.attrValueB = self.UILineUpView["UILineUpView"]["attrValueB"]  --助威加成
    self.attrValueC = self.UILineUpView["UILineUpView"]["attrValueC"]  --助威加成
    self.attrValueD = self.UILineUpView["UILineUpView"]["attrValueD"]  --助威加成

    self.cheerHeroName = self.UILineUpView["UILineUpView"]["cheerHeroName"]

    self.imgHeroBg = self.UILineUpView["UILineUpView"]["playerSprite"] --英雄影子

    self.hpLabel = self.UILineUpView["UILineUpView"]["hpLabel"]
    self.powerLabel = self.UILineUpView["UILineUpView"]["powerLabel"]
    self.physicalDefLabel = self.UILineUpView["UILineUpView"]["physicalDefLabel"]
    self.magicDefLabel = self.UILineUpView["UILineUpView"]["magicDefLabel"]

    self.soldierNode = self.UILineUpView["UILineUpView"]["soldierNode"]
    self.cheerNode =  self.UILineUpView["UILineUpView"]["cheerNode"]

    self.heroNode = self.UILineUpView["UILineUpView"]["heroNode"]
    self.heroNode2 = self.UILineUpView["UILineUpView"]["heroNode2"]

    self.heroNameLabel = self.UILineUpView["UILineUpView"]["heroNameLabel"]  --武将名
    self.heroTypeBMLabel = self.UILineUpView["UILineUpView"]["heroTypeBMLabel"]  --武将职业
    self.typeSprite = self.UILineUpView["UILineUpView"]["typeSprite"]
    self.breakLvBg = self.UILineUpView["UILineUpView"]["breakLvBg"]

    self.secretNoMenu = self.UILineUpView["UILineUpView"]["secretNoMenu"]
    self.menuLianti = self.UILineUpView["UILineUpView"]["menu_lianti"]
    self.menuFuwen = self.UILineUpView["UILineUpView"]["menu_fuwen"]
    self.menuAddPower = self.UILineUpView["UILineUpView"]["btnSoldierAddPower"]
    self.btnAllEqu = self.UILineUpView["UILineUpView"]["btnAllEqu"]

    --状态标签
    self.soldierNormal = self.UILineUpView["UILineUpView"]["soldierNormal"]
    self.soldierSelect = self.UILineUpView["UILineUpView"]["soldierSelect"]
    self.upSelect = self.UILineUpView["UILineUpView"]["upSelect"]
    self.upNormal = self.UILineUpView["UILineUpView"]["upNormal"]
    self.wsNormal = self.UILineUpView["UILineUpView"]["ws_normal"]
    self.wsSelect = self.UILineUpView["UILineUpView"]["ws_select"]

    --阵容标签中的查看羁绊信息的相关变量
    self.chekLinkLayer = self.UILineUpView["UILineUpView"]["chekLinkLayer"]
    self.linkTouchLayer = self.UILineUpView["UILineUpView"]["linkTouchLayer"]
    self.linkDetailScroll = self.UILineUpView["UILineUpView"]["linkDetailScroll"]
    self.lineupHeroName = self.UILineUpView["UILineUpView"]["lineupHeroName"]
    self.lineupHeroType = self.UILineUpView["UILineUpView"]["lineupHeroType"]
    self.linkInfoMenuItem = self.UILineUpView["UILineUpView"]["linkInfoMenuItem"]
    self.linkDetailLayer = self.UILineUpView["UILineUpView"]["linkDetailLayer"]
    self.bgMenuItem = self.UILineUpView["UILineUpView"]["bgMenuItem"]

    self.animationManager = self.UILineUpView["UILineUpView"]["mAnimationManager"]

    self.SeatNode = self.UILineUpView["UILineUpView"]["hero_node"]
    self.jibanSelectedSp = self.UILineUpView["UILineUpView"]["jibanSelectedSp"]  -- 羁绊亮框

    --阵容属性信息相关
    self.sxSelectedSp = self.UILineUpView["UILineUpView"]["sxSelectedSp"]        -- 属性亮框

    --武将小头像亮框
    self.lightKuangA = self.UILineUpView["UILineUpView"]["lightKuangA"]
    self.lightKuangB = self.UILineUpView["UILineUpView"]["lightKuangB"]
    self.lightKuangC = self.UILineUpView["UILineUpView"]["lightKuangC"]
    self.lightKuangD = self.UILineUpView["UILineUpView"]["lightKuangD"]
    self.lightKuangE = self.UILineUpView["UILineUpView"]["lightKuangE"]
    self.lightKuangF = self.UILineUpView["UILineUpView"]["lightKuangF"]
    table.insert(self.iconMenuTable, self.lightKuangA)
    table.insert(self.iconMenuTable, self.lightKuangB)
    table.insert(self.iconMenuTable, self.lightKuangC)
    table.insert(self.iconMenuTable, self.lightKuangD)
    table.insert(self.iconMenuTable, self.lightKuangE)
    table.insert(self.iconMenuTable, self.lightKuangF)

    --助威小头像亮框
    self.lightKuang1 = self.UILineUpView["UILineUpView"]["lightKuang1"]
    self.lightKuang2 = self.UILineUpView["UILineUpView"]["lightKuang2"]
    self.lightKuang3 = self.UILineUpView["UILineUpView"]["lightKuang3"]
    self.lightKuang4 = self.UILineUpView["UILineUpView"]["lightKuang4"]
    self.lightKuang5 = self.UILineUpView["UILineUpView"]["lightKuang5"]
    self.lightKuang6 = self.UILineUpView["UILineUpView"]["lightKuang6"]
    table.insert(self.cheerIconMenuTable, self.lightKuang1)
    table.insert(self.cheerIconMenuTable, self.lightKuang2)
    table.insert(self.cheerIconMenuTable, self.lightKuang3)
    table.insert(self.cheerIconMenuTable, self.lightKuang4)
    table.insert(self.cheerIconMenuTable, self.lightKuang5)
    table.insert(self.cheerIconMenuTable, self.lightKuang6)

    -- 武将等级
    self.levelLayer1 = self.UILineUpView["UILineUpView"]["levelLayer1"]
    self.levelLayer2 = self.UILineUpView["UILineUpView"]["levelLayer2"]
    self.levelLayer3 = self.UILineUpView["UILineUpView"]["levelLayer3"]
    self.levelLayer4 = self.UILineUpView["UILineUpView"]["levelLayer4"]
    self.levelLayer5 = self.UILineUpView["UILineUpView"]["levelLayer5"]
    self.levelLayer6 = self.UILineUpView["UILineUpView"]["levelLayer6"]
    self.levelLabel1 = self.UILineUpView["UILineUpView"]["levelLabel1"]
    self.levelLabel2 = self.UILineUpView["UILineUpView"]["levelLabel2"]
    self.levelLabel3 = self.UILineUpView["UILineUpView"]["levelLabel3"]
    self.levelLabel4 = self.UILineUpView["UILineUpView"]["levelLabel4"]
    self.levelLabel5 = self.UILineUpView["UILineUpView"]["levelLabel5"]
    self.levelLabel6 = self.UILineUpView["UILineUpView"]["levelLabel6"]
    -- 装备等级
    self.zbLevelLayer1 = self.UILineUpView["UILineUpView"]["zbLevelLayer1"]
    self.zbLevelLayer2 = self.UILineUpView["UILineUpView"]["zbLevelLayer2"]
    self.zbLevelLayer3 = self.UILineUpView["UILineUpView"]["zbLevelLayer3"]
    self.zbLevelLayer4 = self.UILineUpView["UILineUpView"]["zbLevelLayer4"]
    self.zbLevelLayer5 = self.UILineUpView["UILineUpView"]["zbLevelLayer5"]
    self.zbLevelLayer6 = self.UILineUpView["UILineUpView"]["zbLevelLayer6"]
    self.zbLevelLabel1 = self.UILineUpView["UILineUpView"]["zbLevelLabel1"]
    self.zbLevelLabel2 = self.UILineUpView["UILineUpView"]["zbLevelLabel2"]
    self.zbLevelLabel3 = self.UILineUpView["UILineUpView"]["zbLevelLabel3"]
    self.zbLevelLabel4 = self.UILineUpView["UILineUpView"]["zbLevelLabel4"]
    self.zbLevelLabel5 = self.UILineUpView["UILineUpView"]["zbLevelLabel5"]
    self.zbLevelLabel6 = self.UILineUpView["UILineUpView"]["zbLevelLabel6"]
    -- 装备可升级提示
    self.arrowSprite1 = self.UILineUpView["UILineUpView"]["arrowSprite1"]
    self.arrowSprite2 = self.UILineUpView["UILineUpView"]["arrowSprite2"]
    self.arrowSprite3 = self.UILineUpView["UILineUpView"]["arrowSprite3"]
    self.arrowSprite4 = self.UILineUpView["UILineUpView"]["arrowSprite4"]
    self.arrowSprite5 = self.UILineUpView["UILineUpView"]["arrowSprite5"]
    self.arrowSprite6 = self.UILineUpView["UILineUpView"]["arrowSprite6"]

    -- 助威提示字
    self.bottomLabelAddA = self.UILineUpView["UILineUpView"]["bottomLabelAddA"]
    self.bottomLabelAddB = self.UILineUpView["UILineUpView"]["bottomLabelAddB"]
    self.bottomLabelAddC = self.UILineUpView["UILineUpView"]["bottomLabelAddC"]
    self.bottomLabelAddD = self.UILineUpView["UILineUpView"]["bottomLabelAddD"]
    self.bottomLabelAddE = self.UILineUpView["UILineUpView"]["bottomLabelAddE"]
    self.bottomLabelAddF = self.UILineUpView["UILineUpView"]["bottomLabelAddF"]


    self.levelNumLabelNode = self.UILineUpView["UILineUpView"]["levelNumLabelNode"]
    self.nunLabelWS = self.UILineUpView["UILineUpView"]["nunLabelWS"]



    --无双
    self.nodeWS = self.UILineUpView["UILineUpView"]["wu_node"]
    self.wslayer = self.UILineUpView["UILineUpView"]["ws_layer"]
    self.ws_bg = self.UILineUpView["UILineUpView"]["ws_bg"]

    --驻守
    self.zsMenuItem = self.UILineUpView["UILineUpView"]["secretYesMenu"]
    self.btnAllEquStrength = self.UILineUpView["UILineUpView"]["btnAllEquStrength"]
    

    -- 武将等级
    -- self.levelNumLabel = self.UILineUpView["UILineUpView"]["levelNumLabel"]
    self.levelNumLabel = self.UILineUpView["UILineUpView"]["levelNumLabelNode"]


    -- 关闭按钮
    self.menuCallBack = self.UILineUpView["UILineUpView"]["menuCallBack"]
    -- 羁绊 属性 sprite
    self.jbSprite = self.UILineUpView["UILineUpView"]["jbSprite"]
    self.sxSprite = self.UILineUpView["UILineUpView"]["sxSprite"]

    self.lineupSpriteType1 = self.UILineUpView["UILineUpView"]["lineupSpriteType1"]
    self.lineupSpriteType2 = self.UILineUpView["UILineUpView"]["lineupSpriteType2"]



    --init view
    -- self.linkInfoMenuItem:setAllowScale(false)
    self.bgMenuItem:setAllowScale(false)

    self.type = 1
    --self:createListView()

    -- ws
    --self:updateWSListData()
    -- self:createWSList()

    self:updateHeroIconLight(self.curIndex)

    g_node = UI_Wujiangjiemianwujianganniu(0,10)
    self.soldierSelect:addChild(g_node)
end

function PVLineUp:initHeroLayerTouch()
    self.heroLayer = self.UILineUpView["UILineUpView"]["heroLayer"]
    self.heroLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    -- self.heroLayer:setTouchEnabled(false)
    local posX,posY = self.heroLayer:getPosition()
    local size = self.heroLayer:getContentSize()

    local rectArea = cc.rect(0, 0, size.width, size.height)

    local moveType = self.TYPE_MOVE_NONE
    local MAGIN = 50
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            local _point = self.heroLayer:convertToNodeSpace(cc.p(x,y))
            local isInRect = cc.rectContainsPoint(rectArea, _point)
            moveType = self.TYPE_MOVE_NONE
            if isInRect then
                self.touchBeginX = x
                return true
            else
                return false
            end

        elseif  eventType == "moved" then
            local length = self.touchBeginX - x
            if math.abs(length) > MAGIN then
                if length > 0 then
                    moveType = self.TYPE_MOVE_LEFT
                else
                    moveType = self.TYPE_MOVE_RIGHT
                end
            else
                moveType = self.TYPE_MOVE_NONE
            end
        elseif  eventType == "ended" then
            self:onLayerTouchCallBack(moveType)
        end
    end

    self.heroLayer:registerScriptTouchHandler(onTouchEvent)
    self.heroLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.heroLayer:setTouchEnabled(false)
end

function PVLineUp:onLayerTouchCallBack(moveType)
    print("--moveType--",moveType)
    if moveType == self.TYPE_MOVE_NONE then
        self:showSelectHeroView()
        groupCallBack(GuideGroupKey.BTN_ADD_HERO)
    elseif moveType == self.TYPE_MOVE_LEFT then
        self:OnTouchMoveRight()
        -- self:OnTouchMoveLeft()
    elseif moveType == self.TYPE_MOVE_RIGHT then
        self:OnTouchMoveLeft()
        -- self:OnTouchMoveRight()
    end

end
--往左滑动
function PVLineUp:OnTouchMoveLeft()
    local isGuiding = getNewGManager():isHaveGuide()
    if isGuiding then
        return
    end

    self.moveType = 2
    if self.TYPE_TYPE == self.TYPE_SOLDIER_VIEW then --武将页面
        if self.lastSelectHeroIndex == 1 then
            self.lastSelectHeroIndex = self.maxOpenIndex
        else
            self.lastSelectHeroIndex = self.lastSelectHeroIndex -1
        end
        -- print(self.lastSelectHeroIndex)
        self.curIndex = self.lastSelectHeroIndex
        self:onSelectAddClick(self.lastSelectHeroIndex)
    elseif self.TYPE_TYPE == self.TYPE_CHEER_VIEW then  -- 助威页面
        if self.lastSelectCheerHeroIndex == 1 then
            self.lastSelectCheerHeroIndex = self.maxOpenIndex
        else
            self.lastSelectCheerHeroIndex = self.lastSelectCheerHeroIndex - 1
        end
        self.addSoldierNode:setVisible(false)
        self.soldierXinxiNode:setVisible(true)
        self.starAndNameNode:setVisible(true)
        self:updateOtherView()
    end
end

--往右滑动
function PVLineUp:OnTouchMoveRight()
    local isGuiding = getNewGManager():isHaveGuide()
    if isGuiding then
        return
    end

    self.moveType = 1
    if self.TYPE_TYPE == self.TYPE_SOLDIER_VIEW then --武将页面
        if self.lastSelectHeroIndex == self.maxOpenIndex then
            self.lastSelectHeroIndex = 1
        else
            self.lastSelectHeroIndex = self.lastSelectHeroIndex + 1
        end
        self.curIndex = self.lastSelectHeroIndex
        self:onSelectAddClick(self.lastSelectHeroIndex)
    elseif self.TYPE_TYPE == self.TYPE_CHEER_VIEW then  -- 助威页面
        if self.lastSelectCheerHeroIndex == self.maxOpenIndex then
            self.lastSelectCheerHeroIndex = 1
        else
            self.lastSelectCheerHeroIndex = self.lastSelectCheerHeroIndex + 1
        end
        self.addSoldierNode:setVisible(false)
        self.soldierXinxiNode:setVisible(true)
        self.starAndNameNode:setVisible(true)
        self:updateOtherView()
    end
end

--更新英雄身上的装备
function PVLineUp:updateSoldierEquipment()
    print("--updateSoldierEquipment---")

    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _slotEquips = {}

        for i=1,6 do
            local _temp = {}
            _temp.equ = {}
            _temp.equ.no = 0
            _temp.no = i
            table.insert(_slotEquips, _temp)
        end
        if self.minetype == 3 then
            local _slotEquipments = self.secretPlaceData:getEquipsSlotItemByHeroSeat(self.lastSelectHeroIndex)
            -- print("-----------updateSoldierEquipment----11111-------")
            --  table.print(_slotEquipments)
            for k1,v1 in pairs(_slotEquips) do

                -- table.print(v1)
                if _slotEquipments ~= nil  then
                    for k,v in pairs(_slotEquipments) do
                        if v.slot_no == v1.no then
                            -- v.equ.no = v.slot_no
                            -- _equips.equ = {}
                            local _equ = self.c_EquipmentData:getEquipById(v.equipment_id)
                            if _equ ~= nil then
                                v1.equ.no = _equ.no
                                v1.equ = _equ
                            end
                        end
                    end
                end
             end
        else
            local _slotEquipments = self.secretPlaceData:getEquipDataBySlot(self.lastSelectHeroIndex)
            -- print("-----------updateSoldierEquipment----11111-------")
            --  table.print(_slotEquipments)
            for k1,v1 in pairs(_slotEquips) do

                -- table.print(v1)
                if _slotEquipments ~= nil  then
                    for k,v in pairs(_slotEquipments) do
                        if v.no == v1.no then
                            -- v.equ.no = v.slot_no
                            -- _equips.equ = {}
                            -- local _equ = self.c_EquipmentData:getEquipById(v.equipment_id)
                            if v.equ ~= nil then
                                v1.equ.no = v.equ.no
                                v1.equ = v.equ
                            end
                        end
                    end
                end
             end
        end
        for k,v in pairs(_slotEquips) do
            self:updateEquipIcon(v)
        end
    else
        local lineUpSlot = self.lineupData:getSlotItemBySeat(self.lastSelectHeroIndex)
        if lineUpSlot == nil then
            return
        end

        local slotEquipment = lineUpSlot.equs
        for k, v in pairs(slotEquipment) do

            print("----k------"..k)

            self:updateEquipIcon(v)
        end
    end
end

--更新武将装备图标
function PVLineUp:updateEquipIcon(slotEquipment)
    local seat = slotEquipment.no    --装备格子编号
    local equipmentPB = slotEquipment.equ
    local templateId = equipmentPB.no
    print("templateId="..templateId)

    local activation = true
    if templateId == 0 then
        activation = false
    end
    local tempIconSprite = nil
    local playerLevel = getDataManager():getCommonData():getLevel()
    local fadeOut = cc.FadeOut:create(0.6)
    local delayAction = cc.DelayTime:create(0.5)
    local fadeIn = cc.FadeIn:create(0.6)
    local seqAction = cc.Sequence:create(fadeIn,delayAction,fadeOut,delayAction,fadeIn)
    local repeatAction = cc.RepeatForever:create(seqAction)
    if seat == 1 then
        if activation then
            self.qulityA:setVisible(true)
            tempIconSprite = self.qulityA
            -- self.addA:setVisible(false)
            if equipmentPB.id ~= nil then 
                -- local _equipData = self.c_EquipmentData:getEquipById(equipmentPB.id)
                --table.print(equipData)
                self.zbLevelLayer1:setVisible(true)
                self.zbLevelLabel1:setString("Lv." .. string.format(equipmentPB.strengthen_lv))
                if tonumber(equipmentPB.strengthen_lv) < tonumber(playerLevel) then
                    self.arrowSprite1:setVisible(true)
                    self.arrowSprite1:stopAllActions()
                    self.arrowSprite1:runAction(repeatAction)
                    --self.arrowSprite1:removeAllChildren()
                    -- local node = UI_zhuangbeishengjitixing()
                    -- self.arrowSprite1:addChild(node)
                    --createTotleNodeAction(self.arrowSprite1,UI_zhuangbeishengjitixing,1.8,99999999)
                else
                    self.arrowSprite1:setVisible(false)
                end
            end
        else
            self.qulityA:setVisible(false)
            -- self.addA:setVisible(true)
            self.zbLevelLayer1:setVisible(false)
        end
    end

    if seat == 2 then
        if activation then
            self.qulityB:setVisible(true)
            tempIconSprite = self.qulityB
            -- self.addB:setVisible(false)
            if equipmentPB.id ~= nil then 
                -- local _equipData = self.c_EquipmentData:getEquipById(equipmentPB.id)
                self.zbLevelLayer2:setVisible(true)
                self.zbLevelLabel2:setString("Lv." .. string.format(equipmentPB.strengthen_lv)) 
                if tonumber(equipmentPB.strengthen_lv) < tonumber(playerLevel) then
                    self.arrowSprite2:setVisible(true)
                    self.arrowSprite2:stopAllActions()
                    self.arrowSprite2:runAction(repeatAction)
                    --self.arrowSprite2:removeAllChildren()
                    -- local node = UI_zhuangbeishengjitixing()
                    -- self.arrowSprite2:addChild(node)
                    --createTotleNodeAction(self.arrowSprite2,UI_zhuangbeishengjitixing,1.8,99999999)
                else
                    self.arrowSprite2:setVisible(false)
                end
            end
        else
            self.qulityB:setVisible(false)
            -- self.addB:setVisible(true)
            self.zbLevelLayer2:setVisible(false)
        end
    end

    if seat == 3 then
        if activation then
            self.qulityC:setVisible(true)
            tempIconSprite = self.qulityC
            -- self.addC:setVisible(false)
            if equipmentPB.id ~= nil then 
                -- local _equipData = self.c_EquipmentData:getEquipById(equipmentPB.id)
                self.zbLevelLayer3:setVisible(true)
                self.zbLevelLabel3:setString("Lv." .. string.format(equipmentPB.strengthen_lv)) 
                if tonumber(equipmentPB.strengthen_lv) < tonumber(playerLevel) then
                    self.arrowSprite3:setVisible(true)
                    self.arrowSprite3:stopAllActions()
                    self.arrowSprite3:runAction(repeatAction)
                    --self.arrowSprite3:removeAllChildren()
                    -- local node = UI_zhuangbeishengjitixing()
                    -- self.arrowSprite3:addChild(node)
                    --createTotleNodeAction(self.arrowSprite3,UI_zhuangbeishengjitixing,1.8,99999999)
                else
                    self.arrowSprite3:setVisible(false)
                end
            end
        else
            self.qulityC:setVisible(false)
            -- self.addC:setVisible(true)
            self.zbLevelLayer3:setVisible(false)
        end
    end

    if seat == 4 then
        if activation then
            self.qulityD:setVisible(true)
            tempIconSprite = self.qulityD
            -- self.addD:setVisible(false)
            if equipmentPB.id ~= nil then 
                -- local _equipData = self.c_EquipmentData:getEquipById(equipmentPB.id)
                self.zbLevelLayer4:setVisible(true)
                self.zbLevelLabel4:setString("Lv." .. string.format(equipmentPB.strengthen_lv)) 
                if tonumber(equipmentPB.strengthen_lv) < tonumber(playerLevel) then
                    self.arrowSprite4:setVisible(true)
                    self.arrowSprite4:stopAllActions()
                    self.arrowSprite4:runAction(repeatAction)
                    -- self.arrowSprite4:removeAllChildren()
                    -- createTotleNodeAction(self.arrowSprite4,UI_zhuangbeishengjitixing,1.8,99999999)
                    --local node = UI_zhuangbeishengjitixing()
                    --self.arrowSprite4:addChild(node)
                else
                    self.arrowSprite4:setVisible(false)
                end
            end
        else
            self.qulityD:setVisible(false)
            -- self.addD:setVisible(true)
            self.zbLevelLayer4:setVisible(false)
        end
    end

    if seat == 5 then
        if activation then
            self.qulityE:setVisible(true)
            tempIconSprite = self.qulityE
            -- self.addE:setVisible(false)
            if equipmentPB.id ~= nil then 
                -- local _equipData = self.c_EquipmentData:getEquipById(equipmentPB.id)
                self.zbLevelLayer5:setVisible(true)
                self.zbLevelLabel5:setString("Lv." .. string.format(equipmentPB.strengthen_lv)) 
                self.arrowSprite5:setVisible(false)
                -- if tonumber(_equipData.strengthen_lv) < tonumber(playerLevel) then
                --     self.arrowSprite5:setVisible(true)
                --     self.arrowSprite5:removeAllChildren()
                --     local node = UI_zhuangbeishengjitixing()
                --     self.arrowSprite5:addChild(node)
                -- else
                --     self.arrowSprite5:setVisible(false)
                -- end
            end
        else
            self.qulityE:setVisible(false)
            -- self.addE:setVisible(true)
            self.zbLevelLayer5:setVisible(false)
        end
    end

    if seat == 6 then
        if activation then
            self.qulityF:setVisible(true)
            tempIconSprite = self.qulityF
            -- self.addF:setVisible(false)
            -- local resIcon = self.c_equipTemp:getEquipResIcon(templateId)
            -- game.setSpriteFrame(self.qulityF, resIcon)
            if equipmentPB.id ~= nil then 
                -- local _equipData = self.c_EquipmentData:getEquipById(equipmentPB.id)
                self.zbLevelLayer6:setVisible(true)
                self.zbLevelLabel6:setString("Lv." .. string.format(equipmentPB.strengthen_lv)) 
                self.arrowSprite6:setVisible(false)
                -- if tonumber(_equipData.strengthen_lv) < tonumber(playerLevel) then
                --     self.arrowSprite6:setVisible(true)
                --     self.arrowSprite6:removeAllChildren()
                --     local node = UI_zhuangbeishengjitixing()
                --     self.arrowSprite6:addChild(node)
                -- else
                --     self.arrowSprite6:setVisible(false)
                -- end
            end
        else
            self.qulityF:setVisible(false)
            -- self.addF:setVisible(true)
            self.zbLevelLayer6:setVisible(false)
        end
    end

    if activation then
        local equipmentItem = self.c_equipTemp:getTemplateById(templateId)
        local quality = equipmentItem.quality
        local resIcon = self.c_equipTemp:getEquipResHD(templateId)        -- 新版本icon
        -- local resIcon = self.c_equipTemp:getEquipResIcon(templateId)   -- 旧版本icon

        -- setItemImage(tempIconSprite, resIcon, quality)
        -- changeEquipIconImageBottom(tempIconSprite, resIcon, quality)  -- 旧版本路径
        setNewEquipCardWithFrame(tempIconSprite, resIcon, quality)  -- 新版本路径
        local node = UI_Xiangqianzhuangbei(nil)
        tempIconSprite:addChild(node)
    end
end

function PVLineUp:initLinkData(soldierId)

    self.cheerDiscriptions = {}

    local function getBuffInfo(buff)
        local strEffect = ""
        for i,v in ipairs(buff) do
            local buffInfo = self.c_SoldierTemplate:getSkillBuffTempLateById(buff[i])
            local buffEffectId = buffInfo.effectId
            local buffType = buffInfo.valueType
            local buffValue = buffInfo.valueEffect
            local strValue = nil
            if buffType == 1 then strValue = tostring(buffValue)
            elseif buffType == 2 then strValue = tostring(buffValue) .. "%"
            end
            strEffect = strEffect .. self.c_SoldierTemplate:getSkillBuffEffectName(buffEffectId) .. strValue
        end
        return strEffect
    end

    local posy = 250-5
    local posx = 0
    local _height = 0
    local linkItem = self.c_SoldierTemplate:getLinkTempLateById(soldierId)
     -- print("----linkItem----")
     -- table.print(linkItem)
     -- print("----------------")
    for i=1, 5 do
        local isTrigger,trigger = self.c_SoldierTemplate:getIsTriggerByIndex(soldierId, i)

        if isTrigger then
            local strName = "linkname"..tostring(i)
            local strText = "linktext"..tostring(i)
            local strSkill = "link"..tostring(i)
            local strType = "type"..tostring(i)
            local name = linkItem[strName]
            local text = linkItem[strText]
            local skillId = linkItem[strSkill]
            local typeId = linkItem[strType]
            local nameLanguage = self.c_LanguageTemplate:getLanguageById(name)
            local textLanguage = self.c_LanguageTemplate:getLanguageById(text)
            local skillInfo = self.c_SoldierTemplate:getSkillTempLateById(skillId)

            local buff = skillInfo.group
            textLanguage = string.gsub(textLanguage, "s%%", "")
            textLanguage = textLanguage .. getBuffInfo(buff)

            local _dis = "["..nameLanguage.."]".."："..textLanguage
            self.cheerDiscriptions[i] = {}
            self.cheerDiscriptions[i].trigger = trigger
            self.cheerDiscriptions[i].dis = _dis
            self.cheerDiscriptions[i].typeId = typeId
        end
    end

    local function sortByTypeId()
        local function cmp1(a,b)
            if a.typeId ~= nil and b.typeId ~= nil then
                if a.typeId < b.typeId then return true end
            end
        end
        table.sort(self.cheerDiscriptions,cmp1)
    end
    sortByTypeId()

end

--根据座位号更新羁绊信息(助威页面)
function PVLineUp:updateCheerLinkBySeat(seat)
    local soldierId = 0
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then  -- 符文秘境进来的
        local _hero_no = self.secretPlaceData:getSlotItemBySeat(self.curIndex)
        if _hero_no == nil then
            _hero_no = 0
        end
        soldierId = _hero_no
    else
        local slotItem = self.lineupData:getSlotItemBySeat(seat)
        if slotItem == nil then
            self.tableView:setVisible(false)
            soldierId = 0
        else
            local heroPb = slotItem.hero
            soldierId = heroPb.hero_no
        end
    end

    if soldierId == 0 then
        --更新助威加成
        local attr = self.c_Calculation:CheerAttr()
        self.attrValueA:setString(string.format(self:keepSingleBitNum(attr.hp)))
        self.attrValueB:setString(string.format(self:keepSingleBitNum(attr.physicalDef)))
        self.attrValueC:setString(string.format(self:keepSingleBitNum(attr.atk)))
        self.attrValueD:setString(string.format(self:keepSingleBitNum(attr.magicDef)))
        return
    end
    local nameStr = self.c_SoldierTemplate:getHeroName(soldierId)
    self.cheerHeroName:setString(nameStr)

    self.totleLinkDataItem = self.c_SoldierTemplate:getLinkDataById(soldierId) --这个英雄的全部羁绊信息
    self.linkItemTable = self.lineupData:getLink(soldierId)   --这个英雄羁绊上得信息

    -- 助威信息
    self:initLinkData(soldierId)
    self.size = table.getn(self.cheerDiscriptions)
    if self.tableView then
        self.tableView:setVisible(true)
        self.tableView:reloadData()
    end

    --更新助威加成
    local attr = self.c_Calculation:CheerAttr()
    self.attrValueA:setString(string.format(self:keepSingleBitNum(attr.hp)))
    self.attrValueB:setString(string.format(self:keepSingleBitNum(attr.physicalDef)))
    self.attrValueC:setString(string.format(self:keepSingleBitNum(attr.atk)))
    self.attrValueD:setString(string.format(self:keepSingleBitNum(attr.magicDef)))
end

function PVLineUp:isExistsSelectSoldierData(linkid)
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _mineGuardHeroNos = self.secretPlaceData:getMineGuardHeroNos()
        for k,v in pairs(_mineGuardHeroNos) do
            if v == linkid then
                return true
            end
        end
    else
        for k,v in pairs(self.selectSoldierData) do
            if v.hero.hero_no == linkid then
                return true
            end
        end
    end
    return false
end

function PVLineUp:isExistsCheerSoldierData(linkid)
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
    else
        for k,v in pairs(self.cheerSoldierData) do
            if v.hero.hero_no == linkid then
                return true
            end
        end
    end
    return false
end

function PVLineUp:isExistsEquipmentData(linkid)

    -- print("self.lastSelectHeroIndex="..self.lastSelectHeroIndex)

    local lineUpSlot = self.lineupData:getSlotItemBySeat(self.cheerSelectIndex)
    if lineUpSlot == nil then
        return false
    end

    local slotEquipment = lineUpSlot.equs

    -- table.print(slotEquipment)

    for k, v in pairs(slotEquipment) do
        -- self:updateEquipIcon(v)
        local equipmentPB = v.equ
        local templateId = equipmentPB.no
        -- print(linkid.."..templateId="..templateId)
        if templateId == linkid then
            return true
        end
    end

    return false
end

function PVLineUp:isExistsEquipmentData2(linkid)
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _equipment_slots = self.secretPlaceData:getEquipsSlotItemByHeroSeat(self.lastSelectHeroIndex)
        if _equipment_slots == nil then
            return false
        end
        for k, v in pairs(_equipment_slots) do
            local _equ = self.c_EquipmentData:getEquipById(v.equipment_id)
            if _equ ~= nil then
                table.print(_equ)
                if _equ.no == linkid then
                    return true
                end
            end
        end
    else
        -- print("self.lastSelectHeroIndex="..self.lastSelectHeroIndex)
        local lineUpSlot = self.lineupData:getSlotItemBySeat(self.lastSelectHeroIndex)
        if lineUpSlot == nil then
            return false
        end
        local slotEquipment = lineUpSlot.equs

        -- table.print(slotEquipment)

        for k, v in pairs(slotEquipment) do
            -- self:updateEquipIcon(v)
            local equipmentPB = v.equ
            local templateId = equipmentPB.no
            -- print(linkid.."..templateId="..templateId)
            if templateId == linkid then
                return true
            end
        end
    end
    return false
end

--更新武将界面羁绊信息
function PVLineUp:updateSelectSoldierLinkView(seat)
    local slotItem = nil
    local heroPb = nil
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _hero_no = self.secretPlaceData:getSlotItemBySeat(seat)
        if _hero_no == nil or _hero_no == 0 then
            self:showEmptyView()
            self:clearAttribute()
            return 0
        end
        print("_hero_no==".._hero_no)
        local slotItem = nil
        if self.minetype == 3 then
            slotItem = self.lineupData:getSlotItemBySeatfromSoldierData(_hero_no)
        else
            slotItem = self.secretPlaceData:getHeroDataBySlot(self.curIndex)
        end
        if slotItem == nil then
            return 0
        end
        heroPb = slotItem

    else
        slotItem = self.lineupData:getSlotItemBySeat(seat)
        if slotItem == nil then
            return 0
        end
        heroPb = slotItem.hero
    end

    local soldierId = heroPb.hero_no
    print("soldierId=====" .. soldierId)
    -- table.print(self.selectSoldierData)
    if soldierId == 0 then
        self:clearAttribute()
        self:showEmptyView()
        return
    end
    self.totleLinkDataItem = self.c_SoldierTemplate:getLinkDataById(soldierId) --这个英雄的全部羁绊信息
    self.linkItemTable = self.lineupData:getLink(soldierId)   --这个英雄羁绊上得信息
    -- self.totleLinkDataItem = self.c_SoldierTemplate:getLinkTempLateById(soldierId)
     print("------self.totleLinkDataItem------")
     --table.print(self.totleLinkDataItem)
    local function sortByTypeId()
        local function cmp1(a,b)
            if a.typeId ~= nil and b.typeId ~= nil then
                if a.typeId < b.typeId then return true end
            end
        end
        table.sort(self.totleLinkDataItem,cmp1)
    end
    sortByTypeId()

     -- print("!!!!!!!!!!!!")
     -- table.print(self.totleLinkDataItem)
     -- print("@@@@@@")
    -- table.print(self.linkItemTable)
    -- print("!!!!!!!!!!!!")

    print("--------------------")

    local size = table.getn(self.totleLinkDataItem)
    for k,v in pairs(self.linkLabel) do
        if size < k then v:setVisible(false)
        else
            local item = self.totleLinkDataItem[k]
            local name = item["name"]
            local resStr = self.c_LanguageTemplate:getLanguageById(name)
            v:setVisible(true)
            v:setString(resStr)
            -- 遍历所有的羁绊，显示已激活的羁绊
            local _color = ui.COLOR_GREEN
            local _opacity = 255
            local _isGreen = true
            for _k,_v in pairs(self.totleLinkDataItem[k].trigger) do

                if (not self:isExistsSelectSoldierData(_v) and not self:isExistsCheerSoldierData(_v)) then
                    _color = ui.COLOR_GREY
                    _isGreen = false
                    _opacity = 100
                    break
                end
            end
            if _isGreen == false then
                _color = ui.COLOR_GREEN
                _opacity = 255
                for _k,_v in pairs(self.totleLinkDataItem[k].trigger) do
                    if not self:isExistsEquipmentData2(_v) then
                         _color = ui.COLOR_GREY
                         _opacity = 100
                        break
                    end
                end
            end
            -- v:setColor(_color)
            v:setOpacity(_opacity)
        end
    end
    print("--------------------")

end

--更新选择英雄的icon
function PVLineUp:updateHeroIcon()
    local tempIndex = 0
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _soldiers = self.secretPlaceData:getMineGuardRequestHeros()
        -- print("updateHeroIcon===00000====1111111==")
        -- table.print(_soldiers)
        -- print("updateHeroIcon===00000")
        for k, v in pairs(_soldiers) do
            --print("updateHeroIcon===111111")
           local seat = v.slot_no
           local heroId = v.hero_no

           self:updateHeroIconImage(heroId, seat, activation)

        end

    else
       -- print("===updateHeroIcon===22222=====")
        local tempIndex = 0
        -- table.print(self.selectSoldierData)

        for k, v in pairs(self.selectSoldierData) do

           local seat = v.slot_no
           local hero = v.hero
           local equs = v.equs
           local activation = v.activation
           local heroId = hero.hero_no

           self:updateHeroIconImage(heroId, seat, activation)
           if activation == true then
            tempIndex = tempIndex + 1
           end
        end
        self.maxOpenIndex = tempIndex

        -- 更新头像
        -- local event = cc.EventCustom:new(UPDATE_HEAD_ICON)
        -- self:getEventDispatcher():dispatchEvent(event)
        -- self.basicAttributeView:updateHeadIcon()
        getHomeBasicAttrView():updateHeadIcon()
    end
end


function PVLineUp:updateHeroIconImage(id, seatIndex, activation)
    local nowSprite = nil
    local topAdd = nil
    local levelLayer = nil
    local _soldierData = nil
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        _soldierData = self.secretPlaceData:getHeroDataBySlot(seatIndex)
    else
        _soldierData = self.sodierData:getSoldierDataById(id)
    end
    
    if seatIndex == 1 then
        nowSprite = self.userSpriteA
        topAdd = self.topAddA
        levelLayer = self.levelLayer1
        if _soldierData ~= nil then
            --table.print(_soldierData)
            self.levelLabel1:setString("Lv." .. string.format(_soldierData.level))
        end
    elseif seatIndex == 2 then
        nowSprite = self.userSpriteB
        topAdd = self.topAddB
        levelLayer = self.levelLayer2
        if _soldierData ~= nil then
            self.levelLabel2:setString("Lv."..string.format(_soldierData.level))
        end
    elseif seatIndex == 3 then
        nowSprite = self.userSpriteC
        topAdd = self.topAddC
        levelLayer = self.levelLayer3
        if _soldierData ~= nil then
            self.levelLabel3:setString("Lv."..string.format(_soldierData.level))
        end
    elseif seatIndex == 4 then
        nowSprite = self.userSpriteD
        topAdd = self.topAddD
        levelLayer = self.levelLayer4
        if _soldierData ~= nil then
            self.levelLabel4:setString("Lv."..string.format(_soldierData.level))
        end
    elseif seatIndex == 5 then
        nowSprite = self.userSpriteE
        topAdd = self.topAddE
        levelLayer = self.levelLayer5
        if _soldierData ~= nil then
            self.levelLabel5:setString("Lv."..string.format(_soldierData.level))
        end
    elseif seatIndex == 6 then
        nowSprite = self.userSpriteF
        topAdd = self.topAddF
        levelLayer = self.levelLayer6
        if _soldierData ~= nil then
            self.levelLabel6:setString("Lv."..string.format(_soldierData.level))
        end
    end
    if id ~= 0  then
        nowSprite:setVisible(true)
        topAdd:setVisible(true)
        levelLayer:setVisible(true)
    else
        nowSprite:setVisible(false)
        --topAdd:setVisible(false)
        levelLayer:setVisible(false)
        return
    end

    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(id)
    local quality = soldierTemplateItem.quality


    local resIcon = self.c_SoldierTemplate:getSoldierIcon(id)
    -- changeNewIconImage(nowSprite, resIcon, quality) --更新icon
    changeNewIconImage(nowSprite, resIcon, quality)  -- 新版icon

end

--更新未开启view
function PVLineUp:updateUnOpenView()
    local level = self.c_CommonData:getLevel()
    --print("level======" .. level)
    self.maxOpenIndex = self.baseTemplate:getOpenSeatsByLv(level)
    --print("self.maxOpenIndex========" .. self.maxOpenIndex)
    local baseItem = self.baseTemplate:getBaseInfoById("hero_position_open_level")

    if self.maxOpenIndex > 0 then
        self.upOpenBgA:setVisible(false)
        self.unOpenLabelNodeA:setVisible(false)
        self.heroSeatMenuTable[1]:setEnabled(true)
        self.topAddA:setVisible(true)
    else
        self.topAddA:setVisible(true)
        self.upOpenBgA:setVisible(true)
        self.unOpenLabelNodeA:setVisible(true)
        self.topAddA:setVisible(false)
        local openLevel = baseItem["1"]
        self.unOpenLevelLabelA:setString(string.format(openLevel))
        self.heroSeatMenuTable[1]:setEnabled(false)
    end

    if self.maxOpenIndex > 1 then
        self.upOpenBgB:setVisible(false)
        self.unOpenLabelNodeB:setVisible(false)
        self.heroSeatMenuTable[2]:setEnabled(true)
        self.topAddB:setVisible(true)
    else
        self.upOpenBgB:setVisible(true)
        self.unOpenLabelNodeB:setVisible(true)
        self.topAddB:setVisible(false)
        local openLevel = baseItem["2"]
        self.unOpenLevelLabelB:setString(string.format(openLevel))
        self.heroSeatMenuTable[2]:setEnabled(false)
    end

    if self.maxOpenIndex > 2 then
        self.upOpenBgC:setVisible(false)
        self.unOpenLabelNodeC:setVisible(false)
        self.heroSeatMenuTable[3]:setEnabled(true)
        self.topAddC:setVisible(true)
    else
        self.topAddC:setVisible(false)
        self.upOpenBgC:setVisible(true)
        self.unOpenLabelNodeC:setVisible(true)

        local openLevel = baseItem["3"]
        self.unOpenLevelLabelC:setString(string.format(openLevel))
        self.heroSeatMenuTable[3]:setEnabled(false)
    end

    if self.maxOpenIndex > 3 then
        self.upOpenBgD:setVisible(false)
        self.unOpenLabelNodeD:setVisible(false)
        self.heroSeatMenuTable[4]:setEnabled(true)
        self.topAddD:setVisible(true)
    else
        self.topAddD:setVisible(false)
        self.upOpenBgD:setVisible(true)
        self.unOpenLabelNodeD:setVisible(true)

        local openLevel = baseItem["4"]
        self.unOpenLevelLabelD:setString(string.format(openLevel))
        self.heroSeatMenuTable[4]:setEnabled(false)
    end

    if self.maxOpenIndex > 4 then
        self.upOpenBgE:setVisible(false)
        self.unOpenLabelNodeE:setVisible(false)
        self.heroSeatMenuTable[5]:setEnabled(true)
        self.topAddE:setVisible(true)
    else
        self.topAddE:setVisible(false)
        self.upOpenBgE:setVisible(true)
        self.unOpenLabelNodeE:setVisible(true)

        local openLevel = baseItem["5"]
        self.unOpenLevelLabelE:setString(string.format(openLevel))
        self.heroSeatMenuTable[5]:setEnabled(false)
    end

    if self.maxOpenIndex > 5 then
        self.upOpenBgF:setVisible(false)
        self.unOpenLabelNodeF:setVisible(false)
        --self.heroSeatMenuTable[6]:setEnabled(true)
        self.topAddF:setVisible(true)
    else
        self.topAddF:setVisible(false)
        self.upOpenBgF:setVisible(true)
        self.unOpenLabelNodeF:setVisible(true)

        local openLevel = baseItem["6"]
        self.unOpenLevelLabelF:setString(string.format(openLevel))
        self.heroSeatMenuTable[6]:setEnabled(false)
    end
end

--更新助威未开启
function PVLineUp:updateCheerUnOpenView(seat, activation)
    local baseItem = self.baseTemplate:getBaseInfoById("friend_position_open_level")
    --["1"] = 20,  ["3"] = 40,  ["2"] = 30,  ["5"] = 60,  ["4"] = 50,  ["6"] = 70,}

    print("---activation----",activation)
    --table.print(baseItem)
    local fadeOut = cc.FadeOut:create(1)
    local delayAction = cc.DelayTime:create(0.5)
    local fadeIn = cc.FadeIn:create(1)
    local seqAction = cc.Sequence:create(fadeIn,delayAction,fadeOut,delayAction,fadeIn)  ---fadeIn   --fadeOut
    local seqAction1 = cc.Sequence:create(fadeOut,delayAction,fadeIn,delayAction,fadeOut)
    if seat == 1 then
        self.bottomAddA:stopAllActions()
        self.bottomLabelAddA:stopAllActions()
        if activation then
            self.unOpenCheerBgA:setVisible(false)  ---false
            self.uOCheerLabelNodeA:setVisible(false)
            self.bottomAddA:runAction(cc.RepeatForever:create(seqAction1))
            self.bottomLabelAddA:runAction(cc.RepeatForever:create(seqAction))
        else
            self.unOpenCheerBgA:setVisible(true)
            self.uOCheerLabelNodeA:setVisible(true)

            local openLevel = baseItem[string.format(seat)]
            --print("openLevel")
            self.uOCheerLVLabelA:setString(string.format(openLevel))
        end
    end

    if seat == 2 then
        self.bottomAddB:stopAllActions()
        self.bottomLabelAddB:stopAllActions()
        if activation then
            self.unOpenCheerBgB:setVisible(false)
            self.uOCheerLabelNodeB:setVisible(false)
            self.bottomAddB:runAction(cc.RepeatForever:create(seqAction1))
            self.bottomLabelAddB:runAction(cc.RepeatForever:create(seqAction))
        else
            self.unOpenCheerBgB:setVisible(true)
            self.uOCheerLabelNodeB:setVisible(true)

            local openLevel = baseItem[string.format(seat)]
            --print("openLevel")
            self.uOCheerLVLabelB:setString(string.format(openLevel))
        end
    end

    if seat == 3 then
        self.bottomAddC:stopAllActions()
        self.bottomLabelAddC:stopAllActions()
        if activation then
            self.unOpenCheerBgC:setVisible(false)
            self.uOCheerLabelNodeC:setVisible(false)
            self.bottomAddC:runAction(cc.RepeatForever:create(seqAction1))
            self.bottomLabelAddC:runAction(cc.RepeatForever:create(seqAction))
        else
            self.unOpenCheerBgC:setVisible(true)
            self.uOCheerLabelNodeC:setVisible(true)

            local openLevel = baseItem[string.format(seat)]
            --print("openLevel")
            self.uOCheerLVLabelC:setString(string.format(openLevel))
        end
    end

    if seat == 4 then
        self.bottomAddD:stopAllActions()
        self.bottomLabelAddD:stopAllActions()
        if activation then
            self.unOpenCheerBgD:setVisible(false)
            self.uOCheerLabelNodeD:setVisible(false)
            self.bottomAddD:runAction(cc.RepeatForever:create(seqAction1))
            self.bottomLabelAddD:runAction(cc.RepeatForever:create(seqAction))
        else
            self.unOpenCheerBgD:setVisible(true)
            self.uOCheerLabelNodeD:setVisible(true)

            local openLevel = baseItem[string.format(seat)]
            --print("openLevel")
            self.uOCheerLVLabelD:setString(string.format(openLevel))
        end
    end

    if seat == 5 then
        self.bottomAddE:stopAllActions()
        self.bottomLabelAddE:stopAllActions()
        if activation then
            self.unOpenCheerBgE:setVisible(false)
            self.uOCheerLabelNodeE:setVisible(false)
            self.bottomAddE:runAction(cc.RepeatForever:create(seqAction1))
            self.bottomLabelAddE:runAction(cc.RepeatForever:create(seqAction))
        else
            self.unOpenCheerBgE:setVisible(true)
            self.uOCheerLabelNodeE:setVisible(true)

            local openLevel = baseItem[string.format(seat)]
            --print("openLevel")
            self.uOCheerLVLabelE:setString(string.format(openLevel))
        end
    end

    if seat == 6 then
        self.bottomAddF:stopAllActions()
        self.bottomLabelAddF:stopAllActions()
        if activation then
            self.unOpenCheerBgF:setVisible(false)
            self.uOCheerLabelNodeF:setVisible(false)
             self.bottomAddF:runAction(cc.RepeatForever:create(seqAction1))
             self.bottomLabelAddF:runAction(cc.RepeatForever:create(seqAction))
        else
            self.unOpenCheerBgF:setVisible(true)
            self.uOCheerLabelNodeF:setVisible(true)

            local openLevel = baseItem[string.format(seat)]
            --print("openLevel")
            self.uOCheerLVLabelF:setString(string.format(openLevel))
        end
    end
end

--更新助威icon
function PVLineUp:updateCheerData()
    -- table.print(self.cheerSoldierData)
    for k, v in pairs(self.cheerSoldierData) do
       self:updataCheerHeroIcon(v)
    end
end

-------
function PVLineUp:updataCheerHeroIcon(lineUpSlot)
    local seatIndex = lineUpSlot.slot_no
    local hero = lineUpSlot.hero
    local activation = lineUpSlot.activation
    local heroId = hero.hero_no
    local attribute = nil
    local attribute_2 = nil

    self:updateCheerUnOpenView(seatIndex, activation)
    local nowCheerSprite = nil
    if seatIndex == 1 then
        nowCheerSprite = self.cheerHeroA
        attribute = self.attribute1
    elseif seatIndex == 2 then
        nowCheerSprite = self.cheerHeroB
        attribute = self.attribute2
    elseif seatIndex == 3 then
        nowCheerSprite = self.cheerHeroC
        attribute = self.attribute3
    elseif seatIndex == 4 then
        nowCheerSprite = self.cheerHeroD
        attribute = self.attribute4
    elseif seatIndex == 5 then
        nowCheerSprite = self.cheerHeroE
        attribute = self.attribute5
        attribute_2 = self.attribute5_2
    elseif seatIndex == 6 then
        nowCheerSprite = self.cheerHeroF
        attribute = self.attribute6
        attribute_2 = self.attribute6_2
    end

    if heroId ~= 0 then
        nowCheerSprite:setVisible(true)

        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(heroId)
        local quality = soldierTemplateItem.quality


        local resIcon = self.c_SoldierTemplate:getSoldierIcon(heroId)
        -- changeNewIconImage(nowCheerSprite, resIcon, quality) --更新icon
        changeNewIconImage(nowCheerSprite, resIcon, quality)  -- 新版icon

        attribute:setVisible(true)
        local baseItem = self.baseTemplate:getCheerAddBySeat(seatIndex)
        local str = ""
        local str2 = ""
        if seatIndex == 1 then
            str = string.format("%s+%d%%", Localize.query("lineup.1"), tonumber(baseItem["1"])*100)
        elseif seatIndex == 2 then
            str = string.format("%s+%d%%",Localize.query("lineup.2"),  tonumber(baseItem["3"])*100)
        elseif seatIndex == 3 then
            str = string.format("%s+%d%%",Localize.query("lineup.3"),  tonumber(baseItem["4"])*100)
        elseif seatIndex == 4 then
            str = string.format("%s+%d%%",Localize.query("lineup.4"), tonumber(baseItem["2"])*100)
        elseif seatIndex == 5 then
            str = string.format("%s+%d%%",Localize.query("lineup.4"), tonumber(baseItem["2"])*100)
            str2 = string.format("%s+%d%%",Localize.query("lineup.2"), tonumber(baseItem["3"])*100)
        elseif seatIndex == 6 then
            str = string.format("%s+%d%%",Localize.query("lineup.4"), tonumber(baseItem["2"])*100)
            str2 = string.format("%s+%d%%",Localize.query("lineup.3"), tonumber(baseItem["4"])*100)
        end
         attribute:setString(str)
         if attribute_2 ~= nil then
            attribute_2:setVisible(true)
            attribute_2:setString(str2)
        end
    else
        nowCheerSprite:setVisible(false)
        attribute:setVisible(false)
        if attribute_2 ~= nil then
            attribute_2:setVisible(false)
        end
    end

end

--武将助威按钮的切换
function PVLineUp:changeView()
    if g_node then
        g_node:removeFromParent()
    end
    g_node = UI_Wujiangjiemianwujianganniu(0,10)
    print("=====================================>", self.TYPE_TYPE)
    if self.TYPE_TYPE == self.TYPE_SOLDIER_VIEW then
        self.SeatNode:setVisible(true)
        self.cheerNode:setVisible(false)
        self.soldierNode:setVisible(true)
        self.heroLayer:setTouchEnabled(true)
        if self.tableView then
            self.tableView:setTouchEnabled(false)
        end
        if self.wsTableView then
            self.wsTableView:setTouchEnabled(false)
        end
        self.soldierBtn:setEnabled(false)
        -- self.soldierBtn:getSelectedImage():setVisible(false)
        self.cheerBtn:setEnabled(true)
        self.wsBtn:setEnabled(true)
        self.soldierNormal:setVisible(false)
        self.soldierSelect:setVisible(true)
        self.upSelect:setVisible(false)
        self.upNormal:setVisible(true)
        self.wsNormal:setVisible(true)
        self.wsSelect:setVisible(false)
        self.nodeWS:setVisible(false)
        self.ws_bg:setVisible(false)
        self.soldierSelect:addChild(g_node)
    elseif self.TYPE_TYPE == self.TYPE_CHEER_VIEW then
        self.SeatNode:setVisible(true)
        self.cheerNode:setVisible(true)
        self.soldierNode:setVisible(false)
        self.heroLayer:setTouchEnabled(true)
        if self.tableView then
            self.tableView:setTouchEnabled(true)
        end
        if self.wsTableView then
            self.wsTableView:setTouchEnabled(false)
        end
        self.soldierBtn:setEnabled(true)
        self.cheerBtn:setEnabled(false)
        -- self.cheerBtn:getSelectedImage():setVisible(false)
        self.wsBtn:setEnabled(true)
        self.soldierNormal:setVisible(true)
        self.soldierSelect:setVisible(false)
        self.upSelect:setVisible(true)
        self.upNormal:setVisible(false)
        self.wsNormal:setVisible(true)
        self.wsSelect:setVisible(false)
        self.nodeWS:setVisible(false)
        self.ws_bg:setVisible(false)
        self.upSelect:addChild(g_node)
    elseif self.TYPE_TYPE == self.TYPE_WS_VIEW then
        self.SeatNode:setVisible(false)
        self.cheerNode:setVisible(false)
        self.soldierNode:setVisible(false)
        self.heroLayer:setTouchEnabled(false)
        if self.tableView then
            self.tableView:setTouchEnabled(false)
        end
        if self.wsTableView then
            self.wsTableView:setTouchEnabled(true)
        end
        self.soldierBtn:setEnabled(true)
        self.cheerBtn:setEnabled(true)
        self.wsBtn:setEnabled(false)
        -- self.wsBtn:getSelectedImage():setVisible(false)
        self.soldierNormal:setVisible(true)
        self.soldierSelect:setVisible(false)
        self.upNormal:setVisible(true)
        self.upSelect:setVisible(false)
        self.wsNormal:setVisible(false)
        self.wsSelect:setVisible(true)
        self.nodeWS:setVisible(true)
        self.ws_bg:setVisible(true)
        self.wsSelect:addChild(g_node)
        self:updateWSListData()

        groupCallBack(GuideGroupKey.BTN_ZR_WU)
    end
end

--更新无双列表的数据
function PVLineUp:updateWSListData()
    self.wsList = self.c_InstanceTemplate:getWSList()  -- 无双列表

    local function getIsActive(wsId)
        local condition = {}
        local v = self.c_InstanceTemplate:getWSInfoById(wsId)
        if v.condition1 ~= 0 then table.insert(condition, v.condition1) end
        if v.condition2 ~= 0 then table.insert(condition, v.condition2) end
        if v.condition3 ~= 0 then table.insert(condition, v.condition3) end
        if v.condition4 ~= 0 then table.insert(condition, v.condition4) end
        if v.condition5 ~= 0 then table.insert(condition, v.condition5) end
        if v.condition6 ~= 0 then table.insert(condition, v.condition6) end
        if v.condition7 ~= 0 then table.insert(condition, v.condition7) end

        for k,v in pairs(condition) do
            if self:getSoldierIsActivity(v) == false then -- v is soldierId
                return false
            end
        end

        return true
    end

    for k,v in pairs(self.wsList) do
        if getIsActive(v.id) then v.isActive = true end
        v.level = self.lineupData:getWSLevel(v.id)
    end

    -- sort
    local function compare(a, b)
        local cmpA = 0
        local cmpB = 0
        if a.isActive then cmpA = 1 end
        if b.isActive then cmpB = 1 end
        if a.level > b.level then return true
        elseif  a.level == b.level then
            if cmpA > cmpB then return true
            elseif cmpA == cmpB then
                if a.id < b.id then return true
                else return false
                end
            end
        end
    end
    table.sort( self.wsList, compare )

    if self.wsTableView then
        print("0000000000")
        self.wsTableView:reloadData()
        self:tableViewItemAction(self.wsTableView)
    else
        self:createWSList()
    end
    local _size = table.nums(self.wsList)
    self.nunLabelWS:setString(_size)
end

--阵容界面初始化按钮事件监听
function PVLineUp:initTouchListener()
    local function soldierMenuClick()
        self.type = 1
        getAudioManager():playEffectPage()
        self.TYPE_TYPE = self.TYPE_SOLDIER_VIEW
        self:changeView()
        if self.tableView then
            self:createListView()
            if self.chekLinkLayer:isVisible() == false then
                self.tableView:setTouchEnabled(false)
            end
        else
            self:createAttrScroll()
            self:createAttributeScollView()
        end
        if g_curIndex ~= nil then
            self.curIndex = g_curIndex
        end
        self:onSelectAddClick(self.curIndex)
        g_curIndex = nil
    end

    local function cheerMenuClick()
        self.type = 2
        self.lastSelectHeroIndex = 1
        getAudioManager():playEffectPage()
        self.TYPE_TYPE = self.TYPE_CHEER_VIEW
        self:changeView()
        if self.scrollView then
            self.scrollView:removeFromParent()
            self.scrollView = nil
        end
        self:createListView()
        self:onSelectAddClick(self.curIndex)

    end

    local function wsMenuClick()
        for k,v in pairs(self.iconMenuTable) do
            v:setVisible(false)
            v:removeAllChildren()
        end
        self.type = 3
        getAudioManager():playEffectPage()
        self.TYPE_TYPE = self.TYPE_WS_VIEW
        self:changeView()
    end

    local function menuAddClickA()
        self.curIndex = 1
        self:onSelectAddClick(1)
    end

    local function menuAddClickB()
        self.curIndex = 2
        self:onSelectAddClick(2)
        groupCallBack(GuideGroupKey.BTN_SECOND_SLOT)
    end

    local function menuAddClickC()
        self.curIndex = 3
        self:onSelectAddClick(3)
        groupCallBack(GuideGroupKey.BTN_THIRD_SLOT)
    end

    local function menuAddClickD()
        self.curIndex = 4
        self:onSelectAddClick(4)
        --stepCallBack(G_GUIDE_20086)
    end

    local function menuAddClickE()
        self.curIndex = 5
        self:onSelectAddClick(5)
    end

    local function menuAddClickF()
        self.curIndex = 6
        self:onSelectAddClick(6)
    end

    local function equipClickA()
        self:showSelectEquipmenatView(1)
    end

    local function equipClickB()

        self:showSelectEquipmenatView(2)
    end

    local function equipClickC()

        self:showSelectEquipmenatView(3)
    end

    local function equipClickD()

        self:showSelectEquipmenatView(4)
    end

    local function equipClickE()

        self:showSelectEquipmenatView(5)
    end

    local function equipClickF()

        self:showSelectEquipmenatView(6)
    end

    local function cheerSelectSoliderCallBackA()

        self:showSelectCheerHeroView(1)
    end

    local function cheerSelectSoliderCallBackB()

        self:showSelectCheerHeroView(2)
    end

    local function cheerSelectSoliderCallBackC()

        self:showSelectCheerHeroView(3)
    end

    local function cheerSelectSoliderCallBackD()

        self:showSelectCheerHeroView(4)
    end

    local function cheerSelectSoliderCallBackE()

        self:showSelectCheerHeroView(5)
    end

    local function cheerSelectSoliderCallBackF()

        self:showSelectCheerHeroView(6)
    end

    local function backMenuClick()
        getAudioManager():playEffectButton2()

        if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
            if self.minetype == 3 then
                local _exist = getDataManager():getMineData():existMineLineUp()
                if _exist then
                    self:onHideView()
                    return
                end
            else
                self:onHideView()
                return
            end

            local  sure = function()

                getDataManager():getMineData():clearMineGuardRequest()
                getNetManager():getSecretPlaceNet():getMineBaseInfo()
                local _mineGuardRequest =  getDataManager():getMineData():getMineGuardRequest()
                _mineGuardRequest.pos = getDataManager():getMineData():getMapPosition()
                getNetManager():getSecretPlaceNet():guardMine(_mineGuardRequest)
                self:onHideView()
            end

            local cancel = function()
            end

            getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVEmbattle.1"))
        else
            print("==================关闭阵容页面===========================")
            if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20057 then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_20058)
            end
            self:onHideView()
        end

        -- showModuleView(MODULE_NAME_HOMEPAGE)
    end

    local function onCloseClick()
        self.jbSprite:removeAllChildren()
        self.sxSprite:removeAllChildren()
        self.chekLinkLayer:setVisible(false)
        if self.tableView then
            self.tableView:setTouchEnabled(false)
        end
    end

    --查看属性信息
    local function onAttributeClick()
        self.str_type = Localize.query("lineupTypeShow.1")
        self.jbSprite:removeAllChildren()
        self.sxSprite:removeAllChildren()

        local _node = UI_Wujiangjiemianwujianganniu(20,20)
        getAudioManager():playEffectButton2()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
            self.tableView = nil
        end
        if self.chekLinkLayer:isVisible() then
            if self.scrollView then
                self.chekLinkLayer:setVisible(false)
            else
                self.sxSprite:addChild(_node)
            end
            self:createAttrScroll()
            self:createAttributeScollView()
        else
            if self.scrollView then
                self.chekLinkLayer:setVisible(true)
                self.sxSprite:addChild(_node)
            else
                self.chekLinkLayer:setVisible(true)
                 self.sxSprite:addChild(_node)
            end
            self:createAttrScroll()
            self:createAttributeScollView()
        end
        self.lineupHeroType:setString(self.str_type)
        self.lineupSpriteType1:setVisible(true)
        self.lineupSpriteType2:setVisible(false)
    end

    --查看羁绊信息
    local function onLinkIndoClick()
        self.str_type = Localize.query("lineupTypeShow.2")
        self.jbSprite:removeAllChildren()
        self.sxSprite:removeAllChildren()
        local _node = UI_Wujiangjiemianwujianganniu(20,20)
        if self.scrollView ~= nil then
            self.scrollView:removeFromParent(true)
            self.scrollView = nil
        end
        if self.chekLinkLayer:isVisible() then
            if self.tableView then
                self.chekLinkLayer:setVisible(false)
                self.tableView:setTouchEnabled(false)
            else
                self:createListView()
                self:onSelectAddClick(self.curIndex)
                self.jbSprite:addChild(_node)
            end
        else
            if self.tableView then
                self.chekLinkLayer:setVisible(true)
                self:createListView()
                self:onSelectAddClick(self.curIndex)
                self.tableView:setTouchEnabled(true)
            else
                self.chekLinkLayer:setVisible(true)
                self:createListView()
                self:onSelectAddClick(self.curIndex)
            end
            self.jbSprite:addChild(_node)
        end
        self.lineupHeroType:setString(self.str_type)
        self.lineupSpriteType1:setVisible(false)
        self.lineupSpriteType2:setVisible(true)

        --self.tableView:setTouchEnabled(true)

        print("查看羁绊信息 -================- ")
    end
    -- --查看练体
    -- local function onMenuLianti()
    --     print("查看练体 。。。")

    --     local slotItem = self.lineupData:getSlotItemBySeat(self.lastSelectHeroIndex)
    --     if slotItem == nil then
    --         self.tableView:setVisible(false)
    --         return 0
    --     end
    --     local heroPb = slotItem.hero
    --     local soldierId = heroPb.hero_no

    --     getModule(MODULE_NAME_LINEUP):showUIView("PVSoldierChain", soldierId)
    --     stepCallBack(G_GUIDE_130008)
    -- end
    --提升战力
    local function onbtnSoldierAddPower(event, clickBtn)
        local slotItem = self.lineupData:getSlotItemBySeat(self.lastSelectHeroIndex)
        if slotItem == nil then
            self.tableView:setVisible(false)
            return 0
        end
        local heroPb = slotItem.hero
        local soldierId = heroPb.hero_no

        getOtherModule():showOtherView("PVPromoteForce", soldierId, clickBtn)
        groupCallBack(GuideGroupKey.BTN_UP_ATTACK)
    end

    --查看符文
    local function onMenuFuwen()
        local attribute = self.c_StoneTemplate:getAttriStrByType(1)
        self.c_runeNet:sendBagRunes()
        local slotItem = self.lineupData:getSlotItemBySeat(self.lastSelectHeroIndex)
        if slotItem == nil then
            self.tableView:setVisible(false)
            return 0
        end
        local heroPb = self.sodierData:getSoldierDataById(slotItem.hero.hero_no)
        --当前武将符文相关信息的初始化

        self.c_runeData:setCurSoliderId(heroPb.hero_no)

        self.c_runeData:setSoldierRune(heroPb.runt_type)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRunePanel", heroPb.hero_no)
        -- print("onMenuFuwen----------")

    end

    --一键装备
    local function onekeyChangeEquipments()
        local _stageId = self.baseTemp:getEquUpgradeOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            local _equipsData = self:sortOriginPower()
            -- print("-----onekeyChangeEquipments-----",#_equipsData.equs)
            -- table.print(self._newEquipsIdList)
            -- print("-----onekeyChangeEquipments-----",#_equipsData.equs)
            -- table.print(self._oldEquipsIdList)
            local _isChangeEqu = false
            for i = 1,6 do
                if self._newEquipsIdList[i] ~= self._oldEquipsIdList[i] then
                    _isChangeEqu = true
                    break
                end
            end

            if _isChangeEqu then
                ----装备ble.print(_equipsData)
                self.c_LineUpNet:sendChangeMultiEquipmentMsg(_equipsData)
            else
                groupCallBack(GuideGroupKey.BTN_EQUIPMENT)
                getOtherModule():showAlertDialog(nil, Localize.query("pvLineUp.oneKeyEquipEmpty"))
            end
        else
            getStageTips(_stageId)
            return
        end


    end    

    -- 一键装备强化
    local function btnAllEquStrengthOnClick()
        
        local _equip_ids = self.lineupData:getEquipIds(self.lastSelectHeroIndex)
        local equipData = {}
        local _isHaveEqu = false
        for k,v in pairs(_equip_ids) do
            if k < 5 then
                if v ~= "" then
                    local _equipData = self.c_EquipmentData:getEqu(v)
                    table.insert(equipData,_equipData)
                    _isHaveEqu = true
                end
            end
        end

        local function comp1(a,b)
            if a ~= nil and b ~= nil then
                if a.strengthen_lv < b.strengthen_lv then 
                    return true 
                elseif a.strengthen_lv == b.strengthen_lv then 
                    if tonumber(a.prefix) > tonumber(b.prefix) then 
                        return true
                    end
                end 
            elseif a ~= nil and b == nil then 
                return true 
            elseif a == nil and b ~= nil then 
                return false 
            end
        end
        if _isHaveEqu then
            table.sort( equipData, comp1 )
            local _equipData = equipData[1]
            local _equLevel = _equipData.strengthen_lv
            local _maxLevel = self.c_CommonData:getLevel()
            if _equLevel < _maxLevel then
                local _needMoney = self.c_equipTemp:getStengthMoneyById(_equipData.no, _equLevel)
                local _curr_coin = self.c_CommonData:getCoin()
                print("-----_needMoney-----_curr_coin---------",_needMoney,_curr_coin)
                if _needMoney <= _curr_coin then
                    self.c_LineUpNet:sendEquipStrength(self.lastSelectHeroIndex)
                else
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.10"))
                end
            else
                getOtherModule():showAlertDialog(nil, Localize.query("lineupTips.1"))
            end 
        else
            getOtherModule():showAlertDialog(nil, Localize.query("lineupTips.1"))
        end
    end

    -- 驻守
    local function onZhuShouClick()
        local _isHaveHero = false
        local _heroNos = self.secretPlaceData:getMineGuardHeroNos()
        for k,v in pairs(_heroNos) do
            if v ~= 0 and v ~= nil then
                _isHaveHero = true
                break
            end
        end

        if _isHaveHero == false then
            local  sure = function()
                getDataManager():getMineData():clearMineGuardRequest()
                local _mineGuardRequest =  self.secretPlaceData:getMineGuardRequest()
                _mineGuardRequest.pos = self.secretPlaceData:getMapPosition()
                getNetManager():getSecretPlaceNet():guardMine(_mineGuardRequest)
                self:onHideView()
            end
            local cancel = function()
            end
            getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVEmbattle.1"))
        else
            _stage_id = self.secretPlaceData:getStageID()
            _fromType = self.fromType

            groupCallBack(GuideGroupKey.BTN_UP_ATTACK)

            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", _stage_id, _fromType)
        end
    end

    self.UILineUpView["UILineUpView"] = {}
    self.UILineUpView["UILineUpView"]["soldierMenuClick"] = soldierMenuClick
    self.UILineUpView["UILineUpView"]["cheerMenuClick"] = cheerMenuClick
    self.UILineUpView["UILineUpView"]["wsMenuClick"] = wsMenuClick

    self.UILineUpView["UILineUpView"]["menuAddClickA"] = menuAddClickA
    self.UILineUpView["UILineUpView"]["menuAddClickB"] = menuAddClickB
    self.UILineUpView["UILineUpView"]["menuAddClickC"] = menuAddClickC
    self.UILineUpView["UILineUpView"]["menuAddClickD"] = menuAddClickD
    self.UILineUpView["UILineUpView"]["menuAddClickE"] = menuAddClickE
    self.UILineUpView["UILineUpView"]["menuAddClickF"] = menuAddClickF

    self.UILineUpView["UILineUpView"]["equipClickA"] = equipClickA
    self.UILineUpView["UILineUpView"]["equipClickB"] = equipClickB
    self.UILineUpView["UILineUpView"]["equipClickC"] = equipClickC
    self.UILineUpView["UILineUpView"]["equipClickD"] = equipClickD
    self.UILineUpView["UILineUpView"]["equipClickE"] = equipClickE
    self.UILineUpView["UILineUpView"]["equipClickF"] = equipClickF

    self.UILineUpView["UILineUpView"]["cheerSelectSoliderCallBackA"] = cheerSelectSoliderCallBackA
    self.UILineUpView["UILineUpView"]["cheerSelectSoliderCallBackB"] = cheerSelectSoliderCallBackB
    self.UILineUpView["UILineUpView"]["cheerSelectSoliderCallBackC"] = cheerSelectSoliderCallBackC
    self.UILineUpView["UILineUpView"]["cheerSelectSoliderCallBackD"] = cheerSelectSoliderCallBackD
    self.UILineUpView["UILineUpView"]["cheerSelectSoliderCallBackE"] = cheerSelectSoliderCallBackE
    self.UILineUpView["UILineUpView"]["cheerSelectSoliderCallBackF"] = cheerSelectSoliderCallBackF

    self.UILineUpView["UILineUpView"]["backMenuClick"] = backMenuClick
    self.UILineUpView["UILineUpView"]["onLinkIndoClick"] = onLinkIndoClick
    self.UILineUpView["UILineUpView"]["onMenuLianti"] = onMenuLianti
    self.UILineUpView["UILineUpView"]["onMenuFuwen"] = onMenuFuwen
    self.UILineUpView["UILineUpView"]["onAttributeClick"] = onAttributeClick
    self.UILineUpView["UILineUpView"]["onbtnSoldierAddPower"] = onbtnSoldierAddPower
    self.UILineUpView["UILineUpView"]["btnAllEquOnClick"] = onekeyChangeEquipments
    self.UILineUpView["UILineUpView"]["onZhuShouClick"] = onZhuShouClick
    self.UILineUpView["UILineUpView"]["onCloseClick"] = onCloseClick
    self.UILineUpView["UILineUpView"]["btnAllEquStrengthOnClick"] = btnAllEquStrengthOnClick

end

--获得该座位是否有人坐
function PVLineUp:getIsSeated(seat)

    for k, v in pairs(self.selectSoldierData) do
        local tempSeat = v.slot_no
        if tempSeat == seat then

            local hero = self.sodierData:getSoldierDataById(v.hero.hero_no)

            if v.hero.hero_no ~= 0 and hero ~= nil then
                return true
            else
                return false
            end
        end
    end
end

--
function PVLineUp:updateOtherView()
    local heroData = nil
    local heroData2 = nil
    if self.fromType then
        print("PVLineUp:updateOtherView self.fromType:"..self.fromType)
    end 

    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _hero_no = self.secretPlaceData:getSlotItemBySeat(self.lastSelectHeroIndex)
        heroData = self.secretPlaceData:getHeroDataBySlot(self.lastSelectHeroIndex)
        print("---------_hero_no-----------",_hero_no)
        if _hero_no ~= nil then
            print("_hero_no==".._hero_no)
            heroData = self.lineupData:getSlotItemBySeatfromSoldierData(_hero_no)
            if heroData == nil then
                heroData = self.secretPlaceData:getHeroDataBySlot(self.lastSelectHeroIndex)
                if heroData == nil then
                    heroData = {hero_no = 0}
                end
            end
            print("==========heroData============")
            table.print(heroData)
        else
            heroData = {hero_no = 0}
        end

        -- heroData = self.lineupData:getSlotItemBySeatfromSoldierData(_hero_no)
        -- 下一个英雄大图
        local _nextHeroIndex = nil
        if self.lastSelectHeroIndex == self.maxOpenIndex then
            _nextHeroIndex = 1
        else
            _nextHeroIndex = self.lastSelectHeroIndex + 1
        end
      
        local _hero_no2 = self.secretPlaceData:getSlotItemBySeat(_nextHeroIndex)
        if _hero_no2 ~= nil then
            heroData2 = self.lineupData:getSlotItemBySeatfromSoldierData(_hero_no2)
            if heroData2 == nil then
                heroData2 = self.secretPlaceData:getHeroDataBySlot(_nextHeroIndex)
                if heroData2 == nil then
                    heroData2 = {hero_no = 0}
                end
            end
        else 
            heroData2 = {hero_no = 0}
        end
    else
        -- 下一个英雄位置
        local _nextHeroIndex = nil
        if self.TYPE_TYPE == self.TYPE_SOLDIER_VIEW then --武将页面
            if self.lastSelectHeroIndex == 6 then  -- self.maxOpenIndex
                _nextHeroIndex = 1
            else
                _nextHeroIndex = self.lastSelectHeroIndex + 1
            end
            heroData = self.lineupData:getSlotItemBySeat(self.lastSelectHeroIndex)
            heroData2 = self.lineupData:getSlotItemBySeat(_nextHeroIndex)
        elseif self.TYPE_TYPE == self.TYPE_CHEER_VIEW then  -- 助威页面
            self:updateCheerHeroIconLight(self.lastSelectCheerHeroIndex)
            if self.lastSelectCheerHeroIndex == 6 then   --self.maxOpenIndex
                _nextHeroIndex = 1
            else
                _nextHeroIndex = self.lastSelectCheerHeroIndex + 1
            end
            heroData = self.lineupData:getSlotCheerItemBySeat(self.lastSelectCheerHeroIndex)
            heroData2 = self.lineupData:getSlotCheerItemBySeat(_nextHeroIndex)
        end
    end


    if heroData == nil then
        cclog("error:cant find the heroData by self.lastSelectHeroIndex===" .. self.lastSelectHeroIndex)
        return
    end

    local heroPB = nil
    local heroPB2 = nil
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        heroPB = heroData
        heroPB2 = heroData2
    else
        heroPB = heroData.hero
        heroPB2 = heroData2.hero
    end

    local heroId = nil
    local heroId2 = nil
    if heroPB == nil then
        heroId = 0
    else
        heroId = heroPB.hero_no
    end
    if heroPB2 == nil then
        heroId2 = 0
    else
        heroId2 = heroPB2.hero_no
    end

    -- local heroId = heroPB.hero_no
    -- local heroId2 = heroPB2.hero_no

    local level = heroPB.level
    local break_level = heroPB.break_level

    -- self.imgHeroBg:setVisible(false)
    --更新英雄大图
    local _time = 0.3
    local _time2 = 0.1

    if self._heroId ~= nil and self.moveType ~= 0 then
        local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(self._heroId)
        if heroImageNode == nil then
        else
            self.heroNode:getParent():removeChildByTag(1000001)
            self.heroNode:getParent():addChild(heroImageNode, 1000001)

            self.heroNode:stopActionByTag(10000)
            self.heroNode:stopActionByTag(10001)

            heroImageNode:setPosition(cc.p(280, 518))
            heroImageNode:setOpacity(255)
            local _node1 = heroImageNode:getChildByTag(1)
            local _node2 = heroImageNode:getChildByTag(2)
            if _node1 ~= nil then  _node1:setOpacity(100) end
            if _node2 ~= nil then  _node2:setOpacity(100) end

            local moveTo = cc.MoveTo:create(_time, cc.p(100, 300))
            if self.moveType == 1 then
                moveTo = cc.MoveTo:create(_time, cc.p(100, 300))
            elseif  self.moveType ==  2 then
                moveTo = cc.MoveTo:create(_time, cc.p(534, 712))
            end
            local fadeOutAction = cc.FadeOut:create(_time)
            local fadeOutAction1 = cc.FadeOut:create(_time)
            local fadeOutAction2 = cc.FadeOut:create(_time)
            moveTo:setTag(10000)
            fadeOutAction:setTag(10001)
            fadeOutAction1:setTag(10002)
            fadeOutAction2:setTag(10003)
            heroImageNode:runAction(moveTo)
            heroImageNode:runAction(fadeOutAction)
            if _node1 ~= nil then _node1:runAction(fadeOutAction1) end
            if _node2 ~= nil then _node2:runAction(fadeOutAction2) end
        end
    end

    self._heroId = heroPB.hero_no

    self.heroNode:removeAllChildren()
    self.heroNode2:removeAllChildren()
    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    if heroId ~= 0 then           -- 11111大图
        self.sodierData:loadHeroImage(heroId)
        local heroImageNode = self.c_SoldierTemplate:getHeroBigImageById(heroId)
        self.heroNode:addChild(heroImageNode)
        if self.moveType == 0 then
        else
            self.heroNode:stopActionByTag(10001)
            self.heroNode:stopActionByTag(10002)
            local _node1 = heroImageNode:getChildByTag(1)
            local _node2 = heroImageNode:getChildByTag(2)
            self.heroNode:setScale(0.9)
            heroImageNode:setOpacity(100)
            if _node1 ~= nil then  _node1:setOpacity(100) end
            if _node2 ~= nil then  _node2:setOpacity(100) end

            if self.moveType ==  1 then
                self.heroNode:setPosition(cc.p(534, 712))
            elseif self.moveType ==  2 then
                self.heroNode:setPosition(cc.p(0, 0))
            end

            local moveTo = cc.MoveTo:create(_time, cc.p(280, 518))
            local scaleTo = cc.ScaleTo:create(_time, 1.3)
            local fadeInAction = cc.FadeIn:create(_time)
            local fadeInAction1 = cc.FadeIn:create(_time)
            local fadeInAction2 = cc.FadeIn:create(_time)
            moveTo:setTag(10001)
            scaleTo:setTag(10002)
            fadeInAction:setTag(10003)
            fadeInAction1:setTag(10004)
            fadeInAction2:setTag(10005)
            self.heroNode:runAction(moveTo)
            self.heroNode:runAction(scaleTo)
            heroImageNode:runAction(fadeInAction)
            if _node1 ~= nil then _node1:runAction(fadeInAction1) end
            if _node2 ~= nil then _node2:runAction(fadeInAction2) end
        end

        self.moveType = 0
        self.soldierXinxiNode:setVisible(true)
        self.starAndNameNode:setVisible(true)
        self.addSoldierNode:setVisible(false)

    else
        self.soldierXinxiNode:setVisible(false)
        self.starAndNameNode:setVisible(false)
        self.addSoldierNode:setVisible(true)
    end
    if heroId2 ~= 0 then          -- 下一个英雄大图
        self.sodierData:loadHeroImage(heroId2)
        local heroImageNode2 = self.c_SoldierTemplate:getHeroBigImageById(heroId2)
        self.heroNode2:addChild(heroImageNode2)
        local _node1 = heroImageNode2:getChildByTag(1)
        local _node2 = heroImageNode2:getChildByTag(2)
        if _node1 ~= nil then  _node1:setOpacity(100) end
        if _node2 ~= nil then  _node1:setOpacity(100) end
        heroImageNode2:setOpacity(100)
    end

    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    print("--------heroId------",heroId)
    if heroId == 0 then  self:showEmptyView() return end

    self:updateAttribute(heroId, level, break_level)   --更新属性

    local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(heroId)
    local quality = soldierTemplateItem.quality

    local breakStr = "" .. break_level
    if break_level>0 then
        self.breakLvBg:setVisible(true)
        self.breakLvBg:setSpriteFrame(self:updateBreakLv(break_level))
    else
        self.breakLvBg:setVisible(false)
    end

    updateStarLV(self.starTable, quality) --更新星级

    local nameStr = self.c_SoldierTemplate:getHeroName(heroId)
    local _nameLen, t = stringLen(nameStr)
    -- local _name_type = nameStr .. self.str_type
    local _heroName = nameStr
    if #t == 2 then
        _heroName = string.format(t[1]) .. " " .. string.format(t[2])
    end
    self.lineupHeroName:setString(_heroName)  --羁绊界面武将名称
    self.lineupHeroType:setString(self.str_type)
    
    if #t == 2 then
        nameStr = string.format(t[1]) .. "\n\n" .. string.format(t[2])
    end
    self.heroNameLabel:setString(nameStr)   --武将名称

    local _color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
    self.heroNameLabel:setColor(_color)
    self.lineupHeroName:setColor(_color)
    -- local _soldierData = self.sodierData:getSoldierDataById(heroId)

    -- self.levelNumLabel:setString(string.format(level))          --武将等级
    local levelNode = getLevelNode(level)
    self.levelNumLabel:removeAllChildren()
    self.levelNumLabel:addChild(levelNode)
    --self.menuLianti:setVisible(true)
    --self.menuFuwen:setVisible(true)
    self.menuAddPower:setVisible(true)
    self.btnAllEqu:setVisible(true)

    local _type = soldierTemplateItem.job
    local strType = getHeroTypeName(_type)
    print("------strType------",strType)
    self.heroTypeBMLabel:setString(strType)  --英雄职业
    -- self.heroTypeBMLabel:setVisible(true)
    self.typeSprite:setVisible(true)
    local jobId = self.c_SoldierTemplate:getHeroTypeId(heroId)
    local _spriteJob = nil
    print("----jobId-----",jobId)
     if jobId == 1 then              -- 1：猛将
        _spriteJob = "ui_comNew_kind_001.png"
    elseif jobId == 2 then          -- 2：禁卫
        _spriteJob = "ui_comNew_kind_002.png"
    elseif jobId == 3 then          -- 3：游侠
        _spriteJob = "ui_comNew_kind_003.png"
    elseif jobId == 4 then          -- 4：谋士
        _spriteJob = "ui_comNew_kind_004.png"
    elseif jobId == 5 then          -- 5：方士
        _spriteJob = "ui_comNew_kind_005.png"
    end
   
    self.typeSprite:setSpriteFrame(_spriteJob)
    if self.TYPE_TYPE == self.TYPE_SOLDIER_VIEW then --武将页面
        --更新英雄icon等级 装备等级
        self:updateHeroIcon()
        self:updateSoldierEquipment() --更新显示装备
    end

end

function PVLineUp:updateBreakLv(level)
    local _img = "ui_lineup_number1.png"
    if level == 1 then
    elseif level == 2 then
        _img = "ui_lineup_number2.png"
    elseif level == 3 then
        _img = "ui_lineup_number3.png"
    elseif level == 4 then
        _img = "ui_lineup_number4.png"
    elseif level == 5 then
        _img = "ui_lineup_number5.png"
    elseif level == 6 then
        _img = "ui_lineup_number6.png"
    elseif level == 7 then
        _img = "ui_lineup_number7.png"
    elseif level == 8 then
        _img = "ui_lineup_number8.png"
    elseif level == 9 then
        _img = "ui_lineup_number9.png"
    end

    return _img
end

--清除属性
function PVLineUp:clearAttribute(heroId, level, break_level)

    self.hpLabel:setString("0")
    self.powerLabel:setString("0")
    self.physicalDefLabel:setString("0")
    self.magicDefLabel:setString("0")

    for k,v in pairs(self.linkLabel) do
        v:setVisible(false)
    end
    if self.tableView then
        self.tableView:setTouchEnabled(false)
    end
    self.linkInfoMenuItem:setEnabled(false)
    self.zhushouMenuitem:setEnabled(false)
end

--更新属性
function PVLineUp:updateAttribute(heroId, level, break_level)
     local attr = nil
     if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        if self.minetype ~= 3 then
            self:closeMenuTouch() 
        end 
        -- local _hero_no = self.secretPlaceData:getSlotItemBySeat(self.curIndex)
        -- local _hero_nos = self.secretPlaceData:getMineGuardHeroNos()
        -- local _hero = getDataManager():getSoldierData():getSoldierDataById(_hero_no)
        -- local _hero = nil
        -- if self.minetype == 3 then
        --     local _hero_no = self.secretPlaceData:getSlotItemBySeat(self.curIndex)
        --     local _hero_nos = self.secretPlaceData:getMineGuardHeroNos()
        --     print("---------_hero_nos---------")
        --     table.print(_hero_nos)
        --     _hero = getDataManager():getSoldierData():getSoldierDataById(_hero_no)
        -- else
        --     _hero = self.secretPlaceData:getHeroDataBySlot(self.curIndex)
        -- end
        -- -- local _hero = self.secretPlaceData:getHeroDataBySlot(self.curIndex)

        -- local slotItem = {slot_no = self.curIndex, hero = _hero,equs = {}}
        -- for i = 1,6 do
        --    local _equipId = self.secretPlaceData:getEquipDataSeat(self.curIndex, i)
        --    if _equipId ~= "" then
        --        local _equipData = self.c_EquipmentData:getEquipById(_equipId)
        --        if _equipData ~= nil then
        --            if _equipData.id == _equipId then
        --                 local _equip = { no = i,equ = _equipData}
        --                 table.insert(slotItem.equs,_equip)
        --            end 
        --        end
        --     end
        -- end
        -- local slot = {}
        -- table.insert(slot,slotItem)

        local _lineUP = self.secretPlaceData:getLineUp()
        -- if _lineUP.slot.hero == nil then
        --     -- print("-----_lineUP.slot.hero-> nil -----")
        --     -- table.print(slot)
        --     _lineUP.slot = slot
        -- else
        --     if _lineUP.slot.hero.hero_no ~= _hero.hero_no then
        --         -- print("-----_lineUP.slot.hero-----")
        --         -- table.print(slot)
        --         if _lineUP.slot.slot_no == self.curIndex then
        --             _lineUP.slot = slot
        --         end
        --     end
        -- end
        -- print("-------_lineUP-----")
        -- table.print(_lineUP)
        self.c_Calculation:setLineUpData(_lineUP)
        attr = self.c_Calculation:SoldierLineUpAttr(self.curIndex)
        self.c_Calculation:resetLineUpData()
        print("-----attr-------")
        table.print(attr)
     else
        attr = self.c_Calculation:SoldierLineUpAttr(self.curIndex)
     end
     self.hpLabel:setString(string.format(roundAttriNum(attr.hpArray)))
     self.powerLabel:setString(string.format(roundAttriNum(attr.atkArray)))
     self.physicalDefLabel:setString(string.format(roundAttriNum(attr.physicalDefArray)))
     self.magicDefLabel:setString(string.format(roundAttriNum(attr.magicDefArray)))
end

function PVLineUp:setColorByIsOpenCheerLink(item, label)
    for _k,_v in pairs(self.linkItemTable) do
        if _v.link == item.link then
            -- label:setColor(ui.COLOR_GREEN)
            break
        end
    end
end

--创建羁绊列表
function PVLineUp:createListView()
    cclog("--------查看羁绊信息-----@@@@@@@------")
    local function tableCellTouched(table, cell)
        print("cell touched at index: " .. cell:getIdx())
        g_curIndex = self.curIndex
        local _idx = cell:getIdx()
        local _trigger = self.cheerDiscriptions[_idx + 1].trigger
        local _typeId = self.cheerDiscriptions[_idx + 1].typeId
        getModule(MODULE_NAME_LINEUP):showUITopShowLastView("PVSoldierGetType", _trigger, _typeId)
    end

    local function numberOfCellsInTableView(table)
        return self.size
    end

    local function cellSizeForTable(table, idx)
        local __strLen,_t = stringLen(self.cheerDiscriptions[idx + 1].dis)
        local __strLen = #_t 
        print("-----strLen1111-------",__strLen)
        if __strLen > ONELINE_MAX_NUM then
            if idx > 0 then
                local __strLen1,_t1 = stringLen(self.cheerDiscriptions[idx].dis)
                local __strLen1 = #_t1 
                if __strLen1 > ONELINE_MAX_NUM then
                    return  self.itemSize.height+25,self.itemSize.width
                else
                    return  self.itemSize.height,self.itemSize.width
                end
            else
                return  self.itemSize.height,self.itemSize.width
            end
            -- return  self.itemSize.height,self.itemSize.width
        else
            if idx > 0 then
                local __strLen1,_t1 = stringLen(self.cheerDiscriptions[idx].dis)
                local __strLen1 = #_t1 
                if __strLen1 > ONELINE_MAX_NUM then
                    return  self.itemSize.height+20,self.itemSize.width
                else
                    return  self.itemSize.height,self.itemSize.width
                end
            else
                return  self.itemSize.height-10,self.itemSize.width
            end 
        end
        -- return  self.itemSize.height+20,self.itemSize.width
    end

    local function tableCellAtIndex(tab, idx)
        local cell = nil --tab:dequeueCell()
        local label = nil
        local _strLen,t = stringLen(self.cheerDiscriptions[idx + 1].dis)
        local strLen = table.nums(t)
        if nil == cell then
            cell = cc.TableViewCell:new()

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UILinkItem"] = {}
            local node = CCBReaderLoad("lineup/ui_link_item1.ccbi", proxy, cell.cardinfo)
            local layer = cell.cardinfo["UILinkItem"]["layer"]
            local descLabel = cell.cardinfo["UILinkItem"]["descLabel"]

            cell:addChild(node)
        end

        local discriptionLab = cell.cardinfo["UILinkItem"]["discriptionLab"]
        local linkTypeNme = cell.cardinfo["UILinkItem"]["linkTypeNameLabel"]
        local linkbg = cell.cardinfo["UILinkItem"]["linkbg"]
        local linkTypeName1 = cell.cardinfo["UILinkItem"]["linkTypeName1"]
        local linkTypeName2 = cell.cardinfo["UILinkItem"]["linkTypeName2"]

        -- local linkSprite = cell.cardinfo["UILinkItem"]["lineSprite"]
        discriptionLab:setDimensions(585,0)
        if self.type == 1 then
            local _posX, _posY = discriptionLab:getPosition()
            discriptionLab:setPosition(cc.p(_posX, _posY))  --35
            -- local _posX, _posY = linkTypeNme:getPosition()
            -- linkTypeNme:setPosition(cc.p(_posX - 80, _posY))
        elseif self.type == 2 then
            local _posX, _posY = discriptionLab:getPosition()
            discriptionLab:setPosition(cc.p(_posX, _posY))
        end
        discriptionLab:setString(self.cheerDiscriptions[idx + 1].dis)
        discriptionLab:setColor(ui.COLOR_GREY)
        -- print("----羁绊ID-----",self.cheerDiscriptions[idx + 1].typeId)

        local _color = self:getLinkColor(self.cheerDiscriptions[idx + 1])
        discriptionLab:setColor(_color)
        if self.cheerDiscriptions[idx + 1].typeId == 1 then
            linkTypeName1:setVisible(true)
            linkTypeName2:setVisible(false)
        elseif self.cheerDiscriptions[idx + 1].typeId == 2 then
            linkTypeName1:setVisible(false)
            linkTypeName2:setVisible(true)
        end
        return cell
    end


    local tempTable = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("lineup/ui_link_item1.ccbi", proxy, tempTable)
    local sizeLayer = tempTable["UILinkItem"]["sizeLayer"]

    self.itemSize = sizeLayer:getContentSize()
    print("当前选择的类型 ： ================= ", self.TYPE_TYPE)

    self.listLayer:removeChildByTag(10001)
    self.linkDetailLayer:removeChildByTag(10001)

    if self.type ==  1 then
        print("选择武将 -==========-")
        self.layerSize = self.linkDetailLayer:getContentSize()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
            self.tableView = nil
        end
        self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))
        self.linkDetailLayer:addChild(self.tableView)

        local scrBar = PVScrollBar:new()
        scrBar:setTag(10001)
        scrBar:init(self.tableView,1)
        scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
        self.linkDetailLayer:addChild(scrBar,2)
    elseif self.type == 2 then
        print("选择助威 -============-")
        self.layerSize = self.listLayer:getContentSize()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
            self.tableView = nil
        end
        self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))
        self.listLayer:addChild(self.tableView)

        local scrBar = PVScrollBar:new()
        scrBar:setTag(10001)
        scrBar:init(self.tableView,1)
        scrBar:setPosition(cc.p(self.layerSize.width-3,self.layerSize.height/2))
        self.listLayer:addChild(scrBar,2)
    end
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)

    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
end

--创建属性加成列表
function PVLineUp:createAttrScroll()
    if self.scrollView ~= nil then
        self.scrollView:removeFromParent(true)
        self.scrollView = nil
    end
    self.linkDetailLayer:removeChildByTag(10001)
    self.listLayer:removeChildByTag(10001)

    self.scrollView = cc.ScrollView:create()
    local screenSize = nil
    if self.type ==  1 then
        print("选择武将 -==========-")
        if self.scrollView ~= nil then
            screenSize = self.linkDetailLayer:getContentSize()
            self.scrollView:setViewSize(cc.size(screenSize.width, screenSize.height))
            self.scrollView:ignoreAnchorPointForPosition(true)
            self.scrollView:setDirection(1)
            self.scrollView:setClippingToBounds(true)
            self.scrollView:setBounceable(true)
            self.scrollView:setDelegate()
            self.scrollView:updateInset()
            self.scrollView:setContentSize(cc.size(screenSize.width, 840))

        end
        self.linkDetailLayer:addChild(self.scrollView)

        local scrBar = PVScrollBar:new()
        scrBar:init(self.scrollView,1)
        scrBar:setPosition(cc.p(screenSize.width,screenSize.height/2))
        self.linkDetailLayer:addChild(scrBar,2,10001)
    elseif self.type == 2 then
        print("选择助威 -============-")
        if self.scrollView ~= nil then
            screenSize = self.listLayer:getContentSize()
            self.scrollView:setViewSize(cc.size(screenSize.width, screenSize.height))
            self.scrollView:ignoreAnchorPointForPosition(true)
            self.scrollView:setDirection(1)
            self.scrollView:setClippingToBounds(true)
            self.scrollView:setBounceable(true)
            self.scrollView:setDelegate()
            self.scrollView:updateInset()
            self.scrollView:setContentSize(cc.size(screenSize.width, 840))

        end
        self.listLayer:addChild(self.scrollView)

        local scrBar = PVScrollBar:new()
        scrBar:init(self.scrollView,1)
        scrBar:setPosition(cc.p(screenSize.width,screenSize.height/2))
        self.listLayer:addChild(scrBar,2,10001)

    end
end

-- 创建详细属性加成列表
function PVLineUp:createAttributeScollView()
    --触发事件
    -- local function onEquiupdoClick()
    --     -- body
    --     print("----装备----")
    -- end
    local function onLtdoClick()
        -- body
        print("----炼体----")
        local slotItem = self.lineupData:getSlotItemBySeat(self.curIndex)
        if slotItem == nil then
            return 0
        end
        local heroPb = slotItem.hero
        local soldierId = heroPb.hero_no
        getModule(MODULE_NAME_LINEUP):showUIView("PVSoldierChain",soldierId)
    end
    local function onFwdoClick()
        -- body
        print("----符文----"..self.curIndex)
        local slotItem = self.lineupData:getSlotItemBySeat(self.curIndex)
        if slotItem == nil then
            return 0
        end
        local heroPb = slotItem.hero
        local soldierId = heroPb.hero_no
        self.c_runeData = getDataManager():getRuneData()
        self.c_runeData:setCurSoliderId(soldierId)
        --self.c_runeData:setSoldierRunse(heroPb.runt_type)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRunePanel")
    end
    local function onFwzdoClick()
        -- body
        print("----风物志----")
        self:onHideView()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPanel")
    end
    local function onLegiondoClick()
        -- body
        print("----公会----")
        self.c_LegionNet:sendGetLegionInfo()
        self:onHideView()
        getModule(MODULE_NAME_HOMEPAGE):showUINodeView("PVLegionPanel")

    end
    ---menuClick---
    self.lineupAttrNode = {}
    self.lineupAttrNode["UILineupAttributeItem"] = {}
    --self.lineupAttrNode["UILineupAttributeItem"]["onEquiupdoClick"] = onEquiupdoClick
    -- self.lineupAttrNode["UILineupAttributeItem"]["onLtdoClick"] = onLtdoClick
    -- self.lineupAttrNode["UILineupAttributeItem"]["onFwdoClick"] = onFwdoClick
    -- self.lineupAttrNode["UILineupAttributeItem"]["onFwzdoClick"] = onFwzdoClick
    -- self.lineupAttrNode["UILineupAttributeItem"]["onLegiondoClick"] = onLegiondoClick


    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("lineup/ui_lineup_attribute_item.ccbi", proxy, self.lineupAttrNode)

    --属性一览
    local _attrLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrLifeLabel"]
    local _attrAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrAtkLabel"]
    local _attrPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrPdefLabel"]
    local _attrMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrMdefLabel"]
    local _attrHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrHitLabel"]
    local _attrDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrDodgeLabel"]
    local _attrCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrCriLabel"]
    local _attrDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrDuctilityLabel"]
    local _attrCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrCri_hurtLabel"]
    local _attrCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrCri_dedLabel"]
    local _attrBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["attrBlockLabel"]
    --装备
    local _equipLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipLifeLabel"]
    local _equipAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipAtkLabel"]
    local _equipPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipPdefLabel"]
    local _equipMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipMdefLabel"]
    local _equipHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipHitLabel"]
    local _equipDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipDodgeLabel"]
    local _equipCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipCriLabel"]
    local _equipDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipDuctilityLabel"]
    local _equipCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipCri_hurtLabel"]
    local _equipCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipCri_dedLabel"]
    local _equipBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["equipBlockLabel"]
    --炼体
    local _ltLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltLifeLabel"]
    local _ltAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltAtkLabel"]
    local _ltPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltPdefLabel"]
    local _ltMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltMdefLabel"]
    local _ltHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltHitLabel"]
    local _ltDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltDodgeLabel"]
    local _ltCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltCriLabel"]
    local _ltDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltDuctilityLabel"]
    local _ltCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltCri_hurtLabel"]
    local _ltCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltCri_dedLabel"]
    local _ltBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["ltBlockLabel"]
    --符文
    local _fwLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwLifeLabel"]
    local _fwAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwAtkLabel"]
    local _fwPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwPdefLabel"]
    local _fwMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwMdefLabel"]
    local _fwHitLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwHitLabel"]
    local _fwDodgeLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwDodgeLabel"]
    local _fwCriLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwCriLabel"]
    local _fwDuctilityLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwDuctilityLabel"]
    local _fwCri_hurtLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwCri_hurtLabel"]
    local _fwCri_dedLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwCri_dedLabel"]
    local _fwBlockLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwBlockLabel"]
    --风物志
    local _fwzLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzLifeLabel"]
    local _fwzAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzAtkLabel"]
    local _fwzPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzPdefLabel"]
    local _fwzMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["fwzMdefLabel"]
    --公会
    local _legionLifeLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionLifeLabel"]
    local _legionAtkLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionAtkLabel"]
    local _legionPdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionPdefLabel"]
    local _legionMdefLabel = self.lineupAttrNode["UILineupAttributeItem"]["legionMdefLabel"]
    --
    local _arrowSprite = self.lineupAttrNode["UILineupAttributeItem"]["arrowSprite"]
    local seqAction = cc.Sequence:create({cc.MoveBy:create(0.3,cc.p(0,-10)),cc.MoveBy:create(0.3,cc.p(0,10))})
    _arrowSprite:runAction(cc.RepeatForever:create(seqAction))

    ---------label显示---------
    local slotItem = nil
    local heroPb = nil
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then  -- 符文秘境进来的
        local _hero_no = self.secretPlaceData:getSlotItemBySeat(self.curIndex)
        if _hero_no == nil then
            return
        end
        print("_hero_no==".._hero_no)
        -- local _slotItem = self.lineupData:getSlotItemBySeatfromSoldierData(_hero_no)
        local _slotItem = self.secretPlaceData:getHeroDataBySlot(self.curIndex)
        if _slotItem == nil then
            return 0
        end
        heroPb = _slotItem
        local _lineUP = self.secretPlaceData:getLineUp()
        self.c_Calculation:setLineUpData(_lineUP)
    -- end
    else
        slotItem = self.lineupData:getSlotItemBySeat(self.curIndex)
        if slotItem == nil or slotItem.hero == nil then
            return 0
        end
        heroPb = slotItem.hero
    end
    local soldierId = heroPb.hero_no
    local hero = self.sodierData:getSoldierDataById(soldierId)
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        hero = self.secretPlaceData:getHeroDataBySlot(self.curIndex)
    end

    if hero == nil then return 0 end

    print("soldierId=====" .. soldierId)
    local _abc = math.floor
    --属性一览
    local attr = nil
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
       local _hero_no = self.secretPlaceData:getSlotItemBySeat(self.curIndex)
       local _hero_nos = self.secretPlaceData:getMineGuardHeroNos()
       -- local _hero = getDataManager():getSoldierData():getSoldierDataById(_hero_no)
       local _hero = self.secretPlaceData:getHeroDataBySlot(self.curIndex)
       local _mine_line_up_slot = self.secretPlaceData:getMineGuardRequestHeros()
       slotItem = {hero = _hero,equs = {}}
       for i = 1,6 do
           local _equipId = self.secretPlaceData:getEquipDataSeat(self.curIndex, i)
           if _equipId ~= "" then
               local _equipData = self.c_EquipmentData:getEquipById(_equipId)
               if _equipData ~= nil then
                    if _equipData.id == _equipId then
                        local _equip = { no = i,equ = _equipData}
                        table.insert(slotItem.equs,_equip)
                   end
               end
            end
       end
       attr = self.c_Calculation:SoldierLineUpAttr(self.curIndex)
    else
       attr = self.c_Calculation:SoldierLineUpAttr(self.curIndex)
    end
    _attrLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(attr.hpArray)))
    if attr.hpArray > 0 then
        _attrLifeLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrLifeLabel:setColor(ui.COLOR_GREY)
    end
    _attrAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(attr.atkArray)))
    if attr.atkArray > 0 then
        _attrAtkLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrAtkLabel:setColor(ui.COLOR_GREY)
    end
    _attrPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(attr.physicalDefArray)))
    if attr.physicalDefArray > 0 then
        _attrPdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrPdefLabel:setColor(ui.COLOR_GREY)
    end
    _attrMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(attr.magicDefArray)))
    if attr.magicDefArray > 0 then
        _attrMdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrMdefLabel:setColor(ui.COLOR_GREY)
    end
    _attrHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(attr.hitArray)))
    if attr.hitArray > 0 then
        _attrHitLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrHitLabel:setColor(ui.COLOR_GREY)
    end
    _attrDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(attr.dodgeArray)))
    if attr.dodgeArray > 0 then
        _attrDodgeLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrDodgeLabel:setColor(ui.COLOR_GREY)
    end
    _attrCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(attr.criArray)))
    if attr.criArray > 0 then
        _attrCriLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrCriLabel:setColor(ui.COLOR_GREY)
    end
    _attrDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(attr.ductilityArray)))
    if attr.ductilityArray > 0 then
        _attrDuctilityLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrDuctilityLabel:setColor(ui.COLOR_GREY)
    end
    _attrCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(attr.criCoeffArray)))
    if attr.criCoeffArray > 0 then
        _attrCri_hurtLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _attrCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(attr.criDedCoeffArray )))
    if attr.criDedCoeffArray > 0 then
        _attrCri_dedLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrCri_dedLabel:setColor(ui.COLOR_GREY)
    end
    _attrBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(attr.blockArray )))
    if attr.blockArray > 0 then
        _attrBlockLabel:setColor(ui.COLOR_ORANGE)
    else
        _attrBlockLabel:setColor(ui.COLOR_GREY)
    end
    --装备
    --local line_up_slot = self.c_LineupData:getSelectSoldierBySlotNo(self.curIndex)

    local hero = self.sodierData:getSoldierDataById(soldierId)
    
    -- local hero = self.sodierData:getSoldierDataById(soldierId)

    local self_attr = self.c_Calculation:SoldierSelfAttr(hero)
    local equ_attr = self.c_Calculation:EquAttr(slotItem, self_attr)
    _equipLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(equ_attr.hp)))
    if equ_attr.hp > 0 then
        _equipLifeLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipLifeLabel:setColor(ui.COLOR_GREY)
    end
    _equipAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(equ_attr.atk)))
    if equ_attr.atk > 0 then
        _equipAtkLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipAtkLabel:setColor(ui.COLOR_GREY)
    end
    _equipPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(equ_attr.physicalDef)))
    if equ_attr.physicalDef > 0 then
        _equipPdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipPdefLabel:setColor(ui.COLOR_GREY)
    end
    _equipMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(equ_attr.magicDef)))
    if equ_attr.magicDef > 0 then
        _equipMdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipMdefLabel:setColor(ui.COLOR_GREY)
    end
    _equipHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(equ_attr.hit)))
    if equ_attr.hit > 0 then
        _equipHitLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipHitLabel:setColor(ui.COLOR_GREY)
    end
     _equipDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(equ_attr.dodge)))
    if equ_attr.dodge > 0 then
        _equipDodgeLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipDodgeLabel:setColor(ui.COLOR_GREY)
    end
     _equipCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(equ_attr.cri)))
    if equ_attr.cri > 0 then
        _equipCriLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipCriLabel:setColor(ui.COLOR_GREY)
    end
    _equipDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(equ_attr.ductility)))
    if equ_attr.ductility > 0 then
        _equipDuctilityLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipDuctilityLabel:setColor(ui.COLOR_GREY)
    end
    _equipCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(equ_attr.criCoeff)))
    if equ_attr.criCoeff > 0 then
        _equipCri_hurtLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _equipCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(equ_attr.criDedCoeff)))
    if equ_attr.criDedCoeff > 0 then
        _equipCri_dedLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipCri_dedLabel:setColor(ui.COLOR_GREY)
    end
     _equipBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(equ_attr.block)))
    if equ_attr.block > 0 then
        _equipBlockLabel:setColor(ui.COLOR_ORANGE)
    else
        _equipBlockLabel:setColor(ui.COLOR_GREY)
    end
    --炼体
    local chain_attr = self.c_SoldierTemplate:getAllAttribute(hero.refine)
    _ltLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(chain_attr.hp)))
    if chain_attr.hp > 0 then
        _ltLifeLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltLifeLabel:setColor(ui.COLOR_GREY)
    end
    _ltAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(chain_attr.atk)))
    if chain_attr.atk > 0 then
        _ltAtkLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltAtkLabel:setColor(ui.COLOR_GREY)
    end
    _ltPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(chain_attr.physicalDef)))
    if chain_attr.physicalDef > 0 then
        _ltPdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltPdefLabel:setColor(ui.COLOR_GREY)
    end
    _ltMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(chain_attr.magicDef)))
    if chain_attr.magicDef > 0 then
        _ltMdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltMdefLabel:setColor(ui.COLOR_GREY)
    end
    _ltHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(chain_attr.hit)))
    if chain_attr.hit > 0 then
        _ltHitLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltHitLabel:setColor(ui.COLOR_GREY)
    end
    _ltDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(chain_attr.dodge)))
    if chain_attr.dodge > 0 then
        _ltDodgeLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltDodgeLabel:setColor(ui.COLOR_GREY)
    end
    _ltCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(chain_attr.cri)))
    if chain_attr.cri > 0 then
        _ltCriLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltCriLabel:setColor(ui.COLOR_GREY)
    end
    _ltDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(chain_attr.ductility)))
    if chain_attr.ductility > 0 then
        _ltDuctilityLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltDuctilityLabel:setColor(ui.COLOR_GREY)
    end
     _ltCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(chain_attr.criCoeff)))
    if chain_attr.criCoeff > 0 then
        _ltCri_hurtLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _ltCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(chain_attr.criDedCoeff)))
    if chain_attr.criDedCoeff > 0 then
        _ltCri_dedLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltCri_dedLabel:setColor(ui.COLOR_GREY)
    end
    _ltBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(chain_attr.block)))
    if chain_attr.block > 0 then
        _ltBlockLabel:setColor(ui.COLOR_ORANGE)
    else
        _ltBlockLabel:setColor(ui.COLOR_GREY)
    end
    --符文
    local hero_info = self.c_SoldierTemplate:getHeroTempLateById(hero.hero_no)
    local rune_attr = self.c_Calculation:SoldierRuneAttr(hero, hero_info)
    _fwLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(rune_attr.hp)))
    if rune_attr.hp > 0 then
        _fwLifeLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwLifeLabel:setColor(ui.COLOR_GREY)
    end
    _fwAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(rune_attr.atk)))
    if rune_attr.atk > 0 then
        _fwAtkLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwAtkLabel:setColor(ui.COLOR_GREY)
    end
    _fwPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(rune_attr.physicalDef)))
    if rune_attr.physicalDef > 0 then
        _fwPdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwPdefLabel:setColor(ui.COLOR_GREY)
    end
    _fwMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(rune_attr.magicDef)))
    if rune_attr.magicDef > 0 then
        _fwMdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwMdefLabel:setColor(ui.COLOR_GREY)
    end
    _fwHitLabel:setString(Localize.query("lineupAtt.5")..string.format(self:keepSingleBitNum(rune_attr.hit)))
    if rune_attr.hit > 0 then
        _fwHitLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwHitLabel:setColor(ui.COLOR_GREY)
    end
    _fwDodgeLabel:setString(Localize.query("lineupAtt.6")..string.format(self:keepSingleBitNum(rune_attr.dodge)))
    if rune_attr.dodge > 0 then
        _fwDodgeLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwDodgeLabel:setColor(ui.COLOR_GREY)
    end
    _fwCriLabel:setString(Localize.query("lineupAtt.7")..string.format(self:keepSingleBitNum(rune_attr.cri)))
    if rune_attr.cri > 0 then
        _fwCriLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwCriLabel:setColor(ui.COLOR_GREY)
    end
    _fwDuctilityLabel:setString(Localize.query("lineupAtt.8")..string.format(self:keepSingleBitNum(rune_attr.ductility)))
    if rune_attr.ductility > 0 then
        _fwDuctilityLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwDuctilityLabel:setColor(ui.COLOR_GREY)
    end
    _fwCri_hurtLabel:setString(Localize.query("lineupAtt.9")..string.format(self:keepSingleBitNum(rune_attr.criCoeff)))
    if rune_attr.criCoeff > 0 then
        _fwCri_hurtLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwCri_hurtLabel:setColor(ui.COLOR_GREY)
    end
    _fwCri_dedLabel:setString(Localize.query("lineupAtt.10")..string.format(self:keepSingleBitNum(rune_attr.criDedCoeff)))
    if rune_attr.criDedCoeff > 0 then
        _fwCri_dedLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwCri_dedLabel:setColor(ui.COLOR_GREY)
    end
    _fwBlockLabel:setString(Localize.query("lineupAtt.11")..string.format(self:keepSingleBitNum(rune_attr.block)))
    if rune_attr.block > 0 then
        _fwBlockLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwBlockLabel:setColor(ui.COLOR_GREY)
    end
    --风物志
    local travel_attr = self.c_Calculation:TravelAttr()
    _fwzLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(travel_attr.hp)))
    if travel_attr.hp > 0 then
        _fwzLifeLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwzLifeLabel:setColor(ui.COLOR_GREY)
    end
    _fwzAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(travel_attr.atk)))
    if travel_attr.atk > 0 then
        _fwzAtkLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwzAtkLabel:setColor(ui.COLOR_GREY)
    end
    _fwzPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(travel_attr.physicalDef)))
    if travel_attr.physicalDef > 0 then
        _fwzPdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwzPdefLabel:setColor(ui.COLOR_GREY)
    end
    _fwzMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(travel_attr.magicDef)))
    if travel_attr.magicDef > 0 then
        _fwzMdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _fwzMdefLabel:setColor(ui.COLOR_GREY)
    end
    --公会
    local _legionLevel = 0
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then  -- 符文秘境进来的
        local _lineUP = self.secretPlaceData:getLineUp()
        if _lineUP.guild_level ~= nil then
            _legionLevel = _lineUP.guild_level
        end
    else
        _legionLevel = getDataManager():getLegionData():getLegionLevel()
    end
    -- local _legionLevel = getDataManager():getLegionData():getLegionLevel()
    local legion_attr = self.c_Calculation:LegionAttr(_legionLevel)
    _legionLifeLabel:setString(Localize.query("lineupAtt.1")..string.format(self:keepSingleBitNum(legion_attr.hp)))
    if legion_attr.hp > 0 then
        _legionLifeLabel:setColor(ui.COLOR_ORANGE)
    else
        _legionLifeLabel:setColor(ui.COLOR_GREY)
    end
    _legionAtkLabel:setString(Localize.query("lineupAtt.2")..string.format(self:keepSingleBitNum(legion_attr.atk)))
    if legion_attr.atk > 0 then
        _legionAtkLabel:setColor(ui.COLOR_ORANGE)
    else
        _legionAtkLabel:setColor(ui.COLOR_GREY)
    end
    _legionPdefLabel:setString(Localize.query("lineupAtt.3")..string.format(self:keepSingleBitNum(legion_attr.physicalDef)))
    if legion_attr.physicalDef > 0 then
        _legionPdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _legionPdefLabel:setColor(ui.COLOR_GREY)
    end
    _legionMdefLabel:setString(Localize.query("lineupAtt.4")..string.format(self:keepSingleBitNum(legion_attr.magicDef)))
    if legion_attr.magicDef > 0 then
        _legionMdefLabel:setColor(ui.COLOR_ORANGE)
    else
        _legionMdefLabel:setColor(ui.COLOR_GREY)
    end

    self.scrollView:addChild(node)
    self.scrollView:setContentOffset(cc.p(0, self.scrollView:minContainerOffset().y))
end

function PVLineUp:createWSList()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_common2.plist")

    local function tableCellTouched(tab, cell)
        print("cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
        return table.nums(self.wsList)
    end
    local function cellSizeForTable(tab, idx)
        return 142, 555
    end
    local function tableCellAtIndex(tab, idx)
        local cell = nil --tab:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local function selectMenuClick()
                getModule(MODULE_NAME_LINEUP):showUIViewAndInTop("PVWSDetailPage", self.wsList[idx+1].id)
                groupCallBack(GuideGroupKey.BTN_UPGRADE)
            end
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISelectWSItem"] = {}
            cell.cardinfo["UISelectWSItem"]["selectMenuClick"] = selectMenuClick
            local node = CCBReaderLoad("lineup/ui_lineup_ws_item.ccbi", proxy, cell.cardinfo)
            cell:addChild(node)

            cell.menu = cell.cardinfo["UISelectWSItem"]["menu"]
            cell.menu2 = cell.cardinfo["UISelectWSItem"]["menu2"]
            cell.labelDes = cell.cardinfo["UISelectWSItem"]["desc"]
            cell.nodeState = cell.cardinfo["UISelectWSItem"]["node_state"]
            cell.iconImg = cell.cardinfo["UISelectWSItem"]["img_ws"]
            cell.levelLabel = cell.cardinfo["UISelectWSItem"]["label_lv"]

            cell.richText = self:getAllPremiseName(self.wsList[idx+1].id)
            cell.nodeState:addChild(cell.richText)
        end

        local wsItem = self.wsList[idx+1]
        local _icon = self.c_ResourceTemplate:getResourceById(wsItem.icon)
        local _description = self.c_LanguageTemplate:getLanguageById(wsItem.discription)
        local _wsLevel = self.lineupData:getWSLevel(wsItem.id)
        cell.labelDes:setString(_description)

        cell.levelLabel:removeAllChildren()
        local levelNode = getLevelNode(tostring(_wsLevel))
        cell.levelLabel:addChild(levelNode)
        -- cell.levelLabel:setString(tostring(_wsLevel))

        print("res/icon/ws/====".._icon)

        game.setSpriteFrame(cell.iconImg, "res/icon/ws/".._icon)
        if wsItem.isActive then   -- 升级
            cell.menu:setVisible(true)
            cell.menu2:setVisible(false)
        else  -- 查看
            cell.menu:setVisible(false)
            cell.menu2:setVisible(true)
        end

        return cell
    end

    self.wsTableView = cc.TableView:create(self.wslayer:getContentSize())
    self.wsTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.wsTableView:setDelegate()
    self.wsTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.wslayer:addChild(self.wsTableView)

    self.wsTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.wsTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.wsTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.wsTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.wsTableView,1)
    scrBar:setPosition(cc.p(self.wslayer:getContentSize().width-5,self.wslayer:getContentSize().height/2))
    self.wslayer:addChild(scrBar,2)

    self.wsTableView:reloadData()
    self:tableViewItemAction(self.wsTableView)
end

--无双是否激活
function PVLineUp:getSoldierIsActivity(soldierId)
    local selectSoldier = self.lineupData:getSelectSoldier()

    for k, v in pairs(selectSoldier) do
        if v.hero.hero_no == soldierId then
            return true
        end
    end
    return false
end

--获取激活条件
function PVLineUp:getAllPremiseName(wsId)

    local richtext = ccui.RichText:create()
    richtext:setAnchorPoint(cc.p(0,0.5))

    local nameId = self.c_InstanceTemplate:getWSInfoById(wsId).name
    local wsName = self.c_LanguageTemplate:getLanguageById(nameId)

    local re0 = ccui.RichElementText:create(1, ui.COLOR_WHITE, 255, wsName, "res/ccb/resource/miniblack.ttf", 25)
    richtext:pushBackElement(re0)

    local re1 = ccui.RichElementText:create(1, ui.COLOR_MISE, 255, Localize.query("wushuang.1"), "res/ccb/resource/miniblack.ttf", 22)
    richtext:pushBackElement(re1)

    local condition = {}
    local v = self.c_InstanceTemplate:getWSInfoById(wsId)
    if v.condition1 ~= 0 then table.insert(condition, v.condition1) end
    if v.condition2 ~= 0 then table.insert(condition, v.condition2) end
    if v.condition3 ~= 0 then table.insert(condition, v.condition3) end
    if v.condition4 ~= 0 then table.insert(condition, v.condition4) end
    if v.condition5 ~= 0 then table.insert(condition, v.condition5) end
    if v.condition6 ~= 0 then table.insert(condition, v.condition6) end
    if v.condition7 ~= 0 then table.insert(condition, v.condition7) end

    local count = table.nums(condition)

    for k,v in pairs(condition) do
        local _nameId = self.c_SoldierTemplate:getHeroTempLateById(v).nameStr
        local _nameStr = self.c_LanguageTemplate:getLanguageById(_nameId)
        local color = ui.COLOR_GREY
        if self:getSoldierIsActivity(v) then -- v is soldierId
            color = ui.COLOR_YELLOW
        end
        local re1 = ccui.RichElementText:create(1, color, 255, _nameStr, "res/ccb/resource/miniblack.ttf", 22)
        richtext:pushBackElement(re1)

        if k ~= count then
            local re2 = ccui.RichElementText:create(1, ui.COLOR_GREY, 255, Localize.query("wushuang.2"), "res/ccb/resource/miniblack.ttf", 22)
            richtext:pushBackElement(re2)
        end
    end
    local rend = ccui.RichElementText:create(1, ui.COLOR_MISE, 255, Localize.query("wushuang.3"), "res/ccb/resource/miniblack.ttf", 22)
    richtext:pushBackElement(rend)

    return richtext
end

function PVLineUp:getLinkColor(LinkDataItem, label)

    local _color = ui.COLOR_YELLOW --ui.COLOR_GREEN
    local _isGreen = true
    for _k,_v in pairs(LinkDataItem.trigger) do

        if not self:isExistsSelectSoldierData(_v) and not self:isExistsCheerSoldierData(_v) then
            _color = ui.COLOR_GREY
            _isGreen = false
            break
        end
    end

    if _isGreen == false then
        _color = ui.COLOR_YELLOW  --ui.COLOR_GREEN
        -- table.print(LinkDataItem.trigger)
        for _k,_v in pairs(LinkDataItem.trigger) do
            if not self:isExistsEquipmentData(_v) then
                 _color = ui.COLOR_GREY
                break
            end
        end
    end

    return _color
end


function PVLineUp:showSelectHeroView()
    self.lastSelectType = TYPE_SELECT_HERO
    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _seatState = self.secretPlaceData:getIsSeated(self.curIndex)
        if _seatState then
            local soldierId = self.secretPlaceData:getSlotItemBySeat(self.curIndex)
            local _heroData = self.secretPlaceData:getHeroDataBySlot(self.curIndex) 
            -- print("-------soldierId-----",soldierId)
            -- table.print(_heroData)
            if soldierId ~= nil and soldierId ~= 0 then
                if self.minetype == 3 then
                    getOtherModule():showOtherView("PVLineUpCheck", soldierId,TYPE_SELECT_HERO, self.fromType, 1)
                    -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", soldierId, 1, TYPE_SELECT_HERO, self.fromType) 
                else
                    getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", _heroData.hero_no, 10, _heroData.level, true, _heroData.break_level)
                end
            else
                if self.minetype == 3 then
                    getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_HERO, self.fromType) 
                end
            end
        else
            if self.minetype == 3 then
                getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_HERO, self.fromType) 
            end
        end
    else
        if self.TYPE_TYPE == self.TYPE_SOLDIER_VIEW then --武将页面
            local _seatState = self:getIsSeated(self.curIndex)
            if _seatState then
                local slotItem = self.lineupData:getSlotItemBySeat(self.curIndex)
                if slotItem ~= nil then
                    local heroPb = slotItem.hero
                    local soldierId = heroPb.hero_no
                    if soldierId ~= 0 then
                        getOtherModule():showOtherView("PVLineUpCheck", soldierId, TYPE_SELECT_HERO, self.fromType, 1)
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", soldierId, 1, TYPE_SELECT_HERO, self.fromType)
                    end
                end
            else
               getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_HERO, self.fromType)
            end
        elseif self.TYPE_TYPE == self.TYPE_CHEER_VIEW then  -- 助威页面
            local _seatState = self.lineupData:getCheerIsOpenBySeat(self.lastSelectCheerHeroIndex)
            self.lastSelectType = TYPE_SELECT_CHEER_HERO
            if _seatState then
                local slotItem = self.lineupData:getSlotCheerItemBySeat(self.lastSelectCheerHeroIndex)
                if slotItem ~= nil then
                    print("--------TYPE_CHEER_VIEW--------",self.lastSelectCheerHeroIndex)
                    local heroPb = slotItem.hero
                    local soldierId = heroPb.hero_no
                    if soldierId ~= 0 then
                        getOtherModule():showOtherView("PVLineUpCheck", soldierId, TYPE_SELECT_CHEER_HERO, self.fromType, 1)
                        -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", soldierId, 1, TYPE_SELECT_CHEER_HERO, self.fromType)
                    else
                        getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_CHEER_HERO)
                    end
                else
                    print("--------TYPE_CHEER_VIEW--------nil",self.lastSelectCheerHeroIndex)
                    getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_CHEER_HERO)
                end
            end
        end
    end
    -- print("----showSelectHeroView--------")
    --getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_HERO, self.fromType)
end

function PVLineUp:showSelectCheerHeroView(seat)
    self.addSoldierNode:setVisible(false)
    self.soldierXinxiNode:setVisible(true)
    self.starAndNameNode:setVisible(true)
    print("seat="..seat)
    self.lastSelectCheerHeroIndex = seat
    self:updateOtherView()
    -------------------------
    -- local CheerSoldier = self.lineupData:getCheerSoldier()
    --  getAudioManager():playEffectButton2()
    -- local isCheerSeatOpen = self.lineupData:getCheerIsOpenBySeat(seat)
    -- if isCheerSeatOpen then
    --     self.lastSelectCheerHeroIndex = seat
    --     self.lastSelectType = TYPE_SELECT_CHEER_HERO
    --     local slotCheerItem = self.lineupData:getSlotCheerItemBySeat(seat)
    --     if slotCheerItem ~= nil then
    --         local heroPb = slotCheerItem.hero
    --         local soldierId = heroPb.hero_no
    --         if soldierId ~= 0 then
    --             getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", soldierId, 1, TYPE_SELECT_CHEER_HERO, self.fromType)
    --         else
    --             getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_CHEER_HERO)
    --         end
    --     else
    --         getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_CHEER_HERO)
    --     end
    --     --getModule(MODULE_NAME_LINEUP):showUIView("PVSelectSoldier", TYPE_SELECT_CHEER_HERO)
    -- end
end

function PVLineUp:showSelectEquipmenatView(seat)
    --if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then return end
    local _stageId = self.baseTemp:getEquUpgradeOpenStage()
    local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
    if _isOpen then
        cclog("self.lastSelectHeroIndex＝＝"..self.lastSelectHeroIndex)

        local isInSeated = 0
        if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
            isInSeated = self.secretPlaceData:getIsSeated(self.lastSelectHeroIndex)
        else
            isInSeated = self:getIsSeated(self.lastSelectHeroIndex)
        end

        if not isInSeated then
            -- self:toastShow(Localize.query("lineup.5"))
            getOtherModule():showAlertDialog(nil, Localize.query("lineup.5"))
            return
        end

        self.lastSelectType = TYPE_SELECT_EQUIP
        self.lastSelectEquipSeat = seat

        local equipId = 0
        if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
            equipId = self.secretPlaceData:getEquipDataSeat(self.lastSelectHeroIndex, seat)
        else
            equipId = self.lineupData:getEquipDataSeat(self.lastSelectHeroIndex, seat)
        end

        if equipId ~= "" and equipId ~= 0 then --如果装备位上有装备,则跳到装备属性页面
            local equipPB = self.c_EquipmentData:getEquipById(equipId)
            getOtherModule():showOtherView("PVLineUpCheck", equipPB,seat, nil, 2)
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipPB, 1, seat)
            --如果槽位上有装备则直接点击强化按钮
            --[[if getNewGManager():getCurrentGid()==GuideId.G_GUIDE_40027 then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_40029)
            end
            groupCallBack(GuideGroupKey.BTN_QIANGHUA_EQUIPMENT)]]--
            groupCallBack(GuideGroupKey.BTN_EQUIP_DETAIL)
        else  --如果装备位上没有装备
            -- getModule(MODULE_NAME_LINEUP):showUIView("PVSelectEquipment", seat, self.fromType)
            -- groupCallBack(GuideGroupKey.BTN_EQUIPMENT_SLOT)
            if self.minetype == 3 or self.minetype == nil then
                getModule(MODULE_NAME_LINEUP):showUIView("PVSelectEquipment", seat, self.fromType)
                groupCallBack(GuideGroupKey.BTN_EQUIPMENT_SLOT) 
            else
                return
            end          
        end
    else
        getStageTips(_stageId)
        return
    end

end

--更新武将头像底框
function PVLineUp:updateHeroIconLight(idx)
    for k,v in pairs(self.iconMenuTable) do
        if k == idx then
            v:removeAllChildren()
            v:setVisible(true)
            -- local node = UI_Wujiangbuzhenxuanze()
            local node = UI_Wujiangjiemiantouxiang()
            v:addChild(node)
        else
            v:setVisible(false)
            v:removeAllChildren()
        end
    end
end

--更新助威武将头像底框
function PVLineUp:updateCheerHeroIconLight(idx)
    local isOpen = self.lineupData:getCheerIsOpenBySeat(idx)
    for k,v in pairs(self.cheerIconMenuTable) do
        if k == idx and isOpen then
            v:removeAllChildren()
            v:setVisible(true)
            local node = UI_Wujiangjiemiantouxiang()
            v:addChild(node)
        else
            v:setVisible(false)
            v:removeAllChildren()
        end
    end
end

function PVLineUp:onReloadCallBack(_type, data)
    if data == -1 or data == nil then
        return
    end

    cclog("self.lastSelectHeroIndex="..self.lastSelectHeroIndex)
    cclog("data="..data)

    if self.fromType == FROM_TYPE_MINE or self.fromType == FROM_TYPE_MINE_CHANGE_LINEUP then
        print("_type11111",_type)
        if _type == TYPE_SELECT_HERO then
            self.secretPlaceData:setMineGuardRequest(self.lastSelectHeroIndex, data)
            self:updateHeroIcon()
            self:updateSelectSoldierLinkView(self.lastSelectHeroIndex)  --更新武将羁绊
            self:updateOtherView()

        elseif _type == TYPE_SELECT_EQUIP then
            self.secretPlaceData:setHeroEquip(self.lastSelectHeroIndex, self.lastSelectEquipSeat, data)
            self:updateSoldierEquipment()
            self:updateSelectSoldierLinkView(self.lastSelectHeroIndex)  --更新武将羁绊
            self:updateOtherView()
        end
    else
        print("_type1222",_type)
        if _type == TYPE_SELECT_HERO then
            self.c_LineUpNet:sendChangeHeroMsg(self.lastSelectHeroIndex, data)
        elseif _type == TYPE_SELECT_CHEER_HERO then
            self.c_LineUpNet:sendChangeCheerHeroMsg(self.lastSelectCheerHeroIndex, data)

        elseif _type == TYPE_SELECT_EQUIP then
            self.c_LineUpNet:sendChangeEquipmentMsg(self.lastSelectHeroIndex, self.lastSelectEquipSeat, data)

        end
    end
end

--返回更新
function PVLineUp:onReloadView()
    print("xxxxx",self.lastSelectType)
    if self.lastSelectType ~= -1 then  --更新选择英雄

        local data = self.funcTable[1]
        -- if data == -1 or data == nil then   -- 101  是无双界面关闭时候传过来的
        --     self.linkInfoMenuItem:setEnabled(true)
        --     self.zhushouMenuitem:setEnabled(true)
        -- else
            self.linkInfoMenuItem:setEnabled(true)
            self.zhushouMenuitem:setEnabled(true)
        -- end

        if data ~= 101 then
            self:onReloadCallBack(self.lastSelectType, data)
        end
    end

    if self.wsTableView then
        self:updateWSListData()
     end

    cclog("onReloadView ...")

    if self.funcTable[1] ~= 101 then
        self:updateOtherView()
    end
end

function PVLineUp:closeMenuTouch()
    self.equipMenuA:setEnabled(false)
    self.equipMenuB:setEnabled(false)
    self.equipMenuC:setEnabled(false)
    self.equipMenuD:setEnabled(false)
    self.equipMenuE:setEnabled(false)
    self.equipMenuF:setEnabled(false)
end

--装备原始战力排序,然后取原始战力最高装备
function PVLineUp:sortOriginPower()
    self._oldEquipsIdList = {}
    self._newEquipsIdList = {}
    local _equipData = {}
    _equipData.equs = {}
    table.insert(_equipData,equs)
    local _equipmentData = self.c_EquipmentData:getEquipList()
    for k, v in pairs(_equipmentData) do
        v.originPower = self.c_Calculation:SingleOriginEquCombatPower(v)
    end
    local function cmp1(a,b)
        if a.id ~= nil and b.id ~= nil then
            local _equipOriginPowerA = a.originPower  --self.c_Calculation:SingleOriginEquCombatPower(a.id)
            local _equipOriginPowerB = b.originPower --self.c_Calculation:SingleOriginEquCombatPower(b.id)
            if _equipOriginPowerA > _equipOriginPowerB then return true end
        end
    end
    for i = 1, 6 do
        local _equipmentListTemp = string.format("_equipmentList%d",i)
        local _equipmentIdTemp = string.format("_equipmentId%d",i)
        local _equipmentTemp = string.format("_equipment%d",i)
        local _equipIdTemp = string.format("_equipId%d",i)
        local _equipTemp = string.format("_equip%d",i)
        local _DataTemp = string.format("_Data%d",i)
        local _equipmentListTemp = self.lineupData:getChangeEquip(i)
        local _equipmentIdTemp = self.lineupData:getEquipDataSeat(self.lastSelectHeroIndex, i)
        if _equipmentIdTemp ~= nil then
            local _equipmentTemp = self.c_EquipmentData:getEquipById(_equipmentIdTemp)
            table.insert(_equipmentListTemp,_equipmentTemp)
            if _equipmentIdTemp == "" then _equipmentIdTemp = 0 end
            table.insert(self._oldEquipsIdList,_equipmentIdTemp)

        else
            table.insert(self._oldEquipsIdList,0)
        end

        table.sort(_equipmentListTemp,cmp1)
        local _equipIdTemp = 0
        local _equipTemp = table.getValueByIndex(_equipmentListTemp,1)
        if _equipTemp ~= nil then _equipIdTemp = _equipTemp.id end
        local _DataTemp = {slot_no = self.lastSelectHeroIndex, no = i, equipment_id = _equipIdTemp}
        table.insert(_equipData.equs,_DataTemp)
        table.insert(self._newEquipsIdList,_equipIdTemp)
    end
    return _equipData
end

function PVLineUp:clearResource()
    cclog("--------clearResource-----")
    -- self.sodierData:clearHeroImagePlist()

    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")
end

function PVLineUp:keepSingleBitNum(num)
    return math.floor(num * 10) / 10
end

return PVLineUp
