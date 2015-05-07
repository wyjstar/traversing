--战前准备
--[[
  用法
  @ 剧情，精英，活动关卡：getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", stage_id, type)
  @ type : "normal", "elite", "activity", "travel", "mine_monster", "mine_otheruser"
  @ pvp ：getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", rank_order, "pvp")
  @ 世界boss : getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", boss_id, "boss")=
]]

local PVEmbattle = class("PVEmbattle", BaseUIView)


function PVEmbattle:ctor(id)

    PVEmbattle.super.ctor(self, id)

    self:registerNetCallback()

    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.stageData = getDataManager():getStageData()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.secretPlaceData = getDataManager():getMineData()
    self.instanceTemp = getTemplateManager():getInstanceTemplate()

    -- 多适配处理所需数据
    self.winSize = cc.Director:getInstance():getWinSize()
    self.factor = cc.Director:getInstance():getContentScaleFactor()
    self.designSize = cc.size(640,960)
    local _offsetX = math.abs(self.winSize.width - self.designSize.width)
    local _offsetY = math.abs(self.winSize.height - self.designSize.height)
    if _offsetX < _offsetY then
        self.offsetX = 0
        self.offsetY = (_offsetY * self.factor)/2
    else
        self.offsetY = 0
        self.offsetX = (_offsetX * self.factor)/2
    end

    self.wsId = 0
    self.stageData:setCurrFriend(nil)
    getDataManager():getStageData():setCurrUnpara(nil)

    getDataManager():getFightData():resetAllData()

end

function PVEmbattle:onMVCEnter()
    self:showAttributeView()

    self.UIEmbattle = {}

    self:initTouchListener()

    self:loadCCBI("instance/ui_embattle.ccbi", self.UIEmbattle)

    self:initData()
    self:initView()
    self:initLayerTouchListener()

end

function PVEmbattle:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    getDataManager():getResourceData():clearResourcePlistTexture()

end

local function getTypeId(type)
    print("_______________>", type)

    if type == "normal" then
        return 1
    elseif type == "elite" then
        return 2
    elseif type == "activity" then
        return 3
    elseif type == "travel" then
        return 4
    elseif type == "mine_monster" then
        return 8
    elseif type == "mine_otheruser" then
        return 9
    elseif type == "boss" then
        return TYPE_WORLD_BOSS
    end
end

-- 注册网络response回调
function PVEmbattle:registerNetCallback()

    local function startFightCallback(id, data)
        print("####################### PVEmbattle", id, data)
        table.print(data.res)
        print("data.res.result ====== data.res.result ===== ", data.res.result)
        -- table.print(data)
        -- print(tostring(data.res.result))
        -- print(tostring(data.res.result_no))
        -- print(tostring(data.res.message))
        if data.res.result == true then
            print("返回数据正确 =========== ")
            -- 将数据传入DataCenter
            -- local fightData = getDataManager():getFightData()
            -- fightData:setLineup(self.lineup)
            -- -- table.print(self.lineup)
            -- fightData:setData(data)

            -- fightData:setFightingStageId(self.stageId)
            -- self.wsId = data.hero_unpar

            -- enterFightScene() --开打

            print("==================================================")
            -- groupCallBack(GuideGroupKey.BTN_ENTER_FIGHT)
            -- stepCallBack(G_GUIDE_00104)
            -- stepCallBack(G_GUIDE_20046)
            -- --stepCallBack(G_GUIDE_20055)
            -- --stepCallBack(G_GUIDE_20094)
            -- stepCallBack(G_GUIDE_20112)
            -- stepCallBack(G_GUIDE_30103)                  --  30006 点击进入战斗

            -- -- 扣体力   目前剧情副本战斗失败不扣体力
            -- if self.type == "normal" then
            --     local _stageTempItem = self.stageTemp:getTemplateById(self.stageId)
            --     local _useVigor = _stageTempItem.vigor
            --     local _curVigor = getDataManager():getCommonData():getStamina()
            --     getDataManager():getCommonData():setStamina(_curVigor-_useVigor)
            -- -- elseif self.type == "mine_monster" then
            -- --     fightData:setFightType(getTypeId("mine_monster"))
            -- -- elseif self.type == "mine_otheruser" then
            -- --     fightData:setFightType(getTypeId("mine_otheruser"))
            -- end

            --世界boss战斗后增加活跃度数值
            if self.type == "boss" then
                getDataManager():getActiveData():setActiveDegreeNum(10)
            end

            self:onHideView(1) -- 开打后关闭当前界面
        end
    end
    local function getFriendList(id, data)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmploySoldier")
    end
    self:registerMsg(INST_START_FIGHT_CODE, startFightCallback)
    self:registerMsg(FRIEND_LIST_REQUEST, getFriendList)

    -- pvp
    local function getChallengeCallBack(id, data)
        print("发起pvp挑战返回 -=================-")
        table.print(data)
        print(tostring(data.res.result))

        if data.res.result == true then
            local curTimes = getDataManager():getCommonData():getPvpTimes()
            getDataManager():getCommonData():setPvpTimes(curTimes + 1)
            -- getDataProcessor():gainGameResourcesResponse(data.gain)
            -- 将数据传入DataCenter
            local fightData = getDataManager():getFightData()
            fightData:setLineup(self.lineup)

            -- table.print(self.lineup)
            fightData:setData(data)

            fightData:setRed(data.red)
            fightData:setBlue(data.blue)
            fightData:setUnparalleled(data.red_skill)
            fightData:setMonsterUnpara(data.blue_skill)

            fightData:setFightType(TYPE_PVP)

            print("----getChallengeCallBack---data.fight_result----")
            print(data.fight_result)
            
            fightData:setFightResult(data.fight_result)

            enterFightScene() --开打

            self:onHideView(1) -- 开打后关闭当前界面
        else
            print("---data.res.result_no---",tostring(data.res.result_no))
        end
    end
    self:registerMsg(ARENA_CHALLENGE, getChallengeCallBack)

    -- 世界boss
    local function getBossCallback(id, data)
        print("~~~~~~~~~~~~~~ getBossCallback ~~~~~~~~~~~~~~~")
        table.print(data)
        print(tostring(data.res.result))
        if data.res.result == true then
            -- 将数据传入DataCenter
            local fightData = getDataManager():getFightData()
            fightData:setLineup(self.lineup)

            fightData:setData(data)

            fightData:setFightType(TYPE_WORLD_BOSS)
            fightData:setFightingStageId(self.stageId)
            fightData:setFightResult(data.fight_result)
            enterFightScene() --开打

            self:onHideView(2) -- 开打后关闭当前界面
        end
    end
    self:registerMsg(BOSS_FIGHT_START, getBossCallback)

    -- 秘境战斗
    local function getMineCallback(id, data)
        print("~~~~~~~~~~~~~~ getMineCallback ~~~~~~~~~~~~~~~")
        table.print(data)
        -- print("~~~~~~~~~~~~~~ getMineCallback ~~~~~~~~22222~~~~~~~")
        -- table.print(data.res)
        print(data.res.result)

        if not self:handelCommonResResult(data.res) then
            return
        end


        -- if fightType == TYPE_MINE_MONSTER or fightType == TYPE_MINE_OTHERUSER then   -- 秘境
        --


        if data.res.result == true then
            -- 将数据传入DataCenter
            local fightData = getDataManager():getFightData()
            fightData:setLineup(self.lineup)

            fightData:setData(data)

            if self.type == "mine_monster" then
                fightData:setFightingStageId(self.stageId)
            else
                fightData:setFightResult(data.fight_result)
            end

            local _type = getTypeId(self.type)
            fightData:setFightType(_type)


            -- if _type == TYPE_MINE_MONSTER or _type == TYPE_MINE_OTHERUSER then
            --     if table.nums(data.blue)<=0 then
            --         local data = {}
            --         data.pos=getDataManager():getMineData():getMapPosition()
            --         data.result=true
            --         getNetManager():getSecretPlaceNet():sendMineSettleRequest(data)

            --         self:onHideView(1) -- 开打后关闭当前界面
            --         return
            --     end
            -- end
            -- fightData:setRed(data.red)
            -- fightData:setBlue(data.blue)
            -- fightData:setUnparalleled(data.red_skill)
            -- fightData:setMonsterUnpara(data.blue_skill)

            enterFightScene() --开打

            self:onHideView(1) -- 开打后关闭当前界面
        end
    end
    self:registerMsg(MINE_BATTLE, getMineCallback)

    local function ZhuShouCallBack()
        if self.type == FROM_TYPE_MINE  then
            self:onHideView(1)
        elseif self.type == FROM_TYPE_MINE_CHANGE_LINEUP then
            self:onHideView(10)
        end
    end

    self:registerMsg(MINE_GUARD, ZhuShouCallBack)
