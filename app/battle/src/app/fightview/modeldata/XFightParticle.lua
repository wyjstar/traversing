
function UI_bosslaixichixu()--boss来袭持续
    --图标特效-- 第一个
    local particleone = createParticle("ui_b003302", cc.p(19,-48) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第一个
    local particletwo = createParticle("ui_b003304", cc.p(19,-200) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    --图标特效-- 第三个

    local particlethree = createParticle("ui_b003303", cc.p(52,173) )
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b003303", cc.p(91,165) )
    local particlesixRotate = createRotateTo(0, 98)
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b003301", cc.p(19,63) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 2, 2)
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(scaleToActiotten,delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particleone, sequenceActionone,particletwo, sequenceActiontwo,particlefour, sequenceActionfour,
                                    particleten, sequenceActionten)
    return node
end

function UI_bosslaixibianshen()--boss来袭变身
    --图标特效-- 第一个
    local particleone = createParticle("ui_b003401", cc.p(339,730) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.5, 0.4, 0.4)
    local delayActionone = createParticleDelay(0.4)--持续时间
    local stopActionone = createParticleOut(0.2)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)


    --图标特效-- 第一个
    local particletwo = createParticle("ui_b003403", cc.p(339,700) )

    -- local moveOne = createParticleMove(cc.p())
    local cistblethireight1 = createVistbleAction(false)
    local delaythireight1 = createParticleDelay(0.15)
    local cistblethireight2 = createVistbleAction(true)
    local delayActiontwo = createParticleDelay(0.4)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(cistblethireight1,delaythireight1,cistblethireight2,delayActiontwo,stopActiontwo)
    --图标特效-- 第三个

    local particlethree = createParticle("ui_b003405", cc.p(372,873) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethireight1 = createVistbleAction(false)
    local delaythireight1 = createParticleDelay(0.15)
    local cistblethireight2 = createVistbleAction(true)
    local delayActionthree = createParticleDelay(0.5)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(cistblethireight1,delaythireight1,cistblethireight2,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b003402", cc.p(339,740) )

    local cistblethireight1 = createVistbleAction(false)
    local delaythireight1 = createParticleDelay(0.4)
    local cistblethireight2 = createVistbleAction(true)

    local scaleToActiotten  = createScaleTo(0.8, 2.1, 2.1)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(cistblethireight1,delaythireight1,cistblethireight2,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b003407", cc.p(339,763) )

    local cistblethireight1 = createVistbleAction(false)
    local delaythireight1 = createParticleDelay(0.4)
    local cistblethireight2 = createVistbleAction(true)
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.5, 2.5, 2.5)
    local delayActionten = createParticleDelay(1)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistblethireight1,delaythireight1,cistblethireight2,scaleToActiotten,delayActionten,stopActionten)



    --图标特效-- 第二个
    local particleseven = createParticle("ui_b003408", cc.p(339,763) )

    local cistblethireight1 = createVistbleAction(false)
    local delaythireight1 = createParticleDelay(0.4)
    local cistblethireight2 = createVistbleAction(true)
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotseven  = createScaleTo(0.5, 2.5, 2.5)
    local delayActionseven = createParticleDelay(1)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(cistblethireight1,delaythireight1,cistblethireight2,scaleToActiotseven,delayActionseven,stopActionseven)


    --中心爆点--
    local particlefive = createParticle("ui_b003406", cc.p(339,763) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirfive1 = createVistbleAction(false)
    local delaythirfive1 = createParticleDelay(1.7)
    local cistblethirfive2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003406")

    local scaleToActiotfive  = createScaleTo(0.04, 3.5, 3.5)
    local delayActionfive = createParticleDelay(0.1)--持续时间
    local stopActionfive = createParticleOut(0.1)
    local sequenceActionfive = createSequence(cistblethirfive1,delaythirfive1,cistblethirfive2,particletwelveClone,scaleToActiotfive, delayActionfive,stopActionfive)


    --中心爆点--
    local particlesix = createParticle("ui_b003404", cc.p(339,800) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirsix1 = createVistbleAction(false)
    local delaythirsix1 = createParticleDelay(1.6)
    local cistblethirsix2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003404")

    local scaleToActiotsix  = createScaleTo(0.07, 1.3, 1.3)
    local delayActionsix = createParticleDelay(0.1)--持续时间
    local stopActionsix = createParticleOut(0.1)
    local sequenceActionsix = createSequence(cistblethirsix1,delaythirsix1,cistblethirsix2,particletwelveClone,scaleToActiotsix, delayActionsix,stopActionsix)

    local node = createTotleAction(particlethree, sequenceActionthree,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                    particleten, sequenceActionten,particletwo, sequenceActiontwo,particlefive, sequenceActionfive,particlesix, sequenceActionsix,
                                    particleseven, sequenceActionseven)
    return node
end

function UI_bianshen()--变身特效

    --图标特效-- 第一个
    local particleone = createParticle("ui_b003001", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(0.1)--持续时间
    local stopActionone = createParticleOut(0.2)
    local sequenceActionone = createSequence(delayActionone,stopActionone)


    --图标特效-- 第一个
    local particletwo = createParticle("a0051_01", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.2, 0.2)
    local delayActiontwo = createParticleDelay(0.15)--持续时间
    local stopActiontwo = createParticleOut(0.25)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第一个
    local particlethree = createParticle("ui_b003003", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotthree  = createScaleTo(0, 0.2, 0.2)
    local delayActionthree = createParticleDelay(0.2)--持续时间
    local stopActionthree = createParticleOut(0.3)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)



    --中心爆点--
    local particlefour = createParticle("ui_b003005", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirfour1 = createVistbleAction(false)
    local delaythirfour1 = createParticleDelay(0.2)
    local cistblethirfour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003004")

    local scaleToActiotfour  = createScaleTo(0, 0.9, 0.9)
    local delayActionfour = createParticleDelay(0.7)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(cistblethirfour1,delaythirfour1,cistblethirfour2,particletwelveClone,scaleToActiotfour, delayActionfour,stopActionfour)


    --中心爆点--
    local particlesix = createParticle("ui_b003203", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirsix1 = createVistbleAction(false)
    local delaythirsix1 = createParticleDelay(0.2)
    local cistblethirsix2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003203")

    local scaleToActiotsix  = createScaleTo(0, 1.5, 1.5)
    local delayActionsix = createParticleDelay(0.7)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(cistblethirsix1,delaythirsix1,cistblethirsix2,particletwelveClone,scaleToActiotsix, delayActionsix,stopActionsix)

    --中心爆点--
    local particleseven = createParticle("ui_b001804", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirseven1 = createVistbleAction(false)
    local delaythirseven1 = createParticleDelay(0.2)
    local cistblethirseven2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001804")

    local scaleToActiotseven  = createScaleTo(0, 0.44, 0.44)
    local delayActionseven = createParticleDelay(0.4)--持续时间
    local stopActionseven = createParticleOut(0.2)
    local sequenceActionseven = createSequence(cistblethirseven1,delaythirseven1,cistblethirseven2,particletwelveClone,scaleToActiotseven, delayActionseven,stopActionseven)


    --中心爆点--
    local particlefive = createParticle("ui_b003004", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirfive1 = createVistbleAction(false)
    local delaythirfive1 = createParticleDelay(1)
    local cistblethirfive2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003004")

    local scaleToActiotfive  = createScaleTo(0.07, 2.2, 2.2)
    local delayActionfive = createParticleDelay(0.1)--持续时间
    local stopActionfive = createParticleOut(0.25)
    local sequenceActionfive = createSequence(cistblethirfive1,delaythirfive1,cistblethirfive2,particletwelveClone,scaleToActiotfive, delayActionfive,stopActionfive)


    --中心爆点--
    local particlenine = createParticle("ui_a000505", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirnine1 = createVistbleAction(false)
    local delaythirnine1 = createParticleDelay(1.2)
    local cistblethirnine2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_a000505")

    local scaleToActiotnine  = createScaleTo(0.07, 0.7, 0.7)
    local delayActionnine = createParticleDelay(0.4)--持续时间
    local stopActionnine = createParticleOut(0.4)
    local sequenceActionnine = createSequence(cistblethirnine1,delaythirnine1,cistblethirnine2,particletwelveClone,scaleToActiotnine, delayActionnine,stopActionnine)

    --中心爆点--
    local particleeight = createParticle("ui_b001804", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethireight1 = createVistbleAction(false)
    local delaythireight1 = createParticleDelay(0.8)
    local cistblethireight2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001804")

    local scaleToActioteight  = createScaleTo(0.12, 0.44, 0.44)
    local delayActioneight = createParticleDelay(0.4)--持续时间
    local stopActioneight = createParticleOut(1)
    local sequenceActioneight = createSequence(cistblethireight1,delaythireight1,cistblethireight2,particletwelveClone,scaleToActioteight, delayActioneight,stopActioneight)

    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,particlefour, sequenceActionfour,
                                  particlesix, sequenceActionsix,particleseven, sequenceActionseven,particlefive, sequenceActionfive,particlenine, sequenceActionnine,
                                  particleeight, sequenceActioneight)
                                 
    return node
end

--------------------------------------
function UI_mozhaoyun()--魔赵云
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,28) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002202", cc.p(-27,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002203", cc.p(0,15) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002204", cc.p(15,15) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002205", cc.p(35,-5) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(-20,-10) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -30)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(particlesixRotate,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(35,-5) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002308", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleten, sequenceActionten)

    return node
end

function UI_moliguang()--魔李广
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,50) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002202", cc.p(-40,26) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002203", cc.p(20,56) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 100)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002203", cc.p(20,56) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 100)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002205", cc.p(35,20) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(30, -70)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(particlesixRotate,delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(20,-25) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 120)
    local scaleToActiotten  = createScaleTo(0, 0.7, 3)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(particlesixRotate,scaleToActiotten,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(20,-25) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 120)
    local scaleToActiotten  = createScaleTo(0, 0.7, 3)
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(particlesixRotate,scaleToActiotten,delayActionseven,stopActionseven)


    --图标特效-- 第一个
    local particleeight = createParticle("ui_b002201", cc.p(0,-80) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第四个
    local particlenine = createParticle("ui_b002208", cc.p(5,30) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -90)
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(particlesixRotate,scaleToActiotten,delayActionnine,stopActionnine)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002308", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine,particleten, sequenceActionten)




    return node
end

function UI_moliyuanba()--魔李元霸
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,-80) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002202", cc.p(-50,-10) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个

    local particlethree = createParticle("ui_b002103", cc.p(60,11) )
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(73,6) )
    local particlesixRotate = createRotateTo(0, 32)
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002205", cc.p(-40,10) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(-40,30) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(0,-40) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    --图标特效-- 第四个
    local particleeight = createParticle("ui_b002205", cc.p(50,36) )
    local scaleToActiotten  = createScaleTo(0, 1, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(scaleToActiotten,delayActioneight,stopActioneight)

    --图标特效-- 第二个
    local particlenine = createParticle("ui_b002202", cc.p(30,100) )
    local scaleToActiotten  = createScaleTo(0, 0.1, 1)
    local particlesixRotate = createRotateTo(0, -90)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(particlesixRotate,delayActionnine,stopActionnine)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002308", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine,particleten, sequenceActionten,particlefive, sequenceActionfive)




    return node
end

function UI_moxiangyu()--魔项羽
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,36) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002202", cc.p(-27,26) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002203", cc.p(6,18) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002204", cc.p(19,15) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002205", cc.p(35,20) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -70)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(particlesixRotate,delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(-44,56) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -30)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(particlesixRotate,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(58,38) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)


    --图标特效-- 第一个
    local particleeight = createParticle("ui_b002201", cc.p(0,-66) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第四个
    local particlenine = createParticle("ui_b002208", cc.p(5,30) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -90)
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(particlesixRotate,scaleToActiotten,delayActionnine,stopActionnine)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002308", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine,particleten, sequenceActionten)

    return node
end

function UI_moguanyu()--魔关羽
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,36) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002302", cc.p(-35,31) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(15,26) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(30,31) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002306", cc.p(-42,46) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -50)
    local scaleToActiotten  = createScaleTo(0, 0.5, 1.5)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(scaleToActiotten,particlesixRotate,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002307", cc.p(55,12) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(scaleToActiotten,delayActionseven,stopActionseven)

    --图标特效-- 第一个
    local particleeight = createParticle("ui_b002301", cc.p(0,-66) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002309", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)



    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particleten, sequenceActionten)


    return node
end

function UI_molvbu()--魔吕布
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,-80) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002202", cc.p(0,40) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个

    local particlethree = createParticle("ui_b002103", cc.p(-48,11) )
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(-35,16) )
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002205", cc.p(0,10) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(-20,40) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(0,10) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    --图标特效-- 第四个
    local particleeight = createParticle("ui_b002205", cc.p(50,36) )
    local scaleToActiotten  = createScaleTo(0, 1, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(scaleToActiotten,delayActioneight,stopActioneight)

    --图标特效-- 第二个
    local particlenine = createParticle("ui_b002202", cc.p(30,100) )
    local scaleToActiotten  = createScaleTo(0, 0.1, 1)
    local particlesixRotate = createRotateTo(0, -90)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(particlesixRotate,delayActionnine,stopActionnine)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002308", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)



  
    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine,particleten, sequenceActionten)


    return node
end

function UI_shengzhangfei()--圣张飞
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002401", cc.p(0,36) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002302", cc.p(-35,31) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002402", cc.p(72,22) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 2.4, 2.4)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002404", cc.p(-42,62) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -35)
    local scaleToActiotten  = createScaleTo(0, 0.7, 1.3)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(scaleToActiotten,particlesixRotate,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002311", cc.p(55,-17) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(scaleToActiotten,delayActionseven,stopActionseven)

    --图标特效-- 第一个
    local particleeight = createParticle("ui_b002401", cc.p(0,-80) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1,10)
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,
                                   particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particleten, sequenceActionten)


    return node
end

---------------------------------------

function UI_shengdiaochan()--圣貂蝉
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002312", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002311", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-10,43) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(12,45) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,particleten, sequenceActionten)
    return node
