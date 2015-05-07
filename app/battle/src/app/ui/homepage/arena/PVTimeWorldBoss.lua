
local PVTimeWorldBoss = class("PVTimeWorldBoss", BaseUIView)

function PVTimeWorldBoss:ctor(id)
    self.super.ctor(self, id)
end

function PVTimeWorldBoss:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
    self:registerDataBack()

    self.c_commonData = getDataManager():getCommonData()
    self.c_bossData = getDataManager():getBossData()
    self.c_ResourceData = getDataManager():getResourceData()

    self.c_stageTemp = getTemplateManager():getInstanceTemplate()
    self.c_baseTemplate = getTemplateManager():getBaseTemplate()
    self.c_soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_resourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()

    self.c_bossNet = getNetManager():getBossNet()

    self:initData()
    self:initView()

end

--网络返回
function PVTimeWorldBoss:registerDataBack()
    --鼓舞返回
    local  function sliverEncourage(id, data)
        if data.result then
            if self.inspireType == 1 then
                local curYear = self.c_commonData:getYear()
                local curMonth = self.c_commonData:getMonth()
                local curHour = self.c_commonData:getCurrHour()
                local curMin = self.c_commonData:getCurrMin()
                local curDay = self.c_commonData:getDay()
                local curSec = self.c_commonData:getCurSec()
                --当前时间
                local nowTime = os.time({year = curYear, month = curMonth, day = curDay, hour = curHour, min = curMin, sec = curSec})

                --银币鼓舞cd时间
                sliverEncourageEndTime = nowTime + self.sliverCD
                self.sliverCDTime = sliverEncourageEndTime - nowTime
                print("self.sliverCDTime =============== ", self.sliverCDTime)

                self.sliverCDLayer:setVisible(true)
                self.sliverCDLabel:setString(string.format("%02d:%02d",math.floor(self.sliverCDTime%3600/60),self.sliverCDTime%60))
                self.btnSilver:setEnabled(false)
                self.encourageTimes = self.encourageTimes + 1
                print("self.costSliverNum ============== ", self.costSliverNum)
                self.c_commonData:subCoin(self.costSliverNum)
                self:updateSliverEncourageCD()
                --更新银币鼓舞消耗
                local costSliverNum = self.perCost * 2 ^ (self.encourageTimes)
                self.sliverValue:setString(costSliverNum)

            elseif self.inspireType == 2 then
                self.goldEncourageTimes = self.goldEncourageTimes + 1
                self.c_commonData:subGold(self.costGoldNum)
                --更新金币鼓舞消耗
                self.goldValue:setString(self.costGoldNum)
            end

            local ratio1 = self.encourageTimes * self.sliverRadio
            local ratio2 = self.goldEncourageTimes * self.goldRadio
            -- self.shhAddLabel:setString("伤害 + " .. ratio1 * 100 .. "%")
            -- self.shhAddLabel2:setString("伤害 + " .. ratio2 * 100 .. "%")
            self.hjgwNumLabel:setString(self.encourageTimes .. "次")
            self.zgzwNumLabel:setString(self.goldEncourageTimes .. "次")
            local totalRatio = (ratio1 + ratio2) * 100
            self.labelHurt:setString(totalRatio .. " %")
        end
    end

    self:registerMsg(BOSS_INSPIRE, sliverEncourage)

    --复活协议返回
    local function reliveCallBack(id, data)
        print("复活返回 --================ ")
        table.print(data)
        if data.result then
            -- self.labelTime:setVisible(false)
            -- self.btnFight:setEnabled(true)

            -- self.reviveLayer:setVisible(false)
            -- self.btnFight:setVisible(true)
            relive = true
            --复活消耗的元宝
            self.c_commonData:subGold(self.goldReviveNum)

            self.reviveLayer:setVisible(false)
            self.btnFight:setVisible(true)
            self.btnFight:setEnabled(true)

            _stageID = self.stageId
            self:removeScheduler1()
            self:removeScheduler2()
            self:removeScheduler3()
            -- self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEmbattle", _stageID, "boss")
            _stageID = nil
        end

    end

    self:registerMsg(BOSS_RELIVE, reliveCallBack)

