
mvc = mvc or {}

mvc.CollectBase = class("CollectBase")

function mvc.CollectBase:ctor()
    self.models = {}
    self.collects = {}
end

function mvc.CollectBase:addModel(model)
    self.models[model.id] = model
end

function mvc.CollectBase:removeModel(id)
    self.models[id] = nil
end

function mvc.CollectBase:addCollect(no, callback)
    self.collects[no] = callback
end

function mvc.CollectBase:onCollect(no, ...)
    return self.collects[no](self, ...)
end

function mvc.CollectBase:onMVCEnter()
end

function mvc.CollectBase:onMVCExit()
end