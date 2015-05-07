
SECRETPLACEPANEL_NOTICE = "SECRETPLACEPANEL_NOTICE"

-- 秘境
local PVSecretPlacePanel = class("PVSecretPlacePanel", BaseUIView)

function PVSecretPlacePanel:ctor(id)
    self.super.ctor(self, id)
end

function PVSecretPlacePanel:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_secretTerritory.plist")
    self:showAttributeView()

    self.UISecretExpore = {}
    self.secretLayer = {}
    self.curIndex = -1
    self.allLefttime = {}
    --以下两个标志用来标志重置的时候检查宝箱和商人是否领取
    self.mjshopIsGot = true   
    self.bagxIsGot = true

    self:initTouchListener()

    self:loadCCBI("secretTerritory/ui_secret_notExpore.ccbi", self.UISecretExpore)

    self:initView()

    self:initRegisterNetCallBack()

    getNetManager():getSecretPlaceNet():getMineBaseInfo()            --获取秘境信息

    local data = {}
    data.position = 0
    getNetManager():getSecretPlaceNet():getDetailInfo(data)


    self.c_bossNet = getNetManager():getBossNet()


    local function update_mineNotice1()
        self:updateMineNoticeData()
    end

    self.listener3 = cc.EventListenerCustom:create(UPDATE_MINE_NOTICE, update_mineNotice1)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener3, 1)

    self.shopSwitch = true    --控制第一次有秘境商人的时候发送协议的开关

    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         if self.onExit ~= nil then
    --             self:onExit()
    --         end
    --     end
    -- end

    -- self:registerScriptHandler(onNodeEvent)
end

function PVSecretPlacePanel:onExit()
    cclog("-------onExit----1111111")
    -- self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_secretTerritory.plist")

    if __scheduerSectetPanelLeftTime ~= nil then
         timer.unscheduleGlobal(__scheduerSectetPanelLeftTime)
         __scheduerSectetPanelLeftTime = nil
    end

    self:getEventDispatcher():removeEventListener(self.listener3)

    getDataManager():getResourceData():clearResourcePlistTexture()
end


function PVSecretPlacePanel:updateMineNoticeData()
    self.notice:setVisible(false)
end

function PVSecretPlacePanel:displayAll()
    local mineData = getDataManager():getMineData()
    local num = 0
    print("------displayAll---------")
    -- table.print(mineData.mines)
    print("------displayAll---------")
    for k, mine in pairs(mineData.mines) do
        num = num +1
        if k ~= 0 then
            self:displayView(k, mine)
        end
    end
    testmine = {}
    testmine.type = 5
    testmine.nickname = "yujinling"
    testmine.status = 1
    --self:displayView(2, testmine)
    print('mines:dafdsfasdf'..table.getn(mineData.mines)..'::num'..num)
    if num >= 10 then
        --显示重置按钮和重置次数
        print('111111')
        self.tarvelBottomLabel:setVisible(false)
        self.resetMapBtn:setVisible(true)
        local str = string.format(Localize.query("PVSecretPlacePanel.1"), mineData:getLastTimes())
        self.resetLabel:setString(str)
        self.resetLabel:setVisible(true)
        --print('getDataManager():getMineData():getLastTimes()---'..getDataManager():getMineData():getLastTimes())
        if getDataManager():getMineData():getLastTimes() <= 0 then
            SpriteGrayUtil:drawSpriteTextureGray(self.resetMapBtn:getNormalImage())
            self.resetMapBtn:setEnabled(false)
        end
    else
        self.tarvelBottomLabel:setVisible(true)
        self.resetMapBtn:setVisible(false)
        self.resetLabel:setVisible(false)
    end

   

end

function PVSecretPlacePanel:showNotice()
     -- 红点
   local totalNum = 0
   if getDataManager():getMineData():getNormalNum(0) <= getDataManager():getMineData():getLimit(0) then 
        totalNum = getDataManager():getMineData():getNormalNum(0) + getDataManager():getMineData():getLuckyNum(0)
    else
        totalNum = getDataManager():getMineData():getLimit(0) + getDataManager():getMineData():getLuckyNum(0)
    end
   -- if totalNum >= getDataManager():getMineData():getLimit(0) then
   --      self.notice:setVisible(true)
   --  end
   if getDataManager():getMineData():getNormalNum(0) >= getDataManager():getMineData():getLimit(0) then
        self.notice:setVisible(true)
    end
    cclog("-------PVSecretPlacePanel:showNotice--------"..totalNum)
    self.proNumLabel:setString("(已生产:"..totalNum..")")