end

--时间初始化
function PVTimeWorldBoss:initData()
    --当前boss相关信息
    self.stageId = self.c_bossData:getCurSatgeId()                                         --当前的关卡id
    local roundId = self.c_stageTemp:getSpecialStageById(self.stageId).round1              --当前的怪物组id
    self.curMonsterId = self.c_soldierTemplate:getMonsIdFromGroup(roundId)
    print("世界boss的id =================", self.curMonsterId)
    self.c_ResourceData:loadHeroImageDataById(self.curMonsterId)
    self.curMonsterInfo = self.c_soldierTemplate:getMonsterTempLateById(self.curMonsterId)  --当前boss相关信息                                  --获取怪物相关信息

    self.curHp = self.curMonsterInfo.hp                                                     --当前boss的总血量

    self.bloodLeft = self.c_bossData:getBloodValue()                                        --当前boss的剩余血量

    self.encourageTimes = self.c_bossData:getSliverEncourageTime()                          --银币鼓舞的次数

    self.costRadio = self.c_baseTemplate:getCostRatio()                                     --银币鼓舞的消耗翻倍系数

    self.perCost = self.c_baseTemplate:getCostSliverNum()                                   --银币鼓舞每次消耗

    self.goldEncourageTimes = self.c_bossData:getGoldEncourageTimes()                       --金币鼓舞的次数

    self.costGoldNum = self.c_baseTemplate:getCostGoldNum()                                 --金币鼓舞消耗

    self.fightTimes = self.c_bossData:getFightTimes()                                       --战斗次数

    self.rankNo = self.c_bossData:getRankNo()                                               --当前排名

    self.sliverRadio = self.c_baseTemplate:getSliverEncorageRadio()                         --银两鼓舞增加攻击力比率

    self.goldRadio = self.c_baseTemplate:getGoldEncourageRadio()                            --元宝鼓舞增加攻击力比率

    self.damageHp = self.c_bossData:getDamageHp()                                           --伤害血量值

    self.debuff_skill_no = self.c_bossData:getAdventure()                                   --奇遇

    self.sliverCD = self.c_baseTemplate:getSliverEncorageCD()                               --银币鼓舞cd时间

    self.sliverEncourageMax = self.c_baseTemplate:getSliverEncorageTimes()                  --银币鼓舞最大次数

    self.goldEncourageMax = self.c_baseTemplate:getGoldEncorageTimes()                      --金币鼓舞最大次数

    print("奇遇的数值=================== ", self.debuff_skill_no)

    self.costSliverNum = self.perCost * 2 ^ (self.encourageTimes)

    --当前拥有的银币和砖石
    self.haveSliver = self.c_commonData:getCoin()
    self.haveGold = self.c_commonData:getGold()

    --战斗时间相关
    local activity_time = self.c_stageTemp:getSpecialStageById(self.stageId).timeControl
    local index = string.find(activity_time, "-")
    print("Time:",activity_time)

    local start_time = string.sub(activity_time, 1, index - 1)
    local end_time = string.sub(activity_time, index + 1, 11)
    local curYear = self.c_commonData:getYear()
    local curMonth = self.c_commonData:getMonth()
    local curHour = self.c_commonData:getCurrHour()
    local curMin = self.c_commonData:getCurrMin()
    local curDay = self.c_commonData:getDay()
    local curSec = self.c_commonData:getCurSec()
    --当前时间
    local nowTime = os.time({year = curYear, month = curMonth, day = curDay, hour = curHour, min = curMin, sec = curSec})

    --开始时间
    local startIndex = string.find(start_time, ":")
    local start_hour = string.sub(start_time, 1, startIndex - 1)
    local start_min = string.sub(start_time, startIndex + 1, 5)
    local curTime1 = {year = curYear, month = curMonth, day = curDay, hour = start_hour, min = start_min, sec = 0}
    local startTime = os.time(curTime1)

    --结束时间
    local endIndex = string.find(end_time, ":")
    local end_hour = string.sub(end_time, 1, endIndex - 1)
    local end_min = string.sub(end_time, endIndex + 1, 5)
    local curTime2 = {year = curYear, month = curMonth, day = curDay, hour = end_hour, min = end_min, sec = 0}
    local endTime = os.time(curTime2)

    --距离开始时间间隔
    self.subTime = startTime - nowTime
    --距离结束时间间隔
    self.subTime1 = endTime - nowTime
    --总的时间 
    self.sumTime = endTime - startTime

    print("self.subTime1 =================== ",self.subTime1)
    --当前时间
    local lastFightTime = self.c_bossData:getLastFightTime()
    local reliveInsistTime = self.c_baseTemplate:getReliveWaitTime()

    print("relive 是否复活 ========= ", relive)
    if relive then
        self.reliveWaitTime = -1
    else
        self.reliveWaitTime = lastFightTime + reliveInsistTime - nowTime
        print("-------reliveWaitTime---",self.reliveWaitTime)
    end

    if sliverEncourageEndTime ~= nil then
        self.sliverCDTime =  sliverEncourageEndTime - nowTime
    end

    self.inspireType = 1

