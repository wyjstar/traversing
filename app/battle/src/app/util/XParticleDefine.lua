--设计效果类
function CREATE_ARRIVE_FUNC()
    local particle = createParticle("a0151_02", cc.p(400,400)) 


    local scaleToAction  = createScaleTo(0.5, 1.45, 0.3)
    local rotateToAction = createRotateTo(1, 30)

    local spawnAction = createSpawn( scaleToAction, rotateToAction)
    -------------

    local moveAction = createParticleMove(cc.p(400,800), 0.5, 0)

    local showAction = createParticleShow(2, 0)

    local sequenceAction = createSequence(spawnAction, moveAction, showAction)

    particle:startAction(sequenceAction)

    return particle
end

--贝塞尔
function CREATE_ARRIVE_FUNC2()

    local particle = createParticle("a0151_02", cc.p(200,100))

    local scaleToAction  = createScaleTo(0.5, 0.45, 0.3)
    local rotateToAction = createRotateTo(1, 30)

    local spawnAction = createSpawn( scaleToAction, rotateToAction)

    local function callBack1()
        print("callBack1")
        --local moveAction = createParticleMove(cc.p(400,800), 0.5, 0)
        local moveAction = createBezier(0.5, cc.p(100, 100),  cc.p(100, 200), cc.p(400, 800))

        local function moveCallBack()
            print("moveCallBack")
            local showAction = createParticleShow(2, 0)
            local function showCallBack()
                print("showCallBack")
                particle:beRemove()
            end
            local showFun = createCallFun(showCallBack)
            local showSequence = createSequence(showAction, showFun)
            particle:runAction(showSequence)
        end

        local moveFun = createCallFun(moveCallBack)
        local moveSequence = createSequence(moveAction, moveFun)

        particle:runAction(moveSequence)
    end

    local callBackFun1 = createCallFun(callBack1)
    local sequenceAction = createSequence(spawnAction, callBackFun1)

    particle:runAction(sequenceAction)

    return particle
end


-- 新版特效中不再使用此特效
function UI_Wujiangtupo(func)--武将突破01  
    --武将碎片
    local particleOne = createParticle("ui_a000101", cc.p(135.6,220.8))
    local scaleToActionOne  = createScaleTo(0, 1, 1)
    local delayActionOne = createParticleDelay(0.5)
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local spawnActionOne = createSpawn( scaleToActionOne, sequenceActionOne)

    --突破丹
    local particleTwo = createParticle("ui_a000101", cc.p(249.6,220.8))
    local scaleToActionTwo  = createScaleTo(0, 1, 1)
    local delayActionTwo = createParticleDelay(0.5)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)
    local spawnActionTwo = createSpawn( scaleToActionTwo, sequenceActionTwo)

    --武将碎片能量
    local particleThree = createParticle("ui_a000103", cc.p(135.6,220.8))
    local delayThree = createParticleDelay(0.45)
    local bezierThree1 = createRandomBezier(0.7, cc.p(-100,250), cc.p(-100,250), cc.p(310,500))
    local bezierThree2 = createRandomBezier(0.6, cc.p(-300,800), cc.p(300,500), cc.p(170,600))
    local delayThree2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionThree = createSequence(delayThree, bezierThree1, bezierThree2, 
        delayThree2,stopActionTwo)
    local spawnActionThree = createSpawn(sequenceActionThree)

    --突破丹能量
    local particleFour = createParticle("ui_a000103", cc.p(249.6,220.8))
    local delayFour = createParticleDelay(0.45)
    local bezierFour1 = createRandomBezier(0.5, cc.p(400,350), cc.p(400,350), cc.p(50,550))
    local bezierFour2 = createRandomBezier(0.8, cc.p(-200,650), cc.p(600,900), cc.p(170,600))
    local delayFour2 = createParticleDelay(0)
    local stopActionFour = createParticleOut(0.2)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionFour = createSequence(delayFour, bezierFour1, bezierFour2, 
        delayFour2,stopActionFour)
    local spawnActionFour = createSpawn(sequenceActionFour)

    --进化前的卡片特效--星星点点
    local particleFive = createParticle("ui_a000104", cc.p(170,600))
    local cistbleFive1 = createVistbleAction(false)
    local delayFive1 = createParticleDelay(1)
    local cistbleFive2 = createVistbleAction(true)
    local delayFive2 = createParticleDelay(0.9)
    --createRestartAction
    local scaleFive = createScaleTo(0.15, 0.3, 0.3)
    local stopActionFive = createParticleOut(0.3)
    local sequenceActionFive = createSequence(cistbleFive1, delayFive1, cistbleFive2, delayFive2, 
        stopActionFive)
    
    --进化前的卡片特效--爆的光
    local particleSix = createParticle("ui_a000105", cc.p(170,600))
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(1.7)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a000105")
    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.2)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2, 
        delaySix2, stopActionSix)

    --进化前的卡片特效--爆的法阵
    local particleSeven = createParticle("ui_a000106", cc.p(170,600))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(1.7)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_a000106")
    local delaySeven2 = createParticleDelay(0.2)
    local stopActionSeven = createParticleOut(0.2)
    local sequenceActionSeven= createSequence(cistbleSeven1, delaySeven1, cistbleSeven2, 
        particleSeven2, delaySeven2, stopActionSeven)

    --进化后的卡片特效——爆的法阵
    local particleEight = createParticle("ui_a000107", cc.p(480,600))
    local cistbleEight1 = createVistbleAction(false)
    local delayEight1 = createParticleDelay(2)
    local cistbleEight2 = createVistbleAction(true)
    local particleEight2 = createRestartAction("ui_a000107")
    local delayEight2 = createParticleDelay(0.2)
    local stopActionEight = createParticleOut(0.2)
    local sequenceActionEight= createSequence(cistbleEight1, delayEight1, cistbleEight2, 
        particleEight2, delayEight2, stopActionEight)

    --进化后的卡片特效--星星点点
    local particleNine = createParticle("ui_a000104", cc.p(480,600))
    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(2)
    local cistbleNine2 = createVistbleAction(true)
    local delayNine2 = createParticleDelay(0.1)
    local scaleNine = createScaleTo(0, 1.5, 1.5)
    local stopActionNine = createParticleOut(0.5)
    local sequenceActionNine = createSequence(cistbleNine1, delayNine1, cistbleNine2, 
        delayNine2, scaleNine, stopActionNine)
    
    --进化后的卡片特效--云
    local particleTen = createParticle("ui_a000108", cc.p(480,600))
    local cistbleTen1 = createVistbleAction(false)
    local delayTen1 = createParticleDelay(2)
    local cistbleTen2 = createVistbleAction(true)
    local delayTen2 = createParticleDelay(0.25)
    local scaleTen = createScaleTo(0, 1.5, 1.5)
    local stopActionTen = createParticleOut(0.5, func)
    local sequenceActionTen = createSequence(cistbleTen1, delayTen1, cistbleTen2, 
        delayTen2, stopActionTen)
    
    local node = createTotleAction(particleOne, spawnActionOne, particleTwo, spawnActionTwo,
          particleThree, spawnActionThree, particleFour, spawnActionFour, 
          particleFive, sequenceActionFive, particleSix, sequenceActionSix,
          particleSeven, sequenceActionSeven,particleEight, sequenceActionEight,
          particleNine, sequenceActionNine, particleTen, sequenceActionTen)
    --particleOne:runAction(spawnActionOne)

    return node
end

function UI_Wujiangtupojiaqiangzhongjian(func)
    --武将碎片
    local particleOne = createParticle("ui_b005001", cc.p(317,200))
    local scaleToActionOne  = createScaleTo(0, 1.4, 1.4)
    local delayActionOne = createParticleDelay(0.5)
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local spawnActionOne = createSpawn( scaleToActionOne, sequenceActionOne)


    --武将碎片能量
    local particleThree = createParticle("ui_b007102", cc.p(317,200))
    local delayThree = createParticleDelay(0.45)
    local bezierThree1 = createRandomBezier(0.33, cc.p(1300,435), cc.p(-700,600), cc.p(356,776),270,-270)
    local bezierThree2 = createRandomBezier(0.26, cc.p(210,408), cc.p(301,436), cc.p(383,450))
    local bezierThree3 = createRandomBezier(0.2, cc.p(463,464), cc.p(600,522), cc.p(583,591))
    local bezierThree4 = createRandomBezier(0.2, cc.p(552,689), cc.p(478,747), cc.p(356,776))
    local delayThree2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionThree = createSequence(delayThree, bezierThree1,
          delayThree2,stopActionTwo)
    local spawnActionThree = createSpawn(sequenceActionThree)
    local node = createTotleAction(particleOne, spawnActionOne,
          particleThree, spawnActionThree)

    return node
end

function UI_Wujiangtupojiaqiangzuomian(func)--武将突破加强左面粒子
    --武将碎片
    local particleOne = createParticle("ui_b005001", cc.p(190,200))
    local scaleToActionOne  = createScaleTo(0, 1.4, 1.4)
    local delayActionOne = createParticleDelay(0.5)
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local spawnActionOne = createSpawn( scaleToActionOne, sequenceActionOne)


    --武将碎片能量
    local particleThree = createParticle("ui_b007102", cc.p(190,200))
    local delayThree = createParticleDelay(0.45)
    local bezierThree1 = createRandomBezier(0.33, cc.p(1300,435), cc.p(-700,600), cc.p(356,776),270,-270)
    local bezierThree2 = createRandomBezier(0.26, cc.p(210,408), cc.p(301,436), cc.p(383,450))
    local bezierThree3 = createRandomBezier(0.2, cc.p(463,464), cc.p(600,522), cc.p(583,591))
    local bezierThree4 = createRandomBezier(0.2, cc.p(552,689), cc.p(478,747), cc.p(356,776))
    local delayThree2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionThree = createSequence(delayThree, bezierThree1,
          delayThree2,stopActionTwo)
    local spawnActionThree = createSpawn(sequenceActionThree)
    local node = createTotleAction(particleOne, spawnActionOne,
          particleThree, spawnActionThree)

    return node
end

function UI_Wujiangtupojiaqiangyoumian(func)--武将突破加强右面粒子

    --突破丹
    local particleTwo = createParticle("ui_b005001", cc.p(440,200))
    local scaleToActionTwo  = createScaleTo(0, 1.4, 1.4)
    local delayActionTwo = createParticleDelay(0.5)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)
    local spawnActionTwo = createSpawn( scaleToActionTwo, sequenceActionTwo)


    --突破丹能量
    local particleFour = createParticle("ui_b007102", cc.p(440,200))
    local delayFour = createParticleDelay(0.45)
    local bezierFour1 = createRandomBezier(0.3, cc.p(-600,407), cc.p(1200,661), cc.p(242,769),300,-260)
    local bezierFour2 = createRandomBezier(0.26, cc.p(423,420), cc.p(330,436), cc.p(248,442))
    local bezierFour3 = createRandomBezier(0.2, cc.p(166,448), cc.p(30,497), cc.p(10,560))
    local bezierFour4 = createRandomBezier(0.2, cc.p(20,661), cc.p(125,727), cc.p(242,769))
    local delayFour2 = createParticleDelay(0)
    local stopActionFour = createParticleOut(0.2)

    local sequenceActionFour = createSequence(delayFour, bezierFour1,
        delayFour2,stopActionFour)
    local spawnActionFour = createSpawn(sequenceActionFour)
 
    local node = createTotleAction( particleTwo, spawnActionTwo,
           particleFour, spawnActionFour)

    return node
end

function UI_Wujiangtupojiaqianghoubanbufen(func)--武将突破加强后部分

    --进化前的卡片特效--星星点点
    local particleFive = createParticle("ui_b005003", cc.p(251,720))
    local cistbleFive1 = createVistbleAction(false)
    local delayFive1 = createParticleDelay(1)
    local cistbleFive2 = createVistbleAction(true)
    local delayFive2 = createParticleDelay(0.9)
    --createRestartAction
    local scaleFive = createScaleTo(0, 1.3, 1.3)
    local stopActionFive = createParticleOut(0.3)
    local sequenceActionFive = createSequence(cistbleFive1, delayFive1, cistbleFive2, delayFive2, scaleFive,
        stopActionFive)
    
    --进化前的卡片特效--爆的光
    local particleSix = createParticle("ui_b007104", cc.p(251,720))
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0.73)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_b007104")
    local scaleSix = createScaleTo(0.06, 1.35, 1.35)
    local delaySix2 = createParticleDelay(0.5)
    local stopActionSix = createParticleOut(0.5)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2,scaleSix, 
        delaySix2, stopActionSix)



    --进化前的卡片特效--爆的法阵
    local particleSeven = createParticle("ui_b005004", cc.p(251,720))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(0.8)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_b005004")
    local scaleSeven = createScaleTo(0, 1.2, 1.2)
    local delaySeven2 = createParticleDelay(0.35)
    local stopActionSeven = createParticleOut(0.3)
    local sequenceActionSeven= createSequence(cistbleSeven1, delaySeven1, cistbleSeven2, 
        particleSeven2,scaleSeven, delaySeven2, stopActionSeven)



    --人物闪
    local particleSeventeen = createParticle("ui_b007105", cc.p(251,720))
    local cistbleSeventeen1 = createVistbleAction(false)
    local delaySeventeen1 = createParticleDelay(1.2)
    local cistbleSeventeen2 = createVistbleAction(true)
    local particleSeventeen2 = createRestartAction("ui_b007105")
    local delaySeventeen2 = createParticleDelay(1.5)
    local stopActionSeventeen = createParticleOut(0.3)
    local sequenceActionSeventeen= createSequence(cistbleSeventeen1, delaySeventeen1, cistbleSeventeen2, 
        particleSeventeen2, delaySeventeen2, stopActionSeventeen)



    --进化前的卡片特效--聚气光线
    local particleSixteen = createParticle("ui_b003001", cc.p(251,720))
    local cistbleSixteen1 = createVistbleAction(false)
    local delaySixteen1 = createParticleDelay(0.8)
    local cistbleSixteen2 = createVistbleAction(true)
    local particleSixteen2 = createRestartAction("ui_b003001")
    local scaleSixteen = createScaleTo(0, 1.6, 1.6)
    local delaySixteen2 = createParticleDelay(0.35)
    local stopActionSixteen = createParticleOut(0.3)
    local sequenceActionSixteen= createSequence(cistbleSixteen1, delaySixteen1, cistbleSixteen2, 
        particleSixteen2,scaleSixteen, delaySixteen2, stopActionSixteen)

    --进化前的卡片特效--云持续
    local particleFifteen = createParticle("ui_b007103", cc.p(251,720))
    local cistbleFifteen1 = createVistbleAction(false)
    local delayFifteen1 = createParticleDelay(0.7)
    local cistbleFifteen2 = createVistbleAction(true)
    local particleFifteen2 = createRestartAction("ui_b007103")
    local scaleFifteen = createScaleTo(0.06, 1.55, 1.55)
    local delayFifteen2 = createParticleDelay(2)
    local stopActionFifteen = createParticleOut(0.2)
    local sequenceActionFifteen= createSequence(cistbleFifteen1, delayFifteen1, cistbleFifteen2, particleFifteen2,scaleFifteen, 
        delayFifteen2, stopActionFifteen)


    --进化后的卡片特效——爆的光晕
    local particleFourteen = createParticle("ui_b003004", cc.p(251,720))
    local cistbleFourteen1 = createVistbleAction(false)
    local delayFourteen1 = createParticleDelay(2.6)
    local cistbleFourteen2 = createVistbleAction(true)
    local particleFourteen2 = createRestartAction("ui_b003004")
    local scaleFourteen = createScaleTo(0.05, 2.4, 2.4)
    local delayFourteen2 = createParticleDelay(0.2)
    local stopActionFourteen = createParticleOut(0.1)
    local sequenceActionFourteen= createSequence(cistbleFourteen1, delayFourteen1, cistbleFourteen2, 
        particleFourteen2,scaleFourteen, delayFourteen2, stopActionFourteen)



    --进化后的卡片特效——爆的法阵
    local particleEight = createParticle("ui_b005006", cc.p(251,720))
    local cistbleEight1 = createVistbleAction(false)
    local delayEight1 = createParticleDelay(2.8)
    local cistbleEight2 = createVistbleAction(true)
    local particleEight2 = createRestartAction("ui_b005006")
    local scaleEight = createScaleTo(0.08, 1.8, 1.8)
    local delayEight2 = createParticleDelay(0.1)
    local stopActionEight = createParticleOut(0.1)
    local sequenceActionEight= createSequence(cistbleEight1, delayEight1, cistbleEight2, 
        particleEight2,scaleEight, delayEight2, stopActionEight)
    

    --进化后的卡片特效——爆的法阵001
    local particleEighteen = createParticle("ui_b003404", cc.p(251,720))
    local cistbleEighteen1 = createVistbleAction(false)
    local delayEighteen1 = createParticleDelay(2.7)
    local cistbleEighteen2 = createVistbleAction(true)
    local particleEighteen2 = createRestartAction("ui_b003404")
    local scaleEighteen = createScaleTo(0.08, 1, 1)
    local delayEighteen2 = createParticleDelay(0.05)
    local stopActionEighteen = createParticleOut(0.02)
    local sequenceActionEighteen= createSequence(cistbleEighteen1, delayEighteen1, cistbleEighteen2, 
        particleEighteen2,scaleEighteen, delayEighteen2, stopActionEighteen)



    --进化后的卡片特效——持续(电)
    local particleThirteen = createParticle("ui_b003203", cc.p(251,720))
    local cistbleThirteen1 = createVistbleAction(false)
    local delayThirteen1 = createParticleDelay(1.2)
    local cistbleThirteen2 = createVistbleAction(true)
    local particleThirteen2 = createRestartAction("ui_b003203")
    local scaleThirteen = createScaleTo(0.12, 2.7, 2.7)
    local delayThirteen2 = createParticleDelay(1.5)
    local stopActionThirteen = createParticleOut(0.5)
    local sequenceActionThirteen= createSequence(cistbleThirteen1, delayThirteen1, cistbleThirteen2, 
        particleThirteen2,scaleThirteen,delayThirteen2, stopActionThirteen)



    --进化后的卡片特效--星星点点
    local particleNine = createParticle("ui_b007106", cc.p(251,720))
    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(1.5)
    local cistbleNine2 = createVistbleAction(true)
    local delayNine2 = createParticleDelay(1.65)
    local scaleNine = createScaleTo(0, 1.4, 1.4)
    local stopActionNine = createParticleOut(0.5)
    local sequenceActionNine = createSequence(cistbleNine1, delayNine1, cistbleNine2, 
        delayNine2,scaleNine,stopActionNine)
    
    --进化后的卡片特效--云(持续)
    local particleTen = createParticle("ui_b007101", cc.p(251,720))
    local cistbleTen1 = createVistbleAction(false)
    local delayTen1 = createParticleDelay(1.1)
    local cistbleTen2 = createVistbleAction(true)
    local delayTen2 = createParticleDelay(1.8)
    local scaleTen = createScaleTo(0, 1.6, 1.6)
    local stopActionTen = createParticleOut(0.6, func)
    local sequenceActionTen = createSequence(cistbleTen1, delayTen1, cistbleTen2, 
        delayTen2,scaleTen, stopActionTen)
    
    local node = createTotleAction(particleFive,sequenceActionFive,particleSix,sequenceActionSix,particleSeven,
        sequenceActionSeven,particleSeventeen,sequenceActionSeventeen,particleSixteen,sequenceActionSixteen,
        particleFifteen,sequenceActionFifteen,particleFourteen,sequenceActionFourteen,particleEight,
        sequenceActionEight,particleEighteen,sequenceActionEighteen,particleThirteen,sequenceActionThirteen,
        particleNine,sequenceActionNine,particleTen,sequenceActionTen)
          
    return node
end

