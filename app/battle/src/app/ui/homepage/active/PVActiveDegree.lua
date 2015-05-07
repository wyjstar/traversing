--活跃度界面
local PVActiveDegree = class("PVActiveDegree", BaseUIView)
-- local PVScrollBar = import("..scrollbar.PVScrollBar")

function PVActiveDegree:ctor(id)
    PVActiveDegree.super.ctor(self, id)
end

function PVActiveDegree:onMVCEnter()
    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_activeDegree.plist")

    self.c_activeData = getDataManager():getActiveData()
    self.c_activeNet = getNetManager():getActiveNet()
    self.c_AchievementTempalte = getTemplateManager():getAchievementTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_StageData = getDataManager():getStageData()
    self.dropTemp = getTemplateManager():getDropTemplate()
    self.baseTemp = getTemplateManager():getBaseTemplate()

    self:initData()
    self:initView()
    self:registerCallBack()
end

function PVActiveDegree:onExit()
    -- self:unregisterScriptHandler()
    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    getDataManager():getResourceData():clearResourcePlistTexture()
end

function PVActiveDegree:registerCallBack()
    --领取奖励返回
    local function getRewardCallBack(id, data)
        -- print("领取奖励返回 ------------ ")
        
        print(data)


        getDataProcessor():gainGameResourcesResponse(data.gain)

        local teamExp = data.gain.team_exp
        local _commonData = getDataManager():getCommonData()

        print("------teamExp---------")
        print(teamExp)

        if teamExp ~= nil and teamExp ~= 0 and teamExp > 0 then
            print("getRewardCallBack------000")
            local exp = _commonData:getExp()
            local level = _commonData:getLevel()
            local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)

            if exp > maxExp then
                print("getRewardCallBack------11111")
                local  addLevels = 1
                local remainExp = exp - maxExp
                maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level+addLevels)
                while remainExp > maxExp do
                    print("getRewardCallBack------22222")
                    addLevels = addLevels + 1
                    remainExp = remainExp - maxExp
                    maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level+addLevels)
                    print("-----maxExp--------",maxExp)
                    print("-----remainExp--------",remainExp)
                end

                _commonData:setLevel(level+addLevels)
                _commonData:setExp(remainExp)
            end
        end


        local rewards = {}
        if id == ACTIVE_RECEIVE_REWARD then
            if table.getn(self.smallBagIds) > 0 then
                for k, v in pairs(self.smallBagIds) do
                    local smallBagId = self.smallBagIds[k]
                    local smallItem = self.dropTemp:getSmallBagById(smallBagId)
                    table.insert(rewards, smallItem)
                end
            end
            -- print("活跃度领取奖励 ============== ")
            -- table.print(rewards)
            getOtherModule():showOtherView("PVCongratulationsGainDialog", 4, rewards)
            local isHave = self.c_activeData:getNotice()
            touchNotice(NOTICE_ACTIVE_DEGREE, isHave)
            self.recieveMenuItem:setEnabled(false)
            self:initData()
            self:updateOtherView()
        end
    end

    self:registerMsg(ACTIVE_RECEIVE_REWARD, getRewardCallBack)

    --请求
    local function getInfoCallBack()
        self:initData()
        self:resetTabviewContentOffset(self.tableView)
        self.tableView:reloadData()
        self:tableViewItemAction(self.tableView)
        self:updateOtherView()
    end
    self:registerMsg(ACTIVE_TASK_LIST, getInfoCallBack)
end

function PVActiveDegree:initData()
    self.taskList = self.c_activeData:getTaskList()
    self.itemCount = table.getn(self.taskList)
    self.rewardList = self.c_activeData:getRewardList()

    for k, v in pairs(self.rewardList) do
        if v.status == 2 then
            self.curRewarId = v.tid
            break
        else
            self.curRewarId = self.rewardList[1].tid
        end
    end
end