end

--银币鼓舞cd
function PVTimeWorldBoss:updateSliverEncourageCD()
    -- 复活冷却时间倒计时
    local function updateTimer3(dt)
        if self.sliverCDTime ~= nil then
            self.sliverCDTime = self.sliverCDTime - 1
            if self.sliverCDTime < 0 then
                self.sliverCDLayer:setVisible(false)
                self.btnSilver:setEnabled(true)
                if self.scheduer3 ~= nil then
                    timer.unscheduleGlobal(self.scheduer3)
                    self.scheduer3 = nil
                end
            else
                self.sliverCDLabel:setString(string.format("%02d:%02d",math.floor(self.sliverCDTime%3600/60),self.sliverCDTime%60))
            end
        end
    end

    if self.sliverCDTime > 0 then
        self.sliverCDLayer:setVisible(true)
        self.btnSilver:setEnabled(false)
        self.scheduer3 = timer.scheduleGlobal(updateTimer3, 1.0)
    else
        self.sliverCDLayer:setVisible(false)
        self.btnSilver:setEnabled(true)
        if self.scheduer3 ~= nil then
            timer.unscheduleGlobal(self.scheduer3)
            self.scheduer3 = nil
        end
    end
end

--战斗倒计时
function PVTimeWorldBoss:updateData()
    --战斗倒计时
    local function updateTimer1(dt)
        self.subTime1 = self.subTime1 - 1
        if self.subTime1 <= 0 then
            if self.scheduer1 ~= nil then
                timer.unscheduleGlobal(self.scheduer1)
                self.scheduer1 = nil
            end
            getModule(MODULE_NAME_HOMEPAGE):removeLastView()
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeBossWait")
        else
            -- 倒计时 剩余时间
            self.timeLabel:setString( string.format("%02d:%02d:%02d",math.floor(self.subTime1/3600),math.floor(self.subTime1%3600/60),self.subTime1%60) )
            --进度条更新显示
            self.expPrgress:setPercentage(self.subTime1 / self.sumTime * 100)
            -- local posX, posY = self.progressPoint:getPosition()
            -- if posX > 27 then
            --     self.progressPoint:setPosition(cc.p(posX - self.moveLength, posY))
            -- else
            --     self.progressPoint:setPosition(cc.p(27, posY))
            -- end
        end
    end

    if self.subTime1 > 0 then
        --进度条相关基础设置
        -- local length = self.progressSprite:getContentSize().width
        -- self.moveLength = math.floor(length / self.subTime1)
        -- local posX, posY = self.progressPoint:getPosition()
        -- local curPosX = posX - (self.subTime1 - self.subTime) * self.moveLength
        -- self.progressPoint:setPosition(cc.p(curPosX + 26 / 2, posY))
        --活动开始启动计时器
        self.scheduer1 = timer.scheduleGlobal(updateTimer1, 1.0)
    else
        if self.scheduer1 ~= nil then
            timer.unscheduleGlobal(self.scheduer1)
            self.scheduer1 = nil
        end
    end


