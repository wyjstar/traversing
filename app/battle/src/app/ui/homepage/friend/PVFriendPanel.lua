local PVFriendApply = import("..friend.PVFriendApply")

local PVFriendPanel = class("PVFriendPanel", BaseUIView)

function PVFriendPanel:ctor(id)
    PVFriendPanel.super.ctor(self, id)
end

function PVFriendPanel:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_friend.plist")
    -- game.addSpriteFramesWithFile("res/ccb/resource/ui_common1.plist")
    self:showAttributeView()
    self.UIFriendView   = {}
    self.UIFriendRule   = {}
    self.UIFriendPop    = {}
    self.friendListData = {}
    self.CommonResponseData = {}
    self.commonData = getDataManager():getCommonData()
    self.GameLoginResponse = self.commonData:getData()
    self.languageTemplate = getTemplateManager():getLanguageTemplate()

    self.openReceive = 1   -- 开启活力赠送
    self.generalItems1 = {}-- 好友列表
    self.generalItems2 = {}-- 坏蛋列表
    self.generalItems3 = {}-- 申请列表
    self.generalItems4 = {}-- 删除好友列表
    self.generalItems5 = {}-- 删除坏蛋列表
    self.generalItems6 = {}-- 推送好友列表
    self.generalItems7 = {}-- 查找好友列表
    self.totalSelect = {}

    self.UISecondMenuView = {}
    self.editBoxSearch = nil
    self:initTouchListener()

    self:initTestData()

    -- self:loadCCBI("friend/ui_friend_panel.ccbi", self.UIFriendView)
    -- self:loadCCBI("friend/ui_friend_rule.ccbi", self.UIFriendRule)
    -- self:loadCCBI("friend/ui_friend_pop.ccbi", self.UIFriendPop)

    self.friendActivityValue = getTemplateManager():getBaseTemplate():getFriendActivityValue()--好友活跃度上限
    self.friendCountMax = getTemplateManager():getBaseTemplate():getFriendMax()--好友数量上限
    self.badCountMax = getTemplateManager():getBaseTemplate():getBadMax()--坏蛋数量上限
    self.activityGiftNum = nil --活跃度奖励
    local activityTable = getTemplateManager():getBaseTemplate():getFriendActivityyReward()
    for k,v in pairs(activityTable) do
        if k == "106" then
            print("_LZD:v[3] = " .. v[3])
            local smallTable = getTemplateManager():getDropTemplate():getBigBagById(v[3])
            local smallItem = smallTable.smallPacketId
            self.activityGiftNum = smallItem
        end
    end


    local proxy = cc.CCBProxy:create()
    self.friendView = CCBReaderLoad("friend/ui_friend_panel.ccbi", proxy, self.UIFriendView)
    self.friendRuleView = CCBReaderLoad("friend/ui_friend_rule.ccbi", proxy, self.UIFriendRule)
    self.friendPopView = CCBReaderLoad("friend/ui_friend_pop.ccbi", proxy, self.UIFriendPop)
    self.shieldlayer = game.createShieldLayer()
    self.shieldlayer:setTouchEnabled(false)

    self:addToUIChild(self.friendView)
    self:addToUIChild(self.shieldlayer)
    self:addToUIChild(self.friendRuleView)
    self:addToUIChild(self.friendPopView)

    --表单类型(1 -- 好友列表; 2 -- 坏蛋列表; 3 -- 申请列表; 4 -- 删除好友列表; 5 -- 删除坏蛋列表; 6 -- 推荐好友列表, 7 -- 查找好友列表)
    self.curIndex = 1       --当前表单类型
    self.itemCount = 0
    self.curCellIdx = 0
    self:initView()
    self:initTableView()

    self:initData()
    self:initRegisterNetCallBack()

    self.friendNet = getNetManager():getFriendNet()
    self.friendNet:sendGetFriendListMsg()

    local node = UI_shejiao()
    self:addChild(node)

end

function PVFriendPanel:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    getDataManager():getResourceData():clearResourcePlistTexture()
end

-- 二级菜单关闭之后更新本界面
function PVFriendPanel:onReloadView()

end

-- 设置测试数据
function PVFriendPanel:initTestData()

    -- 排序：按好友战力和等级
    local function sortByPower(x, y)
        -- return x.data.power > y.data.power
        if x.data.power == y.data.power then
            return x.data.level > y.data.level --!!level未在协议中定义
        else
            return x.data.power > y.data.power
        end
    end
    -- 排序: 按照好友了离线时间,由短至长
    local function sortByLeaveTimeUp(x, y)
        return x.data.last_time > y.data.last_time
    end
    -- 排序: 按照好友了离线时间,由长至短
    local function sortByLeaveTimeDown(x, y)
        return x.data.last_time < y.data.last_time
    end
    -- 排序: 按照擂台排名
    local function sortByBattleRank(x, y)
        return x.data.b_rank < y.data.b_rank --!!b_rank未在协议中定义
    end

    --给好友添加测试数据
    self.generalItems1 = {}
    for k = 1, 10, 1 do
        local thisData = {
            id          = 90000 + k,
            nickname    = "Test_" .. k,
            hero_no     = 10040 + k,
            gift        = k,
            power       = 3000 + k,
            hp          = 100 + k,
            atk         = 200 + k,
            physical_def=300 + k,
            magic_def   = 400 + k,
            last_time   = 1429671600 + 60*60*24*k,
            level       = 30 + k,
            b_rank      = 100 - k,
            activity     = 120 - 20*k   --  -1为已领取; 其他数据为当前活跃度
        }

        self.generalItems1[k] = {}
        self.generalItems1[k].data = thisData
        self.generalItems1[k].isSelect = false
        self.generalItems1[k].id = k
    end
    table.sort(self.generalItems1, sortByPower)

    self.generalItems4 = {}
    self.generalItems4 = clone(self.generalItems1)
    -- self:loadData()
    table.sort(self.generalItems4, sortByLeaveTimeDown)

    --给坏蛋添加测试数据
    self.generalItems2 = {}
    for k = 1, 10, 1 do
        local thisData = {
            id          = 80000 + k,
            nickname    = "Test_Bad_" .. k,
            hero_no     = 10040 + k,
            gift        = k,
            power       = 3000 + k,
            hp          = 100 + k,
            atk         = 200 + k,
            physical_def=300 + k,
            magic_def   = 400 + k,
            last_time   = 1429671600 + 60*60*24*k,
            level       = 30 + k,
            b_rank      = 100 - k,
            activity     = 90 + k
        }
        self.generalItems2[k] = {}
        self.generalItems2[k].data = thisData
        self.generalItems2[k].isSelect = false
        self.generalItems2[k].id = k
    end
    table.sort(self.generalItems2, sortByBattleRank)
    self.generalItems5 = {}
    self.generalItems5 = clone(self.generalItems2)

    --给申请添加测试数据
    self.generalItems3 = {}
    for k = 1, 10, 1 do
        local thisData = {
            id          = 70000 + k,
            nickname    = "Test_Apply_" .. k,
            hero_no     = 10040 + k,
            gift        = k,
            power       = 3000 + k,
            hp          = 100 + k,
            atk         = 200 + k,
            physical_def=300 + k,
            magic_def   = 400 + k,
            last_time   = 1429671600 + 60*60*24*k,
            level       = 30 + k,
            b_rank      = 100 - k,
            activity     = 90 + k
        }
        self.generalItems3[k] = {}
        self.generalItems3[k].data = thisData
        self.generalItems3[k].isSelect = false
        self.generalItems3[k].id = k
    end
    table.sort(self.generalItems3, sortByLeaveTimeUp)

    --推送好友数据
    self.generalItems6 = {}
    for k = 1, 10, 1 do
        local thisData = {
            id          = 70000 + k,
            nickname    = "Test_Push_" .. k,
            hero_no     = 10040 + k,
            gift        = k,
            power       = 3000 + k,
            hp          = 100 + k,
            atk         = 200 + k,
            physical_def=300 + k,
            magic_def   = 400 + k,
            last_time   = 1429671600 + 60*60*24*k,
            level       = 30 + k,
            b_rank      = 100 - k,
            activity     = 90 + k
        }
        self.generalItems6[k] = {}
        self.generalItems6[k].data = thisData
        self.generalItems6[k].isSelect = false
        self.generalItems6[k].id = k
    end
end

