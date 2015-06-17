
mvc = mvc or {}

mvc.ModelBase = class("ModelBase")

function mvc.ModelBase:ctor(id)
    self.id = id
end

function mvc.ModelBase:onAddByCtrl(ctrl)
    self.myctrl = ctrl
end

function mvc.ModelBase:onRemoveByCtrl(ctrl)
    self.myctrl = nil
end

function mvc.ModelBase:listenEvent(name, func, data)
    self.myctrl.events:listen(name, func, self, data)
end

function mvc.ModelBase:dispatchEvent(name, ...)
    self.myctrl.events:dispatch(name, ...)
end

function mvc.ModelBase:collectData(no, ...)
    return self.myctrl.collect:onCollect(no, ...)
end

function mvc.ModelBase:onMVCEnter()
end

function mvc.ModelBase:onMVCExit()
end