function UI_Wujiangtupojiaqiangxin(func)--武将突破加强新

    --武将碎片
    local particleOne = createParticle("ui_b005001", cc.p(136,188))
    local scaleToActionOne  = createScaleTo(0, 1.4, 1.4)
    local delayActionOne = createParticleDelay(0.5)
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local spawnActionOne = createSpawn( scaleToActionOne, sequenceActionOne)


    --武将碎片能量
    local particleThree = createParticle("ui_b007102", cc.p(136,188))
    local delayThree = createParticleDelay(0.45)
    local bezierThree1 = createRandomBezier(0.33, cc.p(1300,435), cc.p(-700,600), cc.p(356,776),270,-270)
    local bezierThree2 = createRandomBezier(0.26, cc.p(210,408), cc.p(301,436), cc.p(383,450))
    local bezierThree3 = createRandomBezier(0.2, cc.p(463,464), cc.p(600,522), cc.p(583,591))
    local bezierThree4 = createRandomBezier(0.2, cc.p(552,689), cc.p(478,747), cc.p(356,776))
    local delayThree2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionThree = createSequence(delayThree, bezierThree1,
          delayThree2,stopActionTwo)
    local spawnActionThree = createSpawn(sequenceActionThree)




    --突破丹
    local particleTwo = createParticle("ui_b005001", cc.p(510,188))
    local scaleToActionTwo  = createScaleTo(0, 1.4, 1.4)
    local delayActionTwo = createParticleDelay(0.5)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)
    local spawnActionTwo = createSpawn( scaleToActionTwo, sequenceActionTwo)


    --突破丹能量
    local particleFour = createParticle("ui_b007102", cc.p(510,188))
    local delayFour = createParticleDelay(0.45)
    local bezierFour1 = createRandomBezier(0.3, cc.p(-600,407), cc.p(1200,661), cc.p(242,769),300,-260)
    local bezierFour2 = createRandomBezier(0.26, cc.p(423,420), cc.p(330,436), cc.p(248,442))
    local bezierFour3 = createRandomBezier(0.2, cc.p(166,448), cc.p(30,497), cc.p(10,560))
    local bezierFour4 = createRandomBezier(0.2, cc.p(20,661), cc.p(125,727), cc.p(242,769))
    local delayFour2 = createParticleDelay(0)
    local stopActionFour = createParticleOut(0.2)

    local sequenceActionFour = createSequence(delayFour, bezierFour1,
        delayFour2,stopActionFour)
    local spawnActionFour = createSpawn(sequenceActionFour)

    --突破丹
    local particleEleven = createParticle("ui_b005001", cc.p(317,186))
    local scaleToActionEleven  = createScaleTo(0, 1.4, 1.4)
    local delayActionEleven = createParticleDelay(0.5)
    local stopActionEleven = createParticleOut(0.3)
    local sequenceActionEleven = createSequence(delayActionEleven, stopActionEleven)
    local spawnActionEleven = createSpawn( scaleToActionEleven, sequenceActionEleven)


    --突破丹能量
    local particleTwelve = createParticle("ui_b007102", cc.p(510,188))
    local delayTwelve = createParticleDelay(0.45)
    local bezierTwelve1 = createRandomBezier(0.35, cc.p(540,409), cc.p(740,1300), cc.p(288,775),400,-300)
    local bezierTwelve2 = createRandomBezier(0.2, cc.p(383,408), cc.p(271,473), cc.p(366,509) )
    local bezierTwelve3 = createRandomBezier(0.25, cc.p(272,548), cc.p(365,590), cc.p(257,621))
    local bezierTwelve4 = createRandomBezier(0.2, cc.p(369,674), cc.p(242,703), cc.p(288,775))
    local delayTwelve2 = createParticleDelay(0)
    local stopActionTwelve = createParticleOut(0.2)

    local sequenceActionTwelve = createSequence(delayTwelve, bezierTwelve1, 
        delayTwelve2,stopActionTwelve)
    local spawnActionTwelve = createSpawn(sequenceActionTwelve)

    --进化前的卡片特效--星星点点
    local particleFive = createParticle("ui_b005003", cc.p(251,720))
    local cistbleFive1 = createVistbleAction(false)
    local delayFive1 = createParticleDelay(1)
    local cistbleFive2 = createVistbleAction(true)
    local delayFive2 = createParticleDelay(0.9)
    --createRestartAction
    local scaleFive = createScaleTo(0, 1.3, 1.3)
    local stopActionFive = createParticleOut(0.3)
    local sequenceActionFive = createSequence(cistbleFive1, delayFive1, cistbleFive2, delayFive2, scaleFive,
        stopActionFive)
    
    --进化前的卡片特效--爆的光
    local particleSix = createParticle("ui_b007104", cc.p(251,720))
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0.73)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_b007104")
    local scaleSix = createScaleTo(0.06, 1.35, 1.35)
    local delaySix2 = createParticleDelay(0.5)
    local stopActionSix = createParticleOut(0.5)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2,scaleSix, 
        delaySix2, stopActionSix)



    --进化前的卡片特效--爆的法阵
    local particleSeven = createParticle("ui_b005004", cc.p(251,720))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(0.8)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_b005004")
    local scaleSeven = createScaleTo(0, 1.2, 1.2)
    local delaySeven2 = createParticleDelay(0.35)
    local stopActionSeven = createParticleOut(0.3)
    local sequenceActionSeven= createSequence(cistbleSeven1, delaySeven1, cistbleSeven2, 
        particleSeven2,scaleSeven, delaySeven2, stopActionSeven)



    --人物闪
    local particleSeventeen = createParticle("ui_b007105", cc.p(251,720))
    local cistbleSeventeen1 = createVistbleAction(false)
    local delaySeventeen1 = createParticleDelay(1.2)
    local cistbleSeventeen2 = createVistbleAction(true)
    local particleSeventeen2 = createRestartAction("ui_b007105")
    local delaySeventeen2 = createParticleDelay(1.5)
    local stopActionSeventeen = createParticleOut(0.3)
    local sequenceActionSeventeen= createSequence(cistbleSeventeen1, delaySeventeen1, cistbleSeventeen2, 
        particleSeventeen2, delaySeventeen2, stopActionSeventeen)



    --进化前的卡片特效--聚气光线
    local particleSixteen = createParticle("ui_b003001", cc.p(251,720))
    local cistbleSixteen1 = createVistbleAction(false)
    local delaySixteen1 = createParticleDelay(0.8)
    local cistbleSixteen2 = createVistbleAction(true)
    local particleSixteen2 = createRestartAction("ui_b003001")
    local scaleSixteen = createScaleTo(0, 1.6, 1.6)
    local delaySixteen2 = createParticleDelay(0.35)
    local stopActionSixteen = createParticleOut(0.3)
    local sequenceActionSixteen= createSequence(cistbleSixteen1, delaySixteen1, cistbleSixteen2, 
        particleSixteen2,scaleSixteen, delaySixteen2, stopActionSixteen)

    --进化前的卡片特效--云持续
    local particleFifteen = createParticle("ui_b007103", cc.p(251,720))
    local cistbleFifteen1 = createVistbleAction(false)
    local delayFifteen1 = createParticleDelay(0.7)
    local cistbleFifteen2 = createVistbleAction(true)
    local particleFifteen2 = createRestartAction("ui_b007103")
    local scaleFifteen = createScaleTo(0.06, 1.55, 1.55)
    local delayFifteen2 = createParticleDelay(2)
    local stopActionFifteen = createParticleOut(0.2)
    local sequenceActionFifteen= createSequence(cistbleFifteen1, delayFifteen1, cistbleFifteen2, particleFifteen2,scaleFifteen, 
        delayFifteen2, stopActionFifteen)


    --进化后的卡片特效——爆的光晕
    local particleFourteen = createParticle("ui_b003004", cc.p(251,720))
    local cistbleFourteen1 = createVistbleAction(false)
    local delayFourteen1 = createParticleDelay(2.6)
    local cistbleFourteen2 = createVistbleAction(true)
    local particleFourteen2 = createRestartAction("ui_b003004")
    local scaleFourteen = createScaleTo(0.05, 2.4, 2.4)
    local delayFourteen2 = createParticleDelay(0.2)
    local stopActionFourteen = createParticleOut(0.1)
    local sequenceActionFourteen= createSequence(cistbleFourteen1, delayFourteen1, cistbleFourteen2, 
        particleFourteen2,scaleFourteen, delayFourteen2, stopActionFourteen)



    --进化后的卡片特效——爆的法阵
    local particleEight = createParticle("ui_b005006", cc.p(251,720))
    local cistbleEight1 = createVistbleAction(false)
    local delayEight1 = createParticleDelay(2.8)
    local cistbleEight2 = createVistbleAction(true)
    local particleEight2 = createRestartAction("ui_b005006")
    local scaleEight = createScaleTo(0.08, 1.8, 1.8)
    local delayEight2 = createParticleDelay(0.1)
    local stopActionEight = createParticleOut(0.1)
    local sequenceActionEight= createSequence(cistbleEight1, delayEight1, cistbleEight2, 
        particleEight2,scaleEight, delayEight2, stopActionEight)
    

    --进化后的卡片特效——爆的法阵001
    local particleEighteen = createParticle("ui_b003404", cc.p(251,720))
    local cistbleEighteen1 = createVistbleAction(false)
    local delayEighteen1 = createParticleDelay(2.7)
    local cistbleEighteen2 = createVistbleAction(true)
    local particleEighteen2 = createRestartAction("ui_b003404")
    local scaleEighteen = createScaleTo(0.08, 1, 1)
    local delayEighteen2 = createParticleDelay(0.05)
    local stopActionEighteen = createParticleOut(0.02)
    local sequenceActionEighteen= createSequence(cistbleEighteen1, delayEighteen1, cistbleEighteen2, 
        particleEighteen2,scaleEighteen, delayEighteen2, stopActionEighteen)



    --进化后的卡片特效——持续(电)
    local particleThirteen = createParticle("ui_b003203", cc.p(251,720))
    local cistbleThirteen1 = createVistbleAction(false)
    local delayThirteen1 = createParticleDelay(1.2)
    local cistbleThirteen2 = createVistbleAction(true)
    local particleThirteen2 = createRestartAction("ui_b003203")
    local scaleThirteen = createScaleTo(0.12, 2.7, 2.7)
    local delayThirteen2 = createParticleDelay(1.5)
    local stopActionThirteen = createParticleOut(0.5)
    local sequenceActionThirteen= createSequence(cistbleThirteen1, delayThirteen1, cistbleThirteen2, 
        particleThirteen2,scaleThirteen,delayThirteen2, stopActionThirteen)



    --进化后的卡片特效--星星点点
    local particleNine = createParticle("ui_b007106", cc.p(251,720))
    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(1.5)
    local cistbleNine2 = createVistbleAction(true)
    local delayNine2 = createParticleDelay(1.65)
    local scaleNine = createScaleTo(0, 1.4, 1.4)
    local stopActionNine = createParticleOut(0.5)
    local sequenceActionNine = createSequence(cistbleNine1, delayNine1, cistbleNine2, 
        delayNine2,scaleNine,stopActionNine)
    
    --进化后的卡片特效--云(持续)
    local particleTen = createParticle("ui_b007101", cc.p(251,720))
    local cistbleTen1 = createVistbleAction(false)
    local delayTen1 = createParticleDelay(1.1)
    local cistbleTen2 = createVistbleAction(true)
    local delayTen2 = createParticleDelay(1.8)
    local scaleTen = createScaleTo(0, 1.6, 1.6)
    local stopActionTen = createParticleOut(0.6, func)
    local sequenceActionTen = createSequence(cistbleTen1, delayTen1, cistbleTen2, 
        delayTen2,scaleTen, stopActionTen)
    
    local node = createTotleAction(particleOne, spawnActionOne,particleThree, spawnActionThree,particleTwo, spawnActionTwo,
                                   particleEleven, spawnActionEleven,particleTwelve, spawnActionTwelve,particleFive, sequenceActionFive,particleSix, 
                                   sequenceActionSix,particleFour, spawnActionFour,
                                   particleFifteen, sequenceActionFifteen,particleSeven, sequenceActionSeven,
                                   particleSixteen, sequenceActionSixteen,
                                   particleEight, sequenceActionEight,particleEighteen, sequenceActionEighteen,particleThirteen, sequenceActionThirteen,
                                   particleSeventeen, sequenceActionSeventeen,
                                   particleNine, sequenceActionNine,particleTen, sequenceActionTen,particleFourteen, sequenceActionFourteen)
          


    return node
end

function UI_Wujiangshengjirenwushengji(func)--武将升级人物升级特效02
    --云雾
    local particleOne = createParticle("ui_a000401", cc.p(320,730)) 

    local cistbleOne1 = createVistbleAction(false)
    local delayOne1 = createParticleDelay(1)
    local cistbleOne2 = createVistbleAction(true)
    local particleOne2 = createRestartAction("ui_a000401")

    local delayActionOne = createParticleDelay(0.35)
    local stopActionOne = createParticleOut(1, func)
    local sequenceActionOne = createSequence(cistbleOne1, delayOne1, cistbleOne2, particleOne2, 
          delayActionOne, stopActionOne)
    
    --爆的法阵
    local particleSix = createParticle("ui_a000402", cc.p(320,750))

    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(1)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a000402")

    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.2)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2, 
          delaySix2, stopActionSix)

    --能量左
    local particleTwo = createParticle("ui_a000403", cc.p(0,750))
    local delayTwo = createParticleDelay(0.3)
    local bezierTwo1 = createRandomBezier(0.4, cc.p(0,500), cc.p(320,500), cc.p(320,500))
    local bezierTwo2 = createRandomBezier(0.25, cc.p(480,500), cc.p(480,750), cc.p(480,750))
    local bezierTwo3 = createRandomBezier(0.15, cc.p(480,900), cc.p(320,900), cc.p(320,900))
    local bezierTwo4 = createRandomBezier(0.15, cc.p(160,675), cc.p(160,675), cc.p(320,750))
    local delayTwo2 = createParticleDelay(0.3)
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionTwo = createSequence(bezierTwo1, bezierTwo2, bezierTwo3, 
          bezierTwo4, delayTwo,stopActionTwo)

    --能量右
    local particleThree = createParticle("ui_a000403", cc.p(640,750))
    local delayThree = createParticleDelay(0.3)
    local bezierThree1 = createRandomBezier(0.4, cc.p(640,900), cc.p(320,900), cc.p(320,900))
    local bezierThree2 = createRandomBezier(0.25, cc.p(160,900), cc.p(160,750), cc.p(160,750))
    local bezierThree3 = createRandomBezier(0.15, cc.p(160,600), cc.p(320,600), cc.p(320,600))
    local bezierThree4 = createRandomBezier(0.15, cc.p(480,675), cc.p(480,675), cc.p(320,750))
    local delayThree2 = createParticleDelay(0.3)
    local stopActionThree = createParticleOut(0.2)
    local sequenceActionThree = createSequence(bezierThree1, bezierThree2, bezierThree3, 
          bezierThree4, delayThree2,stopActionThree)

    -- local node = createTotleAction(particleTwo, sequenceActionTwo, particleThree, sequenceActionThree)
    local node = createTotleAction(particleOne, sequenceActionOne, particleSix, sequenceActionSix, 
                 particleTwo, sequenceActionTwo, particleThree, sequenceActionThree)

    return node
end

function UI_Wujiangshengjirenwushengjiyijian(func)--武将升级人物升级特效02_01
    --云雾
    local particleOne = createParticle("ui_a000401", cc.p(320,730)) 
    local cistbleOne1 = createVistbleAction(false)
    local delayOne1 = createParticleDelay(5)
    local cistbleOne2 = createVistbleAction(true)
    local particleOne2 = createRestartAction("ui_a000401")
    local delayActionOne = createParticleDelay(0.35)
    local stopActionOne = createParticleOut(1, func)
    local sequenceActionOne = createSequence(cistbleOne1, delayOne1, cistbleOne2, particleOne2, delayActionOne, stopActionOne)
    
    --爆的法阵
    local particleFive = createParticle("ui_a000407", cc.p(320,750))
    local cistbleFive1 = createVistbleAction(false)
    local delayFive1 = createParticleDelay(5)
    local cistbleFive2 = createVistbleAction(true)
    local particleFive2 = createRestartAction("ui_a000407")
    local delayFive2 = createParticleDelay(0.2)
    local stopActionFive = createParticleOut(0.2)
    local sequenceActionFive = createSequence(cistbleFive1, delayFive1, cistbleFive2, particleFive2, 
          delayFive2, stopActionFive)

    --持续的法阵
    local particleFour = createParticle("ui_a000406", cc.p(320,750))
    local cistbleFour1 = createVistbleAction(false)
    local delayFour1 = createParticleDelay(1)
    local cistbleFour2 = createVistbleAction(true)
    local particleFour2 = createRestartAction("ui_a000406")
    local delayFour2 = createParticleDelay(4)
    local stopActionFour = createParticleOut(0.2)
    local sequenceActionFour= createSequence(cistbleFour1, delayFour1, cistbleFour2, particleFour2, delayFour2, stopActionFour)

    -- 待机火点
    local particleSix = createParticle("ui_a000404", cc.p(320,750))
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0.4)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a000404")
    local delaySix2 = createParticleDelay(4.6)
    local stopActionSix = createParticleOut(0.8)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2, delaySix2, stopActionSix)

    --能量左
    local particleTwo = createParticle("ui_a000405", cc.p(0,750))
    local delayTwo = createParticleDelay(0.3)
    local bezierTwo1 = createRandomBezier(0.3, cc.p(0,500), cc.p(320,500), cc.p(320,500))
    local bezierTwo2 = createRandomBezier(0.2, cc.p(480,500), cc.p(480,750), cc.p(480,750))
    local bezierTwo3 = createRandomBezier(0.1, cc.p(480,900), cc.p(320,900), cc.p(320,900))
    local bezierTwo4 = createRandomBezier(0.1, cc.p(160,675), cc.p(160,675), cc.p(320,750))
    local delayTwo2 = createParticleDelay(4)
    local stopActionTwo = createParticleOut(0.7)
    local sequenceActionTwo = createSequence(bezierTwo1, bezierTwo2, bezierTwo3, 
          bezierTwo4, delayTwo,stopActionTwo)

    --能量右
    local particleThree = createParticle("ui_a000405", cc.p(640,750))
    local delayThree = createParticleDelay(0.3)
    local bezierThree1 = createRandomBezier(0.3, cc.p(640,900), cc.p(320,900), cc.p(320,900))
    local bezierThree2 = createRandomBezier(0.2, cc.p(160,900), cc.p(160,750), cc.p(160,750))
    local bezierThree3 = createRandomBezier(0.1, cc.p(160,600), cc.p(320,600), cc.p(320,600))
    local bezierThree4 = createRandomBezier(0.1, cc.p(480,675), cc.p(480,675), cc.p(320,750))
    local delayThree2 = createParticleDelay(4)
    local stopActionThree = createParticleOut(0.7)
    local sequenceActionThree = createSequence(bezierThree1, bezierThree2, bezierThree3, 
          bezierThree4, delayThree2,stopActionThree)

    --能量左
    local particleTwo0 = createParticle("ui_a000405", cc.p(0,750))
    local delayTwo0 = createParticleDelay(0.5)
    local bezierTwo10 = createRandomBezier(0.3, cc.p(0,500), cc.p(320,500), cc.p(320,500))
    local bezierTwo20 = createRandomBezier(0.2, cc.p(480,500), cc.p(480,750), cc.p(480,750))
    local bezierTwo30 = createRandomBezier(0.1, cc.p(480,900), cc.p(320,900), cc.p(320,900))
    local bezierTwo40 = createRandomBezier(0.1, cc.p(160,675), cc.p(160,675), cc.p(320,750))
    local delayTwo20 = createParticleDelay(0.3)
    local stopActionTwo0 = createParticleOut(0.7)
    local sequenceActionTwo0 = createSequence(delayTwo0,bezierTwo10, bezierTwo20, bezierTwo30, 
          bezierTwo40, delayTwo0,stopActionTwo0)

    --能量右
    local particleThree0 = createParticle("ui_a000405", cc.p(640,750))
    local delayThree0 = createParticleDelay(0.5)
    local bezierThree10 = createRandomBezier(0.3, cc.p(640,900), cc.p(320,900), cc.p(320,900))
    local bezierThree20 = createRandomBezier(0.2, cc.p(160,900), cc.p(160,750), cc.p(160,750))
    local bezierThree30 = createRandomBezier(0.1, cc.p(160,600), cc.p(320,600), cc.p(320,600))
    local bezierThree40 = createRandomBezier(0.1, cc.p(480,675), cc.p(480,675), cc.p(320,750))
    local delayThree20 = createParticleDelay(0.3)
    local stopActionThree0 = createParticleOut(0.7)
    local sequenceActionThree0 = createSequence(delayThree0,bezierThree10, bezierThree20, bezierThree30, 
          bezierThree40, delayThree20,stopActionThree0)

    local node = createTotleAction(
        particleOne, sequenceActionOne, 
        particleSix, sequenceActionSix,particleFive,sequenceActionFive,
        particleTwo0, sequenceActionTwo0, particleThree0, sequenceActionThree0,
                 particleTwo, sequenceActionTwo, particleThree, sequenceActionThree,particleFour,sequenceActionFour
                 )

    return node
end

function UI_Wujiangshengjidanyao()--吃武将升级丹药03
    --云雾
    local particleOne = createParticle("ui_a000202", cc.p(0,0))
    local scaleToActionOne  = createScaleTo(0, 1.2, 1)
    local delayActionOne = createParticleDelay(0.35)
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --星星
    local particleTwo = createParticle("ui_a000203", cc.p(0,0))
    local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(0.5)
    local stopActionTwo = createParticleOut(0.5)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    --整体发光
    local particleThree = createParticle("ui_a000201", cc.p(0,0))
    local scaleToActionThree = createScaleTo(0, 1, 1)
    local delayActionThree = createParticleDelay(0.3)
    local stopActionThree = createParticleOut(0.5)
    local sequenceActionThree = createSequence(delayActionThree , stopActionThree)
    local spawnActionThree = createSpawn( scaleToActionThree , sequenceActionThree)

    local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne,
                                   particleThree, spawnActionThree)
    return node
end