function PVActiveDegree:initView()
    self.UIActiveDegreeView = {}

    self:initTouchListener()

    self:loadCCBI("activeDegree/ui_activeDegree_view.ccbi", self.UIActiveDegreeView)

    --领取奖励的图片
    self.receiveSprite1 = self.UIActiveDegreeView["UIActiveDegreeView"]["receiveSprite1"]
    self.receiveSprite2 = self.UIActiveDegreeView["UIActiveDegreeView"]["receiveSprite2"]
    self.receiveSprite3 = self.UIActiveDegreeView["UIActiveDegreeView"]["receiveSprite3"]
    self.receiveSprite4 = self.UIActiveDegreeView["UIActiveDegreeView"]["receiveSprite4"]
    self.receiveSprite5 = self.UIActiveDegreeView["UIActiveDegreeView"]["receiveSprite5"]

    --宝箱发光的图片
    self.box_light1 = self.UIActiveDegreeView["UIActiveDegreeView"]["box_light1"]
    self.box_light2 = self.UIActiveDegreeView["UIActiveDegreeView"]["box_light2"]
    self.box_light3= self.UIActiveDegreeView["UIActiveDegreeView"]["box_light3"]
    self.box_light4 = self.UIActiveDegreeView["UIActiveDegreeView"]["box_light4"]
    self.box_light5 = self.UIActiveDegreeView["UIActiveDegreeView"]["box_light5"]

    --宝箱按钮
    self.boxMenu1 = self.UIActiveDegreeView["UIActiveDegreeView"]["boxMenu1"]
    self.boxMenu2 = self.UIActiveDegreeView["UIActiveDegreeView"]["boxMenu2"]
    self.boxMenu3 = self.UIActiveDegreeView["UIActiveDegreeView"]["boxMenu3"]
    self.boxMenu4 = self.UIActiveDegreeView["UIActiveDegreeView"]["boxMenu4"]
    self.boxMenu5 = self.UIActiveDegreeView["UIActiveDegreeView"]["boxMenu5"]

    --数值
    self.desLabel1 = self.UIActiveDegreeView["UIActiveDegreeView"]["desLabel1"]
    self.desLabel2 = self.UIActiveDegreeView["UIActiveDegreeView"]["desLabel2"]
    self.desLabel3 = self.UIActiveDegreeView["UIActiveDegreeView"]["desLabel3"]
    self.desLabel4 = self.UIActiveDegreeView["UIActiveDegreeView"]["desLabel4"]
    self.desLabel5 = self.UIActiveDegreeView["UIActiveDegreeView"]["desLabel5"]

    --进度箭头
    self.curSprite = {}
    self.curSprite[2] = self.UIActiveDegreeView["UIActiveDegreeView"]["sprite1"]
    self.curSprite[3] = self.UIActiveDegreeView["UIActiveDegreeView"]["sprite2"]
    self.curSprite[4] = self.UIActiveDegreeView["UIActiveDegreeView"]["sprite3"]
    self.curSprite[5] = self.UIActiveDegreeView["UIActiveDegreeView"]["sprite4"]

    -- self.menustatus1 = {}
    -- self.menustatus2 = {}
    -- self.menustatus3 = {}
    -- self.menustatus4 = {}
    -- self.menustatus5 = {}
    -- self.menustatus1 = {self.boxMenu1, {self.receiveSprite1, self.box_light1}, self.boxMenu1}
    -- self.menustatus2 = {self.boxMenu2, {self.receiveSprite2, self.box_light2}, self.boxMenu2}
    -- self.menustatus3 = {self.boxMenu3, {self.receiveSprite3, self.box_light3}, self.boxMenu3}
    -- self.menustatus4 = {self.boxMenu4, {self.receiveSprite4, self.box_light4}, self.boxMenu4}
    -- self.menustatus5 = {self.boxMenu5, {self.receiveSprite5, self.box_light5}, self.boxMenu5}

    --优化
    self.menustatus = {}

    self.menustatus[1] = {self.boxMenu1, {self.receiveSprite1, self.box_light1}, self.boxMenu1, self.desLabel1}
    self.menustatus[2] = {self.boxMenu2, {self.receiveSprite2, self.box_light2}, self.boxMenu2, self.desLabel2}
    self.menustatus[3] = {self.boxMenu3, {self.receiveSprite3, self.box_light3}, self.boxMenu3, self.desLabel3}
    self.menustatus[4] = {self.boxMenu4, {self.receiveSprite4, self.box_light4}, self.boxMenu4, self.desLabel4}
    self.menustatus[5] = {self.boxMenu5, {self.receiveSprite5, self.box_light5}, self.boxMenu5, self.desLabel5}

    --当前获取的活跃度
    self.activeDegreeNum = self.UIActiveDegreeView["UIActiveDegreeView"]["activeDegreeNum"]

    --奖励layer
    self.activeDJiangliLayer = self.UIActiveDegreeView["UIActiveDegreeView"]["activeDJiangliLayer"]

    --增加活跃度的途径列表layer
    self.activeDegreeItemLayer = self.UIActiveDegreeView["UIActiveDegreeView"]["activeDegreeItemLayer"]

    --领取奖励按钮
    self.recieveMenuItem = self.UIActiveDegreeView["UIActiveDegreeView"]["recieveMenuItem"]

    --奖励展示，暂时
    self.rewardIcon = self.UIActiveDegreeView["UIActiveDegreeView"]["rewardIcon"]
    self.activeJLItemNum = self.UIActiveDegreeView["UIActiveDegreeView"]["activeJLItemNum"]


    self:initTable()

    print("--self.rewardList-----")

    for k,v in pairs(self.rewardList) do

        print(v.status)

        if v.status == 2 then  -- 可以领取
            self.curRewarId = v.tid
            
            print(self.curRewarId)

            self:updateCurReward(v.tid, k)
            break
        else
            self.recieveMenuItem:setEnabled(false)
            self:updateCurReward(self.curRewarId, 1)
        end
    end

    self:createRewardsList(self.activeDJiangliLayer)

    self:updateOtherView()
    -- self.menustatus[1][1]:setScale(1.2)
