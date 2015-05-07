
local ActionEditorCell = class("ActionEditorCell", function() 
    return cc.LayerColor:create(cc.c4b(100, 0, 0, 120), 480, 8+28*23)
end)

function ActionEditorCell:ctor()
    if device.platform == "ios" then
        local fontname = "Paint Boy"
    else
        local fontname = "fonts/Paint Boy.ttf"
    end

    local h = self:getContentSize().height

    --Dur
    self.labelDur = self:makeNewLabel(4, h-4-28*1, "Time")
    self.editDur = self:makeNewEditBox(110, h-4-28*1, 64, 24, "c9b.png")
    
    self:addChild(self.labelDur)
    self:addChild(self.editDur)

    --Speed
    self.labelSpeed = self:makeNewLabel(220, h-4-28*1, "Speed")
    self.editSpeed = self:makeNewEditBox(290, h-4-28*1, 64, 24, "c9b.png")
    
    self:addChild(self.labelSpeed)
    self:addChild(self.editSpeed)

    --Index
    self.labelIndex = self:makeNewLabel(394, h-4-28*1, "")

    self:addChild(self.labelIndex)

    --MoveTo
    self.labelMoveTo = self:makeNewLabel(4, h-4-28*2, "MoveTo (1, 10, 99)")
    self.editMoveToFlag = self:makeNewEditBox(110, h-4-28*2, 32, 24, "c9c.png")
    self.editMoveToX = self:makeNewEditBox(150, h-4-28*2, 64, 24, "c9a.png")
    self.editMoveToY = self:makeNewEditBox(220, h-4-28*2, 64, 24, "c9a.png")
    self.editMoveToRatio = self:makeNewEditBox(300, h-4-28*2, 48, 24, "c9a.png")
    self.editMoveToEase = self:makeNewEditBox(364, h-4-28*2, 30, 24, "c9c.png")
    self.editMoveToEaseArg = self:makeNewEditBox(400, h-4-28*2, 32, 24, "c9c.png")
    
    self:addChild(self.labelMoveTo)
    self:addChild(self.editMoveToFlag)
    self:addChild(self.editMoveToX)
    self:addChild(self.editMoveToY)
    self:addChild(self.editMoveToRatio)
    self:addChild(self.editMoveToEase)
    self:addChild(self.editMoveToEaseArg)

    --MoveBy
    self.labelMoveBy = self:makeNewLabel(4, h-4-28*3, "MoveBy (1)")
    self.editMoveByFlag = self:makeNewEditBox(110, h-4-28*3, 32, 24, "c9d.png")
    self.editMoveByX = self:makeNewEditBox(150, h-4-28*3, 64, 24, "c9b.png")
    self.editMoveByY = self:makeNewEditBox(220, h-4-28*3, 64, 24, "c9b.png")
    self.editMoveByEase = self:makeNewEditBox(364, h-4-28*3, 30, 24, "c9d.png")
    self.editMoveByEaseArg = self:makeNewEditBox(400, h-4-28*3, 32, 24, "c9d.png")
    
    self:addChild(self.labelMoveBy)
    self:addChild(self.editMoveByFlag)
    self:addChild(self.editMoveByX)
    self:addChild(self.editMoveByY)
    self:addChild(self.editMoveByEase)
    self:addChild(self.editMoveByEaseArg)

    --BezierTo
    self.labelBezierTo = self:makeNewLabel(4, h-4-28*4, "BezierTo (1, 99)")
    self.editBezierToFlag = self:makeNewEditBox(110, h-4-28*4, 32, 24, "c9c.png")
    self.editBezierToX = self:makeNewEditBox(150, h-4-28*4, 64, 24, "c9a.png")
    self.editBezierToY = self:makeNewEditBox(220, h-4-28*4, 64, 24, "c9a.png")
    self.editBezierToEase = self:makeNewEditBox(364, h-4-28*4, 30, 24, "c9c.png")
    self.editBezierToEaseArg = self:makeNewEditBox(400, h-4-28*4, 32, 24, "c9c.png")
    self.editBezierToX1 = self:makeNewEditBox(150, h-4-28*5, 64, 24, "c9a.png")
    self.editBezierToY1 = self:makeNewEditBox(220, h-4-28*5, 64, 24, "c9a.png")
    self.editBezierToX2 = self:makeNewEditBox(292, h-4-28*5, 64, 24, "c9a.png")
    self.editBezierToY2 = self:makeNewEditBox(362, h-4-28*5, 64, 24, "c9a.png")
    
    self:addChild(self.labelBezierTo)
    self:addChild(self.editBezierToFlag)
    self:addChild(self.editBezierToX)
    self:addChild(self.editBezierToY)
    self:addChild(self.editBezierToEase)
    self:addChild(self.editBezierToEaseArg)
    self:addChild(self.editBezierToX1)
    self:addChild(self.editBezierToY1)
    self:addChild(self.editBezierToX2)
    self:addChild(self.editBezierToY2)

    --BezierBy
    self.labelBezierBy = self:makeNewLabel(4, h-4-28*6, "BezierBy (1)")
    self.editBezierByFlag = self:makeNewEditBox(110, h-4-28*6, 32, 24, "c9d.png")
    self.editBezierByX = self:makeNewEditBox(150, h-4-28*6, 64, 24, "c9b.png")
    self.editBezierByY = self:makeNewEditBox(220, h-4-28*6, 64, 24, "c9b.png")
    self.editBezierByEase = self:makeNewEditBox(364, h-4-28*6, 30, 24, "c9d.png")
    self.editBezierByEaseArg = self:makeNewEditBox(400, h-4-28*6, 32, 24, "c9d.png")
    self.editBezierByX1 = self:makeNewEditBox(150, h-4-28*7, 64, 24, "c9b.png")
    self.editBezierByY1 = self:makeNewEditBox(220, h-4-28*7, 64, 24, "c9b.png")
    self.editBezierByX2 = self:makeNewEditBox(292, h-4-28*7, 64, 24, "c9b.png")
    self.editBezierByY2 = self:makeNewEditBox(362, h-4-28*7, 64, 24, "c9b.png")
    
    self:addChild(self.labelBezierBy)
    self:addChild(self.editBezierByFlag)
    self:addChild(self.editBezierByX)
    self:addChild(self.editBezierByY)
    self:addChild(self.editBezierByEase)
    self:addChild(self.editBezierByEaseArg)
    self:addChild(self.editBezierByX1)
    self:addChild(self.editBezierByY1)
    self:addChild(self.editBezierByX2)
    self:addChild(self.editBezierByY2)

    --ScaleTo
    self.labelScaleTo = self:makeNewLabel(4, h-4-28*8, "ScaleTo (99)")
    self.editScaleToFlag = self:makeNewEditBox(110, h-4-28*8, 32, 24, "c9c.png")
    self.editScaleToEase = self:makeNewEditBox(364, h-4-28*8, 30, 24, "c9c.png")
    self.editScaleToEaseArg = self:makeNewEditBox(400, h-4-28*8, 32, 24, "c9c.png")
    
    self:addChild(self.labelScaleTo)
    self:addChild(self.editScaleToFlag)
    self:addChild(self.editScaleToEase)
    self:addChild(self.editScaleToEaseArg)

    --ScaleBy
    self.labelScaleBy = self:makeNewLabel(4, h-4-28*9, "ScaleBy (1)")
    self.editScaleByFlag = self:makeNewEditBox(110, h-4-28*9, 32, 24, "c9d.png")
    self.editScaleByScaleX = self:makeNewEditBox(150, h-4-28*9, 64, 24, "c9b.png")
    self.editScaleByScaleY = self:makeNewEditBox(220, h-4-28*9, 64, 24, "c9b.png")
    self.editScaleByEase = self:makeNewEditBox(364, h-4-28*9, 30, 24, "c9d.png")
    self.editScaleByEaseArg = self:makeNewEditBox(400, h-4-28*9, 32, 24, "c9d.png")
    
    self:addChild(self.labelScaleBy)
    self:addChild(self.editScaleByFlag)
    self:addChild(self.editScaleByScaleX)
    self:addChild(self.editScaleByScaleY)
    self:addChild(self.editScaleByEase)
    self:addChild(self.editScaleByEaseArg)

    --RotateTo
    self.labelRotateTo = self:makeNewLabel(4, h-4-28*10, "RotateTo (1, 99)")
    self.editRotateToFlag = self:makeNewEditBox(110, h-4-28*10, 32, 24, "c9c.png")
    self.editRotateToX = self:makeNewEditBox(150, h-4-28*10, 64, 24, "c9a.png")
    self.editRotateToY = self:makeNewEditBox(220, h-4-28*10, 64, 24, "c9a.png")
    self.editRotateToZ = self:makeNewEditBox(290, h-4-28*10, 64, 24, "c9a.png")
    self.editRotateToEase = self:makeNewEditBox(364, h-4-28*10, 30, 24, "c9c.png")
    self.editRotateToEaseArg = self:makeNewEditBox(400, h-4-28*10, 32, 24, "c9c.png")
    
    self:addChild(self.labelRotateTo)
    self:addChild(self.editRotateToFlag)
    self:addChild(self.editRotateToX)
    self:addChild(self.editRotateToY)
    self:addChild(self.editRotateToZ)
    self:addChild(self.editRotateToEase)
    self:addChild(self.editRotateToEaseArg)

    --RotateBy
    self.labelRotateBy = self:makeNewLabel(4, h-4-28*11, "RotateBy (1)")
    self.editRotateByFlag = self:makeNewEditBox(110, h-4-28*11, 32, 24, "c9d.png")
    self.editRotateByX = self:makeNewEditBox(150, h-4-28*11, 64, 24, "c9b.png")
    self.editRotateByY = self:makeNewEditBox(220, h-4-28*11, 64, 24, "c9b.png")
    self.editRotateByZ = self:makeNewEditBox(290, h-4-28*11, 64, 24, "c9b.png")
    self.editRotateByEase = self:makeNewEditBox(364, h-4-28*11, 30, 24, "c9d.png")
    self.editRotateByEaseArg = self:makeNewEditBox(400, h-4-28*11, 32, 24, "c9d.png")
    
    self:addChild(self.labelRotateBy)
    self:addChild(self.editRotateByFlag)
    self:addChild(self.editRotateByX)
    self:addChild(self.editRotateByY)
    self:addChild(self.editRotateByZ)
    self:addChild(self.editRotateByEase)
    self:addChild(self.editRotateByEaseArg)

    --OrbitCamera
    self.labelOrbitCamera = self:makeNewLabel(4, h-4-28*12, "OrbitCamera (1)")
    self.editOrbitCameraFlag = self:makeNewEditBox(110, h-4-28*12, 32, 24, "c9c.png")
    self.editOrbitCameraRadius = self:makeNewEditBox(150, h-4-28*12, 64, 24, "c9a.png")
    self.editOrbitCameraRadiusDlt = self:makeNewEditBox(220, h-4-28*12, 64, 24, "c9a.png")
    self.editOrbitCameraEase = self:makeNewEditBox(364, h-4-28*12, 30, 24, "c9c.png")
    self.editOrbitCameraEaseArg = self:makeNewEditBox(400, h-4-28*12, 32, 24, "c9c.png")
    self.editOrbitCameraZ = self:makeNewEditBox(150, h-4-28*13, 64, 24, "c9a.png")
    self.editOrbitCameraZDlt = self:makeNewEditBox(220, h-4-28*13, 64, 24, "c9a.png")
    self.editOrbitCameraX = self:makeNewEditBox(292, h-4-28*13, 64, 24, "c9a.png")
    self.editOrbitCameraXDlt = self:makeNewEditBox(362, h-4-28*13, 64, 24, "c9a.png")
    
    self:addChild(self.labelOrbitCamera)
    self:addChild(self.editOrbitCameraFlag)
    self:addChild(self.editOrbitCameraRadius)
    self:addChild(self.editOrbitCameraRadiusDlt)
    self:addChild(self.editOrbitCameraEase)
    self:addChild(self.editOrbitCameraEaseArg)
    self:addChild(self.editOrbitCameraZ)
    self:addChild(self.editOrbitCameraZDlt)
    self:addChild(self.editOrbitCameraX)
    self:addChild(self.editOrbitCameraXDlt)

    --Animate
    self.labelAnimate = self:makeNewLabel(4, h-4-28*14, "Animate")
    self.editAnimateDlt = self:makeNewEditBox(110, h-4-28*14, 46, 24, "c9b.png")
    self.editAnimateX = self:makeNewEditBox(160, h-4-28*14, 48, 24, "c9b.png")
    self.editAnimateY = self:makeNewEditBox(210, h-4-28*14, 48, 24, "c9b.png")
    self.editAnimateFile = self:makeNewEditBox(262, h-4-28*14, 86, 24, "c9b.png")
    self.editAnimateNum = self:makeNewEditBox(350, h-4-28*14, 32, 24, "c9b.png")
    self.editAnimateScale = self:makeNewEditBox(386, h-4-28*14, 29, 24, "c9b.png")
    self.editAnimateFlip = self:makeNewEditBox(417, h-4-28*14, 29, 24, "c9b.png")
    self.editAnimateDelayTimes = self:makeNewEditBox(448, h-4-28*14, 29, 24, "c9b.png")

    self:addChild(self.labelAnimate)
    self:addChild(self.editAnimateDlt)
    self:addChild(self.editAnimateX)
    self:addChild(self.editAnimateY)
    self:addChild(self.editAnimateFile)
    self:addChild(self.editAnimateNum)
    self:addChild(self.editAnimateScale)
    self:addChild(self.editAnimateFlip)
    self:addChild(self.editAnimateDelayTimes)

    --AnimateS
    self.labelAnimateS = self:makeNewLabel(4, h-4-28*15, "Animate(Static)")
    self.editAnimateSDlt = self:makeNewEditBox(110, h-4-28*15, 46, 24, "c9a.png")
    self.editAnimateSX = self:makeNewEditBox(160, h-4-28*15, 48, 24, "c9a.png")
    self.editAnimateSY = self:makeNewEditBox(210, h-4-28*15, 48, 24, "c9a.png")
    self.editAnimateSFile = self:makeNewEditBox(262, h-4-28*15, 86, 24, "c9a.png")
    self.editAnimateSNum = self:makeNewEditBox(350, h-4-28*15, 32, 24, "c9a.png")
    self.editAnimateSScale = self:makeNewEditBox(386, h-4-28*15, 46, 24, "c9a.png")
    self.editAnimateSFlip = self:makeNewEditBox(436, h-4-28*15, 32, 24, "c9a.png")

    self:addChild(self.labelAnimateS)
    self:addChild(self.editAnimateSDlt)
    self:addChild(self.editAnimateSX)
    self:addChild(self.editAnimateSY)
    self:addChild(self.editAnimateSFile)
    self:addChild(self.editAnimateSNum)
    self:addChild(self.editAnimateSScale)
    self:addChild(self.editAnimateSFlip)

    --Particle
    self.labelParticle = self:makeNewLabel(4, h-4-28*16, "Particle")
    self.editParticleDlt1 = self:makeNewEditBox(110, h-4-28*16, 46, 24, "c9b.png")
    self.editParticleX1 = self:makeNewEditBox(160, h-4-28*16, 48, 24, "c9b.png")
    self.editParticleY1 = self:makeNewEditBox(210, h-4-28*16, 48, 24, "c9b.png")
    self.editParticleFile1 = self:makeNewEditBox(262, h-4-28*16, 86, 24, "c9b.png")
    self.editParticleLife1 = self:makeNewEditBox(350, h-4-28*16, 32, 24, "c9b.png")
    self.editParticleScale1 = self:makeNewEditBox(386, h-4-28*16, 29, 24, "c9b.png")
    self.editParticleFree1 = self:makeNewEditBox(417, h-4-28*16, 29, 24, "c9b.png")
    self.editParticleRotate1 = self:makeNewEditBox(448, h-4-28*16, 29, 24, "c9b.png")


    self.editParticleDlt2 = self:makeNewEditBox(110, h-4-28*17, 46, 24, "c9a.png")
    self.editParticleX2 = self:makeNewEditBox(160, h-4-28*17, 48, 24, "c9a.png")
    self.editParticleY2 = self:makeNewEditBox(210, h-4-28*17, 48, 24, "c9a.png")
    self.editParticleFile2 = self:makeNewEditBox(262, h-4-28*17, 86, 24, "c9a.png")
    self.editParticleLife2 = self:makeNewEditBox(350, h-4-28*17, 32, 24, "c9a.png")
    self.editParticleScale2 = self:makeNewEditBox(386, h-4-28*17, 29, 24, "c9a.png")
    self.editParticleFree2 = self:makeNewEditBox(417, h-4-28*17, 29, 24, "c9a.png")
    self.editParticleRotate2 = self:makeNewEditBox(448, h-4-28*17, 29, 24, "c9a.png")


    self.editParticleDlt3 = self:makeNewEditBox(110, h-4-28*18, 46, 24, "c9b.png")
    self.editParticleX3 = self:makeNewEditBox(160, h-4-28*18, 48, 24, "c9b.png")
    self.editParticleY3 = self:makeNewEditBox(210, h-4-28*18, 48, 24, "c9b.png")
    self.editParticleFile3 = self:makeNewEditBox(262, h-4-28*18, 86, 24, "c9b.png")
    self.editParticleLife3 = self:makeNewEditBox(350, h-4-28*18, 32, 24, "c9b.png")
    self.editParticleScale3 = self:makeNewEditBox(386, h-4-28*18, 29, 24, "c9b.png")
    self.editParticleFree3 = self:makeNewEditBox(417, h-4-28*18, 29, 24, "c9b.png")
    self.editParticleRotate3 = self:makeNewEditBox(448, h-4-28*18, 29, 24, "c9b.png")


    self.editParticleDlt4 = self:makeNewEditBox(110, h-4-28*19, 46, 24, "c9a.png")
    self.editParticleX4 = self:makeNewEditBox(160, h-4-28*19, 48, 24, "c9a.png")
    self.editParticleY4 = self:makeNewEditBox(210, h-4-28*19, 48, 24, "c9a.png")
    self.editParticleFile4 = self:makeNewEditBox(262, h-4-28*19, 86, 24, "c9a.png")
    self.editParticleLife4 = self:makeNewEditBox(350, h-4-28*19, 32, 24, "c9a.png")
    self.editParticleScale4 = self:makeNewEditBox(386, h-4-28*19, 29, 24, "c9a.png")
    self.editParticleFree4 = self:makeNewEditBox(417, h-4-28*19, 29, 24, "c9a.png")
    self.editParticleRotate4 = self:makeNewEditBox(448, h-4-28*19, 29, 24, "c9a.png")

    self:addChild(self.labelParticle)
    self:addChild(self.editParticleDlt1)
    self:addChild(self.editParticleX1)
    self:addChild(self.editParticleY1)
    self:addChild(self.editParticleFile1)
    self:addChild(self.editParticleLife1)
    self:addChild(self.editParticleScale1)
    self:addChild(self.editParticleFree1)
    self:addChild(self.editParticleRotate1)

    self:addChild(self.editParticleDlt2)
    self:addChild(self.editParticleX2)
    self:addChild(self.editParticleY2)
    self:addChild(self.editParticleFile2)
    self:addChild(self.editParticleLife2)
    self:addChild(self.editParticleScale2)
    self:addChild(self.editParticleFree2)
    self:addChild(self.editParticleRotate2)

    self:addChild(self.editParticleDlt3)
    self:addChild(self.editParticleX3)
    self:addChild(self.editParticleY3)
    self:addChild(self.editParticleFile3)
    self:addChild(self.editParticleLife3)
    self:addChild(self.editParticleScale3)
    self:addChild(self.editParticleFree3)
    self:addChild(self.editParticleRotate3)

    self:addChild(self.editParticleDlt4)
    self:addChild(self.editParticleX4)
    self:addChild(self.editParticleY4)
    self:addChild(self.editParticleFile4)
    self:addChild(self.editParticleLife4)
    self:addChild(self.editParticleScale4)
    self:addChild(self.editParticleFree4)
    self:addChild(self.editParticleRotate4)

    --Shake
    self.labelShake = self:makeNewLabel(4, h-4-28*20, "Shake (1, 2)")
    self.editShakeFlag = self:makeNewEditBox(110, h-4-28*20, 32, 24, "c9d.png")
    self.editShakeDlt = self:makeNewEditBox(150, h-4-28*20, 48, 24, "c9b.png")
    self.editShakeFrequency = self:makeNewEditBox(200, h-4-28*20, 48, 24, "c9b.png")
    
    self:addChild(self.labelShake)
    self:addChild(self.editShakeFlag)
    self:addChild(self.editShakeDlt)
    self:addChild(self.editShakeFrequency)

    --Slow
    self.labelSlow = self:makeNewLabel(280, h-4-28*20, "Slow")
    self.editSlowDlt = self:makeNewEditBox(320, h-4-28*20, 48, 24, "c9b.png")
    self.editSlowDur = self:makeNewEditBox(370, h-4-28*20, 48, 24, "c9b.png")
    self.editSlowSpeed = self:makeNewEditBox(420, h-4-28*20, 48, 24, "c9b.png")
    
    self:addChild(self.labelSlow)
    self:addChild(self.editSlowDlt)
    self:addChild(self.editSlowDur)
    self:addChild(self.editSlowSpeed)

    --Focus
    self.labelFocus = self:makeNewLabel(4, h-4-28*21, "Focus")
    self.editFocusDlt = self:makeNewEditBox(110, h-4-28*21, 46, 24, "c9a.png")
    self.editFocusX = self:makeNewEditBox(160, h-4-28*21, 48, 24, "c9a.png")
    self.editFocusY = self:makeNewEditBox(210, h-4-28*21, 48, 24, "c9a.png")
    self.editFocusDur = self:makeNewEditBox(334, h-4-28*21, 48, 24, "c9a.png")
    self.editFocusScale = self:makeNewEditBox(386, h-4-28*21, 46, 24, "c9a.png")

    self:addChild(self.labelFocus)
    self:addChild(self.editFocusDlt)
    self:addChild(self.editFocusX)
    self:addChild(self.editFocusY)
    self:addChild(self.editFocusDur)
    self:addChild(self.editFocusScale)

    --FadeTo
    self.labelFadeTo = self:makeNewLabel(4, h-4-28*22, "FadeTo (1)")
    self.editFadeToFlag = self:makeNewEditBox(110, h-4-28*22, 32, 24, "c9d.png")
    self.editFadeToOpacity = self:makeNewEditBox(150, h-4-28*22, 48, 24, "c9b.png")
    
    self:addChild(self.labelFadeTo)
    self:addChild(self.editFadeToFlag)
    self:addChild(self.editFadeToOpacity)

    --
    --shook 自身的抖动.跟shake做区分

    self.labelShook = self:makeNewLabel(4, h-4-28*23, "tremble (1)")
    self.editShookFlag = self:makeNewEditBox(110, h-4-28*23, 32, 24, "c9d.png") --标志
    self.editShookDlt = self:makeNewEditBox(150, h-4-28*23, 48, 24, "c9b.png")  --延迟时间
    self.editShookDuration = self:makeNewEditBox(200, h-4-28*23, 48, 24, "c9b.png")  --持续时间
    self.editShookFrequency = self:makeNewEditBox(250, h-4-28*23, 48, 24, "c9b.png")  --z
    self.editShookTime = self:makeNewEditBox(300, h-4-28*23, 48, 24, "c9b.png")  --震动频率

    self:addChild(self.labelShook)
    self:addChild(self.editShookFlag)
    self:addChild(self.editShookDlt)
    self:addChild(self.editShookDuration)
    self:addChild(self.editShookFrequency)
    self:addChild(self.editShookTime)
