function UI_zhujiu()--煮酒

    --图标特效-- 第一个
    local particleone = createParticle("ui_b003501", cc.p(306,259) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 0.8)
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(0.9)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    --图标特效-- 第一个
    local particletwo = createParticle("ui_b003502", cc.p(306,259) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 0.8)
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(0.9)
    local sequenceActiontwo = createSequence(scaleToActiotten,delayActiontwo,stopActiontwo)

    --图标特效-- 第一个
    local particlenine = createParticle("ui_b003505", cc.p(306,250) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionnine = createParticleDelay(999)--持续时间
    local stopActionnine = createParticleOut(0.9)
    local sequenceActionnine = createSequence(scaleToActiotten,delayActionnine,stopActionnine)


    --图标特效-- 第一个
    local particlethree = createParticle("ui_b003501", cc.p(191,331) )

    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 84)
    local scaleToActiotten  = createScaleTo(0, 0.5, 0.3)
    local delayActionthree = createParticleDelay(999)--持续时间
    local stopActionthree = createParticleOut(0.9)
    local sequenceActionthree = createSequence(particlesixRotate,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第一个
    local particlefour = createParticle("ui_b003502", cc.p(191,331) )

    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 84)
    local scaleToActiotten  = createScaleTo(0, 0.6, 0.4)
    local delayActionfour = createParticleDelay(999)--持续时间
    local stopActionfour = createParticleOut(0.9)
    local sequenceActionfour = createSequence(particlesixRotate,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第一个
    local particleten = createParticle("ui_b003505", cc.p(191,331) )

    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 45)
    local scaleToActiotten  = createScaleTo(0, 0.6, 0.6)
    local delayActionten = createParticleDelay(999)--持续时间
    local stopActionten = createParticleOut(0.9)
    local sequenceActionten = createSequence(particlesixRotate,scaleToActiotten,delayActionten,stopActionten)



    --图标特效-- 第一个
    local particlefive = createParticle("ui_b003501", cc.p(450,328) )

    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -84)
    local scaleToActiotten  = createScaleTo(0, 0.5, 0.5)
    local delayActionfive = createParticleDelay(999)--持续时间
    local stopActionfive = createParticleOut(0.9)
    local sequenceActionfive = createSequence(particlesixRotate,scaleToActiotten,delayActionfive,stopActionfive)

    --图标特效-- 第一个
    local particlesix = createParticle("ui_b003502", cc.p(450,328) )

    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -84)
    local scaleToActiotten  = createScaleTo(0, 0.6, 0.5)
    local delayActionsix = createParticleDelay(999)--持续时间
    local stopActionsix = createParticleOut(0.9)
    local sequenceActionsix = createSequence(particlesixRotate,scaleToActiotten,delayActionsix,stopActionsix)

    --图标特效-- 第一个
    local particleeleven = createParticle("ui_b003505", cc.p(450,328) )

    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, -46)
    local scaleToActiotten  = createScaleTo(0, 0.6, 0.5)
    local delayActioneleven = createParticleDelay(999)--持续时间
    local stopActioneleven = createParticleOut(0.9)
    local sequenceActioneleven = createSequence(particlesixRotate,scaleToActiotten,delayActioneleven,stopActioneleven)


    --锅里的烟雾
    local particleseven = createParticle("ui_b003503", cc.p(330,580) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionseven = createParticleDelay(999)--持续时间
    local stopActionseven = createParticleOut(0.9)
    local sequenceActionseven = createSequence(scaleToActiotten,delayActionseven,stopActionseven)

    --屋里的烟雾
    local particleeight = createParticle("ui_b003504", cc.p(314,743) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActioneight = createParticleDelay(999)--持续时间
    local stopActioneight = createParticleOut(0.9)
    local sequenceActioneight = createSequence(scaleToActiotten,delayActioneight,stopActioneight)

    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,particlefour, sequenceActionfour,
                                    particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                    particlenine, sequenceActionnine,particleten, sequenceActionten,particleeleven, sequenceActioneleven)

    return node
end


function UI_wujiangjiban()--武将羁绊

    --图标特效-- 第一个
    local particleone = createParticle("ui_b003601", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)

    return node
end


function UI_youlifengwuzhi()--游历风物志

    --图标特效-- 第一个
    local particleone = createParticle("ui_b003701", cc.p(149,128) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)

    return node
end


function UI_youlifengwuzhi001()--游历风物志001

    --图标特效-- 第一个
    local particleone = createParticle("ui_b003701", cc.p(149,128) )

    -- local moveOne = createParticleMove(cc.p())
    local particlesixRotate = createRotateTo(0, 180)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(particlesixRotate,delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)

    return node
end


function UI_youlifengwuzhijiemianshuoming()--游历风物志界面说明

    --图标特效-- 第一个
    local particleone = createParticle("ui_b003801", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)

    return node
end

function UI_Youlibaoxiang()--游历宝箱 31

    local particleone = createParticle("ui_a003101", cc.p(0,0))
    local delayActionone = createParticleDelay(0.3)
    local stopActionone = createParticleOut(0.3)
    local sequenceActionone= createSequence(delayActionone, stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)
    return node
end

function UI_gongzhanqitawanjiayewaikuangdian()--攻占敌方玩家野外矿点
    --发光
    local particleOne = createParticle("ui_b001502", cc.p(0,18))
    -- local moveOne = createParticleMove(cc.p())

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionOne = createParticleDelay(0.3)--持续时间
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionOne, stopActionOne)

    --原地点光
    local particlesix = createParticle("ui_b002801", cc.p(0,18))
    -- local moveOne = createParticleMove(cc.p())

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.4)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionsix = createParticleDelay(0.3)--持续时间
    local stopActionsix = createParticleOut(0.7)
    local sequenceActionsix = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionsix, stopActionsix)

    --原地光点
    local particleTwo = createParticle("ui_b001403", cc.p(0,15))
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local scaleToActionTwo  = createScaleTo(0, 1, 1)
    local delayNine1 = createParticleDelay(0.15)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionTwo = createParticleDelay(0.4)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleNine1,scaleToActionTwo,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    -- local node = createTotleAction(particleOne, sequenceActionOne)
    local node = createTotleAction(particleOne, sequenceActionOne,
                                   particlesix, sequenceActionsix, particleTwo, sequenceActionTwo)
    return node
end


function UI_dazaofuwen001()--打造符文

    --墓碑特效--  一闪
    local particleten = createParticle("ui_b002902", cc.p(351,601) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(0.75)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b002902")

    local scaleToActiotten  = createScaleTo(0.12, 2.7, 2.7)
    local delayActionten = createParticleDelay(0.3)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten, delayActionten,stopActionten)

    --墓碑颗粒--  爆
    local particlethirteen = createParticle("ui_b001913", cc.p(334,601) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(0.75)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001913")
    local scaleToActiotten  = createScaleTo(0.1, 2, 2)

    local delayActionthirteen = createParticleDelay(0.6)--持续时间
    local stopActionthirteen = createParticleOut(2)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten,delayActionthirteen, stopActionthirteen)

    --墓碑闪电--
    local particlethree = createParticle("ui_b001914", cc.p(334,601) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(1.45)
    local cistblethree2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001914")

    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(1)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,particletwelveClone,delayActionthree, stopActionthree)

    --墓碑火焰
    local particlefour = createParticle("ui_b000401", cc.p(334,601) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(0.75)
    local cistblefour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b000401")
    local scaleToActiotten  = createScaleTo(0.3, 2.1, 3)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(1)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,particletwelveClone,scaleToActiotten,delayActionfour,stopActionfour)

    --旋转的星星
    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(0.2)
    local cistbleTwo2 = createVistbleAction(true)

    local particleTwo= createParticle("ui_b001903", cc.p(0,555))
    local delayTwo = createParticleDelay(0)
    local bezierTwo1 = createRandomBezier(0.2, cc.p(88,396), cc.p(250,334), cc.p(410,333))
    local bezierTwo2 = createRandomBezier(0.1, cc.p(544,410), cc.p(605,535), cc.p(594,558))
    local bezierTwo3 = createRandomBezier(0.15, cc.p(544,700), cc.p(480,776), cc.p(311,775))
    local bezierTwo4 = createRandomBezier(0.1, cc.p(200,697), cc.p(238,595), cc.p(337,555))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,delayTwo, bezierTwo1, bezierTwo2, bezierTwo3, bezierTwo4,
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)

    --旋转的星星
    local cistblefive1 = createVistbleAction(false)
    local delayfive1 = createParticleDelay(0.2)
    local cistblefive2 = createVistbleAction(true)

    local particlefive= createParticle("ui_b002901", cc.p(610,950))
    local delayfive = createParticleDelay(0)
    local bezierfive1 = createRandomBezier(0.2, cc.p(461,936), cc.p(303,905), cc.p(192,832))
    local bezierfive2 = createRandomBezier(0.1, cc.p(115,709), cc.p(83,539), cc.p(152,406))
    local bezierfive3 = createRandomBezier(0.15, cc.p(312,363), cc.p(428,393), cc.p(517,494))
    local bezierfive4 = createRandomBezier(0.1, cc.p(519,627), cc.p(428,663), cc.p(337,555))
    local delayfive2 = createParticleDelay(0)
    local stopActionfive = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionfive = createSequence(cistblefive1,delayfive1,cistblefive2,delayfive, bezierfive1, bezierfive2, bezierfive3, bezierfive4,
                                              delayfive2,stopActionfive)
    local spawnActionfive = createSpawn(sequenceActionfive)


    --旋转的星星
    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(0.2)
    local cistblesix2 = createVistbleAction(true)

    local particlesix= createParticle("ui_b001703", cc.p(309,128))
    local delaysix = createParticleDelay(0)
    local beziersix1 = createRandomBezier(0.2, cc.p(468,220), cc.p(533,380), cc.p(550,539))
    local beziersix2 = createRandomBezier(0.1, cc.p(478,669), cc.p(349,739), cc.p(181,682))
    local beziersix3 = createRandomBezier(0.15, cc.p(103,589), cc.p(89,455), cc.p(174,353))
    local beziersix4 = createRandomBezier(0.1, cc.p(301,381), cc.p(350,473), cc.p(337,555))
    local delaysix2 = createParticleDelay(0)
    local stopActionsix = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionsix = createSequence(cistblesix1,delaysix1,cistblesix2,delaysix, beziersix1, beziersix2, beziersix3, beziersix4,
                                              delaysix2,stopActionsix)
    local spawnActionsix = createSpawn(sequenceActionsix)

    -- local img = game.newSprite("res/diyi.png")--战斗胜利
    -- img:setPosition(150, 585)
    -- img:setScale(1,1)

    local node = createTotleAction(particleten, sequenceActionten,particlethirteen, sequenceActionthirteen,
                                    particleTwo, spawnActionTwo,particlethree, sequenceActionthree,
                                    particlefour, sequenceActionfour,particlefive, sequenceActionfive,particlesix, sequenceActionsix
                                         )

    -- node:addChild(img, -1) -- to do
    return node
end


function UI_huoyuedu()--活跃度

    --图标特效-- 第一个
    local particleone = createParticle("ui_a000901", cc.p(0,0) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.2, 1.1, 1.1)
    local delayActionone = createParticleDelay(0.07)--持续时间
    local stopActionone = createParticleOut(0.2)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    local node = createTotleAction(particleone, sequenceActionone)

    return node
end


