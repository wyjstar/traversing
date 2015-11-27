--@module CustomTask
--[[--
-- 功能: 定时任务器
-- 相关类: CustomTimer
-- 作者: 肖寒
-- 时间: 2015-06-06
]]
local CustomClock = import(".CustomClock")

local CustomTask = class("CustomTask")
--[[--
构造方法
@param CustomClock clock 计时器
@param function callback 回调方法
@param int count 执行次数
]]
function CustomTask:ctor(callback, interval, count)
	self.clock_ = CustomClock.new(interval)
	self.callback_ = callback
	self.count_ = count or -1
	self.curCount_ = self.count_
	self.paused_ = false
	self.enabled_ = true
	--保存通用数据对象，用于计算时差
	self.commonData = getDataManager():getCommonData()
	self.lastTime = self.commonData:getTime() --上次更新时间
	self.callTime = self.commonData:getTime() --上次回调时间
end
--[[--
获取更新时间差
]]
function CustomTask:getDiffTime()
	local cur = self.commonData:getTime()
	local dt = math.floor(cur - self.lastTime)
	self.lastTime = cur
	return dt
end
--[[--
获取回调时间差
]]
function CustomTask:getCallTimeDiff()
	local cur = self.commonData:getTime()
	local dt = math.floor(cur - self.callTime)
	self.callTime = cur
	return dt	
end
--[[--
倒计时
]]
function CustomTask:update(dt)
	if not self.enabled_ or self.paused_ then return end
	local dt_ = self:getDiffTime()
	if dt_ == 0 then return end
	if self.clock_:countDown(dt_) then

		if self.count_ ~= -1 then --永久
			self.curCount_ = self.curCount_ - 1
			if self.curCount_ == 0 then
				self.enabled_ = false
			end
		end

		if self.callback_ then
			self.callback_(self, self:getCallTimeDiff())
		end	
		self:reset()	
	end
end
--[[--
重置任务
]]
function CustomTask:reset()
	self.clock_:reset()
	self.curCount_ = self.count_
	self.paused_ = false
	self.enabled_ = true
	self.lastTime = self.commonData:getTime() --上次更新时间
	self.callTime = self.commonData:getTime() --上次回调时间	
end
--[[--
是否可用
]]
function CustomTask:isEnabled()
	return self.enabled_
end
--[[--
设置暂停
]]
function CustomTask:setPaused(paused)
	self.paused_ = paused
end
--[[--
设置可用
]]
function CustomTask:setEnabled(enabled)
	self.enabled_ = enabled
end


return CustomTask
