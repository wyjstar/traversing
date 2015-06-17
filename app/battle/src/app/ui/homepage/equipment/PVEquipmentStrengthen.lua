--装备强化界面

local RgTableView = import(".PVEquipShuxTableView")

local PVEquipmentStrengthen = class("PVEquipmentStrengthen", BaseUIView)

function PVEquipmentStrengthen:ctor(id)
    PVEquipmentStrengthen.super.ctor(self, id)
    self:registerNetCallback()
    self.lineupData = getDataManager():getLineupData()
    self.c_equipData = getDataManager():getEquipmentData()
    self.c_equipTemp = getTemplateManager():getEquipTemplate()
    self.c_CommonData = getDataManager():getCommonData()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.strengthenCount =0
end

function PVEquipmentStrengthen:onMVCEnter()
    g_equipListIndex = 1
    self.ccbiNode = {}
    self.equipCanStrengTable = {}
    self.onLineEquipList = self.lineupData:getOnLineUpEquip()
    self:initTouchListener()
    self:loadCCBI("equip/ui_equipment_strengthen.ccbi", self.ccbiNode)
    self:strengthEquipSort()
    self:initView()
    self:updateView()
    -- self:showAttributeView()
end 

function PVEquipmentStrengthen:onExit()
    cclog("-------onExit----")
    if self.scheduerOnline ~= nil then
        timer.unscheduleGlobal(self.scheduerOnline); self.scheduerOnline = nil
    end
    if self.flag then
        getDataManager():getEquipmentData():setStrengLv(self.equipData.id, self.strengthLv)
    end
end