-- 注册网络回调
function PVFriendPanel:initRegisterNetCallBack()

    function onReciveMsgCallBack(_id)
        print('LZD:--onReciveMsgCallBack--'.._id)
        if _id == FRIEND_LIST_REQUEST then  -- 列表
            self:onUpdateUIList()
        elseif _id == FRIEND_APPLY_REQUEST then --好友申请
            self:onUpdateAddFriendUI()
            getOtherModule():showAlertDialog(nil, Localize.query("friend.7"))
        elseif _id == FRIEND_ACCEPT_APPLY_REQUEST  or _id == FRIEND_REFUSE_APPLY_REQUEST then -- 接受或者拒绝好友申请
            self:onUpdateAcceptFriendApplyList(_id)
        elseif _id == FRIEND_FIND_REQUEST then -- 查询好友列表
            self:onUpdateSearchList()
        elseif _id ==  FRIEND_DELETE_REQUEST then -- 确定删除好友
            self:onUpdateDeleteFriendUIList()
        -- 领取活跃度奖励
        -- 赠予体力
        -- 反击
        -- 删除坏蛋        
        end
        print("_LZD:网络回调完成")
        self:setButtonsState()
    end

    -- 回调函数：查看好友信息
    local function getCheckBack()
        local teamName = self.name
        local c_arenaData = getDataManager():getArenaData()
        self.selectSoldierData = c_arenaData:getArenaRankCheck()
        if self.selectSoldierData ~= nil then
            -- self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaCheckInfo", teamName)
        end
    end

    self:registerMsg(CHECK_INFO, getCheckBack)
    self:registerMsg(FRIEND_FIND_REQUEST, onReciveMsgCallBack)
    self:registerMsg(FRIEND_ACCEPT_APPLY_REQUEST, onReciveMsgCallBack)
    self:registerMsg(FRIEND_REFUSE_APPLY_REQUEST, onReciveMsgCallBack)
    self:registerMsg(FRIEND_APPLY_REQUEST, onReciveMsgCallBack)
    self:registerMsg(FRIEND_LIST_REQUEST, onReciveMsgCallBack)

end

-- 更新删除好友列表
function PVFriendPanel:onUpdateDeleteFriendUIList()
    for k, v in pairs(self.totalSelect) do
            self:removeTableData(v)
        end
        self:loadData()
        self.totalSelect = {}
        self.itemCount = table.nums(self.generalItems4)
        self.tableView:reloadData()
end

function PVFriendPanel:filterFriend()
    local v = self.FindFriendResponseData

    if v.id == 0 or v.id == self.GameLoginResponse.id then
        -- table.remove(self.FindFriendResponseData, k)
        self.FindFriendResponseData = {}
    end

    -- for k,v in pairs(self.FindFriendResponseData) do
    --     if v.id == 0 or v.id == self.GameLoginResponse.id then
    --         table.remove(self.FindFriendResponseData, k)
    --     end
    -- end
end

-- 更新添加好友中 搜索好友列表
function PVFriendPanel:onUpdateSearchList()
    self.FindFriendResponseData = getDataManager():getFriendData():getFindFriendResponseData()

    -- table.print(self.FindFriendResponseData)

    self:filterFriend()

    if table.nums(self.FindFriendResponseData) <=0 then
        -- getOtherModule():showToastView(Localize.query("friend.5"))
        getOtherModule():showAlertDialog(nil, Localize.query("friend.5"))
        return
    end

    self.generalItems7 = {}
    self.generalItems7[1] = {}
    self.generalItems7[1] = self.FindFriendResponseData
    self.generalItems7[1].isSelect = false
    -- self.generalItems7[1].id = 1

    -- for k, v in pairs(self.FindFriendResponseData) do
    --     print('---k-'..k)
    --     self.generalItems7[index] = {}
    --     self.generalItems7[index] = v;
    --     self.generalItems7[index].isSelect = false
    --     self.generalItems7[index].id = k
    --     index = index + 1
    -- end
    self.curIndex = 7
    self.itemCount = table.nums(self.generalItems7)
    self.tableView:reloadData()
end

function PVFriendPanel:removeGeneralItems1ById()

end

function PVFriendPanel:onUpdateAcceptFriendApplyList(id)
    self.CommonResponseData = getDataManager():getFriendData():getCommonResponseData()
    -- table.print(self.CommonResponseData)
    -- self.generalItems3 = {}
    -- self:removeGeneralItems1ById(self.generalItems3[]hero_no)
    table.remove(self.generalItems3, self.curCellIdx+1)
    self.itemCount = table.nums(self.generalItems3)
    self.tableView:reloadData()

    if table.nums(self.generalItems3) > 0 then
        -- self.applyLayer:setVisible(true)
        local num = string.format("%d", table.nums(self.generalItems3))
        -- self.applyNum:setString(num)
    else
        -- self.applyLayer:setVisible(false)
    end

    -- if self.CommonResponseData.result then
        self.friendNet:sendGetFriendListMsg()
    -- end

    -- 更新homepage红点
    local event = cc.EventCustom:new(UPDATE_FRIEND_NOTICE)
    self:getEventDispatcher():dispatchEvent(event)

    --弹出更新提示
    -- if id == FRIEND_ACCEPT_APPLY_REQUEST then --同意添加
    --     self.UItjcgSpt:setVisible(true)
    -- elseif id == FRIEND_REFUSE_APPLY_REQUEST then --拒绝添加
    --     self.UIyjjSpt:setVisible(true)
    -- end

    -- local function popAdmin()

    -- end

    -- --播放动画

    -- self.UIPopRoot:setVisible(true)
    -- self.UIPopRoot:setPosition(0, 0)
    -- self.UIPopRoot:setOpacity(255)

    -- local move = cc.MoveBy:create(0.5, cc.p(0, 150))
    -- local fade = cc.FadeOut:create(0.5)
    -- local spawnAction = cc.Spawn:create(move, fade)
    -- local sequenceAction = cc.Sequence:create(cc.DelayTime:create(1.0), spawnAction)
    -- self.UIPopRoot:runAction(sequenceAction)
    print("_LZD:弹出更新提示")
    getOtherModule():showOtherView("PVFriendPop", id)

end

function PVFriendPanel:onUpdateAddFriendUI()
    table.remove(self.generalItems7, self.curCellIdx+1)
    self.itemCount = table.nums(self.generalItems7)
    self.tableView:reloadData()

    -- 更新homepage红点
    local event = cc.EventCustom:new(UPDATE_FRIEND_NOTICE)
    self:getEventDispatcher():dispatchEvent(event)
end

-- 更新好友，黑名单，好友申请列表
function PVFriendPanel:onUpdateUIList()

    -- 排序：按好友战力和等级
    local function sortByPower(x, y)
        -- return x.data.power > y.data.power
        if x.data.power == y.data.power then
            return x.data.level > y.data.level --!!level未在协议中定义
        else
            return x.data.power > y.data.power
        end
    end
    -- 排序: 按照好友了离线时间,由短至长
    local function sortByLeaveTimeUp(x, y)
        return x.data.last_time > y.data.last_time
    end
    -- 排序: 按照好友了离线时间,由长至短
    local function sortByLeaveTimeDown(x, y)
        return x.data.last_time < y.data.last_time
    end
    -- 排序: 按照擂台排名
    local function sortByBattleRank(x, y)
        return x.data.b_rank < y.data.b_rank --!!b_rank未在协议中定义
    end


    self.friendListData = getDataManager():getFriendData():getListData()
    self.openReceive = self.friendListData.open_receive
    -- self.generalItems1 = {}--好友列表
    -- for k, v in pairs(self.friendListData.friends) do
    --     self.generalItems1[k] = {}
    --     self.generalItems1[k].data = v;
    --     self.generalItems1[k].isSelect = false
    --     self.generalItems1[k].id = k
    -- end
    table.sort(self.generalItems1, sortByPower)

    self.generalItems4 = {}
    self.generalItems4 = clone(self.generalItems1)
    table.sort(self.generalItems4, sortByLeaveTimeDown)

    -- self.generalItems2 = {}--坏蛋列表
    -- for k, v in pairs(self.friendListData.blacklist) do
    --     self.generalItems2[k] = {}
    --     self.generalItems2[k].data = v;
    --     self.generalItems2[k].isSelect = false
    --     self.generalItems2[k].id = k
    -- end

    table.sort(self.generalItems2, sortByBattleRank)
    self.generalItems5 = {}
    self.generalItems5 = clone(self.generalItems2)

    -- self.generalItems3 = {}--申请列表
    -- for k, v in pairs(self.friendListData.applicant_list) do
    --     self.generalItems3[k] = {}
    --     self.generalItems3[k].data = v
    --     self.generalItems3[k].isSelect = false
    --     self.generalItems3[k].id = k
    -- end
    table.sort(self.generalItems3, sortByLeaveTimeUp)


    -- self.generalItems6 = {}--推送好友列表
    -- for k, v in pairs(self.friendListData.PushList) do
    --     self.generalItems6[k] = {}
    --     self.generalItems6[k].data = v
    --     self.generalItems6[k].isSelect = false
    --     self.generalItems6[k].id = k
    -- end

    if self.curIndex == 1 then
        self.itemCount = table.nums(self.generalItems1)
    elseif self.curIndex == 2 then
        self.itemCount = table.nums(self.generalItems2)
    elseif self.curIndex == 3 then
        self.itemCount = table.nums(self.generalItems3)
    elseif self.curIndex == 4 then
        self.itemCount = table.nums(self.generalItems4)
    elseif self.curIndex == 5 then
        self.itemCount = table.nums(self.generalItems5)
    elseif self.curIndex == 6 then
        self.itemCount = table.nums(self.generalItems6)
    elseif self.curIndex == 7 then
        self.itemCount = table.nums(self.generalItems7)
    end

    self.tableView:reloadData()

    -- 更新homepage红点
    local event = cc.EventCustom:new(UPDATE_FRIEND_NOTICE)
    self:getEventDispatcher():dispatchEvent(event)


    -- 根据好友活跃度数据,设置好友红点状态
    local isRed = false
    for k,v in pairs(self.generalItems1) do
        if v.data.activity >= self.friendActivityValue then
            v.data.activity = self.friendActivityValue
            isRed = true
            break
        end
    end
    self.pointNewFriend:setVisible(isRed)


    -- 根据服务器返回申请好友的状态,设置申请红点状态
    if table.nums(self.generalItems3) > 1 then
        self.pointNewApply:setVisible(true)
    else
        self.pointNewApply:setVisible(false)
    end

    --设置好友数量
    self.friendCount:setString(string.format("(%d/%d)", table.nums(self.generalItems1), self.friendCountMax))
    --设置坏蛋数量
    self.badCount:setString(string.format("(%d/%d)", table.nums(self.generalItems2), self.badCountMax))
