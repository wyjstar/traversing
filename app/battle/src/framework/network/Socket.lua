
local SocketTCP = import(".SocketTCP")

local Socket = Socket or class("Socket")

--pb文件
local pbPath = "res/pb/traversing_one.pb"
-- 检测发送协议时间间隔
local SEND_SOCKET_TICK_TIME = 0.5  
-- 检测发送协议时间超时
local SEND_SOCKET_SEND_PROTO_TIMEOUT = 15   

local RECV_SOCKET_HEARTBEAT_TIME = 35.0         

function Socket:ctor()
    self.ip = nil
    self.port = nil
    self.delegate = nil --netCenter
    self.sendTotalTime = 0.0
    self.recvHeartBeatCheck = nil
    self.receiveTable = {}
end

function Socket:setDelegate(delegate)
    self.delegate = delegate
end

function Socket:connect(ip, port)
    print("socket.getTime:",SocketTCP.getTime())
    print("os.gettime:", os.time())
    print("socket._VERSION:", SocketTCP._VERSION)

    if nil == ip or nil == port then
        return
    end

    self.ip = ip   
    self.port = port  

    if not self._socket then
        self._socket = SocketTCP.new(self.ip,self.port, true)
        self._socket:addEventListener(SocketTCP.EVENT_CONNECTED,handler(self,self.onStatus))
        self._socket:addEventListener(SocketTCP.EVENT_CLOSE, handler(self,self.onStatus))
        self._socket:addEventListener(SocketTCP.EVENT_CLOSED, handler(self,self.onStatus))
        self._socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
        self._socket:addEventListener(SocketTCP.EVENT_CONNECT_TIMEOUT, handler(self,self.onStatus))
        self._socket:addEventListener(SocketTCP.EVENT_DATA, handler(self,self.onReceiveMsg))
    end
    -- 发送回调保存表 对应send
    --self.receiveTable = {code = "AccountInfo",callbacks = {}}
    --回应回调保存表 对应receive

    self:registerPb(pbPath)
    self._buf = net.Buffer.new()
    self.status = nil;
    self._socket:connect()
end


--注册传输协议的规则
function Socket:registerPb(pbPath)
    local buffer = {}
    local addr = io.open(cc.FileUtils:getInstance():fullPathForFilename(pbPath),"rb")

    if addr then
        buffer = addr:read "*a"

        addr:close()

    else
        buffer = cc.FileUtils:getInstance():getStringFromFile(pbPath)
    end
   
    protobuf.register(buffer)
end

--注册协议号对应的callback函数
--decodeWhat对应proto文件中相关的结构名称
--callback 回调函数
function Socket:registerCallback(comid, decodeWhat, callback)
    if self.receiveTable[comid] == nil then
        self.receiveTable[comid] = {}
    end

    self.receiveTable[comid].code = decodeWhat

    if self.receiveTable[comid].callbacks == nil then
        self.receiveTable[comid].callbacks = {}
    end

    table.insert(self.receiveTable[comid].callbacks,callback)
end


--注销协议号对应的callback函数
function Socket:unregisterCallback(comid)
    table.remove(self.receiveTable,comid)
end

function Socket:_packBuffer(comid, encodeWhat, data)
    local buffer = nil
    if encodeWhat ~= nil then
        buffer = protobuf.encode(encodeWhat,data)
    end
    
    sendData = self._buf:pack(comid, buffer)
    return sendData
end

-- return true 代表已经连接
-- false为非连接状态
function Socket:onStatus(__event)
    self.status = __event.name

    print("Network "..__event.name)

    if SocketTCP.EVENT_CONNECTED == __event.name or SocketTCP.EVENT_DATA == __event.name then
        print("Network is connected")

        if self.delegate ~= nil then
            self.delegate:onConnectSuccess()
        end
        
        ret = true
    elseif SocketTCP.SOCKET_TCP_CLOSE == __event.name then
        print("Network _disconnected ")
    elseif SocketTCP.EVENT_CONNECT_TIMEOUT == __event.name then
        if self.delegate ~= nil then
            -- 连接超时是否重连
            self.delegate:onReconnect()
        end
    else 
        print("Network connect failed")

        if self.delegate ~= nil then
            self.delegate:onConnectFailed(__event.data)
        end

        ret = false
    end
    return ret
end

--在这里做分发
--13 + len 为当前数据包包含包头的总长度
-- function Socket:onReceiveMsg(__event)

--     -- 关闭协议发送的检测
--      self:closeSendTimeScheduler()