-- 注册Response回调函数
function PVEquipmentStrengthen:registerNetCallback()

    local function responseEnhanceCallback(id, data)
        -- cclog(" @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ui response enhance ...")
        -- table.pri nt(data)
        if data.res.result == true then
            -- local equipTemp = getTemplateManager():getEquipTemplate()
            self.flag = true
            cclog("<<<== 强化装备处理返回的数据fdsafafe ==>>>")
            table.print(data)
            cclog("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
            self.menugo:setEnabled(false)
            self.menuOnekey:setEnabled(false)
            table.print(data.data)
            -- local enhanceData = data.data[1]
            local enhanceData = data.data
            local _cost_coin = 0
            local _num = #enhanceData
            self.strengthLv = enhanceData[_num].after_lv
            local num = _num

            cclog("-----------num--------------".._num)
            for i = 1,_num do
                _cost_coin = _cost_coin + enhanceData[i].cost_coin
            end
            getDataManager():getCommonData():subCoin(_cost_coin)
           
            getDataManager():getEquipmentData():changeEnhance(self.equipData.id,enhanceData)
            self.lineupData:changeEquipmentById(self.equipData.id)

            local main_attr = self.equipData.main_attr  
            local minor_attr = self.equipData.minor_attr
            ---------------传承----------------
            local _inherit = self.funcTable[2]
            if _inherit ~= nil then
                if _inherit == 0 then 
                    getDataManager():getInheritData():setequId1(getDataManager():getEquipmentData():getEqu(self.equipData.id))
                else  
                    getDataManager():getInheritData():setequId2(getDataManager():getEquipmentData():getEqu(self.equipData.id))
                end 
                local event = cc.EventCustom:new(UPDATE_VIEW)
                self:getEventDispatcher():dispatchEvent(event)
            end
            -------------------------------

            local function hideTips()
                self.breakNode:setVisible(false)
                self.successNode:setVisible(false)

                self.menuRight:setEnabled(true)
                self.menuLeft:setEnabled(true)

                ---战力提升
                self.c_CommonData.updateCombatPower()
                

            --     stepCallBack(G_GUIDE_40119)    -- 点击强化
            -- -- elseif self.strengthenCount==1 then 
            --     stepCallBack(G_GUIDE_40120)    -- 点击强化
            -- -- elseif self.strengthenCount==2 then 
            --     stepCallBack(G_GUIDE_40121) 

                -- groupCallBack(GuideGroupKey.BTN_CLICK_QIANGHUA_EQUIPMENT3)
                -- groupCallBack(GuideGroupKey.BTN_CLICK_QIANGHUA_EQUIPMENT2)
                -- -- groupCallBack(GuideGroupKey.BTN_CLICK_QIANGHUA_EQUIPMENT)
                -- groupCallBack(GuideGroupKey.BTN_CLOSE_QIANGHUA_EQUIPMENT)

            end
            -- local i = 1
            local function callback()
                self.animationNode:removeChildByTag(1000)
                if enhanceData then
                    local foreLv = enhanceData[1].before_lv
                    self.levelUp = enhanceData[num].after_lv - enhanceData[1].before_lv
                    self.labelUp1:setString("等级+"..self.levelUp)
                    self.labelUp2:setString("等级+"..self.levelUp)

                    local zhuNum = main_attr[1].attr_increment * enhanceData[num].before_lv + main_attr[1].attr_value
                    local zhuNextNum = main_attr[1].attr_increment * enhanceData[num].after_lv + main_attr[1].attr_value
                    local typeName = getTemplateManager():getEquipTemplate():setSXName(main_attr[1].attr_type)
                    zhuNum = math.floor(zhuNum*10)/10
                    zhuNextNum = math.floor(zhuNextNum*10)/10
                    self.labelAttrUp1:setString(typeName.."+"..zhuNextNum-zhuNum)
                    self.labelAttrUp2:setString(typeName.."+"..zhuNextNum-zhuNum)

                    getDataManager():getEquipmentData():setStrengLv(self.equipData.id, enhanceData[num].after_lv)

                    self.currLevel = enhanceData[num].after_lv
                    
                    --副属性动画加成
                    local _descrip = ""
                  
                    table.print(self.equipData.minor_attr)
                    local ciNum = table.nums(minor_attr)
                    if ciNum == 0 then 
                        print("没有次属性")
                    else
                        for i=1,ciNum do
                            local str = getTemplateManager():getEquipTemplate():setSXName(minor_attr[i].attr_type)
                            local ciAddNum =  minor_attr[i].attr_value + minor_attr[i].attr_increment * self.equipData.strengthen_lv
                            local foreNum = minor_attr[i].attr_value + minor_attr[i].attr_increment * foreLv
                            ciAddNum = math.floor(ciAddNum*10)/10
                            foreNum = math.floor(foreNum*10)/10
                            _descrip = _descrip .. str .. " +" .. ciAddNum - foreNum.."\n"
                        end
                    end
                    cclog("-------------------qianghua---------"..self.equipData.no)
                    local _quality = getTemplateManager():getEquipTemplate():getQuality(self.equipData.no)    -- 装备品质
                    local _color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)

                    self.labelOtherAttr1:setString(_descrip)
                    self.labelOtherAttr2:setString(_descrip)
                    self.labelOtherAttr1:setColor(_color)
                    self.labelOtherAttr2:setColor(_color)

                    -- i = i + 1 
                    if _num == 0 then 
                        self.layerTouch:setVisible(false)
                        self.layerTouch:setTouchEnabled(false)
                    end

                    self.imgEffect3:setVisible(false)
                    self:updateView()
                  
                    --分下强化代码
                    if num == 1 then 
                        if self.levelUp ~= 1 then -- break             
                            self.breakNode:setVisible(true)
                        elseif self.levelUp == 1 then -- success
                            self.successNode:setVisible(true)
                        end
                    elseif num > 1 then
                        self.successNode:setVisible(true)
                    end

                    self.animationManager:runAnimationsForSequenceNamed("showOver")
                    local seq = cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(hideTips))
                    seq:setTag(1001)
                    self:runAction(seq)
                end
                
            end


            local function func()
                cclog("-----------func----eff----------")
                self.animationNode:removeAllChildren()

                self.layerTouch:setVisible(false)
                self.layerTouch:setTouchEnabled(false)
                self:stopActionByTag(1001)
                hideTips()

                if self.scheduerOnline ~= nil then timer.unscheduleGlobal(self.scheduerOnline); self.scheduerOnline = nil end
                if enhanceData then
                    local foreLv = self.equipData.strengthen_lv
                    self.levelUp = enhanceData[num].after_lv - enhanceData[1].before_lv
                    self.labelUp1:setString("等级+"..self.levelUp)
                    self.labelUp2:setString("等级+"..self.levelUp)

                    local zhuNum = main_attr[1].attr_increment * enhanceData[1].before_lv + main_attr[1].attr_value
                    local zhuNextNum = main_attr[1].attr_increment * enhanceData[num].after_lv + main_attr[1].attr_value
                    local typeName = getTemplateManager():getEquipTemplate():setSXName(main_attr[1].attr_type)
                    zhuNum = math.floor(zhuNum*10)/10
                    zhuNextNum = math.floor(zhuNextNum*10)/10
                    self.labelAttrUp1:setString(typeName.."+"..zhuNextNum-zhuNum)
                    self.labelAttrUp2:setString(typeName.."+"..zhuNextNum-zhuNum)

                    getDataManager():getEquipmentData():setStrengLv(self.equipData.id, enhanceData[num].after_lv)

                    self.currLevel = enhanceData[num].after_lv
            --
                    --副属性动画加成
                    -- local _descrip = ""
                    -- table.print(self.equipData.minor_attr)
                    -- local ciNum = table.nums(minor_attr)
                    -- if ciNum == 0 then 
                    --     print("没有次属性")
                    -- else
                    --     for i=1,ciNum do
                    --         local str = getTemplateManager():getEquipTemplate():setSXName(minor_attr[i].attr_type)
                    --         local ciAddNum =  minor_attr[i].attr_value + minor_attr[i].attr_increment * self.equipData.strengthen_lv
                    --         local foreNum = minor_attr[i].attr_value + minor_attr[i].attr_increment * foreLv
                    --         -- local ciAddNum =  minor_attr[i].attr_increment * self.equipData.strengthen_lv
                    --         ciAddNum = math.floor(ciAddNum*10)/10
                    --         foreNum = math.floor(foreNum*10)/10
                    --         _descrip = _descrip .. str .. " +" .. ciAddNum - foreNum.."\n"
                    --     end
                    -- end
                    -- local _quality = getTemplateManager():getEquipTemplate():getQuality(self.equipData.no)    -- 装备品质
                    -- local _color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)

                    -- self.labelOtherAttr1:setString(_descrip)
                    -- self.labelOtherAttr2:setString(_descrip)
                    -- self.labelOtherAttr1:setColor(_color)
                    -- self.labelOtherAttr2:setColor(_color)
            --
                    self.labelOtherAttr:setVisible(false)
                    self.labelOtherAttrTo:setVisible(false)

                    self.other_attribute_layer:removeAllChildren()
                    self.other_attributeTo_layer:removeAllChildren()

                    local rgTableView1 = RgTableView.new()
                    rgTableView1:setViewSize(self.other_attribute_layer:getContentSize())
                    rgTableView1:initTableView(self.equipData, 1, false)
                    self.other_attribute_layer:addChild(rgTableView1)

                    local rgTableView = RgTableView.new()
                    rgTableView:setViewSize(self.other_attributeTo_layer:getContentSize())
                    rgTableView:initTableView(self.equipData, 1, true)
                    self.other_attributeTo_layer:addChild(rgTableView)

            --

                    
                    self.imgEffect3:setVisible(false)
                    self:updateView()
                
                    print(self.strengthType,self.levelUp,self.oneKeyLevels)
                  
                    self.successNode:setVisible(true)
                    -- if num == 1 then 
                    --     if self.levelUp ~= 1 then -- break             
                    --         self.breakNode:setVisible(true)
                    --     elseif self.levelUp == 1 then -- success
                    --         self.successNode:setVisible(true)
                    --     end
                    -- elseif num > 1 then
                    --     self.successNode:setVisible(true)
                    -- end
                    self.animationManager:runAnimationsForSequenceNamed("showOver")
                    local seq = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(hideTips))
                    self:runAction(seq)
                end
                
            end

            local function cancelEff()
                local size = self.layerTouch:getContentSize()
                local rectArea = cc.rect(0, 0, size.width, size.height)
                local function onTouchEvent(eventType, x, y)
                    local _pos = self.layerTouch:convertToNodeSpace(cc.p(x,y))
                    local isInRect = cc.rectContainsPoint(rectArea, _pos)
                    if eventType == "began" then
                        if isInRect then
                            getAudioManager():playEffectButton2()
                            self.animationNode:removeAllChildren()
                            func()
                            return true
                        end
                    elseif eventType == "ended" then
                        --self.imgTokenLeft:setScale(1)
                        return 
                    end
                end
                self.layerTouch:setVisible(true)
                self.layerTouch:setTouchEnabled(true)
                self.layerTouch:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
                self.layerTouch:registerScriptTouchHandler(onTouchEvent)
            end


            local function updateTimer(dt)
                self.animationNode:removeChildByTag(1000)
                _num = _num - 1
                cclog("------------num---------".._num)
                local node
                if _num >0 then node = UI_ZhaungbeiqianghuaNew(nil) --UI_Zhaungbeiqianghuajiu(nil)
                elseif _num == 0 then node = UI_ZhaungbeiqianghuaNew(callback) --[[UI_Zhaungbeiqianghuajiu(callback)]] end
                node:setTag(1000)
                self.animationNode:addChild(node)
                if _num == 0 and self.scheduerOnline ~= nil then
                    timer.unscheduleGlobal(self.scheduerOnline); self.scheduerOnline = nil
                end
                if _num == 0 then 
                    self.layerTouch:setVisible(false)
                    self.layerTouch:setTouchEnabled(false)
                end
            end
            if _num > 1 then
                cancelEff()    --注册触摸层事件，用来截获触摸，截断特效
            end

            -- self.animationNode:removeChildByTag(1000)
            -- _num = _num - 1
            -- local node = UI_Zhaungbeiqianghuajiu(callback)
            -- node:setTag(1000)
            -- self.animationNode:addChild(node)
            if _num == 1 then
                local node = UI_ZhaungbeiqianghuaNew(callback)--[[UI_Zhaungbeiqianghuajiu(callback)]]
                node:setTag(1000)
                self.animationNode:addChild(node)
            end
            if self.scheduerOnline == nil and _num > 1 then self.scheduerOnline = timer.scheduleGlobal(updateTimer, 0.5) end
            
            -- self.animationNode:addChild(node)
            self.imgEffect3:setVisible(true)
            self.menuRight:setEnabled(false)
            self.menuLeft:setEnabled(false)
        else
            cclog("!!! 数据返回错误")
        end
    end

    self:registerMsg(EQU_ENHANCE_CODE, responseEnhanceCallback)