function UI_wushuangjiemian()--无双界面
    --火焰
    local particleOne = createParticle("ui_b000702", cc.p(320,755))
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.2, 1.4, 1.4)
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(scaleToActiotten,delayActionOne,stopActionOne)

    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_liantichixu()--炼体持续

    --图标特效-- 第一个
    local particleone = createParticle("ui_b003101", cc.p(165,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.2, 2.5)
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    --图标特效-- 第一个
    local particlefour = createParticle("ui_b003102", cc.p(165,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.8, 2.5)
    local delayActionfour = createParticleDelay(999)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第一个
    local particletwo = createParticle("ui_b003101", cc.p(295,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.13, 2.5)
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActiotten,delayActiontwo,stopActiontwo)

     --图标特效-- 第一个
    local particlefive = createParticle("ui_b003102", cc.p(295,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.6, 2.5)
    local delayActionfive = createParticleDelay(999)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)

    --图标特效-- 第一个
    local particlethree = createParticle("ui_b003101", cc.p(40,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.13, 2.5)
    local delayActionthree = createParticleDelay(999)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第一个
    local particlesix = createParticle("ui_b003102", cc.p(40,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.6, 2.5)
    local delayActionsix = createParticleDelay(999)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(scaleToActiotten,delayActionsix,stopActionsix)

    --图标特效-- 第一个
    local particleseven = createParticle("ui_b003103", cc.p(368,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.17, 2.5)
    local delayActionseven = createParticleDelay(999)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(scaleToActiotten,delayActionseven,stopActionseven)

    --图标特效-- 第一个
    local particleeight = createParticle("ui_b003103", cc.p(420,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.07, 2.5)
    local delayActioneight = createParticleDelay(999)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(scaleToActiotten,delayActioneight,stopActioneight)

    --图标特效-- 第一个
    local particlenine = createParticle("ui_b003103", cc.p(-37,-111) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.1, 0.14, 2.5)
    local delayActionnine = createParticleDelay(999)--持续时间
    local stopActionnine = createParticleOut(0.5)
    local sequenceActionnine = createSequence(scaleToActiotten,delayActionnine,stopActionnine)

    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,
                                   particlenine, sequenceActionnine)

    return node
end

function UI_liantichongci(callback)--炼体冲刺

    --墓碑特效--  一闪
    local particleten = createParticle("ui_b003206", cc.p(315,500) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(0.75)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003206")

    local scaleToActiotten  = createScaleTo(0.1, 0.22, 2.5)
    local delayActionten = createParticleDelay(0.9)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten, delayActionten,stopActionten)

    --墓碑颗粒--  爆
    local particlethirteen = createParticle("ui_b003207", cc.p(315,600) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1.7)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003207")
    local scaleToActiotten  = createScaleTo(0, 1., 1)

    local delayActionthirteen = createParticleDelay(0.4)--持续时间
    local stopActionthirteen = createParticleOut(1)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten,delayActionthirteen, stopActionthirteen)

    --墓碑闪电--
    local particlethree = createParticle("ui_b003102", cc.p(315,500) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(1.4)
    local cistblethree2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003102")
    local scaleToActiotten  = createScaleTo(0.1, 0.6, 2.5)

    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(1)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,particletwelveClone,scaleToActiotten,delayActionthree, stopActionthree)

    --墓碑火焰
    local particlefour = createParticle("ui_b003201", cc.p(315,500) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(0.7)
    local cistblefour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003201")
    local scaleToActiotten  = createScaleTo(0.3, 0.4, 5)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(1)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,particletwelveClone,scaleToActiotten,delayActionfour,stopActionfour)

    --旋转的星星

    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(0.2)
    local cistbleTwo2 = createVistbleAction(true)

    local particleTwo= createParticle("ui_b001703", cc.p(414,267))
    local delayTwo = createParticleDelay(0)
    local bezierTwo1 = createRandomBezier(0.2, cc.p(394,337), cc.p(326,391), cc.p(247,438))
    local bezierTwo2 = createRandomBezier(0.1, cc.p(237,493), cc.p(280,523), cc.p(336,549))
    local bezierTwo3 = createRandomBezier(0.15, cc.p(378,601), cc.p(339,647), cc.p(281,661))
    local bezierTwo4 = createRandomBezier(0.1, cc.p(252,695), cc.p(281,731), cc.p(328,761))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,delayTwo, bezierTwo1, bezierTwo2, bezierTwo3, bezierTwo4,
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)

    --旋转的星星

    local cistblefive1 = createVistbleAction(false)
    local delayfive1 = createParticleDelay(0.25)
    local cistblefive2 = createVistbleAction(true)

    local particlefive= createParticle("ui_b003202", cc.p(228,263))
    local delayfive = createParticleDelay(0)
    local bezierfive1 = createRandomBezier(0.2, cc.p(247,336), cc.p(314,390), cc.p(398,437))
    local bezierfive2 = createRandomBezier(0.1, cc.p(407,488), cc.p(364,520), cc.p(309,552))
    local bezierfive3 = createRandomBezier(0.15, cc.p(266,599), cc.p(300,644), cc.p(360,662))
    local bezierfive4 = createRandomBezier(0.1, cc.p(394,696), cc.p(361,733), cc.p(328,761))
    local delayfive2 = createParticleDelay(0)
    local stopActionfive = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionfive = createSequence(cistblefive1,delayfive1,cistblefive2,delayfive, bezierfive1, bezierfive2, bezierfive3, bezierfive4,
                                              delayfive2,stopActionfive)
    local spawnActionfive = createSpawn(sequenceActionfive)

    --旋转的星星

    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(0.5)
    local cistblesix2 = createVistbleAction(true)

    local particlesix= createParticle("ui_b001703", cc.p(314,787))
    local delaysix = createParticleDelay(0)
    local beziersix1 = createRandomBezier(0.2, cc.p(312,735), cc.p(315,694), cc.p(316,653))
    local beziersix2 = createRandomBezier(0.1, cc.p(314,605), cc.p(314,562), cc.p(313,513))
    local beziersix3 = createRandomBezier(0.15, cc.p(313,472), cc.p(312,432), cc.p(314,389))
    local beziersix4 = createRandomBezier(0.1, cc.p(314,340), cc.p(316,295), cc.p(316,226))
    local delaysix2 = createParticleDelay(0)
    local stopActionsix = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionsix = createSequence(cistblesix1,delaysix1,cistblesix2,delaysix, beziersix1, beziersix2, beziersix3, beziersix4,
                                              delaysix2,stopActionsix)
    local spawnActionsix = createSpawn(sequenceActionsix)

    --图标变亮
    local particleeight = createParticle("ui_b003205", cc.p(314,610) )
    -- local moveOne = createParticleMove(cc.p())
    local cistbleeight1 = createVistbleAction(false)
    local delayeight1 = createParticleDelay(0.8)
    local cistbleeight2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003205")
    local scaleToActiotten  = createScaleTo(0.1, 1, 1)
    local delayActioneight = createParticleDelay(1)--持续时间
    local stopActioneight = createParticleOut(0.3)
    local callbackAct1 = createCallFun(callback) -- 回调以显示

    local sequenceActioneight = createSequence(cistbleeight1,delayeight1,cistbleeight2,particletwelveClone,scaleToActiotten,delayActioneight,stopActioneight,callbackAct1)

     --图标变亮
    local particleseven = createParticle("ui_b003204", cc.p(316,610) )
    -- local moveOne = createParticleMove(cc.p())
    local cistbleseven1 = createVistbleAction(false)
    local delayseven1 = createParticleDelay(1.8)
    local cistbleseven2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003204")
    local scaleToActiotten  = createScaleTo(0.1, 1.6, 1.6)
    local delayActionseven = createParticleDelay(0.08)--持续时间
    local stopActionseven = createParticleOut(0.05)

    local sequenceActionseven = createSequence(cistbleseven1,delayseven1,cistbleseven2,particletwelveClone,scaleToActiotten,delayActionseven,stopActionseven)

    local node = createTotleAction(particleten, sequenceActionten,
                                    particleTwo, spawnActionTwo,particlethree, sequenceActionthree,particlethirteen, sequenceActionthirteen,
                                    particlefour, sequenceActionfour,particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven,
                                    particleeight, sequenceActioneight    )

    return node
end

function UI_fuwenjiemian004(addRunes)--符文界面001  法防  type 1 镶嵌  2 删除
    local particleList = {}

    --图标特效-- 第一个
    local particleone = createParticle("ui_b004001", cc.p(237,477) )
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(2)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local action1 = {}
    action1.particle = particleone
    action1.sequenceAction = sequenceActionone
    table.insert(particleList, action1)
    --图标特效-- 第二个
    local particletwo = createParticle("ui_b004002", cc.p(238,397) )

    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(2)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    local action2 = {}
    action2.particle = particletwo
    action2.sequenceAction = sequenceActiontwo
    table.insert(particleList, action2)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b004003", cc.p(320,335) )

    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(2)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    local action3 = {}
    action3.particle = particlethree
    action3.sequenceAction = sequenceActionthree
    table.insert(particleList, action3)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b004004", cc.p(415,418) )

    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(2)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    local action4 = {}
    action4.particle = particlefour
    action4.sequenceAction = sequenceActionfour
    table.insert(particleList, action4)

    --图标特效-- 第五个
    local particlefive = createParticle("ui_b004005", cc.p(366,517) )

    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(2)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    local action5 = {}
    action5.particle = particlefive
    action5.sequenceAction = sequenceActionfive
    table.insert(particleList, action5)

    --图标特效-- 第六个
    local particlesix = createParticle("ui_b004006", cc.p(291,470) )

    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(2)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    local action6 = {}
    action6.particle = particlesix
    action6.sequenceAction = sequenceActionsix
    table.insert(particleList, action6)

    --图标特效-- 第七个
    local particleseven = createParticle("ui_b004007", cc.p(290,406) )

    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(2)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    local action7 = {}
    action7.particle = particleseven
    action7.sequenceAction = sequenceActionseven
    table.insert(particleList, action7)

    --图标特效-- 第八个
    local particleeight = createParticle("ui_b004008", cc.p(368,372) )

    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(2)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    local action8 = {}
    action8.particle = particleeight
    action8.sequenceAction = sequenceActioneight
    table.insert(particleList, action8)

    --图标特效-- 第九个
    local particlenine = createParticle("ui_b004009", cc.p(372,448) )

    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(2)
    local sequenceActionnine = createSequence(delayActionnine,stopActionnine)

    local action9 = {}
    action9.particle = particlenine
    action9.sequenceAction = sequenceActionnine
    table.insert(particleList, action9)

    --图标特效-- 第十个
    local particleten = createParticle("ui_b004010", cc.p(336,436) )

    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(2)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local action10 = {}
    action10.particle = particleten
    action10.sequenceAction = sequenceActionten
    table.insert(particleList, action10)

    for k,v in pairs(particleList) do
        local flag = false
        for m, n in pairs(addRunes) do
            if k == n.runt_po then
                flag = true
            end
        end

        if not flag then
            particleList[k].particle:setVisible(false)
        end
    end

    local node = createTotleAction(particleList[1].particle, particleList[1].sequenceAction,particleList[2].particle, particleList[2].sequenceAction,particleList[3].particle, particleList[3].sequenceAction,particleList[4].particle, particleList[4].sequenceAction,
                                   particleList[5].particle, particleList[5].sequenceAction,particleList[6].particle, particleList[6].sequenceAction,particleList[7].particle, particleList[7].sequenceAction,particleList[8].particle, particleList[8].sequenceAction,
                                   particleList[9].particle, particleList[9].sequenceAction,particleList[10].particle, particleList[10].sequenceAction)

    return node
end

function UI_fuwenjiemian003(addRunes)--符文界面002
    local particleList = {}
    --图标特效-- 第一个
    local particleone = createParticle("ui_b004101", cc.p(231,477) )

    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(2)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local action1 = {}
    action1.particle = particleone
    action1.sequenceAction = sequenceActionone
    table.insert(particleList, action1)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b004102", cc.p(249,366) )

    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(2)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    local action2 = {}
    action2.particle = particletwo
    action2.sequenceAction = sequenceActiontwo
    table.insert(particleList, action2)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b004103", cc.p(368,344) )

    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(2)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    local action3 = {}
    action3.particle = particlethree
    action3.sequenceAction = sequenceActionthree
    table.insert(particleList, action3)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b004104", cc.p(434,455) )

    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(2)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    local action4 = {}
    action4.particle = particlefour
    action4.sequenceAction = sequenceActionfour
    table.insert(particleList, action4)

    --图标特效-- 第五个
    local particlefive = createParticle("ui_b004105", cc.p(336,536) )

    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(2)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    local action5 = {}
    action5.particle = particlefive
    action5.sequenceAction = sequenceActionfive
    table.insert(particleList, action5)


    --图标特效-- 第六个
    local particlesix = createParticle("ui_b004106", cc.p(294,491) )

    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(2)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    local action6 = {}
    action6.particle = particlesix
    action6.sequenceAction = sequenceActionsix
    table.insert(particleList, action6)

    --图标特效-- 第七个
    local particleseven = createParticle("ui_b004107", cc.p(270,395) )

    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(2)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    local action7 = {}
    action7.particle = particleseven
    action7.sequenceAction = sequenceActionseven
    table.insert(particleList, action7)

    --图标特效-- 第八个
    local particleeight = createParticle("ui_b004108", cc.p(345,418) )

    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(2)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    local action8 = {}
    action8.particle = particleeight
    action8.sequenceAction = sequenceActioneight
    table.insert(particleList, action8)

    --图标特效-- 第九个
    local particlenine = createParticle("ui_b004109", cc.p(361 ,363) )

    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(2)
    local sequenceActionnine = createSequence(delayActionnine,stopActionnine)

    local action9 = {}
    action9.particle = particlenine
    action9.sequenceAction = sequenceActionnine
    table.insert(particleList, action9)

    --图标特效-- 第十个
    local particleten = createParticle("ui_b004110", cc.p(413,430) )

    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(2)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local action10 = {}
    action10.particle = particleten
    action10.sequenceAction = sequenceActionten
    table.insert(particleList, action10)


    for k,v in pairs(particleList) do
        local flag = false
        for m, n in pairs(addRunes) do
            if k == n.runt_po then
                flag = true
            end
        end

        if not flag then
            particleList[k].particle:setVisible(false)
        end
    end

    local node = createTotleAction(particleList[1].particle, particleList[1].sequenceAction,particleList[2].particle, particleList[2].sequenceAction,particleList[3].particle, particleList[3].sequenceAction,particleList[4].particle, particleList[4].sequenceAction,
                                   particleList[5].particle, particleList[5].sequenceAction,particleList[6].particle, particleList[6].sequenceAction,particleList[7].particle, particleList[7].sequenceAction,particleList[8].particle, particleList[8].sequenceAction,
                                   particleList[9].particle, particleList[9].sequenceAction,particleList[10].particle, particleList[10].sequenceAction)


    return node
end

function UI_fuwenjiemian002(addRunes)--符文界面003
    local particleList = {}
    --图标特效-- 第一个
    local particleone = createParticle("ui_b004201", cc.p(247,392) )

    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(2)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local action1 = {}
    action1.particle = particleone
    action1.sequenceAction = sequenceActionone
    table.insert(particleList, action1)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b004202", cc.p(356,347) )

    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(2)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    local action2 = {}
    action2.particle = particletwo
    action2.sequenceAction = sequenceActiontwo
    table.insert(particleList, action2)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b004203", cc.p(433,415) )

    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(2)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    local action3 = {}
    action3.particle = particlethree
    action3.sequenceAction = sequenceActionthree
    table.insert(particleList, action3)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b004204", cc.p(422,496) )

    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(2)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    local action4 = {}
    action4.particle = particlefour
    action4.sequenceAction = sequenceActionfour
    table.insert(particleList, action4)

    --图标特效-- 第五个
    local particlefive = createParticle("ui_b004205", cc.p(348,532) )

    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(2)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    local action5 = {}
    action5.particle = particlefive
    action5.sequenceAction = sequenceActionfive
    table.insert(particleList, action5)

    --图标特效-- 第六个
    local particlesix = createParticle("ui_b004206", cc.p(301,489) )

    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(2)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    local action6 = {}
    action6.particle = particlesix
    action6.sequenceAction = sequenceActionsix
    table.insert(particleList, action6)

    --图标特效-- 第七个
    local particleseven = createParticle("ui_b004207", cc.p(295,422) )

    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(2)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    local action7 = {}
    action7.particle = particleseven
    action7.sequenceAction = sequenceActionseven
    table.insert(particleList, action7)

    --图标特效-- 第八个
    local particleeight = createParticle("ui_b004208", cc.p(320,385) )

    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(2)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    local action8 = {}
    action8.particle = particleeight
    action8.sequenceAction = sequenceActioneight
    table.insert(particleList, action8)

    --图标特效-- 第九个
    local particlenine = createParticle("ui_b004209", cc.p(365 ,464) )

    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(2)
    local sequenceActionnine = createSequence(delayActionnine,stopActionnine)

    local action9 = {}
    action9.particle = particlenine
    action9.sequenceAction = sequenceActionnine
    table.insert(particleList, action9)

    --图标特效-- 第十个
    local particleten = createParticle("ui_b004210", cc.p(385,411) )

    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(2)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local action10 = {}
    action10.particle = particleten
    action10.sequenceAction = sequenceActionten
    table.insert(particleList, action10)

    for k,v in pairs(particleList) do
        local flag = false
        for m, n in pairs(addRunes) do
            if k == n.runt_po then
                flag = true
            end
        end

        if not flag then
            particleList[k].particle:setVisible(false)
        end
    end

    local node = createTotleAction(particleList[1].particle, particleList[1].sequenceAction,particleList[2].particle, particleList[2].sequenceAction,particleList[3].particle, particleList[3].sequenceAction,particleList[4].particle, particleList[4].sequenceAction,
                                   particleList[5].particle, particleList[5].sequenceAction,particleList[6].particle, particleList[6].sequenceAction,particleList[7].particle, particleList[7].sequenceAction,particleList[8].particle, particleList[8].sequenceAction,
                                   particleList[9].particle, particleList[9].sequenceAction,particleList[10].particle, particleList[10].sequenceAction)


    return node
end

--符文界面004
function UI_fuwenjiemian001(addRunes)
    local particleList = {}

    --图标特效-- 第一个
    local particleone = createParticle("ui_b004301", cc.p(244,449) )

    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(2)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local action1 = {}
    action1.particle = particleone
    action1.sequenceAction = sequenceActionone
    table.insert(particleList, action1)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_b004302", cc.p(321,341) )

    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(2)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    local action2 = {}
    action2.particle = particletwo
    action2.sequenceAction = sequenceActiontwo
    table.insert(particleList, action2)

    --图标特效-- 第三个
    local particlethree = createParticle("ui_b004303", cc.p(412,377) )

    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(2)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    local action3 = {}
    action3.particle = particlethree
    action3.sequenceAction = sequenceActionthree
    table.insert(particleList, action3)

    --图标特效-- 第四个
    local particlefour = createParticle("ui_b004304", cc.p(427,476) )

    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(2)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    local action4 = {}
    action4.particle = particlefour
    action4.sequenceAction = sequenceActionfour
    table.insert(particleList, action4)

    --图标特效-- 第五个
    local particlefive = createParticle("ui_b004305", cc.p(337,539) )

    local delayActionfive = createParticleDelay(888)--持续时间
    local stopActionfive = createParticleOut(2)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    local action5 = {}
    action5.particle = particlefive
    action5.sequenceAction = sequenceActionfive
    table.insert(particleList, action5)

    --图标特效-- 第六个
    local particlesix = createParticle("ui_b004306", cc.p(300,487) )

    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(2)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    local action6 = {}
    action6.particle = particlesix
    action6.sequenceAction = sequenceActionsix
    table.insert(particleList, action6)

    --图标特效-- 第七个
    local particleseven = createParticle("ui_b004307", cc.p(306,400) )

    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(2)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    local action7 = {}
    action7.particle = particleseven
    action7.sequenceAction = sequenceActionseven
    table.insert(particleList, action7)

    --图标特效-- 第八个
    local particleeight = createParticle("ui_b004308", cc.p(385,379) )

    local delayActioneight = createParticleDelay(888)--持续时间
    local stopActioneight = createParticleOut(2)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    local action8 = {}
    action8.particle = particleeight
    action8.sequenceAction = sequenceActioneight
    table.insert(particleList, action8)

    --图标特效-- 第九个
    local particlenine = createParticle("ui_b004309", cc.p(392 ,433) )

    local delayActionnine = createParticleDelay(888)--持续时间
    local stopActionnine = createParticleOut(2)
    local sequenceActionnine = createSequence(delayActionnine,stopActionnine)

    local action9 = {}
    action9.particle = particlenine
    action9.sequenceAction = sequenceActionnine
    table.insert(particleList, action9)

    --图标特效-- 第十个
    local particleten = createParticle("ui_b004310", cc.p(367,480) )

    local delayActionten = createParticleDelay(888)--持续时间
    local stopActionten = createParticleOut(2)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    local action10 = {}
    action10.particle = particleten
    action10.sequenceAction = sequenceActionten
    table.insert(particleList, action10)

    for k,v in pairs(particleList) do
        local flag = false
        for m, n in pairs(addRunes) do
            if k == n.runt_po then
                flag = true
            end
        end

        if not flag then
            particleList[k].particle:setVisible(false)
        end
    end

    local node = createTotleAction(particleList[1].particle, particleList[1].sequenceAction,particleList[2].particle, particleList[2].sequenceAction,particleList[3].particle, particleList[3].sequenceAction,particleList[4].particle, particleList[4].sequenceAction,
                                   particleList[5].particle, particleList[5].sequenceAction,particleList[6].particle, particleList[6].sequenceAction,particleList[7].particle, particleList[7].sequenceAction,particleList[8].particle, particleList[8].sequenceAction,
                                   particleList[9].particle, particleList[9].sequenceAction,particleList[10].particle, particleList[10].sequenceAction)


    return node
end

function UI_chuancheng()--传承 b74

    --墓碑特效--  一闪
    local particleten = createParticle("ui_b005207", cc.p(480,655))
    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(2)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b005207")
    local scaleToActiotten  = createScaleTo(0, 1.6, 1.6)
    local delayActionten = createParticleDelay(0.2)--持续时间
    local stopActionten = createParticleOut(0.3)
    local sequenceActionten = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten, delayActionten,stopActionten)

    --墓碑特效--  一光
    local particleone = createParticle("ui_b003404", cc.p(480,655))
    local cistblethirone1 = createVistbleAction(false)
    local delaythirone1 = createParticleDelay(2.1)
    local cistblethirone2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b003404")
    local scaleToActiotone  = createScaleTo(0, 0.5, 0.5)
    local delayActionone = createParticleDelay(0.3)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(cistblethirone1,delaythirone1,cistblethirone2,particletwelveClone,scaleToActiotone, delayActionone,stopActionone)

    --墓碑颗粒--  爆
    local particlethirteen = createParticle("ui_b001913", cc.p(490,680))
    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1.8)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001913")
    local scaleToActiotten  = createScaleTo(0.12, 1, 1)
    local delayActionthirteen = createParticleDelay(0.6)--持续时间
    local stopActionthirteen = createParticleOut(2)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten,delayActionthirteen, stopActionthirteen)

    --墓碑闪电--  一闪
    local particlethree = createParticle("ui_b007401", cc.p(490,650))
    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(2.2)
    local cistblethree2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b007401")
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(1)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,particletwelveClone,scaleToActiotten,delayActionthree, stopActionthree)

    --墓碑火焰
    local particlefour = createParticle("ui_b000401", cc.p(490,630))
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(1.8)
    local cistblefour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b000401")
    local scaleToActiotten  = createScaleTo(0, 2.6, 2.5)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(1)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,particletwelveClone,scaleToActiotten,delayActionfour,stopActionfour)

    --旋转的星星
    local particleTwo= createParticle("ui_b007102", cc.p(158,657))
    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(0.9)
    local cistbleTwo2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b007102")
    local delayTwo = createParticleDelay(0.5)
    local bezierTwo1 = createRandomBezier(0.15, cc.p(190,600), cc.p(248,582), cc.p(304,603))
    local bezierTwo2 = createRandomBezier(0.2, cc.p(326,668), cc.p(350,742), cc.p(408,787))
    local bezierTwo3 = createRandomBezier(0.25, cc.p(482,824), cc.p(573,802), cc.p(615,717))
    local bezierTwo4 = createRandomBezier(0.3, cc.p(593,642), cc.p(528,601), cc.p(491,618))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,particletwelveClone,delayTwo, bezierTwo1, bezierTwo2, bezierTwo3, bezierTwo4,
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)

    --刚开始卡牌火焰
    local particleeight = createParticle("ui_b007404", cc.p(165,665))
    local cistbleeight1 = createVistbleAction(false)
    local delayeight1 = createParticleDelay(0.6)
    local cistbleeight2 = createVistbleAction(true)
    local scaleToActiotten  = createScaleTo(0, 1.1, 1.1)
    local delayActioneight = createParticleDelay(1.2)--持续时间
    local stopActioneight = createParticleOut(1)
    local sequenceActioneight = createSequence(cistbleeight1,delayeight1,cistbleeight2,scaleToActiotten,delayActioneight,stopActioneight)

    --收的法阵
    local particlefive= createParticle("ui_b007402", cc.p(165,665))
    local cistblefive1 = createVistbleAction(false)
    local delayfive1 = createParticleDelay(0.6)
    local cistblefive2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b007402")
    local scaleToActiotten  = createScaleTo(0, 0.9, 0.9)
    local delayActionfive = createParticleDelay(0.3)--持续时间
    local stopActionfive = createParticleOut(0.4)
    local sequenceActionfive = createSequence(cistblefive1,delayfive1,cistblefive2,particletwelveClone,scaleToActiotten,delayActionfive,stopActionfive)

    --收的颗粒
    local particlesix= createParticle("a0034_02", cc.p(165,665))
    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(0.6)
    local cistblesix2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("a0034_02")
    local scaleToActiotsix  = createScaleTo(0, 1.4, 1.4)
    local delayActionsix = createParticleDelay(0.3)--持续时间
    local stopActionsix = createParticleOut(0.4)
    local sequenceActionsix = createSequence(cistblesix1,delaysix1,cistblesix2,particletwelveClone,scaleToActiotsix,delayActionsix,stopActionsix)

    --刚开始的颗粒
    local particleseven= createParticle("ui_b007403", cc.p(165,665))
    local scaleToActiotseven  = createScaleTo(0, 1.25, 1.25)
    local delayActionseven = createParticleDelay(0.3)--持续时间
    local stopActionseven = createParticleOut(0.6)
    local sequenceActionseven = createSequence(scaleToActiotseven,delayActionseven,stopActionseven)

     local node = createTotleAction(particleseven, sequenceActionseven,particlesix, sequenceActionsix,particlefive, sequenceActionfive,particleeight, sequenceActioneight,
                                    particleten, sequenceActionten,particleone,
                                    sequenceActionone,particlethirteen, sequenceActionthirteen,
                                    particleTwo, spawnActionTwo,particlethree, sequenceActionthree,
                                    particlefour, sequenceActionfour)

    return node
