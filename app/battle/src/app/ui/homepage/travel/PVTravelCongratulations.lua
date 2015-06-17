
--游历
--恭喜获得
local PVTravelCongratulations = class("PVTravelCongratulations", BaseUIView)

function PVTravelCongratulations:ctor(id)
    self.super.ctor(self, id)

    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
    self.dropTemp = getTemplateManager():getDropTemplate()

    self.commonData = getDataManager():getCommonData()
end

function PVTravelCongratulations:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_common.plist")
    --self:showAttributeView()
    self.UICommonGetCard = {}
    self:initTouchListener()
    --加载本界面的ccbi
    self:loadCCBI("common/ui_common_getcard.ccbi", self.UICommonGetCard)
    print("***************")
    self:initView()

    self:initData()
end

function PVTravelCongratulations:initView()
    self.contentView = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]
    self.propIcon = self.UICommonGetCard["UICommonGetCard"]["propIcon"]

    local proxy = cc.CCBProxy:create()
    local itemInfo = {}
    local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, itemInfo)
    self.contentView:addChild(node)

    self.img_card = itemInfo["UICommonGetCard"]["img_card"]
    game:setSpriteFrame(nodeSp, "#ui_common_framep.png")

    self.label_number = itemInfo["UICommonGetCard"]["label_number"]


    local laySize = self.contentView:getContentSize()
    local cardSize = node:getContentSize()
    node:setPositionX(laySize.width/2 - cardSize.width/2)
end

-- 处理未完成的事件
function PVTravelCongratulations:doUnfinishEvent()
    -- 处理未完成事件
     local _afterGain = self.funcTable[3]
    if _afterGain~=nil and s_afterGain==2 then
        local event = cc.EventCustom:new(UPDATE_UNFINISHEVENT)
        self:getEventDispatcher():dispatchEvent(event)
    end
end

function PVTravelCongratulations:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    --退出
    local function onSureClick()
        getAudioManager():playEffectButton2()
        self:onHideView()

        groupCallBack(GuideGroupKey.BTN_YOULI_BAOXIANG_CONFIRM)
        -- stepCallBack(G_GUIDE_80008)
    end
    self.UICommonGetCard["UICommonGetCard"] = {}
    self.UICommonGetCard["UICommonGetCard"]["onCloseClick"] = onCloseClick
    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick
end