end

function PVEquipmentStrengthen:initView()
    cclog("-------PVEquipmentStrengthen:initView-----------")
    assert(self.funcTable, "PVEquipmentAttribute's funcTable must not be nil !")
    self.equipData = self.funcTable[1]

    table.print(self.equipData)
    --获取控件
    self.ccbiRootNode = self.ccbiNode["UIEquipStrengDetail"]
    self.equipPrefix = self.ccbiRootNode["equipPrefix"]
    -- self.pointSprite = self.ccbiRootNode["pointSprite"
    self.labelEquipName = self.ccbiRootNode["equipName"]
    self.labelNowLv = self.ccbiRootNode["label_nowLv"]
    self.labelNextLv = self.ccbiRootNode["label_nextLv"]
    self.labelAttr = self.ccbiRootNode["attributeType"]
    self.labelNowPower = self.ccbiRootNode["label_nowPower"]
    self.labelNextPower = self.ccbiRootNode["label_nextPower"]
    self.labelNeedMoney = self.ccbiRootNode["label_needMoney"]
    self.labelOneKeyNeedMoney = self.ccbiRootNode["label_one_needMoney"]
    self.labelOtherAttr = self.ccbiRootNode["other_attribute"]
    self.labelOtherAttrTo = self.ccbiRootNode["other_attributeTo"]

    self.other_attributeTo_layer = self.ccbiRootNode["other_attributeTo_layer"]
    self.other_attribute_layer = self.ccbiRootNode["other_attribute_layer"]


    self.labelOtherAttr1 = self.ccbiRootNode["other_attribute1"]
    self.labelOtherAttr2 = self.ccbiRootNode["other_attribute2"]
    self.imgIcon = self.ccbiRootNode["equipPic"]
    -- self.labelEquipTo = self.ccbiRootNode["equipTo"]
    -- self.labelEquipToTip = self.ccbiRootNode["label_fnt_e_to_who"]
    self.weizhuangbeiLabel = self.ccbiRootNode["weizhuangbeiLabel"]
    -- self.imgFrame = self.ccbiRootNode["img_frame"]

    self.menugo = self.ccbiRootNode["menu_go"]
    -- self.menugo:getSelectedImage():setScale(1.3)
    self.menuOnekey = self.ccbiRootNode["menu_onekey"]

    self.label_tips = self.ccbiRootNode["label_tips"]
    self.animationNode = self.ccbiRootNode["animationNode"]
    self.imgEffect1 = self.ccbiRootNode["effect_1"]
    self.imgEffect2 = self.ccbiRootNode["effect_2"]
    self.imgEffect3 = self.ccbiRootNode["effect_3"]
    -- self.imgEffect4 = self.ccbiRootNode["effect_4"]
    self.imgEffect2:setVisible(false)
    self.imgEffect3:setVisible(false)
    -- self.imgEffect4:setVisible(false)
    self.effectNode = self.ccbiRootNode["effect_node"]
    self.successNode = self.ccbiRootNode["success_node"]
    self.breakNode = self.ccbiRootNode["break_node"]
    self.successNode:setVisible(false)
    self.breakNode:setVisible(false)
    self.labelUp1 = self.ccbiRootNode["label_lvup"]
    self.labelAttrUp1 = self.ccbiRootNode["label_attrUp"]
    self.labelUp2 = self.ccbiRootNode["label_lvup2"]
    self.labelAttrUp2 = self.ccbiRootNode["label_attrUp2"]

    self.useVipLevel = self.ccbiRootNode["useVipLevel"]
    local num = getTemplateManager():getBaseTemplate():getOpenLvStrengthen()
    self.useVipLevel:setString("VIP"..num.."可使用")

    self.animationManager = self.ccbiRootNode["mAnimationManager"]
    self.menuRight = self.ccbiRootNode["menuRight"]
    self.menuLeft = self.ccbiRootNode["menuLeft"]
    self.equipToNode = self.ccbiRootNode["equipToNode"]
    self.upMainAttrLabel = self.ccbiRootNode["upMainAttrLabel"]
    self.equipLv = self.ccbiRootNode["equipLv"]
    

    --触摸层
    self.layerTouch = self.ccbiRootNode["layerTouch"]
    self.layerTouch:setVisible(false)
    self.layerTouch:setTouchEnabled(false)
    self.menuLeft:setVisible(false)
    -- self.label_tips:setVisible(false)

    self:preloadEffect()
end

-- 进入后就播放的特效
function PVEquipmentStrengthen:preloadEffect()

    local action1 = cc.FadeTo:create(1, 50)
    local action2 = cc.FadeTo:create(1, 255)
    local seq = cc.Sequence:create(action1, action2)

    self.imgEffect1:runAction(cc.RepeatForever:create(seq))
    local node = UI_Zhuangbeiqianghuahold()
    self.animationNode:addChild(node)
end

function PVEquipmentStrengthen:updateView()

    --模板
    local languageTemp = getTemplateManager():getLanguageTemplate()
    local equipTemp = getTemplateManager():getEquipTemplate()
    local _equipTempItem = equipTemp:getTemplateById(self.equipData.no)

    local _icon = equipTemp:getEquipResHD(self.equipData.no)
    local _quality = equipTemp:getQuality(self.equipData.no)
    local _frameRes = getIconHDByQuality(_quality)
    -- self.imgFrame:setSpriteFrame(_frameRes)
    local _equipPrefix = self.equipData.prefix
    -- local _equipPrefixRes = _equipPrefix .. ".png"
    self._name = languageTemp:getLanguageById(_equipTempItem.name)
    self.imgIcon:setTexture("res/equipment/".._icon)
    self.imgIcon:setScale(0.9,0.9)
    self.currLevel = self.equipData.strengthen_lv


    local _nameImage = "ui_equip_kind_6"
    if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_06" end
    if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_05" end
    if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_04" end
    if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_03" end
    if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_02" end
    if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_01" end

    local _equipPrefixRes = _nameImage .. ".png"



    --提升属性
    --[[
    local _res, _baseV, _growV = equipTemp:getMainAttributeById(self.equipData.no)
    _promoteAttr = _res
    if _growV == nil then
        _growV = 1
        _baseV = 0
    end

    _promoteValue = self.currLevel * _growV + _baseV
    _nextPValue = (self.currLevel+1) * _growV + _baseV
    ]]
    self._suitNo = _equipTempItem.suitNo
    --消耗
    self.useMoney = equipTemp:getStengthMoneyById(self.equipData.no, self.currLevel)
    self.oneKeyLevel, self.oneKeyMoney = equipTemp:getOneKeyStrengthLevel(self.equipData)
    print("-----self.oneKeyLevel------")
    print(self.oneKeyLevel,self.oneKeyMoney)

    -- --装备于谁
    -- local _equipedWho = self.lineupData:getEquipTo(self.equipData.id)
    -- if _equipedWho == Localize.query("equip.1") then
    --     self.labelEquipToTip:setString(_equipedWho)
    --     self.labelEquipTo:setString("")
    -- else
    --     self.labelEquipToTip:setString(Localize.query("equip.0"))
    --     self.labelEquipTo:setString(_equipedWho)
    -- end

    self.equipToNode:removeChildByTag(1001)
    local richtext = ccui.RichText:create()
    richtext:setAnchorPoint(cc.p(1,0.5))
    richtext:setTag(1001)

    local _equipedWho, _color = self.lineupData:getEquipTo(self.equipData.id)
    
    if _equipedWho == Localize.query("equip.1") then
        -- self.labelEquipToTip:setString("")
        -- self.labelEquipTo:setString("未装备")
        -- self.labelEquipTo:setColor(ui.COLOR_MISE)
        -- self.labelEquipTo:setPositionX(self.labelEquipTo:getPositionX() - 50)
        self.weizhuangbeiLabel:setVisible(true)
    else
        -- self.labelEquipToTip:setString("")
        -- self.labelEquipTo:setString("")
        local re0 = ccui.RichElementText:create(1, ui.COLOR_MISE, 255, "装备在：", "res/ccb/resource/miniblack.ttf", 22)
        richtext:pushBackElement(re0)
        local re1 = ccui.RichElementText:create(1, _color, 255, _equipedWho, "res/ccb/resource/miniblack.ttf", 22)
        richtext:pushBackElement(re1)

        self.weizhuangbeiLabel:setVisible(false)
    end

    self.equipToNode:addChild(richtext)

    --给控件赋值
    self.equipLv:removeAllChildren()
    local levelNode = getLevelNode(tostring(self.currLevel))
    self.equipLv:addChild(levelNode)
    self.labelNowLv:setString("Lv."..string.format(self.currLevel))
    self.labelNextLv:setString("Lv."..string.format(self.currLevel+1))
    -- self.labelAttr:setString(_promoteAttr)
    -- self.labelOtherAttr:setString()

    -- self.labelNowPower:setString("+"..string.format(roundNumber(_promoteValue)))
    -- self.labelNextPower:setString("+"..string.format(roundNumber(_nextPValue)))
    self.labelNeedMoney:setString(string.format(self.useMoney))
    self.labelOneKeyNeedMoney:setString(string.format(self.oneKeyMoney))

    self.labelEquipName:setString(self._name)
    local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
    self.labelEquipName:setColor(color)
    if _equipPrefix ~= 0 then
        self.equipPrefix:setSpriteFrame(_equipPrefixRes)
    end

    ---------------------------------------------------
    local _descrip = ""
    -- table.print(self.equipData.main_attr)
    local main_attr = self.equipData.main_attr
    local mainNum = table.nums(main_attr)
    -- if mainNum == 0 then 
    --     print("没有主属性")
    -- else
    --     local zhuNum =  main_attr[1].attr_value + main_attr[1].attr_increment * self.equipData.strengthen_lv
    --     local str = self.equipTemp:setSXName(main_attr[1].attr_type)
    --     _descrip = _descrip .. str .. " +" .. zhuNum
    -- end
    local zhuNum = main_attr[1].attr_increment * (self.equipData.strengthen_lv-1) + main_attr[1].attr_value
    local zhuNextNum = main_attr[1].attr_increment * self.equipData.strengthen_lv + main_attr[1].attr_value
    self.labelAttr:setString(equipTemp:setSXName(main_attr[1].attr_type))
    self.labelNowPower:setString(math.floor(zhuNum*10)/10)         ---math.floor(zhuNum*10)/10
    self.labelNextPower:setString(math.floor(zhuNextNum*10)/10)
    self.upMainAttrLabel:setString(math.floor((zhuNextNum - zhuNum)*10)/10)
    --次属性
    local _descrip = ""
    local _descripTo = ""
    cclog("-------------PVEquipmentStrengthen:updateView minor_attr------")
    table.print(self.equipData.minor_attr)
    local minor_attr = self.c_Calculation:EquMinorAttr(self.equipData)  --self.equipData.minor_attr
    local _equipData = self.equipData
    local _maxLevel =  getTemplateManager():getBaseTemplate():getMaxLevel()
    local minor_attr_temp = nil
    if  _equipData.strengthen_lv < _maxLevel then 
        _equipData.strengthen_lv = _equipData.strengthen_lv + 1
        minor_attr_temp = self.c_Calculation:EquMinorAttr(_equipData)
        _equipData.strengthen_lv = _equipData.strengthen_lv - 1
    else
        minor_attr_temp = self.c_Calculation:EquMinorAttr(_equipData)
    end
    
    -- local minor_attr_temp = self.c_Calculation:EquMinorAttr(_equipData)

    -- print("-------------PVEquipmentStrengthen:updateView minor_attr------",self.equipData.strengthen_lv)
    -- table.print(minor_attr_temp)
    -- local ciNum = table.nums(minor_attr)
    -- if ciNum == 0 then 
    --     print("没有次属性")
    -- else
    --     for i=1,ciNum do
    --         -- local str = equipTemp:setSXName(minor_attr[i].AttrName)
    --         local ciAddNum =  minor_attr[i].Value --[[+ minor_attr[i].attr_increment * (self.equipData.strengthen_lv-1)]]
    --         local ciAddNum1 = minor_attr_temp[i].Value
    --         -- ciAddNum = math.floor(ciAddNum*10)/10
    --         _descrip = _descrip .. minor_attr[i].AttrName .. "   +" .. ciAddNum  --  .." -> " .. ciAddNum1
    --         _descripTo = _descripTo .. minor_attr[i].AttrName .. "   +" .. ciAddNum1
    --         -- if i%2 == 0 then 
    --             _descrip = _descrip.."\n"
    --             _descripTo = _descripTo.."\n"
    --         -- end
    --     end
    -- end
    -- self.labelOtherAttr:setString(_descrip)
    -- -- self.labelOtherAttrTo:setString(_descripTo)
    -- local _quality = equipTemp:getQuality(self.equipData.no)    -- 装备品质
    -- local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
    -- self.labelOtherAttr:setColor(color)
    -- -- self.labelOtherAttrTo:setColor(color)
    self.labelOtherAttr:setVisible(false)
    self.labelOtherAttrTo:setVisible(false)

    self.other_attribute_layer:removeAllChildren()
    self.other_attributeTo_layer:removeAllChildren()

    local rgTableView1 = RgTableView.new()
    rgTableView1:setViewSize(self.other_attribute_layer:getContentSize())
    -- rgTableView:initDate(self.equipData, 1)
    rgTableView1:initTableView(self.equipData, 1, false)
    self.other_attribute_layer:addChild(rgTableView1)--, 10, TAG_VIPVIEW)  -- 将tableView加到tableViewBg上

    local rgTableView = RgTableView.new()
    rgTableView:setViewSize(self.other_attributeTo_layer:getContentSize())
    -- rgTableView:initDate(self.equipData, 1)
    rgTableView:initTableView(self.equipData, 1, true)
    self.other_attributeTo_layer:addChild(rgTableView)--, 10, TAG_VIPVIEW)  -- 将tableView加到tableViewBg上

    ------------------------------------------------------

    -- 强化后更新
    self:limitLevel()

