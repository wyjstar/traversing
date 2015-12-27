formula_config={
  [1] = {
  ["precondition"] = "1",  ["formula"] = "monster_info.hp/10+monster_info.atk*0.2+(monster_info.physicalDef+monster_info.magicDef)*0.4+(monster_info.hit+monster_info.dodge+monster_info.cri+monster_info.criCoeff+monster_info.criDedCoeff+monster_info.block+monster_info.ductility)*5-14500",  ["clientPrecondition"] = "1",  ["id"] = 1,  ["clientFormula"] = "result=monster_info.hp/10+monster_info.atk*0.2+(monster_info.physicalDef+monster_info.magicDef)*0.4+(monster_info.hit+monster_info.dodge+monster_info.cri+monster_info.criCoeff+monster_info.criDedCoeff+monster_info.block+monster_info.ductility)*5-14500",  ["key"] = "fightValue",}
,  [2] = {
  ["precondition"] = "1",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone)*(1+awake_percent)",  ["clientPrecondition"] = "1",  ["id"] = 2,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone)*(1+awake_percent)",  ["key"] = "hpHero",}
,  [3] = {
  ["precondition"] = "1",  ["formula"] = "(hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone)*(1+awake_percent)",  ["clientPrecondition"] = "1",  ["id"] = 3,  ["clientFormula"] = "result=(hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone)*(1+awake_percent)",  ["key"] = "atkHero",}
,  [4] = {
  ["precondition"] = "1",  ["formula"] = "(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone)*(1+awake_percent)",  ["clientPrecondition"] = "1",  ["id"] = 4,  ["clientFormula"] = "result=(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone)*(1+awake_percent)",  ["key"] = "physicalDefHero",}
,  [5] = {
  ["precondition"] = "1",  ["formula"] = "(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone)*(1+awake_percent)",  ["clientPrecondition"] = "1",  ["id"] = 5,  ["clientFormula"] = "result=(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone)*(1+awake_percent)",  ["key"] = "magicDefHero",}
,  [6] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.hit+hitB+hitSeal+hitStone",  ["clientPrecondition"] = "1",  ["id"] = 6,  ["clientFormula"] = "result=hero_info.hit+hitB+hitSeal+hitStone",  ["key"] = "hitHero",}
,  [7] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.dodge+dodgeB+dodgeSeal+dodgeStone",  ["clientPrecondition"] = "1",  ["id"] = 7,  ["clientFormula"] = "result=hero_info.dodge+dodgeB+dodgeSeal+dodgeStone",  ["key"] = "dodgeHero",}
,  [8] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.cri+criB+criSeal+criStone",  ["clientPrecondition"] = "1",  ["id"] = 8,  ["clientFormula"] = "result=hero_info.cri+criB+criSeal+criStone",  ["key"] = "criHero",}
,  [9] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone",  ["clientPrecondition"] = "1",  ["id"] = 9,  ["clientFormula"] = "result=hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone",  ["key"] = "criCoeffHero",}
,  [10] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone",  ["clientPrecondition"] = "1",  ["id"] = 10,  ["clientFormula"] = "result=hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone",  ["key"] = "criDedCoeffHero",}
,  [11] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.block+blockB+blockSeal+blockStone",  ["clientPrecondition"] = "1",  ["id"] = 11,  ["clientFormula"] = "result=hero_info.block+blockB+blockSeal+blockStone",  ["key"] = "blockHero",}
,  [12] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.ductility+ductilityB+ductilitySeal+ductilityStone",  ["clientPrecondition"] = "1",  ["id"] = 12,  ["clientFormula"] = "result=hero_info.ductility+ductilityB+ductilitySeal+ductilityStone",  ["key"] = "ductilityHero",}
,  [13] = {
  ["precondition"] = "1",  ["formula"] = "hpHero/10+atkHero*0.2+(physicalDefHero+magicDefHero)*0.4+(hitHero+dodgeHero+criHero+criCoeffHero+criDedCoeffHero+blockHero+ductilityHero)*5-14500",  ["clientPrecondition"] = "1",  ["id"] = 13,  ["clientFormula"] = "result=self_attr.hpHero*0.1+self_attr.atkHero*0.2+(self_attr.physicalDefHero+self_attr.magicDefHero)*0.4+(self_attr.hitHero+self_attr.dodgeHero+self_attr.criHero+self_attr.criCoeffHero+self_attr.criDedCoeffHero+self_attr.blockHero+self_attr.ductilityHero)*5-14500",  ["key"] = "fightValueHero",}
