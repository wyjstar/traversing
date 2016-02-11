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
from shared.db_opear.configs_data.common_item import CommonGroupItem
from shared.utils.const import const


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
        self.fid = 0 # 缓存强援助阵

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
            red = slot.slot_attr
            if red:
                red_unit[no] = red
        self._red_unit = red_unit
        return self._red_unit

    def get_red_units(self):
        """docstring for get_red_units"""
        self._owner.line_up_component.update_guild_attr()
        red_units = {}
        for no, slot in self.line_up_slots.items():
            logger.debug("xxxxxx%s" % no)
            red = slot.get_battle_unit(self.stage)
            logger.debug("xxxxxx%s" % slot.hero_slot.hero_no)
            if red:
                red_units[no] = red
        self.awake_hero_units(red_units)
        self.__break_hero_units(red_units)
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

    def _get_stage_config(self):
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
        if game_configs.stage_config.get('hjqy_stages').get(self._stage_id):
            return game_configs.stage_config.get(
                'hjqy_stages').get(self._stage_id)

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
        stage = self._get_stage_config()
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
            stage_config = self._get_stage_config()
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

    def _assemble_monster(self):
        """组装怪物战斗单位
        """
        stage_config = self._get_stage_config()  # 关卡配置

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
            print("boss_position %s" % boss_position)

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
        stage_config = self._get_stage_config()  # 关卡配置
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
        stage = self._get_stage_config()
        if not stage:
            return 0
        logger.debug("__get_break_stage_odds %s" % stage.get("break_Probability", 0))
        return stage.get("break_Probability", 0)

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
        blue_units = self._assemble_monster()
        monster_unpara = self.__get_monster_unpara()

        return red_units, blue_units, drop_num, monster_unpara

    def fighting_settlement(self, result, star_num):
        """战斗结算
        stage_type: 1剧情关卡 6精英关卡 4活动宝库关卡5活动校场关卡 14隐藏关卡
        """
        stage_info = self._get_stage_config()
        self.owner.stage_component.settlement(self._stage_id, result, star_num)
        self.owner.stage_component.save_data()
        drops = []
        if result:
            # 关卡掉落
            for _ in range(self._drop_num):
                common_bag = BigBag(self._common_drop)
                common_drop = common_bag.get_drop_items()
                drops.extend(common_drop)
            if stage_info.type == 1 or stage_info.type == 14:
                self.get_stage_drop(stage_info, drops)
                self.owner.stage_component.save_data()
            else:
                if self._elite_drop:
                    elite_bag = BigBag(self._elite_drop)
                    elite_drop = elite_bag.get_drop_items()
                    drops.extend(elite_drop)

        if stage_info.type == 4:
            # 宝库活动副本
            formula = game_configs.formula_config.get("Activitycurrency").get("formula")
            assert formula!=None, "Activitycurrency formula can not be None!"
            coin_num = eval(formula, {"damage_percent": self.damage_percent,"currency": stage_info.currency})
            if coin_num:
                drops.append(CommonGroupItem(const.COIN, coin_num, coin_num, const.RESOURCE))

        elif stage_info.type == 5:
            # 校场活动副本
            formula = game_configs.formula_config.get("ActivityExpDrop").get("formula")
            assert formula!=None, "ActivityExpDrop formula can not be None!"
            exp_drop = eval(formula, {"damage_percent": self.damage_percent,"ExpDrop": stage_info.ExpDrop})

            if stage_info.id % 10 == 1:
                formula = game_configs.formula_config.get("ActivityExpDropConvert_1").get("formula")
                assert formula!=None, "ActivityExpDrop formula can not be None!"
                exp_item_num = eval(formula, {"ActivityExpDrop": exp_drop})
                if exp_item_num >= 1:
                    drops.append(CommonGroupItem(10001, exp_item_num, exp_item_num, const.ITEM))
            elif stage_info.id % 10 ==2:
                formula = game_configs.formula_config.get("ActivityExpDropConvert_2").get("formula")
                assert formula!=None, "ActivityExpDrop formula can not be None!"
                exp_item_num = eval(formula, {"ActivityExpDrop": exp_drop})
                if exp_item_num >= 1:
                    drops.append(CommonGroupItem(10002, exp_item_num, exp_item_num, const.ITEM))
            elif stage_info.id % 10 ==3:
                formula = game_configs.formula_config.get("ActivityExpDropConvert_3").get("formula")
                assert formula!=None, "ActivityExpDrop formula can not be None!"
                exp_item_num = eval(formula, {"ActivityExpDrop": exp_drop})
                if exp_item_num >= 1:
                    drops.append(CommonGroupItem(10003, exp_item_num, exp_item_num, const.ITEM))
        elif stage_info.type == 6:
            # 精英活动副本
            hero_soul_num = stage_info.reward
            if hero_soul_num:
                drops.append(CommonGroupItem(const.RESOURCE, hero_soul_num, hero_soul_num, const.HERO_SOUL))
            #drops.extend(stage_info.ClearanceReward)

        logger.debug("drops %s" % drops)

        return drops

    def add_settle_coin(self, drops, coin):
        """docstring for add_settle_coin"""
        drops.append(CommonGroupItem(const.RESOURCE, coin, coin, const.COIN))



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

            line_up_slot = self.line_up_slots.get(red_unit.slot_no)

            hero_no = break_config.hero_id
            if odds == 1: # 如果百分比为1， 则按几率掉碎片
                self.break_stage_id = break_config.id
            break_hero_obj = self.change_hero(hero, hero_no)

            unit = line_up_slot.assemble_hero(break_hero_obj)
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
            if not hero_item or hero_item.type == 1:
                continue
            line_up_slot = self.line_up_slots.get(red.slot_no)
            logger.debug("hero no %s awakeHeroID %s" % (hero.hero_no, hero_item.get("awakeHeroID")))
            if hero.is_awake() and hero_item.get('awakeHeroID'):
                target_hero_no = hero_item.get('awakeHeroID')
                break_hero_obj = self.change_hero(hero, target_hero_no)

                unit = line_up_slot.assemble_hero(break_hero_obj)
                unit.is_awake = True
                unit.origin_no = red.unit_no
                red_units[no] = unit

    def change_hero(self, origin_hero, target_hero_no):
        """docstring for change_hero, 觉醒，乱入
        return new line_up_slot
        """
        break_hero_obj = copy.deepcopy(origin_hero)  # 实例化一个替换英雄对象
        break_hero_obj.hero_no = target_hero_no
        return break_hero_obj

    def get_stage_drop(self, stage_conf, drops):
        stage_obj = self.owner.stage_component.get_stage(stage_conf.id)

        elite_drop_stage, elite_drop2_stage = stage_obj.have_elite_drop(stage_conf)
        # stage_obj.attack_times += 1

        if elite_drop2_stage and stage_conf.eliteDrop2:  # 掉落保底
            elite_bag = BigBag(stage_conf.eliteDrop2)
            elite_drop2 = elite_bag.get_drop_items()
            drops.extend(elite_drop2)

        if not elite_drop_stage or not stage_conf.eliteDrop:
            return

        if stage_conf.type == 1:
            elite_bag = BigBag(stage_conf.eliteDrop)
            elite_drop = elite_bag.get_drop_items()
            drops.extend(elite_drop)
            if elite_drop:
                stage_obj.elite_drop_times += 1
        else:
            if elite_drop2_stage:
                return
            # 根据条件得到概率
            elite_drop2_condition_state = get_elite_drop2_condition_state(self.owner, stage_conf)
            if not elite_drop2_condition_state:
                return

            elite_bag = BigBag(stage_conf.eliteDrop)
            elite_drop = elite_bag.get_drop_items()
            drops.extend(elite_drop)
            if elite_drop:
                stage_obj.elite_drop_times += 1