end

function UI_liantijiemian()--炼体界面

    --图标特效-- 第1个
    local particleone = createParticle("ui_b004901", cc.p(312,570) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(1)--持续时间
    local stopActionone = createParticleOut(0)
    local sequenceActionone = createSequence(delayActionone,stopActionone)


    --图标特效-- 第2个
    local particletwo = createParticle("ui_b004902", cc.p(326,512) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(1)--持续时间
    local stopActiontwo = createParticleOut(0)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第3个
    local particlethree = createParticle("ui_b004903", cc.p(326,565) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.2, 1.2)
    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(0)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第4个
    local particlefour = createParticle("ui_b004904", cc.p(326,485) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.2, 1.2)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(0)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)





    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,particlefour, sequenceActionfour)


    return node
end

 --史诗符文特效 32
function UI_Fuwentexiao(effectList)
    local particleList = {}
    --绿色符文特效 生命
    local particletwo = createParticle("ui_a003202")
    -- local delayActiontwo = createParticleDelay(999)
    -- local stopActiontwo = createParticleOut(0.3, func)
    -- local sequenceActiontwo= createSequence(delayActiontwo, stopActiontwo)

    -- local particletwo = createParticle("ui_a003202", cc.p(450,686))
    local delayActiontwo = createParticleDelay(999)
    local stopActiontwo = createParticleOut(0.3, func)
    local sequenceActiontwo = createSequence(delayActiontwo, stopActiontwo)

    local effect1 = {}
    effect1.particle = particletwo
    effect1.sequenceAction = sequenceActiontwo
    table.insert(particleList, effect1)

    --红色符文特效 攻击
    local particleone = createParticle("ui_a003201")
    -- local delayActionone = createParticleDelay(999)
    -- local stopActionone = createParticleOut(0.3, func)
    -- local sequenceActionone= createSequence(delayActionone, stopActionone)

    -- local particleone = createParticle("ui_a003201", cc.p(440,456))
    local delayActionone = createParticleDelay(999)
    local stopActionone = createParticleOut(0.3, func)
    local sequenceActionone= createSequence(delayActionone, stopActionone)


    local effect2 = {}
    effect2.particle = particleone
    effect2.sequenceAction = sequenceActionone
    table.insert(particleList, effect2)

    --黄色符文特效 物防
    local particlethree = createParticle("ui_a003203")
    -- local delayActionthree = createParticleDelay(999)
    -- local stopActionthree = createParticleOut(0.3, func)
    -- local sequenceActionthree= createSequence(delayActionthree, stopActionthree)

    -- local particlethree = createParticle("ui_a003203", cc.p(193,720))
    local delayActionthree = createParticleDelay(999)
    local stopActionthree = createParticleOut(0.3, func)
    local sequenceActionthree= createSequence(delayActionthree, stopActionthree)

    local effect3 = {}
    effect3.particle = particlethree
    effect3.sequenceAction = sequenceActionthree
    table.insert(particleList, effect3)

    --蓝色符文特效 法防
    local particlefour = createParticle("ui_a003204")
    -- local delayActionfour = createParticleDelay(999)
    -- local stopActionfour = createParticleOut(0.3, func)
    -- local sequenceActionfour= createSequence(delayActionfour, stopActionfour)

    -- local particlefour = createParticle("ui_a003204", cc.p(188,435))
    local delayActionfour = createParticleDelay(999)
    local stopActionfour = createParticleOut(0.3, func)
    local sequenceActionfour= createSequence(delayActionfour, stopActionfour)

    local effect4 = {}
    effect4.particle = particlefour
    effect4.sequenceAction = sequenceActionfour
    table.insert(particleList, effect4)

    for k,v in pairs(particleList) do
        local flag = false
        for m, n in pairs(effectList) do
            if k == n.typeValue then
                flag = true
            end
        end

        if not flag then
            particleList[k].particle:setVisible(false)
        end
    end


    local node = createTotleAction(particleList[1].particle, particleList[1].sequenceAction, particleList[2].particle, particleList[2].sequenceAction, particleList[3].particle, particleList[3].sequenceAction,
                                   particleList[4].particle, particleList[4].sequenceAction)
    return node