end

function PVTimeWorldBoss:updateReliveData()
    -- 复活冷却时间倒计时
    local function updateTimer2(dt)
        self.reliveWaitTime = self.reliveWaitTime - 1
        if self.reliveWaitTime < 0 then
            self.labelTime:setVisible(false)
            self.reviveLayer:setVisible(true)
            self.btnRevive:setEnabled(true)
            -- self.btnFight:setEnabled(true)
            self.btnFight:setVisible(false)
            if self.scheduer2 ~= nil then
                timer.unscheduleGlobal(self.scheduer2)
                self.scheduer2 = nil
            end
        else
            self.labelTime:setString(string.format("%02d:%02d",math.floor(self.reliveWaitTime%3600/60),self.reliveWaitTime%60))
        end
    end
    print("reliveWaitTime ---================ ", self.reliveWaitTime)
    if self.reliveWaitTime > 0 then
        self.labelTime:setVisible(true)
        self.reviveLayer:setVisible(true)
        self.btnRevive:setEnabled(false)
        -- self.btnFight:setEnabled(false)
        self.btnFight:setVisible(false)
        self.scheduer2 = timer.scheduleGlobal(updateTimer2, 1.0)
    else
        self.labelTime:setVisible(false)
        self.reviveLayer:setVisible(false)
        self.btnRevive:setEnabled(true)
        -- self.btnFight:setEnabled(true)
        self.btnFight:setVisible(true)
        self.btnFight:setEnabled(true)
        if self.scheduer2 ~= nil then
            timer.unscheduleGlobal(self.scheduer2)
            self.scheduer2 = nil
        end
    end
end

--boss血量更新显示
function PVTimeWorldBoss:updataBossBlood()
end

--界面其他相关及时更新
function PVTimeWorldBoss:updateOtherView()
    self.labelFightNum:setString()
end