-- 初始化数据
function PVTravelCongratulations:initData()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    if self.funcTable[1] == 9 then -- 鞋子
        local res = ""
        local name = ""
        local pin = ""
        if self.funcTable[2].shoes_info[1].shoes_type == CAO_SHOES then
            res, name = getTemplateManager():getBaseTemplate():getCaoXieResName(1)
            pin = getTemplateManager():getBaseTemplate():getCaoXiePin(1)
        elseif self.funcTable[2].shoes_info[1].shoes_type == BU_SHOES then 
            res, name = getTemplateManager():getBaseTemplate():getCaoXieResName(2)
            pin = getTemplateManager():getBaseTemplate():getCaoXiePin(2)
        elseif self.funcTable[2].shoes_info[1].shoes_type == PI_SHOES then 
            res, name = getTemplateManager():getBaseTemplate():getCaoXieResName(3)  
            pin = getTemplateManager():getBaseTemplate():getCaoXiePin(3)
        end
        res = res..".webp"
        res = "res/icon/resource/"..res
        

        local bgSprite = cc.Sprite:create()
        self.img_card:removeAllChildren()
        self.img_card:addChild(bgSprite, 1)
        self.img_card:setTexture(res)
        
        local resPin = ""
        -- 绿、蓝3星、蓝4星、紫5星、紫6星
        if pin == 1 or pin == 2 then
            resPin = resPin.."#ui_common2_bg2_lv.png"
        elseif pin == 3 or pin == 4 then 
            resPin = resPin.."#ui_common2_bg2_lan.png"
        elseif pin == 5 or pin == 6 then 
            resPin = resPin.."#ui_common2_bg2_zi.png"
        end
        game.setSpriteFrame(bgSprite, resPin)
        bgSprite:setPosition(self.img_card:getContentSize().width / 2, self.img_card:getContentSize().height / 2)

        self.label_number:setString(string.format("X %d", self.funcTable[2].shoes_info[1].shoes_no))
    elseif self.funcTable[1] == 1 then
        print("恭喜获得，一堆风物志")
        self.dropsList = self:getTransferData()[2]
        self.img_card:setVisible(false)
        self.label_number:setVisible(false)
        self:createDropsList()
    else
        print("恭喜获得，风物志")
        table.print(self:getTransferData()[2])
        self.drops = self:getTransferData()[2]
        local meetNum = 1
     
        if self.drops["type"] == "finance" then
        
            self.commonData = getDataManager():getCommonData()       
            if self.drops.coin ~= nil and self.drops.coin> 0 then
                meetNum = self.drops.coin 
                detailName = "银两" 
                getDataManager():getTravelData():changeFengIconImage(self.img_card, 0 ,false) 
            end
            if self.drops.gold ~= nil and self.drops.gold>0 then meetNum = self.drops.gold detailName = "元宝"  end
            
            if self.drops.junior_stone ~= nil and self.drops.junior_stone>0 then meetNum = self.drops.junior_stone   detailName = "百炼石" end
            if self.drops.middle_stone ~= nil and self.drops.middle_stone>0 then meetNum = self.drops.middle_stone   detailName = "千锤石" end
            if self.drops.high_stone ~= nil and self.drops.high_stone>0 then meetNum = self.drops.high_stone   detailName = "精炼石" end
            

            if self.drops.hero_soul ~= nil and self.drops.hero_soul>0 then 
                print("-------------武魂")
                meetNum = self.drops.hero_soul
                detailName = "武魂"
                setItemImage3(self.img_card, "res/icon/resource/resource_3.png", 1)
            end

            if self.drops.finance_changes ~= nil then
                print(self.drops.finance_changes)
                print(table.nums(self.drops.finance_changes))
                print("-------------finance_changes")
                for k,v in pairs(self.drops.finance_changes) do
                    meetNum = v.item_num
                    local _resourceTemp = getTemplateManager():getResourceTemplate()
                    local _icon = _resourceTemp:getResourceById(v.item_no)
                    setItemImage3(self.img_card, "res/icon/resource/".._icon, 1)
                    detailName = _resourceTemp:getResourceName(v.item_no)
                end
            end

        elseif self.drops["type"] == "travel_item" then
        
            meetNum = self.drops[1]["num"]
            
            --detailName = getTemplateManager():getTravelTemplate():getFentWuzhiByAwardId(self.drops[1]["id"])
            getDataManager():getTravelData():changeFengIconImage(self.img_card, self.drops[1]["id"] ,false)
            -- self.img_card:setScale(1.3)
            
            if getDataManager():getTravelData():setIsHaveFengWuZhi(self.drops[1]["id"]) then
            else
                print("新")
                -- self.contentView 
                local bgSprite = cc.Sprite:createWithSpriteFrameName("ui_stage_new_bgred.png")
                bgSprite:setScale(0.5)
                bgSprite:setAnchorPoint(cc.p(0.5, 0.5))
                self.contentView:addChild(bgSprite)
                -- local self.contentView:getPosition
                bgSprite:setPosition(self.propIcon:getPositionX()-self.contentView:getPositionX()+self.img_card:getContentSize().width / 2-10, self.propIcon:getPositionY()-self.contentView:getPositionY()+self.img_card:getContentSize().width / 2-10)
                -- game.setSpriteFrame(bgSprite, "#ui_stage_new_bgred.png")
            end



        elseif self.drops["type"] == "heros" then  -- 武将
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..self.drops[1]["hero_no"])
            meetNum = 1 --self.drops[1]["num"]

            local _temp = self.soldierTemp:getSoldierIcon(self.drops[1]["hero_no"])
            local quality = self.soldierTemp:getHeroQuality(self.drops[1]["hero_no"])
            changeNewIconImage(self.img_card, _temp, quality)

        elseif self.drops["type"] == "equips" then  -- 装备
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..self.drops[1]["no"])
            meetNum = 1 --self.drops[1]["num"]

           local _temp = self.equipTemp:getEquipResIcon(self.drops[1]["no"])
            local quality = self.equipTemp:getQuality(self.drops[1]["no"])
            changeEquipIconImageBottom(self.img_card, _temp, quality)

        elseif self.drops["type"] == "h_chips" then  -- 英雄灵魂石
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..self.drops[1]["hero_chip_no"])
            meetNum = self.drops[1]["hero_chip_num"]

            local _temp = self.chipTemp:getTemplateById(self.drops[1]["hero_chip_no"]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            setChipWithFrame(self.img_card, "res/icon/hero/".._icon, 1)

        elseif self.drops["type"] == "e_chips" then  -- 英雄灵魂石
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..self.drops[1]["equipment_chip_no"])
            meetNum = self.drops[1]["equipment_chip_num"]

            local _temp = self.chipTemp:getTemplateById(self.drops[1]["equipment_chip_no"]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            setChipWithFrame(self.img_card, "res/icon/equipment/".._icon, 1)

         elseif self.drops["type"] == "items" then  -- item
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..self.drops[1]["item_no"])
            meetNum = self.drops[1]["item_num"]

           local _temp = self.bagTemp:getItemResIcon(self.drops[1]["item_no"])
            local quality = self.bagTemp:getItemQualityById(self.drops[1]["item_no"])
            setItemImage(self.img_card, "res/icon/item/".._temp, quality)

        end

        self.label_number:setString(string.format("X %d", meetNum))
        -- print(">>>>>>>>>>>>>>>>num:"..meetNum)
    end 

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
end