end

--更新奖励按钮的状态
function PVActiveDegree:updateAwardItemStatus(menustatus, status, k)
    print("menustatus, status, k ========== ", menustatus, status, k)
    if status == 2 then
        self.menustatus[1] = {self.boxMenu1, {self.receiveSprite1, self.box_light1}, self.boxMenu1, self.desLabel1}
        local _award = menustatus[2]
        _award[1]:setVisible(true)
        _award[2]:setVisible(true)
        menustatus[3]:setEnabled(true)
        menustatus[4]:setString(k * 20)
        self.recieveMenuItem:setEnabled(true)
    elseif status == 3 then
        local _award = menustatus[2]
        -- _award[1]:setVisible(false)
        -- _award[2]:setVisible(false)
        -- menustatus[3]:setDisabledSpriteFrame(game.newSprite("#ui_activeDegree_acc.png"))
        game.addSpriteFramesWithFile("res/ccb/resource/ui_instance.plist")
        menustatus[3]:getNormalImage():setSpriteFrame("ui_stage_goldbox_open.png")
        menustatus[3]:getDisabledImage():setSpriteFrame("ui_stage_goldbox_open.png")
        -- menustatus[3]:setEnabled(false)

        -- menustatus[4]:setString("已领取")
        self.recieveMenuItem:setEnabled(false)
    else
        SpriteGrayUtil:drawSpriteTextureGray(menustatus[3]:getNormalImage())
        -- menustatus[3]:setScale(0.6)
        -- menustatus[3]:getDisabledImage():setSpriteFrame("ui_activeDegree_bxhh.png")
    end

end

