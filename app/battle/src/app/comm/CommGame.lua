
local CommGame = class("CommGame")

CommGame.NO_LOGIN = 1

function CommGame:ctor()
    self.protocals = {}

    self.bufferGame = net.Buffer.new()
    self.socketGame = net.SocketTCP.new("127.0.0.1", 10000, self.bufferGame)

    self.bufferChat = net.Buffer.new()
    self.socketChat = net.SocketTCP.new("127.0.0.1", 20000, self.bufferChat)

    self.socketGame:regRecv(function(no, frame) self:recvMessage(no, frame) end)
    self.socketChat:regRecv(function(no, frame) self:recvMessage(no, frame) end)
end

function CommGame:init()
    local sharedFile = cc.FileUtils:getInstance()
    local s = nil

    s = sharedFile:getDataFromFile("res/pb/chat.pb")
    protobuf.register(s)

    self.protocals[self.NO_LOGIN] = {code = "proto_chat.ChatResponse", socket = self.self.socketChat, callbacks = {}}
end

function CommGame:regCallback(no, callback)
    table.insert(self.protocals[no].callbacks, callback)
end

function CommGame:sendMessage(no, message)
    local protocal = self.protocals[no]
    if not protocal then return end

    local frame = protobuf.encode(protocal.code, message)

    protocal.socket:send(no, frame)
end

function CommGame:recvMessage(no, frame)
    local protocal = self.protocals[no]
    if not protocal then return end

    local message = protobuf.decode(protocal.code, frame)

    for _, callback in pairs(protocal.callbacks) do
        callback(message)
    end
end

return CommGame