end

function PVFriendPanel:initView()

    self.imgSelect = {1,2,3}
    self.imgNormal = {1,2,3}
    self.menuTable = {}
    --好友
    self.imgSelect[1] = self.UIFriendView["UIFriendView"]["myFriendSelect"]
    self.imgNormal[1] = self.UIFriendView["UIFriendView"]["myFriendNor"]
    --坏蛋
    self.imgSelect[2] = self.UIFriendView["UIFriendView"]["badSelect"]
    self.imgNormal[2] = self.UIFriendView["UIFriendView"]["badNor"]
    --申请
    self.imgSelect[3] = self.UIFriendView["UIFriendView"]["applySelect"]
    self.imgNormal[3] = self.UIFriendView["UIFriendView"]["applyNor"]


    self.myFriendMenuItem = self.UIFriendView["UIFriendView"]["myFriendMenuItem"]
    self.badMenuItem      = self.UIFriendView["UIFriendView"]["badMenuItem"]
    self.applyMenuItem    = self.UIFriendView["UIFriendView"]["applyMenuItem"]
    table.insert(self.menuTable, self.myFriendMenuItem)
    table.insert(self.menuTable, self.badMenuItem)
    table.insert(self.menuTable, self.applyMenuItem)

    self.menuRootFriend = self.UIFriendView["UIFriendView"]["friend_root_node"]     --好友相关按钮
    self.menuRootBad    = self.UIFriendView["UIFriendView"]["bad_root_node"]        --坏蛋相关按钮
    self.menuRootApply  = self.UIFriendView["UIFriendView"]["apply_root_node"]      --申请相关按钮

    --红点
    self.pointNewFriend = self.UIFriendView["UIFriendView"]["point_new_friend"]     --好友红点
    self.pointNewApply = self.UIFriendView["UIFriendView"]["point_new_apply"]       --申请红点
    local redFriend = UI_Hongdiantishitexiao()
    self.pointNewFriend:addChild(redFriend)
    local redApply = UI_Hongdiantishitexiao()
    self.pointNewApply:addChild(redApply)

    --好友数量
    self.friendCount = self.UIFriendView["UIFriendView"]["friendCount"] 
    --坏蛋数量
    self.badCount = self.UIFriendView["UIFriendView"]["badCount"] 

    --好友子菜单
    self.menuNodeFriend     = self.UIFriendView["UIFriendView"]["friend_menu"]      --好友主界面按钮节点
    self.menuNodeFriendDel  = self.UIFriendView["UIFriendView"]["friendDel_menu"]   --删除好友按钮节点
    self.menuNodeFriendAdd  = self.UIFriendView["UIFriendView"]["friendAdd_menu"]   --添加好友按钮节点
    self.menuNodeFriendFind = self.UIFriendView["UIFriendView"]["friendFind_menu"]  --搜索好友按钮节点
    self.menuNodeFriendSearch = self.UIFriendView["UIFriendView"]["friend_search_root"]  --搜索好友按钮

    --坏蛋子菜单
    self.menuNodeBad     = self.UIFriendView["UIFriendView"]["badMain_menu"]        --好友主界面按钮节点
    self.menuNodeBadDel  = self.UIFriendView["UIFriendView"]["badDel_menu"]         --删除好友按钮节点

    --申请子菜单
    self.menuNodeApply    = self.UIFriendView["UIFriendView"]["apply_menu"]      --好友主界面按钮节点

    self.ruleNode = self.UIFriendView["UIFriendView"]["apply_menu"]

    ----------------------------------------------------------------------------------------
    self.ruleRoot = self.UIFriendRule["UIFriendRule"]["UIFriendRuleRoot"]
    self.ruleHuoYueDuTitle = self.UIFriendRule["UIFriendRule"]["huoyueguize_title"]
    self.ruleFanJiTitle = self.UIFriendRule["UIFriendRule"]["fanjiguize_title"]
    self.ruleText = self.UIFriendRule["UIFriendRule"]["text"]
    self.ruleRoot:setVisible(false)
    ----------------------------------------------------------------------------------------
    self.UIPopRoot = self.UIFriendPop["UIFriendPop"]["friend_pop_root"]
    self.UIPopRoot:setVisible(false)
    self.UIzscgSpt = self.UIFriendPop["UIFriendPop"]["zscg"]
    self.UIyscSpt  = self.UIFriendPop["UIFriendPop"]["ysc"]
    self.UIyjjSpt  = self.UIFriendPop["UIFriendPop"]["yjj"]
    self.UItjcgSpt = self.UIFriendPop["UIFriendPop"]["tjcg"]
    ----------------------------------------------------------------------------------------
    self.searchMyselfID = self.UIFriendView["UIFriendView"]["myselfID"] --我的ID
    self.searchMyselfID:setString(getDataManager():getCommonData():getAccountId())
    self.editBoxSearchSprite = self.UIFriendView["UIFriendView"]["editBoxBg"]
    ----------------------------------------------------------------------------------------

    self.contentLayer = self.UIFriendView["UIFriendView"]["contentLayer"]

    -->>>>>>>>>>>>>>>>>>>>>>>>>
    -- self.addLayer = self.UIFriendView["UIFriendView"]["contentLayer"]
    -- self.addContentLayer = self.UIFriendView["UIFriendView"]["contentLayer"]
    -- self.applyLayer = self.UIFriendView["UIFriendView"]["contentLayer"]
    -->>>>>>>>>>>>>>>>>>>>>>>>>

    -- self.addLayer = self.UIFriendView["UIFriendView"]["addLayer"]
    -- self.contentLayer2 = self.UIFriendView["UIFriendView"]["contentLayer2"]
    -- self.addContentLayer = self.UIFriendView["UIFriendView"]["addContentLayer"]
    -- self.myFriendMenuItem = self.UIFriendView["UIFriendView"]["myFriendMenuItem"]
    -- self.blackMenuItem = self.UIFriendView["UIFriendView"]["blackMenuItem"]
    -- self.applyMenuItem = self.UIFriendView["UIFriendView"]["applyMenuItem"]
    -- self.pageNode1 = self.UIFriendView["UIFriendView"]["pageNode1"]
    -- self.pageNode2 = self.UIFriendView["UIFriendView"]["pageNode2"]
    -- self.pageNode3 = self.UIFriendView["UIFriendView"]["pageNode3"]

    -- self.playerID = self.UIFriendView["UIFriendView"]["playerID"]

    -- self.editBoxSearchSprite = self.UIFriendView["UIFriendView"]["editBoxSearch"]
    -- self.pageNode4 = self.UIFriendView["UIFriendView"]["pageNode4"]
    -- self.applyLayer = self.UIFriendView["UIFriendView"]["applyLayer"]
    -- self.applyNum = self.UIFriendView["UIFriendView"]["applyNum"]


    -- self.myNormal = self.UIFriendView["UIFriendView"]["myNormal"]
    -- self.blackSelect = self.UIFriendView["UIFriendView"]["blackSelect"]
    -- self.applyNor = self.UIFriendView["UIFriendView"]["applyNor"]

    -- self.onInviteFriend = self.UIFriendView["UIFriendView"]["onInviteFriend"]
    -- self.onInviteFriend:setVisible(false)

    -- self.addMenuItem = self.UIFriendView["UIFriendView"]["addMenuItem1"]


    -- self.myFriendMenuItem:setEnabled(false)
    -- self.myFriendMenuItem:setAllowScale(false)
    -- self.myFriendMenuItem:getSelectedImage():setVisible(false)
    -- self.blackMenuItem:setEnabled(true)
    -- self.blackMenuItem:setAllowScale(false)
    -- self.applyMenuItem:setEnabled(true)
    -- self.applyMenuItem:setAllowScale(false)

    -- self:updateTabLabelStatus(1)
    -- self.curIndex = 1

end

function PVFriendPanel:initData()
    -- self.playerID:setString(string.format(Localize.query("friend.6"), self.GameLoginResponse.id))
end

