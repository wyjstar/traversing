CREATE_LEGION = 801             --创建军团
JOIN_LEGION = 802               --加入军团
EXIT_LEGION = 803               --退出军团
EDIT_ANNOUNCEMENT = 804         --修改公告
DEALI_JOIN_APPLY = 805          --处理加入军团申请
TRANSFER_LEGION = 806           --转让团长
KILL_OUT = 807                  --提出军团
LEGION_PROMOTION = 808          --晋升
LEGION_WORSHIP = 809            --膜拜
GET_RANK_LIST = 810             --获取军团排行列表
GET_MEMBER_LIST = 811           --获取成员列表
PLAYER_GET_LEGION_INFO = 812    --玩家获取公会信息
GET_APPLY_LIST = 813            --获取加入军团申请列表
GET_KILL_OUT_TIP = 814          --被踢推送消息
GET_APPLY_LIST_NOTICE = 850     --申请消息
INVITE_JOIN_LEGION = 1803       --邀请加入军团
DEAL_INVITE_JOIN_LEGION = 1804       --处理邀请加入军团

LegionNet = class("LegionNet", BaseNetWork)

function LegionNet:ctor()
    self.super.ctor(self, "LegionNet")
    self:init()
end

function LegionNet:init()
    self.legionData = getDataManager():getLegionData()
    self:registerLeginCallBack()
end

--公会创建  801
function LegionNet:sendCreateLegion(cur_name)
    local data =
                {
                    name = cur_name
                }
    self:sendMsg(CREATE_LEGION, "CreateGuildRequest", data)
end

--申请加入军团  802
function LegionNet:sendApplyJoin(legion_id)
    local data =
                {
                    g_id = legion_id
                }

    self:sendMsg(JOIN_LEGION, "JoinGuildRequest", data)
end

--退出军团  803
function LegionNet:sendExitLegion()
    self:sendMsg(EXIT_LEGION)
end

--修改公告  804
function LegionNet:sendEditAnounce(content)
    local data =
                {
                    call = content
                }

    self:sendMsg(EDIT_ANNOUNCEMENT, "EditorCallRequest", data)
end

--处理加军团的申请  805
function LegionNet:sendDealApply(player_ids, deal_type)
    local data =
                {
                    p_ids = player_ids,
                    res_type = deal_type
                }

    self:sendMsg(DEALI_JOIN_APPLY, "DealApplyRequest", data)
end

--转让团长  806
function LegionNet:sendTransferLegion(aim_id)
    local data =
                {
                    p_id = aim_id
                }
    self:sendMsg(TRANSFER_LEGION, "ChangePresidentRequest", data)
end

--踢出军团  807
function LegionNet:sendKillOutLegion(aim_ids)
    local data =
                {
                    p_ids = aim_ids
                }
    self:sendMsg(KILL_OUT, "KickRequest", data)
end

--晋升职位  808
function LegionNet:sendPromotion()
    self:sendMsg(LEGION_PROMOTION)
end

--膜拜    809
function LegionNet:sendWorship(cur_type)
    local data =
                {
                    w_type = cur_type
                }
    self:sendMsg(LEGION_WORSHIP, "WorshipRequest", data)
end

--请求军团排行列表  810
function LegionNet:sendGetRankList()
    self:sendMsg(GET_RANK_LIST)
end

--获取成员玩家列表  811
function LegionNet:sendGetMemberList()
    self:sendMsg(GET_MEMBER_LIST)
end

--玩家获取公会信息  812
function LegionNet:sendGetLegionInfo()
    self:sendMsg(PLAYER_GET_LEGION_INFO)
end

--获取加入军团申请列表    813
function LegionNet:sendGetApplyList()
    self:sendMsg(GET_APPLY_LIST)
end

--邀请加入军团 1803
function LegionNet:sendInviteJoin(userId)
    local data = { user_id = userId }
    self:sendMsg(INVITE_JOIN_LEGION, "InviteJoinRequest", data)
end

--处理邀请加入军团 1804
function LegionNet:sendDealInviteJoin(resultNo, guildId)
    print("发送处理协议 ============== ")
    local data =
                {
                    res = resultNo,
                    guild_id = guildId
                }
    table.print(data)
    self:sendMsg(DEAL_INVITE_JOIN_LEGION, "DealInviteJoinRequest", data)
end

