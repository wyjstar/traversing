
local FVParticleManager = class("FVParticleManager", function()
    return game.newNode()
end)

function FVParticleManager:ctor()
    self.speed = 1.0
    self.particles = {}
end

function FVParticleManager:make(file, life, free)
    -- print("------FVParticleManager:make-----")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    local part = cc.ParticleSystemQuad:create(string.format("res/part/%s.plist", file))
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    if not part then return nil end
    part.free = free
    part:setUpdateSpeed(self.speed)
    if part.free then
        part:setPositionType(cc.POSITION_TYPE_FREE)
    else
        part:setPositionType(cc.POSITION_TYPE_RELATIVE)
    end

    self.particles[part] = true

    local function handler(event)
        if event == "exit" then
            self.particles[part] = nil
        end
    end
    part:registerScriptHandler(handler)

    timer.delayAction(function()
        if self.particles[part] then
            -- part:setAutoRemoveOnFinish(false)
            --part:stopSystem()

            part:removeFromParent(true)
            self.particles[part] = nil
            part = nil
        end
    end, self, nil, life)

    return part
end

function FVParticleManager:setSpeed(speed)
    self.speed = speed

    for part, _ in pairs(self.particles) do
        part:setUpdateSpeed(speed)
    end
end

return FVParticleManager
