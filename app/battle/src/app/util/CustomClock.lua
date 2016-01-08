--@module CustomClock
--[[--
-- 功能: 计时器
-- 作者: 肖寒
-- 时间: 2015-6-6
]]
local CustomClock = class("CustomClock")

function CustomClock:ctor(interval)
	self.interval_ = interval or 0
	self.current = self.interval_
	self.paused = false
end
--[[--
倒计时
@param float dt 时间差
]]
function CustomClock:countDown(dt)
	if self.paused then return false end
	self.current = self.current - dt
	if self.current < 0 then
		self.current = 0
	end
	return self.current == 0
end
--[[--
设置暂停
]]
function CustomClock:setPaused(paused)
	self.paused = paused
end
--[[--
重置时间
]]
function CustomClock:reset()
	self.current = self.interval_	
end
--[[--
设置倒计时时间
]]
function CustomClock:setInterval(interval)
	self.interval_ = interval
end

return CustomClock