--协议返回注册
function LegionNet:registerLeginCallBack()
    --创建返回数据    801
    function creatCallBack(data)
        self.legionData:setResultData(data, CREATE_LEGION)
    end

    self:registerNetMsg(CREATE_LEGION, "GuildCommonResponse", creatCallBack)

    --申请加入军团    802
    function applyCallBack(data)
        self.legionData:setJoinResponseData(data)
    end

    self:registerNetMsg(JOIN_LEGION, "JoinGuildResponse", applyCallBack)

    --退出军团  803
    function exitLegionCallBack(data)
        self.legionData:setResultData(data, EXIT_LEGION)
        local _data = {result = false}
        self.legionData:setLegionInfo(_data)
    end

    self:registerNetMsg(EXIT_LEGION, "GuildCommonResponse", exitLegionCallBack)

    --编辑公告  804
    function editAnounceCallBack(data)
        print("编辑公告 ============== ")
        -- table.print(data)
        self.legionData:setResultData(data, EDIT_ANNOUNCEMENT)
    end
    self:registerNetMsg(EDIT_ANNOUNCEMENT, "GuildCommonResponse", editAnounceCallBack)

    --处理加入军团申请  805
    function dealApplyCallBack(data)
        self.legionData:setResultData(data, DEALI_JOIN_APPLY)
    end
    self:registerNetMsg(DEALI_JOIN_APPLY, "DealApplyResponse", dealApplyCallBack)

    --转让军团  806
    function transferApplyCallBack(data)
        print("转让返回数据 ================== ")
        -- table.print(data)
        self.legionData:setResultData(data, TRANSFER_LEGION)
    end
    self:registerNetMsg(TRANSFER_LEGION, "GuildCommonResponse", transferApplyCallBack)

    --踢出军团  807
    function killOutLegionCallBack(data)
        self.legionData:setResultData(data, KILL_OUT)
    end
    self:registerNetMsg(KILL_OUT, "GuildCommonResponse", killOutLegionCallBack)

    --晋升职位  808
    function promotionCallBack(data)
        self.legionData:setResultData(data, LEGION_PROMOTION)
    end
    self:registerNetMsg(LEGION_PROMOTION, "PromotionResponse", promotionCallBack)

    --膜拜  809
    function worshipCallBack(data)
        print("worship =============== ")
        -- table.print(data)
        self.legionData:setResultData(data, LEGION_WORSHIP)
    end
    self:registerNetMsg(LEGION_WORSHIP, "GuildCommonResponse", worshipCallBack)

    --获取军团排行返回数据    810
    function getRankListCallBack(data)
        self.legionData:setRankList(data)
    end

    self:registerNetMsg(GET_RANK_LIST, "GuildRankProto", getRankListCallBack)

    --获取成员玩家列表     811
    function getMemberListCallBack(data)
        self.legionData:setMemberList(data)
        -- table.print(data)
    end

    self:registerNetMsg(GET_MEMBER_LIST, "GuildRoleListProto", getMemberListCallBack)

    --获取公会信息   812
    function getLegionInfoCallBack(data)
        table.remove(g_netResponselist)
        self.legionData:setLegionInfo(data)
        -- table.print(data)
    end

    self:registerNetMsg(PLAYER_GET_LEGION_INFO, "GuildInfoProto", getLegionInfoCallBack)

    --获取加入公会申请列表   813
    function getApplyListCallBack(data)
        self.legionData:setApplyList(data)
    end

    self:registerNetMsg(GET_APPLY_LIST, "ApplyListProto", getApplyListCallBack)

    --获取被踢出的通知  814
    function getKillTipCallBack(data)
    end

    self:registerNetMsg(GET_KILL_OUT_TIP, "", getKillTipCallBack)

    --获取有申请军团的通知  850
    function getApplyCallBack(data)
        -- self.legionData:setApplyList(data)
    end

    self:registerNetMsg(GET_APPLY_LIST_NOTICE, "", getApplyCallBack)

    --获取邀请加入军团结果
    function getInviteCallBack(data)
        print("服务器返回 ========= ", INVITE_JOIN_LEGION)
    end

    self:registerNetMsg(INVITE_JOIN_LEGION, "InviteJoinResponse", getInviteCallBack)

    --获取处理邀请加入军团结果
    function getDealInviteCallBack(data)
        print("获取处理邀请加入军团结果 ========= ", DEAL_INVITE_JOIN_LEGION)
    end

    self:registerNetMsg(DEAL_INVITE_JOIN_LEGION, "DealInviteJoinResResponse", getDealInviteCallBack)
end

return LegionNet