--界面及时更新 （当前活跃度、领取奖励按钮状态、领取奖励按钮进度）
function PVActiveDegree:updateOtherView()
    self.curDegreeNum = 0

    for k,v in pairs(self.rewardList) do
        self:updateAwardItemStatus(self.menustatus[k], v.status, k)
    end

    table.print(self.rewardList)
    
    --更新可领取奖励按钮的状态 1 不可领取 2 可以领取 3 已经领取
    for k,v in pairs(self.rewardList) do
        if v.status == 2 then
            -- print("可领取 -================----- ", self.curRewarId)
            -- self.curRewarId = v.tid
            self.recieveMenuItem:setEnabled(true)
            break
        -- elseif v.status == 1  or v.status == 3 then
        --     self.curRewarId = v.tid
        --     self.recieveMenuItem:setEnabled(false)
        --     break
        end
    end

    --当前活跃度label数值的更新
    for m,n in pairs(self.taskList) do
        if n.current == n.target then
            local curDegreeValue = self.c_AchievementTempalte:getTaskDegreeValue(n.tid)
            self.curDegreeNum = self.curDegreeNum + curDegreeValue
        end
    end

    self.activeDegreeNum:setString(self.curDegreeNum .. " / " .. 100)
    local count = self.curDegreeNum / 20
    if count > 1 then
        for i = 2, 5 do
            if i <= count then
                self.curSprite[i]:setOpacity(255)
            else
                self.curSprite[i]:setOpacity(150)
            end
        end
    else
        for i = 2, 5 do
            -- self.curSprite[i]:setColor(ui.COLOR_DARK_GREY)
            -- self.curSprite[i]:setSpriteFrame("ui_activeDegree_jtenable.png")
            self.curSprite[i]:setOpacity(150)
        end
    end
end

function PVActiveDegree:updateCurReward(curRewarId, key)
    local rewardNum = "X" .. self.c_AchievementTempalte:getRewardData(curRewarId)               --当前奖励的数量
    local needDegree = self.c_AchievementTempalte:getNeedDegree(curRewarId)                     --当前领取奖励所需要的活跃度值
    local bigBagId = self.c_AchievementTempalte:getBigBagId(curRewarId)

    self.smallBagIds = self.dropTemp:getSmallBagIds(bigBagId)
    table.print(self.smallBagIds)

    for k,v in pairs(self.rewardList) do
        if v.tid == self.curRewarId then
            if v.status == 2 then
                self.recieveMenuItem:setEnabled(true)
            else
                self.recieveMenuItem:setEnabled(false)
            end
        end
        
        if key == k then  --
            -- self.menustatus[key][1]:setDisabledSpriteFrame(game.newSprite("#ui_activeDegree_acc.png"))
            -- self.menustatus[key][1]:getDizsabledImage():setSpriteFrame("ui_stage_silverbox_open.png")
            self.menustatus[key][1]:setScale(0.6)
            self.menustatus[key][1]:setEnabled(false)
        elseif v.status == 3 then  -- 领取完了
            -- self.menustatus[k][1]:setDisabledSpriteFrame(game.newSprite("#ui_activeDegree_acc.png"))
            -- self.menustatus[key][1]:getDisabledImage():setSpriteFrame("ui_stage_silverbox_open.png")
            self.menustatus[k][1]:setEnabled(true)
            self.menustatus[k][1]:setScale(0.5)
        else
            -- self.menustatus[k][1]:getDisabledImage():setSpriteFrame("ui_activeDegree_bxhh.png")
            -- self.menustatus[k][1]
            self.menustatus[k][1]:setEnabled(true)
            self.menustatus[k][1]:setScale(0.5)
            -- self.menustatus[k][1]:setScale(0.6)
        end
    end


end