end

function PVEmbattle:getSeat(x, y)
    print("getSeat:x:",x,"y:",y)
    -- local posPoint = { {149,665},{270,665},{390,665},
    --                    {149,549},{270,549},{390,549}, }

    local posPoint = {{140,750},{290,750},{440,750},
                        {190,500},{340,500},{490,500}}

    for i,v in ipairs(posPoint) do
        local offsetX = math.abs(x - v[1])
        local offsetY = math.abs(y - v[2])
        if offsetX < 5 and offsetY < 5 then
            return i
        end
    end
end


-- function PVEmbattle:sendStartNetMsg()

--     print("^^^^^^^^^^^^^^^^^^^^^stageid", self.stageId)

--     local _data = {}
--     local _hasHero = false
--     self.lineup = {}  -- for fightData
--     _data.stage_id = self.stageId
--     _data.stage_type = getTypeId(self.type)
--     _data.lineup = {}
--     for k,v in pairs(self.touchTable) do
--         local infor = v.touchInfo

--         local pos_x , pos_y = v:getPosition()
--         local _seat = self:getSeat(pos_x, pos_y)

--         _data.lineup[k] = {pos = _seat, hero_id = infor.id}
--         self.lineup[k] = {pos = _seat, hero_id = infor.id, activation = infor.visible}

--         if infor.id ~= 0 then _hasHero = true end
--     end
--     if self.wsId ~= nil then
--         _data.unparalleled = self.wsId
--         print("_data.unparalleled========" .. _data.unparalleled)
--     else
--         _data.unparalleled = 0
--     end
--     _data.fid = self.stageData:getCurrFriend()

--     if _hasHero == true then
--         cclog("发送请求")
--         table.print(_data)
--         cclog("发送请求")
--         getNetManager():getInstanceNet():sendStartFight(_data)
--     end
-- end

function PVEmbattle:sendStartNetMsg()

    print("^^^^^^^^^^^^^^^^^^^^^stageid", self.stageId)

    local _data = {}
    local _hasHero = false
    self.lineup = {}  -- for fightData
    _data.stage_id = self.stageId
    _data.stage_type = getTypeId(self.type)
    _data.lineup = {}
    --_data.order = {}
    for k,v in pairs(self.touchTable) do
        local infor = v.touchInfo

        local pos_x , pos_y = v:getPosition()
        local _seat = self:getSeat(pos_x, pos_y)

        --_data.lineup[k] = {pos = _seat, hero_id = infor.id}
        self:updataOrder(_data.lineup,infor.id,_seat)
        -- self.lineup = _data.lineup
        print("pos:-----",_seat)
        self.lineup[k] = {pos = _seat, hero_id = infor.id, activation = infor.visible}

        if infor.id ~= 0 then _hasHero = true end
    end


    -- for k,v in pairs(_data.lineup) do

    -- end


    local fightData = getDataManager():getFightData()
    fightData:setLineup(self.lineup)

    fightData:setFightingStageId(self.stageId)


    if self.wsId ~= nil then
        _data.unparalleled = self.wsId
        print("_data.unparalleled========" .. _data.unparalleled)
    else
        _data.unparalleled = 0
    end
    --得到当前的无双
    --_data.unpar = self.stageData:getCurrUnpara()
    _data.fid = self.stageData:getCurrFriend()
    if _hasHero == true then
        cclog("发送请求")
        table.print(_data)
        cclog("发送请求")
        getNetManager():getInstanceNet():sendStartFight(_data)
    end

end

--更新order列表
function PVEmbattle:updataOrder(tab,id,seat)
    local function checkId(num)
        for k,v in pairs(self.lineupData) do
            if v.hero_id ~= 0 and num == v.pos then
                return false
            end
        end
        return true
    end
    if id ~= 0 then
        for k,v in pairs(self.lineupData) do
            if v.hero_id == id then
                tab[v.pos] = seat
                break
            end
        end
    else
        for i=1,6 do
            local flag = checkId(i)

            if tab[i] == nil and flag then
                cclog("主公不给力呀"..i.."seat"..seat)
                tab[i] = seat
                return
            end
        end
    end
end

function PVEmbattle:sendStartPVP()
    local _data = {}
    local _hasHero = false
    self.lineup = {}  -- for fightData
    _data.challenge_rank = self.stageId
    _data.lineup = {}
    print("PVEmbattle:sendStartPVP")
    for k,v in pairs(self.touchTable) do
        local infor = v.touchInfo

        local pos_x , pos_y = v:getPosition()
        local _seat = self:getSeat(pos_x, pos_y)

         self:updataOrder(_data.lineup,infor.id,_seat)

        -- _data.lineup[k] = {pos = _seat, hero_id = infor.id}
        self.lineup[k] = {pos = _seat, hero_id = infor.id, activation = infor.visible}

        if infor.id ~= 0 then _hasHero = true end
    end
    if self.wsId ~= nil then
        _data.skill = self.wsId
        print("_data.skill========" .. _data.skill)
    else
        _data.skill = 0
    end
    getDataManager():getLineupData():setEmbattleUnpar(_data.skill)

    if _hasHero == true then
        getNetManager():getArenaNet():sendChallenge(_data)
    end
end

