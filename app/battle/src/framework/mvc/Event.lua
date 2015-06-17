
mvc = mvc or {}

mvc.Event = class("Event")

function mvc.Event:ctor()
    self.events = {}
end

function mvc.Event:clear()
    self.events = {}
end

function mvc.Event:listen(name, func, object, data)
    if not object then object = "_StaticFunc" end

    self.events[name] = self.events[name] or {}
    self.events[name][object] = self.events[name][object] or {}
    if data then
        self.events[name][object][func] = {data, }
    else
        self.events[name][object][func] = {}
    end
end

function mvc.Event:dispatch(name, ...)
    local dispatch = self.events[name]
    if not dispatch then return end

    for obj, listen in pairs(dispatch) do
        for func, data in pairs(listen) do
            if obj == "_StaticFunc" then
                if #data == 0 then
                    func(...)
                else
                    func(data[1], ...)
                end
            else
                if #data == 0 then
                    func(obj, ...)
                else
                    func(obj, data[1], ...)
                end
            end
        end
    end
end

function mvc.Event:exist(name, object)
    if not self.events[name] then return false end
    if object and not self.events[name][object] then return false end

    return true
end

function mvc.Event:removeByName(name)
    self.events[name] = nil
end

function mvc.Event:removeByNameObject(name, object)
    if not self.events[name] then return end

    self.events[name][object] = nil
end

function mvc.Event:removeByObject(object)
    for _, dispatch in pairs(self.events) do
        if dispatch[object] then
            dispatch[object] = nil
        end
    end
end

