ACTIVE_TASK_LIST = 1234
ACTIVE_RECEIVE_REWARD = 1235

ActiveDegreeNet = class("ActiveDegreeNet", BaseNetWork)

function ActiveDegreeNet:ctor()
    self.super.ctor(self, "ActiveDegreeNet")
    self:init()
end

function ActiveDegreeNet:init()
    self.c_activeData = getDataManager():getActiveData()
    self:registerChatCallBack()
end

------=======发送协议=======------

--活跃度数据请求
function ActiveDegreeNet:sendGetTaskList()
    self:sendMsg(ACTIVE_TASK_LIST)
end

--请求领取奖励
function ActiveDegreeNet:sendGetReward(taskId)
    local data = { tid = taskId }
    
    table.print(data)

    self:sendMsg(ACTIVE_RECEIVE_REWARD, "rewardRequest", data)
end

------=======协议返回=======------

function ActiveDegreeNet:registerChatCallBack()
    --活跃度数据返回
    local function taskListCallBack(data)
        self.c_activeData:setActiveDegreeList(data.tasks)
    end

    self:registerNetMsg(ACTIVE_TASK_LIST, "TaskUpdate", taskListCallBack)

    --领取奖励返回
    local function rewardsCallBack(data)
        -- print("领取奖励之后返回 =============== ", data)
        -- table.print(data)
        -- for k,v in pairs(data) do
        --     -- table.print(v)
        -- end
        -- getDataManager():getBagData():setItemByOtherWay(data.items)
        -- getDataProcessor():gainGameResourcesResponse(data.gain)
    end

    self:registerNetMsg(ACTIVE_RECEIVE_REWARD, "rewardResponse", rewardsCallBack)
end

return ActiveDegreeNet