end

function UI_shengzhaoyun()--圣赵云
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002312", cc.p(60,-31) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002311", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-9,25) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(6,27) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,particleten, sequenceActionten)
    return node
end

function UI_shengxiaoqiao()--圣小乔
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002312", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002311", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-21,48) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(0,49) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

  
  
    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,particleten, sequenceActionten)



    return node
end

function UI_shengtaishici()--圣太史慈
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002312", cc.p(50,-20) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002311", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-70,-10) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(0,49) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,particleten, sequenceActionten)

    return node
end

function UI_shengliubei()--圣刘备

   
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-100) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.4, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-36,49) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(-17,45) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)



    return node
end

function UI_shengsunshangxiang()--圣孙尚香
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,36) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002602", cc.p(-50,-10) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-15,44) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(0,43) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 30)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002601", cc.p(-16,0) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -73)
    local scaleToActiotten  = createScaleTo(0, 0.5, 2.6)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(scaleToActiotten,particlesixRotate,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002602", cc.p(55,12) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1.4)
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(scaleToActiotten,delayActionseven,stopActionseven)

    --图标特效-- 第一个
    local particleeight = createParticle("ui_b002301", cc.p(0,-66) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002309", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particlefour, sequenceActionfour,
                                   particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particleten, sequenceActionten)
    return node
end

function UI_shengtaishici()--圣太史慈
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002312", cc.p(50,-20) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002311", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-70,-10) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(0,49) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,particleten, sequenceActionten)

    return node