function PVActiveDegree:initTouchListener()
    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        local isHave = self.c_activeData:getNotice()
        touchNotice(NOTICE_ACTIVE_DEGREE, isHave)
        self:onHideView()
    end

    --领取奖励
    local function receiveRewardClick()
        getAudioManager():playEffectButton2()
        cclog("---receiveRewardClick-----")
        cclog(self.curRewarId)

        self.c_activeNet:sendGetReward(self.curRewarId)
    end

    --奖励查看 (点击更新奖励列表)
    local function activeGoldEvent1()
        self.curRewarId = self.rewardList[1].tid
        self:updateOtherView()
        self:updateCurReward(self.curRewarId, 1)
        self.memberItemCount = table.getn(self.smallBagIds)
        self.memberTableView:reloadData()
    end

    local function activeGoldEvent2()
        self.curRewarId = self.rewardList[2].tid
        self:updateOtherView()
        self:updateCurReward(self.curRewarId, 2)
        self.memberItemCount = table.getn(self.smallBagIds)
        self.memberTableView:reloadData()
    end

    local function activeGoldEvent3()
        self.curRewarId = self.rewardList[3].tid
        self:updateOtherView()
        self:updateCurReward(self.curRewarId, 3)
        self.memberItemCount = table.getn(self.smallBagIds)
        self.memberTableView:reloadData()
    end

    local function activeGoldEvent4()
        self.curRewarId = self.rewardList[4].tid
        self:updateOtherView()
        self:updateCurReward(self.curRewarId, 4)
        self.memberItemCount = table.getn(self.smallBagIds)
        self.memberTableView:reloadData()
    end

    local function activeGoldEvent5()
        self.curRewarId = self.rewardList[5].tid
        self:updateOtherView()
        self:updateCurReward(self.curRewarId, 5)
        self.memberItemCount = table.getn(self.smallBagIds)
        self.memberTableView:reloadData()
    end

    self.UIActiveDegreeView["UIActiveDegreeView"] = {}
    self.UIActiveDegreeView["UIActiveDegreeView"]["onCloseClick"] = onCloseClick
    self.UIActiveDegreeView["UIActiveDegreeView"]["getJiangLiEvent"] = receiveRewardClick
    self.UIActiveDegreeView["UIActiveDegreeView"]["activeGoldEvent1"] = activeGoldEvent1
    self.UIActiveDegreeView["UIActiveDegreeView"]["activeGoldEvent2"] = activeGoldEvent2
    self.UIActiveDegreeView["UIActiveDegreeView"]["activeGoldEvent3"] = activeGoldEvent3
    self.UIActiveDegreeView["UIActiveDegreeView"]["activeGoldEvent4"] = activeGoldEvent4
    self.UIActiveDegreeView["UIActiveDegreeView"]["activeGoldEvent5"] = activeGoldEvent5
end

