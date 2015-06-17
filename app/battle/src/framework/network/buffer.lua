
net = net or {}

net.Buffer = class("Buffer")

function net.Buffer:ctor()
    self.recvdata = ""
    self.recvtime = 0
    self.recvcb = nil
end

function net.Buffer:recv(data)
    if #self.recvdata > 0 then
        if socket.gettime() - self.recvtime > 3 then
            self.recvdata = ""
            self:unpack(data)
        else
            self:unpack(self.recvdata .. data)
        end
    else
        self:unpack(data)
    end

    self.recvtime = socket.gettime()
end

-- function net.Buffer:valid(head0, head1, head2, head3, pver, sver, len, comid)
--     return true
-- end

-- function net.Buffer:pack(comid, frame)
--     print("net.Buffer:pack(comid, frame)")
--     print(frame)
--     local len
--     if frame == nil then
--         frame = ""
--     end

--     local pack  = string.pack(">bbbbbIIIA", 0, 0, 0, 0, 0, 0, string.len(frame)+4, comid, frame)
--     print("pack length = ",string.len(pack))
--     return pack
-- end

function net.Buffer:pack(comid, buffer)
    local len
    if buffer == nil then
        buffer = ""
    end

    local pack  = string.pack(">bbbbbIIIA", 0, 0, 0, 0, 0, 0, string.len(buffer)+4, comid, buffer)
    return pack
end

--返回command id data的长度,protobuf decode前data的内容
function net.Buffer:unpack(data)
    local idx, head0, head1, head2, head3, pver, sver,len,comid  = string.unpack(data, ">bbbbbIIIA")
    cclog("head:%s %s %s %s %s %s %s %s %s", idx, head0, head1, head2, head3, pver, sver, len,comid)
    return comid, len, string.sub(data, 18, 18+ len - 4 -1)
end

--在这里比对 len是否为data部分的长度
function net.Buffer:check(data)
    local ret = false
    local _ , len,rawData= self:unpack(data)
    if  #rawData == len - 4 then
        ret = true
    end
    return ret
end

-- function net.Buffer:unpack(data)
--     if #data < 17 then
--         self.recvdata = data
--         return
--     end

--     local idx, head0, head1, head2, head3, pver, sver,comid,len = string.unpack(data, ">bbbbbIIIA")
--     cclog("head:%s %s %s %s %s %s %s %s %s", idx, head0, head1, head2, head3, pver, sver, len,comid)

--     if not self:valid(head0, head1, head2, head3, pver, sver, comid, len) then
--         self.recvdata = ""
--         return
--     end

--     --Message:receiveMsg(comid,string.sub(data, 18))
--     --print("**********")
--     --print(string.sub(data, 18+len))
--     --print(data)
--     --print(#data)
--     --print(17 + len - 4)
--     --if #data == 17 + len - 4 then
--     if #data == 17 + len - 4 then
--         self.recvdata = ""
--         -- Message:receiveMsg(comid,string.sub(data, 18))
--         --return comid,string.sub(data, 18)
--         --self:frame(comid, string.sub(data, 18))
--     elseif #data > 17 + len - 4  then
--         self.recvdata = string.sub(data, 18 + len)

--         print("xxxxxxoooooxxxxxooooo",self.recvdata)
--         --self:frame(comid, string.sub(data, 18, 17 + len))
--         --return comid,string.sub(data, 18, 17 + len)
--         --Message:receiveMsg(comid,string.sub(data, 18, 17 + len))
--     else
--         self.recvdata = data
--     end
-- end

function net.Buffer:frame(comid, frame)
    if self.recvcb then self.recvcb(comid, frame) end
end

function net.Buffer:regRecv(cb)
    self.recvcb = cb
end