end

function PVSecretPlacePanel:getMineType(mine)
    --1野怪，2，其他玩家占领，3自己占领
    if mine.type == 2 then
        return 1
    else
        if mine.nickname == getDataManager():getCommonData():getUserName() then
            return 3
        else
            return 2
        end
    end
end

function PVSecretPlacePanel:displayView(pos, mine)
    local _SecretLayer = self.secretLayer[pos].subSecretLayer
    local _cloud = _SecretLayer:getChildByTag(1)
    _cloud:setVisible(false)

    local _stagelayer = _SecretLayer:getChildByTag(2)
    local typeMap = {[1]=1,[2]=1,[3]=2,[4]=3,[5]=4}
    local layer = self.secretLayer[pos].subLabelLayer[typeMap[mine.type]]
    _stagelayer:setVisible(true)
    layer:setVisible(true)
    local first = layer:getChildByTag(1)
    local second = layer:getChildByTag(2)
    print("_+_+_+_+_+_+_PVSecretPlacePanel:displayView_+_+_+_+_+_+_+"..pos)
    --table.print(mine)
    local _parent = self.secretLayer[pos].menu:getParent():getParent()      --对旗帜和红点做一下清理，防止缓存
    local _child = _parent:getChildByTag(101)  -- 红点
    if _child ~= nil then
        _child:removeFromParent()
    end

    _child = _parent:getChildByTag(100)  --旗帜
    if _child ~= nil then
        _child:removeFromParent()
    end


    if mine.type == 1 then       
        local _parent = self.secretLayer[pos].menu:getParent():getParent()
        local _child = _parent:getChildByTag(101)  -- 红点
        if _child ~= nil then
            _child:removeFromParent()
        end

        _child = _parent:getChildByTag(100)  --旗帜
        if _child ~= nil then
            _child:removeFromParent()
        end
        print("-------ui_secret_small.png-------")
        -- print(self.secretLayer[pos])
        self.secretLayer[pos].menu:getNormalImage():setSpriteFrame("ui_secret_small.png")
        if self:getMineType(mine) == 3 then
            local _sprite = cc.Sprite:createWithSpriteFrameName("ui_secret_meQi.png")
            local _posX, _posY = self.secretLayer[pos].menu:getPosition()
            _sprite:setPosition(cc.p(_posX-15, _posY))
            -- _sprite:setPosition(0, 0)

            _parent:addChild(_sprite, 0, 100)

            local _spriteType = self.secretLayer[pos].menu:getParent():getParent():getChildByTag(2)
            _spriteType:setLocalZOrder(2)
        end

        first:setString(mine.nickname)
        self.secretLayer[pos].menu:setEnabled(true)
        SpriteGrayUtil:drawSpriteTextureColor(self.secretLayer[pos].menu:getNormalImage())
        
        if mine.status == 3 then             --枯竭
            second:setString(Localize.query("PVSecretPlacePanel.2"))
            self.secretLayer[pos].menu:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[pos].menu:getNormalImage())

        elseif mine.status == 2 then       --收获状态
            second:setString(Localize.query("PVSecretPlacePanel.3"))

            if self:getMineType(mine) == 3 then
                -- 加红点
                local _sprite = cc.Sprite:createWithSpriteFrameName("ui_common_active_red.png")
                local _posX, _posY = self.secretLayer[pos].menu:getPosition()
                _sprite:setPosition(cc.p(_posX+15, _posY+15))
                
                _parent:addChild(_sprite, 0, 101)

            end

        elseif mine.status == 1 then      --生产状态
            local  _leftTime = mine.last_time - getDataManager():getCommonData():getTime()
            -- cclog("---------product time ----".._leftTime.."---pos----"..pos)
            if _leftTime > 0 then
                local _mineLefttime = {}
                _mineLefttime.time = _leftTime
                _mineLefttime.label = second

                table.insert(self.allLefttime, _mineLefttime)
            else
                second:setString(Localize.query("PVSecretPlacePanel.3"))
                if self:getMineType(mine) == 3 then
                    -- 加红点
                    local _sprite = cc.Sprite:createWithSpriteFrameName("ui_common_active_red.png")
                    local _posX, _posY = self.secretLayer[pos].menu:getPosition()
                    _sprite:setPosition(cc.p(_posX+25, _posY+25))
                    
                    _parent:addChild(_sprite, 0, 101)

                end
            end

            -- if self:getMineType(mine) == 3 then
            --     -- 加红点
            --     local _sprite = cc.Sprite:createWithSpriteFrameName("ui_common_active_red.png")
            --     local _posX, _posY = self.secretLayer[pos].menu:getPosition()
            --     _sprite:setPosition(cc.p(_posX+25, _posY+25))
                
            --     _parent:addChild(_sprite, 0, 101)

            -- end
        else
            second:setString(Localize.query("PVSecretPlacePanel.6"))
        end
        
        first:setVisible(true)
        second:setVisible(true)

    elseif mine.type == 2 then --野怪矿
        self.secretLayer[pos].menu:getNormalImage():setSpriteFrame("ui_secret_small.png")
        first:setString(Localize.query("PVSecretPlacePanel.4"))
        second:setString(Localize.query("PVSecretPlacePanel.5"))
        first:setVisible(true)
        second:setVisible(true)
        self.secretLayer[pos].menu:setEnabled(true)
        SpriteGrayUtil:drawSpriteTextureColor(self.secretLayer[pos].menu:getNormalImage())

    elseif mine.type == 3 then --神秘商人
        print("-----神秘商人--------")
        table.print(mine)
        -- local shopFlag = getDataManager():getMineData():getShopCanBuy()
        self.secretLayer[pos].menu:getNormalImage():setSpriteFrame("ui_secret_mjShop.png")
        if mine.status ~= 5 then
            first:setVisible(true)
            self.secretLayer[pos].menu:setEnabled(true)
            -- SpriteGrayUtil:drawSpriteTextureColor(self.secretLayer[pos].menu:getNormalImage())
        -- else
        --     self.secretLayer[pos].menu:setEnabled(false)
        --     SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[pos].menu:getNormalImage())
            -- if  shopFlag == nil and self.shopSwitch then
            --     getNetManager():getShopNet():sendGetShopList(7)
            --     self.shopPos = pos
            --     self.shopSwitch = false
            -- elseif shopFlag == false then
            --     print("@@神秘商人".."false")
            --     SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[pos].menu:getNormalImage())
            -- elseif shopFlag then
            --     print("@@神秘商人".."true")
            -- end
            if  self.shopSwitch then

                getNetManager():getShopNet():sendGetShopList(7)
                self.shopPos = pos
                self.shopSwitch = false
            end
        end

    elseif mine.type == 4 then --巨龙宝箱
        -- self.bagxIsGot = true
        self.secretLayer[pos].menu:getNormalImage():setSpriteFrame("ui_secret_bagX.png")
        if mine.status ~= 5 then
            first:setVisible(true)
            self.secretLayer[pos].menu:setEnabled(true)
            SpriteGrayUtil:drawSpriteTextureColor(self.secretLayer[pos].menu:getNormalImage())
            -- if self.bagxIsGot then
            --     self.bagxIsGot = false
            -- end
        else
            self.secretLayer[pos].menu:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[pos].menu:getNormalImage())
            -- if not self.bagxIsGot then
            --     self.bagxIsGot = true
            -- end
        end
    elseif mine.type == 5 then --副本
        self.secretLayer[pos].menu:getNormalImage():setSpriteFrame("ui_secret_nmrq.png")
        if mine.status ~= 6 then
            first:setVisible(true)
            self.secretLayer[pos].menu:setEnabled(true)
            SpriteGrayUtil:drawSpriteTextureColor(self.secretLayer[pos].menu:getNormalImage())
        else
            self.secretLayer[pos].menu:setEnabled(false)
            SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[pos].menu:getNormalImage())
        end
        --符文副本策划未出，暂停用，以下为停用代码
        -- self.secretLayer[pos].menu:setEnabled(false)
        -- SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[pos].menu:getNormalImage())
        -----------------------------------------------
    end

    if __scheduerSectetPanelLeftTime ~= nil then
         timer.unscheduleGlobal(__scheduerSectetPanelLeftTime)
         __scheduerSectetPanelLeftTime = nil
    end

    -- 开启生产时间倒计时
    self:startLeftTime()