--奖励列表
function PVActiveDegree:createRewardsList(contenLayer)
    self.memberItemCount = table.getn(self.smallBagIds)
    -- print("0-------0---------0------------0", self.memberItemCount)
    -- table.print(self.smallBagIds)
    function tableCellTouched(table, cell)
        local smallBagId = self.smallBagIds[cell:getIdx() + 1]
        local smallItem = self.dropTemp:getSmallBagById(smallBagId)
        local itemId = smallItem.detailID

        if smallItem.type < 100 then  -- 可直接读的资源图
            if smallItem.type == 2 then
                getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 2)
            else
                getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 1)
            end
        elseif smallItem.type == 101 then -- 武将
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", itemId, 1, nil, nil)
        elseif smallItem.type == 102 then -- 装备
            local equipment = getTemplateManager():getEquipTemplate():getTemplateById(itemId)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, nil)
        elseif smallItem.type == 103 then -- 武将碎片
            local nowPatchNum = self.c_SoldierData:getPatchNumById(itemId)
            getOtherModule():showOtherView("PVCommonChipDetail", 1, itemId, nowPatchNum, 1)
        elseif smallItem.type == 104 then -- 装备碎片
            local nowPatchNum = self.c_EquipmentData:getPatchNumById(itemId)
            getOtherModule():showOtherView("PVCommonChipDetail", 2, itemId, nowPatchNum, 1)
        elseif smallItem.type == 105 then  -- 道具
            getOtherModule():showOtherView("PVCommonDetail", 1, itemId, 1)
        elseif smallItem.type == 107 then
            getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 1)
        end

    end

    function cellSizeForTable(table, idx)
        return 110, 115
    end

    function tableCellAtIndex(tabl, idx)
        local curCell = tabl:dequeueCell()

        if nil == curCell then
            curCell = cc.TableViewCell:new()

            curCell.UIActiveDegreeJLItem = {}
            curCell.UIActiveDegreeJLItem["UIActiveDegreeJLItem"] = {}

            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("activeDegree/ui_activeDegree_JLItem.ccbi", proxy, curCell.UIActiveDegreeJLItem)

            curCell.rewardIcon = curCell.UIActiveDegreeJLItem["UIActiveDegreeJLItem"]["rewardIcon"]                     --英雄头像
            curCell.activeJLItemNum = curCell.UIActiveDegreeJLItem["UIActiveDegreeJLItem"]["activeJLItemNum"]
            curCell.activeJLItemName = curCell.UIActiveDegreeJLItem["UIActiveDegreeJLItem"]["activeJLItemName"]
            curCell.activeJLItemNum:getParent():setLocalZOrder(10)
            curCell:addChild(node)

            local _rewardIcon = curCell.rewardIcon
            local _parentNode = _rewardIcon:getParent()
            local _icon = cc.Sprite:create()
            _icon:setScaleX(_rewardIcon:getScaleX())
            _icon:setScaleY(_rewardIcon:getScaleY())
            local _x, _y = _rewardIcon:getPosition()
            _icon:setPosition(cc.p(_x, _y))

            curCell.rewardIcon = _icon
            _parentNode:addChild(_icon)
            _rewardIcon:removeFromParent()

        end
        if table.getn(self.smallBagIds) > 0 then
            local smallBagId = self.smallBagIds[idx + 1]
            local smallItem = self.dropTemp:getSmallBagById(smallBagId)
            local itemType = smallItem.type                                     --物品的类型
            local itemCount = smallItem.count                                     --物品的数量

            curCell.activeJLItemNum:setString(" X " .. itemCount)
            setCommonDrop(itemType, smallItem.detailID, curCell.rewardIcon, curCell.activeJLItemName)


            -- if itemType < 100 then  -- 可直接读的资源图
            --     _temp = itemType
            --     local _icon = self.c_ResourceTemplate:getResourceById(smallItem.detailID)
            --     setItemImage3(curCell.rewardIcon,"res/icon/resource/".._icon,1)
            --     curCell.activeJLItemNum:setString(" X " .. itemCount)
            -- else
            --     if itemType == 101 then -- 武将
            --         _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(smallItem.detailID)
            --         local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(smallItem.detailID)
            --         -- changeNewIconImage(curCell.rewardIcon,_temp,quality)
            --         changeNewIconImage(curCell.rewardIcon,_temp,quality)
            --     elseif itemType == 102 then -- equpment
            --         _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(smallItem.detailID)
            --         local quality = getTemplateManager():getEquipTemplate():getQuality(smallItem.detailID)
            --         changeEquipIconImageBottom(curCell.rewardIcon, _temp, quality)
            --     elseif itemType == 103 then -- hero chips
            --         _temp = self._chipTemp:getTemplateById(smallItem.detailID).resId
            --         local _icon = self.c_ResourceTemplate:getResourceById(_temp)
            --         local _quality = self._chipTemp:getTemplateById(smallItem.detailID).quality
            --         setChipWithFrame(curCell.rewardIcon,"res/icon/hero/".._icon, _quality)
            --     elseif itemType == 104 then -- equipment chips
            --         _temp = self._chipTemp:getTemplateById(smallItem.detailID).resId
            --         local _icon = self.c_ResourceTemplate:getResourceById(_temp)
            --         local _quality = self._chipTemp:getTemplateById(smallItem.detailID).quality
            --         setChipWithFrame(curCell.rewardIcon,"res/icon/equipment/".._icon, _quality)
            --     elseif itemType == 105 then  -- item
            --         _temp = getTemplateManager():getBagTemplate():getItemResIcon(smallItem.detailID)
            --         local quality = getTemplateManager():getBagTemplate():getItemQualityById(smallItem.detailID)
            --         -- setCardWithFrame(curCell.rewardIcon,"res/icon/item/".._temp,quality)
            --         setItemImage3(curCell.rewardIcon,"res/icon/item/".._temp,quality)
            --     elseif itemType == 107 then
            --         local _icon = self.c_ResourceTemplate:getResourceById(smallItem.detailID)
            --         setItemImage3(curCell.rewardIcon,"res/icon/resource/".._icon,1)
            --         curCell.activeJLItemNum:setString(" X " .. itemCount)
            --     end
            -- end
            -- -- local resStr = self.c_ResourceTemplate:getResourceById(itemType)
            -- curCell.activeJLItemNum:setString(" X " .. itemCount)
            -- curCell.activeJLItemName:setString(" X " .. itemCount)
            -- curCell.rewardIcon:setSpriteFrame(resStr)
        end

        return curCell
    end

    function numberOfCellsInTableView(tabl)
        return self.memberItemCount
    end

    local layerSize = contenLayer:getContentSize()
    self.memberTableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    self.memberTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.memberTableView:setPosition(cc.p(0, 0))
    self.memberTableView:setDelegate()
    contenLayer:addChild(self.memberTableView)

    self.memberTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.memberTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.memberTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.memberTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    self.memberTableView:reloadData()