end

-- 限制等级
function PVEquipmentStrengthen:limitLevel()
    local commonData = getDataManager():getCommonData()
    local baseTemp = getTemplateManager():getBaseTemplate()
    local moreLevel = baseTemp:getEquipStrengthMax()

    -- if moreLevel + commonData:getLevel() <= self.currLevel or self.currLevel >= 200 then 
    local _maxLevel =  getTemplateManager():getBaseTemplate():getMaxLevel()
    if commonData:getLevel() <= self.currLevel or self.currLevel >= _maxLevel then 
        self.menugo:setEnabled(false)
        self.menuOnekey:setEnabled(false)
    else
        self.menugo:setEnabled(true)
        local isCanOneKey = baseTemp:getOneKeyStrength()
        if isCanOneKey == true then 
            self.menuOnekey:setEnabled(true)
        else
            self.menuOnekey:setEnabled(false)
        end
    end

    if commonData:getCoin() < self.useMoney then
        self.labelNeedMoney:setColor(ui.COLOR_RED)
    else
        self.labelNeedMoney:setColor(ui.COLOR_WHITE)
    end
    if commonData:getCoin() < self.oneKeyMoney then
        self.labelOneKeyNeedMoney:setColor(ui.COLOR_RED)
    else
        self.labelOneKeyNeedMoney:setColor(ui.COLOR_WHITE)
    end 