function PVEmbattle:sendStartBoss()
    local _data = {}
    local _hasHero = false
    self.lineup = {}  -- for fightData
    _data.boss_id = "world_boss"
    -- _data.stage_id = self.stageId
    _data.lineup = {}
    print("PVEmbattle:sendStartBoss")
    for k,v in pairs(self.touchTable) do
        local infor = v.touchInfo

        local pos_x , pos_y = v:getPosition()
        local _seat = self:getSeat(pos_x, pos_y)

        self:updataOrder(_data.lineup,infor.id,_seat)
        -- _data.lineup[k] = {pos = _seat, hero_id = infor.id}
        self.lineup[k] = {pos = _seat, hero_id = infor.id, activation = infor.visible}

        if infor.id ~= 0 then _hasHero = true end
    end
    if self.wsId ~= nil then
        _data.unparalleled = self.wsId
        print("_data.unparalleled========" .. _data.unparalleled)
    else
        _data.unparalleled = 0
    end
    _data.fid = self.stageData:getCurrFriend()

    if _hasHero == true then
        getNetManager():getBossNet():sendFigthStart(_data)
    end
end

function PVEmbattle:sendStartMineFigth()
    local _data = {}
    local _hasHero = false
    self.lineup = {}  -- for fightData
    _data.pos = getDataManager():getMineData():getMapPosition()
    print("--_data.challenge_rank---")

    _data.lineup = {}
    for k,v in pairs(self.touchTable) do
        local infor = v.touchInfo

        local pos_x , pos_y = v:getPosition()
        local _seat = self:getSeat(pos_x, pos_y)

        self:updataOrder(_data.lineup,infor.id,_seat)
        -- _data.lineup[k] = {pos = _seat, hero_id = infor.id}
        self.lineup[k] = {pos = _seat, hero_id = infor.id, activation = infor.visible}

        if infor.id ~= 0 then _hasHero = true end
    end

    if self.wsId ~= nil then
        _data.unparalleled = self.wsId
        -- print("_data.unparalleled========" .. _data.skill)
    else
        _data.unparalleled = 0
    end
    -- _data.fid = self.stageData:getCurrFriend()


    table.print(_data)

    if _hasHero == true then
        getNetManager():getSecretPlaceNet():battleMine(_data)
    end
end

function PVEmbattle:initData()
    -- 上一个界面传入值
    assert(self.funcTable, "PVEmbattle must have stage data !")
    self.stageId = self.funcTable[1]
    print("战斗的关卡id ================ ", self.stageId)
    self.type = self.funcTable[2]

    print("self.type======")
    print(self.type)

    self.lineupData = {}
    self.embattleOrder = {}
    self.embattleOrder = getDataManager():getLineupData():getEmbattleOrder()

    -- self:updateWSListData()     --获得所属的无双列表，用来检测服务器返回来的无双是否存在

    -- local unparId = getDataManager():getLineupData():getEmbattleUnpar()

    -- if unparId == nil or not self:checkWSExist(unparId) then
    --     self.wsId = nil
    -- else
    --     self.wsId = unparId
    -- end


    local lineUpList = getDataManager():getLineupData():getSelectSoldier()

    for k,v in pairs(lineUpList) do
        self.lineupData[v.slot_no] = {pos=v.slot_no, hero_id=v.hero.hero_no, activation=v.activation, curpos=self.embattleOrder[k]}
    end

    if self.type == FROM_TYPE_MINE or self.type == FROM_TYPE_MINE_CHANGE_LINEUP then
        local _mineLineUpList = getDataManager():getMineData():getMineGuardRequestHeros()
        print("-----------_mineLineUpList-------------")
        table.print(_mineLineUpList)
        local _num = table.nums(_mineLineUpList)

        for k,v in pairs(lineUpList) do
            self.lineupData[v.slot_no].hero_id = 0

            for k1,v1 in pairs(_mineLineUpList) do
                 if v.slot_no == v1.slot_no then
                    if v1.hero_no ~= nil then
                        self.lineupData[v.slot_no].hero_id = v1.hero_no
                    end
                end
            end
        end
    end

     if ISSHOW_GUIDE and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20018 then

        for k,v in pairs(self.lineupData) do

            if k ~= v.curpos then

                local _curpos = self.lineupData[v.curpos].curpos
                local _pos = k --self.lineupData[v.curpos].pos
                local _activation = self.lineupData[v.curpos].activation
                -- local _hero_id = self.lineupData[v.curpos].hero_id

                self.lineupData[v.curpos].curpos = self.lineupData[k].curpos
                self.lineupData[v.curpos].pos = v.curpos
                self.lineupData[v.curpos].activation = self.lineupData[k].activation
                -- self.lineupData[v.curpos].hero_id = self.lineupData[k].hero_id

                 self.lineupData[k].curpos = _curpos
                 self.lineupData[k].pos = _pos
                 self.lineupData[k].activation = _activation
                 -- self.lineupData[k].hero_id = _hero_id
                 break
                
            end
        end
    end

    getDataManager():getLineupData():setEmbattleArray(self.lineupData)

    self:updateWSListData()     --获得所属的无双列表，用来检测服务器返回来的无双是否存在

    local unparId = getDataManager():getLineupData():getEmbattleUnpar()

    if unparId == nil or not self:checkWSExist(unparId) then
        self.wsId = nil
    else
        self.wsId = unparId
    end

end

--注册菜单控件事件
function PVEmbattle:initTouchListener()

    local function backMenuClick()
        -- 重置当前关卡id
        self.stageData:setCurrStageId(nil)
        if self.type == FROM_TYPE_MINE then
            local  sure = function()

                getDataManager():getMineData():clearMineGuardRequest()
                getNetManager():getSecretPlaceNet():getMineBaseInfo()

                self:onHideView(1)
            end

            local cancel = function()
            end

            getOtherModule():showConfirmDialog(sure, cancel, Localize.query("PVEmbattle.1"))
        elseif self.type == FROM_TYPE_MINE_CHANGE_LINEUP then
            getDataManager():getMineData():clearMineGuardRequest()
            -- getNetManager():getSecretPlaceNet():getMineBaseInfo()

            self:onHideView(1)
        else
            self:onHideView()
        end
    end

    --支援
    local function employMenuClick()
        cclog("employMenuClick")
        getAudioManager():playEffectButton2()

        stepCallBack(G_GUIDE_20110)

        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.friendSupporLevel = getTemplateManager():getBaseTemplate():getFriendSupportLevel()

        local _stageId = getTemplateManager():getBaseTemplate():getFriendSupportStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then   ---self.playerLevel >= self.friendSupporLevel
            getNetManager():getFriendNet():sendGetFriendListMsg()
            groupCallBack(GuideGroupKey.BTN_ZHIYUAN)
        else
            --支援
            --功能等级开放提示
            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.friendSupporLevel), 0, 1000)
            getStageTips(_stageId)
        end
    end

    local function onZhuShouClick()
        cclog("onZhuShouClick")
        getAudioManager():playEffectButton2()
        -- getNetManager():getFriendNet():sendGetFriendListMsg()

        -- getNetManager():getEquipNet():sendGetEquipMsg()
        -- getNetManager():getSoldierNet():sendGetSoldierMsg()

        local _mineGuardRequest =  self.secretPlaceData:getMineGuardRequest()
        _mineGuardRequest.pos = self.secretPlaceData:getMapPosition()

        table.print(_mineGuardRequest)

        getNetManager():getSecretPlaceNet():guardMine(_mineGuardRequest)
    end

    local function onChangeLineUp()
        cclog("onChangeLineUp")
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLineUp", 3 , 3)
    end

    local function startFightMenuClick()
        cclog("startFightMenuClick")
        getAudioManager():playEffectButton2()
        print("_______________>", self.type)

        if table.nums(self.lineupData)<=0 then
            -- self:toastShow(Localize.query("lineup.5"))
            getOtherModule():showAlertDialog(nil, Localize.query("lineup.5"))
            return
        end

        if self.type == "normal" or self.type == "travel" then  -- 剧情
            local _useVigor = self.stageTemp:getTemplateById(self.stageId).vigor
            if getDataManager():getCommonData():getStamina() >= _useVigor then
                self:sendStartNetMsg()
            else
                -- getOtherModule():showToastView( Localize.query("instance.2") )
                getOtherModule():showAlertDialog(nil, Localize.query("instance.2"))

            end
        elseif self.type == "elite" or self.type == "activity" then  -- 副本 活动
            self:sendStartNetMsg()
        elseif self.type == "pvp" then
            self:sendStartPVP()
        elseif self.type == "boss" then
            --世界boss相关
            if self.type == "boss" then
                relive = false
            end
            self:sendStartBoss()
        elseif self.type == "mine_monster" or self.type == "mine_otheruser" then
            self:sendStartMineFigth()
        end

    end

    local function changWSMenuClick()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSelectWS")
        -- stepCallBack(G_GUIDE_20042)
        groupCallBack(GuideGroupKey.BTN_CHAGE_HERO)
        cclog("返回这里")

    end

    self.UIEmbattle["UIEmbattle"] = {}
    self.UIEmbattle["UIEmbattle"]["backMenuClick"] = backMenuClick
    self.UIEmbattle["UIEmbattle"]["employMenuClick"] = employMenuClick
    self.UIEmbattle["UIEmbattle"]["startFightMenuClick"] = startFightMenuClick
    self.UIEmbattle["UIEmbattle"]["changWSMenuClick"] = changWSMenuClick
    self.UIEmbattle["UIEmbattle"]["onZhuShouClick"] = onZhuShouClick
    self.UIEmbattle["UIEmbattle"]["onChangeLiueUp"] = onChangeLineUp