end

function PVActiveDegree:initTable()
    local layerSize = self.activeDegreeItemLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.activeDegreeItemLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    -- local scrBar = PVScrollBar:new()
    -- scrBar:init(self.tableView,1)
    -- scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    -- self.activeDegreeItemLayer:addChild(scrBar,2)

    self.tableView:reloadData()
    self:tableViewItemAction(self.tableView)
end

function PVActiveDegree:tableCellTouched(table, cell)
    self.clickIndex = cell:getIdx()
end

function PVActiveDegree:cellSizeForTable(table, idx)
    return 100, 545
end

function PVActiveDegree:tableCellAtIndex(tabl, idx)
    local cell = nil
    if nil == cell then
        cell = cc.TableViewCell:new()

        --前往
        local function onGotoClick()
            local index = cell:getIdx() + 1
            local curTaskId = self.taskList[index].tid
            local conditionType = self.c_AchievementTempalte:getConditionType(curTaskId)
            -- local playerLevel = getDataManager():getCommonData():getLevel()
            -- local runeSecretLevel = getTemplateManager():getBaseTemplate():getRuneLevel()
            local runeSecretStageId = getTemplateManager():getBaseTemplate():getTotemOpenStage()
            local isOpen = getDataManager():getStageData():getIsOpenByStageId(runeSecretStageId)
            if conditionType == 20 or conditionType == 21 then
                if isOpen then     -- playerLevel > runeSecretLevel
                    self:showConditionView(conditionType)
                else
                    -- 功能等级开放提示
                    -- self:removeChildByTag(1000)
                    -- self:addChild(getLevelTips(runeSecretLevel), 1000)
                    getStageTips(runeSecretStageId)

                    return
                end
            else
                self:showConditionView(conditionType)
            end
        end

        cell.UIActiveDegreeItem = {}
        cell.UIActiveDegreeItem["UIActiveDegreeItem"] = {}
        cell.UIActiveDegreeItem["UIActiveDegreeItem"]["onGoToEvent"] = onGotoClick

        local proxy = cc.CCBProxy:create()
        local activeItem = CCBReaderLoad("activeDegree/ui_activeDegree_item.ccbi", proxy, cell.UIActiveDegreeItem)

        cell.activeAccLayer = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["activeAccLayer"]           --奖励层
        cell.finishDegreeDes = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["addXinDes1"]              --完成任务说明
        cell.getDegreeNum = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["addXinNum1"]                 --获得的活跃度数值

        cell.activeNoAccLayer = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["activeNoAccLayer"]       --获取活跃度途径层
        cell.addDegreeNum = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["addXinNum"]                  --增加的活跃度数值
        cell.degreeDes = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["addXinDes"]                     --获取活跃度任务说明
        cell.goMenuItem = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["goMenuItem"]
        cell.addXinDesValue = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["addXinDesValue"]
        cell.mask = cell.UIActiveDegreeItem["UIActiveDegreeItem"]["mask"]
        cell.mask:setVisible(false)

        cell:addChild(activeItem)
    end

    if table.nums(self.taskList) > 0 then
        local taskId = self.taskList[idx + 1].tid
        -- local curNum = self:updateTaskAttacks(taskId)
        local currentValue = self.taskList[idx + 1].current
        local targetValue = self.taskList[idx + 1].target
        local statusValue = self.taskList[idx + 1].status
        local tid = self.taskList[idx + 1].tid

        local curDegreeValue = self.c_AchievementTempalte:getTaskDegreeValue(taskId)


        if currentValue >= targetValue then
            currentValue = targetValue
            cell.goMenuItem:setEnabled(false)
            cell.mask:setVisible(true)
        end

        local text = self.c_AchievementTempalte:getTaskDes(taskId)
        local textValue = currentValue .. "/" .. targetValue

        cell.addDegreeNum:setString(tostring(curDegreeValue))

        cell.degreeDes:setString(text)
        cell.addXinDesValue:setString(textValue)

        -- cell.finishDegreeDes:setString(textValue)
        -- cell.getDegreeNum:setString(curDegreeValue)
    end

    return cell