-- 初始化二级菜单
function PVFriendPanel:initSecondMenu()

    function onCheckClick()
        cclog("-onCheckClick-")
    end

    function onSendClick()
         cclog("-onSendClick-")
    end

    function onIDeleteClick()
         cclog("-onIDeleteClick-")
    end

    self.UISecondMenuView["UICheckView"] = {}
    self.UISecondMenuView["UICheckView"]["onCheckClick"] = onCheckClick
    self.UISecondMenuView["UICheckView"]["onSendClick"] = onSendClick
    self.UISecondMenuView["UICheckView"]["onIDeleteClick"] = onIDeleteClick



    local proxy = cc.CCBProxy:create()
    self.secondMenu = CCBReaderLoad("friend/ui_friend_check.ccbi", proxy, self.UISecondMenuView)

    self.menuLayer = self.UISecondMenuView["UICheckView"]["menuLayer"]
    self.contentLayer:addChild(self.secondMenu,  10)
    -- self.secondMenu:setAnchorPoint(cc.p(0, 0.5))
    local posX = (self.contentLayer:getContentSize().width-self.secondMenu:getContentSize().width)/2
    local posY = (self.contentLayer:getContentSize().height-self.secondMenu:getContentSize().height)/2

    self.secondMenu:setPosition(cc.p(posX, posY))

    self.secondMenu:setVisible(true);
end

-- 获取精灵区域大小
function PVFriendPanel:getRectArea(layer)
    local posX, posY = layer:getPosition()
    local size = layer:getContentSize()
    local rectArea = cc.rect(posX - size.width/2, posY - size.height/2, size.width, size.height)
    return rectArea
end

-- 注册二级菜单事件
function PVFriendPanel:contentLayerRegisterTouchEvent()

    local pos = cc.p(0, 0)
    pos = self.contentLayer:convertToWorldSpace(cc.p(self.menuLayer:getPositionX(), self.menuLayer:getPositionY()))

    local posX = pos.x
    local posY = pos.y

    local size = self.menuLayer:getContentSize()
    local rectArea = cc.rect(posX, posY, size.width, size.height)
    self.contentLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.contentLayer:setTouchEnabled(true)
    local function onTouchEvent(eventType, x, y)
        if self.secondMenu:isVisible() == false then
            return
        end
        local isInRect = cc.rectContainsPoint(rectArea, cc.p(x,y))
         if  eventType == "began" then
            if isInRect then
                return false
            end
            return true
        elseif  eventType == "ended" then
                self.secondMenu:setVisible(false)
        end
    end
    self.contentLayer:registerScriptTouchHandler(onTouchEvent)
end

-- 搜索好友中  editbox事件
function PVFriendPanel:editBoxTextEventHandle(strEventName,pSender)
    local edit = pSender


    if strEventName == "return" then
        local strFmt = string.format("%s",edit:getText())

        local  data = { id_or_nickname = strFmt}
        print("-----------------------------")
        table.print(data)
        self.friendNet:sendFindFriend(data)
    end

end


--重新排序-好友
function PVFriendPanel:loadData()
    local index = 1
    for k, v in pairs(self.generalItems4) do
        v.index = index
        index = index + 1
    end
end

--重新排序-坏蛋
function PVFriendPanel:loadBadData()
    local index = 1
    for k, v in pairs(self.generalItems5) do
        v.index = index
        index = index + 1
    end
end

--移除数据-好友
function PVFriendPanel:removeTableData(_index)
    for m, n in pairs(self.generalItems4) do
        local index = n.index
        if index == _index then
            table.remove(self.generalItems4, m)
            return
        end
    end
end

--移除数据-坏蛋
function PVFriendPanel:removeBadTableData(_index)
    for m, n in pairs(self.generalItems5) do
        local index = n.index
        if index == _index then
            table.remove(self.generalItems5, m)
            return
        end
    end
end