function UI_Wujiangshengjijingyantiao(func)--吃武将升级经验条04
    --雾状颗粒
    local particleOne = createParticle("ui_a000301", cc.p(410,490)) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(9999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

-- 新版本特效中不再使用此特效
--[[function UI_Zhaungbeiqianghua(func)--装备强化05
    --颗粒不动
    local particleTwo = createParticle("ui_a000502", cc.p(330,590))

    -- local scaleToActionOne  = createScaleTo(0, 1.5, 1.5)
    local delayActionTwo = createParticleDelay(0.5)--持续时间
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    --颗粒收缩
    local particleSix = createParticle("ui_a000501", cc.p(330,590))

    local scaleToActionSix  = createScaleTo(0, 1.5, 1.5)
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0.6)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a000501")

    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.2)
    local sequenceActionSix= createSequence(cistbleSix1, scaleToActionSix, delaySix1, cistbleSix2, 
          particleSix2, delaySix2, stopActionSix)

    --爆法阵
    local particleSeven = createParticle("ui_a000503", cc.p(330,590))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(0.8)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_a000503")
    local delaySeven2 = createParticleDelay(0.2)
    local stopActionSeven = createParticleOut(0.3)
    local sequenceActionSeven= createSequence(cistbleSeven1, delaySeven1, cistbleSeven2, 
          particleSeven2, delaySeven2, stopActionSeven)

    --云雾
    local particleOne = createParticle("ui_a000504", cc.p(320,580)) 

    local cistbleOne1 = createVistbleAction(false)
    local delayOne1 = createParticleDelay(0.85)
    local cistbleOne2 = createVistbleAction(true)
    local particleOne2 = createRestartAction("ui_a000504")

    local delayActionOne = createParticleDelay(0.35)
    local stopActionOne = createParticleOut(1, func)
    local sequenceActionOne = createSequence(cistbleOne1, delayOne1, cistbleOne2, particleOne2, 
          delayActionOne, stopActionOne)

    --上升颗粒
    local particleThree = createParticle("ui_a000505", cc.p(320,650)) 

    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(0.85)
    local cistbleThree2 = createVistbleAction(true)
    local particleThree2 = createRestartAction("ui_a000505")

    local delayActionThree = createParticleDelay(0.35)
    local stopActionThree = createParticleOut(1)
    local sequenceActionThree = createSequence(cistbleThree1, delayThree1, cistbleThree2, particleThree2, 
          delayActionThree, stopActionThree)

    local node = createTotleAction(particleThree, sequenceActionThree, particleOne, sequenceActionOne, particleTwo, sequenceActionTwo, 
          particleSix, sequenceActionSix, particleSeven, sequenceActionSeven)
    return node
end
]]
function UI_Zhuangbeiqianghuahold()
    --图标特效-- 第一个
    local particle = createParticle("ui_b005101", cc.p(318,565) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(999999)--持续时间
    -- local stopActionfive = createParticleOut(0)
    local sequenceAction = createSequence(delayActionfive)

    local node = createTotleAction( particle, sequenceAction)
 
    return node
end

function UI_Zhaungbeiqianghua(func)--装备强化         

    --图标特效-- 第一个
    local particleone = createParticle("ui_b005102", cc.p(326,512) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(1)--持续时间
    local stopActionone = createParticleOut(0)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005103", cc.p(316,519) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(1)--持续时间
    local stopActiontwo = createParticleOut(00)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    --图标特效-- 第一个
    local particlethree = createParticle("ui_b005108", cc.p(318,565) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.1, 1.7)
    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(0)
    local sequenceActionthree = createSequence(scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第一个
    local particlesix = createParticle("ui_b005109", cc.p(318,565) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionsix = createParticleDelay(1.2)--持续时间
    local stopActionsix = createParticleOut(0)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    --图标特效-- 第一个
    local particlefour = createParticle("ui_b005105", cc.p(318,485) )

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.2, 1.2)
    local delayActionfour = createParticleDelay(1.4)--持续时间
    local stopActionfour = createParticleOut(0)
    local sequenceActionfour = createSequence(scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第一个
    local particlefive = createParticle("ui_b005101", cc.p(318,516) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(1)--持续时间
    local stopActionfive = createParticleOut(0)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)

    --图标特效-- 第一个
    local particleseven = createParticle("ui_b005110", cc.p(318,550) )

    -- local moveOne = createParticleMove(cc.p())

    local cistblefourteen1 = createVistbleAction(false)
    local delayfourteen1 = createParticleDelay(0.9)
    local cistblefourteen2 = createVistbleAction(true)

    local delayActionseven = createParticleDelay(0.7)--持续时间
    local stopActionseven = createParticleOut(0, func)
    local sequenceActionseven = createSequence(cistblefourteen1,delayfourteen1,cistblefourteen2,delayActionseven,stopActionseven)
  
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,particlefour,sequenceActionfour, 
                                   particlefive, sequenceActionfive,particlesix, sequenceActionsix,particleseven, sequenceActionseven)
                                 
    return node
end


function UI_Zhaungbeiqianghuajiu(func)--装备强化(旧)05
    cclog("-----------锤子光-------------")
    --锤子光
    local particleTwo = createParticle("A0050_05", cc.p(365,523))
    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo = createParticleDelay(0.1)
    local cistbleTwo2 = createVistbleAction(true)
    local particleTwo2 = createRestartAction("A0050_05")
    local delayActionTwo = createParticleDelay(0.3)--持续时间
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo,cistbleTwo2,particleTwo2,delayActionTwo, stopActionTwo)

    --爆的光
    cclog("-----------爆的光-------------")
    local particleSix = createParticle("A0050_03", cc.p(320,310))
    local cistbleSix1 = createVistbleAction(false)
    local scaleToActionSix  = createScaleTo(0, 1.5, 1.5)
    local delaySix1 = createParticleDelay(0.2)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("A0050_03")
    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.2)
    local sequenceActionSix= createSequence(cistbleSix1, scaleToActionSix, delaySix1, cistbleSix2, 
          particleSix2, delaySix2, stopActionSix)

    --爆周围法阵
    local particleSeven = createParticle("ui_b005103", cc.p(320,520))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(0.2)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_b005103")
    local delaySeven2 = createParticleDelay(0.2)
    local stopActionSeven = createParticleOut(0.3)
    local sequenceActionSeven= createSequence(cistbleSeven1, delaySeven1, cistbleSeven2, 
          particleSeven2, delaySeven2, stopActionSeven)

    --创建序列帧   溅射
    local imageNode = cc.Sprite:create()
    imageNode:setPosition(310,470)

    local particleOne = createAnimation("A0050_06.plist","A0050_0",3,2)
    local delayOne1 = createParticleDelay(0.2)
    local scaleToActionOne1  = createScaleTo(0, 4, 4)
    local stopActionOne = createParticleOut(0)
    local sequenceActionOne = createSequence(delayOne1,scaleToActionOne1,particleOne,stopActionOne)


    --爆的颗粒
    local particleThree = createParticle("A0050_02", cc.p(320,400)) 

    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(0.2)
    local cistbleThree2 = createVistbleAction(true)
    local particleThree2 = createRestartAction("A0050_02")

    local delayActionThree = createParticleDelay(0.35)
    -- local stopActionThree = createParticleOut(1)
    local stopActionThree = createParticleOut(1, func)
    local sequenceActionThree = createSequence(cistbleThree1, delayThree1, cistbleThree2, particleThree2, 
          delayActionThree, stopActionThree)

    --创建序列帧   平地波动左
    local imageNodebodongzuo = cc.Sprite:create()
    imageNodebodongzuo:setPosition(150,400)

    local particleOne22 = createAnimation("A0050_04.plist","A0050_",4,2)
    local delayOne122 = createParticleDelay(0.2)
    local scaleToActionOne122  = createScaleTo(0, 2.5, 2.5)
    local stopActionOne22 = createParticleOut(0)
    local sequenceActionOne22 = createSequence(delayOne122,scaleToActionOne122,particleOne22,stopActionOne22)

    --创建序列帧   平地波动右
    local imageNodebodongyou = cc.Sprite:create()
    imageNodebodongyou:setPosition(490,400)

    local particleOne222 = createAnimation("A0050_04.plist","A0050_",4,2)
    local delayOne1222 = createParticleDelay(0.2)
    local scaleToActionOne1222  = createScaleTo(0, -2.5, 2.5)
    local stopActionOne222 = createParticleOut(0)
    local sequenceActionOne222 = createSequence(delayOne1222,scaleToActionOne1222,particleOne222,stopActionOne222)

    --创建序列帧   锤子
    local imageNodechuizi = cc.Sprite:create()
    imageNodechuizi:setPosition(385,600)
    local particleOne223 = createAnimation("chuizi.plist","equip_stren_sinker_",3,2)
    local sequenceActionOne223 = createSequence(particleOne223)

    local node = createTotleAction(
        imageNodebodongzuo,sequenceActionOne22,imageNodebodongyou,sequenceActionOne222,
        imageNodechuizi,sequenceActionOne223,
        particleTwo,sequenceActionTwo,particleSix,sequenceActionSix,particleSeven,sequenceActionSeven,imageNode, sequenceActionOne,particleThree,sequenceActionThree 
        )
    cclog("-----------创建序列帧   锤子-------------")
    return node
end

function UI_ZhaungbeiqianghuaNew(func)--装备强化新
    --锤子光
    local particleTwo = createParticle("A0050_05", cc.p(365,773))
    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo = createParticleDelay(0.1)
    local cistbleTwo2 = createVistbleAction(true)
    local particleTwo2 = createRestartAction("A0050_05")
    local delayActionTwo = createParticleDelay(0.3)--持续时间
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo,cistbleTwo2,particleTwo2,delayActionTwo, stopActionTwo)

    --爆的光
    local particleSix = createParticle("A0050_03", cc.p(320,590))
    local cistbleSix1 = createVistbleAction(false)
    local scaleToActionSix  = createScaleTo(0, 1.5, 1.5)
    local delaySix1 = createParticleDelay(0.2)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("A0050_03")
    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.2)
    local sequenceActionSix= createSequence(cistbleSix1, scaleToActionSix, delaySix1, cistbleSix2, 
          particleSix2, delaySix2, stopActionSix)

    --爆周围法阵
    local particleSeven = createParticle("ui_b005103", cc.p(320,670))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(0.2)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_b005103")
    local delaySeven2 = createParticleDelay(0.2)
    local stopActionSeven = createParticleOut(0.3)
    local sequenceActionSeven= createSequence(cistbleSeven1, delaySeven1, cistbleSeven2, 
          particleSeven2, delaySeven2, stopActionSeven)

    --创建序列帧   溅射
    local imageNode = cc.Sprite:create()
    imageNode:setPosition(310,720)

    local particleOne = createAnimation("A0050_06.plist","A0050_0",3,2)
    local delayOne1 = createParticleDelay(0.2)
    local scaleToActionOne1  = createScaleTo(0, 4, 4)
    local stopActionOne = createParticleOut(0)
    local sequenceActionOne = createSequence(delayOne1,scaleToActionOne1,particleOne,stopActionOne)


    --爆的颗粒
    local particleThree = createParticle("A0050_02", cc.p(320,650)) 

    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(0.2)
    local cistbleThree2 = createVistbleAction(true)
    local particleThree2 = createRestartAction("A0050_02")

    local delayActionThree = createParticleDelay(0.35)
    local stopActionThree = createParticleOut(1,func)
    local sequenceActionThree = createSequence(cistbleThree1, delayThree1, cistbleThree2, particleThree2, 
          delayActionThree, stopActionThree)

    --创建序列帧   平地波动左
    local imageNodebodongzuo = cc.Sprite:create()
    imageNodebodongzuo:setPosition(150,650)

    local particleOne22 = createAnimation("A0050_04.plist","A0050_",4,2)
    local delayOne122 = createParticleDelay(0.2)
    local scaleToActionOne122  = createScaleTo(0, 2.5, 2.5)
    local stopActionOne22 = createParticleOut(0)
    local sequenceActionOne22 = createSequence(delayOne122,scaleToActionOne122,particleOne22,stopActionOne22)

    --创建序列帧   平地波动右
    local imageNodebodongyou = cc.Sprite:create()
    imageNodebodongyou:setPosition(490,650)

    local particleOne222 = createAnimation("A0050_04.plist","A0050_",4,2)
    local delayOne1222 = createParticleDelay(0.2)
    local scaleToActionOne1222  = createScaleTo(0, -2.5, 2.5)
    local stopActionOne222 = createParticleOut(0)
    local sequenceActionOne222 = createSequence(delayOne1222,scaleToActionOne1222,particleOne222,stopActionOne222)

    --创建序列帧   锤子
    local imageNodechuizi = cc.Sprite:create()
    imageNodechuizi:setPosition(385,850)
    local particleOne223 = createAnimation("chuizi.plist","equip_stren_sinker_",3,2)
    local sequenceActionOne223 = createSequence(particleOne223)

    local node = createTotleAction(
        imageNodebodongzuo,sequenceActionOne22,imageNodebodongyou,sequenceActionOne222,
        imageNodechuizi,sequenceActionOne223,
        particleTwo,sequenceActionTwo,particleSix,sequenceActionSix,particleSeven,sequenceActionSeven,imageNode, sequenceActionOne,particleThree,sequenceActionThree 
        )
    return node
end