function PVTravelCongratulations:createDropsList()
    
    local function tableCellTouched(tbl, cell)
        cclog("cell item ================ ")
    end

    local function numberOfCellsInTableView(tab)
       return table.getn(self.dropsList)
    end
    local function cellSizeForTable(tbl, idx)
        return 135,105
    end
    local function tableCellAtIndex(tbl, idx)

        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   "..idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UICommonGetCard"] = {}
            local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, cell.itemInfo)
            --node:setScale(0.85)
            cell:addChild(node)
            cell.img_card = cell.itemInfo["UICommonGetCard"]["img_card"]
            cell.labelNum = cell.itemInfo["UICommonGetCard"]["label_number"]
        end

        cell.reward = self.dropsList[idx+1]

        local meetNum = 1
        local detailName = "银两"
     
        if cell.reward["type"] == "finance" then  
            if cell.reward.coin ~= nil and cell.reward.coin> 0 then
                meetNum = cell.reward.coin 
                detailName = "银两" 
                getDataManager():getTravelData():changeFengIconImage(cell.img_card, 0 ,false) 
            end
            if cell.reward.gold ~= nil and cell.reward.gold>0 then meetNum = cell.reward.gold detailName = "元宝"  end
            
            if cell.reward.junior_stone ~= nil and cell.reward.junior_stone>0 then meetNum = cell.reward.junior_stone   detailName = "百炼石" end
            if cell.reward.middle_stone ~= nil and cell.reward.middle_stone>0 then meetNum = cell.reward.middle_stone   detailName = "千锤石" end
            if cell.reward.high_stone ~= nil and cell.reward.high_stone>0 then meetNum = cell.reward.high_stone   detailName = "精炼石" end
            

            if cell.reward.hero_soul ~= nil and cell.reward.hero_soul>0 then 
                print("-------------武魂")
                meetNum = cell.reward.hero_soul
                detailName = "武魂"
                setItemImage(cell.img_card, "res/icon/resource/resource_3.png", 1)
            end

            if cell.reward.finance_changes ~= nil then
                print(cell.reward.finance_changes)
                print(table.nums(cell.reward.finance_changes))
                print("-------------finance_changes")
                for k,v in pairs(cell.reward.finance_changes) do
                    meetNum = v.item_num
                    local _resourceTemp = getTemplateManager():getResourceTemplate()
                    local _icon = _resourceTemp:getResourceById(v.item_no)
                    setItemImage(cell.img_card, "res/icon/resource/".._icon, 1)
                    detailName = _resourceTemp:getResourceName(v.item_no)
                end
            end

        elseif cell.reward["type"] == "travel_item" then
        
            meetNum = cell.reward[1]["num"]
            
            cell.img_card:removeAllChildren()
            getDataManager():getTravelData():changeFengIconImage(cell.img_card, cell.reward[1]["id"] ,false , false)
            -- cell.img_card:setScale(1.3)
            
            if getDataManager():getTravelData():setIsHaveFengWuZhi(cell.reward[1]["id"]) then
            else
                local bgSprite = cc.Sprite:createWithSpriteFrameName("ui_stage_new_bgred.png")
                bgSprite:setScale(0.5)
                bgSprite:setAnchorPoint(cc.p(0.5, 0.5))
                self.contentView:addChild(bgSprite)
               
                bgSprite:setPosition(self.propIcon:getPositionX()-self.contentView:getPositionX()+cell.img_card:getContentSize().width / 2-10, self.propIcon:getPositionY()-self.contentView:getPositionY()+self.img_card:getContentSize().width / 2-10)
            end
        elseif cell.reward["type"] == "heros" then  -- 武将
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..cell.reward[1]["hero_no"])
            meetNum = 1 --self.drops[1]["num"]

            local _temp = self.soldierTemp:getSoldierIcon(cell.reward[1]["hero_no"])
            local quality = self.soldierTemp:getHeroQuality(cell.reward[1]["hero_no"])
            changeNewIconImage(cell.img_card, _temp, quality)

        elseif cell.reward["type"] == "equips" then  -- 装备
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..cell.reward[1]["no"])
            meetNum = 1 --self.drops[1]["num"]

           local _temp = self.equipTemp:getEquipResIcon(cell.reward[1]["no"])
            local quality = self.equipTemp:getQuality(cell.reward[1]["no"])
            changeEquipIconImageBottom(cell.img_card, _temp, quality)

        elseif cell.reward["type"] == "h_chips" then  -- 英雄灵魂石
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..cell.reward[1]["hero_chip_no"])
            meetNum = scell.reward[1]["hero_chip_num"]

            local _temp = self.chipTemp:getTemplateById(cell.reward[1]["hero_chip_no"]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            setChipWithFrame(cell.img_card, "res/icon/hero/".._icon, 1)

        elseif cell.reward["type"] == "e_chips" then  -- 英雄灵魂石
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..cell.reward[1]["equipment_chip_no"])
            meetNum = cell.reward[1]["equipment_chip_num"]

            local _temp = self.chipTemp:getTemplateById(cell.reward[1]["equipment_chip_no"]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            setChipWithFrame(cell.img_card, "res/icon/equipment/".._icon, 1)

         elseif cell.reward["type"] == "items" then  -- item
            print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>"..cell.reward[1]["item_no"])
            meetNum = cell.reward[1]["item_num"]

           local _temp = self.bagTemp:getItemResIcon(cell.reward[1]["item_no"])
            local quality = self.bagTemp:getItemQualityById(cell.reward[1]["item_no"])
            setItemImage(cell.img_card, "res/icon/item/".._temp, quality)

        end

        cell.labelNum:setString(string.format("X %d", meetNum))

        print("--------"..detailName.."--------"..meetNum)
        

       return cell
    end

    local layerSize = self.contentView:getContentSize()
    local tabView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    local itemCount = table.nums(self.dropsList)
    print("-----------table.nums(self.dropsList)++++++++++++++"..itemCount)
    if itemCount ~= nil and itemCount < 4 then
        tabView:setPosition(cc.p((4 - itemCount) * 105 / 2, -10))
    else
        tabView:setPosition(cc.p(0 , -10))
    end

    tabView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    --tabView:setPosition(cc.p(0, -10))
    tabView:setDelegate()
    tabView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentView:addChild(tabView)

    tabView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    tabView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tabView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tabView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    tabView:reloadData()
   
end

return PVTravelCongratulations