function PVFriendPanel:initTouchListener()
    --返回
    local function onBackClick()
        getAudioManager():playEffectButton2()
        getDataManager():clearFriendData()
        self:onHideView()
    end

    local function onHydgzClick()
        print("onHydgzClick run")
        getAudioManager():playEffectButton2()
        self.ruleRoot:setVisible(true)
        self.shieldlayer:setTouchEnabled(true)
        self.ruleHuoYueDuTitle:setVisible(true)
        self.ruleFanJiTitle:setVisible(false)

        self.ruleText:setString("1、当好友每日的活跃度达到100点，即完成所有活跃度任务时，您可以在好友列表领取活跃好友奖励。\n\n2、每天每个好友达到此条件时，您都可以领取哦。\n\n3、未领取的奖励与好友已获得的活跃度会在0点清空。")
    end
    local function onFjgzClick()
        print("onFjgzClick run")
        getAudioManager():playEffectButton2()
        self.ruleRoot:setVisible(true)
        self.shieldlayer:setTouchEnabled(true)
        self.ruleHuoYueDuTitle:setVisible(false)
        self.ruleFanJiTitle:setVisible(true)

        self.ruleText:setString("1、在擂台打败您的非好友玩家会进入您的黑名单中。\n\n2、通过反击战胜对手后，不会改变您在擂台内的排行，但可以获得军功奖励。\n\n3、通过反击战胜的玩家，将从您的黑名单中消失。")
    end

    local function onMyFriendClick()
        print("onMyFriendClick run")
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(1)
        self.menuRootFriend:setVisible(true)
        self.menuRootBad:setVisible(false)
        self.menuRootApply:setVisible(false)

        self.menuNodeFriend:setVisible(true)
        self.menuNodeFriendDel:setVisible(false)
        self.menuNodeFriendAdd:setVisible(false)
        self.menuNodeFriendFind:setVisible(false)
        self.menuNodeFriendSearch:setVisible(false)

        -- self.pointNewFriend:setVisible(false)

        self.curIndex = 1
        self:initTableView()
    end

    local function onBadClick()
        print("onBadClick run")
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(2)
        self.menuRootFriend:setVisible(false)
        self.menuRootBad:setVisible(true)
        self.menuRootApply:setVisible(false)

        self.menuNodeBad:setVisible(true)
        self.menuNodeBadDel:setVisible(false)

        self.curIndex = 2
        self:initTableView()
    end
    
    local function onApplyFriendClick()
        print("onApplyFriendClick run")
        getAudioManager():playEffectButton2()
        self:updateMenuIndex(3)
        self.menuRootFriend:setVisible(false)
        self.menuRootBad:setVisible(false)
        self.menuRootApply:setVisible(true)

        -- self.pointNewApply:setVisible(false)

        self.curIndex = 3
        self:initTableView()
    end
    
    local function friend_delAallClick()--好友_批量删除 ---> 将按钮修改为删除好友
        print("friend_delAallClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeFriend:setVisible(false)
        self.menuNodeFriendDel:setVisible(true)
        self.menuNodeFriendAdd:setVisible(false)
        self.menuNodeFriendFind:setVisible(false)
        self.menuNodeFriendSearch:setVisible(false)
        
        self.curIndex = 4
        self:initTableView()
    end
    
    local function friend_addClick()--好友_添加好友 ---> 将按钮修改为添加好友
        print("friend_addClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeFriend:setVisible(false)
        self.menuNodeFriendDel:setVisible(false)
        self.menuNodeFriendAdd:setVisible(true)
        self.menuNodeFriendFind:setVisible(false)
        self.menuNodeFriendSearch:setVisible(false)

        self.curIndex = 6
        self:initTableView()
    end
    
    local function friendDel_cancelClick()--好友_批量删除_取消 ---> 将按钮改为好友主界面
        print("friendDel_cancelClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeFriend:setVisible(true)
        self.menuNodeFriendDel:setVisible(false)
        self.menuNodeFriendAdd:setVisible(false)
        self.menuNodeFriendFind:setVisible(false)
        self.menuNodeFriendSearch:setVisible(false)

        self.curIndex = 1
        self:initTableView()
    end
    
    local function friendDel_delClick()--好友_批量删除_删除 >>> 执行删除操作
        print("friendDel_delClick run")
        getAudioManager():playEffectButton2()
        if table.nums(self.totalSelect) < 1 then
            return
        end

        getOtherModule():showConfirmDialog(
            function()
                for k, v in pairs(self.totalSelect) do
                    self:removeTableData(k)
                end

                self:loadData()

                self.itemCount = table.nums(self.generalItems4)
                self.tableView:reloadData()

                 -- 发送删除好友请求
                 local data = {target_ids=self.totalSelect}
                self.friendNet:sendDeleteFriend(data)
                self.totalSelect = {}
            end
            , nil, "真的要删除选中的好友么？您确定么？")
    end
    
    local function friendAdd_cancelClick()--好友_添加好友_取消 ---> 将按钮改为好友主界面
        print("friendAdd_cancelClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeFriend:setVisible(true)
        self.menuNodeFriendDel:setVisible(false)
        self.menuNodeFriendAdd:setVisible(false)
        self.menuNodeFriendFind:setVisible(false)
        self.menuNodeFriendSearch:setVisible(false)
        
        self.curIndex = 1
        self:initTableView()
    end
    
    local function friendAdd_changeClick()--好友_添加好友_换一批 >>> 执行重新获得好友操作
        print("friendAdd_changeClick run")
        getAudioManager():playEffectButton2()

        --请求服务器,获得新的一批推送好友数据

        self.curIndex = 6
        self:initTableView()
    end
    
    local function friendAdd_findFriendClick()--好友_添加好友_搜索好友 ---> 将按钮改为搜索好友
        print("friendAdd_findFriendClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeFriend:setVisible(false)
        self.menuNodeFriendDel:setVisible(false)
        self.menuNodeFriendAdd:setVisible(false)
        self.menuNodeFriendFind:setVisible(true)
        self.menuNodeFriendSearch:setVisible(true)

        self.curIndex = 7
        self:initTableView()
    end
    
    local function friendFind_cancelClick()--好友_搜索好友_取消 ---> 将按钮改为好友主界面
        print("friendFind_cancelClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeFriend:setVisible(true)
        self.menuNodeFriendDel:setVisible(false)
        self.menuNodeFriendAdd:setVisible(false)
        self.menuNodeFriendFind:setVisible(false)
        self.menuNodeFriendSearch:setVisible(false)
        
        self.curIndex = 1
        self:initTableView()
    end
    
    local function friendFind_recommendClick()--好友_搜索好友_推荐好友 ---> 将按钮修改为添加好友
        print("friendFind_recommendClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeFriend:setVisible(false)
        self.menuNodeFriendDel:setVisible(false)
        self.menuNodeFriendAdd:setVisible(true)
        self.menuNodeFriendFind:setVisible(false)
        self.menuNodeFriendSearch:setVisible(false)

        self.curIndex = 6
        self:initTableView()
    end

    local function badMain_clearClick()--坏蛋_清空 >>> 处理清空操作
        print("badMain_clearClick run")
        getAudioManager():playEffectButton2()
        getOtherModule():showConfirmDialog(
            function()--确定清空坏蛋列表
                local _target_ids = {}
                for k,v in pairs(self.generalItems2) do
                    table.insert(data, k, self.generalItems2[k].data.id)
                end
                local  data  = { target_ids=_target_ids}
                self.friendNet:sendDelBlackName(data)
            end
            , nil, "确定清空坏蛋列表么朋友？")
    end

    local function badMain_delClick()--坏蛋_删除 ---> 将按钮修改为删除坏蛋
        print("badMain_delClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeBad:setVisible(false)
        self.menuNodeBadDel:setVisible(true)

        self.curIndex = 5
        self:initTableView()
    end

    local function badDel_cancelClick( )--坏蛋_删除_取消 ---> 进入主界面
        print("badDel_cancelClick run")
        getAudioManager():playEffectButton2()
        self.menuNodeBad:setVisible(true)
        self.menuNodeBadDel:setVisible(false)

        self.curIndex = 2
        self:initTableView()
    end
    
    local function badDel_delClick()--坏蛋_删除_删除 >>> 处理删除逻辑
        print("badDel_delClick run")
        getAudioManager():playEffectButton2()
        getOtherModule():showConfirmDialog(
            function()--确定清空坏蛋列表

                for k, v in pairs(self.totalSelect) do
                    self:removeBadTableData(k)
                end

                self:loadBadData()

                self.itemCount = table.nums(self.generalItems5)
                self.tableView:reloadData()

                 -- 发送删除好友请求
                 local data = {target_ids=self.totalSelect}
                self.friendNet:sendDeleteFriend(data)
                self.totalSelect = {}
                -----------------

                -- local _target_ids = {}
                -- for k,v in pairs(self.totalSelect) do
                --     table.insert(data, k, self.totalSelect[k].data.id)
                -- end
                -- local  data  = { target_ids=_target_ids}
                -- self.friendNet:sendDelBlackName(data)
                -- self.totalSelect = {}
            end
            , nil, "删除选中的玩家后，将无法再进行反击。确定删除么？")
    end
    
    local function apply_no_allClick()--申请_全部拒绝 >>> 处理全部拒绝逻辑
        print("apply_no_allClick run")
        getAudioManager():playEffectButton2()

        local _target_ids = {}

        for k,v in pairs(self.generalItems3) do
            table.insert(_target_ids, k, self.generalItems3[k].data.id)
        end

        local  data  = { target_ids=_target_ids}
        self.friendNet:sendRefuseFriendApply(data)
    end
    
    local function apply_yes_allClick()--申请_全部添加 >>> 处理全部添加逻辑
        print("apply_yes_allClick run")
        getAudioManager():playEffectButton2()
        local _target_ids = {}

        for k,v in pairs(self.generalItems3) do
            table.insert(_target_ids, k, self.generalItems3[k].data.id)
        end

        local  data  = { target_ids=_target_ids}
        self.friendNet:sendAcceptFriendApply(data)
    end

    local function ruleCloseClick()--关闭规则 >>> 关闭规则显示页面
        print("ruleCloseClick run")
        getAudioManager():playEffectButton2()
        self.ruleRoot:setVisible(false)
        self.shieldlayer:setTouchEnabled(false)
    end

    local function onSearchClick()--搜索好友 >>> 更具输入框搜索好友
        print("onSearchClick run")
        getAudioManager():playEffectButton2()
        local strFmt = self.editBoxSearch:getText()
        if string.len(strFmt)<=0 then
            getOtherModule():showAlertDialog(nil, Localize.query("friend.4"))
            return
        end
        local  data = {id_or_nickname=strFmt}
        self.friendNet:sendFindFriend(data)
    end

    self.UIFriendView["UIFriendView"] = {}

    self.UIFriendView["UIFriendView"]["onBackClick"] = onBackClick                  --关闭按钮

    self.UIFriendView["UIFriendView"]["onHydgzClick"] = onHydgzClick                --好友活跃规则
    self.UIFriendView["UIFriendView"]["onFjgzClick"] = onFjgzClick                  --反击规则

    self.UIFriendView["UIFriendView"]["onMyFriendClick"] = onMyFriendClick              --好友按钮
    self.UIFriendView["UIFriendView"]["onBadClick"] = onBadClick                        --坏蛋按钮
    self.UIFriendView["UIFriendView"]["onApplyFriendClick"] = onApplyFriendClick        --申请按钮
    -----------------
    self.UIFriendView["UIFriendView"]["friend_delAallClick"] = friend_delAallClick              --好友_批量删除
    self.UIFriendView["UIFriendView"]["friend_addClick"] = friend_addClick                      --好友_添加好友

    self.UIFriendView["UIFriendView"]["friendDel_cancelClick"] = friendDel_cancelClick          --好友_批量删除_取消
    self.UIFriendView["UIFriendView"]["friendDel_delClick"] = friendDel_delClick                --好友_批量删除_删除

    self.UIFriendView["UIFriendView"]["friendAdd_cancelClick"] = friendAdd_cancelClick          --好友_添加好友_取消
    self.UIFriendView["UIFriendView"]["friendAdd_changeClick"] = friendAdd_changeClick          --好友_添加好友_换一批
    self.UIFriendView["UIFriendView"]["friendAdd_findFriendClick"] = friendAdd_findFriendClick  --好友_添加好友_搜索好友

    self.UIFriendView["UIFriendView"]["onSearchClick"] = onSearchClick        --好友_搜索好友_搜索
    self.UIFriendView["UIFriendView"]["friendFind_cancelClick"] = friendFind_cancelClick        --好友_搜索好友_取消
    self.UIFriendView["UIFriendView"]["friendFind_recommendClick"] = friendFind_recommendClick  --好友_搜索好友_推荐好友
    -----------------
    self.UIFriendView["UIFriendView"]["badMain_clearClick"] = badMain_clearClick                --坏蛋_清空
    self.UIFriendView["UIFriendView"]["badMain_delClick"] = badMain_delClick                    --坏蛋_删除

    self.UIFriendView["UIFriendView"]["badDel_cancelClick"] = badDel_cancelClick                --坏蛋_删除_取消
    self.UIFriendView["UIFriendView"]["badDel_delClick"] = badDel_delClick                      --坏蛋_删除_删除
    -----------------
    self.UIFriendView["UIFriendView"]["apply_no_allClick"] = apply_no_allClick                  --申请_全部拒绝
    self.UIFriendView["UIFriendView"]["apply_yes_allClick"] = apply_yes_allClick                --申请_全部添加
    -----------------------------------------------
    self.UIFriendRule["UIFriendRule"] = {}
    self.UIFriendRule["UIFriendRule"]["ruleCloseClick"] = ruleCloseClick        --关闭规则按钮
    -----------------------------------------------

    -- self.UIFriendView["UIFriendView"]["onMyFriendClick"] = onMyFriendClick
    -- self.UIFriendView["UIFriendView"]["onBlackClick"] = onBlackClick
    -- self.UIFriendView["UIFriendView"]["onApplyFriendClick"] = onApplyFriendClick
    -- self.UIFriendView["UIFriendView"]["onAddFriendClick"] = onAddFriendClick
    -- self.UIFriendView["UIFriendView"]["onInviteFriendClick"] = onInviteFriendClick
    -- self.UIFriendView["UIFriendView"]["onDeleFriendClick"] = onDeleFriendClick
    -- self.UIFriendView["UIFriendView"]["onAllAgreeClick"] = onAllAgreeClick
    -- self.UIFriendView["UIFriendView"]["onAllIgnoreClick"] = onAllIgnoreClick
    -- self.UIFriendView["UIFriendView"]["onBackFriendClick"] = onBackFriendClick
    -- self.UIFriendView["UIFriendView"]["onSureDeleteClick"] = onSureDeleteClick
    -- self.UIFriendView["UIFriendView"]["onSerachClick"] = onSerachClick

end

function PVFriendPanel:updateMenuIndex(index)
    print("PVFriendPanel:updateMenuIndex index = " .. index)
    for i=1,3 do
        if i == index then
            self.imgSelect[i]:setVisible(true)
            self.imgNormal[i]:setVisible(false)
            self.menuTable[i]:setEnabled(false)
        else
            self.imgSelect[i]:setVisible(false)
            self.imgNormal[i]:setVisible(true)
            self.menuTable[i]:setEnabled(true)
        end
    end
end

function PVFriendPanel:updateTabLabelStatus(id)
    -- cclog(self.curIndex.."=id="..id)
    if self.curIndex == 1 then
        game.setSpriteFrame(self.myNormal, "#ui_common_s_myf.png")
    elseif self.curIndex == 2 then
        game.setSpriteFrame(self.blackSelect, "#ui_common_s_block.png")
    elseif self.curIndex == 3 then
        game.setSpriteFrame(self.applyNor, "#ui_common_s_w2bf.png")
    end

    if id == 1 then
        game.setSpriteFrame(self.myNormal, "#ui_common_s_myfl.png")
    elseif id == 2 then
        game.setSpriteFrame(self.blackSelect, "#ui_common_s_blockl.png")
    elseif id == 3 then
        game.setSpriteFrame(self.applyNor, "#ui_common_s_w2bfl.png")
    end

    if self.editBoxSearch ~= nil then
        self.editBoxSearch:setVisible(false)
    end
end

function PVFriendPanel:initTableView()
    if self.tableView ~= nil then
        self.tableView:removeFromParent(true)
    end
    local lSize = self.contentLayer:getContentSize()
    local calcSize = nil

    if self.editBoxSearch ~= nil then
        self.editBoxSearch:removeFromParent(true)
    end
    self.editBoxSearch = nil

    if self.curIndex == 7 then--搜索
        calcSize = cc.size(lSize.width, lSize.height - 130)

        --加入搜索框editbox
        self.editBoxSearch = ui.newEditBox({
            image = cc.Scale9Sprite:create(),
            -- size = cc.size(self.editBoxSearchSprite:getContentSize().width, self.editBoxSearchSprite:getContentSize().height-20),
            size = cc.size(self.editBoxSearchSprite:getContentSize().width - 200, self.editBoxSearchSprite:getContentSize().height),
            x = self.editBoxSearchSprite:getPositionX() + 65 + 200,
            y = self.editBoxSearchSprite:getPositionY(),
            listener = function(strEventName,pSender)
            end
        })

        self.editBoxSearch:setPlaceHolder(Localize.query("friend.4"))
        self.editBoxSearch:setFont(MINI_BLACK_FONT_NAME, 28)
        self.editBoxSearch:setPlaceholderFontColor(cc.c3b(255,186,0))
        self.editBoxSearch:setMaxLength(20)
        self.editBoxSearch:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE )
        self.editBoxSearch:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
        self.menuNodeFriendSearch:addChild(self.editBoxSearch)

    else
        calcSize = lSize
    end
    -- self.layerSize = self.contentLayer:getContentSize()
    self.layerSize = calcSize
    self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    self.contentLayer:removeChildByTag(999)
    local scrBar = PVScrollBar:new()
    scrBar:setTag(999)
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
    print("_LZD::initTableView")
    -- self:setButtonsState()

    self.totalSelect = {}
end

function PVFriendPanel:scrollViewDidScroll(view)
end

function PVFriendPanel:scrollViewDidZoom(view)
end

function PVFriendPanel:tableCellTouched(tab, cell)
    print("_LZD:cell触摸事件 curIndex = " .. self.curIndex)
    local index = cell:getIdx()
    print("_LZD:index = " .. index)

    local chooseSpt = cell.UIFriendCell["UIFriendCell"]["chooseSpt"]

    if self.curIndex == 5 then --删除坏蛋
        if (chooseSpt:isVisible()) then
            chooseSpt:setVisible(false)
            self.generalItems5[index + 1].isSelect = false
            self.totalSelect[index + 1] = nil
            table.remove(self.totalSelect, index + 1)
        else
            chooseSpt:setVisible(true)
            self.generalItems5[index + 1].isSelect = true
            table.insert(self.totalSelect, index + 1, self.generalItems5[index + 1].data.id)
        end
    elseif self.curIndex == 4 then -- 删除好友
        if (chooseSpt:isVisible()) then
            chooseSpt:setVisible(false)
            self.generalItems4[index + 1].isSelect = false
            self.totalSelect[index + 1] = nil
            table.remove(self.totalSelect, index + 1)
        else
            chooseSpt:setVisible(true)
            self.generalItems4[index + 1].isSelect = true
            table.insert(self.totalSelect, index + 1, self.generalItems4[index + 1].data.id)
        end
    elseif self.curIndex == 1 then
        -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVFriendSecondMenu", self.generalItems1[index + 1])
    end

    print("_LZD::tableCellTouched")
    self:setButtonsState()
end

function PVFriendPanel:cellSizeForTable(table, idx)
    return 150, 519
    -- return 640, 140
end

-- 设置好友头像
function PVFriendPanel:setFriendIcon(friendIcon, hero_id)
    local c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    local soldier_template = c_SoldierTemplate:getHeroTempLateById(hero_id)
    if soldier_template then
        local resIcon = c_SoldierTemplate:getSoldierIcon(hero_id)
        changeNewIconImage(friendIcon, resIcon, soldier_template.quality)
    end
end


function PVFriendPanel:isExistsInFriend(no)
    local _friendListData = getDataManager():getFriendData():getListData()

    for k, v in pairs(_friendListData.friends) do
        if v.id == no then
            return true
        end
    end

    return false
end


function PVFriendPanel:tableCellAtIndex(tbl, idx)


    local cell = nil --tbl:dequeueCell()
    local friendData = nil --数据

    -- 预定义需要操作的元素
    local friendBg      --好友背景
    local badBg         --坏蛋背景
    local cellHeadBg    --icon背景
    local friendIcon    --头像
    local detailLabel1  --昵称label
    local rankLabel     --排名label
    local lvFontLabel    --等级Fontlabel
    local powerLabel          --战力label
    local battleRankRoot  --擂台排名root
    local battleRankLabel  --擂台排名
    local stateRoot  --状态root
    local stateTTF         --在线状态
    local lastTimeLabel   --离线时间

    local chooseNode    --勾选菜单
    local chooseBtn     --勾选背景
    local chooseSpt     --勾选前景

    local friendMenuRoot--好友菜单root
    local huoyueduBtn   --活跃度按钮
    local huoyueduNoBtn --活跃度No按钮
    local tiliBtn       --体力按钮
    local huoyueduSpt   --活跃奖励
    local huoyueduTTF   --活跃度文字
    local huoyueduEndIcon--已领取奖励icon
    local huoyueduEndSpt--已领取奖励文字
    local tiliONSpt     --赠予体力文字
    local tiliOFFSpt    --已赠予文字

    local friendAddRoot --添加好友root
    local addBtn        --添加好友按钮
    local addEndSpt     --已添加文字

    local badAttackRoot   --反击菜单

    local applyYesOrNoRoot --拒绝或同意菜单

    -----------------------工具方法定义-----------------------
    --设置活跃度奖励状态
    local function setActivityBtnState(num) -- -1->已领取, 小于上限->不可领取, 等于或超过上限->可领取
        if num < 0 then
            huoyueduBtn:setVisible(false)
            huoyueduNoBtn:setVisible(false)
            huoyueduSpt:setVisible(false)
            huoyueduTTF:setVisible(false)
            huoyueduEndIcon:setVisible(true)
            huoyueduEndSpt:setVisible(true)
        elseif num < self.friendActivityValue then
            huoyueduBtn:setVisible(false)
            huoyueduSpt:setVisible(false)
            huoyueduNoBtn:setVisible(true)
            huoyueduTTF:setVisible(true)
            huoyueduEndIcon:setVisible(false)
            huoyueduEndSpt:setVisible(false)
        elseif num >= self.friendActivityValue then
            num = self.friendActivityValue
            huoyueduBtn:setVisible(true)
            huoyueduSpt:setVisible(true)
            huoyueduNoBtn:setVisible(false)
            huoyueduTTF:setVisible(false)
            huoyueduEndIcon:setVisible(false)
            huoyueduEndSpt:setVisible(false)
        end
    end

    --设置赠送体力状态
    local function toPresentState(num) -- 0->不可赠送, 大于0->可赠送
        if num <= 0 then
            tiliBtn:setEnabled(false)
            tiliONSpt:setVisible(false)
            tiliOFFSpt:setVisible(true)
        elseif num > 0 then
            tiliBtn:setEnabled(true)
            tiliONSpt:setVisible(true)
            tiliOFFSpt:setVisible(false)
        end
    end

    --设置添加好友按钮为不可用
    local function toDisableAdd()
        print("_LZD:toDisableAdd run")
        addBtn:setVisible(false)
        addEndSpt:setVisible(true)
        friendData.isSelect = true --代表已添加
    end

    print("_LZD:idx = " .. idx .. "  curIndex = " .. self.curIndex)
    if nil == cell then
        cell = cc.TableViewCell:new()
        cell.UIFriendCell = {}
        cell.UIFriendCell["UIFriendCell"] = {}

        -- 校验数据 && 数据设置
        --(1 -- 好友列表; 2 -- 坏蛋列表; 3 -- 申请列表; 4 -- 删除好友列表; 5 -- 删除坏蛋列表; 6 -- 推荐好友列表, 7 -- 查找好友列表)
        if self.curIndex == 1 then
            if table.nums(self.generalItems1) < 1 then
                return cell
            end
            friendData = self.generalItems1[idx + 1]
        elseif self.curIndex == 2 then
            if table.nums(self.generalItems2) < 1 then
                return cell
            end
            friendData = self.generalItems2[idx + 1]
        elseif self.curIndex == 3 then
            if table.nums(self.generalItems3) < 1 then
                return cell
            end
            friendData = self.generalItems3[idx + 1]
        elseif self.curIndex == 4 then
            if table.nums(self.generalItems4) < 1 then
                return cell
            end
            friendData = self.generalItems4[idx + 1]
        elseif self.curIndex == 5 then
            if table.nums(self.generalItems5) < 1 then
                return cell
            end
            friendData = self.generalItems5[idx + 1]
        elseif self.curIndex == 6 then
            if table.nums(self.generalItems6) < 1 then
                return cell
            end
            friendData = self.generalItems6[idx + 1]
        elseif self.curIndex == 7 then
            print("_LZD:generalItems7.count = " .. table.nums(self.generalItems7))
            if table.nums(self.generalItems7) < 1 then
                print("_LZD:return cell")
                return cell
            end
            friendData = self.generalItems7[idx + 1]
        end

        -----------------------界面按钮事件-----------------------
        local function onHeadClick()
            print("onHeadClick")
            getAudioManager():playEffectButton2()

            local pos = cell:convertToWorldSpace({0, 0})
            local switchToHeadClick = {
                [1] = function ()
                    getOtherModule():showOtherView("PVChatCheck", friendData.data.id, cell:getContentSize().height, pos.y, friendData.data.nickname, true, true)
                end,
                [2] = function ()
                    getOtherModule():showOtherView("PVChatCheck", friendData.data.id, cell:getContentSize().height, pos.y, friendData.data.nickname, true, true)
                end,
                [3] = function ()
                    getOtherModule():showOtherView("PVChatCheck", friendData.data.id, cell:getContentSize().height, pos.y, friendData.data.nickname, true, false)
                end,
                [4] = function ()
                    -- getOtherModule():showOtherView("PVFriendSecondMenu", self, friendData, pos.x, pos.y, true, true, true)
                end,
                [5] = function ()
                    -- getOtherModule():showOtherView("PVFriendSecondMenu", self, friendData, pos.x, pos.y, true, true, true)
                end,
                [6] = function ()
                    getOtherModule():showOtherView("PVChatCheck", friendData.data.id, cell:getContentSize().height, pos.y, friendData.data.nickname, true, false)
                end,
                [7] = function ()
                    getOtherModule():showOtherView("PVChatCheck", friendData.data.id, cell:getContentSize().height, pos.y, friendData.data.nickname, true, false)
                end
            }

            if switchToHeadClick[self.curIndex] ~= nil then
                switchToHeadClick[self.curIndex]()
            end
        end
        local function onHuoyueduClick()    --领取活跃度奖励
            print("onHuoyueduClick")
            getAudioManager():playEffectButton2()
            if self.curIndex == 1 then
                --设置活跃度按钮状态为已领取
                setActivityBtnState(-1)
                --向服务器发送领取活跃度奖励的请求--!!未完成
                getOtherModule():showOtherView("PVCongratulationsGainDialog", 5, self.activityGiftNum)
            end
        end
        local function onHuoyueduNoClick()  --不可领取时显示要领取的物品
            print("onHuoyueduNoClick")
            getAudioManager():playEffectButton2()
            if self.curIndex == 1 then
                --显示可领取奖励的弹窗--!!未完成
            end
        end
        local function onTiliClick()
            print("onTiliClick")
            getAudioManager():playEffectButton2()
            if self.curIndex == 1 then
                toPresentState(0)
                local data = {target_ids={friendData.data.id}}
                self.friendNet:sendPresentVigor(data)
            end
        end
        local function onAddClick()
            print("onAddClick")
            getAudioManager():playEffectButton2()
            if self.curIndex == 6 then
                toDisableAdd()
                local  data  = { target_ids={friendData.data.id}}
                self.friendNet:sendAcceptFriendApply(data)
            end
        end
        local function onAttackClick() 
            print("onAttackClick")
            getAudioManager():playEffectButton2()
            if self.curIndex == 2 then
                --!!未完成(进入布阵界面)
            end
        end
        local function onYesClick()
            print("onYesClick")
            getAudioManager():playEffectButton2()
            if self.curIndex == 3 then
                local  data  = { target_ids={friendData.data.id}}
                self.friendNet:sendAcceptFriendApply(data)
            end
        end
        local function onNoClick()
            print("onNoClick")
            getAudioManager():playEffectButton2()
            if self.curIndex == 3 then
                local  data  = { target_ids={friendData.data.id}}
                self.friendNet:sendRefuseFriendApply(data)
            end
        end

        -----------------------加载界面按钮-----------------------
        cell.UIFriendCell["UIFriendCell"]["onHeadClick"] = onHeadClick
        cell.UIFriendCell["UIFriendCell"]["onHuoyueduClick"] = onHuoyueduClick
        cell.UIFriendCell["UIFriendCell"]["onHuoyueduNoClick"] = onHuoyueduNoClick
        cell.UIFriendCell["UIFriendCell"]["onTiliClick"] = onTiliClick
        cell.UIFriendCell["UIFriendCell"]["onAddClick"] = onAddClick
        cell.UIFriendCell["UIFriendCell"]["onAttackClick"] = onAttackClick
        cell.UIFriendCell["UIFriendCell"]["onYesClick"] = onYesClick
        cell.UIFriendCell["UIFriendCell"]["onNoClick"] = onNoClick

        -----------------------加载ccbi文件-----------------------
        local proxy = cc.CCBProxy:create()
        local node = CCBReaderLoad("friend/ui_friend_cell_1.ccbi", proxy, cell.UIFriendCell)
        cell:addChild(node)

        -----------------------加载界面元素-----------------------
        friendBg         = cell.UIFriendCell["UIFriendCell"]["itemBg"]     --好友背景
        badBg            = cell.UIFriendCell["UIFriendCell"]["itemBadBg"]  --坏蛋背景
        cellHeadBg       = cell.UIFriendCell["UIFriendCell"]["cellHeadBG"]  --坏蛋背景
        friendIcon       = cell.UIFriendCell["UIFriendCell"]["friendIcon"]--头像
        detailLabel1     = cell.UIFriendCell["UIFriendCell"]["detailLabel1"]--昵称label
        rankLabel        = cell.UIFriendCell["UIFriendCell"]["rankLabel"]--排名label
        lvFontLabel      = cell.UIFriendCell["UIFriendCell"]["lvFontLabel"]--等级Fontlabel
        powerLabel       = cell.UIFriendCell["UIFriendCell"]["powerLabel"]--战力label
        battleRankRoot   = cell.UIFriendCell["UIFriendCell"]["battleRankRoot"]--擂台排名root
        battleRankLabel  = cell.UIFriendCell["UIFriendCell"]["battleRankLabel"]--擂台排名
        stateRoot        = cell.UIFriendCell["UIFriendCell"]["stateRoot"]--状态root
        stateTTF         = cell.UIFriendCell["UIFriendCell"]["stateTTF"]--在线状态
        lastTimeLabel    = cell.UIFriendCell["UIFriendCell"]["lastTimeLabel"]--离线时间

        chooseNode       = cell.UIFriendCell["UIFriendCell"]["chooseNode"]--勾选菜单
        chooseBtn        = cell.UIFriendCell["UIFriendCell"]["chooseBtn"]--勾选背景
        chooseSpt        = cell.UIFriendCell["UIFriendCell"]["chooseSpt"]--勾选前景

        friendMenuRoot   = cell.UIFriendCell["UIFriendCell"]["friend_node_huoyuedu_Tili"]--好友菜单root
        huoyueduBtn      = cell.UIFriendCell["UIFriendCell"]["huoyueduBtn"]--活跃度按钮
        huoyueduNoBtn    = cell.UIFriendCell["UIFriendCell"]["huoyueduNoBtn"]--活跃度No按钮
        SpriteGrayUtil:drawSpriteTextureGray(huoyueduNoBtn:getNormalImage())
        tiliBtn          = cell.UIFriendCell["UIFriendCell"]["tiliBtn"]--体力按钮
        huoyueduSpt      = cell.UIFriendCell["UIFriendCell"]["huoyueduSpt"]--活跃奖励
        huoyueduTTF      = cell.UIFriendCell["UIFriendCell"]["huoyueduTTF"]--活跃度文字
        huoyueduEndIcon  = cell.UIFriendCell["UIFriendCell"]["huoyueduEndIcon"]--已领取奖励icon
        huoyueduEndSpt   = cell.UIFriendCell["UIFriendCell"]["huoyueduEndSpt"]--已领取奖励文字
        tiliONSpt        = cell.UIFriendCell["UIFriendCell"]["tiliONSpt"]--赠予体力文字
        tiliOFFSpt       = cell.UIFriendCell["UIFriendCell"]["tiliOFFSpt"]--已赠予文字

        friendAddRoot    = cell.UIFriendCell["UIFriendCell"]["friend_node_add"]--添加好友root
        addBtn           = cell.UIFriendCell["UIFriendCell"]["addBtn"]--添加好友按钮
        addEndSpt        = cell.UIFriendCell["UIFriendCell"]["addEndSpt"]--已添加文字

        badAttackRoot    = cell.UIFriendCell["UIFriendCell"]["bad_node_attack"]--反击菜单

        applyYesOrNoRoot = cell.UIFriendCell["UIFriendCell"]["apply_node_yes_or_no"]--拒绝或同意菜单
    end

    --设置头像
    if friendData == nil then
        print("_LZD:data == nil")
    else
        print("_LZD:data ~= nil")
    end
    print("_LZD:XX = " .. friendData.data.hero_no)
    -- self:setFriendIcon(friendIcon, friendData.data.hero_no)
    local resIcon = getTemplateManager():getSoldierTemplate():getSoldierHead(friendData.data.hero_no)
    print("_LZD:resIcon ======== ", resIcon)
    friendIcon:setTexture("res/icon/hero_head/"..resIcon)
    --设置昵称
    detailLabel1:setString(string.format("%s", friendData.data.nickname))
    --设置排名
    rankLabel:setString(string.format("%s%s%s", "第", friendData.data.b_rank, "名"))
    --设置等级
    lvFontLabel:addChild(getLevelNode(friendData.data.level))
    --设置战力
    powerLabel:setString(string.format("%s", friendData.data.power))
    --设置擂台排名
    battleRankLabel:setString(string.format("%s", friendData.data.b_rank))
    period = getDataManager():getCommonData():getTime() - friendData.data.last_time
    if period < 0 then
        --设置状态
        stateTTF:setVisible(true)
    else
        if period > (60*60*24*356) then
            str_period = string.format("%s", math.ceil(period / (60*60*24*30)))
            str_period = str_period .. self.languageTemplate:getLanguageById(3200000002)
        elseif period > (60*60*24) then
            str_period = string.format("%s", math.ceil(period / (60*60*24)))
            str_period = str_period .. self.languageTemplate:getLanguageById(3200000003)
        elseif period > (60*60) then
            str_period = string.format("%s", math.ceil(period / (60*60)))
            str_period = str_period .. self.languageTemplate:getLanguageById(3200000004)
        elseif period > 60 then
            str_period = string.format("%s", math.ceil(period / 60))
            str_period = str_period .. self.languageTemplate:getLanguageById(3200000005)
        else
            str_period = string.format("%s", math.ceil(period))
            str_period = str_period .. self.languageTemplate:getLanguageById(3200000006)
        end
        --设置离线时间
        lastTimeLabel:setString(string.format("离线时间：%s", str_period))
    end

    --设置活跃度
    huoyueduTTF:setString(string.format("(%d/%d)", friendData.data.activity, self.friendActivityValue))

    --初始化设置
    friendBg:setVisible(false)
    badBg:setVisible(false)
    battleRankRoot:setVisible(false)
    stateRoot:setVisible(false)
    chooseNode:setVisible(false)   
    friendMenuRoot:setVisible(false)
    friendAddRoot:setVisible(false)
    badAttackRoot:setVisible(false)
    applyYesOrNoRoot:setVisible(false)
    local switchToInit = {
        [1] = function ()
            friendBg:setVisible(true)
            stateRoot:setVisible(true)
            friendMenuRoot:setVisible(true)
            --设置活跃度和体力按钮状态
            setActivityBtnState(friendData.data.activity)
            toPresentState(friendData.data.gift)

            --设置前3名特殊边框
            if idx == 0 then
                local cellFirstA = cell.UIFriendCell["UIFriendCell"]["cellFirstA"]
                local cellFirstB = cell.UIFriendCell["UIFriendCell"]["cellFirstB"]
                cellFirstA:setVisible(true)
                cellFirstB:setVisible(true)
                cellHeadBg:setVisible(false)
                rankLabel:setVisible(false)
            elseif idx == 1 then
                local cellSecondA = cell.UIFriendCell["UIFriendCell"]["cellSecondA"]
                local cellSecondB = cell.UIFriendCell["UIFriendCell"]["cellSecondB"]
                cellSecondA:setVisible(true)
                cellSecondB:setVisible(true)
                cellHeadBg:setVisible(false)
                rankLabel:setVisible(false)
            elseif idx == 2 then
                local cellThreadA = cell.UIFriendCell["UIFriendCell"]["cellThreadA"]
                local cellThreadB = cell.UIFriendCell["UIFriendCell"]["cellThreadB"]
                cellThreadA:setVisible(true)
                cellThreadB:setVisible(true)
                cellHeadBg:setVisible(false)
                rankLabel:setVisible(false)
            end
        end,
        [2] = function ()
            badBg:setVisible(true)
            rankLabel:setVisible(false)
            battleRankRoot:setVisible(true)
            badAttackRoot:setVisible(true)
        end,
        [3] = function ()
            friendBg:setVisible(true)
            rankLabel:setVisible(false)
            stateRoot:setVisible(true)
            applyYesOrNoRoot:setVisible(true)
        end,
        [4] = function ()
            friendBg:setVisible(true)
            stateRoot:setVisible(true)
            chooseNode:setVisible(true) 
        end,
        [5] = function ()
            badBg:setVisible(true)
            rankLabel:setVisible(false)
            battleRankRoot:setVisible(true)
            chooseNode:setVisible(true)
        end,
        [6] = function ()
            friendBg:setVisible(true)
            rankLabel:setVisible(false)
            stateRoot:setVisible(true)
            friendAddRoot:setVisible(true)
            if friendData.isSelect then
                addBtn:setVisible(false)
                addEndSpt:setVisible(true)
            else
                addBtn:setVisible(true)
                addEndSpt:setVisible(false)
            end
        end,
        [7] = function ()
            friendBg:setVisible(true)
            rankLabel:setVisible(false)
            stateRoot:setVisible(true)
            friendAddRoot:setVisible(true)
        end
    }
    if switchToInit[self.curIndex] ~= nil then
        switchToInit[self.curIndex]()
    end

    return cell
end

function PVFriendPanel:numberOfCellsInTableView(table)
    print("PVFriendPanel:numberOfCellsInTableView table.cellsize = " .. self.itemCount)
    return self.itemCount
end

function PVFriendPanel:onShowLegionApplyView()
    self:setVisible(true)
    self.tableView:reloadData()
end

function PVFriendPanel:onHideLegionApplyView()
    self:setVisible(false)
end

function PVFriendPanel:onHomePageHide()
    self:onHideLegionApplyView()
end

function PVFriendPanel:clearResource()
    print('-PVFriendPanel:clearResource-')
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_friend.plist")
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_common1.plist")
end

--根据得到的数据,设置某些按钮的状态
function PVFriendPanel:setButtonsState()
    local menuApplyNoAll  = self.UIFriendView["UIFriendView"]["apply_no_all"]      --申请主界面按钮节点
    local menuApplyYesAll = self.UIFriendView["UIFriendView"]["apply_yes_all"]      --申请主界面按钮节点
    if table.nums(self.generalItems3) < 1 then
        menuApplyNoAll:setEnabled(false)
        menuApplyYesAll:setEnabled(false)
    else
        menuApplyNoAll:setEnabled(true)
        menuApplyYesAll:setEnabled(true)
    end

    local menuFriendDelAll  = self.UIFriendView["UIFriendView"]["friend_delAall"]      --好友主界q全部删除
    print("_LZD::1")
    if table.nums(self.generalItems1) < 1 then
        print("_LZD::2")
        menuFriendDelAll:setEnabled(false)
    else
        print("_LZD::3")
        menuFriendDelAll:setEnabled(true)
    end

    local menuFriendDel = self.UIFriendView["UIFriendView"]["friendDel_del"]    --删除好友界面,确认删除按钮
    local menuBadDelDel = self.UIFriendView["UIFriendView"]["badDel_del"]         --坏蛋界面,确认删除按钮
    print("_LZD:select.count = " .. table.nums(self.totalSelect))
    if table.nums(self.totalSelect) < 1 then
        menuFriendDel:setEnabled(false)
        menuBadDelDel:setEnabled(false)
    else
        menuFriendDel:setEnabled(true)
        menuBadDelDel:setEnabled(true)
    end

    local menuBadClear = self.UIFriendView["UIFriendView"]["badMain_clear"]     --坏蛋界面,清空按钮
    local menuBadDel = self.UIFriendView["UIFriendView"]["badMain_del"]         --坏蛋界面,删除按钮
    if table.nums(self.generalItems2) < 1 then
        menuBadClear:setEnabled(false)
        menuBadDel:setEnabled(false)
    else
        menuBadClear:setEnabled(true)
        menuBadDel:setEnabled(true)
    end
end

return PVFriendPanel