end

function UI_shengdianwei()--圣典韦
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002401", cc.p(0,50) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002701", cc.p(-27,26) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002203", cc.p(6,18) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002204", cc.p(23,15) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002702", cc.p(45,-10) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -70)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(particlesixRotate,delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(-67,-60) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 2, 2)
    local particlesixRotate = createRotateTo(0, -120)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(particlesixRotate,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(58,-40) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)


    --图标特效-- 第一个
    local particleeight = createParticle("ui_b002401", cc.p(0,-70) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第四个
    local particlenine = createParticle("ui_b002208", cc.p(5,30) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -90)
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(particlesixRotate,scaleToActiotten,delayActionnine,stopActionnine)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine,particleten, sequenceActionten)




    return node
end

function UI_shengdaqiao()--圣大乔
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-80) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(17,42) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(32,38) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 30)
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)



    return node
end

function UI_shengzhanghe()--圣张合

   
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-80) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-10,28) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -27)
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(0,39) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 10)
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)

    return node
end

function UI_zhandouxiaoguotanhao()--战斗效果叹号

    --图标特效-- 第一个
    local particleone = createParticle("ui_b004501", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())

    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.4)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)
                                 

    return node
end

function UI_zhandouxiaoguozhuanxing()--战斗效果转星

    --图标特效-- 第一个
    local particleone = createParticle("ui_b004601", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.4)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)
                                 
    return node
