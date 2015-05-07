CHAT_SEND = 1002
CHAT_SYSTEM = 1000

--背包相关数据
local ChatData = class("ChatData")


function ChatData:ctor()
    self.sendResultData = {}        --发送返回结果数据
    self.wordListData = {}          --消息列表
    self.worldContents = {}         --世界消息缓存
    self.legionContents = {}         --世界消息缓存
end

--发送返回数据初始化(请求返回时调用)
function ChatData:setData(data)
    self.sendResultData = data
end

--获取数据(客户端获取返回数据)
function ChatData:getData()
    if self.sendResultData ~= nil then
        return self.sendResultData
    else
        return nil
    end
end

--消息列表数据初始化
function ChatData:setWordsData(data)
    self.wordListData = data
end

--获取消息列表数据
function ChatData:getWordsData()
    if self.wordListData ~= nil then
        return self.wordListData
    else
        return nil
    end
end

--缓存世界聊天消息
function ChatData:setChatWords(wordList, chat_type)
    if chat_type == 1 then
        self.worldContents = wordList
    else
        self.legionContents = wordList
    end
end

--获取世界聊天缓存消息
function ChatData:getChatWords(chat_type)
    if chat_type == 1 then
        return self.worldContents
    else
        return self.legionContents
    end
end

--缓存军团聊天消息
function ChatData:setLegionWords()
    -- body
end

--获取军团聊天缓存消息
function ChatData:getLegionWords()
    -- body
end

function ChatData:onMVCEnter()

end

return ChatData
