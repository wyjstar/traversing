--装备主页面
-- local PVScrollBar = import("..scrollbar.PVScrollBar")
local PVEquipmentMain = class("PVEquipmentMain", BaseUIView)


function PVEquipmentMain:ctor(id)
    PVEquipmentMain.super.ctor(self, id)
    self.TYPE_ALL_SELECTED = 1
    self.TYPE_NOT_ALL_SELECTED = 2
    self.TYPE_ALL_NOT_SELECTED = 3

    self.numAdded = 0

    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.equipData = getDataManager():getEquipmentData()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()  -- 中文
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.lineupData = getDataManager():getLineupData()
    self.commonData = getDataManager():getCommonData()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.stageData = getDataManager():getStageData()

    -- 注册网络回调
    self:registerNetCallback()

    -- 清下选择的熔炼物品
    -- self.equipData:setSmeltIDs({})
end

function PVEquipmentMain:onExit()
    -- self:unregisterScriptHandler()

    getDataManager():getResourceData():clearResourcePlistTexture()
end

function PVEquipmentMain:onMVCEnter()
    self:initBaseUI()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")

    self:showAttributeView()

    self.UIEquipment = {}
    self.currSubMenuIdx = 1

    self:initData()
    self:sortList()

    self:initTouchListener()
    self:loadCCBI("equip/ui_equipment.ccbi", self.UIEquipment)
    self:initView()

    --根据传入的值，跳入对应的章节地图
    if self.goStageId ~= nil then
        self:goTableList(self.goStageId)
    else
        self:firstMenuClick()
    end

    local isCanCom = self.equipData:getIsComEquip()
    self.equip_com_notice:setVisible(isCanCom) 
    print("isCanCom ", isCanCom)
end

function PVEquipmentMain:goTableList( tabIndex )
    self:updateMenuState(tabIndex)
    self:updateSubMenuState(tabIndex)
    -- self:resetSelectSmeltItem() -- 排序后在更新select smelt item
end

function PVEquipmentMain:initData()

    self.goTabIndex = self.funcTable[1]

    self.allEquipments = self.equipData:getEquipList()
    self.allChips = self.equipData:getChipsList()

    -- 将table的结构改成：{[1]={id,..},...}
    self.equipmentTable = {}
    self.equipCanStrengTable = {}
    self.equipmentChips = {}

    -- print("11111111")
    -- table.print(self.allEquipments)
    --table.print(self.allChips)
    -- print("qqqqqqqqqqq")

    -- 初始化数据
    if self.currSubMenuIdx == 1 or self.currSubMenuIdx == nil then
        local index = 1
        for k,v in pairs(self.allEquipments) do
            -- print("## equip no ", v.no)
            local etype = self.equipTemp:getTypeById(v.no)
            self.equipmentTable[index] = v
            index = index + 1
        end
        index = 1
        for k,v in pairs(self.allEquipments) do
            local etype = self.equipTemp:getTypeById(v.no)
            if etype ~= 5 and etype ~= 6 then
                self.equipCanStrengTable[index] = v
                index = index + 1
            end
        end
        index = 1
        for k,v in pairs(self.allChips) do
            local _no = self.chipTemp:getEquipNoById(k)  -- 合成后的装备id
            local etype = self.equipTemp:getTypeById(_no)
            self.equipmentChips[index] = v
            index = index + 1
        end

    else -- 按照类型初始化数据

        local index = 1
        for k,v in pairs(self.allEquipments) do
            local etype = self.equipTemp:getTypeById(v.no)
            self.equipmentTable[index] = v
            index = index + 1
        end
        index = 1
        for k,v in pairs(self.allEquipments) do
            local etype = self.equipTemp:getTypeById(v.no)
            if etype ~= 5 and etype ~= 6 then
                if self.currSubMenuIdx-1 == etype then
                    self.equipCanStrengTable[index] = v
                    index = index + 1
                end
            end
        end
        index = 1
        for k,v in pairs(self.allChips) do
            local _no = self.chipTemp:getEquipNoById(k)
            local etype = self.equipTemp:getTypeById(_no)
            if self.currSubMenuIdx-1 == etype then
                self.equipmentChips[index] = v
                index = index + 1
            end
        end
    end
end

-- 注册Response回调函数
function PVEquipmentMain:registerNetCallback()

    local function responseComposeCallback(id, data)
        print(" ----------- ui response compose ----------")
        -- table.print(data)
        if data.res.result ~= true then
            print("!!! 数据返回错误")
        else
            local _equip = data.equ
            local _useNum = self.chipTemp:getTemplateById(self.request_chipNo).needNum
            self.equipData:subChips(self.request_chipNo, _useNum) -- 在DataCetner中减去消耗掉的碎片

            local function onGotoEquipAttributeView ()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", _equip) --合成了装备，采用跳转到装备详情界面
            end
            onGotoEquipAttributeView()
            -- local equipTemp = getTemplateManager():getEquipTemplate()
            -- local _equipTempItem = equipTemp:getTemplateById(_equip.no)
            -- local equipName = getTemplateManager():getLanguageTemplate():getLanguageById(_equipTempItem.name)
            -- getOtherModule():showAlertDialog(onGotoEquipAttributeView, Localize.query("equip.11")..equipName)
            
        end
    end
    -- local function responseMeltingCallback(id, data)
    --     print(" --------- ui response smelting --------", data)
    --     --显示被溶解后的东西
    --     if data.res.result ~= true then
    --         print("!!! 数据返回错误")
    --         self.menuSmeltShop:setEnabled(true)
    --         self.smeltMenu:setEnabled(true)
    --     else
    --         local function callback()
    --             local _list = self.equipData:getSmeltIDs()
    --             self.equipData:setSmeltIDs({})  -- 情空

    --             local function showDialog()
    --                 if table.nums(_list) ~= 0 then
    --                     SpriteGrayUtil:drawSpriteTextureColor(self.menuSmeltShop:getNormalImage())
    --                     SpriteGrayUtil:drawSpriteTextureColor(self.smeltMenu:getNormalImage())
    --                     SpriteGrayUtil:drawSpriteTextureColor(self.menuOneKeyAdd:getNormalImage())
    --                     self.menuOneKeyAdd:setEnabled(true)
    --                     self.menuSmeltShop:setEnabled(true)
    --                     self.smeltMenu:setEnabled(true)
    --                     getOtherModule():showOtherView("PVEquipmentSmelting", _list, data.cgr)
    --                     -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipmentSmelting", self.melting_equipList, data.cgr)
    --                 end

    --                 for k,v in pairs(_list) do
    --                     local _no = self.equipData:getEquipById(v).no
    --                     self.lineupData:removeEquipOnHero(_no)  -- 阵容上移除装备

    --                     self.equipData:removeEquip(v)  -- 移除后将查不到了，所以先传值显示，再删除
    --                 end
    --             end

    --             -- self.smeltEffectFrame:setVisible(true)
    --             -- self.smeltEffectFrame:setOpacity(255)
    --             -- local action1 = cc.FadeTo:create(0.5, 0)
    --             -- local action2 = cc.CallFunc:create(showDialog)
    --             -- local seq = cc.Sequence:create(action1, action2)
    --             -- self.smeltEffectFrame:runAction(seq)
    --         end

    --         local node = UI_zhuangbeironglian(callback)
    --         self.animationNode:addChild(node)
    --     end
    -- end
    self:registerMsg(EQU_COMPOSE_CODE, responseComposeCallback)
    -- self:registerMsg(EQU_MELTING_CODE, responseMeltingCallback)
