# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:54.
"""
import random
from app.game.component.Component import Component
from app.game.core.drop_bag import BigBag
from app.battle.battle_unit import do_assemble
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
import copy
from app.game.component.fight.hero_attr_cal import combat_power


class CharacterFightCacheComponent(Component):

    """战斗缓存组件
    """

    def __init__(self, owner):
        super(CharacterFightCacheComponent, self).__init__(owner)

        self._stage_id = 0  # 关卡ID
        self._drop_num = 0  # 关卡小怪掉落数量
        self._common_drop = 0  # 关卡小怪掉落编号
        self._elite_drop = 0  # 关卡boss掉落编号

        self._red_unit = []  # 红方战斗单位
        self._blue_unit = []  # 蓝方战斗单位  [[]] 二维

        self._not_replace = []  # 不能替换的英雄
        self.break_stage_id = 0
        self._stage = None
        self.seed1 = 0  # 战斗校验种子
        self.seed2 = 0

    def init_data(self, c):
        return

    def new_data(self):
        return {}

    @property
    def red_unit(self):
        """初始创建红方单位
        """
        red_unit = {}
        for no, slot in self.line_up_slots.items():
            logger.debug("xxxxxx%s" % no)
            red = slot.slot_attr
            logger.debug("xxxxxx%s" % slot.hero_slot.hero_no)
            if red:
                red_unit[no] = red
        self._red_unit = red_unit
        return self._red_unit

    def get_red_units(self):
        """docstring for get_red_units"""
        red_units = {}
        for no, slot in self.line_up_slots.items():
            logger.debug("xxxxxx%s" % no)
            red = slot.get_battle_unit(self.stage)
            logger.debug("xxxxxx%s" % slot.hero_slot.hero_no)
            if red:
                red_units[no] = red
        return red_units


    @red_unit.setter
    def red_unit(self, value):
        self._red_unit = value

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, stage_id):
        self._stage_id = stage_id

    @property
    def stage(self):
        return self._stage

    @stage.setter
    def stage(self, stage):
        self._stage = stage

    @property
    def drop_num(self):
        return self._drop_num

    @drop_num.setter
    def drop_num(self, drop_num):
        self._drop_num = drop_num

    def __get_stage_config(self):
        """取得关卡配置数据
        """
        if game_configs.stage_config.get('travel_fight_stages').get(self._stage_id):
            return game_configs.stage_config.get(
                'travel_fight_stages').get(self._stage_id)
        if game_configs.stage_config.get('stages').get(self._stage_id):
            return game_configs.stage_config.get('stages').get(self._stage_id)
        if game_configs.special_stage_config.get('elite_stages').get(self._stage_id):
            return game_configs.special_stage_config.get(
                'elite_stages').get(self._stage_id)
        if game_configs.special_stage_config.get('act_stages').get(self._stage_id):
            return game_configs.special_stage_config.get(
                'act_stages').get(self._stage_id)
        if game_configs.special_stage_config.get('world_boss_stages').get(self._stage_id):
            return game_configs.special_stage_config.get(
                'world_boss_stages').get(self._stage_id)
        if game_configs.special_stage_config.get('mine_boss_stages').get(self._stage_id):
            return game_configs.special_stage_config.get(
                'mine_boss_stages').get(self._stage_id)
        if game_configs.stage_config.get('mine_stages').get(self._stage_id):
            return game_configs.stage_config.get(
                'mine_stages').get(self._stage_id)

    def __get_skill_config(self, skill_id):
        """取得技能BUFF配置
        """
        return game_configs.skill_config.get(skill_id)

    def __get_monster_group_config(self, group_id):
        """取得怪物组信息
        """
        monster_group_config = game_configs.monster_group_config.get(group_id)
        return monster_group_config

    def __get_monster_config(self, monster_id):
        """取得怪物信息
        """
        monster_config = game_configs.monster_config.get(monster_id)
        return monster_config

    def __get_stage_break_config(self):
        """取得关卡乱入信息"""
        stage = self.__get_stage_config()
        if stage and "stage_break_id" in stage:
            return game_configs.stage_break_config.get(
                stage.stage_break_id,
                None)

        return None

    def __get_drop_num(self):
        """取得关卡小怪掉落数量
        """
        drop_num = 0
        # 如果上次战斗未结算，则使用上次保存的掉落数
        stage = self.owner.stage_component.get_stage(self._stage_id)
        if stage:
            drop_num = stage.drop_num
        if not drop_num:
            stage_config = self.__get_stage_config()
            low = stage_config.low
            high = stage_config.high
            drop_num = random.randint(low, high)
            stage.drop_num = drop_num
            self.owner.stage_component.save_data()

        self._drop_num = drop_num
        return drop_num

    @property
    def line_up_slots(self):
        """阵容
        """
        slots = self.owner.line_up_component.line_up_slots

        return slots

    def __assmble_monsters(self):
        """组装怪物战斗单位
        """
        stage_config = self.__get_stage_config()  # 关卡配置

        monsters = []
        for i in range(3):
            logger.debug("stage_id %s" % self._stage_id)
            logger.debug(
                "stage_group_id %s" %
                getattr(
                    stage_config, 'round%s' %
                    (i + 1)))
            monster_group_id = getattr(stage_config, 'round%s' % (i+1))
            if not monster_group_id:
                continue
            monster_group_config = self.__get_monster_group_config(
                monster_group_id)

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
                monster_config = self.__get_monster_config(monster_id)
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
        self._blue_unit = monsters
        self._common_drop = stage_config.commonDrop
        self._elite_drop = stage_config.eliteDrop
        # logger.info('关卡怪物信息: %s ' % monsters)
        return monsters

    def __get_monster_unpara(self):
        """取得怪物无双
        """
        stage_config = self.__get_stage_config()  # 关卡配置
        unpara = stage_config.get("warriorsSkill")  # 无双编号
        return unpara
        # if not unpara:
        #     return []
        # triggle3 = game_configs.warriors_config.get(unpara).triggle3
        # skill_config = self.__get_skill_config(triggle3)
        # group = skill_config.group
        # return [unpara] + group

    def __get_break_stage_odds(self):
        """取得乱入概率
        """
        odds = 0
        stage_break_config = self.__get_stage_break_config()

        if not stage_break_config:
            logger.info('no stage break odds')
            return odds

        for i in range(1, 8):
            condition_config = getattr(
                stage_break_config,
                'condition%d' %
                i)  # 乱入条件
            odds_config = getattr(stage_break_config, 'odds%d' % i)  # 乱入几率
            if self.check_condition(condition_config):
                odds += odds_config
            logger.info(
                '乱入条件: %s odds:%f not replace:%s' %
                (condition_config, odds, self._not_replace))

        return odds

    def check_condition(self, condition_config):
        """
        @param condition_config: 武将乱入条件配置
        @return: 此条件是否完成
        """
        for condition_type, condition_param in condition_config.items():
            if not self.__do_check_condition(condition_type, condition_param):
                return False
        return True

    def __do_check_condition(self, condition_type, condition_param):
        """
        @param condition_type:  条件类型
        @param condition_param:  条件参数
        @return:
        """
        mapping_dict = {
            '1': self.check_num,  # 上阵人数
            '2': self.check_hero,  # 上阵英雄
            '3': self.check_equ,  # 上阵装备
            '4': self.check_suit,  # 激活套装
            '5': self.check_link,  # 激活羁绊
        }

        return mapping_dict[condition_type](condition_param)

    def check_num(self, condition_param):
        hero_nos = self.owner.line_up_component.hero_nos
        num = len(hero_nos)
        if condition_param > num:
            return False
        return True

    def check_hero(self, condition_param):
        hero_nos = self.owner.line_up_component.hero_nos
        logger.info('hero nos:%s', hero_nos)
        if condition_param in hero_nos:
            self._not_replace.append(condition_param)
            return True
        return False

    def check_equ(self, condition_param):
        for slot in self.line_up_slots.values():
            if slot.equipment_nos:
                logger.info('slot equipment nos:%s', slot.equipment_nos)
            if condition_param in slot.equipment_nos:
                return True
        return False

    def check_suit(self, condition_param):
        for slot in self.line_up_slots.values():
            if slot.equ_suit:
                logger.info('slot equ suit:%s', slot.equ_suit.keys())
            if condition_param in slot.equ_suit:
                return True
        return False

    def check_link(self, condition_param):
        for slot in self.line_up_slots.values():
            #if slot.hero_slot.hero_no in self._not_replace:
                #continue
            if condition_param in slot.hero_slot.link:
                link_config = game_configs.link_config.get(
                    slot.hero_slot.hero_no)
                for i in range(1, 6):
                    link = getattr(link_config, 'link%s' % i)
                    if link:
                        logger.info(
                            'slot hero no%s, link:%s' %
                            (slot.hero_slot.hero_no, link))
                    if condition_param == link:
                        trigger = getattr(link_config, 'trigger%s' % i)
                        set_trigger = set(trigger)
                        set_hero_nos = set(
                            self.owner.line_up_component.hero_nos)
                        if set_hero_nos.issuperset(set_trigger):
                            self._not_replace.append(slot.hero_slot.hero_no)
                            self._not_replace.extend(trigger)
                            return True
        return False

    def fighting_start(self):
        """战斗开始
        """
        self.break_stage_id = 0
        red_units = self.get_red_units()
        drop_num = self.__get_drop_num()  # 掉落数量
        blue_units = self.__assmble_monsters()
        monster_unpara = self.__get_monster_unpara()
        self.awake_hero_units(red_units)
        self.__break_hero_units(red_units)

        return red_units, blue_units, drop_num, monster_unpara

    def fighting_settlement(self, result):
        """战斗结算
        stage_type: 1剧情关卡 2副本关卡 3活动关卡
        """
        self.owner.stage_component.settlement(self._stage_id, result)
        self.owner.stage_component.save_data()
        drops = []
        if not result:
            return drops
        # 关卡掉落
        for _ in range(self._drop_num):
            common_bag = BigBag(self._common_drop)
            common_drop = common_bag.get_drop_items()
            drops.extend(common_drop)

        elite_bag = BigBag(self._elite_drop)
        elite_drop = elite_bag.get_drop_items()
        drops.extend(elite_drop)

        return drops

    def __break_hero_units(self, red_units):
        self._not_replace = []
        odds = self.__get_break_stage_odds()
        break_config = self.__get_stage_break_config()
        if not break_config:
            logger.debug('can not find stage break config')
            return

        rand_odds = random.random()

        logger.info(
            '乱入几率: %s, 随机几率: %s, 红发战斗单位: %s' %
            (odds, rand_odds, red_units))
        if rand_odds <= odds:
            replace = []  # 可以替换的英雄
            for k, red_unit in red_units.items():
                if not red_unit:
                    continue
                hero_no = red_unit.unit_no  # 英雄编号
                if red_unit.is_awake:
                    hero_no = red_unit.origin_no
                if hero_no in self._not_replace:
                    continue
                replace.append(red_unit)
            logger.info('乱入可以替换的战斗单位: %s' % replace)
            if not replace:
                return

            red_unit = random.choice(replace)  # 选出可以替换的单位

            logger.info('乱入被替换战斗单位属性: %s' % red_unit)
            hero = self.owner.hero_component.get_hero(red_unit.unit_no)
            if red_unit.is_awake:
                hero = self.owner.hero_component.get_hero(red_unit.origin_no)

            old_line_up_slot = self.line_up_slots.get(red_unit.slot_no)
            break_line_up_slot = copy.deepcopy(old_line_up_slot)

            hero_no = break_config.hero_id
            if odds == 1: # 如果百分比为1， 则按几率掉碎片
                self.break_stage_id = break_config.id
            break_hero_obj = self.change_hero(hero, hero_no)

            unit = break_line_up_slot.assemble_hero(break_hero_obj)
            logger.info('乱入替换战斗单位属性: %s' % unit)

            unit.is_break = True
            unit.origin_no = red_unit.unit_no
            for key, red in red_units.items():
                if red.unit_no == red_unit.unit_no:
                    red_units[key] = unit

    def awake_hero_units(self, red_units):
        for no, red in red_units.items():
            hero = self.owner.hero_component.get_hero(red.unit_no)
            if not hero:
                continue
            hero_item = hero.hero_info
            _rand = random.random()
            if not hero_item:
                continue
            if not hero_item.get('awake'):
                continue
            old_line_up_slot = self.line_up_slots.get(red.slot_no)
            ap = combat_power.combat_power_hero_self(self.owner, hero)
            for upAp, prob in hero_item.get('awake').items():
                if ap > upAp and _rand < prob:
                    break_line_up_slot = copy.deepcopy(old_line_up_slot)
                    target_hero_no = hero_item.get('awakeHeroID')
                    break_hero_obj = self.change_hero(hero, target_hero_no)

                    unit = break_line_up_slot.assemble_hero(break_hero_obj)
                    unit.is_awake = True
                    unit.origin_no = red.unit_no
                    red_units[no] = unit
                    break

    def change_hero(self, origin_hero, target_hero_no):
        """docstring for change_hero, 觉醒，乱入
        return new line_up_slot
        """
        break_hero_obj = copy.deepcopy(origin_hero)  # 实例化一个替换英雄对象
        break_hero_obj.hero_no = target_hero_no
        return break_hero_obj
