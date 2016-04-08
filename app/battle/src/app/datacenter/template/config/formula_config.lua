formula_config={
  [1] = {
  ["precondition"] = "1",  ["formula"] = "monster_info.hp/6+monster_info.atk/3+(monster_info.physicalDef+monster_info.magicDef)/2+monster_info.hit-9000+monster_info.dodge+monster_info.cri+monster_info.criCoeff-12000+monster_info.criDedCoeff+monster_info.block*2+monster_info.ductility",  ["clientPrecondition"] = "1",  ["id"] = 1,  ["clientFormula"] = "result=monster_info.hp/6+monster_info.atk/3+(monster_info.physicalDef+monster_info.magicDef)/2+monster_info.hit-9000+monster_info.dodge+monster_info.cri+monster_info.criCoeff-12000+monster_info.criDedCoeff+monster_info.block*2+monster_info.ductility",  ["key"] = "fightValue",}
,  [2] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone",  ["clientPrecondition"] = "1",  ["id"] = 2,  ["clientFormula"] = "result=hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone",  ["key"] = "hpHeroBase",}
,  [3] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone",  ["clientPrecondition"] = "1",  ["id"] = 3,  ["clientFormula"] = "result=hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone",  ["key"] = "atkHeroBase",}
,  [4] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone",  ["clientPrecondition"] = "1",  ["id"] = 4,  ["clientFormula"] = "result=hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone",  ["key"] = "physicalDefHeroBase",}
,  [5] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone",  ["clientPrecondition"] = "1",  ["id"] = 5,  ["clientFormula"] = "result=hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone",  ["key"] = "magicDefHeroBase",}
,  [6] = {
  ["precondition"] = "1",  ["formula"] = "hpHeroBase*(1+AwakePercent)",  ["clientPrecondition"] = "1",  ["id"] = 6,  ["clientFormula"] = "result=hpHeroBase*(1+AwakePercent)",  ["key"] = "hpHeroSelf",}
,  [7] = {
  ["precondition"] = "1",  ["formula"] = "atkHeroBase*(1+AwakePercent)",  ["clientPrecondition"] = "1",  ["id"] = 7,  ["clientFormula"] = "result=atkHeroBase*(1+AwakePercent)",  ["key"] = "atkHeroSelf",}
,  [8] = {
  ["precondition"] = "1",  ["formula"] = "physicalDefHeroBase*(1+AwakePercent)",  ["clientPrecondition"] = "1",  ["id"] = 8,  ["clientFormula"] = "result=physicalDefHeroBase*(1+AwakePercent)",  ["key"] = "physicalDefHeroSelf",}
,  [9] = {
  ["precondition"] = "1",  ["formula"] = "magicDefHeroBase*(1+AwakePercent)",  ["clientPrecondition"] = "1",  ["id"] = 9,  ["clientFormula"] = "result=magicDefHeroBase*(1+AwakePercent)",  ["key"] = "magicDefHeroSelf",}
,  [10] = {
  ["precondition"] = "1",  ["formula"] = "hpHeroBase*(1+AwakePercent+EquPercent)",  ["clientPrecondition"] = "1",  ["id"] = 10,  ["clientFormula"] = "result=hpHeroBase*(1+AwakePercent+EquPercent)",  ["key"] = "hpHeroLineBase",}
,  [11] = {
  ["precondition"] = "1",  ["formula"] = "atkHeroBase*(1+AwakePercent+EquPercent)",  ["clientPrecondition"] = "1",  ["id"] = 11,  ["clientFormula"] = "result=atkHeroBase*(1+AwakePercent+EquPercent)",  ["key"] = "atkHeroLineBase",}
,  [12] = {
  ["precondition"] = "1",  ["formula"] = "physicalDefHeroBase*(1+AwakePercent+EquPercent)",  ["clientPrecondition"] = "1",  ["id"] = 12,  ["clientFormula"] = "result=physicalDefHeroBase*(1+AwakePercent+EquPercent)",  ["key"] = "physicalDefHeroLineBase",}
,  [13] = {
  ["precondition"] = "1",  ["formula"] = "magicDefHeroBase*(1+AwakePercent+EquPercent)",  ["clientPrecondition"] = "1",  ["id"] = 13,  ["clientFormula"] = "result=magicDefHeroBase*(1+AwakePercent+EquPercent)",  ["key"] = "magicDefHeroLineBase",}
,  [14] = {
  ["precondition"] = "1",  ["formula"] = "hpHeroLineBase+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["clientPrecondition"] = "1",  ["id"] = 14,  ["clientFormula"] = "result=hpHeroLineBase+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["key"] = "hpHeroLine",}
,  [15] = {
  ["precondition"] = "1",  ["formula"] = "atkHeroLineBase+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["clientPrecondition"] = "1",  ["id"] = 15,  ["clientFormula"] = "result=atkHeroLineBase+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["key"] = "atkHeroLine",}
,  [16] = {
  ["precondition"] = "1",  ["formula"] = "physicalDefHeroLineBase+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["clientPrecondition"] = "1",  ["id"] = 16,  ["clientFormula"] = "result=physicalDefHeroLineBase+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["key"] = "physicalDefHeroLine",}
,  [17] = {
  ["precondition"] = "1",  ["formula"] = "magicDefHeroLineBase+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["clientPrecondition"] = "1",  ["id"] = 17,  ["clientFormula"] = "result=magicDefHeroLineBase+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["key"] = "magicDefHeroLine",}
,  [18] = {
  ["precondition"] = "1",  ["formula"] = "hpHeroSelf/6+atkHeroSelf/3+(physicalDefHeroSelf+magicDefHeroSelf)/2",  ["clientPrecondition"] = "1",  ["id"] = 18,  ["clientFormula"] = "result=hpHeroSelf/6+atkHeroSelf/3+(physicalDefHeroSelf+magicDefHeroSelf)/2",  ["key"] = "fightValueHeroSelf",}
,  [19] = {
  ["precondition"] = "1",  ["formula"] = "(hpHeroSelf4*0.2+hpHeroSelf5*0.1+hpHeroSelf6*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 19,  ["clientFormula"] = "result=(hpHeroSelf4*0.2+hpHeroSelf5*0.1+hpHeroSelf6*0.1)/person",  ["key"] = "hpCheerLine",}
,  [20] = {
  ["precondition"] = "1",  ["formula"] = "atkHeroSelf1*0.2/person",  ["clientPrecondition"] = "1",  ["id"] = 20,  ["clientFormula"] = "result=atkHeroSelf1*0.2/person",  ["key"] = "atkCheerLine",}
,  [21] = {
  ["precondition"] = "1",  ["formula"] = "(physicalDefHeroSelf2*0.1+physicalDefHeroSelf5*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 21,  ["clientFormula"] = "result=(physicalDefHeroSelf2*0.1+physicalDefHeroSelf5*0.1)/person",  ["key"] = "physicalDefCheerLine",}
,  [22] = {
  ["precondition"] = "1",  ["formula"] = "(magicDefHeroSelf3*0.1+magicDefHeroSelf6*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 22,  ["clientFormula"] = "result=(magicDefHeroSelf3*0.1+magicDefHeroSelf6*0.1)/person",  ["key"] = "magicDefCheerLine",}
,  [23] = {
  ["precondition"] = "1",  ["formula"] = "hpHeroLine/6+atkHeroLine/3+(physicalDefHeroLine+magicDefHeroLine)/2+hitArray-hero_info.hit+dodgeArray-hero_info.dodge+criArray-hero_info.cri+criCoeffArray-hero_info.criCoeff+criDedCoeffArray-hero_info.criDedCoeff+blockArray*2-2*hero_info.block+ductilityArray-hero_info.ductility",  ["clientPrecondition"] = "1",  ["id"] = 23,  ["clientFormula"] = "result=hpHeroLine/6+atkHeroLine/3+(physicalDefHeroLine+magicDefHeroLine)/2+hitArray-hero_info.hit+dodgeArray-hero_info.dodge+criArray-hero_info.cri+criCoeffArray-hero_info.criCoeff+criDedCoeffArray-hero_info.criDedCoeff+blockArray*2-2*hero_info.block+ductilityArray-hero_info.ductility",  ["key"] = "fightValueArrayLine",}
,  [24] = {
  ["precondition"] = "1",  ["formula"] = "fightValueArrayLine1+fightValueArrayLine2+fightValueArrayLine3+fightValueArrayLine4+fightValueArrayLine5+fightValueArrayLine6",  ["clientPrecondition"] = "1",  ["id"] = 24,  ["clientFormula"] = "result=fightValueArrayLine1+fightValueArrayLine2+fightValueArrayLine3+fightValueArrayLine4+fightValueArrayLine5+fightValueArrayLine6",  ["key"] = "fightValuePlayerLine",}
,  [25] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.hit+hitB+hitSeal+hitStone",  ["clientPrecondition"] = "1",  ["id"] = 25,  ["clientFormula"] = "result=hero_info.hit+hitB+hitSeal+hitStone",  ["key"] = "hitHero",}
,  [26] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.dodge+dodgeB+dodgeSeal+dodgeStone",  ["clientPrecondition"] = "1",  ["id"] = 26,  ["clientFormula"] = "result=hero_info.dodge+dodgeB+dodgeSeal+dodgeStone",  ["key"] = "dodgeHero",}
,  [27] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.cri+criB+criSeal+criStone",  ["clientPrecondition"] = "1",  ["id"] = 27,  ["clientFormula"] = "result=hero_info.cri+criB+criSeal+criStone",  ["key"] = "criHero",}
,  [28] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone",  ["clientPrecondition"] = "1",  ["id"] = 28,  ["clientFormula"] = "result=hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone",  ["key"] = "criCoeffHero",}
,  [29] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone",  ["clientPrecondition"] = "1",  ["id"] = 29,  ["clientFormula"] = "result=hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone",  ["key"] = "criDedCoeffHero",}
,  [30] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.block+blockB+blockSeal+blockStone",  ["clientPrecondition"] = "1",  ["id"] = 30,  ["clientFormula"] = "result=hero_info.block+blockB+blockSeal+blockStone",  ["key"] = "blockHero",}
,  [31] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.ductility+ductilityB+ductilitySeal+ductilityStone",  ["clientPrecondition"] = "1",  ["id"] = 31,  ["clientFormula"] = "result=hero_info.ductility+ductilityB+ductilitySeal+ductilityStone",  ["key"] = "ductilityHero",}
,  [32] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 32,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hpB_1",}
,  [33] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 33,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "hpB_2",}
,  [34] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 34,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "atkB_1",}
,  [35] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.atk+hero_info.growAtk*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 35,  ["clientFormula"] = "result=(hero_info.atk+hero_info.growAtk*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "atkB_2",}
,  [36] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 36,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "pDefB_1",}
,  [37] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 37,  ["clientFormula"] = "result=(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "pDefB_2",}
,  [38] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 38,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "mDefB_1",}
,  [39] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 39,  ["clientFormula"] = "result=(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "mDefB_2",}
,  [40] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 40,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hitB",}
,  [41] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 41,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "dodgeB",}
,  [42] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 42,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criB",}
,  [43] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 43,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criCoeffB",}
,  [44] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 44,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criDedCoeffB",}
,  [45] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 45,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "blockB",}
,  [46] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 46,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "ductilityB",}
,  [47] = {
  ["precondition"] = "1",  ["formula"] = "hitHero+hitEqu+hitSetEqu+hitlink",  ["clientPrecondition"] = "1",  ["id"] = 47,  ["clientFormula"] = "result=hitHero+hitEqu+hitSetEqu+hitlink",  ["key"] = "hitArray",}