end

function PVEquipmentMain:initView()

    self.qitaNode = self.UIEquipment["UIEquipment"]["qita"]
    self.listLayer = self.UIEquipment["UIEquipment"]["listLayer"]
    self.labelItemNum = self.UIEquipment["UIEquipment"]["equip_num"]

    self.menuA = self.UIEquipment["UIEquipment"]["menuA"]  --强化合成等按钮
    self.menuB = self.UIEquipment["UIEquipment"]["menuB"]
    self.menuC = self.UIEquipment["UIEquipment"]["menuC"]
    self.menuD = self.UIEquipment["UIEquipment"]["menuD"]
    self.menuA:setAllowScale(false)
    self.menuB:setAllowScale(false)
    self.menuC:setAllowScale(false)
    self.menuD:setAllowScale(false)
    self.menuD:setVisible(false)
    self.MenuTable = {}
    table.insert(self.MenuTable, self.menuA)
    table.insert(self.MenuTable, self.menuB)
    table.insert(self.MenuTable, self.menuC)
    local img1Nor = self.UIEquipment["UIEquipment"]["equipNor"]
    local img2Nor = self.UIEquipment["UIEquipment"]["strengthNor"]
    local img3Nor = self.UIEquipment["UIEquipment"]["combineNor"]
    local img1Sel = self.UIEquipment["UIEquipment"]["equipSelect"]
    local img2Sel = self.UIEquipment["UIEquipment"]["strengthSelect"]
    local img3Sel = self.UIEquipment["UIEquipment"]["combineSelect"]
    self.MenuTextNor = {}  -- 存菜单的Normal文字图片
    self.MenuTextSel = {}  -- 存菜单的Selected文字图片
    table.insert(self.MenuTextNor, img1Nor)
    table.insert(self.MenuTextNor, img2Nor)
    table.insert(self.MenuTextNor, img3Nor)
    table.insert(self.MenuTextSel, img1Sel)
    table.insert(self.MenuTextSel, img2Sel)
    table.insert(self.MenuTextSel, img3Sel)
    

    self.nodeMenuBottom = self.UIEquipment["UIEquipment"]["botNode"]  --底部一排小按钮的Node，用来控制按钮们是否可见
    self.subMenuA = self.UIEquipment["UIEquipment"]["subMenuA"]       --底部小按钮
    self.subMenuB = self.UIEquipment["UIEquipment"]["subMenuB"]
    self.subMenuC = self.UIEquipment["UIEquipment"]["subMenuC"]
    self.subMenuD = self.UIEquipment["UIEquipment"]["subMenuD"]
    self.subMenuE = self.UIEquipment["UIEquipment"]["subMenuE"]
    self.subMenuF = self.UIEquipment["UIEquipment"]["subMenuF"]
    self.subMenuG = self.UIEquipment["UIEquipment"]["subMenuG"]
    
    self.subMenuA:setScale(0.9)
    self.subMenuB:setScale(0.9)
    self.subMenuC:setScale(0.9)
    self.subMenuD:setScale(0.9)
    self.subMenuE:setScale(0.9)
    self.subMenuF:setScale(0.9)
    self.subMenuG:setScale(0.9)

    self.subMenuTable = {} -- 存子菜单的按钮
    table.insert(self.subMenuTable, self.subMenuA)
    table.insert(self.subMenuTable, self.subMenuB)
    table.insert(self.subMenuTable, self.subMenuC)
    table.insert(self.subMenuTable, self.subMenuD)
    table.insert(self.subMenuTable, self.subMenuE)
    table.insert(self.subMenuTable, self.subMenuF)
    table.insert(self.subMenuTable, self.subMenuG)
    -- self.selectedA = self.UIEquipment["UIEquipment"]["selected1"]       --底部小按钮
    -- self.selectedB = self.UIEquipment["UIEquipment"]["selected2"]
    -- self.selectedC = self.UIEquipment["UIEquipment"]["selected3"]
    -- self.selectedD = self.UIEquipment["UIEquipment"]["selected4"]
    -- self.selectedE = self.UIEquipment["UIEquipment"]["selected5"]
    -- self.selectedF = self.UIEquipment["UIEquipment"]["selected6"]
    -- self.selectedG = self.UIEquipment["UIEquipment"]["selected7"]
    self.subSelectedTable = {}   -- 选中状态
    -- table.insert(self.subMenuTable, self.selectedA)
    -- table.insert(self.subMenuTable, self.selectedB)
    -- table.insert(self.subMenuTable, self.selectedC)
    -- table.insert(self.subMenuTable, self.selectedD)
    -- table.insert(self.subMenuTable, self.selectedE)
    -- table.insert(self.subMenuTable, self.selectedF)
    -- table.insert(self.subMenuTable, self.selectedG)
    self.subNormalTable = {}   -- 选中状态
    for i=1,7 do
        local selected = self.UIEquipment["UIEquipment"][tostring("selected"..i)]
        table.insert(self.subSelectedTable, selected)
        local normal = self.UIEquipment["UIEquipment"][tostring("normal"..i)]
        table.insert(self.subNormalTable, selected)
    end
    self.normal7 = self.UIEquipment["UIEquipment"]["normal7"]
    self.normal6 = self.UIEquipment["UIEquipment"]["normal6"]

    -- self.subMenuA = self.UIEquipment["UIEquipment"]["subMenuA"]       --底部小按钮
    -- self.subMenuB = self.UIEquipment["UIEquipment"]["subMenuB"]
    -- self.subMenuC = self.UIEquipment["UIEquipment"]["subMenuC"]
    -- self.subMenuD = self.UIEquipment["UIEquipment"]["subMenuD"]
    -- self.subMenuE = self.UIEquipment["UIEquipment"]["subMenuE"]
    -- self.subMenuF = self.UIEquipment["UIEquipment"]["subMenuF"]
    -- self.subMenuG = self.UIEquipment["UIEquipment"]["subMenuG"]

    self.nodeNumber = self.UIEquipment["UIEquipment"]["num_node"]   --数量label的Node
    self.equip_com_notice = self.UIEquipment["UIEquipment"]["equip_com_notice"]

    self.tableViewTable = {}  -- 存TablView
    self:createEquipListView()
    self:createStrengListView()
    self:createComposeListView()

    -- self:registerSmeltTouchEvent()
    -- self.ronglianNode = self.UIEquipment["UIEquipment"]["ronglian"]

    self.animationNode = self.UIEquipment["UIEquipment"]["animationNode"]

    local node = UI_ZhuangbeironglianHode()

end

function PVEquipmentMain:subChNoticeState(noticeId, state)
    if noticeId == NOTICE_COM_EQUIP then
        self.equip_com_notice:setVisible(state)
        self:updateSoldierData()
    end
end

