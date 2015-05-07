
mvc = mvc or {}

mvc.ViewBase = class("ViewBase", function()
    return game.newNode()
end)

function mvc.ViewBase:ctor(id)
    self.id = id
end

function mvc.ViewBase:onAddByCtrl(ctrl)
    self.myctrl = ctrl
end

function mvc.ViewBase:onRemoveByCtrl(ctrl)
    self.myctrl = nil
end

function mvc.ViewBase:addSubView(view)
	self.myctrl:addView(view)
	self:addChild(view)	
end

function mvc.ViewBase:listenEvent(name, func, data)
    self.myctrl.events:listen(name, func, self, data)
end

function mvc.ViewBase:dispatchEvent(name, ...)
    self.myctrl.events:dispatch(name, ...)
end

function mvc.ViewBase:collectData(no, ...)
    return self.myctrl.collect:onCollect(no, ...)
end

function mvc.ViewBase:clearEvent()
	self.myctrl.events:clear()
end

function mvc.ViewBase:onMVCEnter()
end

function mvc.ViewBase:onMVCExit()
end