end

function PVSecretPlacePanel:initView()

    local nameMap = {[1]="One",[2]="Two",[3]="Three",[4]="Four",[5]="Five", [6]="Six", [7]="Seven",[8]="Eight",[9]="Nine"}
    for i=1,9 do
        self.secretLayer[i] = {}
        local  strName = string.format("secret%dLayer", i)
        self.secretLayer[i].subSecretLayer = self.UISecretExpore["UISecretExpore"][strName]
        self.secretLayer[i].subSecretLayer:getChildByTag(1):setVisible(true)
        self.secretLayer[i].subSecretLayer:getChildByTag(2):setVisible(false)
        self.secretLayer[i].subLabelLayer = {}
        for k=1,4 do
            local labelName = string.format(strName.."type%d", k)
            self.secretLayer[i].subLabelLayer[k] = self.UISecretExpore["UISecretExpore"][labelName]
            self.secretLayer[i].subLabelLayer[k]:setVisible(false)
        end
        local menuName = string.format("secret"..nameMap[i].."YesMenuItem")
        self.secretLayer[i].menu = self.UISecretExpore["UISecretExpore"][menuName]

        local menuName2 = string.format("secret"..nameMap[i].."NOMenuItem")
        self.secretLayer[i].menu2 = self.UISecretExpore["UISecretExpore"][menuName2]

        local WenHaoName = string.format("secret"..nameMap[i].."Yun")

        self.secretLayer[i].cloud = self.UISecretExpore["UISecretExpore"][WenHaoName]

    end


    self.myMine = self.UISecretExpore["UISecretExpore"]["myMine"]
    self.myMine:getNormalImage():setSpriteFrame("ui_secret_bag.png")

    self.myNameLabel = self.UISecretExpore["UISecretExpore"]["myNameLabel"]
    self.myNameLabel:setString(getDataManager():getCommonData():getUserName())
    self.proNumLabel = self.UISecretExpore["UISecretExpore"]["proNumLabel"]


    self.tarvelBottomLabel = self.UISecretExpore["UISecretExpore"]["tarvelBottomLabel"]

    self.resetMapBtn = self.UISecretExpore["UISecretExpore"]["resetMapBtn"]

    self.resetLabel = self.UISecretExpore["UISecretExpore"]["LabelLastTimes"]

    self.notice = self.UISecretExpore["UISecretExpore"]["notice"]
    self.notice:setVisible(false)
    -- self:displayAll()