--更新上方tab的状态，以及一些table点击事件
function PVEquipmentMain:updateMenuState(index)

    -- 设置currMenuIdx,为 onReloadView 服务
    if index == nil then index = self.currMenuIdx
    else self.currMenuIdx = index
    end

    -- 主菜单变色处理
    local size = table.getn(self.MenuTable)
    for i = 1, size do
        local item = self.MenuTable[i]
        local norImg = self.MenuTextNor[i]
        local selImg = self.MenuTextSel[i]
        if i == index then
            item:setEnabled(false)
            norImg:setVisible(false)
            selImg:setVisible(true)
        else
            item:setEnabled(true)
            norImg:setVisible(true)
            selImg:setVisible(false)
        end
    end

    -- 更新
    self:sortList()
    self:reloadTableView()

    -- 熔炼菜单
    if index == 4 then
        -- self.smeltLayer:setVisible(true)
        self.nodeNumber:setVisible(false)
        -- self.nodeMenuBottom:setPositionY(self.nodeForSmeltingPos:getPositionY())
        self.nodeMenuBottom:setVisible(false)
        self.qitaNode:setVisible(false)
        -- self:updateSmeltView()
    else
        -- self.smeltLayer:setVisible(false)
        self.nodeNumber:setVisible(true)
        -- self.nodeMenuBottom:setPositionY(0)
        self.nodeMenuBottom:setVisible(true)
        self.qitaNode:setVisible(true)
    end

    -- 隐藏5，6类型的装备，如果是在强化的分支下时
    if self.currMenuIdx == 2 then
        self.subMenuF:setVisible(false)
        self.subMenuG:setVisible(false)

        self.subSelectedTable[6]:setVisible(false)   -- 选中状态
        self.subNormalTable[6]:setVisible(false)   -- 选中状态
        self.subSelectedTable[7]:setVisible(false)   -- 选中状态
        self.subNormalTable[7]:setVisible(false)

        self.normal7:setVisible(false)
        self.normal6:setVisible(false)


        if self.currSubMenuIdx == 6 or self.currSubMenuIdx == 7 then
            self:updateSubMenuState(1)
        end
    else
        self.subMenuF:setVisible(true)
        self.subMenuG:setVisible(true)
        self.normal7:setVisible(true)
        self.normal6:setVisible(true)
    end

    self:updateItemNumber()
end

function PVEquipmentMain:getIsEquip(id)
    local _equipedWho = self.lineupData:getEquipTo(id)
    if _equipedWho == Localize.query("equip.1") then
        return 0
    else
        return 1
    end
end