end

function ActionEditorCell:makeNewLabel(x, y, text)
    local label = ui.newTTFLabel({text = text, font = fontname, size = 14, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, })
    label:setPosition(x, y+3)
    label:setAnchorPoint(scr.ANCHOR_POINTS[scr.BOTTOM_LEFT])

    return label
end

function ActionEditorCell:makeNewEditBox(x, y, width, height, image)
    local editBox = ui.newEditBox({size = {width = width, height = height}, image = "res/ui/" .. image, listener = function(event, sender) end})
    editBox:setPosition(x, y)
    editBox:setAnchorPoint(scr.ANCHOR_POINTS[scr.BOTTOM_LEFT])
    editBox:setFont(fontname, 14)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_DECIMAL)

    return editBox
end

function ActionEditorCell:makeEaseS2I(data)
    if data.easein then
        return 1, data.easein
    elseif data.easeout then
        return 2, data.easeout
    elseif data.easeinout then
        return 3, data.easeinout
    elseif data.easesinein then
        return 11, nil
    elseif data.easesineout then
        return 12, nil
    elseif data.easesineinout then
        return 13, nil
    elseif data.easeexpin then
        return 21, nil
    elseif data.easeexpout then
        return 22, nil
    elseif data.easeexpinout then
        return 23, nil
    else
        return nil, nil
    end