end

function UI_zhandouxiaoguoxin()--战斗效果心

    --图标特效-- 第一个
    local particleone = createParticle("ui_b004401", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.4)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)
                                 

    return node
end

--------------------------------
function UI_shengzhangjiao()--圣张角
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002312", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002311", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-20,31) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(0,42) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,particleten, sequenceActionten)

    return node
end

function UI_shengzhangliao()--圣张辽
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-110) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-30,-1) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -27)
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(-15,7) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 10)
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)

    return node
end

function UI_shengzhouyu()--圣周瑜
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-110) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-28,16) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -27)
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(-12,20) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 30)
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)

    return node
end

function UI_shengsunjian()--圣孙坚
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-110) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)

    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(27,38) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -27)
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(44,38) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 50)
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)

    return node
end

function UI_shengyuanshao()--圣袁绍
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-110) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(-42,26) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -27)
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(-27,30) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 13)
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)
    return node
end

function UI_shenghuangyueying()--圣黄月英
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b002502", cc.p(0,-110) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b002504", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002503", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(22,14) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 0)
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(45,7) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 38)
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)
 
    local node = createTotleAction(particlefive, sequenceActionfive,particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, 
                                   sequenceActionfour,particleten, sequenceActionten)
    return node
end

function UI_mojingke()--魔荆轲
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,-80) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002202", cc.p(0,40) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个

    local particlethree = createParticle("ui_b002103", cc.p(-27,20) )
    local particlesixRotate = createRotateTo(0, -30)
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(-15,25) )
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002205", cc.p(0,10) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(-20,40) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(-58,-10) )
    local scaleToActiotten  = createScaleTo(0, 2.5, 0.8)
    local particlesixRotate = createRotateTo(0, 30)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(scaleToActiotten,particlesixRotate,delayActionseven,stopActionseven)

    --图标特效-- 第四个
    local particleeight = createParticle("ui_b002205", cc.p(50,36) )
    local scaleToActiotten  = createScaleTo(0, 1, 1.7)
    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(scaleToActiotten,delayActioneight,stopActioneight)

    --图标特效-- 第二个
    local particlenine = createParticle("ui_b002202", cc.p(30,100) )
    local scaleToActiotten  = createScaleTo(0, 0.1, 1)
    local particlesixRotate = createRotateTo(0, -90)
    -- local moveOne = createParticleMove(cc.p())
    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(particlesixRotate,delayActionnine,stopActionnine)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002308", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine,particleten, sequenceActionten)

    return node