--界面加载以及初始化
function PVTimeWorldBoss:initView()
    self.UIBossFightView = {}
    self:initTouchListener()

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGB565)
    self:loadCCBI("boss/ui_boss_view.ccbi", self.UIBossFightView)
     cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    self.timeLabel = self.UIBossFightView["UIBossFightView"]["timeLabel"]
    self.progressSprite = self.UIBossFightView["UIBossFightView"]["progress_green"]
    self.progressPoint = self.UIBossFightView["UIBossFightView"]["progress_point"]
    self.labelTime = self.UIBossFightView["UIBossFightView"]["labelTime"]
    self.bossSprite = self.UIBossFightView["UIBossFightView"]["bossSprite"]                     --boss图片资源

    self.labelFightNum = self.UIBossFightView["UIBossFightView"]["labelFightNum"]               --已经战斗的次数
    self.labelHurt = self.UIBossFightView["UIBossFightView"]["labelHurt"]                       --伤害增加
    self.labelRank = self.UIBossFightView["UIBossFightView"]["labelRank"]                       --当前排名
    self.labelHurtNum = self.UIBossFightView["UIBossFightView"]["labelHurtNum"]                 --伤害数值

    self.labelQiyu = self.UIBossFightView["UIBossFightView"]["labelQiyu"]                       --奇遇

    self.btnFight = self.UIBossFightView["UIBossFightView"]["btnFight"]                         --战斗按钮
    self.btnAutomaticFight = self.UIBossFightView["UIBossFightView"]["btnAutomaticFight"]       --自动战斗
    self.btnRevive = self.UIBossFightView["UIBossFightView"]["btnRevive"]

    --银币鼓舞
    self.btnSilver = self.UIBossFightView["UIBossFightView"]["btnSilver"]                       --银币鼓舞按钮
    self.sliverCDLayer = self.UIBossFightView["UIBossFightView"]["sliverCDLayer"]
    self.sliverCDLabel = self.UIBossFightView["UIBossFightView"]["sliverCDLabel"]
    self.sliverValue = self.UIBossFightView["UIBossFightView"]["sliverValue"]                   --银币鼓舞消耗

    self.goldValue = self.UIBossFightView["UIBossFightView"]["goldValue"]                       --金币鼓舞消耗

    self.reviveLayer = self.UIBossFightView["UIBossFightView"]["reviveLayer"]                   --复活、立即复活层
    self.goldReviveValue = self.UIBossFightView["UIBossFightView"]["goldReviveValue"]                   --复活、立即复活层

    self.shhAddLabel = self.UIBossFightView["UIBossFightView"]["shhAddLabel"]                   --银币鼓舞消耗提示
    self.shhAddLabel2 = self.UIBossFightView["UIBossFightView"]["shhAddLabel2"]                 --金币鼓舞消耗提示

    self.hjgwNumLabel = self.UIBossFightView["UIBossFightView"]["hjgwNumLabel"]                 --号角鼓舞次数
    self.zgzwNumLabel = self.UIBossFightView["UIBossFightView"]["zgzwNumLabel"]                 --战鼓助威次数


    print("self.sliverCDTime  ==== initView =========== ", self.sliverCDTime)

    if self.sliverCDTime ~= nil and self.sliverCDTime > 0 then
        self.sliverCDLabel:setString(string.format("%02d:%02d",math.floor(self.sliverCDTime%3600/60),self.sliverCDTime%60))
        self:updateSliverEncourageCD()
    end

    self.progressSprite:setVisible(false)
    self.expPrgress = cc.ProgressTimer:create(self.progressSprite)
    self.expPrgress:setAnchorPoint(cc.p(0, 0.5))
    self.expPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.expPrgress:setBarChangeRate(cc.p(1, 0))
    self.expPrgress:setMidpoint(cc.p(0, 0))
    self.expPrgress:setLocalZOrder(0)
    self.expPrgress:setScaleX(1.4);
    self.progressPoint:setLocalZOrder(2)

    self.expPrgress:setPosition(self.progressSprite:getPosition())
    self.progressSprite:getParent():addChild(self.expPrgress)

     -- 倒计时 剩余时间
    self.timeLabel:setString( string.format("%02d:%02d:%02d",math.floor(self.subTime1/3600),math.floor(self.subTime1%3600/60),self.subTime1%60) )

    self:updateData()
    --boss图片设置
    self.bossSprite:removeAllChildren()
    local bossImageNode = self.c_soldierTemplate:getWorldBossImage(self.curMonsterId)
    self.bossSprite:addChild(bossImageNode)

    --进度条更新显示(显示当前剩余的血量)
    local percentage = self.bloodLeft / self.curHp
    self.expPrgress:setPercentage(percentage * 100)
    -- self.expPrgress:setPercentage(50 / 100 * 100)

    --进度条相关基础设置
    local length = self.progressSprite:getContentSize().width
    local posY = self.progressPoint:getPositionY()
    local pointWidth = self.progressPoint:getContentSize().width
    if percentage == 1 then
        self.progressPoint:setPosition(cc.p(length * percentage + 5, posY))
    else
        self.progressPoint:setPosition(cc.p(length * percentage + pointWidth / (1.5 + percentage), posY))
    end

    self.labelFightNum:setString(self.fightTimes .. "次")                           --战斗次数
    if self.rankNo == 0 then
        self.labelRank:setString("--")
    else
        self.labelRank:setString(self.rankNo)
    end

    local ratio1 = self.encourageTimes * self.sliverRadio
    local ratio2 = self.goldEncourageTimes * self.goldRadio
    -- self.shhAddLabel:setString("伤害 + " .. ratio1 * 100 .. "%")
    -- self.shhAddLabel2:setString("伤害 + " .. ratio2 * 100 .. "%")
    self.hjgwNumLabel:setString(self.encourageTimes .. "次")
    self.zgzwNumLabel:setString(self.goldEncourageTimes .. "次")
    local totalRatio = (ratio1 + ratio2) * 100
    self.labelHurt:setString(totalRatio .. " %")

    self.labelHurtNum:setString(self.damageHp)

    self.goldReviveNum = self.c_baseTemplate:getReliveCostGold()
    self.goldReviveValue:setString(self.goldReviveNum)

    -- self.labelTime:setVisible(false)
    self.reviveLayer:setVisible(false)
    -- if self.c_commonData:getVip() > 0 then
    --     self.btnAutomaticFight:setEnabled(true)
    -- else
    --     self.btnAutomaticFight:setEnabled(false)
    -- end

    if self.fightTimes > 0 and self.bloodLeft > 0 then
        -- self.btnFight:setEnabled(false)
        self.labelTime:setString(string.format("%02d:%02d",math.floor(self.reliveWaitTime%3600/60),self.reliveWaitTime%60))
        -- self.labelTime:setVisible(true)
        self:updateReliveData()
    end

    -- self:initTable()

    local costSliverNum = self.perCost * 2 ^ (self.encourageTimes)
    self.sliverValue:setString(costSliverNum)

    self.goldValue:setString(self.costGoldNum)

     --奇遇
    local _skillData = self.c_soldierTemplate:getSkillTempLateById(self.debuff_skill_no)
    if _skillData ~= nil then
        local _describe = self.c_LanguageTemplate:getLanguageById(_skillData.describe)
        self.labelQiyu:setString(_describe)
    else
        self.labelQiyu:setString("")
    end