end

function ActionEditorCell:makeEaseI2S(e, a)
    if e == 1 and a > 1 then
        return "easein", a
    elseif e == 2 and a > 1 then
        return "easeout", a
    elseif e == 3 and a > 1 then
        return "easeinout", a
    elseif e == 11 then
        return "easesinein", true
    elseif e == 12 then
        return "easesineout", true
    elseif e == 13 then
        return "easesineinout", true
    elseif e == 21 then
        return "easeexpin", true
    elseif e == 22 then
        return "easeexpout", true
    elseif e == 23 then
        return "easeexpinout", true
    else
        return nil, nil
    end
end

function ActionEditorCell:clearAllEditBox()
    --Dur
    self.editDur:setText("")

    --Speed
    self.editSpeed:setText("")

    --Index
    self.labelIndex:setString("")

    --MoveTo
    self.editMoveToFlag:setText("")
    self.editMoveToX:setText("")
    self.editMoveToY:setText("")
    self.editMoveToRatio:setText("")
    self.editMoveToEase:setText("")
    self.editMoveToEaseArg:setText("")

    --MoveBy
    self.editMoveByFlag:setText("")
    self.editMoveByX:setText("")
    self.editMoveByY:setText("")
    self.editMoveByEase:setText("")
    self.editMoveByEaseArg:setText("")

    --BezierTo
    self.editBezierToFlag:setText("")
    self.editBezierToX:setText("")
    self.editBezierToY:setText("")
    self.editBezierToEase:setText("")
    self.editBezierToEaseArg:setText("")
    self.editBezierToX1:setText("")
    self.editBezierToY1:setText("")
    self.editBezierToX2:setText("")
    self.editBezierToY2:setText("")

    --BezierBy
    self.editBezierByFlag:setText("")
    self.editBezierByX:setText("")
    self.editBezierByY:setText("")
    self.editBezierByEase:setText("")
    self.editBezierByEaseArg:setText("")
    self.editBezierByX1:setText("")
    self.editBezierByY1:setText("")
    self.editBezierByX2:setText("")
    self.editBezierByY2:setText("")

    --ScaleTo
    self.editScaleToFlag:setText("")
    self.editScaleToEase:setText("")
    self.editScaleToEaseArg:setText("")

    --ScaleBy
    self.editScaleByFlag:setText("")
    self.editScaleByScaleX:setText("")
    self.editScaleByScaleY:setText("")
    self.editScaleByEase:setText("")
    self.editScaleByEaseArg:setText("")

    --RotateTo
    self.editRotateToFlag:setText("")
    self.editRotateToX:setText("")
    self.editRotateToY:setText("")
    self.editRotateToZ:setText("")
    self.editRotateToEase:setText("")
    self.editRotateToEaseArg:setText("")

    --RotateBy
    self.editRotateByFlag:setText("")
    self.editRotateByX:setText("")
    self.editRotateByY:setText("")
    self.editRotateByZ:setText("")
    self.editRotateByEaseArg:setText("")
    self.editRotateByEase:setText("")

    --OrbitCamera
    self.editOrbitCameraFlag:setText("")
    self.editOrbitCameraRadius:setText("")
    self.editOrbitCameraRadiusDlt:setText("")
    self.editOrbitCameraEase:setText("")
    self.editOrbitCameraEaseArg:setText("")
    self.editOrbitCameraZ:setText("")
    self.editOrbitCameraZDlt:setText("")
    self.editOrbitCameraX:setText("")
    self.editOrbitCameraXDlt:setText("")

    --Animate
    self.editAnimateDlt:setText("")
    self.editAnimateX:setText("")
    self.editAnimateY:setText("")
    self.editAnimateFile:setText("")
    self.editAnimateNum:setText("")
    self.editAnimateScale:setText("")
    self.editAnimateFlip:setText("")

    --AnimateS
    self.editAnimateSDlt:setText("")
    self.editAnimateSX:setText("")
    self.editAnimateSY:setText("")
    self.editAnimateSFile:setText("")
    self.editAnimateSNum:setText("")
    self.editAnimateSScale:setText("")
    self.editAnimateSFlip:setText("")

    --Particle
    self.editParticleDlt1:setText("")
    self.editParticleX1:setText("")
    self.editParticleY1:setText("")
    self.editParticleFile1:setText("")
    self.editParticleLife1:setText("")
    self.editParticleScale1:setText("")
    self.editParticleFree1:setText("")
    self.editParticleRotate1:setText("")
    
    self.editParticleDlt2:setText("")
    self.editParticleX2:setText("")
    self.editParticleY2:setText("")
    self.editParticleFile2:setText("")
    self.editParticleLife2:setText("")
    self.editParticleScale2:setText("")
    self.editParticleFree2:setText("")
    self.editParticleRotate2:setText("")

    self.editParticleDlt3:setText("")
    self.editParticleX3:setText("")
    self.editParticleY3:setText("")
    self.editParticleFile3:setText("")
    self.editParticleLife3:setText("")
    self.editParticleScale3:setText("")
    self.editParticleFree3:setText("")
    self.editParticleRotate3:setText("")

    self.editParticleDlt4:setText("")
    self.editParticleX4:setText("")
    self.editParticleY4:setText("")
    self.editParticleFile4:setText("")
    self.editParticleLife4:setText("")
    self.editParticleScale4:setText("")
    self.editParticleFree4:setText("")
    self.editParticleRotate4:setText("")

    --Shake
    self.editShakeFlag:setText("")
    self.editShakeDlt:setText("")
    self.editShakeFrequency:setText("")

    --Slow
    self.editSlowDlt:setText("")
    self.editSlowDur:setText("")
    self.editSlowSpeed:setText("")

    --Focus
    self.editFocusDlt:setText("")
    self.editFocusX:setText("")
    self.editFocusY:setText("")
    self.editFocusDur:setText("")
    self.editFocusScale:setText("")

    --FadeTo
    self.editFadeToFlag:setText("")
    self.editFadeToOpacity:setText("")

    --shook
    self.editShookFlag:setText("")
    self.editShookDlt:setText("")
    self.editShookDuration:setText("")
    self.editShookFrequency:setText("")
    self.editShookTime:setText("")
    