def get_elite_drop2_condition_state(player, stage_conf):
    gailv = 0
    determination = stage_conf.Determination
    for type, info in determination.items():
        info1 = copy.copy(info)
        del info1[0]
        res = eval('get_condition_state'+str(type)+'(player, info1)')
        if res:
            gailv += info[0]
    print gailv, '================================gailv'
    return random.random() > gailv


def get_condition_state1(player, info):
    return False


def get_condition_state2(player, info):
    line_up_slots = player.line_up_component.line_up_slots
    num = 0
    for slot in line_up_slots.values():
        if not slot.activation:  # 如果卡牌位未激活
            continue
        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if hero_obj:
            if hero_obj.break_level >= info[2]:
                num += 1
    if num >= info[1]:
        return True
    return False


def get_condition_state3(player, info):
    if player.base_info.level >= info[1]:
        return True
    return False


def get_condition_state4(player, info):
    if player.base_info.vip_level >= info[1]:
        return True
    return False


def get_condition_state5(player, info):
    if player.line_up_component.combat_power >= info[1]:
        return True
    return False


def get_condition_state6(player, info):
    return False


def get_condition_state7(player, info):
    line_up_slots = player.line_up_component.line_up_slots
    res = False
    for slot in line_up_slots.values():
        if not slot.activation:  # 如果卡牌位未激活
            continue
        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if hero_obj and hero_obj.hero_no == info[1]:
            if info[2] and hero_obj.level < info[2]:
                continue
            if info[3]:
                link_res = 0
                for link_no, link_info in slot.hero_slot.link.items():
                    if link_no == info[3] and link_info:
                        link_res = 1
                        break
                if link_res:
                    continue
            res = True
            break
    return True


def get_condition_state8(player, info):
    line_up_slots = player.line_up_component.line_up_slots
    res = False
    for slot in line_up_slots.values():
        if not slot.activation:  # 如果卡牌位未激活
            continue

        for equ_slot_no, equ_slot_obj in slot.equipment_slots.items():
            if not equ_slot_obj.equipment_id or equ_slot_obj.equipment_id != info[1]:
                continue
            if not info[2]:
                res = True
                break
            equipment_obj = equ_slot_obj.equipment_obj
            if equipment_obj.attribute.strengthen_lv >= info[2]:
                res = True
            break

    if not info[3]:
        return res

    for slot in line_up_slots.values():
        if not slot.activation:  # 如果卡牌位未激活
            continue

        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if hero_obj:
            for link_no, link_info in slot.hero_slot.link:
                if link_no == info[3] and link_info:
                    return True
    return False