--给装备排序
-- @ param _equipList : 用EquipData中的数据
function PVEquipmentMain:sortList()

    self.c_Calculation = getCalculationManager():getCalculation()

    local function isEquip(id)
        return self:getIsEquip(id)
    end

    local function cmp1(a,b)  -- 已经装配的至于未装配上方 按照等级大>小，品质大>小 降序排序,
        local _isEquipedA = isEquip(a.id)
        local _isEquipedB = isEquip(b.id)

        local _qualityA = self.equipTemp:getQuality(a.no)
        local _qualityB = self.equipTemp:getQuality(b.no)

        local _powerA = self.c_Calculation:SingleEquCombatPower(a)
        local _powerB = self.c_Calculation:SingleEquCombatPower(b)

        if _isEquipedA == _isEquipedB then         --  装备 > 未装备
            if a.prefix == b.prefix then        -- 前缀
                if _qualityA == _qualityB then  -- 星级
                    if _powerA == _powerB then  -- 战力
                        if a.strengthen_lv == b.strengthen_lv then    -- 等级
                            return a.no > b.no
                        else
                            return a.strengthen_lv > b.strengthen_lv
                        end
                    else
                        return _powerA > _powerB
                    end
                else
                    return _qualityA > _qualityB
                end
            else
                return a.prefix > b.prefix
            end
        else
            return _isEquipedA > _isEquipedB
        end
    end

    local function cmp2(a,b)  -- 按照可合成>不可合成，碎片数量大>小 降序排序
        local chipTemplateItemA = self.chipTemp:getTemplateById(a.equipment_chip_no) --装备碎片模板数据
        local _qualityA = self.chipTemp:getTemplateById(a.equipment_chip_no).quality
        local _numA = a.equipment_chip_num       --碎片数目
        local _needA = chipTemplateItemA.needNum                  --合成所需碎片个数
        local chipTemplateItemB = self.chipTemp:getTemplateById(b.equipment_chip_no) --装备碎片模板数据
        local _qualityB = self.chipTemp:getTemplateById(b.equipment_chip_no).quality
        local _numB = b.equipment_chip_num       --碎片数目
        local _needB = chipTemplateItemB.needNum                  --合成所需碎片个数

        local _isCanA = ( _needA <= _numA )
        local _isCanB = ( _needB <= _numB )
        if _isCanA == true and _isCanB == false then
            return true
        elseif _isCanA == false and _isCanB == true then
            return false
        else
            if _qualityA > _qualityB then return true
            else return false end
        end
    end

    table.sort(self.equipmentTable, cmp1)
    table.sort(self.equipCanStrengTable, cmp1)
    table.sort(self.equipmentChips, cmp2)

    local tempFinalPatchData = {}
    for k, v in pairs(self.equipmentChips) do
        local isCanCom = v.isCanCom
        if isCanCom then
            tempFinalPatchData[#tempFinalPatchData + 1] = v
        end
    end
    
    for k, v in pairs(self.equipmentChips) do
        local isCanCom = v.isCanCom
        if isCanCom == false then
            tempFinalPatchData[#tempFinalPatchData + 1] = v
        end
    end
    self.equipmentChips = tempFinalPatchData

end

--更新子tab，进行分类
function PVEquipmentMain:updateSubMenuState(idx)
    self.currSubMenuIdx = idx
    --更新界面
    local size = table.getn(self.subMenuTable)
    for i = 1, size do
        local item = self.subMenuTable[i]
        if i == idx then
            item:setEnabled(false)
            self.subSelectedTable[i]:setVisible(false)
            self.subNormalTable[i]:setVisible(true)
        else
            item:setEnabled(true)
            self.subSelectedTable[i]:setVisible(true)
            self.subNormalTable[i]:setVisible(false)
        end
    end

    --更新数据
    self.equipmentTable = {}
    self.equipCanStrengTable = {}
    self.equipmentChips = {}
    -- self.equipCanSmeltTable = {}
    if idx == 1 then
        local index = 1
        for k,v in pairs(self.allEquipments) do
            local etype = self.equipTemp:getTypeById(v.no)
            self.equipmentTable[index] = v
            index = index + 1
        end
        index = 1
        for k,v in pairs(self.allEquipments) do
            local etype = self.equipTemp:getTypeById(v.no)
            if etype ~= 5 and etype ~= 6 then
                self.equipCanStrengTable[index] = v
                index = index + 1
            end
        end
        index = 1
        for k,v in pairs(self.allChips) do
            self.equipmentChips[index] = v
            index = index + 1
        end
        index = 1
        -- for k,v in pairs(self.allEquipments) do
        --     if self:getIsEquip(v.id) == 0 then
        --         self.equipCanSmeltTable[index] = v
        --         index = index + 1
        --     end
        -- end
    else
        --将所有装备中的选中的类型的装备取出
        local _index = 1
        for k,v in pairs(self.allEquipments) do
            local type = self.equipTemp:getTemplateById(v.no).type
            if type == idx-1 then
                self.equipmentTable[_index] = v
                _index = _index + 1
            end
        end
        --强化
        _index = 1
        for k,v in pairs(self.allEquipments) do
            local type = self.equipTemp:getTemplateById(v.no).type
            if type == idx-1 and type ~= 5 and type ~= 6 then
                self.equipCanStrengTable[_index] = v
                _index = _index + 1
            end
        end
        --将所有装备碎片中的选中的类型的装备碎片取出
        _index = 1
        for k,v in pairs(self.allChips) do
            --先根据chipTemplate由id查出对应equipment的id
            local _no = self.chipTemp:getEquipNoById(k)
            local type = self.equipTemp:getTypeById(_no)
            if type == idx-1 then
                self.equipmentChips[_index] = v
                _index = _index + 1
            end
        end
        _index = 1
        -- for k,v in pairs(self.allEquipments) do
        --     --先根据chipTemplate由id查出对应equipment的id
        --     local type = self.equipTemp:getTemplateById(v.no).type
        --     if type == idx-1 and self:getIsEquip(v.id) == 0 then
        --         self.equipCanSmeltTable[_index] = v
        --         _index = _index + 1
        --     end
        -- end
    end

    --排序
    self:sortList()
    if self.curType ~= 1 then
        self:reloadTableView()
    end

    self:updateItemNumber()

    -- self:resetSelectSmeltItem()
end

function PVEquipmentMain:reloadTableView()
    -- TabelView部件是否显示 以及 更新相应的数据
    for k, v in pairs(self.tableViewTable) do
        if k == self.currMenuIdx then
            cclog("-------------reloadTableView------"..k)
            
            if v ~= nil then 
                v:setVisible(true)
                v:reloadData()
                self:tableViewItemAction(v)
                local layerSize = self.listLayer:getContentSize()
                self.listLayer:removeChildByTag(999)
                local scrBar = PVScrollBar:new()
                scrBar:setTag(999)
                scrBar:init(v,1)
                scrBar:setPosition(cc.p(layerSize.width-3,layerSize.height/2))
                self.listLayer:addChild(scrBar,2)
            end
        else
            v:setVisible(false)
        end
    end
end

function PVEquipmentMain:updateItemNumber()
    -- 更新列表中的数量
    print("------当前currMenuIdx-----" ,self.currMenuIdx)
    if self.currMenuIdx == 3 then
        local _num = table.nums(self.equipmentChips)
        self.labelItemNum:setString(string.format(_num))
    elseif self.currMenuIdx == 2 then
        local _num = table.nums(self.equipCanStrengTable)
        self.labelItemNum:setString(string.format(_num))
    else 
        local _num = table.nums(self.equipmentTable)
        self.labelItemNum:setString(string.format(_num))
    end
end

-- --更新装备熔炼界面的
-- function PVEquipmentMain:updateSmeltView()
--     self.equipSoulNum:setString( self.commonData:getEquipSoul() )

--     local _list = self.equipData:getSmeltIDs()

--     if _list ~= nil then
--         -- table.print(_list)

--         self.numAdded = 0
--         for i=1,8 do
--             local v = _list[i]
--             if v ~= nil then
--                 local equip_no = self.equipData:getEquipById(v).no
--                 local _icon = self.equipTemp:getEquipResIcon(equip_no)  -- 资源名
--                 local _quality = self.equipTemp:getQuality(equip_no)    -- 装备品质
--                 local img = game.newSprite()
--                 changeEquipIconImageBottom(img, _icon, _quality)  -- 设置卡的图片
--                 self.menuAddSmelt[i]:setNormalImage(img)
--                 self.imgAdd[i]:setVisible(false)
--                 self.numAdded = self.numAdded + 1
--             else
--                 local img = game.newSprite("#ui_rune_kuang.png")
--                 self.menuAddSmelt[i]:setNormalImage(img)
--                 self.imgAdd[i]:setVisible(true)
--             end
--         end
--     end

--     if self.numAdded == 8 then
--         SpriteGrayUtil:drawSpriteTextureGray(self.menuOneKeyAdd:getNormalImage())
--         self.menuOneKeyAdd:setEnabled(false)
--     else
--         SpriteGrayUtil:drawSpriteTextureColor(self.menuOneKeyAdd:getNormalImage())
--         self.menuOneKeyAdd:setEnabled(true)
--     end
-- end

-- 首次进入该装备界面时，初始化分页界面
function PVEquipmentMain:firstMenuClick()
    self:updateMenuState(1)
    -- self:updateSubMenuState(1)
end

-- 给界面添加触控事件
function PVEquipmentMain:initTouchListener()

    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
        print("========关闭装备界面==========")
    end

    ---- 装备各种操作 ----
    local function menuClickA()
        getAudioManager():playEffectButton2()
        self:updateMenuState(1)
    end
    local function menuClickB()
        getAudioManager():playEffectButton2()
        
        local _stageId = self.baseTemp:getEquUpgradeOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            self:updateMenuState(2)
        else
            getStageTips(_stageId)
            return
        end
        
    end
    local function menuClickC()
        getAudioManager():playEffectButton2()
        
        local _stageId = self.baseTemp:getEquAssembleOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        -- print("----_isOpen------")
        -- print(_isOpen)
        
        if _isOpen then
            self:updateMenuState(3)
            groupCallBack(GuideGroupKey.BTN_HECHENG_IN_EQUIPMENT)
        else
            getStageTips(_stageId)
            return
        end
    end
    local function menuClickD()
        getAudioManager():playEffectButton2()
        self:updateMenuState(4)
    end

    ---- 分类显示 ----
    local function subMenuClickA()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(1)
    end
    local function subMenuClickB()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(2)
    end
    local function subMenuClickC()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(3)
    end
    local function subMenuClickD()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(4)
    end
    local function subMenuClickE()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(5)
    end
    local function subMenuClickF()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(6)
    end
    local function subMenuClickG()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(7)
    end
    -- local function onOneKeyMenuClick()
    --     getAudioManager():playEffectButton2()
    --     -- self:onAllSmeltSelected()
    --     print("可以再添加的个数 ", self.numAdded)

    --     local _list = {}
    --     local _haveList = self.equipData:getSmeltIDs()
    --     for k,v in pairs(self.allEquipments) do
    --         local etype = self.equipTemp:getTypeById(v.no)
    --         --local fvalue = getCalculationManager():getEquipCalculation():getFightValue(v.id)
    --         local fvalue = self.equipTemp:getQuality(v.no)
    --         local tvalue = self.equipTemp:getTypeById(v.no)
    --         if tvalue == 5 or tvalue == 6 then
    --             fvalue = fvalue + 0.5
    --         end
    --         -- print("@ no, level, value", v.no, v.strengthen_lv, fvalue)
    --         local ishave = true
    --         for _k,_v in pairs(_haveList) do
    --             if v.id == _v then ishave = false; break end
    --         end
    --         if ishave and self:getIsEquip(v.id)==0 then
    --             table.insert(_list, {v.id,v.no,fvalue})
    --         end
    --     end

    --     table.sort(_list, function (a,b) return a[3] < b[3] end)

    --     -- table.print(_list)
    --     local max
    --     if table.nums(_list) < 8 then max = table.nums(_list)
    --     else max = 8-self.numAdded end
    --     for i=1, max do
    --         self.equipData:addSmeltID(_list[i][1])
    --     end


    --     -- self:updateSmeltView()
    -- end

    -- local function addOneEquipToSmelt(posIdx)
    --     print(posIdx)
    --     self.currSelectPos = posIdx
    --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSelectSmeltEquip")
    -- end
    -- local function addKey1() addOneEquipToSmelt(1) end
    -- local function addKey2() addOneEquipToSmelt(2) end
    -- local function addKey3() addOneEquipToSmelt(3) end
    -- local function addKey4() addOneEquipToSmelt(4) end
    -- local function addKey5() addOneEquipToSmelt(5) end
    -- local function addKey6() addOneEquipToSmelt(6) end
    -- local function addKey7() addOneEquipToSmelt(7) end
    -- local function addKey8() addOneEquipToSmelt(8) end
    -- local function oneKeyAdd()
    --     print("one key add ..")
    -- end
    -- local function onEquipmentStore()
    --     print("equipment store ..")
    --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipShop")
        
    -- end
    -- local function onSmeltClick()
    --     print("equipment store ..")
    --     self:smeltMenuClick()
    -- end

    self.UIEquipment["UIEquipment"] = {}
    self.UIEquipment["UIEquipment"]["backMenuClick"] = backMenuClick

    self.UIEquipment["UIEquipment"]["menuClickA"] = menuClickA
    self.UIEquipment["UIEquipment"]["menuClickB"] = menuClickB
    self.UIEquipment["UIEquipment"]["menuClickC"] = menuClickC
    self.UIEquipment["UIEquipment"]["menuClickD"] = menuClickD

    self.UIEquipment["UIEquipment"]["subMenuClickA"] = subMenuClickA
    self.UIEquipment["UIEquipment"]["subMenuClickB"] = subMenuClickB
    self.UIEquipment["UIEquipment"]["subMenuClickC"] = subMenuClickC
    self.UIEquipment["UIEquipment"]["subMenuClickD"] = subMenuClickD
    self.UIEquipment["UIEquipment"]["subMenuClickE"] = subMenuClickE
    self.UIEquipment["UIEquipment"]["subMenuClickF"] = subMenuClickF
    self.UIEquipment["UIEquipment"]["subMenuClickG"] = subMenuClickG

    -- self.UIEquipment["UIEquipment"]["onAddRuneClick1"] = addKey1
    -- self.UIEquipment["UIEquipment"]["onAddRuneClick2"] = addKey2
    -- self.UIEquipment["UIEquipment"]["onAddRuneClick3"] = addKey3
    -- self.UIEquipment["UIEquipment"]["onAddRuneClick4"] = addKey4
    -- self.UIEquipment["UIEquipment"]["onAddRuneClick5"] = addKey5
    -- self.UIEquipment["UIEquipment"]["onAddRuneClick6"] = addKey6
    -- self.UIEquipment["UIEquipment"]["onAddRuneClick7"] = addKey7
    -- self.UIEquipment["UIEquipment"]["onAddRuneClick8"] = addKey8

    -- self.UIEquipment["UIEquipment"]["onOneKeyAdd"] = onOneKeyMenuClick
    -- self.UIEquipment["UIEquipment"]["onInputRuneClick"] = onEquipmentStore
    -- self.UIEquipment["UIEquipment"]["SmeltClick"] = onSmeltClick

end

function PVEquipmentMain:checkSelectState()
    local selectedNum = 0
    local itemNum = 0
    for k, v in pairs(self.selectSmeltingTable) do
        if v.isSelect == true then
            selectedNum = selectedNum + 1
        end
        itemNum = itemNum + 1
    end
    if itemNum == selectedNum then
        return self.TYPE_ALL_SELECTED
    elseif selectedNum == 0 then
        return self.TYPE_ALL_NOT_SELECTED
    else
        return self.TYPE_NOT_ALL_SELECTED
    end
end

--创建装备的列表
function PVEquipmentMain:createEquipListView()

    local function tableCellTouched(tbl, cell)
        print("PVEquipmentMain cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.equipmentTable)
    end
    local function cellSizeForTable(tbl, idx)
        return 145,640
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function detailMenuClick()
                getAudioManager():playEffectButton2()
                local equipment = table.getValueByIndex(self.equipmentTable, cell:getIdx()+1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment)
            end
            local function inheritMenuClick()
                print("选择传承装备")
                local equipment = table.getValueByIndex(self.equipmentTable, cell:getIdx()+1)
                -- table.print(equipment)
                -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment)
            end

            local function onItemClick()
                self.curType = 1
                getAudioManager():playEffectButton2()
                local equipment = table.getValueByIndex(self.equipmentTable, cell:getIdx()+1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment, 2)
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIEquipItem"] = {}
            cell.cardinfo["UIEquipItem"]["strengMenuClick"] = detailMenuClick
            cell.cardinfo["UIEquipItem"]["inheritMenuClick"] = inheritMenuClick
            cell.cardinfo["UIEquipItem"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("equip/ui_equip_equip_item.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIEquipItem"]["headIcon"]
            cell.equipPrefix = cell.cardinfo["UIEquipItem"]["equipPrefix"]
            cell.equipName = cell.cardinfo["UIEquipItem"]["equipName"]
            cell.minor_attr_label = cell.cardinfo["UIEquipItem"]["descripLabel"]
            cell.main_attr_label = cell.cardinfo["UIEquipItem"]["main_attr_label"]
            cell.labelZBY = cell.cardinfo["UIEquipItem"]["label_zby"]
            cell.equipTo = cell.cardinfo["UIEquipItem"]["equipTo"]
            -- cell.menuIcon = cell.cardinfo["UIEquipItem"]["iconMenu"]
            cell.labelLevel = cell.cardinfo["UIEquipItem"]["label_lv"]
            cell.inheritMenu = cell.cardinfo["UIEquipItem"]["inheritMenu"]
            cell.strengMenu = cell.cardinfo["UIEquipItem"]["strengMenu"]
            cell.itemMenuItem = cell.cardinfo["UIEquipItem"]["itemMenuItem"]
            cell.itemMenuItem:setAllowScale(false)
            cell.itemBg = cell.cardinfo["UIEquipItem"]["itemBg"]


            cell:addChild(node)
        end

        cell.index = idx
        -- 获取数据中的值
        local equipData = table.getValueByIndex(self.equipmentTable, idx+1)
        -- print("-----equipData-----")
        -- table.print(equipData)
        -- print("---------",equipData.prefix)
        local equipmentItem = self.equipTemp:getTemplateById(equipData.no)
        local _name = self.languageTemp:getLanguageById(equipmentItem.name)
        local _equipPrefix = equipData.prefix
        local _nameImage = "ui_equip_kind_6"
        if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
        if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
        if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
        if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
        if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
        if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
        -- print(">>>>>>>>>>>>>> _nameImage  " .. _nameImage)
        -- print(">>>>>>>>>>>>>> _equipPrefix  " .. _equipPrefix)
        

        local _equipPrefixRes = _nameImage .. ".png"
        ---------------------------------------------------
        local _descrip = ""
        -- table.print(equipData.main_attr)
        local main_attr = self.c_Calculation:EquMainAttr(equipData)
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then
            print("没有主属性")
        else
            _descrip = _descrip .. main_attr.AttrName.. " +" .. main_attr.Value
        end
        cell.main_attr_label:setString(_descrip)

        --次属性
        local _descrip = ""
        -- table.print(equipData.minor_attr)
        local minor_attr = self.c_Calculation:EquMinorAttr(equipData)
        local ciNum = table.nums(minor_attr)
        if ciNum == 0 then
            print("没有次属性")
        else
            for i=1,ciNum do
                _descrip = _descrip .. minor_attr[i].AttrName.. " +" .. minor_attr[i].Value
                if i%2 == 0 then
                    _descrip = _descrip.."\n"
                else
                    _descrip = _descrip.."  \t"
                end
            end
        end
        cell.minor_attr_label:setString(_descrip)
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质
        local _color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
        cell.minor_attr_label:setColor(_color)
        ------------------------------------------------------

        local _equipedWho, color = self.lineupData:getEquipTo(equipData.id)
        -- if color == ui.COLOR_PURPLE  then color = ui.COLOR_PURPLE end -- 新版本紫色 
        -- if color == ui.COLOR_BLUE  then color = ui.COLOR_BLUE end   -- 新版本蓝色
        -- if color == ui.COLOR_GREEN  then color = ui.COLOR_GREEN end    -- 新版本绿色

        local _icon = self.equipTemp:getEquipResIcon(equipData.no)  -- 资源名
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质
        -- changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片

        local resIcon = self.equipTemp:getEquipResHD(equipData.no)        -- 新版本icon
        
        if _quality == 5 or _quality == 6 then cell.icon:setScale(0.5) 
        elseif _quality == 3 or _quality == 4 then  cell.icon:setScale(0.6)
        else cell.icon:setScale(0.65) end

        cell.icon:setTexture("res/equipment/"..resIcon)   -- 新版本路径
        local imgBg = setNewEquipQualityWithFrame(_quality)
        game.setSpriteFrame(cell.itemBg, imgBg )

        cell.labelLevel:removeAllChildren()
        local levelNode = getLevelNode(equipData.strengthen_lv)
        cell.labelLevel:addChild(levelNode)

        cell.equipName:setString(_name)
        cell.equipName:setColor(_color)

        if _equipPrefix ~= 0 then
            cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        end
        --cell.equipName:setColor(_color)
        --cell.equipPrefix:setColor(_color)
        local _posx,_posy = cell.labelZBY:getPosition()
        if _equipedWho == Localize.query("equip.1") then
            cell.labelZBY:setVisible(false)
            cell.equipTo:setString(_equipedWho)
            cell.equipTo:setPosition(cc.p(_posx,_posy))
            cell.equipTo:setColor(ui.COLOR_MISE)
        else
            cell.labelZBY:setVisible(true)
            cell.equipTo:setString(_equipedWho)
            cell.equipTo:setColor(color)
            cell.equipTo:setPosition(cc.p(_posx+45,_posy))
            cell.labelZBY:setColor(ui.COLOR_MISE)
        end

        return cell
    end
    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    CCBReaderLoad("equip/ui_equip_compose_item.ccbi", proxy, tempTab)
    local node = tempTab["UIEquipComposeItem"]["itemBg"]
    local layerSize = self.listLayer:getContentSize()
    self.itemSizeA = node:getContentSize()
    self.euqipTableView = cc.TableView:create(layerSize)

    self.euqipTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.euqipTableView:setDelegate()
    self.euqipTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.euqipTableView)

    self.euqipTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.euqipTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.euqipTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.euqipTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.tableViewTable[1] = self.euqipTableView
end

--创建强化列表
function PVEquipmentMain:createStrengListView()

    local function tableCellTouched(tbl, cell)
        print("PVEquipmentMain cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
        return table.nums(self.equipCanStrengTable)
    end
    local function cellSizeForTable(tbl, idx)
        return 145,640
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function iconMenuClick()
                getAudioManager():playEffectButton2()
                local equipment = table.getValueByIndex(self.equipCanStrengTable, cell:getIdx()+1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment)
            end
            local function strengMenuClick()
                getAudioManager():playEffectButton2()
                -- 判断是否可以强化，不能就不显示界面
                local equipment = table.getValueByIndex(self.equipCanStrengTable, cell:getIdx()+1)
                -- print("equipment no", equipment.no)
                if self.equipTemp:getIsCanStrength(equipment.no) == true then
                    getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipmentStrengthen", equipment)
                else
                    -- getOtherModule():showToastView( Localize.query("equip.2") )
                    getOtherModule():showAlertDialog(nil, Localize.query("equip.2"))
                end
            end

            local function onItemClick()
                self.curType = 1
                getAudioManager():playEffectButton2()
                local equipment = table.getValueByIndex(self.equipCanStrengTable, cell:getIdx()+1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment, 2)
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIEquipStrengItem"] = {}
            cell.cardinfo["UIEquipStrengItem"]["strengMenuClick"] = strengMenuClick
            cell.cardinfo["UIEquipStrengItem"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("equip/ui_equip_strengthen_item.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIEquipStrengItem"]["headIcon"]
            cell.itemBg = cell.cardinfo["UIEquipStrengItem"]["itemBg"]
            cell.equipPrefix = cell.cardinfo["UIEquipStrengItem"]["equipPrefix"]
            cell.equipName = cell.cardinfo["UIEquipStrengItem"]["equipName"]
            cell.mainAttrLabel = cell.cardinfo["UIEquipStrengItem"]["main_attr_label"]
            cell.otherAttrLabel = cell.cardinfo["UIEquipStrengItem"]["descripLabel"]
            cell.labelZBY = cell.cardinfo["UIEquipStrengItem"]["label_zby"]
            cell.equipTo = cell.cardinfo["UIEquipStrengItem"]["equipTo"]
            -- cell.menuIcon = cell.cardinfo["UIEquipStrengItem"]["iconMenu"]
            cell.labelLevel = cell.cardinfo["UIEquipStrengItem"]["label_lv"]
            cell.itemMenuItem = cell.cardinfo["UIEquipStrengItem"]["itemMenuItem"]
            cell.strengMenu = cell.cardinfo["UIEquipStrengItem"]["strengMenu"]
            cell.strengNotice = cell.cardinfo["UIEquipStrengItem"]["strengNotice"]

            cell.itemMenuItem:setAllowScale(false)

            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值
        local equipData = table.getValueByIndex(self.equipCanStrengTable, idx+1)
        ------
        local equipmentItem = self.equipTemp:getTemplateById(equipData.no)
        local _name = self.languageTemp:getLanguageById(equipmentItem.name)
        local _equipPrefix = equipData.prefix

        local _nameImage = "ui_equip_kind_6"
        if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
        if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
        if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
        if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
        if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
        if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
        -- print(">>>>>>>>>>>>>> _nameImage  " .. _nameImage)
        -- print(">>>>>>>>>>>>>> _equipPrefix  " .. _equipPrefix)
        local _equipPrefixRes = _nameImage .. ".png"

        ---------------------------------------------------
        local _descrip = ""
        -- table.print(equipData.main_attr)
        local main_attr = self.c_Calculation:EquMainAttr(equipData)
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then
            print("没有主属性")
        else
            _descrip = _descrip .. main_attr.AttrName.. " +" .. main_attr.Value
        end
        cell.mainAttrLabel:setString(_descrip)

        --次属性
        local _descrip = ""
        -- table.print(equipData.minor_attr)
        local minor_attr = self.c_Calculation:EquMinorAttr(equipData)
        local ciNum = table.nums(minor_attr)
        if ciNum == 0 then
            print("没有次属性")
        else
            for i=1,ciNum do
                _descrip = _descrip .. minor_attr[i].AttrName.. " +" .. minor_attr[i].Value
                if i%2 == 0 then
                    _descrip = _descrip.."\n"
                end
            end
        end
        cell.otherAttrLabel:setString(_descrip)
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质
        local _color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
        cell.otherAttrLabel:setColor(_color)
        ------------------------------------------------------

        local _equipedWho, color = self.lineupData:getEquipTo(equipData.id)
        -- if color == ui.COLOR_PURPLE  then color = ui.COLOR_PURPLE end   -- 新版本紫色 
        -- if color == ui.COLOR_BLUE  then color = ui.COLOR_BLUE end       -- 新版本蓝色
        -- if color == ui.COLOR_GREEN  then color = ui.COLOR_GREEN end     -- 新版本绿色


        -- local _equipedWho = self.lineupData:getEquipTo(equipData.id)
        local _icon = self.equipTemp:getEquipResIcon(equipData.no)  -- 资源名
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质

        -- changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片

        local resIcon = self.equipTemp:getEquipResHD(equipData.no)        -- 新版本icon
        -- cell.icon:setScale(0.45)

        if _quality == 5 or _quality == 6 then 
            cell.icon:setScale(0.5) 
        elseif _quality == 3 or _quality == 4 then 
            cell.icon:setScale(0.6)
        else 
            cell.icon:setScale(0.65) 
        end

        cell.icon:setTexture("res/equipment/"..resIcon)   -- 新版本路径
        local imgBg = setNewEquipQualityWithFrame(_quality)
        game.setSpriteFrame(cell.itemBg, imgBg )

        cell.labelLevel:removeAllChildren()
        local levelNode = getLevelNode(equipData.strengthen_lv)
        cell.labelLevel:addChild(levelNode)

        cell.equipName:setString(_name)
        cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        -- cell.labelLevel:setString(equipData.strengthen_lv)
        cell.equipName:setString(_name)
        if _equipPrefix ~= 0 then
            cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        end
        cell.equipName:setColor(_color)
        --cell.equipPrefix:setColor(color)
        local _posx,_posy = cell.labelZBY:getPosition()
        if _equipedWho == Localize.query("equip.1") then
            cell.labelZBY:setVisible(false)
            cell.equipTo:setString(_equipedWho)
            cell.equipTo:setPosition(cc.p(_posx+10,_posy))
            cell.equipTo:setColor(ui.COLOR_MISE)
            -- cell.labelZBY:setColor(ui.COLOR_MISE) 
        else
            cell.labelZBY:setVisible(true)
            cell.equipTo:setString(_equipedWho)
            cell.equipTo:setColor(color) 
            cell.equipTo:setPosition(cc.p(_posx+50,_posy))
            cell.labelZBY:setColor(ui.COLOR_MISE) 
        end

        -- 强化按钮 状态
        local _equipLv = equipData.strengthen_lv
        local _playerLv = getDataManager():getCommonData():getLevel()
        if _equipLv >= _playerLv then
            cell.strengMenu:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(cell.strengMenu:getNormalImage()) 
        else
            cell.strengMenu:setEnabled(true)
            SpriteGrayUtil:drawSpriteTextureColor(cell.strengMenu:getNormalImage())  
        end

        -- 满级显示
        local _maxLevel =  getTemplateManager():getBaseTemplate():getMaxLevel()
        if _equipLv >= _maxLevel then
            cell.strengNotice:setVisible(true)
        else
            cell.strengNotice:setVisible(false)
        end

        return cell
    end
    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    CCBReaderLoad("equip/ui_equip_compose_item.ccbi", proxy, tempTab)
    local node = tempTab["UIEquipComposeItem"]["itemBg"]
    
    local layerSize = self.listLayer:getContentSize()
    self.itemSizeA = node:getContentSize()
    self.strengTableView = cc.TableView:create(layerSize)

    self.strengTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.strengTableView:setDelegate()
    self.strengTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.strengTableView)

    self.strengTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.strengTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.strengTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.strengTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.tableViewTable[2] = self.strengTableView
end

--创建合成列表
function PVEquipmentMain:createComposeListView()

    local function tableCellTouched(tbl, cell)
        print("createComposeListView cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.equipmentChips)
    end
    local function cellSizeForTable(tbl, idx)
        return 145,640
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function composeMenuClick()
                getAudioManager():playEffectButton2()
                -- local msg = "合成成功"
                 print("send to net compose operator",id,cell:getIdx())
                self.request_chipNo = table.getValueByIndex(self.equipmentChips, cell:getIdx()+1).equipment_chip_no
                -- print("chip no : ", self.request_chipNo)
                getNetManager():getEquipNet():sendComposeMsg(self.request_chipNo)

                groupCallBack(GuideGroupKey.BTN_CLICK_HECHENG)

            end
            local function viewFallsMenuClick()
                getAudioManager():playEffectButton2()
                -- print("go to chapter view ")
                local _no = table.getValueByIndex(self.equipmentChips, cell:getIdx()+1).equipment_chip_no
                local _data = getTemplateManager():getChipTemplate():getAllDropPlace(_no)
                if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
                    and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
                    and _data.arenaShop == 0 and _data.stageBreak == 0  then
                    local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
                    -- getOtherModule():showToastView(tipText)
                    getOtherModule():showAlertDialog(nil, tipText)

                else
                    -- getOtherModule():showOtherView("PVChipGetDetail", _data)
                    getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVChipGetDetail", _data, _no, 4)
                end
            end

            local function onItemClick()
                self.curType = 1
                getAudioManager():playEffectButton2()
                local equipmentChipItem = table.getValueByIndex(self.equipmentChips, cell:getIdx()+1)
                local equipChipNo = equipmentChipItem.equipment_chip_no              --碎片id
                local equipChipNum = equipmentChipItem.equipment_chip_num           --碎片数目
                getOtherModule():showOtherView("PVCommonChipDetail", 2, equipChipNo, equipChipNum)
            end
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIEquipComposeItem"] = {}
            cell.cardinfo["UIEquipComposeItem"]["composeMenuClick"] = composeMenuClick
            cell.cardinfo["UIEquipComposeItem"]["viewFallsMenuClick"] = viewFallsMenuClick
            cell.cardinfo["UIEquipComposeItem"]["onItemClick"] = onItemClick

            local node = CCBReaderLoad("equip/ui_equip_compose_item.ccbi", proxy, cell.cardinfo)
            cell.equipName = cell.cardinfo["UIEquipComposeItem"]["equipName"]
            -- cell.haveValue = cell.cardinfo["UIEquipComposeItem"]["haveValue"]
            cell.ritchText = cell.cardinfo["UIEquipComposeItem"]["ritchText"]
            cell.icon = cell.cardinfo["UIEquipComposeItem"]["headIcon"]
            cell.kuangBg = cell.cardinfo["UIEquipComposeItem"]["kuangBg"]
            cell.kuangBg2 = cell.cardinfo["UIEquipComposeItem"]["kuangBg2"]
            cell.composeMenu = cell.cardinfo["UIEquipComposeItem"]["composeMenu"]
            cell.seeDrop = cell.cardinfo["UIEquipComposeItem"]["viewFallsMenu"]
            cell.labelNeed = cell.cardinfo["UIEquipComposeItem"]["label_need"]
            cell.needAnotherValue = cell.cardinfo["UIEquipComposeItem"]["needAnotherValue"]
            cell.imgCanCom = cell.cardinfo["UIEquipComposeItem"]["img_cancom"]
            -- cell.needValue = cell.cardinfo["UIEquipComposeItem"]["comValue"]
            cell.canComText = cell.cardinfo["UIEquipComposeItem"]["canComText"]
            cell.itemMenuItem = cell.cardinfo["UIEquipComposeItem"]["itemMenuItem"]

            cell.texiaoNode = cell.cardinfo["UIEquipComposeItem"]["texiaoNode"]
            cell.itemMenuItem:setAllowScale(false)

            cell:addChild(node)
        end

        local equipmentChipItem = self.equipmentChips[idx+1] --装备碎片数据
        local chipTemplateItem = self.chipTemp:getTemplateById(equipmentChipItem.equipment_chip_no) --装备碎片模板数据
        local _num = equipmentChipItem.equipment_chip_num        --碎片数目
        local _need = chipTemplateItem.needNum                   --合成所需碎片个数
        local _languageId = chipTemplateItem.language            --碎片名称
        local _name = self.languageTemp:getLanguageById(_languageId)  -- 中文
        local _icon = self.resourceTemp:getResourceById(chipTemplateItem.resId) -- 资源名
        local _quality = chipTemplateItem.quality

        local _equId = chipTemplateItem.combineResult  -- 合成的产物id

        -- setChipWithFrame(cell.icon, _icon, _quality)  -- 设置卡的图片

        local resIcon = self.equipTemp:getEquipResHD(_equId)        -- 新版本icon
        cell.icon:setScale(0.45)

        if _quality == 5 or _quality == 6 then 
            cell.icon:setScale(0.5) 
        elseif _quality == 3 or _quality == 4 then 
            cell.icon:setScale(0.6)
        else 
            cell.icon:setScale(0.65) 
        end

        cell.icon:setTexture("res/equipment/"..resIcon)   -- 新版本路径
        local imgBg = changeHeroQualityWithFrame(_quality)
        local imgBg2 = changeHeroQualityWithFrame2(_quality)
        game.setSpriteFrame(cell.kuangBg, imgBg )
        game.setSpriteFrame(cell.kuangBg2, imgBg2 )

        cell.ritchText:removeChildByTag(1001)
        local richtext = ccui.RichText:create()
        richtext:setAnchorPoint(cc.p(0,0.5))
        richtext:setTag(1001)

        local color = ui.COLOR_BLUE2
        if _need - _num <= 0 then
            color = ui.COLOR_BLUE2
        else
            color = ui.COLOR_GREY
        end
        local re0 = ccui.RichElementText:create(1, color, 255, string.format("%d", _num), "res/ccb/resource/Berlin.ttf", 22)
        richtext:pushBackElement(re0)
        local re1 = ccui.RichElementText:create(1, ui.COLOR_MISE, 255, tostring("/".._need), "res/ccb/resource/Berlin.ttf", 22)
        richtext:pushBackElement(re1)
        cell.ritchText:addChild(richtext)

        if _need - _num <= 0 then
            local _allNum = math.floor(_num / _need)
            cell.needAnotherValue:setString( tostring(_allNum) )
            cell.needAnotherValue:setColor(color)
            cell.composeMenu:setEnabled(true)
            cell.imgCanCom:setVisible(true)
            -- cell.haveValue:setColor(ui.COLOR_GREEN)

            local _node = UI_Hechenganniu()
            cell.texiaoNode:removeAllChildren()
            cell.texiaoNode:addChild(_node)

        else
            cell.needAnotherValue:setString( "0" )
            cell.needAnotherValue:setColor(color)
            cell.composeMenu:setEnabled(false)
            cell.imgCanCom:setVisible(false)
            -- cell.haveValue:setColor(ui.COLOR_RED)

            cell.texiaoNode:removeAllChildren()
        end

        -- cell.needValue:setString("/"..tostring(_need))
        cell.equipName:setString(_name)
        -- cell.haveValue:setString(string.format("%d", _num).."/"..tostring(_need))
        -- cell.needValue:setPositionX(cell.haveValue:getPositionX()+cell.haveValue:getContentSize().width+5)
        cell.canComText:setPositionX( cell.needAnotherValue:getPositionX()+cell.needAnotherValue:getContentSize().width+5 )

        return cell
    end

    local layerSize = self.listLayer:getContentSize()
    self.itemSizeB = self.itemSizeA  --暂时设为和itemSizeA的一样大
    self.composeTableView = cc.TableView:create(layerSize)

    self.composeTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.composeTableView:setDelegate()
    self.composeTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.composeTableView)

    self.composeTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.composeTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.composeTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.composeTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.tableViewTable[3] = self.composeTableView
end

-- -- 熔炼
-- function PVEquipmentMain:smeltMenuClick()
--     cclog("smeltMenuClick")
--     getAudioManager():playEffectButton2()

--     local _list = self.equipData:getSmeltIDs()

--     if _list == nil or table.getn(_list) == 0 then 
--         -- self:toastShow("未选择熔炼装备！")
--         getOtherModule():showAlertDialog(nil, "未选择熔炼装备！")
--         return 
--     else 
--         SpriteGrayUtil:drawSpriteTextureGray(self.menuSmeltShop:getNormalImage())
--         SpriteGrayUtil:drawSpriteTextureGray(self.smeltMenu:getNormalImage())
--         SpriteGrayUtil:drawSpriteTextureGray(self.menuOneKeyAdd:getNormalImage())
--         self.menuOneKeyAdd:setEnabled(false)
--         self.menuSmeltShop:setEnabled(false)
--         self.smeltMenu:setEnabled(false)
--     end

--     -- table.print(_list)

--     local hasSpecialEquip = false
--     local hasPurpleEquip = false
--     for k,v in pairs(_list) do
--         local equip_no = self.equipData:getEquipById(v).no
--         local _quality = self.equipTemp:getQuality(equip_no)
--         local _type = self.equipTemp:getTypeById(equip_no)
--         if _type >= 5 then hasSpecialEquip = true end
--         if _quality >= 5 then hasPurpleEquip = true end
--     end
--     if hasSpecialEquip and hasPurpleEquip then
--         getOtherModule():showOtherView("SystemTips", Localize.query("shop.17"))
--     elseif hasSpecialEquip and not hasPurpleEquip then
--         getOtherModule():showOtherView("SystemTips", Localize.query("shop.16"))
--     elseif hasPurpleEquip and not hasSpecialEquip then
--         getOtherModule():showOtherView("SystemTips", Localize.query("shop.6"))
--     else
--         getNetManager():getEquipNet():sendMeltingMsg(_list)
--     end

-- end

-- function PVEquipmentMain:registerSmeltTouchEvent()
--     -- self.smeltTouchLayer

--     -- local size = self.smeltTouchLayer:getContentSize()
--     -- local rectArea = cc.rect(0, 0, size.width, size.height)
--     -- self.smeltTouchLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
--     -- self.smeltTouchLayer:setTouchEnabled(true)

--     -- local function onTouchEvent(eventType, x, y)
--     --     local _pos = self.smeltTouchLayer:convertToNodeSpace(cc.p(x,y))
--     --     local isInRect = cc.rectContainsPoint(rectArea, _pos)
--     --     if eventType == "began" then
--     --         if isInRect then
--     --             getAudioManager():playEffectButton2()

--     --             self:smeltMenuClick()
--     --         end
--     --     end
--     -- end
--     -- self.smeltTouchLayer:registerScriptTouchHandler(onTouchEvent)

-- end

function PVEquipmentMain:onReloadView()

    local data = self.funcTable[1]
    if data == 1 then
        return
    end
    if data == 80 then
        return
    end
    self:initData()
    self:sortList()
    self:updateSubMenuState(self.currSubMenuIdx)
    if self.currMenuIdx == 4 then
        -- self:updateSmeltView()
    end

    -- if COMMON_TIPS_BOOL_RETURN == true then
    --     -- 发送熔炼协议
    --     -- getNetManager():getEquipNet():sendMeltingMsg(self.equipData:getSmeltIDs())
    -- end
    -- COMMON_TIPS_BOOL_RETURN = nil
    self.curType = nil
end

function PVEquipmentMain:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")
end

--@return
return PVEquipmentMain
