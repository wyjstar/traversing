--PVBoss Rank Particle
-- function UI_Jianglipaihangbiankuang()--奖励排行特效67


  




--     local node = createTotleAction( 
--                                      particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree
--                                     ,particlefour, sequenceActionfour,particlefive, sequenceActionfive,particleeight, sequenceActioneight
--                                     ,particlesix, sequenceActionsix
--                                     ,particleseven, sequenceActionseven
                                    
--                                     )

--     return node
-- end

--奖励特效第一名
function UI_Jianglipaihangbiankuang_frist( ... )
        -- 第一名的牌子
    local particleone = createParticle("ui_a006701", cc.p(325,840-720))
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- 颗粒
    local particletwo = createParticle("ui_a006702", cc.p(325,840-720))
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    -- 长条
    local particlethree = createParticle("ui_a006703", cc.p(320,725-720))
    local delayActionthree = createParticleDelay(999)--持续时间
    local stopActionthree = createParticleOut(5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)


    local node = createTotleAction( particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree
                                    )
    return node
end

function UI_Jianglipaihangbiankuang_second( ... )
        -- 第二名的牌子
    local particlefour = createParticle("ui_a006704", cc.p(325,626-506))
    local delayActionfour = createParticleDelay(999)--持续时间
    local stopActionfour = createParticleOut(5)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)
  
    -- 颗粒
    local particlefive = createParticle("ui_a006705", cc.p(325,626-506))
    local delayActionfive = createParticleDelay(999)--持续时间
    local stopActionfive = createParticleOut(5)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)
  
    -- 长条
    local particleeight = createParticle("ui_a006703", cc.p(325,515-506))
    local delayActioneight = createParticleDelay(999)--持续时间
    local stopActioneight = createParticleOut(5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    local node = createTotleAction(particlefour, sequenceActionfour,particlefive, sequenceActionfive,particleeight, sequenceActioneight)
    return node
end

function UI_Jianglipaihangbiankuang_third( ... )
    -- body
        -- 第三名的牌子
    local particlesix = createParticle("ui_a006706", cc.p(325,420-300))
    local delayActionsix = createParticleDelay(999)--持续时间
    local stopActionsix = createParticleOut(5)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    -- 颗粒
    local particleseven = createParticle("ui_a006707", cc.p(325,420-300))
    local delayActionseven = createParticleDelay(999)--持续时间
    local stopActionseven = createParticleOut(5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)

    local node = createTotleAction(    particlesix, sequenceActionsix
                                    ,particleseven, sequenceActionseven)
    return node

end

function UI_Dengjipaihangbiankuang_first( ... )
        -- 第一名的牌子
    local particleone = createParticle("ui_a006801", cc.p(325,790-670))
    local delayActionone = createParticleDelay(999)--持续时间
    local stopActionone = createParticleOut(5)
    local sequenceActionone = createSequence(delayActionone,stopActionone)

    -- 颗粒
    local particletwo = createParticle("ui_a006702", cc.p(325,840-670))
    local delayActiontwo = createParticleDelay(999)--持续时间
    local stopActiontwo = createParticleOut(5)
    local sequenceActiontwo = createSequence(delayActiontwo,stopActiontwo)

    -- 长条
    local particlethree = createParticle("ui_a006703", cc.p(320,725-670))
    local delayActionthree = createParticleDelay(999)--持续时间
    local stopActionthree = createParticleOut(5)
    local sequenceActionthree = createSequence(delayActionthree,stopActionthree)

    local node = createTotleAction(particleone, sequenceActionone,particletwo, sequenceActiontwo,particlethree, sequenceActionthree)
    return node
end

function UI_Dengjipaihangbiankuang_second( ... )
        -- 第二名的牌子
    local particlefour = createParticle("ui_a006802", cc.p(325,645-525))
    local delayActionfour = createParticleDelay(999)--持续时间
    local stopActionfour = createParticleOut(5)
    local sequenceActionfour = createSequence(delayActionfour,stopActionfour)
  
    -- 颗粒
    local particlefive = createParticle("ui_a006705", cc.p(325,690-525))
    local delayActionfive = createParticleDelay(999)--持续时间
    local stopActionfive = createParticleOut(5)
    local sequenceActionfive = createSequence(delayActionfive,stopActionfive)
  
    -- 长条
    local particleeight = createParticle("ui_a006703", cc.p(325,570-525))
    local delayActioneight = createParticleDelay(999)--持续时间
    local stopActioneight = createParticleOut(5)
    local sequenceActioneight = createSequence(delayActioneight,stopActioneight)

    local node = createTotleAction(particlefour, sequenceActionfour,particlefive, sequenceActionfive,particleeight, sequenceActioneight)

    return node
end

function UI_Dengjipaihangbiankuang_third( ... )
        -- 第三名的牌子
    local particlesix = createParticle("ui_a006803", cc.p(325,480-360))
    local delayActionsix = createParticleDelay(999)--持续时间
    local stopActionsix = createParticleOut(5)
    local sequenceActionsix = createSequence(delayActionsix,stopActionsix)

    -- 颗粒
    local particleseven = createParticle("ui_a006707", cc.p(325,530-360))
    local delayActionseven = createParticleDelay(999)--持续时间
    local stopActionseven = createParticleOut(5)
    local sequenceActionseven = createSequence(delayActionseven,stopActionseven)


    local node = createTotleAction(particlesix, sequenceActionsix,particleseven, sequenceActionseven)
    
    return node
end