,  [48] = {
  ["precondition"] = "1",  ["formula"] = "dodgeHero+dodgeEqu+dodgeSetEqu+dodgelink",  ["clientPrecondition"] = "1",  ["id"] = 48,  ["clientFormula"] = "result=dodgeHero+dodgeEqu+dodgeSetEqu+dodgelink",  ["key"] = "dodgeArray",}
,  [49] = {
  ["precondition"] = "1",  ["formula"] = "criHero+criEqu+criSetEqu+crilink",  ["clientPrecondition"] = "1",  ["id"] = 49,  ["clientFormula"] = "result=criHero+criEqu+criSetEqu+crilink",  ["key"] = "criArray",}
,  [50] = {
  ["precondition"] = "1",  ["formula"] = "criCoeffHero+criCoeffEqu+criCoeffSetEqu+criCoefflink",  ["clientPrecondition"] = "1",  ["id"] = 50,  ["clientFormula"] = "result=criCoeffHero+criCoeffEqu+criCoeffSetEqu+criCoefflink",  ["key"] = "criCoeffArray",}
,  [51] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeffHero+criDedCoeffEqu+criDedCoeffSetEqu+criDedCoefflink",  ["clientPrecondition"] = "1",  ["id"] = 51,  ["clientFormula"] = "result=criDedCoeffHero+criDedCoeffEqu+criDedCoeffSetEqu+criDedCoefflink",  ["key"] = "criDedCoeffArray",}
,  [52] = {
  ["precondition"] = "1",  ["formula"] = "blockHero+blockEqu+blockSetEqu+blocklink",  ["clientPrecondition"] = "1",  ["id"] = 52,  ["clientFormula"] = "result=blockHero+blockEqu+blockSetEqu+blocklink",  ["key"] = "blockArray",}