end

function PVSecretPlacePanel:startLeftTime()

    local function updateTimer(dt)

        if self.allLefttime == nil then
            if __scheduerSectetPanelLeftTime ~= nil then
                 timer.unscheduleGlobal(__scheduerSectetPanelLeftTime)
                 __scheduerSectetPanelLeftTime = nil
            end
            return
        end

        for k,v in pairs(self.allLefttime) do
            v.time = v.time - dt
            local _leftTime = v.time
            if _leftTime <=0 then 
                v.time = 0
                v.label:setString(Localize.query("PVSecretPlacePanel.3"))
            else
                
                v.label:setString(string.format("%02d:%02d:%02d",math.floor(_leftTime/3600), math.floor(_leftTime%3600/60), _leftTime%60))
            end
            
             
        end

    end

    __scheduerSectetPanelLeftTime = timer.scheduleGlobal(updateTimer, 1.0)
end

-- 初始化矿点信息
function PVSecretPlacePanel:initData()

end


function PVSecretPlacePanel:updateUIData()

    -- local fadeTo = cc.FadeTo:create(0.3, 0)
    
    -- local _menuSprite = self.secretLayer[self.curIndex].menu2:getNormalImage()
    -- _menuSprite:runAction(fadeTo)

    -- local fadeTo2 = cc.FadeTo:create(0.3, 0)

    -- local function callBack()
        self:displayAll()
    -- end 

    -- local sequenceAction = cc.Sequence:create(fadeTo2, cc.CallFunc:create(callBack))

    -- self.secretLayer[self.curIndex].cloud:runAction(sequenceAction)