end

--卡牌变身特效1 紫色
function UI_Wujiangzhuanhuanzise()

    -- 法阵
    local particleone = createParticle("ui_a003402", cc.p(320,740))
    local delayActionone = createParticleDelay(0.3)--持续时间
    local stopActionone = createParticleOut(0.4)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- 点点
    local particletwo = createParticle("ui_a003403", cc.p(320,740))
    local cistblethirtwo1 = createVistbleAction(false)
    local delaythirtwo = createParticleDelay(0.3)
    local cistblethirtwo2 = createVistbleAction(true)
    local delayActiontwo = createParticleDelay(0.5)--持续时间
    local stopActiontwo = createParticleOut(0.6)
    local sequenceActiontwo = createSequence(cistblethirtwo1,delaythirtwo,cistblethirtwo2,delayActiontwo,stopActiontwo)

    -- 雾
    local particlethree = createParticle("ui_a003401", cc.p(320,740))
    local cistblethirthree1 = createVistbleAction(false)
    local delaythirthree = createParticleDelay(0.35)
    local cistblethirthree2 = createVistbleAction(true)
    local delayActionthree = createParticleDelay(0.2)--持续时间
    local stopActionthree = createParticleOut(2)
    local sequenceActionthree = createSequence(cistblethirthree1,delaythirthree,cistblethirthree2,delayActionthree,stopActionthree)



    -- 闪电
    local particlefour = createParticle("ui_a003404", cc.p(320,740))
    local cistblethirfour1 = createVistbleAction(false)
    local delaythirfour = createParticleDelay(0.2)
    local cistblethirfour2 = createVistbleAction(true)
    local delayActionfour = createParticleDelay(0.3)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(cistblethirfour1,delaythirfour,cistblethirfour2,delayActionfour,stopActionfour)


    local node = createTotleAction(particlefour, sequenceActionfour,particleone, sequenceActionone,particletwo,
                                   sequenceActiontwo,particlethree, sequenceActionthree)


    return node
end

--卡牌变身特效2 橙色
function UI_Wujiangzhuanhuanchengse()

    -- 法阵
    local particleone = createParticle("ui_a003502", cc.p(320,740))
    local delayActionone = createParticleDelay(0.3)--持续时间
    local stopActionone = createParticleOut(0.4)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- 点点
    local particletwo = createParticle("ui_a003503", cc.p(320,740))
    local cistblethirtwo1 = createVistbleAction(false)
    local delaythirtwo = createParticleDelay(0.3)
    local cistblethirtwo2 = createVistbleAction(true)
    local delayActiontwo = createParticleDelay(0.5)--持续时间
    local stopActiontwo = createParticleOut(0.6)
    local sequenceActiontwo = createSequence(cistblethirtwo1,delaythirtwo,cistblethirtwo2,delayActiontwo,stopActiontwo)

    -- 雾
    local particlethree = createParticle("ui_a003501", cc.p(320,740))
    local cistblethirthree1 = createVistbleAction(false)
    local delaythirthree = createParticleDelay(0.35)
    local cistblethirthree2 = createVistbleAction(true)
    local delayActionthree = createParticleDelay(0.2)--持续时间
    local stopActionthree = createParticleOut(2)
    local sequenceActionthree = createSequence(cistblethirthree1,delaythirthree,cistblethirthree2,delayActionthree,stopActionthree)



    -- 闪电
    local particlefour = createParticle("ui_a003504", cc.p(320,740))
    local cistblethirfour1 = createVistbleAction(false)
    local delaythirfour = createParticleDelay(0.2)
    local cistblethirfour2 = createVistbleAction(true)
    local delayActionfour = createParticleDelay(0.3)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(cistblethirfour1,delaythirfour,cistblethirfour2,delayActionfour,stopActionfour)


    local node = createTotleAction(particlefour, sequenceActionfour,particleone, sequenceActionone,particletwo,
                                   sequenceActiontwo,particlethree, sequenceActionthree)


    return node
end

--符文炼化特效
function UI_lianHuajiemian()--符文炼化界面
    --图标特效-- 第一个
    local particlesix = createParticle("ui_b007901", cc.p(117,300) )
    local delayActionsix = createParticleDelay(1)--持续时间
    local stopActionsix = createParticleOut(0)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    --图标特效-- 第二个
    local particleseven = createParticle("ui_b007901", cc.p(250,300) )
    local delayActionseven = createParticleDelay(1)--持续时间
    local stopActionseven = createParticleOut(0)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    --图标特效-- 第三个
    local particleeight = createParticle("ui_b007901", cc.p(387,300) )
    local delayActioneight = createParticleDelay(1)--持续时间
    local stopActioneight = createParticleOut(0)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    --图标特效-- 第四个
    local particlenine = createParticle("ui_b007901", cc.p(524,300) )
    local delayActionnine = createParticleDelay(1)--持续时间
    local stopActionnine = createParticleOut(0)
    local sequenceActionnine = createSequence(delayActionnine,stopActionnine)

    --图标特效-- 第五个
    local particleten = createParticle("ui_b007901", cc.p(117,165) )
    local delayActionten = createParticleDelay(1)--持续时间
    local stopActionten = createParticleOut(0)
    local sequenceActionten = createSequence(delayActionten,stopActionten)

    --图标特效-- 第六个
    local particleeleven = createParticle("ui_b007901", cc.p(249,165) )
    local delayActioneleven = createParticleDelay(1)--持续时间
    local stopActioneleven = createParticleOut(0)
    local sequenceActioneleven = createSequence(delayActioneleven,stopActioneleven)

    --图标特效-- 第七个
    local particletwelve = createParticle("ui_b007901", cc.p(388,165) )
    local delayActiontwelve = createParticleDelay(1)--持续时间
    local stopActiontwelve = createParticleOut(0)
    local sequenceActiontwelve = createSequence(delayActiontwelve,stopActiontwelve)

    --图标特效-- 第八个
    local particlethirteen = createParticle("ui_b007901", cc.p(540,165) )
    local delayActionthirteen = createParticleDelay(1)--持续时间
    local stopActionthirteen = createParticleOut(0)
    local sequenceActionthirteen = createSequence(delayActionthirteen,stopActionthirteen)
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------

    --旋转的星星（第一个）
    local cistblefourteen1 = createVistbleAction(false)
    local delayfourteen1 = createParticleDelay(0.36)
    local cistblefourteen2 = createVistbleAction(true)
    local particlefourteen= createParticle("ui_b005107", cc.p(117,300))
    local delayfourteen = createParticleDelay(0)
    local bezierfourteen1 = createRandomBezier(0.4, cc.p(700,900), cc.p(320,900), cc.p(324,648), 300 , -300)
    local delayfourteen2 = createParticleDelay(0)
    local stopActionfourteen = createParticleOut(0.9)
    local sequenceActionfourteen = createSequence(cistblefourteen1,delayfourteen1,cistblefourteen2,delayfourteen, bezierfourteen1,delayfourteen2,stopActionfourteen)
    local spawnActionfourteen = createSpawn(sequenceActionfourteen)
    
    --旋转的星星（第二个）
    local cistblefifteen1 = createVistbleAction(false)
    local delayfifteen1 = createParticleDelay(0.36)
    local cistblefifteen2 = createVistbleAction(true)
    local particlefifteen= createParticle("ui_b005107", cc.p(250,300))
    local delayfifteen = createParticleDelay(0)
    local bezierfifteen1 = createRandomBezier(0.4, cc.p(800,1000), cc.p(320,600), cc.p(324,648), 300 , -300)
    local delayfifteen2 = createParticleDelay(0)
    local stopActionfifteen = createParticleOut(0.9)
    local sequenceActionfifteen = createSequence(cistblefifteen1,delayfifteen1,cistblefifteen2,delayfifteen, bezierfifteen1,delayfifteen2,stopActionfifteen)
    local spawnActionfifteen = createSpawn(sequenceActionfifteen)

    --旋转的星星（第三个）
    local cistblesixteen1 = createVistbleAction(false)
    local delaysixteen1 = createParticleDelay(0.36)
    local cistblesixteen2 = createVistbleAction(true)
    local particlesixteen= createParticle("ui_b005107", cc.p(387,300))
    local delaysixteen = createParticleDelay(0)
    local beziersixteen1 = createRandomBezier(0.4, cc.p(500,400), cc.p(320,700), cc.p(324,648), 300 , -300)
    local delaysixteen2 = createParticleDelay(0)
    local stopActionsixteen = createParticleOut(0.9)
    local sequenceActionsixteen = createSequence(cistblesixteen1,delaysixteen1,cistblesixteen2,delaysixteen, beziersixteen1,delaysixteen2,stopActionsixteen)
    local spawnActionsixteen = createSpawn(sequenceActionsixteen)

    --旋转的星星（第四个）
    local cistbleseventeen1 = createVistbleAction(false)
    local delayseventeen1 = createParticleDelay(0.36)
    local cistbleseventeen2 = createVistbleAction(true)
    local particleseventeen= createParticle("ui_b005107", cc.p(524,300))
    local delayseventeen = createParticleDelay(0)
    local bezierseventeen1 = createRandomBezier(0.4, cc.p(-300,400), cc.p(320,700), cc.p(324,648), 300 , -300)
    local delayseventeen2 = createParticleDelay(0)
    local stopActionseventeen = createParticleOut(0.9)
    local sequenceActionseventeen = createSequence(cistbleseventeen1,delayseventeen1,cistbleseventeen2,delayseventeen, bezierseventeen1,delayseventeen2,stopActionseventeen)
    local spawnActionseventeen = createSpawn(sequenceActionseventeen)

    --旋转的星星（第五个）
    local cistbleeighteen1 = createVistbleAction(false)
    local delayeighteen1 = createParticleDelay(0.36)
    local cistbleeighteen2 = createVistbleAction(true)
    local particleeighteen= createParticle("ui_b005107", cc.p(117,180))
    local delayeighteen = createParticleDelay(0)
    local beziereighteen1 = createRandomBezier(0.4, cc.p(-100,900), cc.p(600,900), cc.p(324,648), 300 , -300)
    local delayeighteen2 = createParticleDelay(0)
    local stopActioneighteen = createParticleOut(0.9)
    local sequenceActioneighteen = createSequence(cistbleeighteen1,delayeighteen1,cistbleeighteen2,delayeighteen, beziereighteen1, delayeighteen2,stopActioneighteen)
    local spawnActioneighteen = createSpawn(sequenceActioneighteen)

    --旋转的星星（第六个）
    local cistblenineteen1 = createVistbleAction(false)
    local delaynineteen1 = createParticleDelay(0.36)
    local cistblenineteen2 = createVistbleAction(true)
    local particlenineteen= createParticle("ui_b005107", cc.p(249,180))
    local delaynineteen = createParticleDelay(0)
    local beziernineteen1 = createRandomBezier(0.4, cc.p(100,500), cc.p(400,900), cc.p(324,648), 300 , -300)
    local delaynineteen2 = createParticleDelay(0)
    local stopActionnineteen = createParticleOut(0.9)
    local sequenceActionnineteen = createSequence(cistblenineteen1,delaynineteen1,cistblenineteen2,delaynineteen, beziernineteen1,delaynineteen2,stopActionnineteen)
    local spawnActionnineteen = createSpawn(sequenceActionnineteen)

    --旋转的星星（第七个）
    local cistbletwenty1 = createVistbleAction(false)
    local delaytwenty1 = createParticleDelay(0.36)
    local cistbletwenty2 = createVistbleAction(true)
    local particletwenty= createParticle("ui_b005107", cc.p(388,180))
    local delaytwenty = createParticleDelay(0)
    local beziertwenty1 = createRandomBezier(0.4, cc.p(200,200), cc.p(500,900), cc.p(324,648), 300 , -300)
    local delaytwenty2 = createParticleDelay(0)
    local stopActiontwenty = createParticleOut(0.9)
    local sequenceActiontwenty = createSequence(cistbletwenty1,delaytwenty1,cistbletwenty2,delaytwenty, beziertwenty1,delaytwenty2,stopActiontwenty)
    local spawnActiontwenty = createSpawn(sequenceActiontwenty)

    --旋转的星星（第八个）
    local cistbletwentyone1 = createVistbleAction(false)
    local delaytwentyone1 = createParticleDelay(0.36)
    local cistbletwentyone2 = createVistbleAction(true)
    local particletwentyone= createParticle("ui_b005107", cc.p(522,180))
    local delaytwentyone = createParticleDelay(0)
    local beziertwentyone1 = createRandomBezier(0.4, cc.p(600,300), cc.p(400,900), cc.p(324,648), 300 , -300)
    local delaytwentyone2 = createParticleDelay(0)
    local stopActiontwentyone = createParticleOut(0.9)
    local sequenceActiontwentyone = createSequence(cistbletwentyone1,delaytwentyone1,cistbletwentyone2,delaytwentyone, beziertwentyone1,delaytwentyone2,stopActiontwentyone)
    local spawnActiontwentyone = createSpawn(sequenceActiontwentyone)