,  [14] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 14,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hpB_1",}
,  [15] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 15,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "hpB_2",}
,  [16] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 16,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "atkB_1",}
,  [17] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.atk+hero_info.growAtk*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 17,  ["clientFormula"] = "result=(hero_info.atk+hero_info.growAtk*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "atkB_2",}
,  [18] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 18,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "pDefB_1",}
,  [19] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 19,  ["clientFormula"] = "result=(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "pDefB_2",}
,  [20] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 20,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "mDefB_1",}
,  [21] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 21,  ["clientFormula"] = "result=(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "mDefB_2",}
,  [22] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 22,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hitB",}
,  [23] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 23,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "dodgeB",}
,  [24] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 24,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criB",}
,  [25] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 25,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criCoeffB",}
,  [26] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 26,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criDedCoeffB",}
,  [27] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 27,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "blockB",}
,  [28] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 28,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "ductilityB",}
,  [29] = {
  ["precondition"] = "1",  ["formula"] = "hpHero+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["clientPrecondition"] = "1",  ["id"] = 29,  ["clientFormula"] = "result=hpHero+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["key"] = "hpArray",}
,  [30] = {
  ["precondition"] = "1",  ["formula"] = "atkHero+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["clientPrecondition"] = "1",  ["id"] = 30,  ["clientFormula"] = "result=atkHero+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["key"] = "atkArray",}
,  [31] = {
  ["precondition"] = "1",  ["formula"] = "physicalDefHero+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["clientPrecondition"] = "1",  ["id"] = 31,  ["clientFormula"] = "result=physicalDefHero+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["key"] = "physicalDefArray",}
,  [32] = {
  ["precondition"] = "1",  ["formula"] = "magicDefHero+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["clientPrecondition"] = "1",  ["id"] = 32,  ["clientFormula"] = "result=magicDefHero+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["key"] = "magicDefArray",}
,  [33] = {
  ["precondition"] = "1",  ["formula"] = "hitHero+hitEqu+hitSetEqu+hitlink",  ["clientPrecondition"] = "1",  ["id"] = 33,  ["clientFormula"] = "result=hitHero+hitEqu+hitSetEqu+hitlink",  ["key"] = "hitArray",}
,  [34] = {
  ["precondition"] = "1",  ["formula"] = "dodgeHero+dodgeEqu+dodgeSetEqu+dodgelink",  ["clientPrecondition"] = "1",  ["id"] = 34,  ["clientFormula"] = "result=dodgeHero+dodgeEqu+dodgeSetEqu+dodgelink",  ["key"] = "dodgeArray",}
,  [35] = {
  ["precondition"] = "1",  ["formula"] = "criHero+criEqu+criSetEqu+crilink",  ["clientPrecondition"] = "1",  ["id"] = 35,  ["clientFormula"] = "result=criHero+criEqu+criSetEqu+crilink",  ["key"] = "criArray",}
,  [36] = {
  ["precondition"] = "1",  ["formula"] = "criCoeffHero+criCoeffEqu+criCoeffSetEqu+criCoefflink",  ["clientPrecondition"] = "1",  ["id"] = 36,  ["clientFormula"] = "result=criCoeffHero+criCoeffEqu+criCoeffSetEqu+criCoefflink",  ["key"] = "criCoeffArray",}
,  [37] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeffHero+criDedCoeffEqu+criDedCoeffSetEqu+criDedCoefflink",  ["clientPrecondition"] = "1",  ["id"] = 37,  ["clientFormula"] = "result=criDedCoeffHero+criDedCoeffEqu+criDedCoeffSetEqu+criDedCoefflink",  ["key"] = "criDedCoeffArray",}
,  [38] = {
  ["precondition"] = "1",  ["formula"] = "blockHero+blockEqu+blockSetEqu+blocklink",  ["clientPrecondition"] = "1",  ["id"] = 38,  ["clientFormula"] = "result=blockHero+blockEqu+blockSetEqu+blocklink",  ["key"] = "blockArray",}
,  [39] = {
  ["precondition"] = "1",  ["formula"] = "ductilityHero+ductilityEqu+ductilitySetEqu+ductilitylink",  ["clientPrecondition"] = "1",  ["id"] = 39,  ["clientFormula"] = "result=ductilityHero+ductilityEqu+ductilitySetEqu+ductilitylink",  ["key"] = "ductilityArray",}
,  [40] = {
  ["precondition"] = "1",  ["formula"] = "hpArray*0.1+atkArray*0.2+(physicalDefArray+magicDefArray)*0.4+(hitArray+dodgeArray+criArray+criCoeffArray+criDedCoeffArray+blockArray+ductilityArray)*5-14500",  ["clientPrecondition"] = "1",  ["id"] = 40,  ["clientFormula"] = "result=lineup_attr.hpArray*0.1+lineup_attr.atkArray*0.2+(lineup_attr.physicalDefArray+lineup_attr.magicDefArray)*0.4+(lineup_attr.hitArray+lineup_attr.dodgeArray+lineup_attr.criArray+lineup_attr.criCoeffArray+lineup_attr.criDedCoeffArray+lineup_attr.blockArray+lineup_attr.ductilityArray)*5-14500",  ["key"] = "fightValueArray",}
,  [41] = {
  ["precondition"] = "1",  ["formula"] = "fightValueArray1+fightValueArray2+fightValueArray3+fightValueArray4+fightValueArray5+fightValueArray6",  ["clientPrecondition"] = "1",  ["id"] = 41,  ["clientFormula"] = "result=fightValueArray1+fightValueArray2+fightValueArray3+fightValueArray4+fightValueArray5+fightValueArray6",  ["key"] = "fightValuePlayer",}