end

function PVSecretPlacePanel:initRegisterNetCallBack()

     function onReciveMsgCallBack(_id)
         if  _id == MINE_BASE_INFO then -- 探索
            cclog("---------_id == MINE_BASE_INFO-----------")
             self:updateUIData()
        elseif _id == MINE_SEARCH then
            cclog("---------_id == MINE_SEARCH-----------")
            self:cloudRunAction()
         end
     end

    function onDetailCallBack()
        cclog("----------onDetailCallBack----------")
        if self.curIndex == -1 then 
            self:showNotice()
            return
        end

        if self.curIndex == 0 then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlaceMyMineInfo")
            self:showNotice()        --后加之
        else
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlaceSeizeMineInfo", self.curIndex)
        end
    end

    function onResetMapCallback()

        for i=1,9 do
            self.secretLayer[i].subSecretLayer:getChildByTag(1):setVisible(true)
            self.secretLayer[i].menu2:getNormalImage():setOpacity(255)
            self.secretLayer[i].cloud:setOpacity(255)
            self.secretLayer[i].subSecretLayer:getChildByTag(2):setVisible(false)
            for k=1,4 do
                self.secretLayer[i].subLabelLayer[k]:setVisible(false)
            end
        end
        self.tarvelBottomLabel:setVisible(true)
        self.resetMapBtn:setVisible(false)
        self.resetLabel:setVisible(false)
        self.shopSwitch = true
        self.mjshopIsGot = true
        self.bagxIsGot = true
        -- getDataManager():getMineData():setShopCanBuy(true)
        self:displayAll()
    end


    function onRewardCallback(data)
        print('box----'..data)
        SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[self.curIndex].menu:getNormalImage())
        self.secretLayer[self.curIndex].menu:setEnabled(false)

        local _BoxReward = getDataManager():getMineData():getBoxReward()
        local runt = _BoxReward.data.gain.runt
        local runtNum = table.getn(runt)
        cclog("------------巨龙宝箱获得－－－－－－－－－－")
        table.print(_BoxReward.data)
        print("----------------------------"..runtNum)

        if  runtNum ~= 0 then 
            cclog("符文石－－－－－")
            -- getOtherModule():showOtherView("PVCongratulationsGainDialog", 1, runt)
            getModule(MODULE_NAME_SHOP):showUITopShowLastView("PVShopEquBuySuccess", runt,1)
        else
            cclog("银两－－－－－")
            local _drops = getDataProcessor():getGameResourcesResponse(_BoxReward.data.gain)
            getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops[1])
        end
    end

    function onRandBossCallBack(id, data)
        if not self:handelCommonResResult(data) then
            return
        end
    end

    function onRandBossPushCallBack(id, data)
        -- 接受数据成功，发送1701协议进入世界boss
        cclog("---onRandBossPushCallBack------")
        if not self:handelCommonResResult(data.res) then
            return
        end

        local data = { boss_id = data.boss_id }
        self.c_bossNet:sendGetBossInfo(data)
    end

    function onRandBossInfoCallBack(id, data)
        print("-----onRandBossInfoCallBack--------")
        -- self:onHideView()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeWorldBoss")
    end

    function onGetShopListCallBack(id, data)
        print("get secretshop list ...刷刷刷刷刷刷刷刷刷")
        if not self:handelCommonResResult(data.res) then
            return
        else
            --if self.shopSwitch then
                print("----------------initRegisterNetCallBack----------")
                table.print(data)
                if table.nums(data.id) == 0 then
                    SpriteGrayUtil:drawSpriteTextureGray(self.secretLayer[self.shopPos].menu:getNormalImage())
                    self.mjshopIsGot = true
                else
                    SpriteGrayUtil:drawSpriteTextureColor(self.secretLayer[self.shopPos].menu:getNormalImage())
                    self.mjshopIsGot = false
                end
            --end
        end
    end

	self:registerMsg(MINE_RAND_BOSS_PUSH, onRandBossPushCallBack)
    self:registerMsg(RAND_BOSS_INFO, onRandBossInfoCallBack)
    -- self:registerMsg(MINE_RAND_BOSS, onRandBossCallBack)
    self:registerMsg(MINE_BASE_INFO, onReciveMsgCallBack)
    self:registerMsg(MINE_SEARCH, onReciveMsgCallBack)
    self:registerMsg(MINE_RESET, onResetMapCallback)
    self:registerMsg(MINE_DETAIL_INFO, onDetailCallBack)
    self:registerMsg(MINE_BOX, onRewardCallback)
    self:registerMsg(SHOP_GET_ITEM_CODE, onGetShopListCallBack)

    local function ZhuShouCallBack()

        getNetManager():getSecretPlaceNet():getMineBaseInfo()
    end 

    self:registerMsg(MINE_GUARD, ZhuShouCallBack)