function UI_ZhuangbeironglianHode()
    --图标特效-- 第一个
    local particlefive = createParticle("ui_b005201", cc.p(318,516) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(99999)--持续时间
    -- local stopActionfive = createParticleOut(0)
    local sequenceActionfive = createSequence(delayActionfive)

    local node = createTotleAction(particlefive, sequenceActionfive)
    return node
end

--[[function UI_zhuangbeironglian(func)--装备熔炼

   --图标特效-- 第一个
    local particlesix = createParticle("ui_b005204", cc.p(498,643) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionsix = createParticleDelay(0.3)--持续时间
    local stopActionsix = createParticleOut(0)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    --图标特效-- 第一个
    local particleseven = createParticle("ui_b005204", cc.p(528,548) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(0.3)--持续时间
    local stopActionseven = createParticleOut(0)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)


    --图标特效-- 第一个
    local particleeight = createParticle("ui_b005204", cc.p(527,452) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(0.3)--持续时间
    local stopActioneight = createParticleOut(0)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)


    --图标特效-- 第一个
    local particlenine = createParticle("ui_b005204", cc.p(497,357) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionnine = createParticleDelay(0.3)--持续时间
    local stopActionnine = createParticleOut(0)
    local sequenceActionnine = createSequence(delayActionnine,stopActionnine)


    --图标特效-- 第一个
    local particleten = createParticle("ui_b005204", cc.p(157,358) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionten = createParticleDelay(0.3)--持续时间
    local stopActionten = createParticleOut(0)
    local sequenceActionten = createSequence(delayActionten,stopActionten)


    --图标特效-- 第一个
    local particleeleven = createParticle("ui_b005204", cc.p(128,453) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActioneleven = createParticleDelay(0.3)--持续时间
    local stopActioneleven = createParticleOut(0)
    local sequenceActioneleven = createSequence(delayActioneleven,stopActioneleven)


    --图标特效-- 第一个
    local particletwelve = createParticle("ui_b005204", cc.p(126,546) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwelve = createParticleDelay(0.3)--持续时间
    local stopActiontwelve = createParticleOut(0)
    local sequenceActiontwelve = createSequence(delayActiontwelve,stopActiontwelve)

    --图标特效-- 第一个
    local particlethirteen = createParticle("ui_b005204", cc.p(156,642) )

    -- local moveOne = createParticleMove(cc.p())
    local delayActionthirteen = createParticleDelay(0.3)--持续时间
    local stopActionthirteen = createParticleOut(0)
    local sequenceActionthirteen = createSequence(delayActionthirteen,stopActionthirteen)

    --旋转的星星

    local cistblefourteen1 = createVistbleAction(false)
    local delayfourteen1 = createParticleDelay(0.26)
    local cistblefourteen2 = createVistbleAction(true)

    local particlefourteen= createParticle("ui_b005205", cc.p(499,642))
    local delayfourteen = createParticleDelay(0)
    local bezierfourteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(326,488), 300 , -300)
    local delayfourteen2 = createParticleDelay(0)
    local stopActionfourteen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionfourteen = createSequence(cistblefourteen1,delayfourteen1,cistblefourteen2,delayfourteen, bezierfourteen1,
                                              delayfourteen2,stopActionfourteen)
    local spawnActionfourteen = createSpawn(sequenceActionfourteen)
    
    --旋转的星星

    local cistblefifteen1 = createVistbleAction(false)
    local delayfifteen1 = createParticleDelay(0.26)
    local cistblefifteen2 = createVistbleAction(true)

    local particlefifteen= createParticle("ui_b005205", cc.p(526,549))
    local delayfifteen = createParticleDelay(0)
    local bezierfifteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(326,488), 300 , -300)
    local delayfifteen2 = createParticleDelay(0)
    local stopActionfifteen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionfifteen = createSequence(cistblefifteen1,delayfifteen1,cistblefifteen2,delayfifteen, bezierfifteen1,
                                              delayfifteen2,stopActionfifteen)
    local spawnActionfifteen = createSpawn(sequenceActionfifteen)

    --旋转的星星

    local cistblesixteen1 = createVistbleAction(false)
    local delaysixteen1 = createParticleDelay(0.26)
    local cistblesixteen2 = createVistbleAction(true)

    local particlesixteen= createParticle("ui_b005205", cc.p(528,454))
    local delaysixteen = createParticleDelay(0)
    local beziersixteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(326,488), 300 , -300)
    local delaysixteen2 = createParticleDelay(0)
    local stopActionsixteen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionsixteen = createSequence(cistblesixteen1,delaysixteen1,cistblesixteen2,delaysixteen, beziersixteen1,
                                              delaysixteen2,stopActionsixteen)
    local spawnActionsixteen = createSpawn(sequenceActionsixteen)

 
    --旋转的星星

    local cistbleseventeen1 = createVistbleAction(false)
    local delayseventeen1 = createParticleDelay(0.26)
    local cistbleseventeen2 = createVistbleAction(true)

    local particleseventeen= createParticle("ui_b005205", cc.p(496,357))
    local delayseventeen = createParticleDelay(0)
    local bezierseventeen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(326,488), 300 , -300)
    local delayseventeen2 = createParticleDelay(0)
    local stopActionseventeen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionseventeen = createSequence(cistbleseventeen1,delayseventeen1,cistbleseventeen2,delayseventeen, bezierseventeen1,
                                              delayseventeen2,stopActionseventeen)
    local spawnActionseventeen = createSpawn(sequenceActionseventeen)

    
    --旋转的星星

    local cistbleeighteen1 = createVistbleAction(false)
    local delayeighteen1 = createParticleDelay(0.26)
    local cistbleeighteen2 = createVistbleAction(true)

    local particleeighteen= createParticle("ui_b005205", cc.p(158,360))
    local delayeighteen = createParticleDelay(0)
    local beziereighteen1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(326,488), 300 , -300)
    local delayeighteen2 = createParticleDelay(0)
    local stopActioneighteen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActioneighteen = createSequence(cistbleeighteen1,delayeighteen1,cistbleeighteen2,delayeighteen, beziereighteen1,
                                              delayeighteen2,stopActioneighteen)
    local spawnActioneighteen = createSpawn(sequenceActioneighteen)


    --旋转的星星

    local cistblenineteen1 = createVistbleAction(false)
    local delaynineteen1 = createParticleDelay(0.26)
    local cistblenineteen2 = createVistbleAction(true)

    local particlenineteen= createParticle("ui_b005205", cc.p(126,452))
    local delaynineteen = createParticleDelay(0)
    local beziernineteen1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(326,488), 300 , 600)
    local delaynineteen2 = createParticleDelay(0)
    local stopActionnineteen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionnineteen = createSequence(cistblenineteen1,delaynineteen1,cistblenineteen2,delaynineteen, beziernineteen1,
                                              delaynineteen2,stopActionnineteen)
    local spawnActionnineteen = createSpawn(sequenceActionnineteen)

    --旋转的星星

    local cistbletwenty1 = createVistbleAction(false)
    local delaytwenty1 = createParticleDelay(0.26)
    local cistbletwenty2 = createVistbleAction(true)

    local particletwenty= createParticle("ui_b005205", cc.p(127,548))
    local delaytwenty = createParticleDelay(0)
    local beziertwenty1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(326,488), 300 , 600)
    local delaytwenty2 = createParticleDelay(0)
    local stopActiontwenty = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActiontwenty = createSequence(cistbletwenty1,delaytwenty1,cistbletwenty2,delaytwenty, beziertwenty1,
                                              delaytwenty2,stopActiontwenty)
    local spawnActiontwenty = createSpawn(sequenceActiontwenty)

    --旋转的星星

    local cistbletwentyone1 = createVistbleAction(false)
    local delaytwentyone1 = createParticleDelay(0.26)
    local cistbletwentyone2 = createVistbleAction(true)

    local particletwentyone= createParticle("ui_b005205", cc.p(127,548))
    local delaytwentyone = createParticleDelay(0)
    local beziertwentyone1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(326,488), 300 , 600)
    local delaytwentyone2 = createParticleDelay(0)
    local stopActiontwentyone = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActiontwentyone = createSequence(cistbletwentyone1,delaytwentyone1,cistbletwentyone2,delaytwentyone, beziertwentyone1,
                                              delaytwentyone2,stopActiontwentyone)
    local spawnActiontwentyone = createSpawn(sequenceActiontwentyone)


    --旋转的星星

    local cistbletwentytwo1 = createVistbleAction(false)
    local delaytwentytwo1 = createParticleDelay(0.26)
    local cistbletwentytwo2 = createVistbleAction(true)

    local particletwentytwo= createParticle("ui_b005205", cc.p(157,642))
    local delaytwentytwo = createParticleDelay(0)
    local beziertwentytwo1 = createRandomBezier(0.4, cc.p(400,600), cc.p(600,409), cc.p(326,488), 300 , 600)
    local delaytwentytwo2 = createParticleDelay(0)
    local stopActiontwentytwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActiontwentytwo = createSequence(cistbletwentytwo1,delaytwentytwo1,cistbletwentytwo2,delaytwentytwo, beziertwentytwo1,
                                              delaytwentytwo2,stopActiontwentytwo)
    local spawnActiontwentytwo = createSpawn(sequenceActiontwentytwo)


    --图标特效-- 第一个
    local particleone = createParticle("ui_b005202", cc.p(318,492) )

    local cistbleone1 = createVistbleAction(false)
    local delayone1 = createParticleDelay(0.8)
    local cistbleone2 = createVistbleAction(true)

    -- local moveOne = createParticleMove(cc.p())
    local delayActionone = createParticleDelay(1)--持续时间
    local stopActionone = createParticleOut(0)
    local sequenceActionone = createSequence(cistbleone1,delayone1,cistbleone2,delayActionone,stopActionone)

    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005203", cc.p(326,490) )

    local cistbletwo1 = createVistbleAction(false)
    local delaytwo1 = createParticleDelay(0.8)
    local cistbletwo2 = createVistbleAction(true)

    -- local moveOne = createParticleMove(cc.p())
    local delayActiontwo = createParticleDelay(1)--持续时间
    local stopActiontwo = createParticleOut(00)
    local sequenceActiontwo = createSequence(cistbletwo1,delaytwo1,cistbletwo2,delayActiontwo,stopActiontwo)

    --图标特效-- 第一个
    local particlethree = createParticle("ui_b005108", cc.p(318,516) )

    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(0.8)
    local cistblethree2 = createVistbleAction(true)

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 0.15, 1.8)
    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(0)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,scaleToActiotten,delayActionthree,stopActionthree)

    --图标特效-- 第一个
    local particlefour = createParticle("ui_b005109", cc.p(318,485) )

    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(0.8)
    local cistblefour2 = createVistbleAction(true)

    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1.2)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(0)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,scaleToActiotten,delayActionfour,stopActionfour)

    --图标特效-- 第一个
    local particlefive = createParticle("ui_b005201", cc.p(318,516) )

    local cistblefive1 = createVistbleAction(false)
    local delayfive1 = createParticleDelay(0.8)
    local cistblefive2 = createVistbleAction(true)

    -- local moveOne = createParticleMove(cc.p())
    local delayActionfive = createParticleDelay(1)--持续时间
    local stopActionfive = createParticleOut(0)
    local sequenceActionfive = createSequence(cistblefive1,delayfive1,cistblefive2,delayActionfive,stopActionfive)

    --中心爆点--
    local particletwentyfour = createParticle("ui_b005207", cc.p(318,516) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirtwentyfour1 = createVistbleAction(false)
    local delaythirtwentyfour1 = createParticleDelay(1.5)
    local cistblethirtwentyfour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b005207")

    local scaleToActiottwentyfour  = createScaleTo(0.07, 1.7, 1.7)
    local delayActiontwentyfour = createParticleDelay(0.1)--持续时间
    local stopActiontwentyfour = createParticleOut(0.1)
    local sequenceActiontwentyfour = createSequence(cistblethirtwentyfour1,delaythirtwentyfour1,cistblethirtwentyfour2,particletwelveClone,
                                                     scaleToActiottwentyfour, delayActiontwentyfour,stopActiontwentyfour)
    --中心爆点--
    local particletwentyfive = createParticle("ui_b005206", cc.p(318,516) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirtwentyfive1 = createVistbleAction(false)
    local delaythirtwentyfive1 = createParticleDelay(1.6)
    local cistblethirtwentyfive2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b005206")

    local scaleToActiottwentyfive  = createScaleTo(0.0, 1, 1)
    local delayActiontwentyfive = createParticleDelay(0.4)--持续时间
    local stopActiontwentyfive = createParticleOut(0.4)
    local sequenceActiontwentyfive = createSequence(cistblethirtwentyfive1,delaythirtwentyfive1,cistblethirtwentyfive2,particletwelveClone,scaleToActiottwentyfive, 
                                                    delayActiontwentyfive,stopActiontwentyfive)

    --中心爆点--
    local particletwentysix = createParticle("ui_b001804", cc.p(318,516) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirtwentysix1 = createVistbleAction(false)
    local delaythirtwentysix1 = createParticleDelay(1.65)
    local cistblethirtwentysix2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001804")

    local scaleToActiottwentysix  = createScaleTo(0., 0.44, 0.44)
    local delayActiontwentysix = createParticleDelay(0.4)--持续时间
    local stopActiontwentysix = createParticleOut(1, func)
    local sequenceActiontwentysix = createSequence(cistblethirtwentysix1,delaythirtwentysix1,cistblethirtwentysix2,particletwelveClone,scaleToActiottwentysix, 
                                                   delayActiontwentysix,stopActiontwentysix)

    local node = createTotleAction(particlesix, sequenceActionsix,particleseven, sequenceActionseven,particleeight, sequenceActioneight,particlenine, sequenceActionnine,
                                   particleten, sequenceActionten,particleeleven, sequenceActioneleven,particletwelve, sequenceActiontwelve,particlethirteen, sequenceActionthirteen,
                                   particlefourteen, sequenceActionfourteen,

                                   particlefifteen, sequenceActionfifteen,particlesixteen, sequenceActionsixteen,
                                   particleseventeen, sequenceActionseventeen,particleeighteen, sequenceActioneighteen,particlenineteen, sequenceActionnineteen,

                                   particletwenty, sequenceActiontwenty,particletwentyone, sequenceActiontwentyone,particletwentytwo, sequenceActiontwentytwo,
                                   particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree,
                                   particlefour, sequenceActionfour,
                                   particlefive, sequenceActionfive,
                                   particletwentyfour, sequenceActiontwentyfour,particletwentyfive, sequenceActiontwentyfive,
                                   particletwentysix, sequenceActiontwentysix)
    return node
end]]--

function UI_zhuangbeironglian(func)--装备熔炼

    --聚能亮（第一个）
    local particlesix = createParticle("ui_b005208", cc.p(97,266))

    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(0.15)
    local cistblesix2 = createVistbleAction(true)

    local delayActionsix = createParticleDelay(0.5)--持续时间
    local stopActionsix = createParticleOut(0)
    local sequenceActionsix = createSequence(cistblesix1,delaysix1,cistblesix2,delayActionsix,stopActionsix)

    --聚能亮（第二个）
    local particleseven = createParticle("ui_b005208", cc.p(230,266))

    local cistbleseven1 = createVistbleAction(false)
    local delayseven1 = createParticleDelay(0.15)
    local cistbleseven2 = createVistbleAction(true)

    local delayActionseven = createParticleDelay(0.5)--持续时间
    local stopActionseven = createParticleOut(0)
    local sequenceActionseven = createSequence(cistbleseven1,delayseven1,cistbleseven2,delayActionseven,stopActionseven)

    --聚能亮（第三个）
    local particleeight = createParticle("ui_b005208", cc.p(367,266))

    local cistbleeight1 = createVistbleAction(false)
    local delayeight1 = createParticleDelay(0.15)
    local cistbleeight2 = createVistbleAction(true)

    local delayActioneight = createParticleDelay(0.5)--持续时间
    local stopActioneight = createParticleOut(0)
    local sequenceActioneight = createSequence(cistbleeight1,delayeight1,cistbleeight2,delayActioneight,stopActioneight)

    --聚能亮（第四个）
    local particlenine = createParticle("ui_b005208", cc.p(504,266))

    local cistblenine1 = createVistbleAction(false)
    local delaynine1 = createParticleDelay(0.15)
    local cistblenine2 = createVistbleAction(true)

    local delayActionnine = createParticleDelay(0.5)--持续时间
    local stopActionnine = createParticleOut(0)
    local sequenceActionnine = createSequence(cistblenine1,delaynine1,cistblenine2,delayActionnine,stopActionnine)

    --聚能亮（第五个）
    local particleten = createParticle("ui_b005208", cc.p(97,150))

    local cistbleten1 = createVistbleAction(false)
    local delayten1 = createParticleDelay(0.15)
    local cistbleten2 = createVistbleAction(true)

    local delayActionten = createParticleDelay(0.5)--持续时间
    local stopActionten = createParticleOut(0)
    local sequenceActionten = createSequence(cistbleten1,delayten1,cistbleten2,delayActionten,stopActionten)

    --聚能亮（第六个）
    local particlenineteen = createParticle("ui_b005208", cc.p(229,150))

    local cistblenineteen1 = createVistbleAction(false)
    local delaynineteen1 = createParticleDelay(0.15)
    local cistblenineteen2 = createVistbleAction(true)

    local delayActionnineteen = createParticleDelay(0.5)--持续时间
    local stopActionnineteen = createParticleOut(0)
    local sequenceActionnineteen = createSequence(cistblenineteen1,delaynineteen1,cistblenineteen2,delayActionnineteen,stopActionnineteen)

    --聚能亮（第七个）
    local particletwenty = createParticle("ui_b005208", cc.p(368,150))

    local cistbletwenty1 = createVistbleAction(false)
    local delaytwenty1 = createParticleDelay(0.15)
    local cistbletwenty2 = createVistbleAction(true)

    local delayActiontwenty = createParticleDelay(0.5)--持续时间
    local stopActiontwenty = createParticleOut(0)
    local sequenceActiontwenty = createSequence(cistbletwenty1,delaytwenty1,cistbletwenty2,delayActiontwenty,stopActiontwenty)

    --聚能亮（第八个）
    local particletwentyone = createParticle("ui_b005208", cc.p(502,150))

    local cistbletwentyone1 = createVistbleAction(false)
    local delaytwentyone1 = createParticleDelay(0.15)
    local cistbletwentyone2 = createVistbleAction(true)

    local delayActiontwentyone = createParticleDelay(0.5)--持续时间
    local stopActiontwentyone = createParticleOut(0)
    local sequenceActiontwentyone = createSequence(cistbletwentyone1,delaytwentyone1,cistbletwentyone2,delayActiontwentyone,stopActiontwentyone)

    --旋转的星星（第一个）
    local particlefourteen= createParticle("ui_b001903", cc.p(97,266))
    local cistblefourteen1 = createVistbleAction(false)
    local delayfourteen1 = createParticleDelay(0.6)
    local cistblefourteen2 = createVistbleAction(true)
    local delayfourteen = createParticleDelay(0)
    local bezierfourteen1 = createRandomBezier(0.4, cc.p(700,900), cc.p(320,900), cc.p(324,648), 300 , -300)
    local delayfourteen2 = createParticleDelay(0)
    local stopActionfourteen = createParticleOut(1.1)
    local sequenceActionfourteen = createSequence(cistblefourteen1,delayfourteen1,cistblefourteen2,delayfourteen, bezierfourteen1,delayfourteen2,stopActionfourteen)
    local spawnActionfourteen = createSpawn(sequenceActionfourteen)
    
    --旋转的星星（第二个）
    local particlefifteen= createParticle("ui_b001903", cc.p(230,266))
    local cistblefifteen1 = createVistbleAction(false)
    local delayfifteen1 = createParticleDelay(0.6)
    local cistblefifteen2 = createVistbleAction(true)
    local delayfifteen = createParticleDelay(0)
    local bezierfifteen1 = createRandomBezier(0.4, cc.p(800,1000), cc.p(320,600), cc.p(324,648), 300 , -300)
    local delayfifteen2 = createParticleDelay(0)
    local stopActionfifteen = createParticleOut(1.1)
    local sequenceActionfifteen = createSequence(cistblefifteen1,delayfifteen1,cistblefifteen2,delayfifteen, bezierfifteen1,delayfifteen2,stopActionfifteen)
    local spawnActionfifteen = createSpawn(sequenceActionfifteen)

    --旋转的星星（第三个）
    local cistblesixteen1 = createVistbleAction(false)
    local delaysixteen1 = createParticleDelay(0.6)
    local cistblesixteen2 = createVistbleAction(true)
    local particlesixteen= createParticle("ui_b001903", cc.p(367,266))
    local delaysixteen = createParticleDelay(0)
    local beziersixteen1 = createRandomBezier(0.4, cc.p(500,400), cc.p(320,700), cc.p(324,648), 300 , -300)
    local delaysixteen2 = createParticleDelay(0)
    local stopActionsixteen = createParticleOut(1.1)
    local sequenceActionsixteen = createSequence(cistblesixteen1,delaysixteen1,cistblesixteen2,delaysixteen, beziersixteen1,delaysixteen2,stopActionsixteen)
    local spawnActionsixteen = createSpawn(sequenceActionsixteen)

    --旋转的星星（第四个）
    local cistbleseventeen1 = createVistbleAction(false)
    local delayseventeen1 = createParticleDelay(0.6)
    local cistbleseventeen2 = createVistbleAction(true)
    local particleseventeen= createParticle("ui_b001903", cc.p(504,266))
    local delayseventeen = createParticleDelay(0)
    local bezierseventeen1 = createRandomBezier(0.4, cc.p(-300,400), cc.p(320,700), cc.p(324,648), 300 , -300)
    local delayseventeen2 = createParticleDelay(0)
    local stopActionseventeen = createParticleOut(1.1)
    local sequenceActionseventeen = createSequence(cistbleseventeen1,delayseventeen1,cistbleseventeen2,delayseventeen, bezierseventeen1, delayseventeen2,stopActionseventeen)
    local spawnActionseventeen = createSpawn(sequenceActionseventeen)

    --旋转的星星（第五个）
    local cistbleeighteen1 = createVistbleAction(false)
    local delayeighteen1 = createParticleDelay(0.6)
    local cistbleeighteen2 = createVistbleAction(true)
    local particleeighteen= createParticle("ui_b001903", cc.p(97,150))
    local delayeighteen = createParticleDelay(0)
    local beziereighteen1 = createRandomBezier(0.4, cc.p(-100,900), cc.p(600,900), cc.p(324,648), 300 , -300)
    local delayeighteen2 = createParticleDelay(0)
    local stopActioneighteen = createParticleOut(1.1)
    local sequenceActioneighteen = createSequence(cistbleeighteen1,delayeighteen1,cistbleeighteen2,delayeighteen, beziereighteen1, delayeighteen2,stopActioneighteen)
    local spawnActioneighteen = createSpawn(sequenceActioneighteen)

    --旋转的星星（第六个）
    local cistbletwentytwo1 = createVistbleAction(false)
    local delaytwentytwo1 = createParticleDelay(0.6)
    local cistbletwentytwo2 = createVistbleAction(true)
    local particletwentytwo= createParticle("ui_b001903", cc.p(229,150))
    local delaytwentytwo = createParticleDelay(0)
    local beziertwentytwo1 = createRandomBezier(0.4, cc.p(100,500), cc.p(400,900), cc.p(324,648), 300 , -300)
    local delaytwentytwo2 = createParticleDelay(0)
    local stopActiontwentytwo = createParticleOut(1.1)
    local sequenceActiontwentytwo = createSequence(cistbletwentytwo1,delaytwentytwo1,cistbletwentytwo2,delaytwentytwo, beziertwentytwo1, delaytwentytwo2,stopActiontwentytwo)
    local spawnActiontwentytwo = createSpawn(sequenceActiontwentytwo)

    --旋转的星星（第七个）
    local cistbletwentythree1 = createVistbleAction(false)
    local delaytwentythree1 = createParticleDelay(0.6)
    local cistbletwentythree2 = createVistbleAction(true)
    local particletwentythree= createParticle("ui_b001903", cc.p(368,150))
    local delaytwentythree = createParticleDelay(0)
    local beziertwentythree1 = createRandomBezier(0.4, cc.p(200,200), cc.p(500,900), cc.p(324,648), 300 , -300)
    local delaytwentythree2 = createParticleDelay(0)
    local stopActiontwentythree = createParticleOut(1.1)
    local sequenceActiontwentythree = createSequence(cistbletwentythree1,delaytwentythree1,cistbletwentythree2,delaytwentythree, beziertwentythree1, delaytwentythree2,stopActiontwentythree)
    local spawnActiontwentythree = createSpawn(sequenceActiontwentythree)

    --旋转的星星（第八个）
    local cistbletwentyseven1 = createVistbleAction(false)
    local delaytwentyseven1 = createParticleDelay(0.6)
    local cistbletwentyseven2 = createVistbleAction(true)
    local particletwentyseven= createParticle("ui_b001903", cc.p(502,150))
    local delaytwentyseven = createParticleDelay(0)
    local beziertwentyseven1 = createRandomBezier(0.4, cc.p(600,300), cc.p(400,900), cc.p(324,648), 300 , -300)
    local delaytwentyseven2 = createParticleDelay(0)
    local stopActiontwentyseven = createParticleOut(1.1)
    local sequenceActiontwentyseven = createSequence(cistbletwentyseven1,delaytwentyseven1,cistbletwentyseven2,delaytwentyseven, beziertwentyseven1, delaytwentyseven2,stopActiontwentyseven)
    local spawnActiontwentyseven = createSpawn(sequenceActiontwentyseven)

----------------------------------------------------------------------------------------------------------------------------------------------------------------

    --鼎亮
    local particleone = createParticle("ui_b005202", cc.p(310,660) )
    local cistbleone1 = createVistbleAction(false)
    local delaytwo1one1 = createParticleDelay(1)
    local scaleToActiotone1  = createScaleTo(0, 1.32, 1.32)
    local cistbleone2 = createVistbleAction(true)
    local delayActionone = createParticleDelay(0.5)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(cistbleone1,scaleToActiotone1,delaytwo1one1,cistbleone2,delayActionone,stopActionone)


    --酝酿的烟
    local particlefive = createParticle("ui_b005201", cc.p(310,680) )
    local cistblefive1 = createVistbleAction(false)
    local delayfive1 = createParticleDelay(0)
    local cistblefive2 = createVistbleAction(true)
    local delayActionfive = createParticleDelay(1)--持续时间
    local stopActionfive = createParticleOut(0)
    local sequenceActionfive = createSequence(cistblefive1,delayfive1,cistblefive2,delayActionfive,stopActionfive)

    --爆的阵法--
    local particletwentyfour = createParticle("ui_a000503", cc.p(320,650) )
    local cistblethirtwentyfour1 = createVistbleAction(false)
    local delaythirtwentyfour1 = createParticleDelay(0.9)
    local scaleToActiottwentyfour  = createScaleTo(0, 0.8, 0.8)
    local cistblethirtwentyfour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_a000503")
    local delayActiontwentyfour = createParticleDelay(0.1)--持续时间
    local stopActiontwentyfour = createParticleOut(0.5)
    local sequenceActiontwentyfour = createSequence(cistblethirtwentyfour1,scaleToActiottwentyfour,delaythirtwentyfour1,cistblethirtwentyfour2,particletwelveClone, delayActiontwentyfour,stopActiontwentyfour)

    --中心星星--
    local particletwentyfive = createParticle("ui_b005206", cc.p(320,595) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirtwentyfive1 = createVistbleAction(false)
    local delaythirtwentyfive1 = createParticleDelay(1)
    local scaleToActiotfive1  = createScaleTo(0, 1.5, 1.5)
    local cistblethirtwentyfive2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b005206")

    local scaleToActiottwentyfive  = createScaleTo(0.0, 1, 1)
    local delayActiontwentyfive = createParticleDelay(0.4)--持续时间
    local stopActiontwentyfive = createParticleOut(0.4)
    local sequenceActiontwentyfive = createSequence(cistblethirtwentyfive1,delaythirtwentyfive1,scaleToActiotfive1,cistblethirtwentyfive2,particletwelveClone,scaleToActiottwentyfive,delayActiontwentyfive,stopActiontwentyfive)

----------------------------------------------------------------------------------------------------------------------------------------------------------------

    --中心爆的烟--
    local particletwentysix = createParticle("ui_b001804", cc.p(320,595))
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirtwentysix1 = createVistbleAction(false)
    local delaythirtwentysix1 = createParticleDelay(0.9)
    local cistblethirtwentysix2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001804")

    local scaleToActiottwentysix  = createScaleTo(0., 0.44, 0.44)
    local delayActiontwentysix = createParticleDelay(0.4)--持续时间
    -- local stopActiontwentysix = createParticleOut(1.5)
    local stopActiontwentysix = createParticleOut(1.5, func)
    local sequenceActiontwentysix = createSequence(cistblethirtwentysix1,delaythirtwentysix1,cistblethirtwentysix2,particletwelveClone,scaleToActiottwentysix, 
                                                   delayActiontwentysix,stopActiontwentysix)
  
    local node = createTotleAction(particlenineteen, sequenceActionnineteen,particletwenty, sequenceActiontwenty,particletwentyone, sequenceActiontwentyone,
                                   particlesix, sequenceActionsix
                                   ,particleseven, sequenceActionseven,particleeight, sequenceActioneight,particlenine, sequenceActionnine,
                                   particleten, sequenceActionten,
                                   particlefourteen, spawnActionfourteen
                                   ,

                                   particlefifteen, spawnActionfifteen,particlesixteen, spawnActionsixteen,
                                   particleseventeen, spawnActionseventeen
                                   ,particleeighteen, spawnActioneighteen,
                                   particletwentytwo, spawnActiontwentytwo,
                                   particletwentythree, spawnActiontwentythree,
                                   particletwentyseven, spawnActiontwentyseven,


                                   particleone, sequenceActionone,
                                   particlefive, sequenceActionfive,
                                   particletwentyfour, sequenceActiontwentyfour,particletwentyfive, sequenceActiontwentyfive,
                                   particletwentysix, sequenceActiontwentysix
                                   )
                                 
    return node
end

function UI_Xianji(func)--献祭06

     --聚能亮（第一个）
    local particlesix = createParticle("ui_a000605", cc.p(108,244))

    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(0.15)
    local cistblesix2 = createVistbleAction(true)

    local delayActionsix = createParticleDelay(0.5)--持续时间
    local stopActionsix = createParticleOut(0)
    local sequenceActionsix = createSequence(cistblesix1,delaysix1,cistblesix2,delayActionsix,stopActionsix)

    --聚能亮（第二个）
    local particleseven = createParticle("ui_a000605", cc.p(222,249))

    local cistbleseven1 = createVistbleAction(false)
    local delayseven1 = createParticleDelay(0.15)
    local cistbleseven2 = createVistbleAction(true)

    local delayActionseven = createParticleDelay(0.5)--持续时间
    local stopActionseven = createParticleOut(0)
    local sequenceActionseven = createSequence(cistbleseven1,delayseven1,cistbleseven2,delayActionseven,stopActionseven)

    --聚能亮（第三个）
    local particleeight = createParticle("ui_a000605", cc.p(327,261))

    local cistbleeight1 = createVistbleAction(false)
    local delayeight1 = createParticleDelay(0.15)
    local cistbleeight2 = createVistbleAction(true)

    local delayActioneight = createParticleDelay(0.5)--持续时间
    local stopActioneight = createParticleOut(0)
    local sequenceActioneight = createSequence(cistbleeight1,delayeight1,cistbleeight2,delayActioneight,stopActioneight)

    --聚能亮（第四个）
    local particlenine = createParticle("ui_a000605", cc.p(433,281))

    local cistblenine1 = createVistbleAction(false)
    local delaynine1 = createParticleDelay(0.15)
    local cistblenine2 = createVistbleAction(true)

    local delayActionnine = createParticleDelay(0.5)--持续时间
    local stopActionnine = createParticleOut(0)
    local sequenceActionnine = createSequence(cistblenine1,delaynine1,cistblenine2,delayActionnine,stopActionnine)

    --聚能亮（第五个）
    local particleten = createParticle("ui_a000605", cc.p(530,305))

    local cistbleten1 = createVistbleAction(false)
    local delayten1 = createParticleDelay(0.15)
    local cistbleten2 = createVistbleAction(true)

    local delayActionten = createParticleDelay(0.5)--持续时间
    local stopActionten = createParticleOut(0)
    local sequenceActionten = createSequence(cistbleten1,delayten1,cistbleten2,delayActionten,stopActionten)

    --旋转的星星（第一个）
    local particlefourteen= createParticle("ui_a000604", cc.p(108,244))
    local cistblefourteen1 = createVistbleAction(false)
    local delayfourteen1 = createParticleDelay(0.6)
    local cistblefourteen2 = createVistbleAction(true)
    local delayfourteen = createParticleDelay(0)
    local bezierfourteen1 = createRandomBezier(0.4, cc.p(700,900), cc.p(320,900), cc.p(324,698), 300 , -300)
    local delayfourteen2 = createParticleDelay(0)
    local stopActionfourteen = createParticleOut(1.1)
    local sequenceActionfourteen = createSequence(cistblefourteen1,delayfourteen1,cistblefourteen2,delayfourteen, bezierfourteen1,delayfourteen2,stopActionfourteen)
    local spawnActionfourteen = createSpawn(sequenceActionfourteen)
    
    --旋转的星星（第二个）
    local particlefifteen= createParticle("ui_a000604", cc.p(222,246))
    local cistblefifteen1 = createVistbleAction(false)
    local delayfifteen1 = createParticleDelay(0.6)
    local cistblefifteen2 = createVistbleAction(true)
    local delayfifteen = createParticleDelay(0)
    local bezierfifteen1 = createRandomBezier(0.4, cc.p(800,1000), cc.p(320,600), cc.p(324,698), 300 , -300)
    local delayfifteen2 = createParticleDelay(0)
    local stopActionfifteen = createParticleOut(1.1)
    local sequenceActionfifteen = createSequence(cistblefifteen1,delayfifteen1,cistblefifteen2,delayfifteen, bezierfifteen1,delayfifteen2,stopActionfifteen)
    local spawnActionfifteen = createSpawn(sequenceActionfifteen)

    --旋转的星星（第三个）
    local cistblesixteen1 = createVistbleAction(false)
    local delaysixteen1 = createParticleDelay(0.6)
    local cistblesixteen2 = createVistbleAction(true)
    local particlesixteen= createParticle("ui_a000604", cc.p(327,261))
    local delaysixteen = createParticleDelay(0)
    local beziersixteen1 = createRandomBezier(0.4, cc.p(500,400), cc.p(320,700), cc.p(324,698), 300 , -300)
    local delaysixteen2 = createParticleDelay(0)
    local stopActionsixteen = createParticleOut(1.1)
    local sequenceActionsixteen = createSequence(cistblesixteen1,delaysixteen1,cistblesixteen2,delaysixteen, beziersixteen1,delaysixteen2,stopActionsixteen)
    local spawnActionsixteen = createSpawn(sequenceActionsixteen)

    --旋转的星星（第四个）
    local cistbleseventeen1 = createVistbleAction(false)
    local delayseventeen1 = createParticleDelay(0.6)
    local cistbleseventeen2 = createVistbleAction(true)
    local particleseventeen= createParticle("ui_a000604", cc.p(433,281))
    local delayseventeen = createParticleDelay(0)
    local bezierseventeen1 = createRandomBezier(0.4, cc.p(-300,400), cc.p(320,700), cc.p(324,698), 300 , -300)
    local delayseventeen2 = createParticleDelay(0)
    local stopActionseventeen = createParticleOut(1.1)
    local sequenceActionseventeen = createSequence(cistbleseventeen1,delayseventeen1,cistbleseventeen2,delayseventeen, bezierseventeen1, delayseventeen2,stopActionseventeen)
    local spawnActionseventeen = createSpawn(sequenceActionseventeen)

    --旋转的星星（第五个）
    local cistbleeighteen1 = createVistbleAction(false)
    local delayeighteen1 = createParticleDelay(0.6)
    local cistbleeighteen2 = createVistbleAction(true)
    local particleeighteen= createParticle("ui_a000604", cc.p(530,305))
    local delayeighteen = createParticleDelay(0)
    local beziereighteen1 = createRandomBezier(0.4, cc.p(-100,900), cc.p(600,900), cc.p(324,698), 300 , -300)
    local delayeighteen2 = createParticleDelay(0)
    local stopActioneighteen = createParticleOut(1.1)
    local sequenceActioneighteen = createSequence(cistbleeighteen1,delayeighteen1,cistbleeighteen2,delayeighteen, beziereighteen1, delayeighteen2,stopActioneighteen)
    local spawnActioneighteen = createSpawn(sequenceActioneighteen)


----------------------------------------------------------------------------------------------------------------------------------------------------------------

    --鼎亮
    local particleone = createParticle("ui_a000601", cc.p(320,629) )
    local cistbleone1 = createVistbleAction(false)
    local delaytwo1one1 = createParticleDelay(0)
    local scaleToActiotone1  = createScaleTo(0, 1.32, 1.32)
    local cistbleone2 = createVistbleAction(true)
    local delayActionone = createParticleDelay(1.2)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(cistbleone1,scaleToActiotone1,delaytwo1one1,cistbleone2,delayActionone,stopActionone)

    --周围印亮
    local particletwo = createParticle("ui_a000607", cc.p(311,600) )
    local cistbletwo1 = createVistbleAction(false)
    local delaytwo1 = createParticleDelay(0.2)
    local cistbletwo2 = createVistbleAction(true)
    local delayActiontwo = createParticleDelay(1.2)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(cistbletwo1,delaytwo1,cistbletwo2,delayActiontwo,stopActiontwo)

    --酝酿的烟
    local particlefive = createParticle("ui_a000602", cc.p(318,500) )
    local cistblefive1 = createVistbleAction(false)
    local delayfive1 = createParticleDelay(0)
    local scaleToActiotfive1  = createScaleTo(0, 3.5, 2.3)
    local cistblefive2 = createVistbleAction(true)
    local delayActionfive = createParticleDelay(1.1)--持续时间
    local stopActionfive = createParticleOut(0.7)
    local sequenceActionfive = createSequence(cistblefive1,delayfive1,scaleToActiotfive1,cistblefive2,delayActionfive,stopActionfive)

    --底牌冲刺的光
    local particleEleven = createParticle("ui_a000608", cc.p(318,645) )
    local cistbleEleven1 = createVistbleAction(false)
    local delayEleven1 = createParticleDelay(0)
    local scaleToActiotEleven1  = createScaleTo(0, 0.1, 3)
    local cistbleEleven2 = createVistbleAction(true)
    local delayActionEleven = createParticleDelay(1.1)--持续时间
    local stopActionEleven = createParticleOut(0.7)
    local sequenceActionEleven = createSequence(cistbleEleven1,delayEleven1,scaleToActiotEleven1,cistbleEleven2,delayActionEleven,stopActionEleven)


    --爆的阵法--
    local particletwentyfour = createParticle("ui_a000606", cc.p(324,698) )
    local cistblethirtwentyfour1 = createVistbleAction(false)
    local delaythirtwentyfour1 = createParticleDelay(1)
    local scaleToActiottwentyfour  = createScaleTo(0, 0.8, 0.8)
    local cistblethirtwentyfour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_a000606")
    local delayActiontwentyfour = createParticleDelay(0.1)--持续时间
    local stopActiontwentyfour = createParticleOut(0.5)
    local sequenceActiontwentyfour = createSequence(cistblethirtwentyfour1,scaleToActiottwentyfour,delaythirtwentyfour1,cistblethirtwentyfour2,particletwelveClone, delayActiontwentyfour,stopActiontwentyfour)

    --中心星星--
    local particletwentyfive = createParticle("ui_a000603", cc.p(324,698) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirtwentyfive1 = createVistbleAction(false)
    local delaythirtwentyfive1 = createParticleDelay(1.1)
    local scaleToActiotfive1  = createScaleTo(0, 1.5, 1.5)
    local cistblethirtwentyfive2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_a000603")

    local scaleToActiottwentyfive  = createScaleTo(0.0, 1, 1)
    local delayActiontwentyfive = createParticleDelay(0.4)--持续时间
    local stopActiontwentyfive = createParticleOut(0.4)
    local sequenceActiontwentyfive = createSequence(cistblethirtwentyfive1,delaythirtwentyfive1,scaleToActiotfive1,cistblethirtwentyfive2,particletwelveClone,scaleToActiottwentyfive,delayActiontwentyfive,stopActiontwentyfive)

----------------------------------------------------------------------------------------------------------------------------------------------------------------

    --中心爆的烟--
    local particletwentysix = createParticle("ui_b001804", cc.p(324,698))
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirtwentysix1 = createVistbleAction(false)
    local delaythirtwentysix1 = createParticleDelay(1)
    local cistblethirtwentysix2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001804")

    local scaleToActiottwentysix  = createScaleTo(0., 0.44, 0.44)
    local delayActiontwentysix = createParticleDelay(0.4)--持续时间
    -- local stopActiontwentysix = createParticleOut(1.5)
    local stopActiontwentysix = createParticleOut(1.5,func)
    local sequenceActiontwentysix = createSequence(cistblethirtwentysix1,delaythirtwentysix1,cistblethirtwentysix2,particletwelveClone,scaleToActiottwentysix, 
                                                   delayActiontwentysix,stopActiontwentysix)
  
    local node = createTotleAction(
                                   particlesix, sequenceActionsix
                                   ,particleseven, sequenceActionseven,particleeight, sequenceActioneight,particlenine, sequenceActionnine,
                                   particleten, sequenceActionten,
                                   particleEleven, sequenceActionEleven,
                                   particlefourteen, sequenceActionfourteen
                                   ,

                                   particlefifteen, sequenceActionfifteen,particlesixteen, sequenceActionsixteen,
                                   particleseventeen, sequenceActionseventeen
                                   ,particleeighteen, sequenceActioneighteen,
                                                    
                                   particleone, sequenceActionone
                                   ,particletwo, sequenceActiontwo
                                   ,

                                   particlefive, sequenceActionfive,
                                   particletwentyfour, sequenceActiontwentyfour,particletwentyfive, sequenceActiontwentyfive,
                                   particletwentysix, sequenceActiontwentysix
                                   )
                                 
    return node
end



-- function UI_Xianji(posx, posy, callbackActionEnd, ret)--献祭06
--     --卡牌身上的暴光
--     local particleOne = createParticle("ui_a000601", cc.p(posx,posy)) 
--     local delayActionOne = createParticleDelay(1)--持续时间
--     local stopActionOne = createParticleOut(0.5)
--     local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

--     --爆的雾
--     local particleTwo = createParticle("ui_a000602", cc.p(posx,posy))
--     local cistbleTwo1 = createVistbleAction(false)
--     local delayTwo1 = createParticleDelay(0.8)
--     local cistbleTwo2 = createVistbleAction(true)
--     local particleTwo2 = createRestartAction("ui_a000602")
--     local delayTwo2 = createParticleDelay(0.2)
--     local stopActionTwo = createParticleOut(0.5)
--     local sequenceActionTwo = createSequence(cistbleTwo1, delayTwo1, 
--           cistbleTwo2, particleTwo2, delayTwo2,stopActionTwo)

--     --爆的光
--     local particleSix = createParticle("ui_a000105", cc.p(posx,posy))
--     local cistbleSix1 = createVistbleAction(false)
--     local scaleToActionSix  = createScaleTo(0, 0.4, 0.4)
--     local delaySix1 = createParticleDelay(0.8)
--     local cistbleSix2 = createVistbleAction(true)
--     local particleSix2 = createRestartAction("ui_a000105")
--     local delaySix2 = createParticleDelay(0.2)
--     local stopActionSix = createParticleOut(0.2)
--     local sequenceActionSix= createSequence(cistbleSix1, scaleToActionSix, delaySix1, cistbleSix2, particleSix2, 
--         delaySix2, stopActionSix)

--     --能量黄
--     local particleThree = createParticle("ui_a000603", cc.p(posx,posy))
--     local cistbleThree1 = createVistbleAction(false)
--     local delayThree = createParticleDelay(1)
--     local cistbleThree2 = createVistbleAction(true)
--     local bezierThree1 = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(240,480), 800, -800)
--     local delayThree2 = createParticleDelay(0.3)
--     local stopActionThree = createParticleOut(0.5)
--     local sequenceActionThree = createSequence(cistbleThree1, delayThree, cistbleThree2, bezierThree1, delayThree2,stopActionThree)

--     --能量黄Clone
--     local particleThreeClone = createParticle("ui_a000603", cc.p(posx,posy))
--     local cistbleThree1Clone = createVistbleAction(false)
--     local delayThreeClone = createParticleDelay(1)
--     local cistbleThree2Clone = createVistbleAction(true)
--     local bezierThree1Clone = createRandomBezier(0.4, cc.p(-100,400), cc.p(320,300), cc.p(240,480), 800 , -800)
--     local delayThree2Clone = createParticleDelay(0.3)
--     local stopActionThreeClone = createParticleOut(0.5)
--     local sequenceActionThreeClone = createSequence(cistbleThree1Clone, delayThreeClone,  cistbleThree2Clone, bezierThree1Clone, delayThree2Clone, stopActionThreeClone)

--     --蓝能量
--     local particleFour = createParticle("ui_a000103", cc.p(posx,posy))
--     local cistbleFour1 = createVistbleAction(false)
--     local delayFour = createParticleDelay(1)
--     local cistbleFour2 = createVistbleAction(true)
--     local bezierFour1 = createRandomBezier(0.4, cc.p(300,1000), cc.p(600,450), cc.p(410,480), -800 , 600)
--     local delayFour2 = createParticleDelay(0.3)
--     local stopActionFour = createParticleOut(0.5)
--     local sequenceActionFour = createSequence(cistbleFour1, delayFour, cistbleFour2, bezierFour1, delayFour2,stopActionFour)

--     --蓝能量Clone
--     local particleFourClone = createParticle("ui_a000103", cc.p(posx,posy))
--     local cistbleFour1Clone = createVistbleAction(false)
--     local delayFourClone = createParticleDelay(1)
--     local cistbleFour2Clone = createVistbleAction(true)
--     local bezierFour1Clone = createRandomBezier(0.4, cc.p(300,1000), cc.p(600,450), cc.p(410,480), -800 , 600)
--     local delayFour2Clone = createParticleDelay(0.3)
--     local stopActionFourClone = createParticleOut(0.5)
--     local sequenceActionFourClone = createSequence(cistbleFour1Clone, delayFourClone, cistbleFour2Clone, bezierFour1Clone, delayFour2Clone,stopActionFourClone)
    
--     --经验丹能量光
--     local particleFive = createParticle("ui_a000201", cc.p(240,480)) 
--     local cistbleFive1 = createVistbleAction(false)
--     local delayFive = createParticleDelay(1.35)
--     local scaleToActionFive = createScaleTo(0, 1, 1)
--     local cistbleFive2 = createVistbleAction(true)
--     local delayActionFive = createParticleDelay(0.2)
--     local stopActionFive = createParticleOut(0.6)
--     local sequenceActionFive = createSequence(cistbleFive1, delayFive, scaleToActionFive, cistbleFive2, 
--           delayActionFive, stopActionFive)

--     --武魂能量光
--     local particleSeven = createParticle("ui_a000101", cc.p(410,480)) 
--     local cistbleSeven1 = createVistbleAction(false)
--     local delaySeven = createParticleDelay(1.35)
--     local scaleToActionSeven = createScaleTo(0, 1, 1)
--     local cistbleSeven2 = createVistbleAction(true)
--     local delayActionSeven = createParticleDelay(0.3)
--     local stopActionSeven = createParticleOut(0.5)

--     local sequenceActionSeven = createSequence(cistbleSeven1, delaySeven, scaleToActionSeven, cistbleSeven2, delayActionSeven,createCallFun(callbackActionEnd), stopActionSeven)

--     -- 一级武将
--     local node = nil
--     if not ret then
--         node = createTotleAction(particleSeven, sequenceActionSeven, particleOne, sequenceActionOne, particleTwo, sequenceActionTwo, particleSix, sequenceActionSix, particleFour, sequenceActionFour, particleFourClone, sequenceActionFourClone)
--     else
--     -- 多级武将
--         node = createTotleAction(particleFive, sequenceActionFive, particleSeven, sequenceActionSeven, particleOne, sequenceActionOne, particleTwo, sequenceActionTwo, particleSix, sequenceActionSix, particleThree, sequenceActionThree, particleFour, sequenceActionFour, particleThreeClone, sequenceActionThreeClone, particleFourClone, sequenceActionFourClone)
--     end

--     return node
-- end

function UI_Jiandanguanka(func)--简单关卡07
    --星星
    local particleOne = createParticle("ui_a000701", cc.p(472,588)) 
    local scaleToActionOne  = createScaleTo(0, 1, 1)
    local delayActionOne = createParticleDelay(0.2)
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_Guankakaibaoxiang(func)--关卡开宝箱08
    --宝箱发光
    local particleOne = createParticle("ui_a000801", cc.p(0,0)) 
    -- local particleOne = createParticle("ui_a000801", cc.p(180,238)) 
    local delayActionOne = createParticleDelay(0.6)
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --星星
    local particleTwo = createParticle("ui_a000802", cc.p(0,-28)) 
    -- local particleTwo = createParticle("ui_a000802", cc.p(180,210)) 
    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo  = createParticleDelay(0.1)
    local cistbleTwo2 = createVistbleAction(true)
    local delayActionTwo = createParticleDelay(1)
    local stopActionTwo = createParticleOut(0.5, func)
    local sequenceActionTwo = createSequence(cistbleTwo1, delayTwo, cistbleTwo2, delayActionTwo, stopActionTwo)

    local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne)
    return node
end

function UI_Guankaweikaibaoxiang(func)--关卡未开宝箱09
    --宝箱发光
    local particleOne = createParticle("ui_a000901", cc.p(0,0)) 
    local delayActionOne = createParticleDelay(0.6)
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_Wujiangshilianchou(func)--武将十连抽10
    --左符号
    local particleOne = createParticle("ui_a001007", cc.p(360,311))
    -- local particleOneClone = createFlipXAction(0)
    local delayActionOne = createParticleDelay(0.3)
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --招
    local particleTwo = createParticle("ui_a001001", cc.p(393,315))
    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo  = createParticleDelay(0.1)
    local cistbleTwo2 = createVistbleAction(true)
    local delayActionTwo = createParticleDelay(0.3)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleTwo1, delayTwo, cistbleTwo2, delayActionTwo, stopActionTwo)

    --募
    local particleThree = createParticle("ui_a001002", cc.p(431,315))
    local cistbleThree1 = createVistbleAction(false)
    local delayThree  = createParticleDelay(0.2)
    local cistbleThree2 = createVistbleAction(true)
    local delayActionThree = createParticleDelay(0.3)
    local stopActionThree = createParticleOut(0.3)
    local sequenceActionThree = createSequence(cistbleThree1, delayThree, cistbleThree2, delayActionThree, 
          stopActionThree)

    --1
    local particleFour = createParticle("ui_a001003", cc.p(460,315))
    local cistbleFour1 = createVistbleAction(false)
    local delayFour  = createParticleDelay(0.3)
    local cistbleFour2 = createVistbleAction(true)
    local delayActionFour = createParticleDelay(0.3)
    local stopActionFour = createParticleOut(0.3)
    local sequenceActionFour = createSequence(cistbleFour1, delayFour, cistbleFour2, delayActionFour, 
          stopActionFour)

    --0
    local particleFive = createParticle("ui_a001004", cc.p(485,315))
    local cistbleFive1 = createVistbleAction(false)
    local delayFive  = createParticleDelay(0.4)
    local cistbleFive2 = createVistbleAction(true)
    local delayActionFive = createParticleDelay(0.3)
    local stopActionFive = createParticleOut(0.3)
    local sequenceActionFive = createSequence(cistbleFive1, delayFive, cistbleFive2, delayActionFive, 
          stopActionFive)
    
    --次
    local particleSix = createParticle("ui_a001005", cc.p(515,315))
    local cistbleSix1 = createVistbleAction(false)
    local delaySix  = createParticleDelay(0.5)
    local cistbleSix2 = createVistbleAction(true)
    local delayActionSix = createParticleDelay(0.3)
    local stopActionSix = createParticleOut(0.3)
    local sequenceActionSix = createSequence(cistbleSix1, delaySix, cistbleSix2, delayActionSix, 
          stopActionSix)

    --右符号
    local particleSeven = createParticle("ui_a001006", cc.p(550,311))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven = createParticleDelay(0.6)
    local cistbleSeven2 = createVistbleAction(true)
    local delayActionSeven = createParticleDelay(0.3)
    local stopActionSeven = createParticleOut(0.3, func)
    local sequenceActionSeven = createSequence(cistbleSeven1, delaySeven, cistbleSeven2, delayActionSeven, 
          stopActionSeven)

    local node = createTotleAction(particleOne, sequenceActionOne, particleTwo, sequenceActionTwo,
          particleThree, sequenceActionThree, particleFour, sequenceActionFour, particleFive, sequenceActionFive
          , particleSix, sequenceActionSix, particleSeven, sequenceActionSeven)

    return node