end

--界面监听事件
function PVTimeWorldBoss:initTouchListener()
    --返回
    local function backMenuClick()
        getAudioManager():playEffectButton2()
        cclog("backMenuClick")
        self:removeScheduler1()
        self:removeScheduler2()
        self:removeScheduler3()
        self:onHideView()
    end

    --银币鼓舞
    local function menuSilverEncourage()
        self.inspireType = 1
        local ratio = self.c_baseTemplate:getCostRatio()                        --银币鼓舞次数翻倍系数
        if self.encourageTimes < self.sliverEncourageMax then
            self.costSliverNum = self.perCost * 2 ^ (self.encourageTimes)
            print("self.costSliverNum ========= menuSilverEncourage", self.costSliverNum)
            if self.haveSliver >= self.costSliverNum then

                self.c_bossNet:sendSliverInspire(self.inspireType, self.costSliverNum)
            else
                -- getOtherModule():showToastView(Localize.query(101))
                getOtherModule():showAlertDialog(nil, Localize.query(101))
            end
        else
            -- getOtherModule():showAlertDialog(nil, Localize.query(101))
            getOtherModule():showAlertDialog(nil, Localize.query("boss.1"))
        end
    end

    --金币鼓舞
    local function menuGoldEncourage()
        self.inspireType = 2
        if self.goldEncourageTimes < self.goldEncourageMax then
            if self.haveGold >= self.costGoldNum then
                self.c_bossNet:sendSliverInspire(self.inspireType, self.costGoldNum)
            else
                -- getOtherModule():showToastView(Localize.query(102))
                getOtherModule():showAlertDialog(nil, Localize.query(102))

            end
        else
            getOtherModule():showAlertDialog(nil, Localize.query("boss.1"))
        end
    end



    --战斗
    local function menuFight()
        _stageID = self.stageId
        self:removeScheduler1()
        self:removeScheduler2()
        self:removeScheduler3()
        -- self:onHideView()
        -- getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEmbattle", _stageID, "boss")
        _stageID = nil
    end

    --免费复活
    local function menuRevive()
        relive = true
        _stageID = self.stageId
        self:removeScheduler1()
        self:removeScheduler2()
        self:removeScheduler3()
        -- self:onHideView()
        self.reviveLayer:setVisible(false)
        self.btnFight:setVisible(true)
        self.btnFight:setEnabled(true)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEmbattle", _stageID, "boss")
        _stageID = nil
    end

    --立即复活
    local function menuGoldRevive()
        if self.haveGold < self.goldReviveNum then
            -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVCommonDialog")
            local str = Localize.query("common.1")
            getOtherModule():showOtherView("PVCommonDialog", str)
        else
            self.c_bossNet:sendRelive()
        end
    end

    --自动战斗
    local function menuAutomaticFight()
    end

    self.UIBossFightView["UIBossFightView"] = {}

    self.UIBossFightView["UIBossFightView"]["backMenuClick"] = backMenuClick                        --关闭
    self.UIBossFightView["UIBossFightView"]["menuSilverEncourage"] = menuSilverEncourage            --银币鼓舞
    self.UIBossFightView["UIBossFightView"]["menuGoldEncourage"] = menuGoldEncourage                --金币鼓舞
    self.UIBossFightView["UIBossFightView"]["menuRevive"] = menuRevive                              --复活
    self.UIBossFightView["UIBossFightView"]["menuAutomaticFight"] = menuAutomaticFight              --自动战斗                          --战斗
    self.UIBossFightView["UIBossFightView"]["menuFight"] = menuFight                                --战斗
    self.UIBossFightView["UIBossFightView"]["menuGoldRevive"] = menuGoldRevive                      --立即复活