end


function PVEquipmentStrengthen:initTouchListener()

    local function backMenuClick()
        getAudioManager():playEffectButton2()

        groupCallBack(GuideGroupKey.BTN_CLICK_BACK_IN_EQUIPMENT)
            
        self:onHideView()
    end

    local function composeMenuClick()
        getAudioManager():playEffectButton2()

        if self.useMoney < getDataManager():getCommonData():getCoin() then
            print("strength once:")
            getNetManager():getEquipNet():sendEnHanceMsg(self.equipData.id, 1)
            self.strengthType = 1
        else
            -- getOtherModule():showToastView( Localize.query("equip.8") )
            getOtherModule():showAlertDialog(nil, Localize.query("equip.8"))

        end
        --getNewGManager():hideHandSprite()
        -- if self.strengthenCount==0 then
        --     stepCallBack(G_GUIDE_40119)    -- 点击强化
        -- -- elseif self.strengthenCount==1 then 
        --     stepCallBack(G_GUIDE_40120)    -- 点击强化
        -- -- elseif self.strengthenCount==2 then 
        --     stepCallBack(G_GUIDE_40121)    -- 点击强化
        -- end
        groupCallBack(GuideGroupKey.BTN_CLICK_QIANGHUA_EQUIPMENT3, self.equipData.no)
        groupCallBack(GuideGroupKey.BTN_CLICK_QIANGHUA_EQUIPMENT2, self.equipData.no)
        -- groupCallBack(GuideGroupKey.BTN_CLICK_QIANGHUA_EQUIPMENT1, self.equipData.no)
        groupCallBack(GuideGroupKey.BTN_CLOSE_QIANGHUA_EQUIPMENT, self.equipData.no)
                

        local delayAction1 = cc.DelayTime:create(2) 
        local function callBack()
            local gId = getNewGManager():getCurrentGid()
            print("gId===========", gId)
            --TODO: 注释掉，有问题打开重写
           -- if gId == G_GUIDE_40120 or gId == G_GUIDE_40121 or gId == G_GUIDE_40122 then
           --      getNewGManager():startGuide()
           --      self.strengthenCount = self.strengthenCount + 1
           -- end
        end

        local sequenceAction1 = cc.Sequence:create(delayAction1, cc.CallFunc:create(callBack))
        self:runAction(sequenceAction1)

    end

    local function composeTenMenuClick()
        print("1111111")
        getAudioManager():playEffectButton2()
        if self.useMoney < getDataManager():getCommonData():getCoin() then
            --一键强化获得能强化的次数
            print("onekey strength :", self.oneKeyLevel)
            self.oneKeyLevels = self.oneKeyLevel
            getNetManager():getEquipNet():sendEnHanceMsg(self.equipData.id, 2)
            self.strengthType = 2
        else
            -- getOtherModule():showToastView( Localize.query("equip.8") )
            getOtherModule():showAlertDialog(nil, Localize.query("equip.8"))

        end   
    end

    local function onRightMove()
        -- body
        g_equipListIndex = g_equipListIndex + 1
        self.equipData = nil
        self.equipData = self.equipCanStrengTable[g_equipListIndex] 
        if self.equipData ~= nil then
            self:updateView()
            self.menuLeft:setVisible(true)
        else
            self.menuLeft:setVisible(true)
            self.menuRight:setVisible(false)
            g_equipListIndex = g_equipListIndex - 1
        end
    end


    local function onLeftMove()
        -- body
        g_equipListIndex = g_equipListIndex - 1
        self.equipData = nil
        self.equipData = self.equipCanStrengTable[g_equipListIndex] 
        if self.equipData ~= nil then
            self:updateView()
            self.menuRight:setVisible(true)
            if g_equipListIndex == 1 then
                self.menuLeft:setVisible(false)
            end
        else
            self.menuLeft:setVisible(false)
            self.menuRight:setVisible(true)
            if g_equipListIndex == 0 then
                g_equipListIndex = g_equipListIndex + 1
            end
        end
    end

    self.ccbiNode["UIEquipStrengDetail"] = {}
    self.ccbiNode["UIEquipStrengDetail"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UIEquipStrengDetail"]["composeMenuClick"] = composeMenuClick
    self.ccbiNode["UIEquipStrengDetail"]["composeTenMenuClick"] = composeTenMenuClick
    self.ccbiNode["UIEquipStrengDetail"]["onRightMove"] = onRightMove
    self.ccbiNode["UIEquipStrengDetail"]["onLeftMove"] = onLeftMove
end

function PVEquipmentStrengthen:strengthEquipSort()
    -- body
    self.equipData = self.funcTable[1]
    self.equipList = self.c_equipData:getEquipList()
    local _equipedWho = self.lineupData:getEquipTo(self.equipData.id)
    --强化列表
    _index = 1
    for k,v in pairs(self.equipList) do
        local type = self.c_equipTemp:getTemplateById(v.no).type
        if type ~= nil and type ~= 5 and type ~= 6 then
            self.equipCanStrengTable[_index] = v
            _index = _index + 1
        end
    end
    local function isEquip(id)
        return self:getIsEquip(id)
    end

    local function cmp1(a,b)  -- 已经装配的至于未装配上方 按照等级大>小，品质大>小 降序排序,
        local _isEquipedA = isEquip(a.id)
        local _isEquipedB = isEquip(b.id)
        if _isEquipedA > _isEquipedB then return true
        elseif _isEquipedA == _isEquipedB then
            if a.strengthen_lv > b.strengthen_lv then return true
            elseif a.strengthen_lv == b.strengthen_lv then
                local _qualityA = self.c_equipTemp:getQuality(a.no)
                local _qualityB = self.c_equipTemp:getQuality(b.no)
                if _qualityA > _qualityB then return true
                else return false end
            else return false
            end
        else return false
        end
    end

    table.sort(self.equipCanStrengTable, cmp1)
end

-- 根据阵容槽 将装备依次排序
function PVEquipmentStrengthen:getIsEquip(id)
    local _equipedWho = self.lineupData:getEquipTo(id)
    if _equipedWho == Localize.query("equip.1") then
        if id == self.equipData.id then
            return 9
        else
            return 0
        end
    else
        if _equipedWho == self.lineupData:getEquipTo(self.equipData.id) then
            if id == self.equipData.id then
                return 9
            else
                return 8 
            end
        else
            for i=1, 6 do
                local  _equipIds = self.lineupData:getEquipIds(i)
                if _equipIds ~= nil then
                    for k, v in pairs(_equipIds) do
                        if id == v then
                            return 8 - i
                        end
                    end
                end
            end
        end
    end
end


-- function PVEquipmentStrengthen:registerNetCallback()

--     local function responseEnhanceCallback(id, data)
--         -- cclog(" @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ui response enhance ...")
--         -- table.print(data)
--         if data.res.result == true then
--             cclog("<<<== 强化装备处理返回的数据fdsafafe ==>>>")
--             table.print(data)
--             cclog("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
--             self.menugo:setEnabled(false)
--             self.menuOnekey:setEnabled(false)
--             table.print(data.data)
--             -- local enhanceData = data.data[1]
--             local enhanceData = data.data
--             local _cost_coin = 0
--             local _num = #enhanceData
--             for i = 1,_num do
--                 print("---enhanceData[i].cost_coin---",enhanceData[i].cost_coin)
--                 _cost_coin = _cost_coin + enhanceData[i].cost_coin
--             end
--             print("------data.data.cost_coin--------------",_cost_coin)
--             getDataManager():getCommonData():subCoin(_cost_coin)
--             -- getDataManager():getCommonData():subCoin(enhanceData.cost_coin)
--             getDataManager():getEquipmentData():setStrengLv(self.equipData.id, enhanceData[_num].after_lv)
--             getDataManager():getEquipmentData():changeEnhance(self.equipData.id,enhanceData)
--             self.lineupData:changeEquipmentById(self.equipData.id)
--             print("-----enhanceData.after_lv-----",enhanceData[_num].after_lv,  enhanceData[1].before_lv,_num)
--             self.levelUp = enhanceData[_num].after_lv - enhanceData[1].before_lv
--             self.labelUp1:setString("等级+"..self.levelUp)
--             self.labelUp2:setString("等级+"..self.levelUp)
--             local main_attr = self.equipData.main_attr
--             local zhuNum = main_attr[1].attr_increment * enhanceData[_num].before_lv + main_attr[1].attr_value
--             local zhuNextNum = main_attr[1].attr_increment * enhanceData[_num].after_lv + main_attr[1].attr_value
--             local typeName = getTemplateManager():getEquipTemplate():setSXName(main_attr[1].attr_type)
--             zhuNum = math.floor(zhuNum*10)/10
--             zhuNextNum = math.floor(zhuNextNum*10)/10
--             self.labelAttrUp1:setString(typeName..zhuNextNum-zhuNum)
--             self.labelAttrUp2:setString(typeName..zhuNextNum-zhuNum)

--             self.currLevel = enhanceData.after_lv
--             -- local _equipedWho = self.lineupData:getEquipTo(self.equipData.id)
--             ---------------传承----------------
--             local _inherit = self.funcTable[2]
--             if _inherit ~= nil then
--                 if _inherit == 0 then 
--                     getDataManager():getInheritData():setequId1(getDataManager():getEquipmentData():getEqu(self.equipData.id))
--                 else  
--                     getDataManager():getInheritData():setequId2(getDataManager():getEquipmentData():getEqu(self.equipData.id))
--                 end 
--                 local event = cc.EventCustom:new(UPDATE_VIEW)
--                 self:getEventDispatcher():dispatchEvent(event)
--             end
--             -------------------------------

--             local function hideTips()
--                 self.breakNode:setVisible(false)
--                 self.successNode:setVisible(false)

--                 self.menuRight:setEnabled(true)
--                 self.menuLeft:setEnabled(true)

--                 ---战力提升
--                 self.c_CommonData.updateCombatPower()
--             end
--             local function callback()
--                 self.animationNode:removeChildByTag(1000)
--                 if enhanceData then
--                     self.imgEffect3:setVisible(false)
--                     self:updateView()
--                     -- self.imgEffect4:setVisible(true)
--                     -- self.imgEffect4:setOpacity(255)
--                     print("-----一键强化成功------")
--                     print(self.strengthType,self.levelUp,self.oneKeyLevels)
--                     if self.strengthType == 1 and self.levelUp ~= 1 then -- break
--                         self.breakNode:setVisible(true)
--                     elseif self.strengthType == 1 and self.levelUp == 1 then -- success
--                         self.successNode:setVisible(true)
--                     elseif self.strengthType == 2 and self.levelUp == self.oneKeyLevels then -- success
--                         self.successNode:setVisible(true)
--                     elseif self.strengthType == 2 and self.levelUp ~= self.oneKeyLevels then -- break
--                         self.breakNode:setVisible(true)
--                     end
--                     self.animationManager:runAnimationsForSequenceNamed("showOver")
--                     local seq = cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(hideTips))
--                     self:runAction(seq)
--                 end
--             end

--             -- local node = UI_Zhaungbeiqianghua(callback)
--    
--             local node = UI_Zhaungbeiqianghuajiu(callback)
--            
--             self.animationNode:addChild(node)
--             self.imgEffect3:setVisible(true)
--             self.menuRight:setEnabled(false)
--             self.menuLeft:setEnabled(false)
--         else
--             cclog("!!! 数据返回错误")
--         end
--     end

--     self:registerMsg(EQU_ENHANCE_CODE, responseEnhanceCallback)
-- end
return PVEquipmentStrengthen