,  [53] = {
  ["precondition"] = "1",  ["formula"] = "ductilityHero+ductilityEqu+ductilitySetEqu+ductilitylink",  ["clientPrecondition"] = "1",  ["id"] = 53,  ["clientFormula"] = "result=ductilityHero+ductilityEqu+ductilitySetEqu+ductilitylink",  ["key"] = "ductilityArray",}
,  [54] = {
  ["precondition"] = "1",  ["formula"] = "baseHp+growHp*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 54,  ["clientFormula"] = "result=baseHp+growHp*(equLevel-1)",  ["key"] = "hpEqu",}
,  [55] = {
  ["precondition"] = "1",  ["formula"] = "baseAtk+growAtk*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 55,  ["clientFormula"] = "result=baseAtk+growAtk*(equLevel-1)",  ["key"] = "atkEqu",}
,  [56] = {
  ["precondition"] = "1",  ["formula"] = "basePdef+growPdef*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 56,  ["clientFormula"] = "result=basePdef+growPdef*(equLevel-1)",  ["key"] = "physicalDefEqu",}
,  [57] = {
  ["precondition"] = "1",  ["formula"] = "baseMdef+growMdef*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 57,  ["clientFormula"] = "result=baseMdef+growMdef*(equLevel-1)",  ["key"] = "magicDefEqu",}
,  [58] = {
  ["precondition"] = "1",  ["formula"] = "hit+growHit*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 58,  ["clientFormula"] = "result=hit+growHit*(equLevel-1)",  ["key"] = "hitEqu",}
,  [59] = {
  ["precondition"] = "1",  ["formula"] = "dodge+growDodge*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 59,  ["clientFormula"] = "result=dodge+growDodge*(equLevel-1)",  ["key"] = "dodgeEqu",}
,  [60] = {
  ["precondition"] = "1",  ["formula"] = "cri+growCri*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 60,  ["clientFormula"] = "result=cri+growCri*(equLevel-1)",  ["key"] = "criEqu",}
,  [61] = {
  ["precondition"] = "1",  ["formula"] = "criCoeff+growCriCoeff*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 61,  ["clientFormula"] = "result=criCoeff+growCriCoeff*(equLevel-1)",  ["key"] = "criCoeffEqu",}
,  [62] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeff+growCriDedCoeff*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 62,  ["clientFormula"] = "result=criDedCoeff+growCriDedCoeff*(equLevel-1)",  ["key"] = "criDedCoeffEqu",}
,  [63] = {
  ["precondition"] = "1",  ["formula"] = "block+growBlock*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 63,  ["clientFormula"] = "result=block+growBlock*(equLevel-1)",  ["key"] = "blockEqu",}
,  [64] = {
  ["precondition"] = "1",  ["formula"] = "ductility+growDuctility*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 64,  ["clientFormula"] = "result=ductility+growDuctility*(equLevel-1)",  ["key"] = "ductilityEqu",}
,  [65] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 65,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hpSetEqu_1",}
,  [66] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 66,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "hpSetEqu_2",}
,  [67] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 67,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "atkSetEqu_1",}
,  [68] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 68,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "atkSetEqu_2",}
,  [69] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 69,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "physicalDefSetEqu_1",}
,  [70] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 70,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "physicalDefSetEqu_2",}
,  [71] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 71,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "magicDefSetEqu_1",}
,  [72] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 72,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "magicDefSetEqu_2",}
,  [73] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 73,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hitSetEqu",}
,  [74] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 74,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "dodgeSetEqu",}
,  [75] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 75,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criSetEqu",}
,  [76] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 76,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criCoeffSetEqu",}
,  [77] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 77,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criDedCoeffSetEqu",}
,  [78] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 78,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "blockSetEqu",}
,  [79] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 79,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "ductilitySetEqu",}
,  [80] = {
  ["precondition"] = "1",  ["formula"] = "hpB_1",  ["clientPrecondition"] = "1",  ["id"] = 80,  ["clientFormula"] = "hpB_1",  ["key"] = "hplink",}
,  [81] = {
  ["precondition"] = "1",  ["formula"] = "hpB_2",  ["clientPrecondition"] = "1",  ["id"] = 81,  ["clientFormula"] = "hpB_2",  ["key"] = "hplink",}
,  [82] = {
  ["precondition"] = "1",  ["formula"] = "atkB_1",  ["clientPrecondition"] = "1",  ["id"] = 82,  ["clientFormula"] = "atkB_1",  ["key"] = "atklink_1",}
,  [83] = {
  ["precondition"] = "1",  ["formula"] = "atkB_2",  ["clientPrecondition"] = "1",  ["id"] = 83,  ["clientFormula"] = "atkB_2",  ["key"] = "atklink_2",}
,  [84] = {
  ["precondition"] = "1",  ["formula"] = "pDefB_1",  ["clientPrecondition"] = "1",  ["id"] = 84,  ["clientFormula"] = "pDefB_1",  ["key"] = "physicalDeflink",}