end

--获取控件
function PVEmbattle:initView()

    self.animationManager = self.UIEmbattle["UIEmbattle"]["mAnimationManager"]
    self.animationManager:runAnimationsForSequenceNamed("Timeline")
    self.selectNode = self.UIEmbattle["UIEmbattle"]["selectNode"]

    self.addZhiyuanImg = self.UIEmbattle["UIEmbattle"]["addZhiyuanImg"]
    self.addWushuangImg = self.UIEmbattle["UIEmbattle"]["addWushuangImg"]
    self.wushaungWordImg = self.UIEmbattle["UIEmbattle"]["wushaungWordImg"]
    self.zhiyuanWordImg = self.UIEmbattle["UIEmbattle"]["zhiyuanWordImg"]
    self.wsDetailNode = self.UIEmbattle["UIEmbattle"]["wsDetailNode"]
    self.zhiyuanDetailNode = self.UIEmbattle["UIEmbattle"]["zhiyuanDetailNode"]

    self.wsSkillDetailLabel = self.UIEmbattle["UIEmbattle"]["wsSkillDetailLabel"]
    self.wsLevelNumLabelNode_1 = self.UIEmbattle["UIEmbattle"]["wsLevelNumLabelNode_1"]
    self.zhiyuanSkillDetailLabel = self.UIEmbattle["UIEmbattle"]["zhiyuanSkillDetailLabel"]
    self.zhiyuanSkillNameLabel = self.UIEmbattle["UIEmbattle"]["zhiyuanSkillNameLabel"]
    self.fightNum = self.UIEmbattle["UIEmbattle"]["fightNum"]
    self.soldierKindSp = self.UIEmbattle["UIEmbattle"]["soldierKindSp"]
    self.sodierName = self.UIEmbattle["UIEmbattle"]["sodierName"]
    self.zhiyuanLevelNumLabelNode_1 = self.UIEmbattle["UIEmbattle"]["zhiyuanLevelNumLabelNode_1"]


    self.listLayer = self.UIEmbattle["UIEmbattle"]["listLayer"]
    self.spriteBkA = self.UIEmbattle["UIEmbattle"]["spriteBkA"]
    self.spriteBkB = self.UIEmbattle["UIEmbattle"]["spriteBkB"]
    self.spriteBkC = self.UIEmbattle["UIEmbattle"]["spriteBkC"]
    self.spriteBkD = self.UIEmbattle["UIEmbattle"]["spriteBkD"]
    self.spriteBkE = self.UIEmbattle["UIEmbattle"]["spriteBkE"]
    self.spriteBkF = self.UIEmbattle["UIEmbattle"]["spriteBkF"]
    self.spriteBkG = self.UIEmbattle["UIEmbattle"]["spriteBkG"]

    self.spriteA = self.UIEmbattle["UIEmbattle"]["headQulityA"]  -- 放置英雄的图
    self.spriteB = self.UIEmbattle["UIEmbattle"]["headQulityB"]
    self.spriteC = self.UIEmbattle["UIEmbattle"]["headQulityC"]
    self.spriteD = self.UIEmbattle["UIEmbattle"]["headQulityD"]
    self.spriteE = self.UIEmbattle["UIEmbattle"]["headQulityE"]
    self.spriteF = self.UIEmbattle["UIEmbattle"]["headQulityF"]

    self.startFightBtn = self.UIEmbattle["UIEmbattle"]["startFightBtn"]
    self.normalMenu = self.UIEmbattle["UIEmbattle"]["normalMenu"]
    self.zhushouBtn = self.UIEmbattle["UIEmbattle"]["zhushouBtn"]
    self.runeBtn = self.UIEmbattle["UIEmbattle"]["runeBtn"]

    self.touchTable = {}
    table.insert(self.touchTable, self.spriteA)
    table.insert(self.touchTable, self.spriteB)
    table.insert(self.touchTable, self.spriteC)
    table.insert(self.touchTable, self.spriteD)
    table.insert(self.touchTable, self.spriteE)
    table.insert(self.touchTable, self.spriteF)

    self.spriteBkTable = {}
    table.insert(self.spriteBkTable, self.spriteBkA)
    table.insert(self.spriteBkTable, self.spriteBkB)
    table.insert(self.spriteBkTable, self.spriteBkC)
    table.insert(self.spriteBkTable, self.spriteBkD)
    table.insert(self.spriteBkTable, self.spriteBkE)
    table.insert(self.spriteBkTable, self.spriteBkF)

    self.friendIcon = self.UIEmbattle["UIEmbattle"]["headQulityG"]
    self.menuFriend = self.UIEmbattle["UIEmbattle"]["menu_select_friend"]

    self.wsSprite = self.UIEmbattle["UIEmbattle"]["wsSprite"]
    self.wsName = self.UIEmbattle["UIEmbattle"]["wsName"]
    -- self.wsDesc = self.UIEmbattle["UIEmbattle"]["wsDesc"]

    --self.nodeG = self.UIEmbattle["UIEmbattle"]["nodeG"]
    self.touchMoveLayer = self.UIEmbattle["UIEmbattle"]["touchMoveLayer"]
    self.animationNode = self.UIEmbattle["UIEmbattle"]["animationNode"]

    self.labelNoOpen = self.UIEmbattle["UIEmbattle"]["labelNoOpen"]

    -- 载入英雄图
    cclog("打印出lineup的列表")
    table.print(self.lineupData)
    cclog("打印出lineup的列表")
   
     for k,v in pairs(self.lineupData) do
        local hero = self.lineupData[k].hero_id
        local active = self.lineupData[k].activation
        local curpos = self.lineupData[k].curpos
        if hero ~= 0 and active == true then
            -- local icon = self.soldierTemp:getSoldierIcon(hero)
            -- changeNewIconImage(self.touchTable[curpos],icon,quality)
            --隐藏前军阵，后军阵背景图
            self.spriteBkTable[k]:setVisible(false)
            --添加武将及详细信息显示
            local heroNode = self:addBuzhenWujiangInfoUI(hero,curpos,k)

            self.touchTable[curpos]:removeAllChildren()
            self.touchTable[curpos]:addChild(heroNode)
            self.touchTable[curpos]:setLocalZOrder(self.spriteBkA:getLocalZOrder()+1)
            

        else
            -- self.touchTable[curpos]:setOpacity(0)
        end
    end

    -- 初始化赋值
    --self:updateWSData(self.stageData:getCurrUnpara())
    self:updateWSData(self.wsId)

    local mxId = self.stageData:getCurrUnpara()
    if self.type == "pvp" or self.type == "boss" or self.type == "mine_otheruser" or self.type == "mine_monster" then
        self.menuFriend:setEnabled(false)
    end

    if self.type == "mine_otheruser" or self.type == "mine_monster" then
        self.labelNoOpen:setVisible(true)
    end

    if self.type == FROM_TYPE_MINE or self.type == FROM_TYPE_MINE_CHANGE_LINEUP then
        cclog("----rune change lineup---------")
        -- self.startFightBtn:setVisible(false)
        -- self.zhushouBtn:setVisible(true)
        self.normalMenu:setVisible(false)
        self.runeBtn:setVisible(true)
        self.menuFriend:setEnabled(false)
        self.labelNoOpen:setVisible(true)
    end

    --界面特效
    self.animationNode:addChild(UI_buzhenjiemianchixutexiao())

