
mvc = mvc or {}

mvc.CtrlBase = class("CtrlBase")

function mvc.CtrlBase:ctor()
    self.events = mvc.Event.new()

    self.models = {}
    self.views = {}
end

function mvc.CtrlBase:addCollect(collect)
    self.collect = collect
end

function mvc.CtrlBase:removeCollect()
    self.collect = nil
end

function mvc.CtrlBase:addModel(model)
    self.models[model.id] = model
    --self.collect:addModel(model)

    model:onAddByCtrl(self)
end

function mvc.CtrlBase:removeModel(id)
    local model = self.models[id]
    if not model then return end

    self.models[id] = nil
    -- self.collect:removeModel(id)

    model:onRemoveByCtrl(self)
end

function mvc.CtrlBase:removeAllModels()
    for _, id in pairs(table.keys(self.models)) do
        self:removeModel(id)
    end
end

function mvc.CtrlBase:addView(view)
    self.views[view.id] = view

    view:onAddByCtrl(self)
end

function mvc.CtrlBase:removeView(id)
    local view = self.views[id]
    if not view then return end

    self.views[id] = nil

    view:onRemoveByCtrl(self)
end

function mvc.CtrlBase:removeAllViews()
    for _, id in pairs(table.keys(self.views)) do
        self:removeView(id)
    end
end

function mvc.CtrlBase:listenEvent(name, func, data)
    self.events:listen(name, func, self, data)

end

function mvc.CtrlBase:dispatchEvent(name, ...)
    self.events:dispatch(name, ...)
end

function mvc.CtrlBase:clearEvent()
    self.events:clear()
end

function mvc.CtrlBase:collectData(no, ...)
    return self.collect:onCollect(no, ...)
end

function mvc.CtrlBase:onMVCEnter()
end

function mvc.CtrlBase:onMVCExit()
end

function mvc.CtrlBase:doMVCEnter()
    self:onMVCEnter()
    --self.collect:onMVCEnter()

    for _, model in pairs(self.models) do
        model:onMVCEnter()
    end

    for _, view in pairs(self.views) do
        view:onMVCEnter()
    end
end

function mvc.CtrlBase:doMVCExit()
    self:onMVCExit()
    --self.collect:onMVCExit()
    
    for _, model in pairs(self.models) do
        model:onMVCExit()
    end

    for _, view in pairs(self.views) do
        view:onMVCExit()
    end
end