end

-- 探索区域 -- 发送请求
function PVSecretPlacePanel:openCloud(index)
   local _SecretLayer = self.secretLayer[index].subSecretLayer
   local _cloud = _SecretLayer:getChildByTag(1)
   _cloud:setVisible(false)

   local _stagelayer = _SecretLayer:getChildByTag(2)
   _stagelayer:setVisible(true)

   self.curIndex = index

end

-- 更新探索的区域  -- 显示矿点
function PVSecretPlacePanel:update_mine(index)

end

-- 打开占领的矿点信息
function PVSecretPlacePanel:openSeizeMineInfo(index)

getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlaceSeizeMineInfo")
end

function PVSecretPlacePanel:netCloudRequest(position)
    self.curIndex = position

    data = {}
    data.position = position
    cclog("-------发送搜索矿点请求－－－－－－－－－")
    table.print(data)
    cclog("-------发送搜索矿点请求－－－－－－－－－")
    getNetManager():getSecretPlaceNet():searchMine(data)
end

-- 打开云
function PVSecretPlacePanel:cloudRunAction()
    local fadeTo = cc.FadeTo:create(0.5, 0)
    
    local _menuSprite = self.secretLayer[self.curIndex].menu2:getNormalImage()
    _menuSprite:runAction(fadeTo)

    local fadeTo2 = cc.FadeTo:create(0.5, 0)

    local function callBack()
        self:displayAll()
    end 

    local sequenceAction = cc.Sequence:create(fadeTo2, cc.CallFunc:create(callBack))

    self.secretLayer[self.curIndex].cloud:runAction(sequenceAction)

end

function PVSecretPlacePanel:netNoCloudRequest(position)
    print("----------netNoCloudRequest---------")
    getDataManager():getMineData():setOtherPlayersCanGet(false)

    self.curIndex = position
    getDataManager():getMineData():setCurrentMap(position)
    local mineData = getDataManager():getMineData()
    local mine = mineData.mines[position]
    table.print(mine)

    --1玩家占领的野怪矿，2野外矿，3神秘商人，4巨龙宝箱，5副本
    if mine.type == 1 then      
        -- getDataManager():getMineData():setOtherPlayersCanGet(false)
        if mine.nickname ~= getDataManager():getCommonData():getUserName() then --and mine.status == 1 then
            --如果是其他玩家的矿，这里应该保存一下玩家占领的野怪矿是否可收获
            local  _leftTime = mine.last_time - getDataManager():getCommonData():getTime()
            if _leftTime <= 0 then
                cclog("--------other player can get----------")
                getDataManager():getMineData():setOtherPlayersCanGet(true)
            end
        end
        local data = {}
        data.position = position
        getNetManager():getSecretPlaceNet():getDetailInfo(data)

    elseif mine.type == 2 then
       local data = {}
        data.position = position
        getNetManager():getSecretPlaceNet():getDetailInfo(data)

    elseif mine.type == 3 then
        -- data = {}
        -- data.position = position
        -- getNetManager():getSecretPlaceNet():queryShop(data)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVSecretPlaceShop")
    elseif mine.type == 4 then
       local data = {}
        data.position = position
        getNetManager():getSecretPlaceNet():getReward(data)
    elseif mine.type == 5 then
        --跳转到世界boss
        local data = { boss_id = "mine_boss" }
        self.c_bossNet:sendGetBossInfo(data)
    end
end

