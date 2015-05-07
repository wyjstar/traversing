--[[
For quick-cocos2d-x
SocketTCP lua
@author zrong (zengrong.net)
Creation: 2013-11-12
Last Modification: 2013-12-05
@see http://cn.quick-x.com/?topic=quickkydsocketfzl
]]
local SOCKET_TICK_TIME = 0.1 			-- check socket data interval
local SOCKET_RECONNECT_TIME = 5			-- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 10	-- socket failure timeout

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"


SocketTCP = class("SocketTCP")
local socket = require ('socket.core')

import("...framework.network.EventProtocol").extend(SocketTCP)
SocketTCP.EVENT_DATA = "SOCKET_TCP_DATA"
SocketTCP.EVENT_CLOSE = "SOCKET_TCP_CLOSE"
SocketTCP.EVENT_CLOSED = "SOCKET_TCP_CLOSED"
SocketTCP.EVENT_CONNECTED = "SOCKET_TCP_CONNECTED"
SocketTCP.EVENT_CONNECT_FAILURE = "SOCKET_TCP_CONNECT_FAILURE"
SocketTCP.EVENT_CONNECT_TIMEOUT = "SOCKET_TCP_CONNECT_TIMEOUT"

SocketTCP._VERSION = socket._VERSION
SocketTCP._DEBUG = socket._DEBUG

function SocketTCP.getTime()
	return socket.gettime()
end

function SocketTCP:ctor(__host, __port, __retryConnectWhenFailure)

	--self:addComponent(".EventProtocol"):exportMethods()

    	self.host = __host
    	self.port = __port
	self.tickScheduler = nil			-- timer for data
	self.reconnectScheduler = nil		-- timer for reconnect
	self.connectTimeTickScheduler = nil	-- timer for connect timeout
	self.name = 'SocketTCP'
	self.tcp = nil
	self.isRetryConnect = __retryConnectWhenFailure
	self.isConnected = false
	self.isFirstConnect = true
end

function SocketTCP:setName( __name )
	self.name = __name
	return self
end

function SocketTCP:setTickTime(__time)
	SOCKET_TICK_TIME = __time
	return self
end

function SocketTCP:setReconnTime(__time)
	SOCKET_RECONNECT_TIME = __time
	return self
end

function SocketTCP:setConnFailTime(__time)
	SOCKET_CONNECT_FAIL_TIMEOUT = __time
	return self
end

function SocketTCP:connect(__host, __port, __retryConnectWhenFailure)
	if __host then self.host = __host end
	if __port then self.port = __port end
	if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
	assert(self.host or self.port, "Host and port are necessary!")
	cclog("net:__________%s.connect(%s, %d)", self.name, self.host, self.port)
	self.tcp = socket.tcp()
	self.tcp:settimeout(0)

	local function __checkConnect()
		local __succ = self:_connect()
		if __succ then
			self:_onConnected()
		end
		return __succ
	end
	cclog("net:__________try_to_connect_net")
	if not __checkConnect() then
		cclog("net:________first_connect_failed")
		-- check whether connection is success
		-- the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
		local __connectTimeTick = function ()

			if self.isConnected then return end
			self.waitConnect = self.waitConnect or 0
			self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
			if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
				print("________self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT")
				self.waitConnect = nil
				self:close()
				self:_connectFailure()
			end
			__checkConnect()
		end
		cclog("net:___________try_to_connect_net___again")
		self.connectTimeTickScheduler = timer.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)
	end
end

function SocketTCP:send(__data)
	--assert(self.isConnected, self.name .. " is not connected.")
	if self.isConnected == true then
	    self.tcp:send(__data)
	    cclog("net:______tcp:send")
	else
		self:close()
		self:_connectFailure(__data)
		
	     cclog("socket not connect success when send")
	end
end

function SocketTCP:close( ... )
	cclog("%s.close", self.name)
	self.tcp:close()
	if self.connectTimeTickScheduler then timer.unscheduleGlobal(self.connectTimeTickScheduler) end
	if self.tickScheduler then timer.unscheduleGlobal(self.tickScheduler) end
	-- self:dispatchEvent({name=SocketTCP.EVENT_CLOSE})
end

-- disconnect on user's own initiative.
function SocketTCP:disconnect()
	self:_disconnect()
	self.isRetryConnect = false -- initiative to disconnect, no reconnect.
end


function SocketTCP:_connect()
	print("_connect")
	cclog("host:" .. self.host)
	cclog("post:" .. self.port)
	
	local __succ, __status = self.tcp:connect(self.host, self.port)
	--local __succ, __status = socket:connect(self.host, self.port)
	--cclog("SocketTCP._connect:%s,%s", __succ, __status)
	return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end

function SocketTCP:_disconnect()
	self.isConnected = false
	self.tcp:shutdown()
	self:dispatchEvent({name=SocketTCP.EVENT_CLOSED})
end

function SocketTCP:_onDisconnect()
	cclog("%s._onDisConnect", self.name)
	self.isConnected = false
	-- self:dispatchEvent({name=SocketTCP.EVENT_CLOSED})
	self:_reconnect(true)
end

-- connecte success, cancel the connection timerout timer
function SocketTCP:_onConnected()
	cclog("%s._onConnectd_success", self.name)
	if self.connectTimeTickScheduler then timer.unscheduleGlobal(self.connectTimeTickScheduler) end
	print(self.isConnected)
	if self.isConnected then return end
	self.isConnected = true
	self.isFirstConnect = false
	self:dispatchEvent({name=SocketTCP.EVENT_CONNECTED})

	local __tick = function()
		while true do
			-- if use "*l" pattern, some buffer will be discarded, why?
			local __body, __status, __partial = self.tcp:receive("*a")	-- read the package body
			--print("body:", __body, "__status:", __status, "__partial:", __partial)
    	    if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
		    	self:close()
		    	self.isConnected = false
		    	if self.isConnected then
		    		self:_onDisconnect()
		    	else
		    		self:_connectFailure()
		    	end
		   		return
	    	end
		    if 	(__body and string.len(__body) == 0) or
				(__partial and string.len(__partial) == 0)
			then return end
			if __body and __partial then __body = __body .. __partial end
			self:dispatchEvent({name=SocketTCP.EVENT_DATA, data=(__partial or __body), partial=__partial, body=__body})
		end
	end

	-- start to read TCP data
	self.tickScheduler = timer.scheduleGlobal(__tick, SOCKET_TICK_TIME)
end

function SocketTCP:_connectFailure(data_)
	print(self.isFirstConnect)
	if self.isFirstConnect then
		-- 连接超时 是否重连
		self:dispatchEvent({name=SocketTCP.EVENT_CONNECT_TIMEOUT})	
	else
		self:dispatchEvent({name=SocketTCP.EVENT_CONNECT_FAILURE, data=data_})
	end
	-- self:_reconnect();
end

function SocketTCP:_reconnect(__immediately)
	if not self.isRetryConnect then return end
	if __immediately then self:connect() return end
	if self.reconnectScheduler then timer.unscheduleGlobal(self.reconnectScheduler) end
	local __doReConnect = function ()
		self:connect()
	end
	self.reconnectScheduler = timer.delayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
end

-- 重连
function SocketTCP:reconnect()
	
	self:_onDisconnect()
	
end

return SocketTCP