end

function PVTimeWorldBoss:initTable()
    local layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()

    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVTimeWorldBoss:tableCellTouched(table, cell)
    getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaPanel")
end

function PVTimeWorldBoss:cellSizeForTable(table, idx)
    return 170, 550
end

function PVTimeWorldBoss:tableCellAtIndex(tabl, idx)
    local cell = tabl:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()

        cell.UIArenaWarItem = {}
        cell.UIArenaWarItem["UIArenaWarItem"] = {}


        local proxy = cc.CCBProxy:create()
        local arenaWarItem = CCBReaderLoad("arena/ui_arena_war_item.ccbi", proxy, cell.UIArenaWarItem)

        cell.arenaItemSprite = cell.UIArenaWarItem["UIArenaWarItem"]["arenaItemSprite"]             --挑战按钮层
        cell.arenaItemWord = cell.UIArenaWarItem["UIArenaWarItem"]["arenaItemWord"]                                   --排行按钮层

        cell:addChild(arenaWarItem)
    end

    if table.nums(self.warList) > 0 then
        -- cell.arenaItemSprite:setSpriteFrame("")
    end

    return cell
end

function PVTimeWorldBoss:numberOfCellsInTableView(table)
    return self.itemCount
end

function PVTimeWorldBoss:removeScheduler1()
    if self.scheduer1 ~= nil then
        timer.unscheduleGlobal(self.scheduer1)
        self.scheduer1 = nil
    end
end

function PVTimeWorldBoss:removeScheduler2()
    if self.scheduer2 ~= nil then
        timer.unscheduleGlobal(self.scheduer2)
        self.scheduer2 = nil
    end
end

function PVTimeWorldBoss:removeScheduler3()
    if self.scheduer3 ~= nil then
        timer.unscheduleGlobal(self.scheduer3)
        self.scheduer3 = nil
    end
end

function PVTimeWorldBoss:clearResource()
    -- self.c_ResourceData:removeHeroImageDataById(imageName)
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
end

-- function PVTimeWorldBoss:updateBossView()
--     self:initData()
--     if self.sliverCDTime ~= nil and self.sliverCDTime > 0 then
--         self.sliverCDLabel:setString(string.format("%02d:%02d",math.floor(self.sliverCDTime%3600/60),self.sliverCDTime%60))
--         self:updateSliverEncourageCD()
--     end

--     self.progressSprite:setVisible(false)
--     self.expPrgress = cc.ProgressTimer:create(self.progressSprite)
--     self.expPrgress:setAnchorPoint(cc.p(0, 0.5))
--     self.expPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
--     self.expPrgress:setBarChangeRate(cc.p(1, 0))
--     self.expPrgress:setMidpoint(cc.p(0, 0))
--     self.expPrgress:setLocalZOrder(0)

--     self.progressPoint:setLocalZOrder(2)

--     self.expPrgress:setPosition(self.progressSprite:getPosition())
--     self.progressSprite:getParent():addChild(self.expPrgress)

