
local LegionData = class("LegionData")

function LegionData:ctor()
    self.responseData = {}
    self.joinResponseData = {}
    self.rankList = {}              --军团排行列表
    self.memberList = {}            --成员玩家列表
    self.legionInfo = {}            --公会信息
    self.applyList = {}             --申请加入公会列表

    self.position = nil
    self.myPosition = nil



    self.legionExp = 0            --守护经验
    self.anouncement = nil          --军团公告
    self.transferId = nil
    self.legionNum = 0            --军团成员数量
    self.legionMoney = 0          --军团资金
end

--服务端协议返回数据初始化
function LegionData:setResultData(data, type)
    self.responseData = data
end

--客户端获取服务端返回数据
function LegionData:getLegionResultData()
    if self.responseData ~= nil then
        return self.responseData
    else
        return nil
    end
end

--服务端返回申请加入公会数据
function LegionData:setJoinResponseData(data)
    self.joinResponseData = data
end

--客户端获取服务端返回数据
function LegionData:getJoinResponseData()
    if self.joinResponseData ~= nil then
        return self.joinResponseData
    else
        return nil
    end
end

--服务端协议返回，军团排行对应数据初始化   810
function LegionData:setRankList(data)
    self.rankList = data.guild_rank     --排行列表
end

--客户端获取军团排行列表   810
function LegionData:getRankList()
    table.nums(self.rankList)
    if self.rankList ~= nil then
        return self.rankList
    else
        return nil
    end
end

--服务端协议返回，成员列表数据初始化    811
function LegionData:setMemberList(data)
    self.memberList = data.role_info
    self.commonData = getDataManager():getCommonData()
    self.my_id = self.commonData:getAccountId()
    local my_position = nil
    for k,v in pairs(self.memberList) do
        if self.my_id == v.p_id then
            my_position = v.position
        end
    end
    self:setPositionById(self.my_id, my_position)
end

--客户端获取成员玩家列表   811
function LegionData:getMemberList()
    if self.memberList ~= nil then
        return self.memberList
    else
        return nil
    end
end

--服务端协议返回，公会信息初始化   812
function LegionData:setLegionInfo(data)
    print("set----")
    local lineupData = getDataManager():getLineupData()
    if data.result == false then
        self.legionInfo = nil
        lineupData:setLegionLevel(0)
    else
        self.legionInfo = data.guild_info
        self:setLegionPosition(self.legionInfo.my_position)
        lineupData:setLegionLevel(self.legionInfo.level)
    end
end

--获得公会等级
function LegionData:getLegionLevel()
    if self.legionInfo ~= nil then
        if self.legionInfo == nil then
            return nil
        end
        return self.legionInfo.level
    end

end

--客户端获取公会信息     812
function LegionData:getLegionInfo()
    print("get----")
    if self.legionInfo ~= nil then
        return self.legionInfo
    else
        return nil
    end
end

--服务端协议返回,申请加入公会列表  813
function LegionData:setApplyList(data)
    print("申请列表 -=  ================ ")
    -- table.print(data)
    self.applyList = data.role_info
end

--客户端获取加入公会列表   813
function LegionData:getApplyList()
    if self.applyList ~= nil then
        -- table.print(self.applyList)
        return self.applyList
    else
        return nil
    end
end

--玩家自己的职位
function LegionData:setLegionPosition(my_position)
    self.myPosition =  my_position
end

--玩家自己的职位获取
function LegionData:getLegionPosition()
    if self.myPosition ~= nil then
        return self.myPosition
    else
        return nil
    end
end

--玩家职位初始化
function LegionData:setPositionById(cur_id, cur_position)
    if self.memberList ~= nil then
        for k,v in pairs(self.memberList) do
            if cur_id == v.p_id then
                v.position = cur_position
                self.position =cur_position
            end
        end
    end
end

--玩家职位获取
function LegionData:getPositionById()
    if self.position ~= nil then
        return self.position
    else
        return nil
    end
end

--膜拜获取的资金和经验值
function LegionData:setWorshipData(gain_money, gain_exp)
    self.legionMoney = self.legionMoney + gain_money
    self.legionExp = self.legionExp + gain_exp
end

--公告重新编辑
function LegionData:setAnouncement(content)
    self.anouncement = content
end

--公告内容获取
function LegionData:getAnouncement()
    if self.anouncement ~= nil then
        return self.anouncement
    else
        return nil
    end
end

--军团成员数量变更
function LegionData:updateMemberNum(changeNum, type)
    if self.legionInfo ~= nil then
        if type == 1 then
            -- table.print(self.legionInfo)
            self.legionInfo.p_num = self.legionInfo.p_num + changeNum
        elseif type == 2 then
            -- table.print(self.legionInfo)
            self.legionInfo.p_num = self.legionInfo.p_num - changeNum
        end
    end
end

--设置转让的目标
function LegionData:setTransferId(cur_id)
    self.transferId = cur_id
end

function LegionData:getTransferId()
    if self.transferId ~= nil then
        return self.transferId
    else
        return nil
    end
end


--设置当前的军团成员数量
function LegionData:setLegionNum(change_num, type)
    --type 1 军团成员增加  type  2  军团成员减少
    if type == 1 then
        self.legionNum = self.legionNum + change_num
    elseif type == 2 then
        self.legionNum = self.legionNum - change_num
    end
end

return LegionData
