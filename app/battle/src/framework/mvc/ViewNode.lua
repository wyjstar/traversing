
mvc = mvc or {}

local function dispatchEvent(self, name, ...)
    self:getParent():dispatchEvent(name, ...)
end

mvc.ViewNode = function()
    local node = game.newNode()
    node.dispatchEvent = dispatchEvent
    return node
end

mvc.ViewBatchNode = function(...)
    local node = game.newBatchNode(...)

    node.dispatchEvent = dispatchEvent

    return node
end

mvc.ViewClippingNode = function(...)
    local node = game.newClippingNode(...)

    node.dispatchEvent = dispatchEvent

    return node
end

mvc.ViewSprite = function(...)
    local node = game.newSprite(...)

    node.dispatchEvent = dispatchEvent

    return node
end

mvc.ViewLayer = function(...)
    local node = game.newLayer(...)

    node.dispatchEvent = dispatchEvent

    return node
end

mvc.ViewColorLayer = function(...)
    local node = game.newColorLayer(...)

    node.dispatchEvent = dispatchEvent

    return node
end