--------------------------------------------------------------------------------------------------------------------------------------------------------------

    --图标特效-- 塔亮
    local particleone = createParticle("ui_b004901", cc.p(309,650) )
    local cistbleone1 = createVistbleAction(false)
    local delayone1 = createParticleDelay(0.1)
    local cistbleone2 = createVistbleAction(true)
    local delayActionone = createParticleDelay(1)--持续时间
    local stopActionone = createParticleOut(0)
    local sequenceActionone = createSequence(cistbleone1,delayone1,cistbleone2,delayActionone,stopActionone)

    --图标特效-- 周围印亮
    local particletwo = createParticle("ui_b004902", cc.p(326,580) )
    local cistbletwo1 = createVistbleAction(false)
    local delaytwo1 = createParticleDelay(0.1)
    local cistbletwo2 = createVistbleAction(true)
    local delayActiontwo = createParticleDelay(1)--持续时间
    local stopActiontwo = createParticleOut(00)
    local sequenceActiontwo = createSequence(cistbletwo1,delaytwo1,cistbletwo2,delayActiontwo,stopActiontwo)

    --图标特效-- 冲刺光条
    local particlethree = createParticle("ui_b004903", cc.p(326,590) )
    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(0.1)
    local cistblethree2 = createVistbleAction(true)
    local scaleToActiotten  = createScaleTo(0, 0.2, 1.2)
    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(0)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 冲刺光条宽的
    local particlefour = createParticle("ui_b004904", cc.p(326,570) )
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(0.1)
    local cistblefour2 = createVistbleAction(true)
    local scaleToActiotten  = createScaleTo(0, 0.2, 1.2)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(0)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,scaleToActiotten,delayActionfour,stopActionfour)

--------------------------------------------------------------------------------------------------------------------------------------------------------------

    --中心爆点--
    local particletwentyfour = createParticle("ui_a000107", cc.p(312,650) )
    local cistblethirtwentyfour1 = createVistbleAction(false)
    local scaleToActiottwentyfour  = createScaleTo(0.07, 0.85, 0.85)
    local delaythirtwentyfour1 = createParticleDelay(0.75)
    local cistblethirtwentyfour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_a000107")
    local delayActiontwentyfour = createParticleDelay(0.1)--持续时间
    local stopActiontwentyfour = createParticleOut(0.1)
    local sequenceActiontwentyfour = createSequence(cistblethirtwentyfour1,scaleToActiottwentyfour, delaythirtwentyfour1,cistblethirtwentyfour2,particletwelveClone,delayActiontwentyfour,stopActiontwentyfour)
    --中心爆点--
    local particletwentyfive = createParticle("ui_b005111", cc.p(318,650) )
    local cistblethirtwentyfive1 = createVistbleAction(false)
    local delaythirtwentyfive1 = createParticleDelay(0.75)
    local cistblethirtwentyfive2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b005111")
    local scaleToActiottwentyfive  = createScaleTo(0.0, 1, 1)
    local delayActiontwentyfive = createParticleDelay(0.4)--持续时间
    local stopActiontwentyfive = createParticleOut(0.4)
    local sequenceActiontwentyfive = createSequence(cistblethirtwentyfive1,delaythirtwentyfive1,cistblethirtwentyfive2,particletwelveClone,scaleToActiottwentyfive,delayActiontwentyfive,stopActiontwentyfive)

    --中心爆点--
    local particletwentysix = createParticle("ui_b005112", cc.p(318,650) )
    local cistblethirtwentysix1 = createVistbleAction(false)
    local delaythirtwentysix1 = createParticleDelay(0.75)
    local cistblethirtwentysix2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b005112")
    local scaleToActiottwentysix  = createScaleTo(0., 0.44, 0.44)
    local delayActiontwentysix = createParticleDelay(0.4)--持续时间
    local stopActiontwentysix = createParticleOut(1)
    local sequenceActiontwentysix = createSequence(cistblethirtwentysix1,delaythirtwentysix1,cistblethirtwentysix2,particletwelveClone,scaleToActiottwentysix,delayActiontwentysix,stopActiontwentysix)
  
    local node = createTotleAction(particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,particlenine, sequenceActionnine,
                                   particleten, sequenceActionten,particleeleven, sequenceActioneleven,particletwelve, sequenceActiontwelve,particlethirteen, sequenceActionthirteen,
                                   particlefourteen, spawnActionfourteen,

                                   particlefifteen, spawnActionfifteen,particlesixteen, spawnActionsixteen,
                                   particleseventeen, spawnActionseventeen,particleeighteen, spawnActioneighteen,particlenineteen, spawnActionnineteen,

                                   particletwenty, spawnActiontwenty,particletwentyone, spawnActiontwentyone,
                                   -- particletwentytwo, sequenceActiontwentytwo,
                                   particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,
                                   particlefour, sequenceActionfour,
                                   particletwentyfour, sequenceActiontwentyfour,particletwentyfive, sequenceActiontwentyfive,
                                   particletwentysix, sequenceActiontwentysix)
    return node
end


-- function UI_lianHuajiemian()--符文炼化界面
--     --图标特效-- 第一个
--     local particlesix = createParticle("ui_b005106", cc.p(498,657) )
--     local delayActionsix = createParticleDelay(0.3)--持续时间
--     local stopActionsix = createParticleOut(0)
--     local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

--     --图标特效-- 第一个
--     local particleseven = createParticle("ui_b005106", cc.p(546,562) )
--     local delayActionseven = createParticleDelay(0.3)--持续时间
--     local stopActionseven = createParticleOut(0)
--     local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

--     --图标特效-- 第一个
--     local particleeight = createParticle("ui_b005106", cc.p(548,469) )
--     local delayActioneight = createParticleDelay(0.3)--持续时间
--     local stopActioneight = createParticleOut(0)
--     local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

--     --图标特效-- 第一个
--     local particlenine = createParticle("ui_b005106", cc.p(497,374) )
--     local delayActionnine = createParticleDelay(0.3)--持续时间
--     local stopActionnine = createParticleOut(0)
--     local sequenceActionnine = createSequence(delayActionnine,stopActionnine)

--     --图标特效-- 第一个
--     local particleten = createParticle("ui_b005106", cc.p(155,376) )
--     local delayActionten = createParticleDelay(0.3)--持续时间
--     local stopActionten = createParticleOut(0)
--     local sequenceActionten = createSequence(delayActionten,stopActionten)

--     --图标特效-- 第一个
--     local particleeleven = createParticle("ui_b005106", cc.p(111,470) )
--     local delayActioneleven = createParticleDelay(0.3)--持续时间
--     local stopActioneleven = createParticleOut(0)
--     local sequenceActioneleven = createSequence(delayActioneleven,stopActioneleven)

--     --图标特效-- 第一个
--     local particletwelve = createParticle("ui_b005106", cc.p(111,563) )
--     local delayActiontwelve = createParticleDelay(0.3)--持续时间
--     local stopActiontwelve = createParticleOut(0)
--     local sequenceActiontwelve = createSequence(delayActiontwelve,stopActiontwelve)

--     --图标特效-- 第一个
--     local particlethirteen = createParticle("ui_b005106", cc.p(154,657) )
--     local delayActionthirteen = createParticleDelay(0.3)--持续时间
--     local stopActionthirteen = createParticleOut(0)
--     local sequenceActionthirteen = createSequence(delayActionthirteen,stopActionthirteen)

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

--     --旋转的星星
--     local cistblefourteen1 = createVistbleAction(false)
--     local delayfourteen1 = createParticleDelay(0.26)
--     local cistblefourteen2 = createVistbleAction(true)
--     local particlefourteen= createParticle("ui_b005107", cc.p(498,657))
--     local delayfourteen = createParticleDelay(0)
--     local bezierfourteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(317,557), 300 , -300)
--     local delayfourteen2 = createParticleDelay(0)
--     local stopActionfourteen = createParticleOut(0.9)
--     local sequenceActionfourteen = createSequence(cistblefourteen1,delayfourteen1,cistblefourteen2,delayfourteen, bezierfourteen1,delayfourteen2,stopActionfourteen)
--     local spawnActionfourteen = createSpawn(sequenceActionfourteen)

--     --旋转的星星
--     local cistblefifteen1 = createVistbleAction(false)
--     local delayfifteen1 = createParticleDelay(0.26)
--     local cistblefifteen2 = createVistbleAction(true)
--     local particlefifteen= createParticle("ui_b005107", cc.p(546,562))
--     local delayfifteen = createParticleDelay(0)
--     local bezierfifteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(317,557), 300 , -300)
--     local delayfifteen2 = createParticleDelay(0)
--     local stopActionfifteen = createParticleOut(0.9)
--     local sequenceActionfifteen = createSequence(cistblefifteen1,delayfifteen1,cistblefifteen2,delayfifteen, bezierfifteen1,delayfifteen2,stopActionfifteen)
--     local spawnActionfifteen = createSpawn(sequenceActionfifteen)

--     --旋转的星星
--     local cistblesixteen1 = createVistbleAction(false)
--     local delaysixteen1 = createParticleDelay(0.26)
--     local cistblesixteen2 = createVistbleAction(true)
--     local particlesixteen= createParticle("ui_b005107", cc.p(548,469))
--     local delaysixteen = createParticleDelay(0)
--     local beziersixteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(317,557), 300 , -300)
--     local delaysixteen2 = createParticleDelay(0)
--     local stopActionsixteen = createParticleOut(0.9)
--     local sequenceActionsixteen = createSequence(cistblesixteen1,delaysixteen1,cistblesixteen2,delaysixteen, beziersixteen1,delaysixteen2,stopActionsixteen)
--     local spawnActionsixteen = createSpawn(sequenceActionsixteen)

--     --旋转的星星
--     local cistbleseventeen1 = createVistbleAction(false)
--     local delayseventeen1 = createParticleDelay(0.26)
--     local cistbleseventeen2 = createVistbleAction(true)
--     local particleseventeen= createParticle("ui_b005107", cc.p(497,374))
--     local delayseventeen = createParticleDelay(0)
--     local bezierseventeen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(317,557), 300 , -300)
--     local delayseventeen2 = createParticleDelay(0)
--     local stopActionseventeen = createParticleOut(0.9)
--     local sequenceActionseventeen = createSequence(cistbleseventeen1,delayseventeen1,cistbleseventeen2,delayseventeen, bezierseventeen1,delayseventeen2,stopActionseventeen)
--     local spawnActionseventeen = createSpawn(sequenceActionseventeen)

--     --旋转的星星
--     local cistbleeighteen1 = createVistbleAction(false)
--     local delayeighteen1 = createParticleDelay(0.26)
--     local cistbleeighteen2 = createVistbleAction(true)
--     local particleeighteen= createParticle("ui_b005107", cc.p(155,376))
--     local delayeighteen = createParticleDelay(0)
--     local beziereighteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(317,557), 300 , -300)
--     local delayeighteen2 = createParticleDelay(0)
--     local stopActioneighteen = createParticleOut(0.9)
--     local sequenceActioneighteen = createSequence(cistbleeighteen1,delayeighteen1,cistbleeighteen2,delayeighteen, beziereighteen1, delayeighteen2,stopActioneighteen)
--     local spawnActioneighteen = createSpawn(sequenceActioneighteen)

--     --旋转的星星
--     local cistblenineteen1 = createVistbleAction(false)
--     local delaynineteen1 = createParticleDelay(0.26)
--     local cistblenineteen2 = createVistbleAction(true)
--     local particlenineteen= createParticle("ui_b005107", cc.p(111,470))
--     local delaynineteen = createParticleDelay(0)
--     local beziernineteen1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(317,557), 300 , 600)
--     local delaynineteen2 = createParticleDelay(0)
--     local stopActionnineteen = createParticleOut(0.9)
--     local sequenceActionnineteen = createSequence(cistblenineteen1,delaynineteen1,cistblenineteen2,delaynineteen, beziernineteen1,delaynineteen2,stopActionnineteen)
--     local spawnActionnineteen = createSpawn(sequenceActionnineteen)

--     --旋转的星星
--     local cistbletwenty1 = createVistbleAction(false)
--     local delaytwenty1 = createParticleDelay(0.26)
--     local cistbletwenty2 = createVistbleAction(true)
--     local particletwenty= createParticle("ui_b005107", cc.p(127,548))
--     local delaytwenty = createParticleDelay(0)
--     local beziertwenty1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(317,557), 300 , 600)
--     local delaytwenty2 = createParticleDelay(0)
--     local stopActiontwenty = createParticleOut(0.9)
--     local sequenceActiontwenty = createSequence(cistbletwenty1,delaytwenty1,cistbletwenty2,delaytwenty, beziertwenty1,delaytwenty2,stopActiontwenty)
--     local spawnActiontwenty = createSpawn(sequenceActiontwenty)