--      -- 倒计时 剩余时间
--     self.timeLabel:setString( string.format("%02d:%02d:%02d",math.floor(self.subTime1/3600),math.floor(self.subTime1%3600/60),self.subTime1%60) )

--     self:updateData()
--     --boss图片设置
--     self.bossSprite:removeAllChildren()
--     local bossImageNode = self.c_soldierTemplate:getWorldBossImage(self.curMonsterId)
--     self.bossSprite:addChild(bossImageNode)

--     --进度条更新显示(显示当前剩余的血量)
--     local percentage = self.bloodLeft / self.curHp
--     self.expPrgress:setPercentage(percentage * 100)
--     -- self.expPrgress:setPercentage(50 / 100 * 100)

--     --进度条相关基础设置
--     local length = self.progressSprite:getContentSize().width
--     local posY = self.progressPoint:getPositionY()
--     local pointWidth = self.progressPoint:getContentSize().width
--     if percentage == 1 then
--         self.progressPoint:setPosition(cc.p(length * percentage + 5, posY))
--     else
--         self.progressPoint:setPosition(cc.p(length * percentage + pointWidth / (1.5 + percentage), posY))
--     end

--     self.labelFightNum:setString(self.fightTimes .. "次")                           --战斗次数
--     if self.rankNo == 0 then
--         self.labelRank:setString("--")
--     else
--         self.labelRank:setString(self.rankNo)
--     end

--     local ratio1 = self.encourageTimes * self.sliverRadio
--     local ratio2 = self.goldEncourageTimes * self.goldRadio
--     -- self.shhAddLabel:setString("伤害 + " .. ratio1 * 100 .. "%")
--     -- self.shhAddLabel2:setString("伤害 + " .. ratio2 * 100 .. "%")
--     self.hjgwNumLabel:setString(self.encourageTimes .. "次")
--     self.zgzwNumLabel:setString(self.goldEncourageTimes .. "次")
--     local totalRatio = (ratio1 + ratio2) * 100
--     self.labelHurt:setString(totalRatio .. " %")

--     self.labelHurtNum:setString(self.damageHp)

--     -- self.labelTime:setVisible(false)
--     self.reviveLayer:setVisible(false)
--     -- if self.c_commonData:getVip() > 0 then
--     --     self.btnAutomaticFight:setEnabled(true)
--     -- else
--     --     self.btnAutomaticFight:setEnabled(false)
--     -- end

--     if self.fightTimes > 0 and self.bloodLeft > 0 then
--         -- self.btnFight:setEnabled(false)
--         self.labelTime:setString(string.format("%02d:%02d",math.floor(self.reliveWaitTime%3600/60),self.reliveWaitTime%60))
--         -- self.labelTime:setVisible(true)
--         self:updateReliveData()
--     end

--     -- self:initTable()

--     local costSliverNum = self.perCost * 2 ^ (self.encourageTimes)
--     self.sliverValue:setString(costSliverNum)

--     self.goldValue:setString(self.costGoldNum)

--      --奇遇
--     local _skillData = self.c_soldierTemplate:getSkillTempLateById(self.debuff_skill_no)
--     if _skillData ~= nil then
--         local _describe = self.c_LanguageTemplate:getLanguageById(_skillData.describe)
--         self.labelQiyu:setString(_describe)
--     else
--         self.labelQiyu:setString("")
--     end
-- end

-- --界面更新
-- function PVTimeWorldBoss:updateView()
-- end

function PVTimeWorldBoss:onReloadView()
     local _data = self.funcTable[1]
    print("----onReloadView----",_data)
    if _data ~= 1 then
        print("-------11111111111-------")
        self:removeScheduler1()
        self:removeScheduler2()
        self:removeScheduler3()
        -- self:onHideView()
        g_toBoss = 1
    end

    if _data == 2 then
        self:onHideView()
    end

    -- local isDead = self.c_bossData:getBossIsDead()
    -- if not isDead then
    --     self:onHideView()
    -- end
end

return PVTimeWorldBoss