function PVSecretPlacePanel:callResetMap()
    data = {}
    local mineData = getDataManager():getMineData()
    today = mineData.resetToday
    free = mineData.resetFree
    count = mineData.resetCount
    if today >= count then
        return
    elseif today >= free then
        data.free = 2
    else
        data.free = 1
    end
    data.free = 1      --现在没有收费之说
    getNetManager():getSecretPlaceNet():resetMap(data)
end

function PVSecretPlacePanel:initTouchListener()
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        groupCallBack(GuideGroupKey.BTN_CLOSE_IN_MIJING)
        print("----onCloseClick----")
        self:onHideView()
    end

    local function secretOneNOOnClick()
        cclog("secretOneNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(1)
        self:netCloudRequest(1)
        -- self:cloudRunAction(1)
    end

    local function secretOneOnClick()
        cclog("secretOneOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(1)
        self:netNoCloudRequest(1)
    end

    local function secretTwoNOOnClick()
        cclog("secretTwoNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(2)
        self:netCloudRequest(2)
        -- self:cloudRunAction(2)
    end

    local function secretTwoOnClick()
        cclog("secretTwoOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(2)
        self:netNoCloudRequest(2)
        groupCallBack(GuideGroupKey.BTN_CLICK_CLOUD_AREA)
    end

    local function secretThreeNOOnClick()
        cclog("secretThreeNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(3)
        self:netCloudRequest(3)
        -- self:cloudRunAction(3)
    end

    local function secretThreeOnClick()
        cclog("secretThreeOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(3)
        self:netNoCloudRequest(3)
    end

    local function secretFourNOOnClick()
        cclog("secretFourNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(4)
        self:netCloudRequest(4)
        -- self:cloudRunAction(4)
    end

    local function secretFourOnClick()
        cclog("secretFourOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(4)
        self:netNoCloudRequest(4)
    end

    local function secretFiveNOOnClick()
        cclog("secretFiveNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(5)
        self:netCloudRequest(5)
        -- self:cloudRunAction(5)
    end

    local function secretFiveOnClick()
        cclog("secretFiveOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(5)
        self:netNoCloudRequest(5)
    end

    local function secretSixNOOnClick()
        cclog("secretSixNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(6)
        self:netCloudRequest(6)
        -- self:cloudRunAction(6)
    end

    local function secretSixOnClick()
        cclog("secretSixOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(6)
        self:netNoCloudRequest(6)
    end
    local function secretSevenNOOnClick()
        cclog("secretSevenNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(7)
        self:netCloudRequest(7)
    end
    local function secretSevenOnClick()
        cclog("secretSevenOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(7)
        self:netNoCloudRequest(7)
        -- self:cloudRunAction(7)
    end
    local function secretEightNOOnClick()
        cclog("secretEightNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(8)
        self:netCloudRequest(8)
        -- self:cloudRunAction(8)
    end
    local function secretEightOnClick()
        cclog("secretEightOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(8)
        self:netNoCloudRequest(8)

    end
    local function secretNineNOOnClick()
        cclog("secretNineNOOnClick")
        getAudioManager():playEffectButton2()
        --self:openCloud(9)
        self:netCloudRequest(9)
        -- self:cloudRunAction(9)

    end
    local function secretNineOnClick()
        cclog("secretNineOnClick")
        getAudioManager():playEffectButton2()
        --self:openSeizeMineInfo(9)
        self:netNoCloudRequest(9)
    end
    
    -- 查看自己资源矿产出信息
    local function myMineOnClick()
        cclog("myMineOnClick")
        getAudioManager():playEffectButton2()
        self.curIndex = 0
        data = {}
        data.position = 0
        getNetManager():getSecretPlaceNet():getDetailInfo(data)
        groupCallBack(GuideGroupKey.BTN_CHUSHIKUANG)
        -- stepCallBack(G_GUIDE_50123)    -- 50040 点击初始矿

        -- stepCallBack(G_GUIDE_50124)    -- 50042 点击关闭
        -- stepCallBack(G_GUIDE_50125)    -- 50043 点击云层区域
    end

    local function onSacrificeClick()
       
    end

    local  function onAddAllClick()
        cclog("onAddAllClick")
        getAudioManager():playEffectButton2()
  
    end

    local  function onResetMapClick()
        cclog("onResetMapClick")
        getAudioManager():playEffectButton2()
        local mineData = getDataManager():getMineData()
        self.bagxIsGot = true
        for k, mine in pairs(mineData.mines) do
            if mine.type == 4 and mine.status ~= 5 then
                -- getOtherModule():showConfirmDialog(sure, cancel, Localize.query("确定放弃攻占么?"))
                self.bagxIsGot = false
                break
            end
        end
        local  sure = function()
            self:callResetMap()
        end

        local cancel = function()
        end
        -- if not self.bagxIsGot then
        --     getOtherModule():showConfirmDialog(sure, cancel, Localize.query("还有未领取的巨龙宝箱，确认重置吗?"))
        -- elseif not self.mjshopIsGot then
        --     getOtherModule():showConfirmDialog(sure, cancel, Localize.query("还有未购买的超值道具，确定重置吗?"))
        -- else
        if self.bagxIsGot == false and self.mjshopIsGot == false then
            getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVSecretPlacePanel.7"))
        elseif self.bagxIsGot == false and self.mjshopIsGot == true then
            getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVSecretPlacePanel.8"))
        elseif self.bagxIsGot == true and self.mjshopIsGot == false then
            getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVSecretPlacePanel.9"))
        else
            self:callResetMap()
        end
        
    end

    self.UISecretExpore["UISecretExpore"] = {}

    self.UISecretExpore["UISecretExpore"]["onCloseClick"] = onCloseClick
    self.UISecretExpore["UISecretExpore"]["secretOneNOOnClick"] = secretOneNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretOneOnClick"] = secretOneOnClick
    self.UISecretExpore["UISecretExpore"]["secretTwoNOOnClick"] = secretTwoNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretTwoOnClick"] = secretTwoOnClick
    self.UISecretExpore["UISecretExpore"]["secretThreeNOOnClick"] = secretThreeNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretThreeOnClick"] = secretThreeOnClick
    self.UISecretExpore["UISecretExpore"]["secretFourNOOnClick"] = secretFourNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretFourOnClick"] = secretFourOnClick
    self.UISecretExpore["UISecretExpore"]["secretFiveNOOnClick"] = secretFiveNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretFiveOnClick"] = secretFiveOnClick
    self.UISecretExpore["UISecretExpore"]["secretSixNOOnClick"] = secretSixNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretSixOnClick"] = secretSixOnClick
    self.UISecretExpore["UISecretExpore"]["secretSevenNOOnClick"] = secretSevenNOOnClick

    self.UISecretExpore["UISecretExpore"]["secretSevenOnClick"] = secretSevenOnClick
    self.UISecretExpore["UISecretExpore"]["secretEightNOOnClick"] = secretEightNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretEightOnClick"] = secretEightOnClick
    self.UISecretExpore["UISecretExpore"]["secretNineNOOnClick"] = secretNineNOOnClick
    self.UISecretExpore["UISecretExpore"]["secretNineOnClick"] = secretNineOnClick

    self.UISecretExpore["UISecretExpore"]["myMineOnClick"] = myMineOnClick

    self.UISecretExpore["UISecretExpore"]["onResetMapClick"] = onResetMapClick
    
end


function PVSecretPlacePanel:onReloadView()
   cclog("--PVSecretPlacePanel:onReloadView--")
   -- 红点准备的
   -- getNetManager():getSecretPlaceNet():getMineBaseInfo()            --获取秘境信息

    -- local data = {}
    -- data.position = 0
    -- getNetManager():getSecretPlaceNet():getDetailInfo(data)P
    self.curIndex = -1

    if MY_MINE_BACK then
        cclog("------from my mine back ----------")
        self:showNotice()
        MY_MINE_BACK = false
    end
    -- 有秘境商人的时候，购买完商品以后，退出购买窗口的时候刷新地图界面，使秘境商人显示灰色
    --标志此执行是从秘境商人商店返回的
    if SECRET_SHOP_BACK then
        print("----------SECRET_SHOP_BACK=====") 
        SECRET_SHOP_BACK = false
        self.shopSwitch = true
        self:displayAll()                    
    end
end

function PVSecretPlacePanel:clearResource()
    cclog("--PVSecretPlacePanel:clearResource--")

end

function PVSecretPlacePanel:onShowSacrificeView()

end

return PVSecretPlacePanel