--     --旋转的星星
--     local cistbletwentyone1 = createVistbleAction(false)
--     local delaytwentyone1 = createParticleDelay(0.26)
--     local cistbletwentyone2 = createVistbleAction(true)
--     local particletwentyone= createParticle("ui_b005107", cc.p(111,563))
--     local delaytwentyone = createParticleDelay(0)
--     local beziertwentyone1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(317,557), 300 , 600)
--     local delaytwentyone2 = createParticleDelay(0)
--     local stopActiontwentyone = createParticleOut(0.9)
--     local sequenceActiontwentyone = createSequence(cistbletwentyone1,delaytwentyone1,cistbletwentyone2,delaytwentyone, beziertwentyone1,delaytwentyone2,stopActiontwentyone)
--     local spawnActiontwentyone = createSpawn(sequenceActiontwentyone)

--     --旋转的星星
--     local cistbletwentytwo1 = createVistbleAction(false)
--     local delaytwentytwo1 = createParticleDelay(0.26)
--     local cistbletwentytwo2 = createVistbleAction(true)
--     local particletwentytwo= createParticle("ui_b005107", cc.p(154,657))
--     local delaytwentytwo = createParticleDelay(0)
--     local beziertwentytwo1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(317,557), 300 , 600)
--     local delaytwentytwo2 = createParticleDelay(0)
--     local stopActiontwentytwo = createParticleOut(0.9)
--     local sequenceActiontwentytwo = createSequence(cistbletwentytwo1,delaytwentytwo1,cistbletwentytwo2,delaytwentytwo, beziertwentytwo1,delaytwentytwo2,stopActiontwentytwo)
--     local spawnActiontwentytwo = createSpawn(sequenceActiontwentytwo)

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

--     --图标特效-- 第一个
--     local particleone = createParticle("ui_b004901", cc.p(312,570) )
--     local cistbleone1 = createVistbleAction(false)
--     local delayone1 = createParticleDelay(0)
--     local cistbleone2 = createVistbleAction(true)
--     local delayActionone = createParticleDelay(1)--持续时间
--     local stopActionone = createParticleOut(0)
--     local sequenceActionone = createSequence(cistbleone1,delayone1,cistbleone2,delayActionone,stopActionone)

--     --图标特效-- 第一个
--     local particletwo = createParticle("ui_b004902", cc.p(326,512) )
--     local cistbletwo1 = createVistbleAction(false)
--     local delaytwo1 = createParticleDelay(0)
--     local cistbletwo2 = createVistbleAction(true)
--     local delayActiontwo = createParticleDelay(1)--持续时间
--     local stopActiontwo = createParticleOut(00)
--     local sequenceActiontwo = createSequence(cistbletwo1,delaytwo1,cistbletwo2,delayActiontwo,stopActiontwo)

--     --图标特效-- 第一个
--     local particlethree = createParticle("ui_b004903", cc.p(326,565) )
--     local cistblethree1 = createVistbleAction(false)
--     local delaythree1 = createParticleDelay(0)
--     local cistblethree2 = createVistbleAction(true)
--     local scaleToActiotten  = createScaleTo(0, 0.2, 1.2)
--     local delayActionthree = createParticleDelay(1)--持续时间
--     local stopActionthree = createParticleOut(0)
--     local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,scaleToActiotten,delayActionthree,stopActionthree)

--     --图标特效-- 第一个
--     local particlefour = createParticle("ui_b004904", cc.p(326,485) )
--     local cistblefour1 = createVistbleAction(false)
--     local delayfour1 = createParticleDelay(0)
--     local cistblefour2 = createVistbleAction(true)
--     local scaleToActiotten  = createScaleTo(0, 0.2, 1.2)
--     local delayActionfour = createParticleDelay(1)--持续时间
--     local stopActionfour = createParticleOut(0)
--     local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,scaleToActiotten,delayActionfour,stopActionfour)

--     --图标特效-- 第一个
--     local particlefive = createParticle("ui_b005201", cc.p(318,516) )
--     local cistblefive1 = createVistbleAction(false)
--     local delayfive1 = createParticleDelay(0)
--     local cistblefive2 = createVistbleAction(true)
--     local delayActionfive = createParticleDelay(1)--持续时间
--     local stopActionfive = createParticleOut(0)
--     local sequenceActionfive = createSequence(cistblefive1,delayfive1,cistblefive2,delayActionfive,stopActionfive)

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

--         --中心爆点--
--     local particletwentyfour = createParticle("ui_a000107", cc.p(312,525) )
--     local cistblethirtwentyfour1 = createVistbleAction(false)
--     local scaleToActiottwentyfour  = createScaleTo(0.07, 0.85, 0.85)
--     local delaythirtwentyfour1 = createParticleDelay(0.8)
--     local cistblethirtwentyfour2 = createVistbleAction(true)
--     local particletwelveClone = createRestartAction("ui_a000107")
--     local delayActiontwentyfour = createParticleDelay(0.1)--持续时间
--     local stopActiontwentyfour = createParticleOut(0.1)
--     local sequenceActiontwentyfour = createSequence(cistblethirtwentyfour1,scaleToActiottwentyfour, delaythirtwentyfour1,cistblethirtwentyfour2,particletwelveClone,delayActiontwentyfour,stopActiontwentyfour)
--     --中心爆点--
--     local particletwentyfive = createParticle("ui_b005111", cc.p(318,516) )
--     local cistblethirtwentyfive1 = createVistbleAction(false)
--     local delaythirtwentyfive1 = createParticleDelay(0.8)
--     local cistblethirtwentyfive2 = createVistbleAction(true)
--     local particletwelveClone = createRestartAction("ui_b005111")
--     local scaleToActiottwentyfive  = createScaleTo(0.0, 1, 1)
--     local delayActiontwentyfive = createParticleDelay(0.4)--持续时间
--     local stopActiontwentyfive = createParticleOut(0.4)
--     local sequenceActiontwentyfive = createSequence(cistblethirtwentyfive1,delaythirtwentyfive1,cistblethirtwentyfive2,particletwelveClone,scaleToActiottwentyfive,delayActiontwentyfive,stopActiontwentyfive)

--     --中心爆点--
--     local particletwentysix = createParticle("ui_b005112", cc.p(318,516) )
--     local cistblethirtwentysix1 = createVistbleAction(false)
--     local delaythirtwentysix1 = createParticleDelay(0.8)
--     local cistblethirtwentysix2 = createVistbleAction(true)
--     local particletwelveClone = createRestartAction("ui_b005112")
--     local scaleToActiottwentysix  = createScaleTo(0., 0.44, 0.44)
--     local delayActiontwentysix = createParticleDelay(0.4)--持续时间
--     local stopActiontwentysix = createParticleOut(1)
--     local sequenceActiontwentysix = createSequence(cistblethirtwentysix1,delaythirtwentysix1,cistblethirtwentysix2,particletwelveClone,scaleToActiottwentysix,delayActiontwentysix,stopActiontwentysix)

--     local node = createTotleAction(particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,particlenine, sequenceActionnine,
--                                    particleten, sequenceActionten,particleeleven, sequenceActioneleven,particletwelve, sequenceActiontwelve,particlethirteen, sequenceActionthirteen,
--                                    particlefourteen, sequenceActionfourteen,

--                                    particlefifteen, sequenceActionfifteen,particlesixteen, sequenceActionsixteen,
--                                    particleseventeen, sequenceActionseventeen,particleeighteen, sequenceActioneighteen,particlenineteen, sequenceActionnineteen,

--                                    particletwenty, sequenceActiontwenty,particletwentyone, sequenceActiontwentyone,particletwentytwo, sequenceActiontwentytwo,
--                                    particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,
--                                    particlefour, sequenceActionfour,
--                                    particletwentyfour, sequenceActiontwentyfour,particletwentyfive, sequenceActiontwentyfive,
--                                    particletwentysix, sequenceActiontwentysix)


--     return node
-- end


-- 显示关卡星星
function UI_Guankaxingxing(func)   --关卡星星 39
    --星星
    local particleOne = createParticle("ui_a003901", cc.p(25,25))
    local delayActionOne = createParticleDelay(0.2)
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
 	local node = createTotleAction(particleOne, sequenceActionOne)

	return node
end

function UI_Manxingchoujiang1(func)--满星抽奖 38

    -- 点点(持续状态，一旦开始就一直存在，直到抽奖结束，建议单独拿出来)
    local particleFour = createParticle("ui_a003801", cc.p(0,0))
    local delayFour = createParticleDelay(999)
    local stopActionFour = createParticleOut(4.1)
    local sequenceActionFour = createSequence(delayFour, stopActionFour)

    local node = createTotleAction(
        particleFour, sequenceActionFour)
    return node
end

function UI_Manxingchoujiang2(func)--满星抽奖 38

    --暴点点（一次性）
    local particleone = createParticle("ui_a003802", cc.p(45, 45))
    local delayActionone = createParticleDelay(0.3)--持续时间
    local stopActionone = createParticleOut(0.72,func)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- 暴光（一次性）
    local particlethree = createParticle("ui_a003803", cc.p(45,45))
    local delayActionthree = createParticleDelay(0.3)--持续时间
    local stopActionthree = createParticleOut(0.4)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    local node = createTotleAction(
        particlethree, sequenceActionthree,
        particleone, sequenceActionone
        )

    return node
end

function UI_Zhanduishengji()--战队升级特效 40
    -- 竖线
    local particlefour = createParticle("ui_a004001", cc.p(0,0) )
    local scaleToActiotten  = createScaleTo(0, 0.5, 15)
    local delayActionfour = createParticleDelay(999)--持续时间
    local stopActionfour = createParticleOut(0.2)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    -- 竖线
    local particleFour = createParticle("ui_a004005", cc.p(0,0) )
    local scaleToActiotFen  = createScaleTo(0, 0.5, 15)
    local delayActionFour = createParticleDelay(999)--持续时间
    local stopActionFour = createParticleOut(0.2)
    local sequenceActionFour = createSequence(scaleToActiotFen,delayActionFour,stopActionFour)

    -- 点点
    local particlethree = createParticle("ui_a004002", cc.p(0,-30))
    local delayActionthree = createParticleDelay(999)--持续时间
    local stopActionthree = createParticleOut(0.4)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    -- 火焰
    local particleone = createParticle("ui_a004003", cc.p(0,-30))
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(0.72)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- 上升主体
    local particletwo = createParticle("ui_a004004", cc.p(0,-30))
    local scaleToActiottwo  = createScaleTo(0, 9, 7)
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(0.6)
    local sequenceActiontwo = createSequence(scaleToActiottwo,delayActiontwo,stopActiontwo)

    local node = createTotleAction(
        particletwo,sequenceActiontwo,
        particlefour, sequenceActionfour,
        particleFour, sequenceActionFour,
        particlethree, sequenceActionthree,
        particleone, sequenceActionone
        )


    return node
end

function UI_Zhujiemianbaoxiang(func)--主界面宝箱26 func

    local particleone = createParticle("ui_a002601", cc.p(470,785))
    -- local delayActionone = createParticleDelay(0.3)
    -- local stopActionone = createParticleOut(0.3, func)
    -- local sequenceActionone= createSequence(delayActionone, stopActionone)

    local delayActionone1 = createParticleDelay(0.3)
    local delayActionone2 = createParticleDelay(0.2)
    local delayActionone3 = createParticleDelay(1)
    local showIt = createVistbleAction(true)
    local hideIt = createVistbleAction(false)
    local sequenceActionone= createSequence(delayActionone1, showIt,delayActionone2,hideIt,delayActionone3)
    local repeatAction = createRepeatAction(sequenceActionone)
    local node = createTotleAction(particleone,repeatAction)

    return node
end

function UI_Zhujiemianhuodong(func)--主界面活动 27

    local particleone = createParticle("ui_a002701", cc.p(583,770))
    -- local delayActionone = createParticleDelay(0.3)
    local delayActionone1 = createParticleDelay(0.3)
    local delayActionone2 = createParticleDelay(0.4)
    local delayActionone3 = createParticleDelay(0.3)
    local showIt = createVistbleAction(true)
    local hideIt = createVistbleAction(false)
    local sequenceActionone= createSequence(delayActionone1, showIt,delayActionone2,hideIt,delayActionone3)
    local repeatAction = createRepeatAction(sequenceActionone)
    local node = createTotleAction(particleone,repeatAction)
    return node
end

-- function UI_Zhujiemianbaoxiang(func)--主界面宝箱26 func

--     local particleone = createParticle("ui_a002601", cc.p(470,785))
--     local delayActionone = createParticleDelay(0.3)
--     local stopActionone = createParticleOut(0.3, func)
--     local sequenceActionone= createSequence(delayActionone, stopActionone)

--     local node = createTotleAction(particleone, sequenceActionone)
--     return node
-- end

-- function UI_Zhujiemianhuodong(func)--主界面活动 27

--     local particleone = createParticle("ui_a002701", cc.p(583,770))
--     local delayActionone = createParticleDelay(0.3)
--     local stopActionone = createParticleOut(0.3, func)
--     local sequenceActionone= createSequence(delayActionone, stopActionone)
--     local node = createTotleAction(particleone, sequenceActionone)
--     return node
-- end


function UI_zengchanjiemian()--增产界面

    --烟
    local particleTwo = createParticle("ui_b005401", cc.p(0,0))
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(2)
    local stopActionTwo = createParticleOut(2)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    local node = createTotleAction(particleTwo, sequenceActionTwo)
    return node
end