--     local totalLen = #__event.data
--     print("socket total len:", totalLen)
--     if totalLen < 17 then return end
--     local idx = 1
--     local comid = 0
--     local data = nil
--     local buff = __event.data
--     local _, len, packet = self._buf:unpack(buff)
--     if len - 4 > #packet then return end        
    
--     repeat                                                    
--         buff = string.sub(__event.data,idx,idx + len + 12)        
--         comid,len,packet = self._buf:unpack(buff)        
--         self:mapping(comid,packet)
--         idx = idx + len + 13
--         print (idx, "__onReceiveMsg____idx", totalLen)
--         if idx-1 ~= totalLen then
--             local _, tlen, _ = self._buf:unpack(string.sub(__event.data,idx,totalLen))
--             len = tlen
--         end
--     until idx > totalLen
-- end


buff_pool = buff_pool or ""
--在这里做分发
--13 + len 为当前数据包包含包头的总长度
function Socket:onReceiveMsg(__event)
    cclog("onReceiveMsg__________")
    -- 关闭协议发送的检测
    self:closeSendTimeScheduler()
    buff_pool = buff_pool..__event.data

    local buff_len = #buff_pool
    -- print(buff_len.."---".."loop++++++++")
    
    repeat
        if buff_len < 17 then return end                  
        local comid,len,packet = self._buf:unpack(buff_pool)
        if buff_len < 17 + len - 4 then return end
        -- print(buff_len.."-- -"..(17+len).."loop++++++++"..string.len(packet))
        self:mapping(comid, packet)        

        buff_pool = string.sub(buff_pool, len + 18 -4)
        buff_len = #buff_pool
    until false
end

function Socket:mapping(comid,buff)
    -- local __check = function()
    --     self._socket:_reconnect(true)
    -- end

    -- if comid == 88 then 
    --     cclog("88 received :" .. buff)
    --     if self.recvHeartBeatCheck == nil then
    --         self.recvHeartBeatCheck = timer.scheduleGlobal(__check, RECV_SOCKET_HEARTBEAT_TIME)
    --     end
    --  end

    local protocol = self.receiveTable[comid]

    if not protocol then return end
    local t = protobuf.decode(protocol.code,buff)
    -- if comid == 1400 then
    --     print("------mapping---",t)
    --     table.print(t.days)
    --     table.print(t["days"])
    --     cclog("-------------------")

    --     print(getmetatable(t))
    --     table.print(getmetatable(t))
    --     cclog("-------------------")
    --     table.print(t)
    --     for k,v in pairs(t) do
    --         print(k, v, "---------")
    --     end
    -- end
    for _,callback in pairs(protocol.callbacks) do
        callback(t)
    end 
    
    -- self:unregisterCallback(comid)
    self.delegate:onReceiveMsg(comid, t)
    cclog("onReceiveMsg__________comid===" .. comid)
end

function Socket:reSend(data)
    cclog("net:___Socket:reSend=================>")
    self._socket:send(data)
end

function Socket:sendMsg(comid,encodeWhat,data, isShowLoading)
    if self.delegate and (isShowLoading == nil or isShowLoading==true) then
        self.delegate:onNetLoading()
    end

    if not self._socket then
        return
    end
    
    cclog("net:___Socket:sendMsg==comid:%d", comid)
    local sendData = self:_packBuffer(comid,encodeWhat,data)
    cclog("Socket:sendMsg() --> sendBuffer len = ",string.len(sendData))
    self._socket:send(sendData)

    -- -- 检测协议发送时间
    self:closeSendTimeScheduler()

    local __sendTimeTick = function ()
        self.sendTotalTime = self.sendTotalTime + SEND_SOCKET_TICK_TIME
        if self.sendTotalTime >= SEND_SOCKET_SEND_PROTO_TIMEOUT then
            self:closeSendTimeScheduler()
            self._socket:close()
            self._socket.isConnected = false
            self._socket:_connectFailure()
        end
    end

    self.sendTimeTickScheduler = timer.scheduleGlobal(__sendTimeTick, SEND_SOCKET_TICK_TIME)
end

-- 关闭协议发送的检测
function Socket:closeSendTimeScheduler()
    if self.sendTimeTickScheduler then 
        timer.unscheduleGlobal(self.sendTimeTickScheduler) 
    end
     self.sendTotalTime = 0.0
end

-- 关闭连接
function Socket:closeConnect()
    self._socket:close()
    -- print("--Socket:closeConnect--")
    self._socket:removeAllEventListeners()
    self.receiveTable = {}
    self:closeSendTimeScheduler()
    self._socket = nil
    protobuf.clear()
end

-- 重连
function Socket:reconnect()
    
    self._socket:reconnect()
end

return Socket
