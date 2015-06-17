
local FriendData = class("FriendData")

function FriendData:ctor()
    self.listData = {}
    self.CommonResponseData = {}
    self.FindFriendResponseData = {}
    self.TempFriendInfoData = {} -- 作为临时数据存放
end

function FriendData:setFindFriendResponseData(data)
    if table.nums(self.FindFriendResponseData) > 0 then
    	self.FindFriendResponseData = {}
    end
    self.FindFriendResponseData = data
end

function FriendData:getFindFriendResponseData()

    return self.FindFriendResponseData
end

function FriendData:setCommonResponseData(data)
    -- #注释了，在返回的data为false时，会有问题@jiang
    -- if table.nums(self.CommonResponseData) > 0 then
    -- 	self.CommonResponseData = {}
    -- end
    self.CommonResponseData = data
end

function FriendData:addFriend()
	-- body
end

function FriendData:getCommonResponseData()

    return self.CommonResponseData
end


function FriendData:setListData(data)
    self.listData = data

    -- 过滤掉自己和ID为零的
    local _accountId = getDataManager():getCommonData():getAccountId()
    for k,v in pairs(self.listData.friends) do
        if v.id == 0 or _accountId == v.id then
            table.remove(self.listData.friends, k)
        end
    end
end


function FriendData:getListData()
    return self.listData
end

function FriendData:setTempFriendInfoData(data)
    self.TempFriendInfoData = data
end


function FriendData:getTempFriendInfoData()

    return self.TempFriendInfoData
end

function FriendData:clearTempFriendInfoData()

    self.TempFriendInfoData = {}
end
--判断是否已经是自己的好友
function FriendData:isExistsInFriend(friendId)
    local friends = self.listData.friends
    if friends ~= nil then
        for k, v in pairs(friends) do
            if v.id == friendId then
                return true
            end
        end

        return false
    end
end
function FriendData:clearData()
    -- self.listData = {}
    -- self.CommonResponseData = {}
    -- self.FindFriendResponseData = {}
    -- self.TempFriendInfoData = {}
end


return FriendData