function UI_Zhujiemiantubiaokaiqi(targetPos)--主界面图标开启 33
    --能量左
    local particleTwo = createParticle("ui_a003301", cc.p(700,600))
    local delayTwo = createParticleDelay(0.3)
    local bezierTwo1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), targetPos, 800 , -800)
    local delayTwo2 = createParticleDelay(0.0)
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionTwo = createSequence(bezierTwo1, delayTwo,stopActionTwo)

    --爆
    local particleSix = createParticle("ui_a003302", targetPos)

    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0.4)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a003302")

    local delaySix2 = createParticleDelay(0.5)
    local stopActionSix = createParticleOut(0.5)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2,
          delaySix2, stopActionSix)

    -- local node = createTotleAction(particleSix, sequenceActionSix)
    local node = createTotleAction(particleTwo, sequenceActionTwo, particleSix, sequenceActionSix)
    return node
end


function UI_Wujiangbuzhenxuanze()--武将布阵选择特效 41
    -- 火焰
    local particleone = createParticle("ui_a004101", cc.p(50,50))    ---117,664
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(0.72)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- 竖线
    local particlefour = createParticle("ui_a004102", cc.p(50,50))    ----117, 664
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionfour = createParticleDelay(999)--持续时间
    local stopActionfour = createParticleOut(0.2)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    local node = createTotleAction(
        particleone,sequenceActionone
        ,
        particlefour, sequenceActionfour
        )

    return node
end

function UI_zhuangbeishengjitixing()--装备升级提醒
    --扫光
    local particleTwo = createParticle("ui_b005501", cc.p(15,0))
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(0.2)   ----0.2
    local stopActionTwo = createParticleOut(0.41)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)
    --local repeatAction = createRepeatAction(sequenceActionTwo)
    local node = createTotleAction(particleTwo, sequenceActionTwo)
    return node
end

function UI_Wujiangjiemiantouxiang()--武将界面头像 43

    -- 武将选择旋转框
    local particletwo = createParticle("ui_a004302", cc.p(62,62))
    local scaleToActiottwo  = createScaleTo(0, 1, 1)
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(0.2)
    local sequenceActiontwo = createSequence(scaleToActiottwo,delayActiontwo,stopActiontwo)

    -- 武将选择旋转框
    local particlefour = createParticle("ui_a004303", cc.p(62,62))
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActionfour = createParticleDelay(999)--持续时间
    local stopActionfour = createParticleOut(0.2)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    -- 武将按钮
    local particleone = createParticle("ui_a004306", cc.p(62,62))
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- local img = game.newSprite("res/part/wujiangjiemianxuanzekuang.png")
    -- img:setPosition(90,670)
    -- img:setScale(1,1)

     local node = createTotleAction(
        particletwo,sequenceActiontwo,
        particlefour, sequenceActionfour,
        particleone, sequenceActionone
        )
    -- node:addChild(img, 10) -- to do

    return node
end

function UI_Wujiangjiemianwujianganniu(posX,posY)--武将界面武将按钮 44
    -- 武将按钮
    local particleone = createParticle("ui_a004301", cc.p(posX,posY))  --- 60,862
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- -- 助威按钮
    -- local particleone = createParticle("ui_a004301", cc.p(130,865))
    -- local scaleToActiotten  = createScaleTo(0, 0.7, 0.7)
    -- local delayActionone = createParticleDelay(9999999)--持续时间
    -- local stopActionone = createParticleOut(0.5)
    -- local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    -- -- 无双按钮
    -- local particleone = createParticle("ui_a004301", cc.p(190,870))
    -- local scaleToActiotten  = createScaleTo(0, 0.4, 0.4)
    -- local delayActionone = createParticleDelay(9999999)--持续时间
    -- local stopActionone = createParticleOut(0.5)
    -- local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    -- 属性 (黄色)
    local particleTwo = createParticle("ui_a004301", cc.p(posX,posY))
    -- local particleTwo = createParticle("ui_a004305", cc.p(80,170))
    local scaleToActiotTwo  = createScaleTo(0, 0.5, 0.5)
    local delayActionTwo = createParticleDelay(999)--持续时间
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionTwo = createSequence(scaleToActiotTwo,delayActionTwo,stopActionTwo)

    -- 羁绊（红色）
    local particleThree = createParticle("ui_a004301", cc.p(posX,posY))   ---347
    -- local particleThree = createParticle("ui_a004304", cc.p(280,170))
    local scaleToActiotThree  = createScaleTo(0, 0.5, 0.5)
    local delayActionThree = createParticleDelay(999)--持续时间
    local stopActionThree = createParticleOut(0.2)
    local sequenceActionThree = createSequence(scaleToActiotThree,delayActionThree,stopActionThree)

    local node = createTotleAction(
        particleone,sequenceActionone,
        particleTwo,sequenceActionTwo,
        particleThree,sequenceActionThree

        )

    return node
end

function UI_WujiangjiemianXanniu()--武将界面头像X按钮 45

    -- 武将选择旋转框
    local particletwo = createParticle("ui_a004501", cc.p(60,32))
    local scaleToActiottwo  = createScaleTo(0, 1, 1)
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(0.2)
    local sequenceActiontwo = createSequence(scaleToActiottwo,delayActiontwo,stopActiontwo)

    local node = createTotleAction(
        particletwo, sequenceActiontwo
        )

    return node
end


function UI_Hongdiantishitexiao()--红点提示特效 51
    -- 提示红点特效
    local particleone = createParticle("ui_a005101", cc.p(10,10),false)--将红点由自由模式改成相对模式
    print("UI_Hongdiantishitexiao isFree");

    local scaleToActionone  = createScaleTo(0, 1, 1.3)
    -- local delayActionone = createParticleDelay(10)--持续时间
    -- local stopActionone = createParticleOut(0.4)
    -- local sequenceActionone = createSequence(scaleToActionone,delayActionone,stopActionone)

    -- -- 战字特效
    -- local particleOne = createParticle("ui_b007002", cc.p(400,870))
    -- local scaleToActionOne  = createScaleTo(0, 0.4, 0.4)
    -- local delayActionOne = createParticleDelay(90)--持续时间
    -- local stopActionOne = createParticleOut(1.3)
    -- local sequenceActionOne = createSequence(scaleToActionOne,delayActionOne,stopActionOne)

    -- local node1 = cc.RepeatForever:create( _node1 )

    local node = createTotleAction(
        particleone, scaleToActionone
        -- particleOne, sequenceActionOne
        )

    return node
end

function UI_zhantexiao()    --战特效 51
    -- -- 提示红点特效
    -- local particleone = createParticle("ui_a005101", cc.p(10,10))
    -- local scaleToActionone  = createScaleTo(0, 1, 1.3)
    -- -- local delayActionone = createParticleDelay(10)--持续时间
    -- -- local stopActionone = createParticleOut(0.4)
    -- -- local sequenceActionone = createSequence(scaleToActionone,delayActionone,stopActionone)

    -- 战字特效
    local particleOne = createParticle("ui_b007002", cc.p(50,50))
    local scaleToActionOne  = createScaleTo(0, 0.4, 0.4)
    -- local delayActionOne = createParticleDelay(90)--持续时间
    -- local stopActionOne = createParticleOut(1.3)
    -- local sequenceActionOne = createSequence(scaleToActionOne,delayActionOne,stopActionOne)

    local node = createTotleAction(
        -- particleone, scaleToActionone
        -- particleOne, sequenceActionOne
        particleOne, scaleToActionOne
        )
    return node
end

function UI_NewBeeHandtexiao(posX,posY)--新手引导 小手提示特效
    --光圈
    local particleone = createParticle("ui_a005001", cc.p(posX,posY))
    local scaleToActionOne1  = createScaleTo(0, 0.5, 0.5)
    local delayActionone = createParticleDelay(99999999)--持续时间
    local stopActionone = createParticleOut(0.9)
    local sequenceActionone = createSequence(scaleToActionOne1,delayActionone,stopActionone)
    local node = createTotleAction(particleone,sequenceActionone)
    return node
end


function UI_NewHandJTtexiao()--新手引导 对话框下三角提示特效
    --光圈
    local particleone2 = createParticle("ui_a005003", cc.p(513,15))    --585,200
    local scaleToActionOne21  = createScaleTo(0, 1, 0.8)
    local delayActionone2 = createParticleDelay(9999999)--持续时间
    local stopActionone2 = createParticleOut(0.5)
    local sequenceActionone2 = createSequence(scaleToActionOne21,delayActionone2,stopActionone2)
    local node = createTotleAction(particleone2,sequenceActionone2)
    return node
end

function UI_xinshouyindaoF1()--新手引导F1—2  将开启功能

    --  字上的闪电
    local particlethree = createParticle("ui_b007201", cc.p(333,728) )

    local delayActionthree = createParticleDelay(999)--持续时间
    local stopActionthree = createParticleOut(1.3)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    --图标特效-- 上方的光条
    local particleone = createParticle("ui_b007202", cc.p(319,735) )


    local scaleToActionone  = createScaleTo(0, 1, 2.4)
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(1.3)
    local sequenceActionone = createSequence(scaleToActionone,delayActionone,stopActionone)

    --图标特效-- 下方的光条
    local particletwo = createParticle("ui_b007204", cc.p(319,215) )

    local scaleToActiontwo  = createScaleTo(0, 1, 2.4)
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(1.3)
    local sequenceActiontwo = createSequence(scaleToActiontwo,delayActiontwo,stopActiontwo)

    local node = createTotleAction(particlethree, sequenceActionthree, particleone, sequenceActionone,particletwo, sequenceActiontwo)

    return node
end

function UI_gongxihuodexinjiemian()--恭喜获得新界面

    --图标特效-- 上方的字
    local particleone = createParticle("ui_b006907", cc.p(319,580) )

    -- local moveOne = createParticleMove(cc.p())

    local delayActionone = createParticleDelay(0.4)--持续时间
    local stopActionone = createParticleOut(0.4)
    local sequenceActionone = createSequence(delayActionone,stopActionone)


    --图标特效-- 下方的字
    local particlethree = createParticle("ui_b006901", cc.p(319,337) )

    -- local moveOne = createParticleMove(cc.p())

    local delayActionthree = createParticleDelay(0.4)--持续时间
    local stopActionthree = createParticleOut(0.4)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)


    --图标特效-- 爆炸颗粒
    local particletwo = createParticle("ui_b006902", cc.p(315,465) )


    -- local moveOne = createParticleMove(cc.p())
    local cistbletwo1 = createVistbleAction(false)
    local delaytwo1 = createParticleDelay(0.21)
    local cistbltwo2 = createVistbleAction(true)


    local delayActiontwo = createParticleDelay(2)--持续时间
    local stopActiontwo = createParticleOut(1.3)
    local sequenceActiontwo = createSequence(cistbletwo1,delaytwo1,cistbltwo2,delayActiontwo,stopActiontwo)

    --图标特效-- 上方的光条
    local particlefour = createParticle("ui_b007301", cc.p(319,449) )

    local scaleToActionfour  = createScaleTo(0, 1, 1.1)
    local delayActionfour = createParticleDelay(0.5)--持续时间
    local stopActionfour = createParticleOut(1.5)
    local sequenceActionfour = createSequence(scaleToActionfour,delayActionfour,stopActionfour)

    --图标特效-- 下方的光条
    local particlefive = createParticle("ui_b007302", cc.p(319,460) )

    local scaleToActionfive  = createScaleTo(0, 1, 1.1)
    local delayActionfive = createParticleDelay(0.5)--持续时间
    local stopActionfive = createParticleOut(1.5)
    local sequenceActionfive = createSequence(scaleToActionfive,delayActionfive,stopActionfive)

    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,
                                   particlefour, sequenceActionfour,particlefive, sequenceActionfive)



    return node
end


function UI_Hechenganniu()--合成按钮

    local particlefour = createParticle("ui_b007006", cc.p(551,67))
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(1.3)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    local node = createTotleAction(
        particlefour, sequenceActionfour
        )

    return node
end

function UI_Xiangqianzhuangbei(func)--镶嵌装备

    --爆的光
    local particleSix = createParticle("A0050_03", cc.p(0,0))
    local scaleToActionSix  = createScaleTo(0, 1, 1)
    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.2)
    local sequenceActionSix= createSequence(scaleToActionSix, delaySix2, stopActionSix)

    --爆的颗粒
    local particleThree = createParticle("A0050_06", cc.p(0,60)) 
    local delayActionThree = createParticleDelay(0.35)
    local stopActionThree = createParticleOut(1)
    local sequenceActionThree = createSequence(delayActionThree, stopActionThree)

    --第二种-- 爆炸颗粒
    local particleone = createParticle("A0050_04", cc.p(0,60))
    local delayActionone = createParticleDelay(0.2)--持续时间
    local stopActionone = createParticleOut(1.2)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    local node = createTotleAction(
        particleSix,sequenceActionSix,particleThree,sequenceActionThree,particleone,sequenceActionone

        )
    return node
end

function UI_Qiandaoyeqian(func)--签到页签
    --右上
    local particleOne = createParticle("ui_a001202", cc.p(-12,47)) 
    local moveAction1 = createParticleMove(cc.p(53,8), 0.5, 0)
    local moveAction2 = createParticleMove(cc.p(6,-54), 0.5, 0)
    local moveAction3 = createParticleMove(cc.p(-50,-3), 0.5, 0)
    local moveAction4 = createParticleMove(cc.p(-12,47), 0.5, 0)
    local stopActionOne = createParticleOut(2)
    local sequenceActionOne = createSequence(moveAction1, moveAction2, moveAction3, moveAction4,stopActionOne
        )

    --左下
    local particleTwo = createParticle("ui_a001202", cc.p(6,-54)) 
    local moveActionTwo1 = createParticleMove(cc.p(-50,-3), 0.5, 0)
    local moveActionTwo2 = createParticleMove(cc.p(-12,47), 0.5, 0)
    local moveActionTwo3 = createParticleMove(cc.p(53,8), 0.5, 0)
    local moveActionTwo4 = createParticleMove(cc.p(6,-54), 0.5, 0)
    local stopActionTwo = createParticleOut(2, func)
    local sequenceActionTwo = createSequence(moveActionTwo1, moveActionTwo2, moveActionTwo3, moveActionTwo4, stopActionTwo)

    local node = createTotleAction(
        particleOne, sequenceActionOne
        , particleTwo, sequenceActionTwo
        )
    return node