end

function UI_moliubang()--魔刘邦
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002201", cc.p(0,36) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002202", cc.p(-27,26) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002203", cc.p(-10,30) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002204", cc.p(9,30) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    --图标特效-- 第四个
    local particlefive = createParticle("ui_b002205", cc.p(35,20) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -70)
    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(particlesixRotate,delayActionfive,stopActionfive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b002206", cc.p(0,64) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -30)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(particlesixRotate,delayActionsix,stopActionsix)

    --图标特效-- 第四个
    local particleseven = createParticle("ui_b002207", cc.p(0,-10) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)


    --图标特效-- 第一个
    local particleeight = createParticle("ui_b002201", cc.p(0,-66) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第四个
    local particlenine = createParticle("ui_b002208", cc.p(5,30) )
    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -90)
    local scaleToActiotten  = createScaleTo(0, 0.5, 1)
    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(particlesixRotate,scaleToActiotten,delayActionnine,stopActionnine)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002308", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine,particleten, sequenceActionten)

    return node
end

function UI_shengguanyu()--圣关羽
    --图标特效-- 第一个
    local particleone = createParticle("ui_b002312", cc.p(60,-31) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b002311", cc.p(-40,-20) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b002103", cc.p(6,25) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b002104", cc.p(15,25) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1.5, 1.5)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第二个
    local particleten = createParticle("ui_b002310", cc.p(0,0) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local node = createTotleAction(particlethree, sequenceActionthree,particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour,particleten, sequenceActionten)
    return node
end

