end

function PVActiveDegree:numberOfCellsInTableView(table)
    return self.itemCount
end

--前往任务显示的界面
function PVActiveDegree:showConditionView(conditionType)
    print("showConditionView ================ ", conditionType)
    if conditionType == 4 then
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", nil, 1)                --剧情关卡
    elseif conditionType == 5 then
        local _stageId = self.baseTemp:getSpecialStageOpenStage()
        local _isOpen = self.c_StageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", nil, 2)                --副本关卡
        else
            getStageTips(_stageId)
            return
        end
    elseif conditionType == 18 then
        local _stageId = self.baseTemp:getActivityStageOpenStage()
        local _isOpen = self.c_StageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters", nil, 3)                --活动关卡
        else
            getStageTips(_stageId)
            return
        end
    elseif conditionType == 13 then
        local _stageId = self.baseTemp:getArenaOpenStage()
        local _isOpen = self.c_StageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaPanel")                  --竞技场
        else
            getStageTips(_stageId)
            return
        end
    elseif conditionType == 15 then                                                     --好友赠送体力
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVFriendPanel")
    elseif conditionType == 19 then                                                     --煮酒
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActivityPage", 5)
    elseif conditionType == 20 then
        local _stageId = self.baseTemp:getWarFogOpenStage()
        local _isOpen = self.c_StageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlacePanel")             --探索秘境
        else
            getStageTips(_stageId)
            return
        end
    elseif conditionType == 21 then
        local _stageId = self.baseTemp:getWarFogOpenStage()
        local _isOpen = self.c_StageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlacePanel")              --收获符文
        else
            getStageTips(_stageId)
            return
        end
    elseif conditionType == 22 then
        local _stageId = self.baseTemp:getTravelOpenStage()
        local _isOpen = self.c_StageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPanel")
        else
            getStageTips(_stageId)
            return
        end
    elseif conditionType == 23 then
        local _stageId = self.baseTemp:getWorldBossOpenStage()
        local _isOpen = self.c_StageData:getIsOpenByStageId(_stageId)
        print("----_stageId------_isOpen----",_stageId,_isOpen)
        if _isOpen then
            getModule(MODULE_NAME_WAR):showUIView("PVArenaWarPanel")                                  --攻打世界boss
        else
            getStageTips(_stageId)
            return
        end
    end
end

function PVActiveDegree:onReloadView()
    self.taskList = self.c_activeData:getTaskList()
    self.rewardList = self.c_activeData:getRewardList()
    self:resetTabviewContentOffset(self.tableView)
    self.tableView:reloadData()
    self:tableViewItemAction(self.tableView)
    self:updateOtherView()
end

function PVActiveDegree:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_activeDegree.plist")
end

function PVActiveDegree:subChNoticeState(noticeId, state)
    if noticeId == NOTICE_ACTIVE_DEGREE then
    end
end

return PVActiveDegree
