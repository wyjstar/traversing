CHECK_INFO = 706

ChatNet = class("ChatNet", BaseNetWork)

function ChatNet:ctor()
    self.super.ctor(self, "ChatNet")
    self:init()
end

function ChatNet:init()
    self.chatData = getDataManager():getChatData()
    self.worldChatItems = {}
    self.legionChatItems = {}
    self:registerChatCallBack()
end

--发送聊天
function ChatNet:sendWords(role, type, words, cur_guild_id, vipLevel)
    local data = nil

    if cur_guild_id == nil then
        data =
                {
                    owner = role,
                    channel = type,
                    content = words,
                    vip_level = vipLevel
                }
    else
        data =
                {
                    owner = role,
                    channel = type,
                    content = words,
                    guild_id = cur_guild_id,
                    vip_level = vipLevel
                }
    end
    print("发送聊天信息 =========== sendWords =========== ")
    table.print(data)
    self:sendMsg(CHAT_SEND, "ChatConectingRequest", data, false)
end

--发送查看信息界面
function ChatNet:sendCheckInfo(cur_hero_id)
    local data = { target_id = cur_hero_id }
    self:sendMsg(CHECK_INFO, "GetLineUpRequest", data)
end

function ChatNet:registerChatCallBack()
    --发送是否成功返回
    local function sendCallBack(data)
        print("说话之后返回 ========================== ")
        table.print(data)
        self.chatData:setData(data)
    end
    self:registerNetMsg(CHAT_SEND, "ChatResponse", sendCallBack)

    --服务器推送的消息列表
    local function getListCallBack(data)
        -- table.print(data)
        if data.channel == 1 then
            table.insert(self.worldChatItems, data)
            self.chatData:setChatWords(self.worldChatItems, 1)
        elseif data.channel == 2 then
            table.insert(self.legionChatItems, data)
            self.chatData:setChatWords(self.legionChatItems, 2)
        end
        self.chatData:setWordsData(data)
    end
    self:registerNetMsg(CHAT_SYSTEM, "chatMessageResponse", getListCallBack)

    --战队信息查看
    local function checkInfoCallBack(data)
        print("聊天查看返回 ==== ========= ", data)
        table.print(data)
        local c_arenaData = getDataManager():getArenaData()
        c_arenaData:setRankCheckInfo(data.slot)
        c_arenaData:setOtherPlayerLineUp(data)
    end

    self:registerNetMsg(CHECK_INFO, "LineUpResponse", checkInfoCallBack)
end

return ChatNet