end

function ActionEditorCell:resetAllData(idx, data)
    self:clearAllEditBox()

    if data.dur then
        self.editDur:setText(tostring(data.dur))
    end

    if data.speed then
        self.editSpeed:setText(tostring(data.speed))
    end

    self.labelIndex:setString(tostring(idx))

    if data.moveto then
        if data.moveto.flag then self.editMoveToFlag:setText(tostring(data.moveto.flag)) end
        if data.moveto.pos then
            self.editMoveToX:setText(tostring(data.moveto.pos.x))
            self.editMoveToY:setText(tostring(data.moveto.pos.y))
        end
        if data.moveto.ratio then self.editMoveToRatio:setText(tostring(data.moveto.ratio)) end
        local e, ea = self:makeEaseS2I(data.moveto)
        if e then self.editMoveToEase:setText(tostring(e)) end
        if ea then self.editMoveToEaseArg:setText(tostring(ea)) end
    end

    if data.moveby then
        if data.moveby.flag then self.editMoveByFlag:setText(tostring(data.moveby.flag)) end
        if data.moveby.pos then
            self.editMoveByX:setText(tostring(data.moveby.pos.x))
            self.editMoveByY:setText(tostring(data.moveby.pos.y))
        end
        local e, ea = self:makeEaseS2I(data.moveby)
        if e then self.editMoveByEase:setText(tostring(e)) end
        if ea then self.editMoveByEaseArg:setText(tostring(ea)) end
    end

    if data.bezierto then
        if data.bezierto.flag then self.editBezierToFlag:setText(tostring(data.bezierto.flag)) end
        if data.bezierto.pose then
            self.editBezierToX:setText(tostring(data.bezierto.pose.x))
            self.editBezierToY:setText(tostring(data.bezierto.pose.y))
        end
        if data.bezierto.pos1 then
            self.editBezierToX1:setText(tostring(data.bezierto.pos1.x))
            self.editBezierToY1:setText(tostring(data.bezierto.pos1.y))
        end
        if data.bezierto.pos2 then
            self.editBezierToX2:setText(tostring(data.bezierto.pos2.x))
            self.editBezierToY2:setText(tostring(data.bezierto.pos2.y))
        end
        local e, ea = self:makeEaseS2I(data.bezierto)
        if e then self.editBezierToEase:setText(tostring(e)) end
        if ea then self.editBezierToEaseArg:setText(tostring(ea)) end
    end

    if data.bezierby then
        if data.bezierby.flag then self.editBezierByFlag:setText(tostring(data.bezierby.flag)) end
        if data.bezierby.pose then
            self.editBezierByX:setText(tostring(data.bezierby.pose.x))
            self.editBezierByY:setText(tostring(data.bezierby.pose.y))
        end
        if data.bezierby.pos1 then
            self.editBezierByX1:setText(tostring(data.bezierby.pos1.x))
            self.editBezierByY1:setText(tostring(data.bezierby.pos1.y))
        end
        if data.bezierby.pos2 then
            self.editBezierByX2:setText(tostring(data.bezierby.pos2.x))
            self.editBezierByY2:setText(tostring(data.bezierby.pos2.y))
        end
        local e, ea = self:makeEaseS2I(data.bezierby)
        if e then self.editBezierByEase:setText(tostring(e)) end
        if ea then self.editBezierByEaseArg:setText(tostring(ea)) end
    end

    if data.scaleto then
        if data.scaleto.flag then self.editScaleToFlag:setText(tostring(data.scaleto.flag)) end
        local e, ea = self:makeEaseS2I(data.scaleto)
        if e then self.editScaleToEase:setText(tostring(e)) end
        if ea then self.editScaleToEaseArg:setText(tostring(ea)) end
    end

    if data.scaleby then
        if data.scaleby.flag then self.editScaleByFlag:setText(tostring(data.scaleby.flag)) end
        if data.scaleby.scale then 
            self.editScaleByScaleX:setText(tostring(data.scaleby.scale.x))
            self.editScaleByScaleY:setText(tostring(data.scaleby.scale.y))
        end
        local e, ea = self:makeEaseS2I(data.scaleby)
        if e then self.editScaleByEase:setText(tostring(e)) end
        if ea then self.editScaleByEaseArg:setText(tostring(ea)) end
    end

    if data.rotateto then
        if data.rotateto.flag then self.editRotateToFlag:setText(tostring(data.rotateto.flag)) end
        if data.rotateto.rotate then
            self.editRotateToX:setText(tostring(data.rotateto.rotate.x))
            self.editRotateToY:setText(tostring(data.rotateto.rotate.y))
            self.editRotateToZ:setText(tostring(data.rotateto.rotate.z))
        end
        local e, ea = self:makeEaseS2I(data.rotateto)
        if e then self.editRotateToEase:setText(tostring(e)) end
        if ea then self.editRotateToEaseArg:setText(tostring(ea)) end
    end

    if data.rotateby then
        if data.rotateby.flag then self.editRotateByFlag:setText(tostring(data.rotateby.flag)) end
        if data.rotateby.rotate then
            self.editRotateByX:setText(tostring(data.rotateby.rotate.x))
            self.editRotateByY:setText(tostring(data.rotateby.rotate.y))
            self.editRotateByZ:setText(tostring(data.rotateby.rotate.z))
        end
        local e, ea = self:makeEaseS2I(data.rotateby)
        if e then self.editRotateByEase:setText(tostring(e)) end
        if ea then self.editRotateByEaseArg:setText(tostring(ea)) end
    end

    if data.orbitcamera then
        if data.orbitcamera.flag then self.editOrbitCameraFlag:setText(tostring(data.orbitcamera.flag)) end
        if data.orbitcamera.orbit then
            self.editOrbitCameraRadius:setText(tostring(data.orbitcamera.orbit.r))
            self.editOrbitCameraRadiusDlt:setText(tostring(data.orbitcamera.orbit.rd))
            self.editOrbitCameraZ:setText(tostring(data.orbitcamera.orbit.z))
            self.editOrbitCameraZDlt:setText(tostring(data.orbitcamera.orbit.zd))
            self.editOrbitCameraX:setText(tostring(data.orbitcamera.orbit.x))
            self.editOrbitCameraXDlt:setText(tostring(data.orbitcamera.orbit.xd))
        end
        local e, ea = self:makeEaseS2I(data.orbitcamera)
        if e then self.editOrbitCameraEase:setText(tostring(e)) end
        if ea then self.editOrbitCameraEaseArg:setText(tostring(ea)) end
    end

    if data.animate then
        if data.animate.delta then self.editAnimateDlt:setText(tostring(data.animate.delta)) end
        if data.animate.x then self.editAnimateX:setText(tostring(data.animate.x)) end
        if data.animate.y then self.editAnimateY:setText(tostring(data.animate.y)) end
        if data.animate.file then self.editAnimateFile:setText(tostring(data.animate.file)) end
        if data.animate.num then self.editAnimateNum:setText(tostring(data.animate.num)) end
        if data.animate.scale then self.editAnimateScale:setText(tostring(data.animate.scale)) end
        if data.animate.flip then self.editAnimateFlip:setText(tostring(data.animate.flip)) end
        if data.animate.delayTimes then self.editAnimateDelayTimes:setText(tostring(data.animate.delayTimes)) end
        
    end

    if data.animateS then
        if data.animateS.delta then self.editAnimateSDlt:setText(tostring(data.animateS.delta)) end
        if data.animateS.x then self.editAnimateSX:setText(tostring(data.animateS.x)) end
        if data.animateS.y then self.editAnimateSY:setText(tostring(data.animateS.y)) end
        if data.animateS.file then self.editAnimateSFile:setText(tostring(data.animateS.file)) end
        if data.animateS.num then self.editAnimateSNum:setText(tostring(data.animateS.num)) end
        if data.animateS.scale then self.editAnimateSScale:setText(tostring(data.animateS.scale)) end
        if data.animateS.flip then self.editAnimateSFlip:setText(tostring(data.animateS.flip)) end
    end

    if data.particle then
        if data.particle[1] then
            if data.particle[1].delta then self.editParticleDlt1:setText(tostring(data.particle[1].delta)) end
            if data.particle[1].x then self.editParticleX1:setText(tostring(data.particle[1].x)) end
            if data.particle[1].y then self.editParticleY1:setText(tostring(data.particle[1].y)) end
            if data.particle[1].file then self.editParticleFile1:setText(tostring(data.particle[1].file)) end
            if data.particle[1].life then self.editParticleLife1:setText(tostring(data.particle[1].life)) end
            if data.particle[1].scale then self.editParticleScale1:setText(tostring(data.particle[1].scale)) end
            if data.particle[1].free then self.editParticleFree1:setText(tostring(data.particle[1].free)) end
            if data.particle[1].rotate then self.editParticleRotate1:setText(tostring(data.particle[1].rotate)) end
            
        end
        if data.particle[2] then
            if data.particle[2].delta then self.editParticleDlt2:setText(tostring(data.particle[2].delta)) end
            if data.particle[2].x then self.editParticleX2:setText(tostring(data.particle[2].x)) end
            if data.particle[2].y then self.editParticleY2:setText(tostring(data.particle[2].y)) end
            if data.particle[2].file then self.editParticleFile2:setText(tostring(data.particle[2].file)) end
            if data.particle[2].life then self.editParticleLife2:setText(tostring(data.particle[2].life)) end
            if data.particle[2].scale then self.editParticleScale2:setText(tostring(data.particle[2].scale)) end
            if data.particle[2].free then self.editParticleFree2:setText(tostring(data.particle[2].free)) end
            if data.particle[2].rotate then self.editParticleRotate2:setText(tostring(data.particle[2].rotate)) end
        end
        if data.particle[3] then
            if data.particle[3].delta then self.editParticleDlt3:setText(tostring(data.particle[3].delta)) end
            if data.particle[3].x then self.editParticleX3:setText(tostring(data.particle[3].x)) end
            if data.particle[3].y then self.editParticleY3:setText(tostring(data.particle[3].y)) end
            if data.particle[3].file then self.editParticleFile3:setText(tostring(data.particle[3].file)) end
            if data.particle[3].life then self.editParticleLife3:setText(tostring(data.particle[3].life)) end
            if data.particle[3].scale then self.editParticleScale3:setText(tostring(data.particle[3].scale)) end
            if data.particle[3].free then self.editParticleFree3:setText(tostring(data.particle[3].free)) end
            if data.particle[3].rotate then self.editParticleRotate3:setText(tostring(data.particle[3].rotate)) end
        end
        if data.particle[4] then
            if data.particle[4].delta then self.editParticleDlt4:setText(tostring(data.particle[4].delta)) end
            if data.particle[4].x then self.editParticleX4:setText(tostring(data.particle[4].x)) end
            if data.particle[4].y then self.editParticleY4:setText(tostring(data.particle[4].y)) end
            if data.particle[4].file then self.editParticleFile4:setText(tostring(data.particle[4].file)) end
            if data.particle[4].life then self.editParticleLife4:setText(tostring(data.particle[4].life)) end
            if data.particle[4].scale then self.editParticleScale4:setText(tostring(data.particle[4].scale)) end
            if data.particle[4].free then self.editParticleFree4:setText(tostring(data.particle[4].free)) end
            if data.particle[4].rotate then self.editParticleRotate4:setText(tostring(data.particle[4].rotate)) end
        end
    end

    if data.shake then
        if data.shake.flag then self.editShakeFlag:setText(tostring(data.shake.flag)) end
        if data.shake.delta then self.editShakeDlt:setText(tostring(data.shake.delta)) end
        if data.shake.frequency then self.editShakeFrequency:setText(tostring(data.shake.frequency)) end
    end

    if data.shook then
        if data.shook.flag then self.editShookFlag:setText(tostring(data.shook.flag)) end
        if data.shook.delta then self.editShookDlt:setText(tostring(data.shook.delta)) end
        if data.shook.duration then self.editShookDuration:setText(tostring(data.shook.duration)) end
        if data.shook.frequency then self.editShookFrequency:setText(tostring(data.shook.frequency)) end
        if data.shook.time then self.editShookTime:setText(tostring(data.shook.time)) end
        
    end

    if data.slow then
        if data.slow.delta then self.editSlowDlt:setText(tostring(data.slow.delta)) end
        if data.slow.dur then self.editSlowDur:setText(tostring(data.slow.dur)) end
        if data.slow.speed then self.editSlowSpeed:setText(tostring(data.slow.speed)) end
    end

    if data.focus then
        if data.focus.delta then self.editFocusDur:setText(tostring(data.focus.delta)) end
        if data.focus.x then self.editFocusX:setText(tostring(data.focus.x)) end
        if data.focus.y then self.editFocusY:setText(tostring(data.focus.y)) end
        if data.focus.dur then self.editFocusDur:setText(tostring(data.focus.dur)) end
        if data.focus.scale then self.editFocusScale:setText(tostring(data.focus.scale)) end
    end

    if data.fadeto then
        if data.fadeto.flag then self.editFadeToFlag:setText(tostring(data.fadeto.flag)) end
        if data.fadeto.opacity then self.editFadeToOpacity:setText(tostring(data.fadeto.opacity)) end
    end