,  [85] = {
  ["precondition"] = "1",  ["formula"] = "pDefB_2",  ["clientPrecondition"] = "1",  ["id"] = 85,  ["clientFormula"] = "pDefB_2",  ["key"] = "physicalDeflink",}
,  [86] = {
  ["precondition"] = "1",  ["formula"] = "mDefB_1",  ["clientPrecondition"] = "1",  ["id"] = 86,  ["clientFormula"] = "mDefB_1",  ["key"] = "magicDeflink",}
,  [87] = {
  ["precondition"] = "1",  ["formula"] = "mDefB_2",  ["clientPrecondition"] = "1",  ["id"] = 87,  ["clientFormula"] = "mDefB_2",  ["key"] = "magicDeflink",}
,  [88] = {
  ["precondition"] = "1",  ["formula"] = "hitB",  ["clientPrecondition"] = "1",  ["id"] = 88,  ["clientFormula"] = "hitB",  ["key"] = "hitlink",}
,  [89] = {
  ["precondition"] = "1",  ["formula"] = "dodgeB",  ["clientPrecondition"] = "1",  ["id"] = 89,  ["clientFormula"] = "dodgeB",  ["key"] = "dodgelink",}
,  [90] = {
  ["precondition"] = "1",  ["formula"] = "criB",  ["clientPrecondition"] = "1",  ["id"] = 90,  ["clientFormula"] = "criB",  ["key"] = "crilink",}
,  [91] = {
  ["precondition"] = "1",  ["formula"] = "criCoeffB",  ["clientPrecondition"] = "1",  ["id"] = 91,  ["clientFormula"] = "criCoeffB",  ["key"] = "criCoefflink",}
,  [92] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeffB",  ["clientPrecondition"] = "1",  ["id"] = 92,  ["clientFormula"] = "criDedCoeffB",  ["key"] = "criDedCoefflink",}
,  [93] = {
  ["precondition"] = "1",  ["formula"] = "blockB",  ["clientPrecondition"] = "1",  ["id"] = 93,  ["clientFormula"] = "blockB",  ["key"] = "blocklink",}
,  [94] = {
  ["precondition"] = "1",  ["formula"] = "ductilityB",  ["clientPrecondition"] = "1",  ["id"] = 94,  ["clientFormula"] = "ductilityB",  ["key"] = "ductilitylink",}