end

--添加武将及详细信息显示
--@param heroId 武将id
--@param curpos 在阵容中的位置
--@param k 在lineupData中的索引
--@return 返回node

function PVEmbattle:addBuzhenWujiangInfoUI( heroId, curpos,k)
    -- 英雄信息ui元素
    -- self.starAndNameNode_1:setVisible(false) 
    local UIBuzhenWujiangInfo = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("instance/ui_buzhen_wujiang_info.ccbi", proxy, UIBuzhenWujiangInfo)
    local rootNode = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["UIBuzhenWujiangInfoNode"]
    local starAndNameNode_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starAndNameNode_1"]
    local starSelect6_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect6_1"]
    local levelNumLabel_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["levelNumLabel_1"]
    local levelNumLabelNode_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["levelNumLabelNode_1"]
    local starSelect1_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect1_1"]
    local starSelect2_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect2_1"]
    local starSelect3_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect3_1"]
    local starSelect4_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect4_1"]
    local starSelect5_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect5_1"]
    local starSelect6_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect6_1"]

    local starTable_1 = {}
    table.insert(starTable_1, starSelect1_1)
    table.insert(starTable_1, starSelect2_1)
    table.insert(starTable_1, starSelect3_1)
    table.insert(starTable_1, starSelect4_1)
    table.insert(starTable_1, starSelect5_1)
    table.insert(starTable_1, starSelect6_1)

    local breakLvBg_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["breakLvBg_1"]
    local heroTypeBMLabel_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["heroTypeBMLabel_1"]
    local typeSprite_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["typeSprite_1"]
    local heroNameLabel_1 = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["heroNameLabel_1"]
    local bgFrame = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["bgFrame"]
    local wujiangImg = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["wujiangImg"]
    local frameAnimateNode = UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["frameAnimateNode"]

    --设置英雄信息
    local quality = self.soldierTemp:getHeroQuality(heroId)

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgFrame,"#ui_common_g_frame.png")
        local lvtejiNode = UI_buzhenjiemiankuangLvka()
        lvtejiNode:setPosition(bgFrame:getPosition())
        frameAnimateNode:addChild(lvtejiNode)
        print("lvframe")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgFrame,"#ui_common_b_frame.png")
        local lantejiNode = UI_buzhenjiemiankuangLanka()
        lantejiNode:setPosition(bgFrame:getPosition())
        frameAnimateNode:addChild(lantejiNode)
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgFrame,"#ui_common_p_frame.png")
        local zitejiNode = UI_buzhenjiemiankuangZika()
        zitejiNode:setPosition(bgFrame:getPosition())
        frameAnimateNode:addChild(zitejiNode)
    end

    local heroNode = self.soldierTemp:getHeroBigImageById(heroId)
    local x,y = wujiangImg:getPosition()
    heroNode:setScale(0.7)
    heroNode:setPosition(x*2,y+40)
    wujiangImg:setOpacity(0)
    wujiangImg:addChild(heroNode)

    updateStarLV(starTable_1, quality) --更新星级
    local slotItem = getDataManager():getLineupData():getSlotItemBySeat(k)
    local heroPb = slotItem.hero
    print("slotItem.hero : heroPb = ")
    table.print(heroPb)
    local levelNode = getLevelNode(heroPb.level)
    levelNumLabelNode_1:removeAllChildren()
    levelNumLabelNode_1:addChild(levelNode)

    if heroPb.break_level>0 then
        breakLvBg_1:setVisible(true)
        breakLvBg_1:setSpriteFrame(self:updateBreakLv(heroPb.break_level))
    else
        breakLvBg_1:setVisible(false)
    end

    local jobId = self.soldierTemp:getHeroTypeId(heroId)
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
    typeSprite_1:setSpriteFrame(_spriteJob)

    local nameStr = self.soldierTemp:getHeroName(heroId)
    heroNameLabel_1:setString(nameStr)

    return node
end

function PVEmbattle:updateBreakLv(level)
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

--改变英雄位置监听层
function PVEmbattle:initLayerTouchListener()

    self.touchMoveLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)

    self.touchMoveLayer:setTouchEnabled(true)
    self:firstLoadInfo()

    self.__flag = false  --

    local function onTouchEvent(eventType, x, y)

        if eventType == "began" and self.__flag == false then

            self.__flag = true --

            local isCanBeMove = self:checkIsCanBeMove()
            if isCanBeMove == false then
                cclog("---------isCanBeMove--------")
                self.__flag = false --
                return false
            end
            self:reloadTouchTable()
            self.touchBeginIndex = 0
            self.touchEndIndex = -1
            self.touchBeginSprite = self:getTouchSprite(x, y)
            if self.touchBeginSprite == nil then
                self.__flag = false --
                return false
            end
            self:changeLayerZorder(self.touchBeginIndex)
            self.touchBeginPoint = cc.p(self.touchBeginSprite.touchInfo["posX"], self.touchBeginSprite.touchInfo["posY"])
            self.touchBeginSpriteSize = self.touchBeginSprite:getContentSize()
            return true

        elseif eventType == "moved" then
            -- 如果出框，则移除移动
            local _x,_y = self:offsetToRightPos(x,y)
            local posX, posY = self.touchMoveLayer:getPosition()
            local size = self.touchMoveLayer:getContentSize()
            local rectArea = cc.rect(posX, posY, size.width, size.height)
            local _isInTouchLayer = cc.rectContainsPoint(rectArea, cc.p(_x, _y))
            if _isInTouchLayer == true then
                self.touchBeginSprite:setPosition(_x,_y)
                self:checkMoveToLayer()
            end

        elseif eventType == "ended" then
            self.__flag = false  --
            self:onSpriteTouchEnded()
        end
    end

    self.touchMoveLayer:registerScriptTouchHandler(onTouchEvent)