end

function UI_Tililingqu(func)--体力领取11
    --中间的鸡
    local particleOne = createParticle("ui_a001101", cc.p(320,420)) 

    local cistbleOne1 = createVistbleAction(false)
    local delayOne1 = createParticleDelay(0)
    local cistbleOne2 = createVistbleAction(true)
    local particleOne2 = createRestartAction("ui_a001101")

    local delayActionOne = createParticleDelay(0.35)
    local stopActionOne = createParticleOut(2)
    local sequenceActionOne = createSequence(cistbleOne1, delayOne1, cistbleOne2, particleOne2, 
          delayActionOne, stopActionOne)

    --左下角的肉
    local particleTwo = createParticle("ui_a001101", cc.p(90,330)) 
    local scaleToActionTwo  = createScaleTo(0, 0.5, 0.6)
    local delayActionTwo = createParticleDelay(0.35)
    local stopActionTwo = createParticleOut(2)
    local sequenceActionTwo = createSequence(scaleToActionTwo, delayActionTwo, stopActionTwo)

    --最底部的饼
    local particleThree = createParticle("ui_a001101", cc.p(400,300)) 
    local scaleToActionThree  = createScaleTo(0, 0.5, 0.5)
    local delayActionThree = createParticleDelay(0.35)
    local stopActionThree = createParticleOut(2)
    local sequenceActionThree = createSequence(scaleToActionThree, delayActionThree, stopActionThree)

    --右下角的菜
    local particleFour = createParticle("ui_a001101", cc.p(540,330)) 
    local scaleToActionFour  = createScaleTo(0, 0.5, 0.5)
    local delayActionFour = createParticleDelay(0.35)
    local stopActionFour = createParticleOut(2)
    local sequenceActionFour = createSequence(scaleToActionFour, delayActionFour, stopActionFour)

    --右边的饼
    local particleFive = createParticle("ui_a001101", cc.p(565,410)) 
    local scaleToActionFive  = createScaleTo(0, 0.4, 0.4)
    local delayActionFive = createParticleDelay(0.35)
    local stopActionFive = createParticleOut(2)
    local sequenceActionFive = createSequence(scaleToActionFive, delayActionFive, stopActionFive)

    --最左边的酒
    local particleSix = createParticle("ui_a001101", cc.p(90,440)) 
    local scaleToActionSix  = createScaleTo(0, 0.15, 0.15)
    local delayActionSix = createParticleDelay(0.35)
    local stopActionSix = createParticleOut(2)
    local sequenceActionSix = createSequence(scaleToActionSix, delayActionSix, stopActionSix)

    --左边的酒
    local particleSeven = createParticle("ui_a001101", cc.p(140,410)) 
    local scaleToActionSeven  = createScaleTo(0, 0.15, 0.15)
    local delayActionSeven = createParticleDelay(0.35)
    local stopActionSeven = createParticleOut(2)
    local sequenceActionSeven = createSequence(scaleToActionSeven, delayActionSeven, stopActionSeven)

    --最右边的酒
    local particleEight = createParticle("ui_a001101", cc.p(490,470)) 
    local scaleToActionEight  = createScaleTo(0, 0.15, 0.15)
    local delayActionEight = createParticleDelay(0.35)
    local stopActionEight = createParticleOut(2)
    local sequenceActionEight = createSequence(scaleToActionEight, delayActionEight, stopActionEight)

    --最左边的西瓜
    local particleNine = createParticle("ui_a001101", cc.p(180,500)) 
    local scaleToActionNine  = createScaleTo(0, 0.5, 0.6)
    local delayActionNine = createParticleDelay(0.35)
    local stopActionNine = createParticleOut(2)
    local sequenceActionNine = createSequence(scaleToActionNine, delayActionNine, stopActionNine)

    --右边的西瓜
    local particleTen = createParticle("ui_a001101", cc.p(430,500)) 
    local scaleToActionTen  = createScaleTo(0, 0.6, 0.6)
    local delayActionTen = createParticleDelay(0.35)
    local stopActionTen = createParticleOut(2)
    local sequenceActionTen = createSequence(scaleToActionTen, delayActionTen, stopActionTen)

    --右边的西瓜
    local particleEleven = createParticle("ui_a001101", cc.p(550,500)) 
    local scaleToActionEleven  = createScaleTo(0, 0.4, 0.6)
    local delayActionEleven = createParticleDelay(0.35)
    local stopActionEleven = createParticleOut(2, func)
    local sequenceActionEleven = createSequence(scaleToActionEleven, delayActionEleven, stopActionEleven)

    -- local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne)
    local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne,
          particleThree, sequenceActionThree, particleFour, sequenceActionFour, particleFive, 
          sequenceActionFive, particleSix, sequenceActionSix, particleSeven, sequenceActionSeven,
          particleEight, sequenceActionEight, particleNine, sequenceActionNine, particleTen, 
          sequenceActionTen, particleEleven, sequenceActionEleven)
    return node
end

function UI_Meiriqiandao(func)--每日签到12
    --右上
    local particleOne = createParticle("ui_a001201", cc.p(45,42.5)) 
    local moveAction1 = createParticleMove(cc.p(45,-42.5), 0.5, 0)
    local moveAction2 = createParticleMove(cc.p(-45,-42.5), 0.5, 0)
    local moveAction3 = createParticleMove(cc.p(-45,42.5), 0.5, 0)
    local moveAction4 = createParticleMove(cc.p(45,42.5), 0.5, 0)
    local delayActionEight = createParticleDelay(1)

    local stopActionOne = createParticleOut(2)
    local sequenceActionOne = createSequence(moveAction1, moveAction2, moveAction3, moveAction4, stopActionOne)

    --左下
    local particleTwo = createParticle("ui_a001201", cc.p(-45,-42.5)) 
    local moveActionTwo1 = createParticleMove(cc.p(-45,42.5), 0.5, 0)
    local moveActionTwo2 = createParticleMove(cc.p(45,42.5), 0.5, 0)
    local moveActionTwo3 = createParticleMove(cc.p(45,-42.5), 0.5, 0)
    local moveActionTwo4 = createParticleMove(cc.p(-45,-42.5), 0.5, 0)

    local stopActionTwo = createParticleOut(2, func)
    local sequenceActionTwo = createSequence(moveActionTwo1, moveActionTwo2, moveActionTwo3, moveActionTwo4, stopActionTwo)

    local node = createTotleAction(particleOne, sequenceActionOne, particleTwo, sequenceActionTwo)
    return node
end

function UI_Zhuangbeichouqu(callback1, callback2)--装备抽取13

    --装备位置发光
    local particleTwo = createParticle("ui_a001306", cc.p(320,842.5))
    local delayActionTwo = createParticleDelay(0.2)
    local stopActionTwo = createParticleOut(0.2)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    --持续Logo -- 旋转特效
    local particleThreeClone = createParticle("ui_a001301"--[[, cc.p(320,610)]])
    local node_stone = game.newSprite("#ui_shop_zb_d_01.png")
    node_stone:setAnchorPoint(0.5, 0.5)
    node_stone:setPosition(320, 610)
    node_stone:setLocalZOrder(-1)
    local _contentSize = node_stone:getContentSize()
    particleThreeClone:setPosition(_contentSize.width/2, _contentSize.height/2)
    node_stone:addChild(particleThreeClone)
    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(0.2)
    local cistbleThree2 = createVistbleAction(true)
    local particleThree2 = createRestartAction("ui_a001301")
    local delayThree2 = createParticleDelay(0.5)
    local rotateToAction1 = createRotateBy(0.5, 45)
    local rotateToAction2 = createRotateBy(1, 180)
    local rotateToAction3 = createRotateBy(1, 720)
    local rotateToAction4 = createRotateBy(1, 3600)
    local stopActionThreeClone = createParticleOut(0.3)
    local sequenceActionThreeClone = createSequence(cistbleThree1, delayThree1, cistbleThree2, particleThree2, delayThree2, rotateToAction1, rotateToAction2, 
        rotateToAction3, rotateToAction4, stopActionThreeClone)

    --Logo光晕
    local particleFive = createParticle("ui_a001303", cc.p(320,610))
    local cistbleFive1 = createVistbleAction(false)
    local delayFive1 = createParticleDelay(3.2)
    local cistbleFive2 = createVistbleAction(true)
    local particleFive2 = createRestartAction("ui_a001303")
    local delayFive2 = createParticleDelay(1.5)
    local stopActionFive = createParticleOut(0.6)
    local sequenceActionFive = createSequence(cistbleFive1, delayFive1, cistbleFive2, particleFive2,
          delayFive2, stopActionFive)
    
    --周围光晕
    local particleOne = createParticle("ui_a001302", cc.p(320,480)) 
    local cistbleOne1 = createVistbleAction(false)
    local delayOne1 = createParticleDelay(0.25)
    local cistbleOne2 = createVistbleAction(true)
    local particleOne2 = createRestartAction("ui_a001302")
    local delayActionOne = createParticleDelay(4.5)
    local stopActionOne = createParticleOut(0.3)

    local sequenceActionOne = createSequence(cistbleOne1, delayOne1, cistbleOne2, particleOne2, delayActionOne, stopActionOne)

    --曝光
    local particleSix = createParticle("ui_a001304", cc.p(320,626))
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(5)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a001304")
    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.6)
    local sequenceActionSix = createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2, delaySix2, stopActionSix)

    --callback
    local callbackAct1 = createCallFun(callback1) -- 回调以显示stone
    local callbackAct2 = createCallFun(callback2) -- 播放完回调

    --Logo消失
    local particleFour = createParticle("ui_a001305", cc.p(320,626))
    local cistbleFour1 = createVistbleAction(false)
    local delayFour1 = createParticleDelay(4.7)
    local cistbleFour2 = createVistbleAction(true)
    local particleFour2 = createRestartAction("ui_a001305")
    local delayFour2 = createParticleDelay(0.8)
    local delayFour3 = createParticleDelay(0.8)
    local stopActionFour = createParticleOut(0.6)
    local sequenceActionFour = createSequence(cistbleFour1, delayFour1, cistbleFour2, callbackAct1,
          delayFour2, callbackAct2, delayFour3, stopActionFour)

    local node = createTotleAction(particleTwo, sequenceActionTwo, particleFour, sequenceActionFour, particleSix, sequenceActionSix, particleOne, sequenceActionOne, particleFive, sequenceActionFive, 
          node_stone, sequenceActionThreeClone)
    return node
end