,  [95] = {
  ["precondition"] = "1",  ["formula"] = "1 if triggerRate>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 95,  ["clientFormula"] = "result=(triggerRate>random and 1) or 0",  ["key"] = "isTrigger",}
,  [96] = {
  ["precondition"] = "1",  ["formula"] = "1 if hitArray1/100-dodgeArray2/100>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 96,  ["clientFormula"] = "result=((hitArray1-dodgeArray2)/100>random and 1) or 0",  ["key"] = "isHit",}
,  [97] = {
  ["precondition"] = "1",  ["formula"] = "1 if criArray1/100-ductilityArray2/100>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 97,  ["clientFormula"] = "result=((criArray1-ductilityArray2)/100>random and 1) or 0",  ["key"] = "isCri",}
,  [98] = {
  ["precondition"] = "1",  ["formula"] = "1 if blockArray/100>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 98,  ["clientFormula"] = "result=(blockArray/100>random and 1) or 0",  ["key"] = "isBlock",}
,  [99] = {
  ["precondition"] = "1",  ["formula"] = "atkArray-def2 if atkArray-def2 > heroLevel else heroLevel",  ["clientPrecondition"] = "1",  ["id"] = 99,  ["clientFormula"] = "result= (atkArray-def2 > heroLevel and atkArray-def2 ) or heroLevel",  ["key"] = "baseDamage",}
,  [100] = {
  ["precondition"] = "1",  ["formula"] = "(criCoeffArray1-criDedCoeffArray2)/10000",  ["clientPrecondition"] = "1",  ["id"] = 100,  ["clientFormula"] = "result=(criCoeffArray1-criDedCoeffArray2)/10000",  ["key"] = "criDamage",}
,  [101] = {
  ["precondition"] = "1",  ["formula"] = "1 if heroLevel1<heroLevel2+5 else 1",  ["clientPrecondition"] = "1",  ["id"] = 101,  ["clientFormula"] = "result=1",  ["key"] = "levelDamage",}
,  [102] = {
  ["precondition"] = "1",  ["formula"] = "k1+random*(k2-k1)/99",  ["clientPrecondition"] = "",  ["id"] = 102,  ["clientFormula"] = "result=k1+random*(k2-k1)/99",  ["key"] = "floatDamage",}
,  [103] = {
  ["precondition"] = "1",  ["formula"] = "baseDamage*(1 if isHit else 0)*(criDamage if isCri else 1)*(0.7 if isBlock else 1)",  ["clientPrecondition"] = "1",  ["id"] = 103,  ["clientFormula"] = "result=baseDamage*((isHit and 1) or 0)*((isCri and criDamage) or 1)*((isBlock and 0.7) or 1)*levelDamage*floatDamage",  ["key"] = "allDamage",}
,  [104] = {
  ["precondition"] = "1",  ["formula"] = "atkArray*(criCoeffArray/1000 if isCri else 1)",  ["clientPrecondition"] = "1",  ["id"] = 104,  ["clientFormula"] = "result=atkArray*((isCri and criCoeffArray/1000) or 1)",  ["key"] = "allHeal",}
,  [105] = {
  ["precondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType ==1",  ["formula"] = "allDamage+skill_buff.valueEffect",  ["clientPrecondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType ==1",  ["id"] = 105,  ["clientFormula"] = "result=allDamage+skill_buff.valueEffect",  ["key"] = "damage_1",}
,  [106] = {
  ["precondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType == 2",  ["formula"] = "allDamage*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType == 2",  ["id"] = 106,  ["clientFormula"] = "result=allDamage*skill_buff.valueEffect/100",  ["key"] = "damage_2",}
,  [107] = {
  ["precondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 1",  ["formula"] = "skill_buff.valueEffect",  ["clientPrecondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 1",  ["id"] = 107,  ["clientFormula"] = "result=skill_buff.valueEffect",  ["key"] = "damage_3",}
,  [108] = {
  ["precondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 2",  ["formula"] = "atkArray*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 2",  ["id"] = 108,  ["clientFormula"] = "result=atkArray*skill_buff.valueEffect/100",  ["key"] = "damage_4",}
,  [109] = {
  ["precondition"] = "1",  ["formula"] = "500",  ["clientPrecondition"] = "1",  ["id"] = 109,  ["clientFormula"] = "result=500",  ["key"] = "warriorsDamage",}
,  [110] = {
  ["precondition"] = "1",  ["formula"] = "warriorsBaseDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*playerLevel",  ["clientPrecondition"] = "1",  ["id"] = 110,  ["clientFormula"] = "result=warriorsBaseDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*playerLevel",  ["key"] = "warriorsLastDamage",}
,  [111] = {
  ["precondition"] = "1",  ["formula"] = "atk*0.6",  ["clientPrecondition"] = "1",  ["id"] = 111,  ["clientFormula"] = "result=atk*0.6",  ["key"] = "monster_warriors_atkArray",}
,  [112] = {
  ["precondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 1",  ["formula"] = "allHeal+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 1",  ["id"] = 112,  ["clientFormula"] = "result=allHeal+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "heal_1",}
,  [113] = {
  ["precondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 2",  ["formula"] = "allHeal*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 2",  ["id"] = 113,  ["clientFormula"] = "result=allHeal*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["key"] = "heal_2",}
,  [114] = {
  ["precondition"] = "skill_buff.effectId >3 and skill_buff.effectId != 26 and skill_buff.valueType == 1",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId >3 and skill_buff.effectId ~= 26 and skill_buff.valueType == 1",  ["id"] = 114,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "skillbuffEffct_1",}
,  [115] = {
  ["precondition"] = "skill_buff.effectId >3 and skill_buff.effectId != 26 and skill_buff.valueType == 2",  ["formula"] = "attrHero*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.effectId >3 and skill_buff.effectId ~= 26 and skill_buff.valueType == 2",  ["id"] = 115,  ["clientFormula"] = "result=attrHero*skill_buff.valueEffect/100",  ["key"] = "skillbuffEffct_2",}
,  [116] = {
  ["precondition"] = "seatHero==1",  ["formula"] = "[1,2,3,4,5,6]",  ["clientPrecondition"] = "seatHero==1",  ["id"] = 116,  ["clientFormula"] = "result=[1,2,3,4,5,6]",  ["key"] = "defaultAttackSequence_1 ",}
,  [117] = {
  ["precondition"] = "seatHero==2",  ["formula"] = "[2,3,1,5,6,4]",  ["clientPrecondition"] = "seatHero==2",  ["id"] = 117,  ["clientFormula"] = "result=[2,3,1,5,6,4]",  ["key"] = "defaultAttackSequence_2",}
,  [118] = {
  ["precondition"] = "seatHero==3",  ["formula"] = "[3,1,2,6,4,5]",  ["clientPrecondition"] = "seatHero==3",  ["id"] = 118,  ["clientFormula"] = "result=[3,1,2,6,4,5]",  ["key"] = "defaultAttackSequence_3 ",}
,  [119] = {
  ["precondition"] = "seatHero==4",  ["formula"] = "[1,2,3,4,5,6]",  ["clientPrecondition"] = "seatHero==4",  ["id"] = 119,  ["clientFormula"] = "result=[1,2,3,4,5,6]",  ["key"] = "defaultAttackSequence_4",}
,  [120] = {
  ["precondition"] = "seatHero==5",  ["formula"] = "[2,3,1,5,6,4]",  ["clientPrecondition"] = "seatHero==5",  ["id"] = 120,  ["clientFormula"] = "result=[2,3,1,5,6,4]",  ["key"] = "defaultAttackSequence_5",}
,  [121] = {
  ["precondition"] = "seatHero==6",  ["formula"] = "[3,1,2,6,4,5]",  ["clientPrecondition"] = "seatHero==6",  ["id"] = 121,  ["clientFormula"] = "result=[3,1,2,6,4,5]",  ["key"] = "defaultAttackSequence_6",}
,  [122] = {
  ["precondition"] = "1",  ["formula"] = "hp/6+atk/3+(physicalDef+magicDef)/2+hit+dodge+cri+criCoeff+criDedCoeff+ductility+block*2",  ["clientPrecondition"] = "1",  ["id"] = 122,  ["clientFormula"] = "result=equ_attr.hp/6+equ_attr.atk/3+(equ_attr.physicalDef+equ_attr.magicDef)/2+equ_attr.hit+equ_attr.dodge+equ_attr.cri+equ_attr.criCoeff+equ_attr.criDedCoeff+equ_attr.block*2+equ_attr.ductility",  ["key"] = "equFightValue",}
,  [123] = {
  ["precondition"] = "1",  ["formula"] = "1 if moonCardSurplusDay < 9999999 else 0",  ["clientPrecondition"] = "1",  ["id"] = 123,  ["clientFormula"] = "result=(moonCardSurplusDay < 4 and 1) or 0",  ["key"] = "moonCard",}
,  [124] = {
  ["precondition"] = "1",  ["formula"] = "1 if weekCardSurplusDay < 4 else 0",  ["clientPrecondition"] = "1",  ["id"] = 124,  ["clientFormula"] = "result=(weekCardSurplusDay < 3 and 1) or 0",  ["key"] = "weekCard",}
,  [125] = {
  ["precondition"] = "1",  ["formula"] = "(highestRank - upRank)/2",  ["clientPrecondition"] = "1",  ["id"] = 125,  ["clientFormula"] = "result=(highestRank - upRank)/2",  ["key"] = "arenaRankUpRewardsValue",}
,  [126] = {
  ["precondition"] = "1",  ["formula"] = "heroNum*10",  ["clientPrecondition"] = "1",  ["id"] = 126,  ["clientFormula"] = "result=heroNum*10",  ["key"] = "guide2001",}
,  [127] = {
  ["precondition"] = "1",  ["formula"] = "heroNum*10",  ["clientPrecondition"] = "1",  ["id"] = 127,  ["clientFormula"] = "result=heroNum*10",  ["key"] = "guide2002",}
,  [128] = {
  ["precondition"] = "1",  ["formula"] = "(heroBreak1+heroBreak2+heroBreak3+heroBreak4+heroBreak5+heroBreak6)*10",  ["clientPrecondition"] = "1",  ["id"] = 128,  ["clientFormula"] = "result=(heroBreak)*10",  ["key"] = "guide2003",}
,  [129] = {
  ["precondition"] = "1",  ["formula"] = "(heroStone1+heroStone2+heroStone3+heroStone4+heroStone5+heroStone6)*1",  ["clientPrecondition"] = "1",  ["id"] = 129,  ["clientFormula"] = "result=(heroStone)*1",  ["key"] = "guide2004",}
,  [130] = {
  ["precondition"] = "1",  ["formula"] = "(heroSeal1+heroSeal2+heroSeal3+heroSeal4+heroSeal5+heroSeal6)*10",  ["clientPrecondition"] = "1",  ["id"] = 130,  ["clientFormula"] = "result=(heroSeal)*10",  ["key"] = "guide2005",}
,  [131] = {
  ["precondition"] = "1",  ["formula"] = "cheerNum*10",  ["clientPrecondition"] = "1",  ["id"] = 131,  ["clientFormula"] = "result=cheerNum*10",  ["key"] = "guide2006",}
,  [132] = {
  ["precondition"] = "1",  ["formula"] = "EquNum*10",  ["clientPrecondition"] = "1",  ["id"] = 132,  ["clientFormula"] = "result=EquNum*10",  ["key"] = "guide2007",}
,  [133] = {
  ["precondition"] = "1",  ["formula"] = "EquNum*10",  ["clientPrecondition"] = "1",  ["id"] = 133,  ["clientFormula"] = "result=EquNum*10",  ["key"] = "guide2008",}
,  [134] = {
  ["precondition"] = "1",  ["formula"] = "warriorLevel*100",  ["clientPrecondition"] = "1",  ["id"] = 134,  ["clientFormula"] = "result=warriorLevel*100",  ["key"] = "guide2009",}
,  [135] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 135,  ["clientFormula"] = "result=1",  ["key"] = "hjqyDamage",}
,  [136] = {
  ["precondition"] = "EquNumMax > EquNumMin",  ["formula"] = "grow*0.2+(EquNumRandom-EquNumMin)*1.0/(EquNumMax-EquNumMin)*1*grow*0.8",  ["clientPrecondition"] = "EquNumMax > EquNumMin",  ["id"] = 136,  ["clientFormula"] = "result=grow*0.2+(EquNumRandom-EquNumMin)*1.0/(EquNumMax-EquNumMin)*1*grow*0.8",  ["key"] = "equGrowUpParameter",}
,  [137] = {
  ["precondition"] = "EquNumMax == EquNumMin",  ["formula"] = "grow*1",  ["clientPrecondition"] = "EquNumMax == EquNumMin",  ["id"] = 137,  ["clientFormula"] = "result=grow*1",  ["key"] = "equGrowUpParameter2",}
,  [138] = {
  ["precondition"] = "1",  ["formula"] = "damage_percent*currency",  ["clientPrecondition"] = "1",  ["id"] = 138,  ["clientFormula"] = "result=damage_percent*currency",  ["key"] = "Activitycurrency",}
,  [139] = {
  ["precondition"] = "1",  ["formula"] = "damage_percent*ExpDrop",  ["clientPrecondition"] = "1",  ["id"] = 139,  ["clientFormula"] = "result=damage_percent*ExpDrop",  ["key"] = "ActivityExpDrop",}
,  [140] = {
  ["precondition"] = "1",  ["formula"] = "ActivityExpDrop/100",  ["clientPrecondition"] = "1",  ["id"] = 140,  ["clientFormula"] = "result=ActivityExpDrop/100",  ["key"] = "ActivityExpDropConvert_1",}
,  [141] = {
  ["precondition"] = "1",  ["formula"] = "ActivityExpDrop/500",  ["clientPrecondition"] = "1",  ["id"] = 141,  ["clientFormula"] = "result=ActivityExpDrop/500",  ["key"] = "ActivityExpDropConvert_2",}
,  [142] = {
  ["precondition"] = "1",  ["formula"] = "ActivityExpDrop/1000",  ["clientPrecondition"] = "1",  ["id"] = 142,  ["clientFormula"] = "result=ActivityExpDrop/1000",  ["key"] = "ActivityExpDropConvert_3",}
,  [143] = {
  ["precondition"] = "skill_buff.effectId == 30",  ["formula"] = "(6*wslevel*wslevel+700)*skill_buff.valueEffect/job",  ["clientPrecondition"] = "1",  ["id"] = 143,  ["clientFormula"] = "result=(6*wslevel*wslevel+700)*skill_buff.valueEffect/job",  ["key"] = "peerlessDamage",}
,  [144] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.hp*parameters",  ["clientPrecondition"] = "1",  ["id"] = 144,  ["clientFormula"] = "result=hero_info.hp*parameters",  ["key"] = "hero_Breakthrough.hp",}
,  [145] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.atk*parameters",  ["clientPrecondition"] = "1",  ["id"] = 145,  ["clientFormula"] = "result=hero_info.atk*parameters",  ["key"] = "hero_Breakthrough.atk",}
,  [146] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.physicalDef*parameters",  ["clientPrecondition"] = "1",  ["id"] = 146,  ["clientFormula"] = "result=hero_info.physicalDef*parameters",  ["key"] = "hero_Breakthrough.physicalDef",}
,  [147] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.magicDef*parameters",  ["clientPrecondition"] = "1",  ["id"] = 147,  ["clientFormula"] = "result=hero_info.magicDef*parameters",  ["key"] = "hero_Breakthrough.magicDef",}
,  [148] = {
  ["precondition"] = "1",  ["formula"] = "peoplePercentage*(1-robbedPercentage)",  ["clientPrecondition"] = "1",  ["id"] = 148,  ["clientFormula"] = "result=peoplePercentage*(1-robbedPercentage)",  ["key"] = "EscortReward",}
,  [149] = {
  ["precondition"] = "1",  ["formula"] = "peoplePercentage*robbedPercentage",  ["clientPrecondition"] = "1",  ["id"] = 149,  ["clientFormula"] = "result=peoplePercentage*robbedPercentage",  ["key"] = "SnatchReward",}
,  [150] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone",  ["clientPrecondition"] = "1",  ["id"] = 150,  ["clientFormula"] = "result=hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone",  ["key"] = "hpHero",}
,  [151] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone",  ["clientPrecondition"] = "1",  ["id"] = 151,  ["clientFormula"] = "result=hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone",  ["key"] = "atkHero",}
,  [152] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone",  ["clientPrecondition"] = "1",  ["id"] = 152,  ["clientFormula"] = "result=hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone",  ["key"] = "physicalDefHero",}
,  [153] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone",  ["clientPrecondition"] = "1",  ["id"] = 153,  ["clientFormula"] = "result=hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone",  ["key"] = "magicDefHero",}
,  [154] = {
  ["precondition"] = "1",  ["formula"] = "hpHero/6+atkHero/3+(physicalDefHero+magicDefHero)/2",  ["clientPrecondition"] = "1",  ["id"] = 154,  ["clientFormula"] = "result=self_attr.hpHero/6+self_attr.atkHero/3+(self_attr.physicalDefHero+self_attr.magicDefHero)/2",  ["key"] = "fightValueHero",}
,  [155] = {
  ["precondition"] = "1",  ["formula"] = "hpHero+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["clientPrecondition"] = "1",  ["id"] = 155,  ["clientFormula"] = "result=hpHero+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["key"] = "hpArray",}
,  [156] = {
  ["precondition"] = "1",  ["formula"] = "atkHero+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["clientPrecondition"] = "1",  ["id"] = 156,  ["clientFormula"] = "result=atkHero+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["key"] = "atkArray",}
,  [157] = {
  ["precondition"] = "1",  ["formula"] = "physicalDefHero+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["clientPrecondition"] = "1",  ["id"] = 157,  ["clientFormula"] = "result=physicalDefHero+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["key"] = "physicalDefArray",}
,  [158] = {
  ["precondition"] = "1",  ["formula"] = "magicDefHero+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["clientPrecondition"] = "1",  ["id"] = 158,  ["clientFormula"] = "result=magicDefHero+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["key"] = "magicDefArray",}
,  [159] = {
  ["precondition"] = "1",  ["formula"] = "hpArray/6+atkArray/3+(physicalDefArray+magicDefArray)/2+hitArray-hero_info.hit+dodgeArray-hero_info.dodge+criArray-hero_info.cri+criCoeffArray-hero_info.criCoeff+criDedCoeffArray-hero_info.criDedCoeff+blockArray*2-2*hero_info.block+ductilityArray-hero_info.ductility",  ["clientPrecondition"] = "1",  ["id"] = 159,  ["clientFormula"] = "result=lineup_attr.hpArray/6+lineup_attr.atkArray/3+(lineup_attr.physicalDefArray+lineup_attr.magicDefArray)/2+lineup_attr.hitArray-hero_info.hit+lineup_attr.dodgeArray-hero_info.dodge+lineup_attr.criArray-hero_info.cri+lineup_attr.criCoeffArray-hero_info.criCoeff+lineup_attr.criDedCoeffArray-hero_info.criDedCoeff+lineup_attr.blockArray*2-2*hero_info.block+lineup_attr.ductilityArray-hero_info.ductility",  ["key"] = "fightValueArray",}
,  [160] = {
  ["precondition"] = "1",  ["formula"] = "fightValueArray1+fightValueArray2+fightValueArray3+fightValueArray4+fightValueArray5+fightValueArray6",  ["clientPrecondition"] = "1",  ["id"] = 160,  ["clientFormula"] = "result=fightValueArray1+fightValueArray2+fightValueArray3+fightValueArray4+fightValueArray5+fightValueArray6",  ["key"] = "fightValuePlayer",}
,  [161] = {
  ["precondition"] = "1",  ["formula"] = "hpHero*hpEquValue",  ["clientPrecondition"] = "1",  ["id"] = 161,  ["clientFormula"] = "result=hpHero*hpEquValue",  ["key"] = "hpEqu_1",}
,  [162] = {
  ["precondition"] = "1",  ["formula"] = "atkHero*atkEquValue",  ["clientPrecondition"] = "1",  ["id"] = 162,  ["clientFormula"] = "result=atkHero*atkEquValue",  ["key"] = "atkEqu_1",}
,  [163] = {
  ["precondition"] = "1",  ["formula"] = "physicalDefHero*physicalDefEquValue",  ["clientPrecondition"] = "1",  ["id"] = 163,  ["clientFormula"] = "result=physicalDefHero*physicalDefEquValue",  ["key"] = "physicalDefEqu_1",}
,  [164] = {
  ["precondition"] = "1",  ["formula"] = "magicDefHero*magicDefEquValue",  ["clientPrecondition"] = "1",  ["id"] = 164,  ["clientFormula"] = "result=magicDefHero*magicDefEquValue",  ["key"] = "magicDefEqu_1",}
,  [165] = {
  ["precondition"] = "1",  ["formula"] = "hitHero*hitEquValue",  ["clientPrecondition"] = "1",  ["id"] = 165,  ["clientFormula"] = "result=hitHero*hitEquValue",  ["key"] = "hitEqu_1",}
,  [166] = {
  ["precondition"] = "1",  ["formula"] = "dodgeHero*dodgeEquValue",  ["clientPrecondition"] = "1",  ["id"] = 166,  ["clientFormula"] = "result=dodgeHero*dodgeEquValue",  ["key"] = "dodgeEqu_1",}
,  [167] = {
  ["precondition"] = "1",  ["formula"] = "criHero*criEquValue",  ["clientPrecondition"] = "1",  ["id"] = 167,  ["clientFormula"] = "result=criHero*criEquValue",  ["key"] = "criEqu_1",}
,  [168] = {
  ["precondition"] = "1",  ["formula"] = "criCoeffHero*criCoeffEquValue",  ["clientPrecondition"] = "1",  ["id"] = 168,  ["clientFormula"] = "result=criCoeffHero*criCoeffEquValue",  ["key"] = "criCoeffEqu_1",}
,  [169] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeffHero*criDedCoeffEquValue",  ["clientPrecondition"] = "1",  ["id"] = 169,  ["clientFormula"] = "result=criDedCoeffHero*criDedCoeffEquValue",  ["key"] = "criDedCoeffEqu_1",}
,  [170] = {
  ["precondition"] = "1",  ["formula"] = "blockHero*blockEquValue",  ["clientPrecondition"] = "1",  ["id"] = 170,  ["clientFormula"] = "result=blockHero*blockEquValue",  ["key"] = "blockEqu_1",}
,  [171] = {
  ["precondition"] = "1",  ["formula"] = "ductilityHero*ductilityEquValue",  ["clientPrecondition"] = "1",  ["id"] = 171,  ["clientFormula"] = "result=ductilityHero*ductilityEquValue",  ["key"] = "ductilityEqu_1",}
,  [172] = {
  ["precondition"] = "1",  ["formula"] = "(hpHero4*0.2+hpHero5*0.1+hpHero6*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 172,  ["clientFormula"] = "result=(hpHero4*0.2+hpHero5*0.1+hpHero6*0.1)/person",  ["key"] = "hpCheer",}
,  [173] = {
  ["precondition"] = "1",  ["formula"] = "atkHero1*0.2/person",  ["clientPrecondition"] = "1",  ["id"] = 173,  ["clientFormula"] = "result=atkHero1*0.2/person",  ["key"] = "atkCheer",}
,  [174] = {
  ["precondition"] = "1",  ["formula"] = "(physicalDefHero2*0.1+physicalDefHero5*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 174,  ["clientFormula"] = "result=(physicalDefHero2*0.1+physicalDefHero5*0.1)/person",  ["key"] = "physicalDefCheer",}
,  [175] = {
  ["precondition"] = "1",  ["formula"] = "(magicDefHero3*0.1+magicDefHero6*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 175,  ["clientFormula"] = "result=(magicDefHero3*0.1+magicDefHero6*0.1)/person",  ["key"] = "magicDefCheer",}
,  [176] = {
  ["precondition"] = "expHero >= 100 and expHero < 2000",  ["formula"] = "expHero/100",  ["clientPrecondition"] = "expHero >= 100 and expHero < 2000",  ["id"] = 176,  ["clientFormula"] = "result=expHero/100",  ["key"] = "sacrificeExp_1",}
,  [177] = {
  ["precondition"] = "expHero >= 2000 and expHero < 10000",  ["formula"] = "expHero/500",  ["clientPrecondition"] = "expHero >= 2000 and expHero < 10000",  ["id"] = 177,  ["clientFormula"] = "result=expHero/500",  ["key"] = "sacrificeExp_2",}
,  [178] = {
  ["precondition"] = "expHero >= 10000",  ["formula"] = "expHero/1000",  ["clientPrecondition"] = "expHero >= 10000",  ["id"] = 178,  ["clientFormula"] = "result=expHero/1000",  ["key"] = "sacrificeExp_3",}
,  [179] = {
  ["precondition"] = "1",  ["formula"] = "\"10000\"",  ["clientPrecondition"] = "1",  ["id"] = 179,  ["clientFormula"] = "result=10000",  ["key"] = "coinWorldboss",}
,  [180] = {
  ["precondition"] = "1",  ["formula"] = "\"10\"",  ["clientPrecondition"] = "1",  ["id"] = 180,  ["clientFormula"] = "result=10",  ["key"] = "soulWorldboss",}
,  [181] = {
  ["precondition"] = "1",  ["formula"] = "10000/rank+playerLevel*10",  ["clientPrecondition"] = "1",  ["id"] = 181,  ["clientFormula"] = "result=10000/rank+playerLevel*10",  ["key"] = "coinArenaSuccess",}
,  [182] = {
  ["precondition"] = "1",  ["formula"] = "10000/rank+playerLevel*8",  ["clientPrecondition"] = "1",  ["id"] = 182,  ["clientFormula"] = "result=10000/rank+playerLevel*8",  ["key"] = "coinArenaFail",}
,  [183] = {
  ["precondition"] = "1",  ["formula"] = "playerLuckyValue/50000",  ["clientPrecondition"] = "1",  ["id"] = 183,  ["clientFormula"] = "result=playerLuckyValue/50000",  ["key"] = "shopLuckyValue",}
,  [184] = {
  ["precondition"] = "1",  ["formula"] = "damage if damage<=10000 else 10000+damage/10",  ["clientPrecondition"] = "1",  ["id"] = 184,  ["clientFormula"] = "result=(damage <= 10000 and damage) or 10000+damage/10",  ["key"] = "coinWarFogboss",}
,  [185] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 185,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,2190)].name_1",  ["key"] = "rand_name_1",}
,  [186] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 186,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,4063)].name_2",  ["key"] = "rand_name_2",}
,  [187] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 187,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,116)].name_3",  ["key"] = "rand_name_3",}
,  [188] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 188,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,96)].name_4",  ["key"] = "rand_name_4",}
,  [189] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 189,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,96)].name_4 .. rand_name_config[math.random(1,116)].name_3",  ["key"] = "rand_name_5",}
,  [190] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 190,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,96)].name_4 .. rand_name_config[math.random(1,96)].name_4",  ["key"] = "rand_name_6",}
,  [191] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 191,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,116)].name_3 .. rand_name_config[math.random(1,96)].name_4",  ["key"] = "rand_name_7",}
,  [192] = {
  ["precondition"] = "1",  ["formula"] = "1",  ["clientPrecondition"] = "1",  ["id"] = 192,  ["clientFormula"] = "result=rand_name_config[math.random(1,496)].prefix_1 .. rand_name_config[math.random(1,116)].name_3 .. rand_name_config[math.random(1,116)].name_3",  ["key"] = "rand_name_8",}
,}
