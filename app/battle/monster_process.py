# !/usr/bin/env python
# -*- coding: utf-8 -*-


from app.battle.battle_unit import do_assemble
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger

def assemble_monster(stage_id, stage_config, stage_type_name):
    """组装怪物战斗单位
    """
    stage_config = stage_config.get(stage_type_name).get(stage_id)

    monsters = []
    for i in range(3):
        logger.debug("stage_id %s" % stage_id)
        logger.debug(
            "stage_group_id %s" %
            getattr(
                stage_config, 'round%s' %
                (i + 1)))
        monster_group_id = getattr(stage_config, 'round%s' % (i+1))
        if not monster_group_id:
            continue
        monster_group_config = game_configs.monster_group_config.get(monster_group_id)

        round_monsters = {}

        boss_position = monster_group_config.bossPosition

        for j in range(6):
            pos = j + 1
            monster_id = getattr(monster_group_config, 'pos%s' % pos)
            if not monster_id:
                continue
            is_boss = False
            if j + 1 == boss_position:
                is_boss = True
            monster_config = game_configs.monster_config.get(monster_id)
            logger.info('怪物ID：%s' % monster_id)

            battle_unit = do_assemble(
                0,
                monster_config.id,
                monster_config.quality,
                [],
                monster_config.hp,
                monster_config.atk,
                monster_config.physicalDef,
                monster_config.magicDef,
                monster_config.hit,
                monster_config.dodge,
                monster_config.cri,
                monster_config.criCoeff,
                monster_config.criDedCoeff,
                monster_config.block,
                monster_config.ductility,
                pos,
                monster_config.monsterLv,
                0,
                is_boss,
                is_hero=False)
            round_monsters[pos] = battle_unit
        monsters.append(round_monsters)

    # 保存关卡怪物信息, 掉落信息
    logger.info('关卡怪物信息: %s ' % monsters)
    return monsters