end

function ActionEditorCell:resolveToData()
    local data = {}

    data.dur = tonumber(self.editDur:getText())
    data.speed = tonumber(self.editSpeed:getText())
    
    if not data.dur and not data.speed then return nil end

    local movetoflag = tonumber(self.editMoveToFlag:getText())
    if movetoflag == 1 or movetoflag == 10 or movetoflag == 99 then
        data.moveto = {}
        data.moveto.flag = movetoflag
        data.moveto.pos = {x = tonumber(self.editMoveToX:getText()) or 0, y = tonumber(self.editMoveToY:getText()) or 0}
        data.moveto.ratio = tonumber(self.editMoveToRatio:getText()) or 0
        local e, ea = self:makeEaseI2S(tonumber(self.editMoveToEase:getText()), tonumber(self.editMoveToEaseArg:getText()))
        if e and ea then data.moveto[e] = ea end
    end

    local movebyflag = tonumber(self.editMoveByFlag:getText())
    if movebyflag == 1 then
        data.moveby = {}
        data.moveby.flag = movebyflag
        data.moveby.pos = {x = tonumber(self.editMoveByX:getText()) or 0, y = tonumber(self.editMoveByY:getText()) or 0}
        local e, ea = self:makeEaseI2S(tonumber(self.editMoveByEase:getText()), tonumber(self.editMoveByEaseArg:getText()))
        if e and ea then data.moveby[e] = ea end
    end

    local beziertoflag = tonumber(self.editBezierToFlag:getText())
    if beziertoflag == 1 or beziertoflag == 99 then
        data.bezierto = {}
        data.bezierto.flag = beziertoflag
        data.bezierto.pose = {x = tonumber(self.editBezierToX:getText()) or 0, y = tonumber(self.editBezierToY:getText()) or 0}
        data.bezierto.pos1 = {x = tonumber(self.editBezierToX1:getText()) or 0, y = tonumber(self.editBezierToY1:getText()) or 0}
        data.bezierto.pos2 = {x = tonumber(self.editBezierToX2:getText()) or 0, y = tonumber(self.editBezierToY2:getText()) or 0}
        local e, ea = self:makeEaseI2S(tonumber(self.editBezierToEase:getText()), tonumber(self.editBezierToEaseArg:getText()))
        if e and ea then data.bezierto[e] = ea end
    end

    local bezierbyflag = tonumber(self.editBezierByFlag:getText())
    if bezierbyflag == 1 then
        data.bezierby = {}
        data.bezierby.flag = bezierbyflag
        data.bezierby.pose = {x = tonumber(self.editBezierByX:getText()) or 0, y = tonumber(self.editBezierByY:getText()) or 0}
        data.bezierby.pos1 = {x = tonumber(self.editBezierByX1:getText()) or 0, y = tonumber(self.editBezierByY1:getText()) or 0}
        data.bezierby.pos2 = {x = tonumber(self.editBezierByX2:getText()) or 0, y = tonumber(self.editBezierByY2:getText()) or 0}
        local e, ea = self:makeEaseI2S(tonumber(self.editBezierByEase:getText()), tonumber(self.editBezierByEaseArg:getText()))
        if e and ea then data.bezierby[e] = ea end
    end

    local scaletoflag = tonumber(self.editScaleToFlag:getText())
    if scaletoflag == 99 then
        data.scaleto = {}
        data.scaleto.flag = scaletoflag
        local e, ea = self:makeEaseI2S(tonumber(self.editScaleToEase:getText()), tonumber(self.editScaleToEaseArg:getText()))
        if e and ea then data.scaleto[e] = ea end
    end

    local scalebyflag = tonumber(self.editScaleByFlag:getText())
    if scalebyflag == 1 then
        data.scaleby = {}
        data.scaleby.flag = scalebyflag
        data.scaleby.scale = {x = tonumber(self.editScaleByScaleX:getText()) or 0, y = tonumber(self.editScaleByScaleY:getText()) or 0}
        local e, ea = self:makeEaseI2S(tonumber(self.editScaleByEase:getText()), tonumber(self.editScaleByEaseArg:getText()))
        if e and ea then data.scaleby[e] = ea end
    end

    local rotatetoflag = tonumber(self.editRotateToFlag:getText())
    if rotatetoflag == 1 or rotatetoflag == 99 then
        data.rotateto = {}
        data.rotateto.flag = rotatetoflag
        data.rotateto.rotate = {x = tonumber(self.editRotateToX:getText()) or 0, y = tonumber(self.editRotateToY:getText()) or 0, z = tonumber(self.editRotateToZ:getText()) or 0}
        local e, ea = self:makeEaseI2S(tonumber(self.editRotateToEase:getText()), tonumber(self.editRotateToEaseArg:getText()))
        if e and ea then data.rotateto[e] = ea end
    end
    
    local rotatebyflag = tonumber(self.editRotateByFlag:getText())
    if rotatebyflag == 1 then
        data.rotateby = {}
        data.rotateby.flag = rotatebyflag
        data.rotateby.rotate = {x = tonumber(self.editRotateByX:getText()) or 0, y = tonumber(self.editRotateByY:getText()) or 0, z = tonumber(self.editRotateByZ:getText()) or 0}
        local e, ea = self:makeEaseI2S(tonumber(self.editRotateByEase:getText()), tonumber(self.editRotateByEaseArg:getText()))
        if e and ea then data.rotateby[e] = ea end
    end

    local orbitcameraflag = tonumber(self.editOrbitCameraFlag:getText())
    if orbitcameraflag == 1 then
        data.orbitcamera = {}
        data.orbitcamera.flag = orbitcameraflag
        data.orbitcamera.orbit = {r = tonumber(self.editOrbitCameraRadius:getText()) or 0, rd = tonumber(self.editOrbitCameraRadiusDlt:getText()) or 0,
                z = tonumber(self.editOrbitCameraZ:getText()) or 0, zd = tonumber(self.editOrbitCameraZDlt:getText()) or 0,
                x = tonumber(self.editOrbitCameraX:getText()) or 0, xd = tonumber(self.editOrbitCameraXDlt:getText()) or 0,
            }
        local e, ea = self:makeEaseI2S(tonumber(self.editOrbitCameraEase:getText()), tonumber(self.editOrbitCameraEaseArg:getText()))
        if e and ea then data.orbitcamera[e] = ea end
    end

    local animatefile = self.editAnimateFile:getText()
    if string.len(animatefile) > 0 then
        data.animate = {}
        data.animate.delta = tonumber(self.editAnimateDlt:getText()) or 0
        data.animate.x = tonumber(self.editAnimateX:getText()) or 0
        data.animate.y = tonumber(self.editAnimateY:getText()) or 0
        data.animate.file = animatefile
        data.animate.num = tonumber(self.editAnimateNum:getText()) or 0
        data.animate.scale = tonumber(self.editAnimateScale:getText()) or 0
        data.animate.flip = tonumber(self.editAnimateFlip:getText()) or 0
        data.animate.delayTimes = tonumber(self.editAnimateDelayTimes:getText()) or 1
        
    end

    local animateSfile = self.editAnimateSFile:getText()
    if string.len(animateSfile) > 0 then
        data.animateS = {}
        data.animateS.delta = tonumber(self.editAnimateSDlt:getText()) or 0
        data.animateS.x = tonumber(self.editAnimateSX:getText()) or 0
        data.animateS.y = tonumber(self.editAnimateSY:getText()) or 0
        data.animateS.file = animateSfile
        data.animateS.num = tonumber(self.editAnimateSNum:getText()) or 0
        data.animateS.scale = tonumber(self.editAnimateSScale:getText()) or 0
        data.animateS.flip = tonumber(self.editAnimateSFlip:getText()) or 0
    end

    local particlefile1 = self.editParticleFile1:getText()
    if string.len(particlefile1) > 0 then
        data.particle = data.particle or {}
        data.particle[#data.particle + 1] = {}
        data.particle[#data.particle].delta = tonumber(self.editParticleDlt1:getText()) or 0
        data.particle[#data.particle].x = tonumber(self.editParticleX1:getText()) or 0
        data.particle[#data.particle].y = tonumber(self.editParticleY1:getText()) or 0
        data.particle[#data.particle].file = particlefile1
        data.particle[#data.particle].life = tonumber(self.editParticleLife1:getText()) or 0
        data.particle[#data.particle].scale = tonumber(self.editParticleScale1:getText()) or 0
        data.particle[#data.particle].free = tonumber(self.editParticleFree1:getText()) or 0
        data.particle[#data.particle].rotate = tonumber(self.editParticleRotate1:getText()) or 0

    end

    local particlefile2 = self.editParticleFile2:getText()
    if string.len(particlefile2) > 0 then
        data.particle = data.particle or {}
        data.particle[#data.particle + 1] = {}
        data.particle[#data.particle].delta = tonumber(self.editParticleDlt2:getText()) or 0
        data.particle[#data.particle].x = tonumber(self.editParticleX2:getText()) or 0
        data.particle[#data.particle].y = tonumber(self.editParticleY2:getText()) or 0
        data.particle[#data.particle].file = particlefile2
        data.particle[#data.particle].life = tonumber(self.editParticleLife2:getText()) or 0
        data.particle[#data.particle].scale = tonumber(self.editParticleScale2:getText()) or 0
        data.particle[#data.particle].free = tonumber(self.editParticleFree2:getText()) or 0
        data.particle[#data.particle].rotate = tonumber(self.editParticleRotate2:getText()) or 0
    end

    local particlefile3 = self.editParticleFile3:getText()
    if string.len(particlefile3) > 0 then
        data.particle = data.particle or {}
        data.particle[#data.particle + 1] = {}
        data.particle[#data.particle].delta = tonumber(self.editParticleDlt3:getText()) or 0
        data.particle[#data.particle].x = tonumber(self.editParticleX3:getText()) or 0
        data.particle[#data.particle].y = tonumber(self.editParticleY3:getText()) or 0
        data.particle[#data.particle].file = particlefile3
        data.particle[#data.particle].life = tonumber(self.editParticleLife3:getText()) or 0
        data.particle[#data.particle].scale = tonumber(self.editParticleScale3:getText()) or 0
        data.particle[#data.particle].free = tonumber(self.editParticleFree3:getText()) or 0
        data.particle[#data.particle].rotate = tonumber(self.editParticleRotate3:getText()) or 0
    end

    local particlefile4 = self.editParticleFile4:getText()
    if string.len(particlefile4) > 0 then
        data.particle = data.particle or {}
        data.particle[#data.particle + 1] = {}
        data.particle[#data.particle].delta = tonumber(self.editParticleDlt4:getText()) or 0
        data.particle[#data.particle].x = tonumber(self.editParticleX4:getText()) or 0
        data.particle[#data.particle].y = tonumber(self.editParticleY4:getText()) or 0
        data.particle[#data.particle].file = particlefile4
        data.particle[#data.particle].life = tonumber(self.editParticleLife4:getText()) or 0
        data.particle[#data.particle].scale = tonumber(self.editParticleScale4:getText()) or 0
        data.particle[#data.particle].free = tonumber(self.editParticleFree4:getText()) or 0
        data.particle[#data.particle].rotate = tonumber(self.editParticleRotate4:getText()) or 0
    end

    local shakeflag = tonumber(self.editShakeFlag:getText())
    if shakeflag == 1 or shakeflag == 2 then
        data.shake = {}
        data.shake.flag = shakeflag
        data.shake.delta = tonumber(self.editShakeDlt:getText()) or 0
        data.shake.frequency = tonumber(self.editShakeFrequency:getText()) or 0
    end

    local slowspeed = tonumber(self.editSlowSpeed:getText())
    if slowspeed and slowspeed > 0 then
        data.slow = {}
        data.slow.speed = slowspeed
        data.slow.delta = tonumber(self.editSlowDlt:getText()) or 0
        data.slow.dur = tonumber(self.editSlowDur:getText()) or 0
    end

    local focusdur = tonumber(self.editFocusDur:getText())
    if focusdur and focusdur > 0 then
        data.focus = {}
        data.focus.delta = tonumber(self.editFocusDlt:getText()) or 0
        data.focus.x = tonumber(self.editFocusX:getText()) or 0
        data.focus.y = tonumber(self.editFocusY:getText()) or 0
        data.focus.dur = focusdur
        data.focus.scale = tonumber(self.editFocusScale:getText()) or 0
    end

    local fadetoflag = tonumber(self.editFadeToFlag:getText())
    if fadetoflag then
        data.fadeto = {}
        data.fadeto.flag = fadetoflag
        data.fadeto.opacity = tonumber(self.editFadeToOpacity:getText()) or 0
    end
    
    local shookFlag = tonumber(self.editShookFlag:getText())
    if shookFlag then
        data.shook = {}
        data.shook.flag = shookFlag
        data.shook.delta = tonumber(self.editShookDlt:getText()) or 0
        data.shook.frequency = tonumber(self.editShookFrequency:getText()) or 0
        data.shook.duration = tonumber(self.editShookDuration:getText()) or 0
        data.shook.time = tonumber(self.editShookTime:getText()) or 0
    end

    return data
end

return ActionEditorCell