function UI_ZhuangbeichouquShowCard(_x,_y)
    print("showcard...")
    --装备出现
    local particleSeven = createParticle("ui_a000101", cc.p(_x,_y)) --(320,842.5))
    local cistbleSeven1 = createVistbleAction(false) 
    local scaleToActionSeven  = createScaleTo(0, 1.15, 1.15)
    local delaySeven1 = createParticleDelay(0.1)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_a000101")
    local delayActionSeven = createParticleDelay(1)
    local stopActionSeven = createParticleOut(0.3)
    local sequenceActionSeven = createSequence(cistbleSeven1, scaleToActionSeven, delaySeven1, cistbleSeven2,
      particleSeven2, delayActionSeven, stopActionSeven)
    local node = createTotleAction(particleSeven, sequenceActionSeven)
    return node
end

function UI_Zhuangbeichouqudianji(func)--装备抽取点击14

    --持续Logo
    local particleThree = createParticle("ui_a001401", cc.p(317,603.3))
    local scaleToActionThree  = createScaleTo(0.2, 1, 1)
    local stopActionThreeClone = createParticleOut(0.3, func)

    local sequenceActionThree = createSequence(scaleToActionThree, stopActionThreeClone)

    local node = createTotleAction(particleThree, sequenceActionThree)
    return node
end

function UI_Zhandouwushuangyiji(func)--战斗无双按钮一级15 func
    --无双曝光
    local particleZeroClone = createParticle("ui_a001501", cc.p(55,55))
    local scaleToActionZeroClone  = createScaleTo(0, 0.65, 0.65)
    local delayZeroClone = createParticleDelay(0.2)
    local stopActionZeroClone = createParticleOut(0.5)

    local sequenceActionZeroClone = createSequence(delayZeroClone, stopActionZeroClone)

    --一档
    local particleOne = createParticle("ui_a001502", cc.p(122,19))
    local delayOne = createParticleDelay(0.2)
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(delayOne, stopActionOne)
    
    local node = createTotleAction(particleZeroClone, sequenceActionZeroClone, particleOne, sequenceActionOne)
    return node
end

function UI_Zhandouwushuangerji(func)--战斗无双按钮二级16 func
    --无双曝光
    local particleZeroClone = createParticle("ui_a001501", cc.p(55,55))
    local delayZeroClone = createParticleDelay(0.2)
    local stopActionZeroClone = createParticleOut(0.5)

    local sequenceActionZeroClone = createSequence(delayZeroClone, stopActionZeroClone)
    --二档
    local particleTwo = createParticle("ui_a001503", cc.p(165,19))
    local delayTwo = createParticleDelay(0.2)
    local stopActionTwo = createParticleOut(0.5)
    local sequenceActionTwo = createSequence(delayTwo, stopActionTwo)

    local node = createTotleAction(particleZeroClone, sequenceActionZeroClone, particleTwo, sequenceActionTwo)
    return node
end

function UI_Zhandouwushuangsanji(func)--战斗无双按钮三级17 func
    --无双曝光
    local particleZeroClone = createParticle("ui_a001501", cc.p(55,55))
    local delayZeroClone = createParticleDelay(0.2)
    local stopActionZeroClone = createParticleOut(0.5)

    local sequenceActionZeroClone = createSequence(delayZeroClone, stopActionZeroClone)

    --一档
    local particleOne2 = createParticle("ui_a001502", cc.p(122,19))
    local delayOne2 = createParticleDelay(0.2)
    local stopActionOne2 = createParticleOut(0.5)
    local sequenceActionOne2 = createSequence(delayOne2, stopActionOne2)

    --二档
    local particleTwo2 = createParticle("ui_a001503", cc.p(165,19))
    local delayTwo2 = createParticleDelay(0.2)
    local stopActionTwo2 = createParticleOut(0.5)
    local sequenceActionTwo2 = createSequence(delayTwo2, stopActionTwo2)

    --三档
    local particleThree2 = createParticle("ui_a001504", cc.p(207,19))
    local delayThree2 = createParticleDelay(0.2)
    local stopActionThree2 = createParticleOut(0.5)
    local sequenceActionThree2 = createSequence(delayThree2, stopActionThree2)

    -- 星星点点--持续发射
    local particlesix = createParticle("ui_a001505", cc.p(165,19)) 
    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(0.2)
    local cistblesix2 = createVistbleAction(true)
    local delayActionsix = createParticleDelay(5)
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(cistblesix1, delaysix1, cistblesix2, delayActionsix, stopActionsix)

    -- 烟雾--持续发射
    local particlesix1 = createParticle("ui_a001506", cc.p(165,19)) 
    local cistblesix11 = createVistbleAction(false)
    local delaysix11 = createParticleDelay(0.2)
    local cistblesix12 = createVistbleAction(true)
    local delayActionsix1 = createParticleDelay(555555)
    local stopActionsix1 = createParticleOut(0.5)
    local sequenceActionsix1 = createSequence(cistblesix11, delaysix11, cistblesix12, delayActionsix1, stopActionsix1)
    --三档
    local particleThree = createParticle("ui_a001604", cc.p(207,19))
    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(0.2)
    local cistbleThree2 = createVistbleAction(true)
    local delayThree = createParticleDelay(0.2)
    local stopActionThree = createParticleOut(0.5)
    local sequenceActionThree = createSequence(cistbleThree1, delayThree1, cistbleThree2, delayThree)

    local node = createTotleAction(particleZeroClone, sequenceActionZeroClone, particleOne2, sequenceActionOne2, 
          particleTwo2, sequenceActionTwo2, particleThree2, sequenceActionThree2,
          particlesix1, sequenceActionsix1, particlesix, sequenceActionsix,
          particleThree, sequenceActionThree)
return node
end

function UI_Zhandouwushuanganniudianji(func)--战斗无双按钮点击 23 func
    local imgHide = createVistbleAction(false)
    local imgDelayAct = createParticleDelay(0.4)
    local imgShow = createVistbleAction(true)
    local imgShowDelay = createParticleDelay(2)
    local imgHide2 = createVistbleAction(false)
    local imgSequence = createSequence(imgHide, imgDelayAct, imgShow, imgShowDelay, imgHide2)
    
    --无双收缩的线条
    local particleSeven = createParticle("ui_a002302", cc.p(50,50))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(0)
    local cistbleSeven2 = createVistbleAction(true)
    -- local particleSeven2 = createRestartAction("ui_a002302")
    local delaySeven2 = createParticleDelay(0.2)
    local stopActionSeven = createParticleOut(0.5)
    local sequenceActionSeven = createSequence(delaySeven2, stopActionSeven)

    --无双曝光
    local particleZeroClone = createParticle("ui_a001501", cc.p(55,55))
    local cistbleZeroClone1 = createVistbleAction(false)
    local delayZeroClone1 = createParticleDelay(0)
    local scaleToActionZeroClone  = createScaleTo(0, 1.2, 1.2)
    local cistbleZeroClone2 = createVistbleAction(true)
    local delayZeroClone = createParticleDelay(0.2)
    local stopActionZeroClone = createParticleOut(0.5)
    local sequenceActionZeroClone = createSequence(cistbleZeroClone1, delayZeroClone1, scaleToActionZeroClone, cistbleZeroClone2, delayZeroClone, stopActionZeroClone)
    
    --无双爆的法阵
    local particleSix = createParticle("ui_a002301", cc.p(50,50))  
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a001304")
    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.5)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, cistbleSix2, particleSix2, delaySix2, stopActionSix)

    --第一格
    local particleOne2 = createParticle("ui_a001502", cc.p(122,19))
    local delayOne2 = createParticleDelay(0.2)
    local stopActionOne2 = createParticleOut(0.5)
    local sequenceActionOne2 = createSequence(delayOne2, stopActionOne2)

    --第二格
    local particleTwo2 = createParticle("ui_a001503", cc.p(165,19))
    local delayTwo2 = createParticleDelay(0.2)
    local stopActionTwo2 = createParticleOut(0.5)
    local sequenceActionTwo2 = createSequence(delayTwo2, stopActionTwo2)

    --第三格
    local particleThree2 = createParticle("ui_a001504", cc.p(207,19))
    local delayThree2 = createParticleDelay(0.2)
    local stopActionThree2 = createParticleOut(0.5)
    local sequenceActionThree2 = createSequence(delayThree2, stopActionThree2)

    --无双按钮持续效果
    local particleFour = createParticle("ui_a002303", cc.p(55,50))
    local cistbleFour1 = createVistbleAction(false)
    local delayFour1 = createParticleDelay(0.2)
    local cistbleFour2 = createVistbleAction(true)
    -- local particleSeven2 = createRestartAction("ui_a002302")
    
    local delayFour2 = createParticleDelay(2)
    local stopActionFour = createParticleOut(0.5, func)
    local sequenceActionFour= createSequence(cistbleFour1, delayFour1, cistbleFour2, delayFour2, stopActionFour)

    --无双收缩的线条
    local particleSeven = createParticle("ui_a002401", cc.p(50,50))
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(2.2)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_a002401")
    local delaySeven2 = createParticleDelay(0.2)
    local stopActionSeven = createParticleOut(0.5)
    local sequenceActionSeven = createSequence(cistbleSeven1, delaySeven1, cistbleSeven2, particleSeven2, delaySeven2, stopActionSeven)

    --无双曝光
    local particleZeroClone = createParticle("ui_a002402", cc.p(55,55))
    local cistbleZeroClone1 = createVistbleAction(false)
    local delayZeroClone1 = createParticleDelay(2.2)
    local cistbleZeroClone2 = createVistbleAction(true)
    local particleZeroClone2 = createRestartAction("ui_a002402")
    local delayZeroClone = createParticleDelay(0.2)
    local stopActionZeroClone = createParticleOut(0.5)
    local sequenceActionZeroClone = createSequence(cistbleZeroClone1, delayZeroClone1, cistbleZeroClone2, particleZeroClone2, delayZeroClone, stopActionZeroClone)
    

    local node = createTotleAction(particleZeroClone, sequenceActionZeroClone, particleSix, sequenceActionSix, 
        particleSeven, sequenceActionSeven,
        particleOne2, sequenceActionOne2, particleTwo2, sequenceActionTwo2, particleThree2, sequenceActionThree2, 
        particleFour, sequenceActionFour)

    return node
end
function UI_Zhandouwushuanganniuchufa(func)--战斗无双按钮触发 24 func
    
    --无双针形爆发
    local particleSeven = createParticle("ui_a002401", cc.p(50,50))
    local delaySeven2 = createParticleDelay(0.3)
    local stopActionSeven = createParticleOut(0.5)
    local sequenceActionSeven = createSequence(delaySeven2, stopActionSeven)

    --无双圈形曝光
    local particleZeroClone = createParticle("ui_a002402", cc.p(50,50))
    local delayZeroClone = createParticleDelay(0.3)
    local stopActionZeroClone = createParticleOut(0.5, func)
    local sequenceActionZeroClone = createSequence(delayZeroClone, stopActionZeroClone)
    
    local node = createTotleAction(
        particleZeroClone, sequenceActionZeroClone, 
        particleSeven, sequenceActionSeven)

    return node
end

function UI_Xingxingshanshan()
    --星星--一闪一闪
    local particleseven = createParticle("ui_b001705", cc.p(318,800) )

    local cistbleseven1 = createVistbleAction(false)
    local delayseven1 = createParticleDelay(0)
    local cistbleseven2 = createVistbleAction(true)

    local delayActionseven = createParticleDelay(9999)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(cistbleseven1,delayseven1,cistbleseven2,delayActionseven, stopActionseven)

    local node = createTotleAction(particleseven, sequenceActionseven)
    return node
end

function UI_Xiaohuobantaoxin(func)--小伙伴桃心18 func
    --1
    local particleOne = createParticle("ui_a001801", cc.p(520,22)) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(0.3)--持续时间
    local stopActionOne = createParticleOut(0.3, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --2
    local particleTwo = createParticle("ui_a001801", cc.p(493,22)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(0.3)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    --3
    local particleThree = createParticle("ui_a001801", cc.p(466,22)) 
    local delayActionThree = createParticleDelay(0.3)
    local stopActionThree = createParticleOut(0.3)
    local sequenceActionThree = createSequence(delayActionThree, stopActionThree)

    --4
    local particleFour = createParticle("ui_a001801", cc.p(440,22)) 
    local delayActionFour = createParticleDelay(0.3)
    local stopActionFour = createParticleOut(0.3)
    local sequenceActionFour = createSequence(delayActionFour, stopActionFour)

    --5
    local particleFive = createParticle("ui_a001801", cc.p(413,22)) 
    local delayActionFive = createParticleDelay(0.3)
    local stopActionFive = createParticleOut(0.3)
    local sequenceActionFive = createSequence(delayActionFive, stopActionFive)

    local node = createTotleAction(particleTwo, sequenceActionTwo, 
                                   particleOne, sequenceActionOne, particleThree, sequenceActionThree, 
                                   particleFour, sequenceActionFour, particleFive, sequenceActionFive)
    return node
end

function UI_Xiaohuobananniu(func)--小伙伴按钮19 func
    
    --无双曝光
    local particleZero = createParticle("ui_a001902", cc.p(585,50)) 
    local delayZero = createParticleDelay(0.2)
    local stopActionZero = createParticleOut(0.5)
    local sequenceActionZero = createSequence(delayZero, stopActionZero)

    local particleSix = createParticle("ui_a001901", cc.p(585,50)) 
    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0.2)
    local cistbleSix2 = createVistbleAction(true)

    local delayActionSix = createParticleDelay(999999)--持续时间
    local stopActionSix = createParticleOut(0.3, func)
    local sequenceActionSix = createSequence(cistbleSix1, delaySix1, cistbleSix2, delayActionSix, stopActionSix)

    local node = createTotleAction(particleZero, sequenceActionZero, particleSix, sequenceActionSix)
    return node
end

function UI_Xiaohuobananniudianji(func)--小伙伴按钮点击21 func
    
    --无双曝光
    local particleZero = createParticle("ui_a002101", cc.p(585,50)) 
    local delayZero = createParticleDelay(0.2)
    local stopActionZero = createParticleOut(0.5)
    local sequenceActionZero = createSequence(delayZero, stopActionZero)

    --爆的法阵
    local particleSix = createParticle("ui_a000402", cc.p(585,50))  

    local cistbleSix1 = createVistbleAction(false)
    local delaySix1 = createParticleDelay(0)
    local scaleToActionSix  = createScaleTo(0, 0.35, 0.35)
    local cistbleSix2 = createVistbleAction(true)
    local particleSix2 = createRestartAction("ui_a001304")

    local delaySix2 = createParticleDelay(0.2)
    local stopActionSix = createParticleOut(0.2)
    local sequenceActionSix= createSequence(cistbleSix1, delaySix1, scaleToActionSix, cistbleSix2, particleSix2, delaySix2, stopActionSix)

    --1
    local particleOne = createParticle("ui_a002102", cc.p(520,22)) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(0.1)--持续时间
    local stopActionOne = createParticleOut(0.4)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --11
    local particleOneClone = createParticle("ui_a001801", cc.p(520,22)) 
    local scaleToActionOneClone  = createScaleTo(0, 0.05, 0.05)
    local delayActionOneClone = createParticleDelay(0.2)--持续时间
    local stopActionOneClone = createParticleOut(0.2)
    local sequenceActionOneClone = createSequence(delayActionOneClone, stopActionOneClone)

    --2
    local particleTwo = createParticle("ui_a002102", cc.p(493,22)) 
    local delayActionTwo = createParticleDelay(0.1)
    local stopActionTwo = createParticleOut(0.4)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    --21
    local particleTwoClone = createParticle("ui_a001801", cc.p(493,22)) 
    local scaleToActionTwoClone  = createScaleTo(0, 0.05, 0.05)
    local delayActionTwoClone = createParticleDelay(0.2)
    local stopActionTwoClone = createParticleOut(0.2)
    local sequenceActionTwoClone = createSequence(delayActionTwoClone, stopActionTwoClone)

    --3
    local particleThree = createParticle("ui_a002102", cc.p(466,22)) 
    local delayActionThree = createParticleDelay(0.1)
    local stopActionThree = createParticleOut(0.4)
    local sequenceActionThree = createSequence(delayActionThree, stopActionThree)

    --31
    local particleThreeClone = createParticle("ui_a001801", cc.p(466,22)) 
    local scaleToActionThreeClone  = createScaleTo(0, 0.05, 0.05)
    local delayActionThreeClone = createParticleDelay(0.2)
    local stopActionThreeClone = createParticleOut(0.2)
    local sequenceActionThreeClone = createSequence( delayActionThreeClone, stopActionThreeClone)

    --4
    local particleFour = createParticle("ui_a002102", cc.p(440,22)) 
    local delayActionFour = createParticleDelay(0.1)
    local stopActionFour = createParticleOut(0.4)
    local sequenceActionFour = createSequence(delayActionFour, stopActionFour)

    --41
    local particleFourClone = createParticle("ui_a001801", cc.p(440,22))
    local scaleToActionFourClone  = createScaleTo(0, 0.05, 0.05)
    local delayActionFourClone = createParticleDelay(0.2)
    local stopActionFourClone = createParticleOut(0.2)
    local sequenceActionFourClone = createSequence(delayActionFourClone, stopActionFourClone)

    --5
    local particleFive = createParticle("ui_a002102", cc.p(413,22)) 
    local delayActionFive = createParticleDelay(0.1)
    local stopActionFive = createParticleOut(0.4)
    local sequenceActionFive = createSequence(delayActionFive, stopActionFive)

    --51
    local particleFiveClone = createParticle("ui_a001801", cc.p(413,22)) 
    local scaleToActionFiveClone  = createScaleTo(0, 0.05, 0.05)
    local delayActionFiveClone = createParticleDelay(0.2)
    local stopActionFiveClone = createParticleOut(0.2, func)
    local sequenceActionFiveClone = createSequence(delayActionFiveClone, stopActionFiveClone)

    local node = createTotleAction(particleZero, sequenceActionZero, particleSix, sequenceActionSix, 
                                   particleTwoClone, sequenceActionTwoClone, particleOneClone, sequenceActionOneClone, 
                                   particleThreeClone, sequenceActionThreeClone, particleFourClone, sequenceActionFourClone, 
                                   particleFiveClone, sequenceActionFiveClone, 
                                   particleTwo, sequenceActionTwo, particleOne, sequenceActionOne, 
                                   particleThree, sequenceActionThree, particleFour, sequenceActionFour, 
                                   particleFive, sequenceActionFive)
    return node
end

function UI_Wujiangluanru(func)--武将乱入20 func
    
    local particleone = createParticle("ui_a002001", cc.p(320,550))
    local scaleToActiottenone  = createScaleTo(0, 1, 1)
    local delayActionone = createParticleDelay(0.3)
    local stopActionone = createParticleOut(0.3)
    local sequenceActionone= createSequence(scaleToActiottenone, delayActionone, stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_a002002", cc.p(320,550))
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActiontwo = createParticleDelay(0.2)--持续时间
    local stopActiontwo = createParticleOut(0.5, func)
    local sequenceActiontwo = createSequence(scaleToActiotten,delayActiontwo,stopActiontwo)

    local node = createTotleAction(
        particleone, sequenceActionone,
        particletwo, sequenceActiontwo
        )
    return node
end

function UI_Guankatielian(func)--关卡铁链22 func
    --锁慢热
    local particleOne = createParticle("ui_a002203", cc.p(0,0)) 
    local delayActionOne = createParticleDelay(0.8)--持续时间
    local stopActionOne = createParticleOut(0.2)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --锁已热
    local particleTwo = createParticle("ui_a002205", cc.p(0,0)) 
    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.8)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionTwo = createParticleDelay(1)
    local stopActionTwo = createParticleOut(0)
    local sequenceActionTwo = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    --铁链上
    local particleThree = createParticle("ui_a002201", cc.p(0,0)) 
    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(1.2)
    local rotateToActionThree = createRotateBy(0.5, 60)
    local cistbleThree2 = createVistbleAction(true)
    local particleThree2 = createRestartAction("ui_a002201")

    local delayActionThree = createParticleDelay(0.3)
    local stopActionThree = createParticleOut(0.3)
    local sequenceActionThree = createSequence(cistbleThree1,delayThree1,rotateToActionThree,cistbleThree2,particleThree2,delayActionTwo, stopActionTwo)

    --铁链左
    local particleFour = createParticle("ui_a002201", cc.p(-25,-25)) 
    local cistbleFour1 = createVistbleAction(false)
    local delayFour1 = createParticleDelay(1.2)
    local rotateToActionFour = createRotateBy(0.5, -30)
    local cistbleFour2 = createVistbleAction(true)
    local particleFour2 = createRestartAction("ui_a002201")

    local delayActionFour = createParticleDelay(0.3)
    local stopActionFour = createParticleOut(0.3)
    local sequenceActionFour = createSequence(cistbleFour1,delayFour1,rotateToActionFour,cistbleFour2,particleFour2,delayActionFour, stopActionFour)

    --铁链右
    local particleFive = createParticle("ui_a002201", cc.p(25,-25)) 
    local cistbleFive1 = createVistbleAction(false)
    local delayFive1 = createParticleDelay(1.2)
    local rotateToActionFive = createRotateBy(0.5, 210)
    local cistbleFive2 = createVistbleAction(true)
    local particleFive2 = createRestartAction("ui_a002201")

    local delayActionFive = createParticleDelay(0.3)
    local stopActionFive = createParticleOut(0.3)
    local sequenceActionFive = createSequence(cistbleFive1,delayFive1,rotateToActionFive,cistbleFive2,particleFive2,delayActionFive, stopActionFive)

    --云雾
    local particleSeven = createParticle("ui_a000202", cc.p(0,-0)) 
    local cistbleSeven1 = createVistbleAction(false)
    local delaySeven1 = createParticleDelay(1.6)
    local scaleToActionSeven = createScaleBy(0.5, 1.2,1.2)
    local cistbleSeven2 = createVistbleAction(true)
    local particleSeven2 = createRestartAction("ui_a000202")

    local delayActionSeven = createParticleDelay(0.1)
    local stopActionSeven = createParticleOut(0.3, func)
    local sequenceActionSeven = createSequence(cistbleSeven1,delaySeven1,cistbleSeven2,particleSeven2,delayActionSeven, stopActionSeven)

    -- local node = createTotleAction(particleThree, sequenceActionThree)
    local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne,
                                   particleThree, sequenceActionThree, particleFour, sequenceActionFour,
                                   particleFive, sequenceActionFive, particleSeven, sequenceActionSeven)
    return node
end

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

--==============================================================================================================

function UI_wushuangaoyi()--无双奥义
    --无
    local particleOne = createParticle("ui_b000201", cc.p(142,445)) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(0.3)--持续时间
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --双
    local particleTwo = createParticle("ui_b000202", cc.p(253,475)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.05)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionTwo = createParticleDelay(0.3)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    --奥
    local particleThree = createParticle("ui_b000203", cc.p(381,499)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.1)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionThree = createParticleDelay(0.3)
    local stopActionThree = createParticleOut(0.3)
    local sequenceActionThree = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    --义
    local particleFour = createParticle("ui_b000204", cc.p(505,520)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.15)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionFour = createParticleDelay(0.3)
    local stopActionFour = createParticleOut(0.3)
    local sequenceActionFour = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionFour, stopActionFour)

    -- local node = createTotleAction(particleOne, sequenceActionOne)
    local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne,
                                   particleThree, sequenceActionThree, particleFour, sequenceActionFour)
    return node
end

function UI_mengjianglaixi()--猛将来袭
    --无
    local particleOne = createParticle("ui_b000301", cc.p(165,440)) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(0.3)--持续时间
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --双
    local particleTwo = createParticle("ui_b000302", cc.p(270,487)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.05)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionTwo = createParticleDelay(0.3)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    --奥
    local particleThree = createParticle("ui_b000303", cc.p(381,525)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.1)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionThree = createParticleDelay(0.3)
    local stopActionThree = createParticleOut(0.3)
    local sequenceActionThree = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    --义
    local particleFour = createParticle("ui_b000304", cc.p(485,560)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.15)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionFour = createParticleDelay(0.3)
    local stopActionFour = createParticleOut(0.3)
    local sequenceActionFour = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionFour, stopActionFour)

    -- local node = createTotleAction(particleOne, sequenceActionOne)
    local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne,
                                   particleThree, sequenceActionThree, particleFour, sequenceActionFour)
    return node