end

function UI_Buqiantishi()--补签提示

    local particlefour = createParticle("ui_a001203", cc.p(163,727)) 
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(1.3)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    local node = createTotleAction(
        particlefour, sequenceActionfour
        )
                                  
    return node

end

function UI_Teshujianglidaijitishi(func)--特殊奖励待机提示 12

    --边框发光
    local particlefour = createParticle("ui_a006501", cc.p(588,823))
    local scaleToActionSeven  = createScaleTo(0, 0.7, 0.7)
    local delayActionfour = createParticleDelay(0.5)--持续时间
    local stopActionfour = createParticleOut(1.3)
    local sequenceActionfour = createSequence(scaleToActionSeven,delayActionfour,stopActionfour)

    --点点
    local particleThreeClone = createParticle("ui_a001204", cc.p(588,823))
    local delayThree2 = createParticleDelay(0.5)
    local stopActionThreeClone = createParticleOut(1.3)
    local sequenceActionThreeClone = createSequence(delayThree2, stopActionThreeClone)

    --发光特效
    local particlethree = createParticle("ui_a001205", cc.p(588,823))
    local delayActionthree = createParticleDelay(0.5)
    local stopActionthree = createParticleOut(1.3, func)
    local sequenceActionthree= createSequence(delayActionthree, stopActionthree)

    local node = createTotleAction(
         particlefour, sequenceActionfour,particlethree, sequenceActionthree,particleThreeClone, sequenceActionThreeClone
          )
    return node
end

function UI_Meiriqiandao(func)--每日签到12
    --右上
    local particleOne = createParticle("ui_a001201", cc.p(42,40)) 
    local moveAction1 = createParticleMove(cc.p(42,-36), 0.5, 0)
    local moveAction2 = createParticleMove(cc.p(-40,-34), 0.5, 0)
    local moveAction3 = createParticleMove(cc.p(-40,35), 0.5, 0)
    local moveAction4 = createParticleMove(cc.p(42,40), 0.5, 0)
    local delayActionEight = createParticleDelay(5)
    local stopActionOne = createParticleOut(2)
    local sequenceActionOne = createSequence(moveAction1, moveAction2, moveAction3, moveAction4)--, stopActionOne)
    local repeatActionOne = createRepeatAction(sequenceActionOne)

    --左下
    local particleTwo = createParticle("ui_a001201", cc.p(-40,-34)) 
    local moveActionTwo1 = createParticleMove(cc.p(-40,35), 0.5, 0)
    local moveActionTwo2 = createParticleMove(cc.p(42,40), 0.5, 0)
    local moveActionTwo3 = createParticleMove(cc.p(42,-36), 0.5, 0)
    local moveActionTwo4 = createParticleMove(cc.p(-40,-34), 0.5, 0)
    local stopActionTwo = createParticleOut(2, func)
    local sequenceActionTwo = createSequence(moveActionTwo1, moveActionTwo2, moveActionTwo3, moveActionTwo4)--, stopActionTwo)
    local repeatActionTwo = createRepeatAction(sequenceActionTwo)

    local node = createTotleAction(particleOne, repeatActionOne
        , particleTwo, repeatActionTwo
        )
    return node
end

-- function UI_Zhujiemianhuodong(func)--主界面活动 27

--     local particleone = createParticle("ui_a002701", cc.p(583,770))
--     -- local delayActionone = createParticleDelay(0.3)
--     local delayActionone1 = createParticleDelay(0.3)
--     local delayActionone2 = createParticleDelay(0.4)
--     local delayActionone3 = createParticleDelay(0.3)
--     local showIt = createVistbleAction(true)
--     local hideIt = createVistbleAction(false)
--     local sequenceActionone= createSequence(delayActionone1, showIt,delayActionone2,hideIt,delayActionone3)
--     local repeatAction = createRepeatAction(sequenceActionone)
--     local node = createTotleAction(particleone,repeatAction)
--     return node
-- end

-- function UI_Meiriqiandao(func)--每日签到12
--     --右上
--     local particleOne = createParticle("ui_a001201", cc.p(42,40)) 
--     local moveAction1 = createParticleMove(cc.p(42,-36), 0.5, 0)
--     local moveAction2 = createParticleMove(cc.p(-40,-34), 0.5, 0)
--     local moveAction3 = createParticleMove(cc.p(-40,35), 0.5, 0)
--     local moveAction4 = createParticleMove(cc.p(42,40), 0.5, 0)
--     local delayActionEight = createParticleDelay(5)
--     local stopActionOne = createParticleOut(2)
--     local sequenceActionOne = createSequence(moveAction1, moveAction2, moveAction3, moveAction4, stopActionOne)

--     --左下
--     local particleTwo = createParticle("ui_a001201", cc.p(-40,-34)) 
--     local moveActionTwo1 = createParticleMove(cc.p(-40,35), 0.5, 0)
--     local moveActionTwo2 = createParticleMove(cc.p(42,40), 0.5, 0)
--     local moveActionTwo3 = createParticleMove(cc.p(42,-36), 0.5, 0)
--     local moveActionTwo4 = createParticleMove(cc.p(-40,-34), 0.5, 0)
--     local stopActionTwo = createParticleOut(2, func)
--     local sequenceActionTwo = createSequence(moveActionTwo1, moveActionTwo2, moveActionTwo3, moveActionTwo4, stopActionTwo)

--     local node = createTotleAction(particleOne, sequenceActionOne
--         , particleTwo, sequenceActionTwo
--         )
--     return node
-- end
function UI_juqingyeqianjiemiandianjiguankajiemiantubiaochixu001()--剧情页签列表界面点击关卡界面图标持续001

   
    --图标特效-- 烟雾
    local particleone = createParticle("ui_b009003", cc.p(0,30) )
    local scaleToActiotten  = createScaleTo(0, 1.6, 1.6)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    --图标特效-- 骷髅
    local particletwo = createParticle("ui_b009004", cc.p(7,0) )
    local scaleToActiotten  = createScaleTo(0, 1.9, 1.9)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActiotten,delayActiontwo,stopActiontwo)
    --图标特效-- 左眼睛火

    local particlethree = createParticle("ui_b002103", cc.p(-30,52) )
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    local particlesixRotate = createRotateTo(0, -20)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActiotten,particlesixRotate,delayActionthree,stopActionthree)

    --图标特效-- 右眼睛火
    local particlefour = createParticle("ui_b002104", cc.p(0,52) )
    local scaleToActiotten  = createScaleTo(0, 1.7, 1.7)
    local particlesixRotate = createRotateTo(0, 23)
    local delayActionfour = createParticleDelay(888)--持续时间
    local stopActionfour = createParticleOut(0.5)
    local sequenceActionfour = createSequence(scaleToActiotten,particlesixRotate,delayActionfour,stopActionfour)

    --图标特效-- 左紫色烟雾
    local particlesix = createParticle("ui_b009001", cc.p(-170,0) )
    local scaleToActiotten  = createScaleTo(0, 2, 2)
    local delayActionsix = createParticleDelay(888)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(scaleToActiotten,delayActionsix,stopActionsix)

    --图标特效-- 右紫色烟雾
    local particleseven = createParticle("ui_b009001", cc.p(160,0) )
    local scaleToActiotten  = createScaleTo(0, 2, 2)
    local delayActionseven = createParticleDelay(888)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(scaleToActiotten,delayActionseven,stopActionseven)


  
    local node = createTotleAction(particlethree, sequenceActionthree,particleone, sequenceActionone,particletwo, sequenceActiontwo,particlefour, sequenceActionfour
                                   ,
                                   particlesix, sequenceActionsix,particleseven, sequenceActionseven
                                   )



    return node
end


function UI_juqingyeqianjiemiandianjiguankajiemianjinxingxiangqian()--剧情页签列表界面点击关卡界面金星镶嵌

   
    --图标特效-- 爆出颗粒
    local particleone = createParticle("ui_b008701", cc.p(0,0) )
    local scaleToActiotten  = createScaleTo(0, 1.4, 1.4)
    local delayActionone = createParticleDelay(0.05)--持续时间
    local stopActionone = createParticleOut(1.3)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    --图标特效-- 一闪
    local particletwo = createParticle("ui_b008703", cc.p(7,0) )
    local scaleToActiotten  = createScaleTo(0, 1.4, 1.4)
    local delayActiontwo = createParticleDelay(0.12)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActiotten,delayActiontwo,stopActiontwo)


    --高亮爆
    local particlefour = createParticle("ui_b008702", cc.p(7,0) )
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(0.3)
    local cistblfour2 = createVistbleAction(true)
    local particlefour2 = createRestartAction("ui_b008702")
    local delayActionfour = createParticleDelay(0.3)--持续时间
    local stopActionfour = createParticleOut(0.9)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblfour2,particlefour2,delayActionfour,stopActionfour)

    
  
    local node = createTotleAction(particletwo, sequenceActiontwo,particleone, sequenceActionone,particlefour, sequenceActionfour)




    return node
end 






function UI_juqingyeqianjiemiandianjiguankajiemiantubiaochixu002()--剧情页签列表界面点击关卡界面图标持续002

   
    --图标特效-- 颗粒
    local particleone = createParticle("ui_b008804", cc.p(15,85) )
    local scaleToActiotten  = createScaleTo(0, 1.4, 1.4)
    local delayActionone = createParticleDelay(9999)--持续时间
    local stopActionone = createParticleOut(1.3)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    --图标特效-- 闪
    local particletwo = createParticle("ui_b008801", cc.p(31,210) )
    local delayActiontwo = createParticleDelay(99999)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)


    --烟雾
    local particlefour = createParticle("ui_b008803", cc.p(12,90) )
    local scaleToActiotten  = createScaleTo(0, 1.6, 1.6)
    local delayActionfour = createParticleDelay(99999)--持续时间
    local stopActionfour = createParticleOut(0.9)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    
  
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlefour, sequenceActionfour)




    return node
end 





function UI_juqingyeqianjiemiandianjiguankajiemiantubiaochixu003()--剧情页签列表界面点击关卡界面图标持续003

   
    --图标特效-- 颗粒
    local particleone = createParticle("ui_b008904", cc.p(20,60) )
    local scaleToActiotten  = createScaleTo(0, 1.8, 1.8)
    local delayActionone = createParticleDelay(9999)--持续时间
    local stopActionone = createParticleOut(1.3)
    local sequenceActionone = createSequence(scaleToActiotten,delayActionone,stopActionone)

    --图标特效-- 闪
    local particletwo = createParticle("ui_b008901", cc.p(3,180) )
    local delayActiontwo = createParticleDelay(99999)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)


    --烟雾
    local particlefour = createParticle("ui_b008903", cc.p(19,70) )
    local scaleToActiotten  = createScaleTo(0, 1.6, 1.6)
    local delayActionfour = createParticleDelay(99999)--持续时间
    local stopActionfour = createParticleOut(0.9)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    
  
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlefour, sequenceActionfour)




    return node
end 

function UI_buzhenjiemianchixutexiao()--布阵界面持续特效

   
    --图标特效-- 颗粒
    local particleone = createParticle("ui_b009201", cc.p(320,313) )
    local delayActionone = createParticleDelay(9999)--持续时间
    local stopActionone = createParticleOut(1.3)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 云
    local particletwo = createParticle("ui_b009202", cc.p(320,186) )
    local delayActiontwo = createParticleDelay(99999)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)


    --烟雾颗粒
    local particlefour = createParticle("ui_b009203", cc.p(320,186) )
    local delayActionfour = createParticleDelay(99999)--持续时间
    local stopActionfour = createParticleOut(0.9)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    
  
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo
                                   ,
                                   particlefour, sequenceActionfour
                                   )
    return node
end 

function UI_buzhenjiemiankuangLanka()--布阵界面蓝卡框

    --蓝
    local particlefour = createParticle("ui_b009103", cc.p(0,0) )
    local delayActionfour = createParticleDelay(0.1)--持续时间
    local stopActionfour = createParticleOut(0.9)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)

    --蓝点
    local particlesix = createParticle("ui_b009104", cc.p(0,0) )
    local delayActionsix = createParticleDelay(0.5)--持续时间
    local stopActionsix = createParticleOut(3)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    local node = createTotleAction(particlefour, sequenceActionfour,particlesix, sequenceActionsix)

    return node
end 

function UI_buzhenjiemiankuangZika()--布阵界面紫卡框

    --紫
    local particleone = createParticle("ui_b009101", cc.p(0,0) )
    local delayActionone = createParticleDelay(0.1)--持续时间
    local stopActionone = createParticleOut(0.9)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --紫点
    local particlethree = createParticle("ui_b009106", cc.p(0,0) )
    local delayActionthree = createParticleDelay(0.5)--持续时间
    local stopActionthree = createParticleOut(3)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    local node = createTotleAction(particleone, sequenceActionone,particlethree, sequenceActionthree)

    return node
end 

function UI_buzhenjiemiankuangLvka()--布阵界面绿卡框

    --绿
    local particletwo = createParticle("ui_b009102", cc.p(0,0) )
    local delayActiontwo = createParticleDelay(0.1)--持续时间
    local stopActiontwo = createParticleOut(0.9)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --绿点
    local particlefive = createParticle("ui_b009105", cc.p(464,792) )
    local delayActionfive = createParticleDelay(0.5)--持续时间
    local stopActionfive = createParticleOut(3)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    local node = createTotleAction(particletwo, sequenceActiontwo,particlefive, sequenceActionfive)

    return node
end