,  [42] = {
  ["precondition"] = "1",  ["formula"] = "hpHero*hpEquValue",  ["clientPrecondition"] = "1",  ["id"] = 42,  ["clientFormula"] = "",  ["key"] = "hpEqu_1",}
,  [43] = {
  ["precondition"] = "1",  ["formula"] = "atkHero*atkEquValue",  ["clientPrecondition"] = "1",  ["id"] = 43,  ["clientFormula"] = "",  ["key"] = "atkEqu_1",}
,  [44] = {
  ["precondition"] = "1",  ["formula"] = "physicalDefHero*physicalDefEquValue",  ["clientPrecondition"] = "1",  ["id"] = 44,  ["clientFormula"] = "",  ["key"] = "physicalDefEqu_1",}
,  [45] = {
  ["precondition"] = "1",  ["formula"] = "magicDefHero*magicDefEquValue",  ["clientPrecondition"] = "1",  ["id"] = 45,  ["clientFormula"] = "",  ["key"] = "magicDefEqu_1",}
,  [46] = {
  ["precondition"] = "1",  ["formula"] = "hitHero*hitEquValue",  ["clientPrecondition"] = "1",  ["id"] = 46,  ["clientFormula"] = "",  ["key"] = "hitEqu_1",}
,  [47] = {
  ["precondition"] = "1",  ["formula"] = "dodgeHero*dodgeEquValue",  ["clientPrecondition"] = "1",  ["id"] = 47,  ["clientFormula"] = "",  ["key"] = "dodgeEqu_1",}
,  [48] = {
  ["precondition"] = "1",  ["formula"] = "criHero*criEquValue",  ["clientPrecondition"] = "1",  ["id"] = 48,  ["clientFormula"] = "",  ["key"] = "criEqu_1",}
,  [49] = {
  ["precondition"] = "1",  ["formula"] = "criCoeffHero*criCoeffEquValue",  ["clientPrecondition"] = "1",  ["id"] = 49,  ["clientFormula"] = "",  ["key"] = "criCoeffEqu_1",}
,  [50] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeffHero*criDedCoeffEquValue",  ["clientPrecondition"] = "1",  ["id"] = 50,  ["clientFormula"] = "",  ["key"] = "criDedCoeffEqu_1",}
,  [51] = {
  ["precondition"] = "1",  ["formula"] = "blockHero*blockEquValue",  ["clientPrecondition"] = "1",  ["id"] = 51,  ["clientFormula"] = "",  ["key"] = "blockEqu_1",}
,  [52] = {
  ["precondition"] = "1",  ["formula"] = "ductilityHero*ductilityEquValue",  ["clientPrecondition"] = "1",  ["id"] = 52,  ["clientFormula"] = "",  ["key"] = "ductilityEqu_1",}
