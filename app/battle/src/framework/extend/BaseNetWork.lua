--网络模块继承类
BaseNetWork = class("BaseNetWork")

function BaseNetWork:ctor(id)
    self._name = id
    self.protobufTable = {}
    self.netWorkTable = {}
    self.dataProcessor = getDataProcessor()
    self.mySocket = getNetManager():getSocket()
end

--添加pbName
function BaseNetWork:pushPbName(_name)
   local fullName = "res/pb/" .. _name .. ".pb"
        protobuf.register_file(cc.FileUtils:getInstance():fullPathForFilename(fullName))
end

--发送协议都调用此方法
function BaseNetWork:sendMsg(comid, encodeWhat, data, isShowLoading)
    cclog("net:__Message:sendMsg——name:" .. self._name)
    self.mySocket:sendMsg(comid, encodeWhat, data, isShowLoading)
    self.dataProcessor:pushNetData(comid, data)
end


--注册网络接受协议
function BaseNetWork:registerNetMsg(comid, decodeWhat, callback)

    self.mySocket:registerCallback(comid, decodeWhat, callback)
end

function BaseNetWork:needPreSendMsg()
    if self.preSend ~= nil then
    self:preSend()
    end
end

