formula_config={
  [1] = {
  ["clientFormula"] = "result=monster_info.hp/10+monster_info.atk*0.2+(monster_info.physicalDef+monster_info.magicDef)*0.4+(monster_info.hit+monster_info.dodge+monster_info.cri+monster_info.criCoeff+monster_info.criDedCoeff+monster_info.block+monster_info.ductility)*5-14500",  ["id"] = 1,  ["formula"] = "monster_info.hp/10+monster_info.atk*0.2+(monster_info.physicalDef+monster_info.magicDef)*0.4+(monster_info.hit+monster_info.dodge+monster_info.cri+monster_info.criCoeff+monster_info.criDedCoeff+monster_info.block+monster_info.ductility)*5-14500",  ["precondition"] = "1",  ["key"] = "fightValue",  ["clientPrecondition"] = "1",}
,  [2] = {
  ["clientFormula"] = "result=hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone",  ["id"] = 2,  ["formula"] = "hero_info.hp+hero_info.growHp*(heroLevel-1)+hpB+hero_info.hp*parameters+hpSeal+hpStone",  ["precondition"] = "1",  ["key"] = "hpHero",  ["clientPrecondition"] = "1",}
,  [3] = {
  ["clientFormula"] = "result=hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone",  ["id"] = 3,  ["formula"] = "hero_info.atk+hero_info.growAtk*(heroLevel-1)+atkB+hero_info.atk*parameters+atkSeal+atkStone",  ["precondition"] = "1",  ["key"] = "atkHero",  ["clientPrecondition"] = "1",}
,  [4] = {
  ["clientFormula"] = "result=hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone",  ["id"] = 4,  ["formula"] = "hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1)+pDefB+hero_info.physicalDef*parameters+pDefSeal+pDefStone",  ["precondition"] = "1",  ["key"] = "physicalDefHero",  ["clientPrecondition"] = "1",}
,  [5] = {
  ["clientFormula"] = "result=hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone",  ["id"] = 5,  ["formula"] = "hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1)+mDefB+hero_info.magicDef*parameters+mDefSeal+mDefStone",  ["precondition"] = "1",  ["key"] = "magicDefHero",  ["clientPrecondition"] = "1",}
,  [6] = {
  ["clientFormula"] = "result=hero_info.hit+hitB+hitSeal+hitStone",  ["id"] = 6,  ["formula"] = "hero_info.hit+hitB+hitSeal+hitStone",  ["precondition"] = "1",  ["key"] = "hitHero",  ["clientPrecondition"] = "1",}
,  [7] = {
  ["clientFormula"] = "result=hero_info.dodge+dodgeB+dodgeSeal+dodgeStone",  ["id"] = 7,  ["formula"] = "hero_info.dodge+dodgeB+dodgeSeal+dodgeStone",  ["precondition"] = "1",  ["key"] = "dodgeHero",  ["clientPrecondition"] = "1",}
,  [8] = {
  ["clientFormula"] = "result=hero_info.cri+criB+criSeal+criStone",  ["id"] = 8,  ["formula"] = "hero_info.cri+criB+criSeal+criStone",  ["precondition"] = "1",  ["key"] = "criHero",  ["clientPrecondition"] = "1",}
,  [9] = {
  ["clientFormula"] = "result=hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone",  ["id"] = 9,  ["formula"] = "hero_info.criCoeff+criCoeffB+criCoeffSeal+criCoeffStone",  ["precondition"] = "1",  ["key"] = "criCoeffHero",  ["clientPrecondition"] = "1",}
,  [10] = {
  ["clientFormula"] = "result=hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone",  ["id"] = 10,  ["formula"] = "hero_info.criDedCoeff+criDedCoeffB+criDedCoeffSeal+criDedCoeffStone",  ["precondition"] = "1",  ["key"] = "criDedCoeffHero",  ["clientPrecondition"] = "1",}
,  [11] = {
  ["clientFormula"] = "result=hero_info.block+blockB+blockSeal+blockStone",  ["id"] = 11,  ["formula"] = "hero_info.block+blockB+blockSeal+blockStone",  ["precondition"] = "1",  ["key"] = "blockHero",  ["clientPrecondition"] = "1",}
,  [12] = {
  ["clientFormula"] = "result=hero_info.ductility+ductilityB+ductilitySeal+ductilityStone",  ["id"] = 12,  ["formula"] = "hero_info.ductility+ductilityB+ductilitySeal+ductilityStone",  ["precondition"] = "1",  ["key"] = "ductilityHero",  ["clientPrecondition"] = "1",}
,  [13] = {
  ["clientFormula"] = "result=self_attr.hpHero*0.1+self_attr.atkHero*0.2+(self_attr.physicalDefHero+self_attr.magicDefHero)*0.4+(self_attr.hitHero+self_attr.dodgeHero+self_attr.criHero+self_attr.criCoeffHero+self_attr.criDedCoeffHero+self_attr.blockHero+self_attr.ductilityHero)*5-14500",  ["id"] = 13,  ["formula"] = "hpHero/10+atkHero*0.2+(physicalDefHero+magicDefHero)*0.4+(hitHero+dodgeHero+criHero+criCoeffHero+criDedCoeffHero+blockHero+ductilityHero)*5-14500",  ["precondition"] = "1",  ["key"] = "fightValueHero",  ["clientPrecondition"] = "1",}
,  [14] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 14,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "hpB_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [15] = {
  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 15,  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "hpB_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [16] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 16,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "atkB_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [17] = {
  ["clientFormula"] = "result=(hero_info.atk+hero_info.growAtk*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 17,  ["formula"] = "(hero_info.atk+hero_info.growAtk*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "atkB_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [18] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 18,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "pDefB_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [19] = {
  ["clientFormula"] = "result=(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 19,  ["formula"] = "(hero_info.physicalDef+hero_info.growPhysicalDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "pDefB_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [20] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 20,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "mDefB_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [21] = {
  ["clientFormula"] = "result=(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 21,  ["formula"] = "(hero_info.magicDef+hero_info.growMagicDef*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "mDefB_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [22] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 22,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "hitB",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [23] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 23,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "dodgeB",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [24] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 24,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "criB",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [25] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 25,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "criCoeffB",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [26] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 26,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "criDedCoeffB",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [27] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 27,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "blockB",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [28] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 28,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "ductilityB",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [29] = {
  ["clientFormula"] = "result=hpHero+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["id"] = 29,  ["formula"] = "hpHero+hpEqu+hpSetEqu+hplink+hpGuild+hpCheer+hpTravel",  ["precondition"] = "1",  ["key"] = "hpArray",  ["clientPrecondition"] = "1",}
,  [30] = {
  ["clientFormula"] = "result=atkHero+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["id"] = 30,  ["formula"] = "atkHero+atkEqu+atkSetEqu+atklink+atkGuild+atkCheer+atkTravel",  ["precondition"] = "1",  ["key"] = "atkArray",  ["clientPrecondition"] = "1",}
,  [31] = {
  ["clientFormula"] = "result=physicalDefHero+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["id"] = 31,  ["formula"] = "physicalDefHero+physicalDefEqu+physicalDefSetEqu+physicalDeflink+physicalDefGuild+physicalDefCheer+physicalDefTravel",  ["precondition"] = "1",  ["key"] = "physicalDefArray",  ["clientPrecondition"] = "1",}
,  [32] = {
  ["clientFormula"] = "result=magicDefHero+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["id"] = 32,  ["formula"] = "magicDefHero+magicDefEqu+magicDefSetEqu+magicDeflink+magicDefGuild+magicDefCheer+magicDefTravel",  ["precondition"] = "1",  ["key"] = "magicDefArray",  ["clientPrecondition"] = "1",}
,  [33] = {
  ["clientFormula"] = "result=hitHero+hitEqu+hitSetEqu+hitlink",  ["id"] = 33,  ["formula"] = "hitHero+hitEqu+hitSetEqu+hitlink",  ["precondition"] = "1",  ["key"] = "hitArray",  ["clientPrecondition"] = "1",}
,  [34] = {
  ["clientFormula"] = "result=dodgeHero+dodgeEqu+dodgeSetEqu+dodgelink",  ["id"] = 34,  ["formula"] = "dodgeHero+dodgeEqu+dodgeSetEqu+dodgelink",  ["precondition"] = "1",  ["key"] = "dodgeArray",  ["clientPrecondition"] = "1",}
,  [35] = {
  ["clientFormula"] = "result=criHero+criEqu+criSetEqu+crilink",  ["id"] = 35,  ["formula"] = "criHero+criEqu+criSetEqu+crilink",  ["precondition"] = "1",  ["key"] = "criArray",  ["clientPrecondition"] = "1",}
,  [36] = {
  ["clientFormula"] = "result=criCoeffHero+criCoeffEqu+criCoeffSetEqu+criCoefflink",  ["id"] = 36,  ["formula"] = "criCoeffHero+criCoeffEqu+criCoeffSetEqu+criCoefflink",  ["precondition"] = "1",  ["key"] = "criCoeffArray",  ["clientPrecondition"] = "1",}
,  [37] = {
  ["clientFormula"] = "result=criDedCoeffHero+criDedCoeffEqu+criDedCoeffSetEqu+criDedCoefflink",  ["id"] = 37,  ["formula"] = "criDedCoeffHero+criDedCoeffEqu+criDedCoeffSetEqu+criDedCoefflink",  ["precondition"] = "1",  ["key"] = "criDedCoeffArray",  ["clientPrecondition"] = "1",}
,  [38] = {
  ["clientFormula"] = "result=blockHero+blockEqu+blockSetEqu+blocklink",  ["id"] = 38,  ["formula"] = "blockHero+blockEqu+blockSetEqu+blocklink",  ["precondition"] = "1",  ["key"] = "blockArray",  ["clientPrecondition"] = "1",}
,  [39] = {
  ["clientFormula"] = "result=ductilityHero+ductilityEqu+ductilitySetEqu+ductilitylink",  ["id"] = 39,  ["formula"] = "ductilityHero+ductilityEqu+ductilitySetEqu+ductilitylink",  ["precondition"] = "1",  ["key"] = "ductilityArray",  ["clientPrecondition"] = "1",}
,  [40] = {
  ["clientFormula"] = "result=lineup_attr.hpArray*0.1+lineup_attr.atkArray*0.2+(lineup_attr.physicalDefArray+lineup_attr.magicDefArray)*0.4+(lineup_attr.hitArray+lineup_attr.dodgeArray+lineup_attr.criArray+lineup_attr.criCoeffArray+lineup_attr.criDedCoeffArray+lineup_attr.blockArray+lineup_attr.ductilityArray)*5-14500",  ["id"] = 40,  ["formula"] = "hpArray*0.1+atkArray*0.2+(physicalDefArray+magicDefArray)*0.4+(hitArray+dodgeArray+criArray+criCoeffArray+criDedCoeffArray+blockArray+ductilityArray)*5-14500",  ["precondition"] = "1",  ["key"] = "fightValueArray",  ["clientPrecondition"] = "1",}
,  [41] = {
  ["clientFormula"] = "result=fightValueArray1+fightValueArray2+fightValueArray3+fightValueArray4+fightValueArray5+fightValueArray6",  ["id"] = 41,  ["formula"] = "fightValueArray1+fightValueArray2+fightValueArray3+fightValueArray4+fightValueArray5+fightValueArray6",  ["precondition"] = "1",  ["key"] = "fightValuePlayer",  ["clientPrecondition"] = "1",}
,  [42] = {
  ["clientFormula"] = "",  ["id"] = 42,  ["formula"] = "hpHero*hpEquValue",  ["precondition"] = "1",  ["key"] = "hpEqu_1",  ["clientPrecondition"] = "1",}
,  [43] = {
  ["clientFormula"] = "",  ["id"] = 43,  ["formula"] = "atkHero*atkEquValue",  ["precondition"] = "1",  ["key"] = "atkEqu_1",  ["clientPrecondition"] = "1",}
,  [44] = {
  ["clientFormula"] = "",  ["id"] = 44,  ["formula"] = "physicalDefHero*physicalDefEquValue",  ["precondition"] = "1",  ["key"] = "physicalDefEqu_1",  ["clientPrecondition"] = "1",}
,  [45] = {
  ["clientFormula"] = "",  ["id"] = 45,  ["formula"] = "magicDefHero*magicDefEquValue",  ["precondition"] = "1",  ["key"] = "magicDefEqu_1",  ["clientPrecondition"] = "1",}
,  [46] = {
  ["clientFormula"] = "",  ["id"] = 46,  ["formula"] = "hitHero*hitEquValue",  ["precondition"] = "1",  ["key"] = "hitEqu_1",  ["clientPrecondition"] = "1",}
,  [47] = {
  ["clientFormula"] = "",  ["id"] = 47,  ["formula"] = "dodgeHero*dodgeEquValue",  ["precondition"] = "1",  ["key"] = "dodgeEqu_1",  ["clientPrecondition"] = "1",}
,  [48] = {
  ["clientFormula"] = "",  ["id"] = 48,  ["formula"] = "criHero*criEquValue",  ["precondition"] = "1",  ["key"] = "criEqu_1",  ["clientPrecondition"] = "1",}
,  [49] = {
  ["clientFormula"] = "",  ["id"] = 49,  ["formula"] = "criCoeffHero*criCoeffEquValue",  ["precondition"] = "1",  ["key"] = "criCoeffEqu_1",  ["clientPrecondition"] = "1",}
,  [50] = {
  ["clientFormula"] = "",  ["id"] = 50,  ["formula"] = "criDedCoeffHero*criDedCoeffEquValue",  ["precondition"] = "1",  ["key"] = "criDedCoeffEqu_1",  ["clientPrecondition"] = "1",}
,  [51] = {
  ["clientFormula"] = "",  ["id"] = 51,  ["formula"] = "blockHero*blockEquValue",  ["precondition"] = "1",  ["key"] = "blockEqu_1",  ["clientPrecondition"] = "1",}
,  [52] = {
  ["clientFormula"] = "",  ["id"] = 52,  ["formula"] = "ductilityHero*ductilityEquValue",  ["precondition"] = "1",  ["key"] = "ductilityEqu_1",  ["clientPrecondition"] = "1",}
,  [53] = {
  ["clientFormula"] = "result=baseHp+growHp*(equLevel-1)",  ["id"] = 53,  ["formula"] = "baseHp+growHp*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "hpEqu",  ["clientPrecondition"] = "1",}
,  [54] = {
  ["clientFormula"] = "result=baseAtk+growAtk*(equLevel-1)",  ["id"] = 54,  ["formula"] = "baseAtk+growAtk*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "atkEqu",  ["clientPrecondition"] = "1",}
,  [55] = {
  ["clientFormula"] = "result=basePdef+growPdef*(equLevel-1)",  ["id"] = 55,  ["formula"] = "basePdef+growPdef*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "physicalDefEqu",  ["clientPrecondition"] = "1",}
,  [56] = {
  ["clientFormula"] = "result=baseMdef+growMdef*(equLevel-1)",  ["id"] = 56,  ["formula"] = "baseMdef+growMdef*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "magicDefEqu",  ["clientPrecondition"] = "1",}
,  [57] = {
  ["clientFormula"] = "result=hit+growHit*(equLevel-1)",  ["id"] = 57,  ["formula"] = "hit+growHit*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "hitEqu",  ["clientPrecondition"] = "1",}
,  [58] = {
  ["clientFormula"] = "result=dodge+growDodge*(equLevel-1)",  ["id"] = 58,  ["formula"] = "dodge+growDodge*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "dodgeEqu",  ["clientPrecondition"] = "1",}
,  [59] = {
  ["clientFormula"] = "result=cri+growCri*(equLevel-1)",  ["id"] = 59,  ["formula"] = "cri+growCri*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "criEqu",  ["clientPrecondition"] = "1",}
,  [60] = {
  ["clientFormula"] = "result=criCoeff+growCriCoeff*(equLevel-1)",  ["id"] = 60,  ["formula"] = "criCoeff+growCriCoeff*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "criCoeffEqu",  ["clientPrecondition"] = "1",}
,  [61] = {
  ["clientFormula"] = "result=criDedCoeff+growCriDedCoeff*(equLevel-1)",  ["id"] = 61,  ["formula"] = "criDedCoeff+growCriDedCoeff*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "criDedCoeffEqu",  ["clientPrecondition"] = "1",}
,  [62] = {
  ["clientFormula"] = "result=block+growBlock*(equLevel-1)",  ["id"] = 62,  ["formula"] = "block+growBlock*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "blockEqu",  ["clientPrecondition"] = "1",}
,  [63] = {
  ["clientFormula"] = "result=ductility+growDuctility*(equLevel-1)",  ["id"] = 63,  ["formula"] = "ductility+growDuctility*(equLevel-1)",  ["precondition"] = "1",  ["key"] = "ductilityEqu",  ["clientPrecondition"] = "1",}
,  [64] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 64,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "hpSetEqu_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [65] = {
  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 65,  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "hpSetEqu_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==4 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [66] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 66,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "atkSetEqu_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [67] = {
  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 67,  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "atkSetEqu_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==6 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [68] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 68,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "physicalDefSetEqu_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [69] = {
  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 69,  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "physicalDefSetEqu_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==10 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [70] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 70,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "magicDefSetEqu_1",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [71] = {
  ["clientFormula"] = "result=(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["id"] = 71,  ["formula"] = "(hero_info.hp+hero_info.growHp*(heroLevel-1))*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "magicDefSetEqu_2",  ["clientPrecondition"] = "skill_buff.valueType==2 and skill_buff.effectId==12 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [72] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 72,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "hitSetEqu",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==14 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [73] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 73,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "dodgeSetEqu",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==16 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [74] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 74,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "criSetEqu",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==18 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [75] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 75,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "criCoeffSetEqu",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==20 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [76] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 76,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "criDedCoeffSetEqu",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==21 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [77] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 77,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "blockSetEqu",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==22 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [78] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 78,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos=={11:0}",  ["key"] = "ductilitySetEqu",  ["clientPrecondition"] = "skill_buff.valueType==1 and skill_buff.effectId==28 and skill_buff.triggerType==1 and skill_buff.effectPos[\"11\"]==0",}
,  [79] = {
  ["clientFormula"] = "hpB_1",  ["id"] = 79,  ["formula"] = "hpB_1",  ["precondition"] = "1",  ["key"] = "hplink",  ["clientPrecondition"] = "1",}
,  [80] = {
  ["clientFormula"] = "hpB_2",  ["id"] = 80,  ["formula"] = "hpB_2",  ["precondition"] = "1",  ["key"] = "hplink",  ["clientPrecondition"] = "1",}
,  [81] = {
  ["clientFormula"] = "atkB_1",  ["id"] = 81,  ["formula"] = "atkB_1",  ["precondition"] = "1",  ["key"] = "atklink_1",  ["clientPrecondition"] = "1",}
,  [82] = {
  ["clientFormula"] = "atkB_2",  ["id"] = 82,  ["formula"] = "atkB_2",  ["precondition"] = "1",  ["key"] = "atklink_2",  ["clientPrecondition"] = "1",}
,  [83] = {
  ["clientFormula"] = "pDefB_1",  ["id"] = 83,  ["formula"] = "pDefB_1",  ["precondition"] = "1",  ["key"] = "physicalDeflink",  ["clientPrecondition"] = "1",}
,  [84] = {
  ["clientFormula"] = "pDefB_2",  ["id"] = 84,  ["formula"] = "pDefB_2",  ["precondition"] = "1",  ["key"] = "physicalDeflink",  ["clientPrecondition"] = "1",}
,  [85] = {
  ["clientFormula"] = "mDefB_1",  ["id"] = 85,  ["formula"] = "mDefB_1",  ["precondition"] = "1",  ["key"] = "magicDeflink",  ["clientPrecondition"] = "1",}
,  [86] = {
  ["clientFormula"] = "mDefB_2",  ["id"] = 86,  ["formula"] = "mDefB_2",  ["precondition"] = "1",  ["key"] = "magicDeflink",  ["clientPrecondition"] = "1",}
,  [87] = {
  ["clientFormula"] = "hitB",  ["id"] = 87,  ["formula"] = "hitB",  ["precondition"] = "1",  ["key"] = "hitlink",  ["clientPrecondition"] = "1",}
,  [88] = {
  ["clientFormula"] = "dodgeB",  ["id"] = 88,  ["formula"] = "dodgeB",  ["precondition"] = "1",  ["key"] = "dodgelink",  ["clientPrecondition"] = "1",}
,  [89] = {
  ["clientFormula"] = "criB",  ["id"] = 89,  ["formula"] = "criB",  ["precondition"] = "1",  ["key"] = "crilink",  ["clientPrecondition"] = "1",}
,  [90] = {
  ["clientFormula"] = "criCoeffB",  ["id"] = 90,  ["formula"] = "criCoeffB",  ["precondition"] = "1",  ["key"] = "criCoefflink",  ["clientPrecondition"] = "1",}
,  [91] = {
  ["clientFormula"] = "criDedCoeffB",  ["id"] = 91,  ["formula"] = "criDedCoeffB",  ["precondition"] = "1",  ["key"] = "criDedCoefflink",  ["clientPrecondition"] = "1",}
,  [92] = {
  ["clientFormula"] = "blockB",  ["id"] = 92,  ["formula"] = "blockB",  ["precondition"] = "1",  ["key"] = "blocklink",  ["clientPrecondition"] = "1",}
,  [93] = {
  ["clientFormula"] = "ductilityB",  ["id"] = 93,  ["formula"] = "ductilityB",  ["precondition"] = "1",  ["key"] = "ductilitylink",  ["clientPrecondition"] = "1",}
,  [94] = {
  ["clientFormula"] = "result=(hpHero4*0.2+hpHero5*0.1+hpHero6*0.1)/person",  ["id"] = 94,  ["formula"] = "(hpHero4*0.2+hpHero5*0.1+hpHero6*0.1)/person",  ["precondition"] = "1",  ["key"] = "hpCheer",  ["clientPrecondition"] = "1",}
,  [95] = {
  ["clientFormula"] = "result=atkHero1*0.2/person",  ["id"] = 95,  ["formula"] = "atkHero1*0.2/person",  ["precondition"] = "1",  ["key"] = "atkCheer",  ["clientPrecondition"] = "1",}
,  [96] = {
  ["clientFormula"] = "result=(physicalDefHero2*0.1+physicalDefHero5*0.1)/person",  ["id"] = 96,  ["formula"] = "(physicalDefHero2*0.1+physicalDefHero5*0.1)/person",  ["precondition"] = "1",  ["key"] = "physicalDefCheer",  ["clientPrecondition"] = "1",}
,  [97] = {
  ["clientFormula"] = "result=(magicDefHero3*0.1+magicDefHero6*0.1)/person",  ["id"] = 97,  ["formula"] = "(magicDefHero3*0.1+magicDefHero6*0.1)/person",  ["precondition"] = "1",  ["key"] = "magicDefCheer",  ["clientPrecondition"] = "1",}
,  [98] = {
  ["clientFormula"] = "result=(triggerRate>random and 1) or 0",  ["id"] = 98,  ["formula"] = "1 if triggerRate>random else 0",  ["precondition"] = "1",  ["key"] = "isTrigger",  ["clientPrecondition"] = "1",}
,  [99] = {
  ["clientFormula"] = "result=((hitArray1-dodgeArray2)/10>random and 1) or 0",  ["id"] = 99,  ["formula"] = "1 if hitArray1/10-dodgeArray2/10>random else 0",  ["precondition"] = "1",  ["key"] = "isHit",  ["clientPrecondition"] = "1",}
,  [100] = {
  ["clientFormula"] = "result=((criArray1-ductilityArray2)/10>random and 1) or 0",  ["id"] = 100,  ["formula"] = "1 if criArray1/10-ductilityArray2/10>random else 0",  ["precondition"] = "1",  ["key"] = "isCri",  ["clientPrecondition"] = "1",}
,  [101] = {
  ["clientFormula"] = "result=(blockArray/10>random and 1) or 0",  ["id"] = 101,  ["formula"] = "1 if blockArray/10>random else 0",  ["precondition"] = "1",  ["key"] = "isBlock",  ["clientPrecondition"] = "1",}
,  [102] = {
  ["clientFormula"] = "result= (atkArray-def2 > heroLevel and atkArray-def2 ) or heroLevel",  ["id"] = 102,  ["formula"] = "atkArray-def2 if atkArray-def2 > heroLevel else heroLevel",  ["precondition"] = "1",  ["key"] = "baseDamage",  ["clientPrecondition"] = "1",}
,  [103] = {
  ["clientFormula"] = "result=(criCoeffArray1-criDedCoeffArray2)/1000",  ["id"] = 103,  ["formula"] = "(criCoeffArray1-criDedCoeffArray2)/1000",  ["precondition"] = "1",  ["key"] = "criDamage",  ["clientPrecondition"] = "1",}
,  [104] = {
  ["clientFormula"] = "result=1",  ["id"] = 104,  ["formula"] = "1 if heroLevel1<heroLevel2+5 else 1",  ["precondition"] = "1",  ["key"] = "levelDamage",  ["clientPrecondition"] = "1",}
,  [105] = {
  ["clientFormula"] = "result=k1+random*(k2-k1)/99",  ["id"] = 105,  ["formula"] = "k1+random*(k2-k1)/99",  ["precondition"] = "1",  ["key"] = "floatDamage",  ["clientPrecondition"] = "",}
,  [106] = {
  ["clientFormula"] = "result=baseDamage*((isHit and 1) or 0)*((isCri and criDamage) or 1)*((isBlock and 0.7) or 1)*levelDamage*floatDamage",  ["id"] = 106,  ["formula"] = "baseDamage*(1 if isHit else 0)*(criDamage if isCri else 1)*(0.7 if isBlock else 1)*levelDamage*floatDamage",  ["precondition"] = "1",  ["key"] = "allDamage",  ["clientPrecondition"] = "1",}
,  [107] = {
  ["clientFormula"] = "result=atkArray*((isCri and criCoeffArray/1000) or 1)",  ["id"] = 107,  ["formula"] = "atkArray*(criCoeffArray/1000 if isCri else 1)",  ["precondition"] = "1",  ["key"] = "allHeal",  ["clientPrecondition"] = "1",}
,  [108] = {
  ["clientFormula"] = "result=allDamage+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 108,  ["formula"] = "allDamage+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType ==1",  ["key"] = "damage_1",  ["clientPrecondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType ==1",}
,  [109] = {
  ["clientFormula"] = "result=allDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["id"] = 109,  ["formula"] = "allDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType == 2",  ["key"] = "damage_2",  ["clientPrecondition"] = "skill_buff.effectId <= 2 and skill_buff.valueType == 2",}
,  [110] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 110,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 1",  ["key"] = "damage_3",  ["clientPrecondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 1",}
,  [111] = {
  ["clientFormula"] = "result=atkArray*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["id"] = 111,  ["formula"] = "atkArray*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 2",  ["key"] = "damage_4",  ["clientPrecondition"] = "skill_buff.effectId == 3 and skill_buff.valueType == 2",}
,  [112] = {
  ["clientFormula"] = "result=(warriors_atkArray-enemy_physicalDefArray-enemy_magicDefArray)",  ["id"] = 112,  ["formula"] = "(warriors_atkArray-enemy_physicalDefArray-enemy_magicDefArray)",  ["precondition"] = "1",  ["key"] = "warriorsDamage",  ["clientPrecondition"] = "",}
,  [113] = {
  ["clientFormula"] = "result=warriorsBaseDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*playerLevel",  ["id"] = 113,  ["formula"] = "warriorsBaseDamage*skill_buff.valueEffect/100+skill_buff.levelEffectValue*playerLevel",  ["precondition"] = "1",  ["key"] = "warriorsLastDamage",  ["clientPrecondition"] = "",}
,  [114] = {
  ["clientFormula"] = "result=atk*1.5",  ["id"] = 114,  ["formula"] = "atk*1.5",  ["precondition"] = "1",  ["key"] = "monster_warriors_atkArray",  ["clientPrecondition"] = "1",}
,  [115] = {
  ["clientFormula"] = "result=allHeal+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 115,  ["formula"] = "allHeal+skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 1",  ["key"] = "heal_1",  ["clientPrecondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 1",}
,  [116] = {
  ["clientFormula"] = "result=allHeal*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["id"] = 116,  ["formula"] = "allHeal*skill_buff.valueEffect/100+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 2",  ["key"] = "heal_2",  ["clientPrecondition"] = "skill_buff.effectId == 26 and skill_buff.valueType == 2",}
,  [117] = {
  ["clientFormula"] = "result=skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["id"] = 117,  ["formula"] = "skill_buff.valueEffect+skill_buff.levelEffectValue*heroLevel",  ["precondition"] = "skill_buff.effectId >3 and skill_buff.effectId != 26 and skill_buff.valueType == 1",  ["key"] = "skillbuffEffct_1",  ["clientPrecondition"] = "skill_buff.effectId >3 and skill_buff.effectId ~= 26 and skill_buff.valueType == 1",}
,  [118] = {
  ["clientFormula"] = "result=attrHero*skill_buff.valueEffect/100",  ["id"] = 118,  ["formula"] = "attrHero*skill_buff.valueEffect/100",  ["precondition"] = "skill_buff.effectId >3 and skill_buff.effectId != 26 and skill_buff.valueType == 2",  ["key"] = "skillbuffEffct_2",  ["clientPrecondition"] = "skill_buff.effectId >3 and skill_buff.effectId ~= 26 and skill_buff.valueType == 2",}
,  [119] = {
  ["clientFormula"] = "result=expHero/100",  ["id"] = 119,  ["formula"] = "expHero/100",  ["precondition"] = "expHero >= 100 and expHero < 500",  ["key"] = "sacrificeExp_1",  ["clientPrecondition"] = "expHero >= 100 and expHero < 500",}
,  [120] = {
  ["clientFormula"] = "result=expHero/500",  ["id"] = 120,  ["formula"] = "expHero/500",  ["precondition"] = "expHero >= 500 and expHero < 1000",  ["key"] = "sacrificeExp_2",  ["clientPrecondition"] = "expHero >= 500 and expHero < 1000",}
,  [121] = {
  ["clientFormula"] = "result=expHero/1000",  ["id"] = 121,  ["formula"] = "expHero/1000",  ["precondition"] = "expHero >= 1000",  ["key"] = "sacrificeExp_3",  ["clientPrecondition"] = "expHero >= 1000",}
,  [122] = {
  ["clientFormula"] = "result=10000",  ["id"] = 122,  ["formula"] = "\"10000\"",  ["precondition"] = "1",  ["key"] = "coinWorldboss",  ["clientPrecondition"] = "1",}
,  [123] = {
  ["clientFormula"] = "result=10",  ["id"] = 123,  ["formula"] = "\"10\"",  ["precondition"] = "1",  ["key"] = "soulWorldboss",  ["clientPrecondition"] = "1",}
,  [124] = {
  ["clientFormula"] = "result=10000/rank+playerLevel*10",  ["id"] = 124,  ["formula"] = "10000/rank+playerLevel*10",  ["precondition"] = "1",  ["key"] = "coinArenaSuccess",  ["clientPrecondition"] = "1",}
,  [125] = {
  ["clientFormula"] = "result=10000/rank+playerLevel*8",  ["id"] = 125,  ["formula"] = "10000/rank+playerLevel*8",  ["precondition"] = "1",  ["key"] = "coinArenaFail",  ["clientPrecondition"] = "1",}
,  [126] = {
  ["clientFormula"] = "result=playerLuckyValue/50000",  ["id"] = 126,  ["formula"] = "playerLuckyValue/50000",  ["precondition"] = "1",  ["key"] = "shopLuckyValue",  ["clientPrecondition"] = "1",}
,  [127] = {
  ["clientFormula"] = "result=[1,2,3,4,5,6]",  ["id"] = 127,  ["formula"] = "[1,2,3,4,5,6]",  ["precondition"] = "seatHero==1",  ["key"] = "defaultAttackSequence_1 ",  ["clientPrecondition"] = "seatHero==1",}
,  [128] = {
  ["clientFormula"] = "result=[2,3,1,5,6,4]",  ["id"] = 128,  ["formula"] = "[2,3,1,5,6,4]",  ["precondition"] = "seatHero==2",  ["key"] = "defaultAttackSequence_2",  ["clientPrecondition"] = "seatHero==2",}
,  [129] = {
  ["clientFormula"] = "result=[3,1,2,6,4,5]",  ["id"] = 129,  ["formula"] = "[3,1,2,6,4,5]",  ["precondition"] = "seatHero==3",  ["key"] = "defaultAttackSequence_3 ",  ["clientPrecondition"] = "seatHero==3",}
,  [130] = {
  ["clientFormula"] = "result=[1,2,3,4,5,6]",  ["id"] = 130,  ["formula"] = "[1,2,3,4,5,6]",  ["precondition"] = "seatHero==4",  ["key"] = "defaultAttackSequence_4",  ["clientPrecondition"] = "seatHero==4",}
,  [131] = {
  ["clientFormula"] = "result=[2,3,1,5,6,4]",  ["id"] = 131,  ["formula"] = "[2,3,1,5,6,4]",  ["precondition"] = "seatHero==5",  ["key"] = "defaultAttackSequence_5",  ["clientPrecondition"] = "seatHero==5",}
,  [132] = {
  ["clientFormula"] = "result=[3,1,2,6,4,5]",  ["id"] = 132,  ["formula"] = "[3,1,2,6,4,5]",  ["precondition"] = "seatHero==6",  ["key"] = "defaultAttackSequence_6",  ["clientPrecondition"] = "seatHero==6",}
,  [133] = {
  ["clientFormula"] = "result=equ_attr.hp*0.1+equ_attr.atk*0.2+(equ_attr.physicalDef+equ_attr.magicDef)*0.4+(equ_attr.hit+equ_attr.dodge+equ_attr.cri+equ_attr.criCoeff+equ_attr.criDedCoeff+equ_attr.block+equ_attr.ductility)*5",  ["id"] = 133,  ["formula"] = "hp*0.1+atk*0.2+(physicalDef+magicDef)*0.4+(hit+dodge+cri+criCoeff+criDedCoeff+block+ductility)*5",  ["precondition"] = "1",  ["key"] = "equFightValue",  ["clientPrecondition"] = "1",}
,  [134] = {
  ["clientFormula"] = "result=(damage <= 10000 and damage) or 10000+damage/10",  ["id"] = 134,  ["formula"] = "damage if damage<=10000 else 10000+damage/10",  ["precondition"] = "1",  ["key"] = "coinWarFogboss",  ["clientPrecondition"] = "1",}
,  [135] = {
  ["clientFormula"] = "result=(moonCardSurplusDay < 4 and 1) or 0",  ["id"] = 135,  ["formula"] = "1 if moonCardSurplusDay < 9999999 else 0",  ["precondition"] = "1",  ["key"] = "moonCard",  ["clientPrecondition"] = "1",}
,  [136] = {
  ["clientFormula"] = "result=(weekCardSurplusDay < 3 and 1) or 0",  ["id"] = 136,  ["formula"] = "1 if weekCardSurplusDay < 4 else 0",  ["precondition"] = "1",  ["key"] = "weekCard",  ["clientPrecondition"] = "1",}
,  [137] = {
  ["clientFormula"] = "result=upRank - highestRank",  ["id"] = 137,  ["formula"] = "upRank - highestRank",  ["precondition"] = "1",  ["key"] = "arenaRankUpRewardsValue",  ["clientPrecondition"] = "1",}
,  [138] = {
  ["clientFormula"] = "result=heroNum*10",  ["id"] = 138,  ["formula"] = "heroNum*10",  ["precondition"] = "1",  ["key"] = "guide2001",  ["clientPrecondition"] = "1",}
,  [139] = {
  ["clientFormula"] = "result=heroNum*10",  ["id"] = 139,  ["formula"] = "heroNum*10",  ["precondition"] = "1",  ["key"] = "guide2002",  ["clientPrecondition"] = "1",}
,  [140] = {
  ["clientFormula"] = "result=(heroBreak)*10",  ["id"] = 140,  ["formula"] = "(heroBreak1+heroBreak2+heroBreak3+heroBreak4+heroBreak5+heroBreak6)*10",  ["precondition"] = "1",  ["key"] = "guide2003",  ["clientPrecondition"] = "1",}
,  [141] = {
  ["clientFormula"] = "result=(heroStone)*1",  ["id"] = 141,  ["formula"] = "(heroStone1+heroStone2+heroStone3+heroStone4+heroStone5+heroStone6)*1",  ["precondition"] = "1",  ["key"] = "guide2004",  ["clientPrecondition"] = "1",}
,  [142] = {
  ["clientFormula"] = "result=(heroSeal)*10",  ["id"] = 142,  ["formula"] = "(heroSeal1+heroSeal2+heroSeal3+heroSeal4+heroSeal5+heroSeal6)*10",  ["precondition"] = "1",  ["key"] = "guide2005",  ["clientPrecondition"] = "1",}
,  [143] = {
  ["clientFormula"] = "result=cheerNum*10",  ["id"] = 143,  ["formula"] = "cheerNum*10",  ["precondition"] = "1",  ["key"] = "guide2006",  ["clientPrecondition"] = "1",}
,  [144] = {
  ["clientFormula"] = "result=EquNum*10",  ["id"] = 144,  ["formula"] = "EquNum*10",  ["precondition"] = "1",  ["key"] = "guide2007",  ["clientPrecondition"] = "1",}
,  [145] = {
  ["clientFormula"] = "result=EquNum*10",  ["id"] = 145,  ["formula"] = "EquNum*10",  ["precondition"] = "1",  ["key"] = "guide2008",  ["clientPrecondition"] = "1",}
,  [146] = {
  ["clientFormula"] = "result=warriorLevel*100",  ["id"] = 146,  ["formula"] = "warriorLevel*100",  ["precondition"] = "1",  ["key"] = "guide2009",  ["clientPrecondition"] = "1",}
,  [147] = {
  ["clientFormula"] = "result=1.5+heroBreak*0.1",  ["id"] = 147,  ["formula"] = "1.5+heroBreak*0.1",  ["precondition"] = "1",  ["key"] = "hjqyDamage",  ["clientPrecondition"] = "1",}
,  [148] = {
  ["clientFormula"] = "result=grow*0.2+(EquNumRandom-EquNumMin)*1.0/(EquNumMax-EquNumMin)*1*grow*0.8",  ["id"] = 148,  ["formula"] = "grow*0.2+(EquNumRandom-EquNumMin)*1.0/(EquNumMax-EquNumMin)*1*grow*0.8",  ["precondition"] = "1",  ["key"] = "equGrowUpParameter",  ["clientPrecondition"] = "1",}
,}