,  [53] = {
  ["precondition"] = "1",  ["formula"] = "baseHp+growHp*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 53,  ["clientFormula"] = "result=baseHp+growHp*(equLevel-1)",  ["key"] = "hpEqu",}
,  [54] = {
  ["precondition"] = "1",  ["formula"] = "baseAtk+growAtk*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 54,  ["clientFormula"] = "result=baseAtk+growAtk*(equLevel-1)",  ["key"] = "atkEqu",}
,  [55] = {
  ["precondition"] = "1",  ["formula"] = "basePdef+growPdef*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 55,  ["clientFormula"] = "result=basePdef+growPdef*(equLevel-1)",  ["key"] = "physicalDefEqu",}
,  [56] = {
  ["precondition"] = "1",  ["formula"] = "baseMdef+growMdef*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 56,  ["clientFormula"] = "result=baseMdef+growMdef*(equLevel-1)",  ["key"] = "magicDefEqu",}
,  [57] = {
  ["precondition"] = "1",  ["formula"] = "hit+growHit*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 57,  ["clientFormula"] = "result=hit+growHit*(equLevel-1)",  ["key"] = "hitEqu",}
,  [58] = {
  ["precondition"] = "1",  ["formula"] = "dodge+growDodge*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 58,  ["clientFormula"] = "result=dodge+growDodge*(equLevel-1)",  ["key"] = "dodgeEqu",}
,  [59] = {
  ["precondition"] = "1",  ["formula"] = "cri+growCri*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 59,  ["clientFormula"] = "result=cri+growCri*(equLevel-1)",  ["key"] = "criEqu",}
,  [60] = {
  ["precondition"] = "1",  ["formula"] = "criCoeff+growCriCoeff*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 60,  ["clientFormula"] = "result=criCoeff+growCriCoeff*(equLevel-1)",  ["key"] = "criCoeffEqu",}
,  [61] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeff+growCriDedCoeff*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 61,  ["clientFormula"] = "result=criDedCoeff+growCriDedCoeff*(equLevel-1)",  ["key"] = "criDedCoeffEqu",}
,  [62] = {
  ["precondition"] = "1",  ["formula"] = "block+growBlock*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 62,  ["clientFormula"] = "result=block+growBlock*(equLevel-1)",  ["key"] = "blockEqu",}
,  [63] = {
  ["precondition"] = "1",  ["formula"] = "ductility+growDuctility*(equLevel-1)",  ["clientPrecondition"] = "1",  ["id"] = 63,  ["clientFormula"] = "result=ductility+growDuctility*(equLevel-1)",  ["key"] = "ductilityEqu",}
,  [64] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 64,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hpSetEqu_1",}
,  [65] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 65,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "hpSetEqu_2",}
,  [66] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 66,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "atkSetEqu_1",}
,  [67] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 67,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "atkSetEqu_2",}
,  [68] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 68,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "physicalDefSetEqu_1",}
,  [69] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 69,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "physicalDefSetEqu_2",}
,  [70] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 70,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "magicDefSetEqu_1",}
,  [71] = {
  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 71,  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["key"] = "magicDefSetEqu_2",}
,  [72] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 72,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "hitSetEqu",}
,  [73] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 73,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "dodgeSetEqu",}
,  [74] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 74,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criSetEqu",}
,  [75] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 75,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criCoeffSetEqu",}
,  [76] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 76,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "criDedCoeffSetEqu",}
,  [77] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 77,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "blockSetEqu",}
,  [78] = {
  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",  ["id"] = 78,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "ductilitySetEqu",}
,  [79] = {
  ["precondition"] = "1",  ["formula"] = "hpB_1",  ["clientPrecondition"] = "1",  ["id"] = 79,  ["clientFormula"] = "hpB_1",  ["key"] = "hplink",}
,  [80] = {
  ["precondition"] = "1",  ["formula"] = "hpB_2",  ["clientPrecondition"] = "1",  ["id"] = 80,  ["clientFormula"] = "hpB_2",  ["key"] = "hplink",}
,  [81] = {
  ["precondition"] = "1",  ["formula"] = "atkB_1",  ["clientPrecondition"] = "1",  ["id"] = 81,  ["clientFormula"] = "atkB_1",  ["key"] = "atklink_1",}
,  [82] = {
  ["precondition"] = "1",  ["formula"] = "atkB_2",  ["clientPrecondition"] = "1",  ["id"] = 82,  ["clientFormula"] = "atkB_2",  ["key"] = "atklink_2",}
,  [83] = {
  ["precondition"] = "1",  ["formula"] = "pDefB_1",  ["clientPrecondition"] = "1",  ["id"] = 83,  ["clientFormula"] = "pDefB_1",  ["key"] = "physicalDeflink",}
,  [84] = {
  ["precondition"] = "1",  ["formula"] = "pDefB_2",  ["clientPrecondition"] = "1",  ["id"] = 84,  ["clientFormula"] = "pDefB_2",  ["key"] = "physicalDeflink",}
,  [85] = {
  ["precondition"] = "1",  ["formula"] = "mDefB_1",  ["clientPrecondition"] = "1",  ["id"] = 85,  ["clientFormula"] = "mDefB_1",  ["key"] = "magicDeflink",}
,  [86] = {
  ["precondition"] = "1",  ["formula"] = "mDefB_2",  ["clientPrecondition"] = "1",  ["id"] = 86,  ["clientFormula"] = "mDefB_2",  ["key"] = "magicDeflink",}
,  [87] = {
  ["precondition"] = "1",  ["formula"] = "hitB",  ["clientPrecondition"] = "1",  ["id"] = 87,  ["clientFormula"] = "hitB",  ["key"] = "hitlink",}
,  [88] = {
  ["precondition"] = "1",  ["formula"] = "dodgeB",  ["clientPrecondition"] = "1",  ["id"] = 88,  ["clientFormula"] = "dodgeB",  ["key"] = "dodgelink",}
,  [89] = {
  ["precondition"] = "1",  ["formula"] = "criB",  ["clientPrecondition"] = "1",  ["id"] = 89,  ["clientFormula"] = "criB",  ["key"] = "crilink",}
,  [90] = {
  ["precondition"] = "1",  ["formula"] = "criCoeffB",  ["clientPrecondition"] = "1",  ["id"] = 90,  ["clientFormula"] = "criCoeffB",  ["key"] = "criCoefflink",}
,  [91] = {
  ["precondition"] = "1",  ["formula"] = "criDedCoeffB",  ["clientPrecondition"] = "1",  ["id"] = 91,  ["clientFormula"] = "criDedCoeffB",  ["key"] = "criDedCoefflink",}
,  [92] = {
  ["precondition"] = "1",  ["formula"] = "blockB",  ["clientPrecondition"] = "1",  ["id"] = 92,  ["clientFormula"] = "blockB",  ["key"] = "blocklink",}
,  [93] = {
  ["precondition"] = "1",  ["formula"] = "ductilityB",  ["clientPrecondition"] = "1",  ["id"] = 93,  ["clientFormula"] = "ductilityB",  ["key"] = "ductilitylink",}
,  [94] = {
  ["precondition"] = "1",  ["formula"] = "(hpHero4*0.2+hpHero5*0.1+hpHero6*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 94,  ["clientFormula"] = "result=(hpHero4*0.2+hpHero5*0.1+hpHero6*0.1)/person",  ["key"] = "hpCheer",}
,  [95] = {
  ["precondition"] = "1",  ["formula"] = "atkHero1*0.2/person",  ["clientPrecondition"] = "1",  ["id"] = 95,  ["clientFormula"] = "result=atkHero1*0.2/person",  ["key"] = "atkCheer",}
,  [96] = {
  ["precondition"] = "1",  ["formula"] = "(physicalDefHero2*0.1+physicalDefHero5*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 96,  ["clientFormula"] = "result=(physicalDefHero2*0.1+physicalDefHero5*0.1)/person",  ["key"] = "physicalDefCheer",}
,  [97] = {
  ["precondition"] = "1",  ["formula"] = "(magicDefHero3*0.1+magicDefHero6*0.1)/person",  ["clientPrecondition"] = "1",  ["id"] = 97,  ["clientFormula"] = "result=(magicDefHero3*0.1+magicDefHero6*0.1)/person",  ["key"] = "magicDefCheer",}
,  [98] = {
  ["precondition"] = "1",  ["formula"] = "1 if triggerRate>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 98,  ["clientFormula"] = "result=(triggerRate>random and 1) or 0",  ["key"] = "isTrigger",}
,  [99] = {
  ["precondition"] = "1",  ["formula"] = "1 if hitArray1/10-dodgeArray2/10>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 99,  ["clientFormula"] = "result=((hitArray1-dodgeArray2)/10>random and 1) or 0",  ["key"] = "isHit",}
,  [100] = {
  ["precondition"] = "1",  ["formula"] = "1 if criArray1/10-ductilityArray2/10>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 100,  ["clientFormula"] = "result=((criArray1-ductilityArray2)/10>random and 1) or 0",  ["key"] = "isCri",}
,  [101] = {
  ["precondition"] = "1",  ["formula"] = "1 if blockArray/10>random else 0",  ["clientPrecondition"] = "1",  ["id"] = 101,  ["clientFormula"] = "result=(blockArray/10>random and 1) or 0",  ["key"] = "isBlock",}
,  [102] = {
  ["precondition"] = "1",  ["formula"] = "atkArray-def2 if atkArray-def2 > heroLevel else heroLevel",  ["clientPrecondition"] = "1",  ["id"] = 102,  ["clientFormula"] = "result= (atkArray-def2 > heroLevel and atkArray-def2 ) or heroLevel",  ["key"] = "baseDamage",}
,  [103] = {
  ["precondition"] = "1",  ["formula"] = "(criCoeffArray1-criDedCoeffArray2)/1000",  ["clientPrecondition"] = "1",  ["id"] = 103,  ["clientFormula"] = "result=(criCoeffArray1-criDedCoeffArray2)/1000",  ["key"] = "criDamage",}
,  [104] = {
  ["precondition"] = "1",  ["formula"] = "1 if heroLevel1<heroLevel2+5 else 1",  ["clientPrecondition"] = "1",  ["id"] = 104,  ["clientFormula"] = "result=1",  ["key"] = "levelDamage",}
,  [105] = {
  ["precondition"] = "1",  ["formula"] = "k1+random*(k2-k1)/99",  ["clientPrecondition"] = "",  ["id"] = 105,  ["clientFormula"] = "result=k1+random*(k2-k1)/99",  ["key"] = "floatDamage",}
,  [106] = {
  ["precondition"] = "1",  ["formula"] = "baseDamage*(1 if isHit else 0)*(criDamage if isCri else 1)*(0.7 if isBlock else 1)*levelDamage*floatDamage",  ["clientPrecondition"] = "1",  ["id"] = 106,  ["clientFormula"] = "result=baseDamage*((isHit and 1) or 0)*((isCri and criDamage) or 1)*((isBlock and 0.7) or 1)*levelDamage*floatDamage",  ["key"] = "allDamage",}
,  [107] = {
  ["precondition"] = "1",  ["formula"] = "atkArray*(criCoeffArray/1000 if isCri else 1)",  ["clientPrecondition"] = "1",  ["id"] = 107,  ["clientFormula"] = "result=atkArray*((isCri and criCoeffArray/1000) or 1)",  ["key"] = "allHeal",}
,  [108] = {
  ["precondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType ==1",  ["formula"] = "allDamage+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType ==1",  ["id"] = 108,  ["clientFormula"] = "result=allDamage+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "damage_1",}
,  [109] = {
  ["precondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType == 2",  ["formula"] = "allDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType == 2",  ["id"] = 109,  ["clientFormula"] = "result=allDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["key"] = "damage_2",}
,  [110] = {
  ["precondition"] = "(skill_buff.effectId == 3 or skill_buff.effectId == 33 or skill_buff.effectId == 34 or skill_buff.effectId == 35) and skill_buff.valueType == 1",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "(skill_buff.effectId == 3 or skill_buff.effectId == 33 or skill_buff.effectId == 34 or skill_buff.effectId == 35) and skill_buff.valueType == 1",  ["id"] = 110,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "damage_3",}
,  [111] = {
  ["precondition"] = "(skill_buff.effectId == 3 or skill_buff.effectId == 33 or skill_buff.effectId == 34 or skill_buff.effectId == 35) and skill_buff.valueType == 2",  ["formula"] = "atkArray*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "(skill_buff.effectId == 3 or skill_buff.effectId == 33 or skill_buff.effectId == 34 or skill_buff.effectId == 35) and skill_buff.valueType == 2",  ["id"] = 111,  ["clientFormula"] = "result=atkArray*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["key"] = "damage_4",}
,  [112] = {
  ["precondition"] = "1",  ["formula"] = "(warriors_atkArray-enemy_physicalDefArray-enemy_magicDefArray)",  ["clientPrecondition"] = "",  ["id"] = 112,  ["clientFormula"] = "result=(warriors_atkArray-enemy_physicalDefArray-enemy_magicDefArray)",  ["key"] = "warriorsDamage",}
,  [113] = {
  ["precondition"] = "1",  ["formula"] = "warriorsBaseDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*playerLevel",  ["clientPrecondition"] = "",  ["id"] = 113,  ["clientFormula"] = "result=warriorsBaseDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*playerLevel",  ["key"] = "warriorsLastDamage",}
,  [114] = {
  ["precondition"] = "1",  ["formula"] = "atk*1.5",  ["clientPrecondition"] = "1",  ["id"] = 114,  ["clientFormula"] = "result=atk*1.5",  ["key"] = "monster_warriors_atkArray",}
,  [115] = {
  ["precondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 1",  ["formula"] = "allHeal+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 1",  ["id"] = 115,  ["clientFormula"] = "result=allHeal+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "heal_1",}
,  [116] = {
  ["precondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 2",  ["formula"] = "allHeal*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 2",  ["id"] = 116,  ["clientFormula"] = "result=allHeal*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["key"] = "heal_2",}
,  [117] = {
  ["precondition"] = "skill_buff.effectId >3 and skill_buff.effectId != 26 and skill_buff.valueType == 1",  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["clientPrecondition"] = "skill_buff.effectId >3 and skill_buff.effectId ~= 26 and skill_buff.valueType == 1",  ["id"] = 117,  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["key"] = "skillbuffEffct_1",}
,  [118] = {
  ["precondition"] = "skill_buff.effectId >3 and skill_buff.effectId != 26 and skill_buff.valueType == 2",  ["formula"] = "attrHero*skill_buff.valueEffect/100",  ["clientPrecondition"] = "skill_buff.effectId >3 and skill_buff.effectId ~= 26 and skill_buff.valueType == 2",  ["id"] = 118,  ["clientFormula"] = "result=attrHero*skill_buff.valueEffect/100",  ["key"] = "skillbuffEffct_2",}
,  [119] = {
  ["precondition"] = "expHero >= 50 and expHero < 100",  ["formula"] = "expHero/50",  ["clientPrecondition"] = "expHero >= 50 and expHero < 100",  ["id"] = 119,  ["clientFormula"] = "result=expHero/50",  ["key"] = "sacrificeExp_1",}
,  [120] = {
  ["precondition"] = "expHero >= 100 and expHero < 200",  ["formula"] = "expHero/100",  ["clientPrecondition"] = "expHero >= 100 and expHero < 200",  ["id"] = 120,  ["clientFormula"] = "result=expHero/100",  ["key"] = "sacrificeExp_2",}
,  [121] = {
  ["precondition"] = "expHero >= 200",  ["formula"] = "expHero/200",  ["clientPrecondition"] = "expHero >= 200",  ["id"] = 121,  ["clientFormula"] = "result=expHero/200",  ["key"] = "sacrificeExp_3",}
,  [122] = {
  ["precondition"] = "1",  ["formula"] = "\"10000\"",  ["clientPrecondition"] = "1",  ["id"] = 122,  ["clientFormula"] = "result=10000",  ["key"] = "coinWorldboss",}
,  [123] = {
  ["precondition"] = "1",  ["formula"] = "\"10\"",  ["clientPrecondition"] = "1",  ["id"] = 123,  ["clientFormula"] = "result=10",  ["key"] = "soulWorldboss",}
,  [124] = {
  ["precondition"] = "1",  ["formula"] = "10000/rank+playerLevel*10",  ["clientPrecondition"] = "1",  ["id"] = 124,  ["clientFormula"] = "result=10000/rank+playerLevel*10",  ["key"] = "coinArenaSuccess",}
,  [125] = {
  ["precondition"] = "1",  ["formula"] = "10000/rank+playerLevel*8",  ["clientPrecondition"] = "1",  ["id"] = 125,  ["clientFormula"] = "result=10000/rank+playerLevel*8",  ["key"] = "coinArenaFail",}
,  [126] = {
  ["precondition"] = "1",  ["formula"] = "playerLuckyValue/50000",  ["clientPrecondition"] = "1",  ["id"] = 126,  ["clientFormula"] = "result=playerLuckyValue/50000",  ["key"] = "shopLuckyValue",}
,  [127] = {
  ["precondition"] = "seatHero==1",  ["formula"] = "[1,2,3,4,5,6]",  ["clientPrecondition"] = "seatHero==1",  ["id"] = 127,  ["clientFormula"] = "result=[1,2,3,4,5,6]",  ["key"] = "defaultAttackSequence_1 ",}
,  [128] = {
  ["precondition"] = "seatHero==2",  ["formula"] = "[2,3,1,5,6,4]",  ["clientPrecondition"] = "seatHero==2",  ["id"] = 128,  ["clientFormula"] = "result=[2,3,1,5,6,4]",  ["key"] = "defaultAttackSequence_2",}
,  [129] = {
  ["precondition"] = "seatHero==3",  ["formula"] = "[3,1,2,6,4,5]",  ["clientPrecondition"] = "seatHero==3",  ["id"] = 129,  ["clientFormula"] = "result=[3,1,2,6,4,5]",  ["key"] = "defaultAttackSequence_3 ",}
,  [130] = {
  ["precondition"] = "seatHero==4",  ["formula"] = "[1,2,3,4,5,6]",  ["clientPrecondition"] = "seatHero==4",  ["id"] = 130,  ["clientFormula"] = "result=[1,2,3,4,5,6]",  ["key"] = "defaultAttackSequence_4",}
,  [131] = {
  ["precondition"] = "seatHero==5",  ["formula"] = "[2,3,1,5,6,4]",  ["clientPrecondition"] = "seatHero==5",  ["id"] = 131,  ["clientFormula"] = "result=[2,3,1,5,6,4]",  ["key"] = "defaultAttackSequence_5",}
,  [132] = {
  ["precondition"] = "seatHero==6",  ["formula"] = "[3,1,2,6,4,5]",  ["clientPrecondition"] = "seatHero==6",  ["id"] = 132,  ["clientFormula"] = "result=[3,1,2,6,4,5]",  ["key"] = "defaultAttackSequence_6",}
,  [133] = {
  ["precondition"] = "1",  ["formula"] = "hp*0.1+atk*0.2+(physicalDef+magicDef)*0.4+(hit+dodge+cri+criCoeff+criDedCoeff+block+ductility)*5",  ["clientPrecondition"] = "1",  ["id"] = 133,  ["clientFormula"] = "result=equ_attr.hp*0.1+equ_attr.atk*0.2+(equ_attr.physicalDef+equ_attr.magicDef)*0.4+(equ_attr.hit+equ_attr.dodge+equ_attr.cri+equ_attr.criCoeff+equ_attr.criDedCoeff+equ_attr.block+equ_attr.ductility)*5",  ["key"] = "equFightValue",}
,  [134] = {
  ["precondition"] = "1",  ["formula"] = "damage if damage<=10000 else 10000+damage/10",  ["clientPrecondition"] = "1",  ["id"] = 134,  ["clientFormula"] = "result=(damage <= 10000 and damage) or 10000+damage/10",  ["key"] = "coinWarFogboss",}
,  [135] = {
  ["precondition"] = "1",  ["formula"] = "1 if moonCardSurplusDay < 9999999 else 0",  ["clientPrecondition"] = "1",  ["id"] = 135,  ["clientFormula"] = "result=(moonCardSurplusDay < 4 and 1) or 0",  ["key"] = "moonCard",}
,  [136] = {
  ["precondition"] = "1",  ["formula"] = "1 if weekCardSurplusDay < 4 else 0",  ["clientPrecondition"] = "1",  ["id"] = 136,  ["clientFormula"] = "result=(weekCardSurplusDay < 3 and 1) or 0",  ["key"] = "weekCard",}
,  [137] = {
  ["precondition"] = "1",  ["formula"] = "upRank - highestRank",  ["clientPrecondition"] = "1",  ["id"] = 137,  ["clientFormula"] = "result=upRank - highestRank",  ["key"] = "arenaRankUpRewardsValue",}
,  [138] = {
  ["precondition"] = "1",  ["formula"] = "heroNum*10",  ["clientPrecondition"] = "1",  ["id"] = 138,  ["clientFormula"] = "result=heroNum*10",  ["key"] = "guide2001",}
,  [139] = {
  ["precondition"] = "1",  ["formula"] = "heroNum*10",  ["clientPrecondition"] = "1",  ["id"] = 139,  ["clientFormula"] = "result=heroNum*10",  ["key"] = "guide2002",}
,  [140] = {
  ["precondition"] = "1",  ["formula"] = "(heroBreak1+heroBreak2+heroBreak3+heroBreak4+heroBreak5+heroBreak6)*10",  ["clientPrecondition"] = "1",  ["id"] = 140,  ["clientFormula"] = "result=(heroBreak)*10",  ["key"] = "guide2003",}
,  [141] = {
  ["precondition"] = "1",  ["formula"] = "(heroStone1+heroStone2+heroStone3+heroStone4+heroStone5+heroStone6)*1",  ["clientPrecondition"] = "1",  ["id"] = 141,  ["clientFormula"] = "result=(heroStone)*1",  ["key"] = "guide2004",}
,  [142] = {
  ["precondition"] = "1",  ["formula"] = "(heroSeal1+heroSeal2+heroSeal3+heroSeal4+heroSeal5+heroSeal6)*10",  ["clientPrecondition"] = "1",  ["id"] = 142,  ["clientFormula"] = "result=(heroSeal)*10",  ["key"] = "guide2005",}
,  [143] = {
  ["precondition"] = "1",  ["formula"] = "cheerNum*10",  ["clientPrecondition"] = "1",  ["id"] = 143,  ["clientFormula"] = "result=cheerNum*10",  ["key"] = "guide2006",}
,  [144] = {
  ["precondition"] = "1",  ["formula"] = "EquNum*10",  ["clientPrecondition"] = "1",  ["id"] = 144,  ["clientFormula"] = "result=EquNum*10",  ["key"] = "guide2007",}
,  [145] = {
  ["precondition"] = "1",  ["formula"] = "EquNum*10",  ["clientPrecondition"] = "1",  ["id"] = 145,  ["clientFormula"] = "result=EquNum*10",  ["key"] = "guide2008",}
,  [146] = {
  ["precondition"] = "1",  ["formula"] = "warriorLevel*100",  ["clientPrecondition"] = "1",  ["id"] = 146,  ["clientFormula"] = "result=warriorLevel*100",  ["key"] = "guide2009",}
,  [147] = {
  ["precondition"] = "1",  ["formula"] = "1.5+heroBreak*0.1",  ["clientPrecondition"] = "1",  ["id"] = 147,  ["clientFormula"] = "result=1.5+heroBreak*0.1",  ["key"] = "hjqyDamage",}
,  [148] = {
  ["precondition"] = "1",  ["formula"] = "grow*0.2+(EquNumRandom-EquNumMin)*1.0/(EquNumMax-EquNumMin)*1*grow*0.8",  ["clientPrecondition"] = "1",  ["id"] = 148,  ["clientFormula"] = "result=grow*0.2+(EquNumRandom-EquNumMin)*1.0/(EquNumMax-EquNumMin)*1*grow*0.8",  ["key"] = "equGrowUpParameter",}
,  [150] = {
  ["precondition"] = "1",  ["formula"] = "damage_percent*currency",  ["clientPrecondition"] = "1",  ["id"] = 150,  ["clientFormula"] = "result=damage_percent*currency",  ["key"] = "Activitycurrency",}
,  [151] = {
  ["precondition"] = "1",  ["formula"] = "damage_percent*ExpDrop",  ["clientPrecondition"] = "1",  ["id"] = 151,  ["clientFormula"] = "result=damage_percent*ExpDrop",  ["key"] = "ActivityExpDrop",}
,  [152] = {
  ["precondition"] = "1",  ["formula"] = "ActivityExpDrop/100",  ["clientPrecondition"] = "1",  ["id"] = 152,  ["clientFormula"] = "result=ActivityExpDrop/100",  ["key"] = "ActivityExpDropConvert_1",}
,  [153] = {
  ["precondition"] = "1",  ["formula"] = "ActivityExpDrop/500",  ["clientPrecondition"] = "1",  ["id"] = 153,  ["clientFormula"] = "result=ActivityExpDrop/500",  ["key"] = "ActivityExpDropConvert_2",}
,  [154] = {
  ["precondition"] = "1",  ["formula"] = "ActivityExpDrop/1000",  ["clientPrecondition"] = "1",  ["id"] = 154,  ["clientFormula"] = "result=ActivityExpDrop/1000",  ["key"] = "ActivityExpDropConvert_3",}
,  [155] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.hp*parameters",  ["clientPrecondition"] = "1",  ["id"] = 155,  ["clientFormula"] = "result=hero_info.hp*parameters",  ["key"] = "hero_Breakthrough.hp",}
,  [156] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.atk*parameters",  ["clientPrecondition"] = "1",  ["id"] = 156,  ["clientFormula"] = "result=hero_info.atk*parameters",  ["key"] = "hero_Breakthrough.atk",}
,  [157] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.physicalDef*parameters",  ["clientPrecondition"] = "1",  ["id"] = 157,  ["clientFormula"] = "result=hero_info.physicalDef*parameters",  ["key"] = "hero_Breakthrough.physicalDef",}
,  [158] = {
  ["precondition"] = "1",  ["formula"] = "hero_info.magicDef*parameters",  ["clientPrecondition"] = "1",  ["id"] = 158,  ["clientFormula"] = "result=hero_info.magicDef*parameters",  ["key"] = "hero_Breakthrough.magicDef",}
,}