end


function UI_wushuang1(func)--无双1   凤凰冲击
    --火焰
    local particleOne = createParticle("ui_b000401", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_wushuang2(func)--无双2   狂雷轰顶
    --闪电
    local particleOne = createParticle("ui_b000501", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --电边
    local particleTwo = createParticle("ui_b000502", const.FIGHT_POS_UNPARA_ICON) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(99999999)
    local stopActionTwo = createParticleOut(0.5, func)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    local node = createTotleAction(particleOne, sequenceActionOne,particleTwo, sequenceActionTwo)
    return node
end

function UI_wushuang3(func)--无双3   火柱冲天
    --火焰
    local particleOne = createParticle("ui_b000601", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_wushuang4(func)--无双4   圆刃炫斩
    --旋转图片
    local particleOne = createParticle("ui_b000701", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(9999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_wushuang5(func)--无双5   霜龙冰晶
    --蓝色雾气
    local particleOne = createParticle("ui_b000801", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_wushuang6(func)--无双6   铁索横江
    --火焰
    local particleOne = createParticle("ui_b000901", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_wushuang7(func)--无双7   桃园结义
    --粉色雾气
    local particleOne = createParticle("ui_b001001", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_wushuang8(func)--无双8   血魔破天
    --火焰
    local particleOne = createParticle("ui_b001101", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(999999999)--持续时间
    local stopActionOne = createParticleOut(0.5, func)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    local node = createTotleAction(particleOne, sequenceActionOne)
    return node
end

function UI_wushuang9(func)--无双9   太极八卦
    --旋转太极
    local particleOne = createParticle("ui_b001201", const.FIGHT_POS_UNPARA_ICON) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(99999999)--持续时间
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)
    
    --雾气
    local particleTwo = createParticle("ui_b001202", const.FIGHT_POS_UNPARA_ICON) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(99999999)
    local stopActionTwo = createParticleOut(0.5, func)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    local node = createTotleAction(particleOne, sequenceActionOne,particleTwo, sequenceActionTwo)
    return node
end

function UI_ws_01()--裂魂穿云破
    --图标特效-- 第一个
    local particleone = createParticle("ui_b005601", const.FIGHT_POS_UNPARA_ICON )
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第一个
    local particletwo = createParticle("ui_b001202", const.FIGHT_POS_UNPARA_ICON )

    local scaleToActionTwo  = createScaleTo(0, 1.11, 1.11)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActionTwo,delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_02()--无极破天闪
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b001101", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particletwo, sequenceActiontwo)
    return node
end

function UI_ws_03()--七生伏龙诀
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005801", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo) 
    local node = createTotleAction(particletwo, sequenceActiontwo)
    return node
end

function UI_ws_04()--炎龙华轮破
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005901", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particletwo, sequenceActiontwo)
    return node
end

function UI_ws_05()--地狱焰魂破
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005901", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particletwo, sequenceActiontwo)
    return node
end

function UI_ws_06()--鹿鸣逐日斩
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006001", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005701", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_07()--末日诛神杀
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006101", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005701", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_08()--落英雪云舞
    --图标特效-- 第一个
    local particleone = createParticle("ui_b001202", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionTwo  = createScaleTo(0, 1.05, 1.05)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(scaleToActionTwo,delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b006201", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_09()--碧空黯光闪
    --图标特效-- 第一个
    local particleone = createParticle("ui_b001202", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b000501", const.FIGHT_POS_UNPARA_ICON)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_10()--落影残霜恸

    --图标特效-- 第一个
    local particleone = createParticle("ui_b001202", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b006301", const.FIGHT_POS_UNPARA_ICON )
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_11()--翔翼缚风切

    --图标特效-- 第一个
    local particleone = createParticle("ui_b006401", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b006001", const.FIGHT_POS_UNPARA_ICON )
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_12()--冰劫封灭冲
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006501", const.FIGHT_POS_UNPARA_ICON )
    local scaleToActionTwo  = createScaleTo(0, 0.92,0.92)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(scaleToActionTwo,delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b001608", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionTwo  = createScaleTo(0, 0.7, 0.7)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActionTwo,delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_13()--烈水升龙破
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006501", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b001608", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionTwo  = createScaleTo(0, 1.33, 1.33)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActionTwo,delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_14()--暴雷瞬天杀
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006401", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b006601", const.FIGHT_POS_UNPARA_ICON )
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_15()--三界红莲升
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006701", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b006001", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionTwo  = createScaleTo(0, 0.88, 0.88)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActionTwo,delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_16()--天帝曳光斩
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006101", const.FIGHT_POS_UNPARA_ICON)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b006601", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionTwo  = createScaleTo(0, 0.88, 0.88)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActionTwo,delayActiontwo,stopActiontwo)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo)
    return node
end

function UI_ws_17()--蹈海冰封诀    
    --图标特效-- 第一个
    local particleone = createParticle("ui_b006301", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionTwo  = createScaleTo(0, 0.94, 0.94)
    local delayActionone = createParticleDelay(888)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(scaleToActionTwo,delayActionone,stopActionone)
    --图标特效-- 第一个
    local particletwo = createParticle("ui_b005801", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionTwo  = createScaleTo(0, 0.86, 0.86)
    local delayActiontwo = createParticleDelay(888)--持续时间
    local stopActiontwo = createParticleOut(0.5)
    local sequenceActiontwo = createSequence(scaleToActionTwo,delayActiontwo,stopActiontwo)
    --图标特效-- 第一个
    local particlethree = createParticle("ui_b006801", const.FIGHT_POS_UNPARA_ICON)
    local scaleToActionthree  = createScaleTo(0, 0.88, 0.88)
    local delayActionthree = createParticleDelay(888)--持续时间
    local stopActionthree = createParticleOut(0.5)
    local sequenceActionthree = createSequence(scaleToActionthree,delayActionthree,stopActionthree)
    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree)
    return node
end

function UI_shejiao(func)--社交吃桃子
    --发光
    local particleOne = createParticle("ui_b001301", cc.p(0,0)) 
    -- local moveOne = createParticleMove(cc.p())
    local delayActionOne = createParticleDelay(0.3)--持续时间
    local stopActionOne = createParticleOut(0.3)
    local sequenceActionOne = createSequence(delayActionOne, stopActionOne)

    --长线
    local particleTwo = createParticle("ui_b001302", cc.p(0,-20)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local scaleToActionTwo  = createScaleTo(0, 4, 1)
    local delayNine1 = createParticleDelay(0.12)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionTwo = createParticleDelay(0.3)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleNine1,scaleToActionTwo,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    --星星点点
    local particleThree = createParticle("ui_b001303", cc.p(0,-20))  
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.2)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionThree = createParticleDelay(0.5)
    local stopActionThree = createParticleOut(0.3, func)
    local sequenceActionThree = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    -- local node = createTotleAction(particleOne, sequenceActionOne)
    local node = createTotleAction(particleTwo, sequenceActionTwo, particleOne, sequenceActionOne,
                                   particleThree, sequenceActionThree)
    return node
end

function UI_zhandoushengli(func)--战斗胜利品
    
    --电边
    local particleTwo = createParticle("ui_b001402", cc.p(0,0)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)
    local delayActionTwo = createParticleDelay(99999999)
    local stopActionTwo = createParticleOut(0.5, func)
    local sequenceActionTwo = createSequence(delayActionTwo, stopActionTwo)

    local node = createTotleAction(particleTwo, sequenceActionTwo)
    return node
end

function UI_zhandoushengji(func)--战斗升级
    --发光
    local particleOne = createParticle("ui_b001502", cc.p(0,18)) 
    -- local moveOne = createParticleMove(cc.p())

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.9)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionOne = createParticleDelay(0.4)--持续时间
    local stopActionOne = createParticleOut(0.5)
    local sequenceActionOne = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionOne, stopActionOne)

    --原地点光
    local particlesix = createParticle("ui_b001304", cc.p(0,18)) 
    -- local moveOne = createParticleMove(cc.p())

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(1.1)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionsix = createParticleDelay(0.5)--持续时间
    local stopActionsix = createParticleOut(0.7, func)
    local sequenceActionsix = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionsix, stopActionsix)

    --长线
    local particleTwo = createParticle("ui_b001302", cc.p(0,0)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local scaleToActionTwo  = createScaleTo(0, 4, 1)
    local delayNine1 = createParticleDelay(0.15)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionTwo = createParticleDelay(0.4)
    local stopActionTwo = createParticleOut(0.3)
    local sequenceActionTwo = createSequence(cistbleNine1,scaleToActionTwo,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    --星星点点
    local particleThree = createParticle("ui_b001303", cc.p(0,0)) 
    -- local scaleToActionTwo  = createScaleTo(0, 1.2, 1)

    local cistbleNine1 = createVistbleAction(false)
    local delayNine1 = createParticleDelay(0.2)
    local cistbleNine2 = createVistbleAction(true)

    local delayActionThree = createParticleDelay(0.5)
    local stopActionThree = createParticleOut(0.3)
    local sequenceActionThree = createSequence(cistbleNine1,delayNine1,cistbleNine2,delayActionTwo, stopActionTwo)

    local particleFour = createParticle("ui_b001501", cc.p(40,-15))
    local delayFour = createParticleDelay(0)
    local bezierFour1 = createRandomBezier(0.35, cc.p(40,-10), cc.p(58,20), cc.p(-32,15))
    local bezierFour2 = createRandomBezier(0.44, cc.p(-30,40), cc.p(-71,40), cc.p(3,67))
    local delayFour2 = createParticleDelay(0)
    local stopActionFour = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionFour = createSequence(delayFour, bezierFour1, bezierFour2, 
                                              delayFour2,stopActionFour)
    local spawnActionFour = createSpawn(sequenceActionFour)

    local particleFive = createParticle("ui_b001501", cc.p(-40,-20))
    local delayFive = createParticleDelay(0)
    local bezierFive1 = createRandomBezier(0.35, cc.p(-47,-10), cc.p(20,60), cc.p(23,15))
    local bezierFive2 = createRandomBezier(0.44, cc.p(59,40), cc.p(50,40), cc.p(3,67))
    local delayFive2 = createParticleDelay(0)
    local stopActionFive = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionFive = createSequence(delayFive, bezierFive1, bezierFive2, 
                                              delayFive2,stopActionFive)
    local spawnActionFive = createSpawn(sequenceActionFive)

    -- local node = createTotleAction(particleOne, sequenceActionOne)
    local node = createTotleAction(particleFour, sequenceActionFour,particleFive, sequenceActionFive,particleOne, sequenceActionOne, 
                                   particlesix, sequenceActionsix, particleTwo, sequenceActionTwo, particleThree, sequenceActionThree)
    return node
end

function UI_shangchengwujiangchouqu001(func)--商城武将抽取001

    local particleFour = createParticle("ui_b001701", cc.p(185,150))
    local delayFour = createParticleDelay(0)
    local bezierFour1 = createRandomBezier(0.1, cc.p(180,180), cc.p(100,190), cc.p(177,200))
    local bezierFour2 = createRandomBezier(0.3, cc.p(175,210), cc.p(216,250), cc.p(335,270))
    local delayFour2 = createParticleDelay(0)
    local stopActionFour = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionFour = createSequence(delayFour, bezierFour1, bezierFour2, 
                                              delayFour2,stopActionFour)
    local spawnActionFour = createSpawn(sequenceActionFour)

    local particleFive = createParticle("ui_b001701", cc.p(120,150))
    local delayFive = createParticleDelay(0)
    local bezierFive1 = createRandomBezier(0.1, cc.p(320,180), cc.p(225,200), cc.p(225,200))
    local bezierFive2 = createRandomBezier(0.3, cc.p(235,210), cc.p(315,220), cc.p(335,270))
    local delayFive2 = createParticleDelay(0)
    local stopActionFive = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionFive = createSequence(delayFive, bezierFive1, bezierFive2, 
                                              delayFive2,stopActionFive)
    local spawnActionFive = createSpawn(sequenceActionFive)

    --房子--一闪
    local particleOne = createParticle("ui_b001702", cc.p(310,830))
    -- local moveOne = createParticleMove(cc.p())

    local cistbleOne1 = createVistbleAction(false)
    local delayOne1 = createParticleDelay(1.5)
    local cistbleOne2 = createVistbleAction(true)

    local delayActionOne = createParticleDelay(2)--持续时间
    -- local delayActionOne = createParticleDelay(2.7)--持续时间
    local stopActionOne = createParticleOut(0.1)
    local sequenceActionOne = createSequence(cistbleOne1,delayOne1,cistbleOne2,delayActionOne, stopActionOne)

    --房子--一闪
    local particlefifteen = createParticle("ui_b001702", cc.p(310,830))
    -- local moveOne = createParticleMove(cc.p())

    local cistblefifteen1 = createVistbleAction(false)
    local delayfifteen1 = createParticleDelay(3.5)
    local scaleToActiofifteen  = createScaleTo(0,1.15, 1.15)
    local cistblefifteen2 = createVistbleAction(true)

    local delayActionfifteen= createParticleDelay(0.2)--持续时间
    local stopActionfifteen = createParticleOut(0.1)
    local sequenceActionfifteen = createSequence(cistblefifteen1,delayfifteen1,scaleToActiofifteen,cistblefifteen2,delayActionfifteen, stopActionfifteen)

    --能量球--一闪
    local particleten = createParticle("ui_b001708", cc.p(327,700) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleten1 = createVistbleAction(false)
    local delayten1 = createParticleDelay(2.1)
    local cistbleten2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001708")

    local scaleToActiotten  = createScaleTo(0.8, 2, 2)
    local delayActionten = createParticleDelay(0.8)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistbleten1,delayten1,cistbleten2,scaleToActiotten, stopActionten)

    --聚气--
    local particlethirteen = createParticle("ui_b001712", cc.p(327,700) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(0.5)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001712")

    local delayActionthirteen = createParticleDelay(1)--持续时间
    local stopActionthirteen = createParticleOut(2)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,delayActionthirteen, stopActionthirteen)

    --向天上飞的星星

    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(3.5)
    local cistbleTwo2 = createVistbleAction(true)

    local particleTwo= createParticle("ui_b001703", cc.p(325,670))
    local delayTwo = createParticleDelay(0)
    local bezierTwo1 = createRandomBezier(0.2, cc.p(505,680), cc.p(485,730), cc.p(480,720))
    local bezierTwo2 = createRandomBezier(0.45, cc.p(95,770), cc.p(45,800), cc.p(320,900))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,delayTwo, bezierTwo1, bezierTwo2, 
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)

    --向天上飞的星星

    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(3.5)
    local cistbleThree2 = createVistbleAction(true)

    local particleThree= createParticle("ui_b001703", cc.p(325,670))
    local delayThree = createParticleDelay(0)
    local bezierThree1 = createRandomBezier(0.1, cc.p(165,680), cc.p(155,730), cc.p(160,720))
    local bezierThree2 = createRandomBezier(0.45, cc.p(545,770), cc.p(595,800), cc.p(320,900))
    local delayThree2 = createParticleDelay(0)
    local stopActionThree = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionThree = createSequence(cistbleThree1,delayThree1,cistbleThree2,delayThree, bezierThree1, bezierThree2, 
                                              delayThree2,stopActionThree)
    local spawnActionThree = createSpawn(sequenceActionThree)


    --天空--一闪
    local particlenine = createParticle("ui_b001707", cc.p(327,819) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblenine1 = createVistbleAction(false)
    local scaleToActionine  = createScaleTo(0,1, 2.2)
    local delaynine1 = createParticleDelay(4.1)
    local cistblenine2 = createVistbleAction(true)

    local delayActionnine = createParticleDelay(0.2)--持续时间
    local stopActionnine = createParticleOut(1)
    local sequenceActionnine = createSequence(cistblenine1,scaleToActionine,delaynine1,cistblenine2,delayActionnine, stopActionnine)

    --云--一闪
    local particlesix = createParticle("ui_b001704", cc.p(318,800) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(4.3)
    local cistblesix2 = createVistbleAction(true)

    local delayActionsix = createParticleDelay(0.35)--持续时间
    local stopActionsix = createParticleOut(1.5)
    local sequenceActionsix = createSequence(cistblesix1,delaysix1,cistblesix2,delayActionsix, stopActionsix)

    --云--一闪
    local particlesixClone = createParticle("ui_b001704", cc.p(318,800) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblesix1Clone = createVistbleAction(false)
    local delaysix1Clone = createParticleDelay(4.3)
    local cistblesix2Clone = createVistbleAction(true)

    local delayActionsixClone = createParticleDelay(0.35)--持续时间
    local stopActionsixClone = createParticleOut(1.5)
    local sequenceActionsixClone = createSequence(cistblesix1Clone,delaysix1Clone,cistblesix2Clone,delayActionsixClone, stopActionsixClone)

    --星星--一闪一闪
    local particleseven = createParticle("ui_b001705", cc.p(318,800) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleseven1 = createVistbleAction(false)
    local delayseven1 = createParticleDelay(0)
    local cistbleseven2 = createVistbleAction(true)

    local delayActionseven = createParticleDelay(6)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(cistbleseven1,delayseven1,cistbleseven2,delayActionseven, stopActionseven)

    --天空中最亮的星
    local particleelevn = createParticle("ui_b001709", cc.p(265,819) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleelevn1 = createVistbleAction(false)
    local delayelevn1 = createParticleDelay(5)
    local cistblelevn2 = createVistbleAction(true)

    local delayActionelevn = createParticleDelay(0.1)--持续时间
    local stopActionelevn = createParticleOut(0.5)
    local sequenceActionelevn = createSequence(cistbleelevn1,delayelevn1,cistblelevn2,delayActionelevn, stopActionelevn)

    --天空中最亮的星
    local particleeight = createParticle("ui_b001711", cc.p(265,819) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleeight1 = createVistbleAction(false)
    local delayeight1 = createParticleDelay(5)
    local cistbleight2 = createVistbleAction(true)

    local delayActioneight = createParticleDelay(0.1)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(cistbleeight1,delayeight1,cistbleight2,delayActioneight, stopActioneight)

    --星爆
    local particletwelve = createParticle("ui_b001710", cc.p(265,819) )
    -- local moveOne = createParticleMove(cc.p()) 

    local cistbletwelve1 = createVistbleAction(false)
    local scaleToActiotwelve  = createScaleTo(0, 1, 1)
    local delaytwelve1 = createParticleDelay(5.5)
    local cistbltwelve2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001710")

    local delayActiontwelve = createParticleDelay(0.3)--持续时间
    local stopActiontwelve = createParticleOut(0.2, func)
    local sequenceActiontwelve = createSequence(cistbletwelve1, delaytwelve1,cistbltwelve2,particletwelveClone,delayActiontwelve, stopActiontwelve)

    -- local node = createTotleAction(particleOne, sequenceActionOne)
    local node = createTotleAction(particleFour, sequenceActionFour,particleFive, sequenceActionFive,particleOne, sequenceActionOne,
                                   particlefifteen, sequenceActionfifteen,
                                   particleTwo, sequenceActionTwo,particlethirteen, 
                                   sequenceActionthirteen,  particleThree, sequenceActionThree,
                                   particlesix, sequenceActionsix,particlesixClone, sequenceActionsixClone, particleseven, sequenceActionseven,particleten, sequenceActionten,
                                   particlenine, sequenceActionnine,particleelevn, sequenceActionelevn,particleeight, sequenceActioneight,
                                   particletwelve, sequenceActiontwelve)
    return node
end

function UI_shangchengwujiangchouqushilianchou(func)--商城武将十连抽

    local particleFour = createParticle("ui_b001801", cc.p(480,140))
    local delayFour = createParticleDelay(0)
    local bezierFour1 = createRandomBezier(0.3, cc.p(500,80), cc.p(530,100), cc.p(555,150))
    local bezierFour2 = createRandomBezier(0.15, cc.p(570,246), cc.p(450,256), cc.p(310,270))
    local delayFour2 = createParticleDelay(0)
    local stopActionFour = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionFour = createSequence(delayFour, bezierFour1, bezierFour2, 
                                              delayFour2,stopActionFour)
    local spawnActionFour = createSpawn(sequenceActionFour)

    local particleFive = createParticle("ui_b001801", cc.p(460,140))
    local delayFive = createParticleDelay(0)
    local bezierFive1 = createRandomBezier(0.3, cc.p(500,240), cc.p(555,270), cc.p(540,300))
    local bezierFive2 = createRandomBezier(0.15, cc.p(450,350), cc.p(400,267), cc.p(310,270))
    local delayFive2 = createParticleDelay(0)
    local stopActionFive = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionFive = createSequence(delayFive, bezierFive1, bezierFive2, 
                                              delayFive2,stopActionFive)
    local spawnActionFive = createSpawn(sequenceActionFive)


    local particletwentytwo = createParticle("ui_b001701", cc.p(460,160))
    local delaytwentytwo= createParticleDelay(0)
    local beziertwentytwo1 = createRandomBezier(0.3, cc.p(460,20), cc.p(420,40), cc.p(350,180))
    local beziertwentytwo2 = createRandomBezier(0.15, cc.p(345,200), cc.p(360,240), cc.p(340,270))
    local delaytwentytwo2 = createParticleDelay(0)
    local stopActiontwentytwo = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActiontwentytwo = createSequence(delaytwentytwo, beziertwentytwo1, beziertwentytwo2, 
                                              delaytwentytwo2,stopActiontwentytwo)
    local spawnActiontwentytwo = createSpawn(sequenceActiontwentytwo)


    local particlesixteen = createParticle("ui_b001701", cc.p(500,190))
    local delaysixteen = createParticleDelay(0)
    local beziersixteen1 = createRandomBezier(0.3, cc.p(540,160), cc.p(570,180), cc.p(600,222))
    local beziersixteen2 = createRandomBezier(0.15, cc.p(530,270), cc.p(480,400), cc.p(300,250))
    local delaysixteen2 = createParticleDelay(0)
    local stopActionsixteen = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionsixteen = createSequence(delaysixteen, beziersixteen1, beziersixteen2, 
                                              delaysixteen2,stopActionsixteen)
    local spawnActionsixteen = createSpawn(sequenceActionsixteen)

    local particleseventeen = createParticle("ui_b001801", cc.p(470,140))
    local delayseventeen= createParticleDelay(0)
    local bezierseventeen1 = createRandomBezier(0.3, cc.p(460,160), cc.p(450,100), cc.p(470,134))
    local bezierseventeen2 = createRandomBezier(0.15, cc.p(360,60), cc.p(320,150), cc.p(310,250))
    local delayseventeen2 = createParticleDelay(0)
    local stopActionseventeen = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionseventeen = createSequence(delayseventeen, bezierseventeen1, bezierseventeen2, 
                                              delayseventeen2,stopActionseventeen)
    local spawnActionseventeen = createSpawn(sequenceActionseventeen)

    local particletwentythree = createParticle("ui_b001701", cc.p(470,160))
    local delaytwentythree= createParticleDelay(0)
    local beziertwentythree1 = createRandomBezier(0.3, cc.p(480,165), cc.p(490,170), cc.p(500,180))
    local beziertwentythree2 = createRandomBezier(0.15, cc.p(450,200), cc.p(380,230), cc.p(333,250))
    local delaytwentythree2 = createParticleDelay(0)
    local stopActiontwentythree = createParticleOut(0.5)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActiontwentythree = createSequence(delaytwentythree, beziertwentythree1, beziertwentythree2, 
                                              delaytwentythree2,stopActiontwentythree)
    local spawnActiontwentythree = createSpawn(sequenceActiontwentythree)

    --房子--一闪
    local particleOne = createParticle("ui_b001802", cc.p(310,835) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleOne1 = createVistbleAction(false)
    local delayOne1 = createParticleDelay(1.1)
    local cistbleOne2 = createVistbleAction(true)

    local delayActionOne = createParticleDelay(1.2)--持续时间
    -- local delayActionOne = createParticleDelay(2.7)--持续时间
    local stopActionOne = createParticleOut(0.1)
    local sequenceActionOne = createSequence(cistbleOne1,delayOne1,cistbleOne2,delayActionOne, stopActionOne)

    --房子--一闪
    local particletwentyFour = createParticle("ui_b001802", cc.p(310,780) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbletwentyFour1 = createVistbleAction(false)
    local delaytwentyFour1 = createParticleDelay(1.8)
    local cistbletwentyFour2 = createVistbleAction(true)
    local scaleToActiotten  = createScaleTo(1.2, 0.85, 0.85)

    local delayActiontwentyFour = createParticleDelay(0.3)--持续时间
    -- local delayActionOne = createParticleDelay(2.7)--持续时间
    local stopActiontwentyFour = createParticleOut(0.1)
    local sequenceActiontwentyFour = createSequence(cistbletwentyFour1,delaytwentyFour1,cistbletwentyFour2,scaleToActiotten,delayActiontwentyFour, stopActiontwentyFour)

    --房子--一闪
    local particlefifteen = createParticle("ui_b001805", cc.p(310,875) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblefifteen1 = createVistbleAction(false)
    local delayfifteen1 = createParticleDelay(3.4)
    local cistblefifteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001805")

    local delayActionfifteen= createParticleDelay(0.2)--持续时间
    local stopActionfifteen = createParticleOut(0.1)
    local sequenceActionfifteen = createSequence(cistblefifteen1,delayfifteen1,cistblefifteen2,particletwelveClone,delayActionfifteen, stopActionfifteen)

    --能量球--一闪
    local particleten = createParticle("ui_b001808", cc.p(320,700) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleten1 = createVistbleAction(false)
    local delayten1 = createParticleDelay(2.1)
    local cistbleten2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001808")

    local scaleToActiotten  = createScaleTo(0.8, 2, 2)
    local delayActionten = createParticleDelay(0.8)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistbleten1,delayten1,cistbleten2,scaleToActiotten, stopActionten)

    --聚气--
    local particlethirteen = createParticle("ui_b001812", cc.p(327,700) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(0.5)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001812")

    local delayActionthirteen = createParticleDelay(1.5)--持续时间
    local stopActionthirteen = createParticleOut(2)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,delayActionthirteen, stopActionthirteen)

    --向天上飞的星星

    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(3.5)
    local cistbleTwo2 = createVistbleAction(true)

    local particleTwo= createParticle("ui_b001803", cc.p(325,670))
    local delayTwo = createParticleDelay(0)
    local bezierTwo1 = createRandomBezier(0.2, cc.p(505,680), cc.p(485,730), cc.p(480,720))
    local bezierTwo2 = createRandomBezier(0.45, cc.p(95,770), cc.p(45,800), cc.p(320,900))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,delayTwo, bezierTwo1, bezierTwo2, 
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)

    --向天上飞的星星

    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(3.7)
    local cistbleThree2 = createVistbleAction(true)

    local particleThree= createParticle("ui_b001703", cc.p(325,670))
    local delayThree = createParticleDelay(0)
    local bezierThree1 = createRandomBezier(0.1, cc.p(165,680), cc.p(155,730), cc.p(160,720))
    local bezierThree2 = createRandomBezier(0.45, cc.p(545,770), cc.p(595,800), cc.p(320,900))
    local delayThree2 = createParticleDelay(0)
    local stopActionThree = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionThree = createSequence(cistbleThree1,delayThree1,cistbleThree2,delayThree, bezierThree1, bezierThree2, 
                                              delayThree2,stopActionThree)
    local spawnActionThree = createSpawn(sequenceActionThree)


    --向天上飞的星星

    local cistbleeighteen1 = createVistbleAction(false)
    local delayeighteen1 = createParticleDelay(3.6)
    local cistbleeighteen2 = createVistbleAction(true)

    local particleeighteen= createParticle("ui_b001703", cc.p(325,670))
    local delayeighteen = createParticleDelay(0)
    local beziereighteen = createRandomBezier(0.1, cc.p(585,680), cc.p(405,730), cc.p(410,720))
    local beziereighteen2 = createRandomBezier(0.45, cc.p(240,770), cc.p(150,800), cc.p(320,912))
    local delayeighteen2 = createParticleDelay(0)
    local stopActioneighteen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActioneighteen = createSequence(cistbleeighteen1,delayeighteen1,cistbleeighteen2,delayeighteen, beziereighteen, beziereighteen2, 
                                              delayeighteen2,stopActioneighteen)
    local spawnActioneighteen = createSpawn(sequenceActioneighteen)

    --向天上飞的星星

    local cistblenineteen1 = createVistbleAction(false)
    local delaynineteen1 = createParticleDelay(3.8)
    local cistblenineteen2 = createVistbleAction(true)

    local particlenineteen= createParticle("ui_b001803", cc.p(325,670))
    local delaynineteen = createParticleDelay(0)
    local beziernineteen = createRandomBezier(0.1, cc.p(205,680), cc.p(115,730), cc.p(120,720))
    local beziernineteen2 = createRandomBezier(0.45, cc.p(450,770), cc.p(500,800), cc.p(320,900))
    local delaynineteen2 = createParticleDelay(0)
    local stopActionnineteen = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionnineteen = createSequence(cistblenineteen1,delaynineteen1,cistblenineteen2,delaynineteen, beziernineteen, beziernineteen2, 
                                              delaynineteen2,stopActionnineteen)
    local spawnActionnineteen = createSpawn(sequenceActionnineteen)

    --向天上飞的星星

    local cistbletwentyone1 = createVistbleAction(false)
    local delaytwentyone1 = createParticleDelay(3.9)
    local cistbletwentyone2 = createVistbleAction(true)

    local particletwentyone= createParticle("ui_b001703", cc.p(325,670))
    local delaytwentyone = createParticleDelay(0)
    local beziertwentyone = createRandomBezier(0.1, cc.p(605,680), cc.p(570,730), cc.p(550,720))
    local beziertwentyone2 = createRandomBezier(0.45, cc.p(420,770), cc.p(400,800), cc.p(320,912))
    local delaytwentyone2 = createParticleDelay(0)
    local stopActiontwentyone = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActiontwentyone = createSequence(cistbletwentyone1,delaytwentyone1,cistbletwentyone2,delaytwentyone, beziertwentyone, beziertwentyone2, 
                                              delaytwentyone2,stopActiontwentyone)
    local spawnActiontwentyone = createSpawn(sequenceActiontwentyone)

    --天空--一闪
    local particlenine = createParticle("ui_b001807", cc.p(327,819) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblenine1 = createVistbleAction(false)
    local scaleToActionine  = createScaleTo(0,1, 2.2)
    local delaynine1 = createParticleDelay(4.1)
    local cistblenine2 = createVistbleAction(true)

    local delayActionnine = createParticleDelay(0.2)--持续时间
    local stopActionnine = createParticleOut(1)
    local sequenceActionnine = createSequence(cistblenine1,scaleToActionine,delaynine1,cistblenine2,delayActionnine, stopActionnine)

    --云--一闪
    local particlesix = createParticle("ui_b001804", cc.p(318,800) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblesix1 = createVistbleAction(false)
    local delaysix1 = createParticleDelay(4.3)
    local cistblesix2 = createVistbleAction(true)

    local delayActionsix = createParticleDelay(0.35)--持续时间
    local stopActionsix = createParticleOut(1.5)
    local sequenceActionsix = createSequence(cistblesix1,delaysix1,cistblesix2,delayActionsix, stopActionsix)

    --云--一闪
    local particletwentyFive = createParticle("ui_b001804", cc.p(318,800) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbletwentyFive1 = createVistbleAction(false)
    local delaytwentyFive1 = createParticleDelay(4.3)
    local cistbletwentyFive2 = createVistbleAction(true)

    local delayActiontwentyFive = createParticleDelay(0.35)--持续时间
    local stopActiontwentyFive = createParticleOut(1.5, func)
    local sequenceActiontwentyFive = createSequence(cistbletwentyFive1,delaytwentyFive1,cistbletwentyFive2,delayActiontwentyFive, stopActiontwentyFive)

    --星星--一闪一闪
    local particleseven = createParticle("ui_b001705", cc.p(318,800) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleseven1 = createVistbleAction(false)
    local delayseven1 = createParticleDelay(0)
    local cistbleseven2 = createVistbleAction(true)

    local delayActionseven = createParticleDelay(6)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(cistbleseven1,delayseven1,cistbleseven2,delayActionseven, stopActionseven)

    --天空中最亮的星
    local particleelevn = createParticle("ui_b001809", cc.p(265,819) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleelevn1 = createVistbleAction(false)
    local delayelevn1 = createParticleDelay(5)
    local cistblelevn2 = createVistbleAction(true)

    local delayActionelevn = createParticleDelay(0.1)--持续时间
    local stopActionelevn = createParticleOut(0.5)
    local sequenceActionelevn = createSequence(cistbleelevn1,delayelevn1,cistblelevn2,delayActionelevn, stopActionelevn)

    --天空中最亮的星
    local particleeight = createParticle("ui_b001811", cc.p(265,819) )
    -- local moveOne = createParticleMove(cc.p())

    local cistbleeight1 = createVistbleAction(false)
    local delayeight1 = createParticleDelay(5)
    local cistbleight2 = createVistbleAction(true)

    local delayActioneight = createParticleDelay(0.1)--持续时间
    local stopActioneight = createParticleOut(0.5)
    local sequenceActioneight = createSequence(cistbleeight1,delayeight1,cistbleight2,delayActioneight, stopActioneight)

    --星爆
    local particletwelve = createParticle("ui_b001810", cc.p(265,819) )
    -- local moveOne = createParticleMove(cc.p()) 

    local cistbletwelve1 = createVistbleAction(false)
    local scaleToActiotwelve  = createScaleTo(0, 1, 1)
    local delaytwelve1 = createParticleDelay(5.5)
    local cistbltwelve2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001810")

    local delayActiontwelve = createParticleDelay(0.3)--持续时间
    local stopActiontwelve = createParticleOut(0.2)
    local sequenceActiontwelve = createSequence(cistbletwelve1, delaytwelve1,cistbltwelve2,particletwelveClone,delayActiontwelve, stopActiontwelve)

    -- local node = createTotleAction(particleOne, sequenceActionOne)
    local node = createTotleAction(particleseventeen, sequenceActionseventeen,particlesixteen, sequenceActionsixteen,
                                   particleFour, sequenceActionFour, particleFive, sequenceActionFive, particletwentytwo, sequenceActiontwentytwo,
                                   particletwentythree, sequenceActiontwentythree, particletwentyFour, sequenceActiontwentyFour, 
                                   particleOne, sequenceActionOne,particlefifteen, sequenceActionfifteen,
                                   particleTwo, sequenceActionTwo,particleeighteen, sequenceActioneighteen,
                                   particlenineteen, sequenceActionnineteen,
                                   particletwentyone, sequenceActiontwentyone,
                                   particlethirteen, sequenceActionthirteen,  particleThree, sequenceActionThree,
                                   particlesix, sequenceActionsix,particletwentyFive, sequenceActiontwentyFive,
                                   particleseven, sequenceActionseven,particleten, sequenceActionten,
                                   particlenine, sequenceActionnine)
    return node
end

function UI_mobai1(func)--膜拜001   func

     --图标特效-- 第一个
    local particlefive = createParticle("ui_b000401", cc.p(150,585) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.3, 1.1, 1.1)
    local delayActionfive = createParticleDelay(999999999)--持续时间
    local stopActionfive = createParticleOut(0.5)
    local sequenceActionfive = createSequence(scaleToActiotten,delayActionfive,stopActionfive)

    --图标特效-- 第一个
    local particlesix = createParticle("ui_b001901", cc.p(150,587) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionsix = createParticleDelay(999999999)--持续时间
    local stopActionsix = createParticleOut(0.5, func)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    
    local node = createTotleAction(particlefive, sequenceActionfive,particlesix, sequenceActionsix)


    -- node:addChild(img, -1) -- to do
    return node
end

function UI_mobai2(func)--膜拜002  func


    --图标特效-- 第二个
    local particleFive = createParticle("ui_b001906", cc.p(327,587) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionFive = createParticleDelay(9999999)--持续时间
    local stopActionFive = createParticleOut(0.5)
    local sequenceActionFive = createSequence(delayActionFive,stopActionFive)

    --图标特效-- 第二个
    local particlesix = createParticle("ui_b001907", cc.p(321,587) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionsix = createParticleDelay(9999999)--持续时间
    local stopActionsix = createParticleOut(0.5, func)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)
   
    local node = createTotleAction(particleFive, sequenceActionFive,particlesix, sequenceActionsix)

    return node
end

function UI_mobai3(func)--膜拜003  

    --图标特效-- 第三个
    local particleFive = createParticle("ui_b001905", cc.p(498,585) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionFive = createParticleDelay(9999999)--持续时间
    local stopActionFive = createParticleOut(0.5)
    local sequenceActionFive = createSequence(delayActionFive,stopActionFive)

     --图标特效-- 第三个
    local particlesix = createParticle("ui_b001908", cc.p(498,585) )
    -- local moveOne = createParticleMove(cc.p())
    local scaleToActiotten  = createScaleTo(0.3, 1.45, 1.45)
    local delayActionsix = createParticleDelay(9999999)--持续时间
    local stopActionsix = createParticleOut(0.5)
    local sequenceActionsix = createSequence(scaleToActiotten,delayActionsix,stopActionsix)

    --图标特效-- 第三个
    local particleseven = createParticle("ui_b001909", cc.p(498,585) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActionseven = createParticleDelay(9999999)--持续时间
    local stopActionseven = createParticleOut(0.5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    --图标特效-- 第三个
    local particleeight = createParticle("ui_b001910", cc.p(498,585) )
    -- local moveOne = createParticleMove(cc.p())
    local delayActioneight = createParticleDelay(9999999)--持续时间
    local stopActioneight = createParticleOut(0.5, func)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)
    
     local node = createTotleAction(particleFive, sequenceActionFive,particlesix, sequenceActionsix,
                                    particleseven, sequenceActionseven,particleeight, sequenceActioneight
                                         )

    return node
end

function UI_mobai001(func)--膜拜001  

    --墓碑特效--  一闪
    local particleten = createParticle("ui_b001904", cc.p(335,571) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001904")

    local scaleToActiotten  = createScaleTo(0.12, 3.6, 3.6)
    local delayActionten = createParticleDelay(0.3)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten, delayActionten,stopActionten)


    --墓碑颗粒--  爆
    local particlethirteen = createParticle("ui_b001913", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001913")

    local delayActionthirteen = createParticleDelay(0.6)--持续时间
    local stopActionthirteen = createParticleOut(2)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,delayActionthirteen, stopActionthirteen)

    --墓碑闪电--  一闪
    local particlethree = createParticle("ui_b001914", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(1.7)
    local cistblethree2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001914")

    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(1)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,particletwelveClone,delayActionthree, stopActionthree)

    --墓碑火焰
    local particlefour = createParticle("ui_b000401", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(1)
    local cistblefour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b000401")
    local scaleToActiotten  = createScaleTo(0.3, 1.2, 2.5)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(1, func)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,particletwelveClone,scaleToActiotten,delayActionfour,stopActionfour)

    --旋转的星星

    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(0.2)
    local cistbleTwo2 = createVistbleAction(true)

    local particleTwo= createParticle("ui_b001903", cc.p(150,585))
    local delayTwo = createParticleDelay(0)
    local bezierTwo1 = createRandomBezier(0.1, cc.p(157,465), cc.p(212,384), cc.p(325,349))
    local bezierTwo2 = createRandomBezier(0.2, cc.p(444,368), cc.p(555,431), cc.p(594,558))
    local bezierTwo3 = createRandomBezier(0.25, cc.p(542,700), cc.p(480,776), cc.p(311,775))
    local bezierTwo4 = createRandomBezier(0.3, cc.p(200,697), cc.p(238,595), cc.p(337,555))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,delayTwo, bezierTwo1, bezierTwo2, bezierTwo3, bezierTwo4, 
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)
     
    -- local img = game.newSprite("res/diyi.png")--战斗胜利
    -- img:setPosition(150, 585)
    -- img:setScale(1,1)

    
    local node = createTotleAction(particleten, sequenceActionten,particlethirteen, sequenceActionthirteen,
                                    particleTwo, spawnActionTwo,particlethree, sequenceActionthree,
                                    particlefour, sequenceActionfour)


    -- node:addChild(img, -1) -- to do
    return node
end

function UI_mobai002(func)--膜拜002   func

   --墓碑特效--  一闪
    local particleten = createParticle("ui_b001904", cc.p(335,571) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001904")

    local scaleToActiotten  = createScaleTo(0.12, 3.6, 3.6)
    local delayActionten = createParticleDelay(0.3)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten, delayActionten,stopActionten)


    --墓碑颗粒--  爆
    local particlethirteen = createParticle("ui_b001913", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001913")

    local delayActionthirteen = createParticleDelay(0.6)--持续时间
    local stopActionthirteen = createParticleOut(2)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,delayActionthirteen, stopActionthirteen)

    --墓碑闪电--  一闪
    local particlethree = createParticle("ui_b001914", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(1.7)
    local cistblethree2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001914")

    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(1)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,particletwelveClone,delayActionthree, stopActionthree)

    --墓碑火焰
    local particlefour = createParticle("ui_b000401", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(1)
    local cistblefour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b000401")
    local scaleToActiotten  = createScaleTo(0.3, 1.2, 2.5)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(1, func)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,particletwelveClone,scaleToActiotten,delayActionfour,stopActionfour)

    --旋转的星星

    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(0.2)
    local cistbleTwo2 = createVistbleAction(true)

    local particleTwo= createParticle("ui_b001911", cc.p(324,588))
    local delayTwo = createParticleDelay(0)
    local bezierTwo1 = createRandomBezier(0.1, cc.p(466,727), cc.p(378,871), cc.p(100,772))
    local bezierTwo2 = createRandomBezier(0.2, cc.p(25,699), cc.p(-30,510), cc.p(69,340))
    local bezierTwo3 = createRandomBezier(0.25, cc.p(253,217), cc.p(468,250), cc.p(500,394))
    local bezierTwo4 = createRandomBezier(0.3, cc.p(555,530), cc.p(447,607), cc.p(337,555))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,delayTwo, bezierTwo1, bezierTwo2, bezierTwo3, bezierTwo4, 
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)
    
    -- local img = game.newSprite("res/dier.png")--战斗胜利
    -- img:setPosition(324, 588)
    -- img:setScale(1,1)

    
    local node = createTotleAction(particleten, sequenceActionten,particlethirteen, sequenceActionthirteen,
                                    particleTwo, spawnActionTwo,particlethree, sequenceActionthree,
                                    particlefour, sequenceActionfour)

    -- node:addChild(img, -1) -- to do

    return node
end

function UI_mobai003(func)--膜拜003  func

    --墓碑特效--  一闪
    local particleten = createParticle("ui_b001904", cc.p(335,571) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001904")

    local scaleToActiotten  = createScaleTo(0.12, 3.6, 3.6)
    local delayActionten = createParticleDelay(0.3)--持续时间
    local stopActionten = createParticleOut(0.5)
    local sequenceActionten = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,scaleToActiotten, delayActionten,stopActionten)


    --墓碑颗粒--  爆
    local particlethirteen = createParticle("ui_b001913", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethirteen1 = createVistbleAction(false)
    local delaythirteen1 = createParticleDelay(1)
    local cistblethirteen2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001913")

    local delayActionthirteen = createParticleDelay(0.6)--持续时间
    local stopActionthirteen = createParticleOut(2)
    local sequenceActionthirteen = createSequence(cistblethirteen1,delaythirteen1,cistblethirteen2,particletwelveClone,delayActionthirteen, stopActionthirteen)

    --墓碑闪电--  一闪
    local particlethree = createParticle("ui_b001914", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())

    local cistblethree1 = createVistbleAction(false)
    local delaythree1 = createParticleDelay(1.7)
    local cistblethree2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b001914")

    local delayActionthree = createParticleDelay(1)--持续时间
    local stopActionthree = createParticleOut(1)
    local sequenceActionthree = createSequence(cistblethree1,delaythree1,cistblethree2,particletwelveClone,delayActionthree, stopActionthree)

    --墓碑火焰
    local particlefour = createParticle("ui_b000401", cc.p(324,571) )
    -- local moveOne = createParticleMove(cc.p())
    local cistblefour1 = createVistbleAction(false)
    local delayfour1 = createParticleDelay(1)
    local cistblefour2 = createVistbleAction(true)
    local particletwelveClone = createRestartAction("ui_b000401")
    local scaleToActiotten  = createScaleTo(0.3, 1.2, 2.5)
    local delayActionfour = createParticleDelay(1)--持续时间
    local stopActionfour = createParticleOut(1, func)
    local sequenceActionfour = createSequence(cistblefour1,delayfour1,cistblefour2,particletwelveClone,scaleToActiotten,delayActionfour,stopActionfour)

    --旋转的星星

    local cistbleTwo1 = createVistbleAction(false)
    local delayTwo1 = createParticleDelay(0.2)
    local cistbleTwo2 = createVistbleAction(true)

    local particleTwo= createParticle("ui_b001912", cc.p(498,585))
    local delayTwo = createParticleDelay(0)
    local bezierTwo1 = createRandomBezier(0.1, cc.p(518,698), cc.p(449,794), cc.p(323,837))
    local bezierTwo2 = createRandomBezier(0.2, cc.p(170,817), cc.p(72,725), cc.p(45,586))
    local bezierTwo3 = createRandomBezier(0.25, cc.p(86,425), cc.p(210,338), cc.p(361,336))
    local bezierTwo4 = createRandomBezier(0.3, cc.p(479,424), cc.p(447,539), cc.p(337,555))
    local delayTwo2 = createParticleDelay(0)
    local stopActionTwo = createParticleOut(0.9)
    -- local sequenceActionFour = createSequence(bezierFour, delayFour2, stopActionFour)
    local sequenceActionTwo = createSequence(cistbleTwo1,delayTwo1,cistbleTwo2,delayTwo, bezierTwo1, bezierTwo2, bezierTwo3, bezierTwo4, 
                                              delayTwo2,stopActionTwo)
    local spawnActionTwo = createSpawn(sequenceActionTwo)

    -- local img = game.newSprite("res/disan.png")--战斗胜利
    -- img:setPosition(498,585)
    -- img:setScale(1,1)

    
     local node = createTotleAction(particleten, sequenceActionten,particlethirteen, sequenceActionthirteen,
                                    particleTwo, spawnActionTwo,particlethree, sequenceActionthree,
                                    particlefour, sequenceActionfour)

    -- node:addChild(img, -1) -- to do


    return node
end

function UI_Zhandoulishangsheng()--战斗力上升特效69

    -- 长条
    local particleone = createParticle("ui_a006901", cc.p(120,15),false) 
    local scaleToActionone1  = createScaleTo(0, 0.625, 0)
    local scaleToActionone2  = createScaleTo(0.1, 0.625, 0.5)
    local delayActionone = createParticleDelay(0.15)--持续时间
    local stopActionone = createParticleOut(0.5)
    local sequenceActionone = createSequence(scaleToActionone1,scaleToActionone2,delayActionone,stopActionone)

    -- 颗粒
    local particletwo = createParticle("ui_a006902", cc.p(120,15),false)  
    local scaleToActiontwo  = createScaleTo(0, 1, 0.4)     
    local delayActiontwo = createParticleDelay(0.5)--持续时间
    local stopActiontwo = createParticleOut(1.0)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)
  
    local node = createTotleAction(
                                  particleone, sequenceActionone,
                                  particletwo, sequenceActiontwo
                                  )

    return node
end































