end

-- 初次载入布阵
function PVEmbattle:firstLoadInfo()

    self.seatTable = {}
    print("=======firstLoadInfo==========")
    cclog("初次布阵")
    -- for k, v in pairs(self.touchTable) do
    --     print("===k"..k)
    --     v.touchInfo = {}
    --     v.touchInfo["id"] = self.lineupData[k].hero_id
    --     v.touchInfo["seat"] = k
    --     v.touchInfo["visible"] = self.lineupData[k].activation
    --     v.touchInfo["moving"] = false
    --     local pos_x , pos_y = v:getPosition()
    --     local _seat = self:getSeat(pos_x, pos_y)
    --     self.seatTable[#self.seatTable + 1] = _seat

    -- end
    -- getNewGManager():getCurrentGid()


    if getNewGManager():getCurrentGid() ~= GuideId.G_GUIDE_20018 then

        for k,v in pairs(self.lineupData) do
            local curpos = v.curpos
            print("=======k"..k.."-----curpos"..curpos)
            self.touchTable[curpos].touchInfo = {}
            self.touchTable[curpos].touchInfo["id"] = self.lineupData[k].hero_id
            self.touchTable[curpos].touchInfo["seat"] = curpos
            self.touchTable[curpos].touchInfo["visible"] = true       --self.lineupData[k].activation  --用来标志此为止是否开启
            self.touchTable[curpos].touchInfo["moving"] = false
            local pos_x , pos_y = self.touchTable[curpos]:getPosition()
            local _seat = self:getSeat(pos_x, pos_y)
            self.seatTable[#self.seatTable + 1] = _seat

        end
    end

    
    table.print(self.lineupData)

    print("====================")
     if ISSHOW_GUIDE and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20018 then

        -- for k,v in pairs(self.lineupData) do

        --     print(k.."====v.curpos===="..v.curpos)

        --     if k ~= v.curpos then
        --         print("--------------------")
        --         local _curpos = self.lineupData[v.curpos].curpos
        --         local _pos = k --self.lineupData[v.curpos].pos
        --         local _activation = self.lineupData[v.curpos].activation
        --         -- local _hero_id = self.lineupData[v.curpos].hero_id

        --         self.lineupData[v.curpos].curpos = self.lineupData[k].curpos
        --         self.lineupData[v.curpos].pos = v.curpos
        --         self.lineupData[v.curpos].activation = self.lineupData[k].activation
        --         -- self.lineupData[v.curpos].hero_id = self.lineupData[k].hero_id

        --          self.lineupData[k].curpos = _curpos
        --          self.lineupData[k].pos = _pos
        --          self.lineupData[k].activation = _activation
        --          -- self.lineupData[k].hero_id = _hero_id
        --          break
                
        --     end
        -- end

        table.print(self.lineupData)

        for k,v in pairs(self.lineupData) do
            local curpos = v.curpos
            print("=======k"..k.."-----curpos"..curpos)
            self.touchTable[curpos].touchInfo = {}
            self.touchTable[curpos].touchInfo["id"] = self.lineupData[k].hero_id
            self.touchTable[curpos].touchInfo["seat"] = curpos
            self.touchTable[curpos].touchInfo["visible"] = self.lineupData[k].activation       --self.lineupData[k].activation  --用来标志此为止是否开启
            self.touchTable[curpos].touchInfo["moving"] = false
            local pos_x , pos_y = self.touchTable[curpos]:getPosition()
            local _seat = self:getSeat(pos_x, pos_y)
            self.seatTable[#self.seatTable + 1] = _seat

        end
     end
     cclog("--------初始化布阵---------")
     table.print(self.seatTable)
    
    -- cclog("初始化布阵------------")
    -- for k,v in pairs(self.touchTable) do
    --     table.print(v.touchInfo)
    --     cclog("----------------------------")
    -- end
    self:reloadTouchTable()
end

-- 更新无双数据
function PVEmbattle:updateWSData(id)
    const.FIGHT_POS_UNPARA_ICON = const.POS_UNPARA_ICON_STAGE
    getDataManager():getStageData():setCurrUnpara(id)
    
    if id == nil then
        self.wsName:setString( Localize.query("instance.3") )
    elseif id ~= 0 then
        self.wsId = id
        --设置无双信息
        local wsTempItem = self.stageTemp:getWSInfoById(id)
        local _name = self.languageTemp:getLanguageById(wsTempItem.name)
        local _info = self.languageTemp:getLanguageById(wsTempItem.discription)
        local _img = self.resourceTemp:getResourceById(wsTempItem.icon)
        local _wsLevel = getDataManager():getLineupData():getWSLevel(id)
        self.wsName:setString(_name)
        self.wsSkillDetailLabel:setString(_info)
        print("--------wsTempItem----------")
        table.print(wsTempItem)
        local ws = game.newSprite("res/icon/ws/".._img)
        local size = self.wsSprite:getContentSize()
        ws:setPosition(size.width/2, size.height/2)
        ws:setTag(50)
        self.wsSprite:removeChildByTag(50)
        ws:setScale(0.75)
        self.wsSprite:addChild(ws)

        local funcName = string.gsub(_img, "warriors_", "UI_wushuang")
        funcName = string.gsub(funcName, ".png", "")
        if _G[funcName] ~= nil then
            print("load effect: ", funcName)
            self.animationNode:removeChildByTag(55)
            local node = _G[funcName]() -- 1~9
            node:setTag(55)
            self.animationNode:addChild(node)
        else
            print("没有找到这个特效：", funcName)
        end

        local levelNode = getLevelNode(_wsLevel)
        self.wsLevelNumLabelNode_1:removeAllChildren()
        self.wsLevelNumLabelNode_1:addChild(levelNode)

        -- 符文秘境过来的设置无双
        if self.type == FROM_TYPE_MINE or self.type == FROM_TYPE_MINE_CHANGE_LINEUP then
            getDataManager():getMineData():setBestSkillId(id)
        end

        self.addWushuangImg:setVisible(false)
        self.wushaungWordImg:setVisible(false)
        self.wsDetailNode:setVisible(true)
    end
end

-- 更新雇佣好友
function PVEmbattle:updateFriendIcon(friend_id)
    if friend_id == nil then return end
    local _list = getDataManager():getFriendData():getListData().friends
    print("frendsData===============")
    table.print(_list)
    local hero_no = nil
    for k,v in pairs(_list) do
        if v.id == friend_id then
            hero_no = v.buddy_head
        end
    end

    --设置支援武将信息
    local _icon = self.soldierTemp:getSoldierIcon(hero_no)
    local _quality = self.soldierTemp:getHeroQuality(hero_no)
    local _heroName = self.soldierTemp:getHeroName(hero_no)
    local _type = self.soldierTemp:getHeroTypeId(hero_no)
    self:changeWujiangIconImage(self.friendIcon, _icon, _quality)
    -- self.zhiyuanSkillDetailLabel 
    -- self.zhiyuanSkillNameLabel 
    -- self.fightNum          暂无，需修改协议
    -- self.soldierKindSp 
    -- self.sodierName 
    -- self.zhiyuanLevelNumLabelNode_1  暂无，需修改协议
    self.sodierName:setString(_heroName)
    self.sodierName:setColor(getColorByQuality(_quality))
    setNewHeroTypeName(self.soldierKindSp,_type)

    local function setSkillAttri(str)
        local _describeLanguage = str
        for findStr in string.gmatch(str, "%$%d+:%w+%$") do  -- 模式匹配“$id:字段$”
           
            local repStr = nil
            for _var in string.gmatch(findStr, "%d+:%w+") do
             
                local _pos, _end = string.find(_var, ":")
                local buffId = string.sub(_var, 1, _pos-1)
                local key = string.sub(_var, _end+1)
                print("^^^^^^^^^^^", buffId)
                local buffItem = self.soldierTemp:getSkillBuffTempLateById(tonumber(buffId))
                -- table.print(buffItem)
                local value = buffItem[key]
                repStr = value
            end
            _describeLanguage = string.gsub(_describeLanguage, "%$%d+:%w+%$", repStr, 1)
        end
        return _describeLanguage
    end

    local soliderItem = self.soldierTemp:getHeroTempLateById(hero_no)
    local rageSkill = soliderItem.rageSkill  --怒气技能
    local rageSkillItem = self.soldierTemp:getSkillTempLateById(rageSkill)
    local rageName = rageSkillItem.name
    local rageDescribe = rageSkillItem.describe
    local nameLanguage = self.languageTemp:getLanguageById(rageName)
    local describeLanguage = self.languageTemp:getLanguageById(rageDescribe)
    describeLanguage = setSkillAttri(describeLanguage)
    self.zhiyuanSkillNameLabel:setString("["..nameLanguage.."]")
    self.zhiyuanSkillDetailLabel:setString(describeLanguage)


    self.addZhiyuanImg:setVisible(false)
    self.zhiyuanWordImg:setVisible(false)
    self.zhiyuanDetailNode:setVisible(true)
end

--新版头像但是不加品质框
function PVEmbattle:changeWujiangIconImage(sprite, res, quality)
    local heroSprite = cc.Sprite:create()
    heroSprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
    heroSprite:setScale(0.9)
    sprite:removeAllChildren()
    sprite:addChild(heroSprite, 1)
    heroSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end


function PVEmbattle:changeLayerTouchState(state)
    self.touchMoveLayer:setTouchEnabled(state)
end

--返回头像的Rect
function PVEmbattle:getLayerRect(layer)

    local posX, posY = layer:getPosition()
    local size = layer:getContentSize()
    local rectArea = cc.rect(posX - size.width/2, posY - size.height/2, size.width, size.height)
    return rectArea
end

--改变头像的zorder，被点击的要在上面
function PVEmbattle:changeLayerZorder(_index)
    local unTouchLayerZorder = 0
    local touchLayerZorder = 10
    for k, v in pairs(self.touchTable) do
        if v.touchInfo["seat"] == _index then
            v:setLocalZOrder(touchLayerZorder)
        else
            v:setLocalZOrder(unTouchLayerZorder)
        end
    end
end

--当移动的时候与目标重叠时
function PVEmbattle:isInRect(target)
    local function actionCallBack()
        target.touchInfo["ended"] = true
        target.touchInfo["moving"] = false
    end

    local function actionBackCallBack()
        target.touchInfo["ended"] = false
        target.touchInfo["moving"] = false
    end

    local moveToAction = cc.MoveTo:create(0.3, self.touchBeginPoint)
    local moveToSequence = cc.Sequence:create(moveToAction, cc.CallFunc:create(actionCallBack))

    local moveBackAction = cc.MoveTo:create(0.3, cc.p(target.touchInfo["posX"], target.touchInfo["posY"]))
    local moveBackSequence = cc.Sequence:create(moveBackAction, cc.CallFunc:create(actionBackCallBack))

    if target.touchInfo["ended"] then   --说明移动过了,那么回到原地

        target:runAction(moveBackSequence)
        target.touchInfo["moveToPosX"] = target.touchInfo["posX"]
        target.touchInfo["moveToPosY"] = target.touchInfo["posY"]
    else

        target:runAction(moveToSequence)
        target.touchInfo["moveToPosX"] = self.touchBeginPoint.x
        target.touchInfo["moveToPosY"] = self.touchBeginPoint.y
    end
end

function PVEmbattle:checkMoveToLayer()

    local movingLayerRect = self:getLayerRect(self.touchBeginSprite)

    for k, v in pairs(self.touchTable) do
        if v.touchInfo["visible"] == true and v.touchInfo["touchbegin"] == false then

            if v.touchInfo["moving"] == false  then

                local posX, posY = v:getPosition()
                local size = v:getContentSize()
                local worldPoint = cc.p(posX, posY)--self:convertToWorldSpace(cc.p(posX + size.width / 2, posY + size.height / 2))
                local isInRect = cc.rectContainsPoint(movingLayerRect, worldPoint)

                if isInRect then  --重叠了，那么开始移动
                    self.touchEndIndex = v.touchInfo["seat"]
                    v.touchInfo["startMoving"] = true --区分这个是要移动的，别的要back回来
                    v.touchInfo["moving"] = true --代表这是个正在移动了的
                    self:isInRect(v)
                    self:otherLayerMoveBack()
                    return
                end
            end
        end
    end

end

function PVEmbattle:otherLayerMoveBack()
    for k, v in pairs(self.touchTable) do
        if v.touchInfo["visible"] == true  and v.touchInfo["startMoving"] == false and v.touchInfo["touchbegin"] == false then
            local moveBackAction = cc.MoveTo:create(0.3, cc.p(v.touchInfo["posX"], v.touchInfo["posY"]))

            local function actionCallBack()
                v.touchInfo["moving"] = false
                v.touchInfo["ended"] = false
            end

            local moveToSequence = cc.Sequence:create(moveBackAction, cc.CallFunc:create(actionCallBack))
            v:runAction(moveToSequence)
            v.touchInfo["moveToPosX"] = v.touchInfo["posX"]
            v.touchInfo["moveToPosY"] = v.touchInfo["posY"]
            v.touchInfo["moving"] = true
        end
    end
    for k, v in pairs(self.touchTable) do
        v.touchInfo["startMoving"] = false
    end
end

--检查是否找到了endindex，但其实没移动
function PVEmbattle:checkIsNoChange()
    --找到seat为endindex，看位置是否发生改变
     for k, v in pairs(self.touchTable) do

        local seat = v.touchInfo["seat"]
        local oldPosX = v.touchInfo["posX"]
        local oldPosY = v.touchInfo["posY"]
        if self.touchEndIndex == seat then

            local posX
            local posY
            if v.touchInfo["moving"] == true then
                posX = v.touchInfo["moveToPosX"]
                posY = v.touchInfo["moveToPosY"]
            else
                posX, posY = v:getPosition()
            end


            if posX == oldPosX and posY == oldPosY then
                return true
            else
                return false
            end
        end
    end
    return false
end

--判断放下点
function PVEmbattle:onSpriteTouchEnded()

    local isNoChange = self:checkIsNoChange()

    if self.touchEndIndex == -1 or isNoChange or self.touchEndIndex == self.touchBeginIndex then
        cclog("----------checkIsNoChange-------")
        local temp = self.touchTable[self.touchBeginIndex]

        local posX = self.touchTable[self.touchBeginIndex].touchInfo["posX"]
        local posY = self.touchTable[self.touchBeginIndex].touchInfo["posY"]
        temp:setPosition(cc.p(posX, posY))

        return
    end

    print("isGuiding ",getNewGManager():isHaveGuide())
    print("curGid ",getNewGManager():getCurrentGid())
    print("touchBeginIndex ",self.touchBeginIndex)
    print("touchEndIndex ",self.touchEndIndex)
    for k,v in pairs(self.touchTable) do
        print("-----------"..k)
        table.print(v.touchInfo)
    end

    if getNewGManager():isHaveGuide() == true and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20019 then
        if self.touchBeginIndex~=1 or self.touchEndIndex~=2 then

            print("---change----")
            local temp1 = self.touchTable[self.touchBeginIndex]
            local posX1 = self.touchTable[self.touchBeginIndex].touchInfo["posX"]
            local posY1 = self.touchTable[self.touchBeginIndex].touchInfo["posY"]
            temp1:setPosition(cc.p(posX1, posY1))

            local temp2 = self.touchTable[self.touchEndIndex]
            local posX2 = self.touchTable[self.touchEndIndex].touchInfo["posX"]
            local posY2 = self.touchTable[self.touchEndIndex].touchInfo["posY"]
            -- self:stopAction(self.camerafocusAction)
            temp2:stopAllActions()
            temp2.touchInfo["ended"] = false
            temp2.touchInfo["moving"] = false
            temp2:setPosition(cc.p(posX2,posY2))

            self.touchBeginIndex = 0
            self.touchEndIndex = -1
            return
        end
    end

    local posX = self.touchTable[self.touchEndIndex].touchInfo["posX"]
    local posY = self.touchTable[self.touchEndIndex].touchInfo["posY"]
    self.touchTable[self.touchBeginIndex]:setPosition(cc.p(posX, posY))


     for k, v in pairs(self.touchTable) do
        local posX, posY = v:getPosition()
        v.touchInfo["posX"] = posX
        v.touchInfo["posY"] = posY
    end
    cclog("-------更换位置以后--------")
    for k,v in pairs(self.touchTable) do
        print("-----------"..k)
        table.print(v.touchInfo)
    end

    self.touchBeginIndex = 0
    self.touchEndIndex = -1
    

    local delayAction = cc.DelayTime:create(0.6)
    local function callBack()
        local tempTable = {}
        for k, v in pairs(self.touchTable) do
            local pos_x , pos_y = v:getPosition()
            local _seat = self:getSeat(pos_x, pos_y)
            print("_seat---------")
            print(_seat)
            if _seat == nil then
                _seat = 0
            end
            tempTable[#tempTable + 1] = _seat
        end

        print("111111111")
        table.print(self.seatTable)
        print("111111111")
        print("22222222")
        table.print(tempTable)
        print("333333333")

        for k, v in pairs(self.seatTable) do
            print("v=======" .. v)
            print("tempTable[k]====" .. tempTable[k])
            print("k===",k)
            if self.touchTable[k].touchInfo["id"] == 0 then
                self.spriteBkTable[tempTable[k]]:setVisible(true)
            else
                self.spriteBkTable[tempTable[k]]:setVisible(false)
            end


            if v ~= tempTable[k] then
                -- stepCallBack(G_CHSNGE_SEAT)
                groupCallBack(GuideGroupKey.BTN_SLIDE_HERO)
            end
        end
    end

    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(callBack))
    self:runAction(sequenceAction)

end

function PVEmbattle:reloadTouchTable()
    for k, v in pairs(self.touchTable) do

        v.touchInfo["touchbegin"] = false
        v.touchInfo["startMoving"] = false

        v.touchInfo["ended"] = false
        local posX, posY = v:getPosition()
        v.touchInfo["posX"] = posX
        v.touchInfo["posY"] = posY
    end
    print("reloadTouchTable ==========")
    table.print(self.touchTable)
end

-- 将点击屏幕的点对准
function PVEmbattle:offsetToRightPos(x,y)
    local rightX = x - self.offsetX
    local rightY = y - self.offsetY
    return rightX, rightY
end

--检查当前layer层是否能点击
function PVEmbattle:checkIsCanBeMove()

    for k, v in pairs(self.touchTable) do

        if v.touchInfo["moving"] then
            return false
        end
    end
    return true
end

--获得点击的是哪个头像
function PVEmbattle:getTouchSprite(x, y)
    local _x,_y = self:offsetToRightPos(x,y)
    for k, v in pairs(self.touchTable) do
        if v.touchInfo["visible"] == true then
            local rectArea = self:getLayerRect(v)  --头像的RECT
            local isInRect = cc.rectContainsPoint(rectArea, cc.p(_x, _y))  --是否点中了头像
            if isInRect then
                if v.touchInfo["id"] == 0 then return nil end
                v.touchInfo["touchbegin"] = true
                self.touchBeginIndex = v.touchInfo["seat"]
                if ISSHOW_GUIDE and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20019 and self.touchBeginIndex == 2 then
                    return nil
                end
                return v
            end
        end
    end
    return nil
end


function PVEmbattle:onReloadView()
    self:updateWSData(self.stageData:getCurrUnpara())
    self:updateFriendIcon(self.stageData:getCurrFriend())

    -- print("@@@@@@@@@@@@@@@@@@@")
    -- print(self.stageData:getCurrUnpara())
    -- print(self.stageData:getCurrFriend())

end


function PVEmbattle:updateWSListData()
    local list = self.instanceTemp:getWSList()  -- 无双列表

    local function getIsActive(wsId)
        local condition = {}
        local v = self.instanceTemp:getWSInfoById(wsId)
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

    self.wsList = {}
    for k,v in pairs(list) do
        if getIsActive(v.id) then
            v.isActive = true
            table.insert(self.wsList, v)
        end
    end

    table.print(self.wsList)
end

--为了检测所加载的无双是否存在
function PVEmbattle:getSoldierIsActivity(soldierId)
    -- local selectSoldier = getDataManager():getLineupData():getSelectSoldier()

    -- for k, v in pairs(selectSoldier) do
    --     if v.hero.hero_no == soldierId then
    --         return true
    --     end
    -- end
    -- return false

    for k,v in pairs(self.lineupData) do     --现在对无双的检测是用布阵的武将，不是阵容的武将列表
        if v.hero_id == soldierId then
            return true
        end
    end
    return false
end

function PVEmbattle:checkWSExist(wsid)
    for k,v in pairs(self.wsList) do
        if  v.id == wsid then
            return true
        end
    end
    return false
end

--@return
return PVEmbattle
