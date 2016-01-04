# -*- coding:utf-8 -*-
"""
Created on 2014-11-24

@author: hack
"""
import time
import random
import cPickle
from shared.db_opear.configs_data import game_configs
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from app.game.redis_mode import tb_character_level
from app.game.redis_mode import tb_character_ap
from app.game.redis_mode import tb_mine
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from shared.common_logic.mine import get_cur_data
from shared.common_logic.mine import random_pick


remote_gate = GlobalObject().remote.get('gate')


class MineType:
    USER_SELF = 0
    PLAYER_FIELD = 1
    MONSTER_FIELD = 2
    SHOP = 3
    CHEST = 4
    COPY = 5


def mine_boss():
    result = remote_gate['world'].trigger_mine_boss_remote()
    return result


def get_user_mines(uid):
    mine_obj = tb_character_info.getObj(uid)
    user_mines = mine_obj.hget('mine')
    mines = user_mines.values()
    random.shuffle(mines)
    for mine in mines:
        if mine.get('type') == MineType.PLAYER_FIELD:
            match_mine = tb_mine.hget(mine['seq'])
            if match_mine['status'] != 3:
                match_mine['seq'] = mine['seq']
                return match_mine
    return None


def player_mine_create(mine, uid, nickname, level, lively):
    lively = 1
    item = None
    for v in game_configs.mine_match_config.values():
        if lively == v.playerActivity and level >= v.playerLevel[0] \
           and level <= v.playerLevel[1]:
            item = v
    rule_id = random_pick(item.proRule, sum(item.proRule.values()))
    rule = item.Rule[rule_id]

    if len(rule) < 8:
        return False

    isplayer, _, lowlevel, highlevel,\
        minus, add, lowswordrate, highswordrate = rule
    if isplayer == 0:
        return False

    front = level + minus if level + minus >= lowlevel else lowlevel
    back = level + add if level + add <= highlevel else highlevel
    # 取玩家等级附近的玩家
    uids = tb_character_level.zrangebyscore(front, back+1)
    match_users = []
    self_sword = tb_character_ap.zscore(uid)
    if self_sword is None:
        self_sword = 0
    if uids:
        for one_user in uids:  # 取战力匹配的玩家
            one_user = int(one_user)
            if one_user == uid:
                continue
            user_sword = tb_character_ap.zscore(one_user)
            if user_sword is None:
                user_sword = 0
            if user_sword < self_sword * lowswordrate \
               or user_sword > highswordrate * self_sword:
                continue
            match_users.append(one_user)
    random.shuffle(match_users)
    logger.debug('mine match player:%s', match_users)
    if not match_users:  # 没有匹配的玩家生成野怪矿
        return False
    match_mine = None
    for one_user in match_users:  # 随机玩家占领的野怪矿
        match_mine = get_user_mines(one_user)
        if match_mine is not None:
            mine['type'] = MineType.PLAYER_FIELD
            mine['seq'] = match_mine['seq']
            mine['mine_id'] = match_mine['mine_id']
            return True
    return False


def draw_stones(mine, uid):
    if mine['type'] == MineType.USER_SELF:
        # 领取产出
        normal = {}
        lucky = {}
        for k, v in mine['normal'].items():
            normal[k] = v
            mine['normal'][k] = 0
        for k, v in mine['lucky'].items():
            lucky[k] = v
            mine['lucky'][k] = 0
        return normal, lucky

    if mine['type'] == MineType.PLAYER_FIELD:
        result = remote_gate['world'].mine_harvest_remote(uid, mine['seq'])
        result = cPickle.loads(result)
        return result.get('normal'), result.get('lucky')

    if mine['type'] == MineType.CHEST:
        mine['status'] = 5
        return True

    if mine['type'] == MineType.SHOP:
        return

    if mine['type'] == MineType.COPY:
        mine['status'] = 6
        return True


def detail_info(mine):
    if mine['type'] == MineType.USER_SELF:
        now = time.time()
        get_cur_data(mine, now)
        return mine

    if mine['type'] == MineType.PLAYER_FIELD:

        _remote_mine = tb_mine.hget(mine['seq'])
        if _remote_mine is None:
            logger.error('detail info remote not found:%s', mine['seq'])
            return None
        get_cur_data(_remote_mine, (time.time()))

        return _remote_mine

    return mine


def acc_mine(mine):
        # 增产
        now = time.time()
        get_cur_data(mine, now)  # 本次增产前结算之前的产出
        mine_data = game_configs.mine_config.get(mine['mine_id'])
        if mine.get('increase', 0) < now:
            mine['increase'] = now + mine_data.increasTime * 60
        else:
            mine['increase'] += mine_data.increasTime * 60
        return mine['increase']


def settle(mine, uid=None, result=True, nickname=None, hold=1):
    if mine['type'] == MineType.PLAYER_FIELD:
        result = remote_gate['world'].mine_settle_remote(uid,
                                                         mine['seq'],
                                                         result,
                                                         nickname,
                                                         hold)
        result = cPickle.loads(result)
        logger.debug('remote_gate result:%s', result)

        return mine, result

    if mine['type'] == MineType.MONSTER_FIELD:
        _now = int(time.time())
        mine_item = game_configs.mine_config.get(mine['mine_id'])
        if not mine_item:
            logger.error('mine config cant found:%s', mine['mine_id'])

        player_field = {}
        player_field.update(mine)
        player_field['type'] = MineType.PLAYER_FIELD
        player_field['normal_harvest'] = _now
        player_field['normal_end'] = _now + mine_item.timeLimited1 * 60
        player_field['lucky_harvest'] = _now
        player_field['lucky_end'] = player_field['normal_end']
        player_field['nickname'] = nickname
        player_field['uid'] = uid
        player_field['creator'] = uid
        player_field['last_time'] = _now + mine_item.timeLimited1 * 60
        player_field['status'] = 1
        player_field['seek_help'] = 0

        seq = remote_gate['world'].mine_add_field_remote(uid,
                                                         player_field)
        if seq == 0:
            logger.error('mine add field remote failed:%s', seq)
            return player_field, {'result': False, 'normal': {}, 'lucky': {}}

        mine['seq'] = seq
        mine['type'] = MineType.PLAYER_FIELD

        result = {'result': True, 'normal': {}, 'lucky': {}}
        return player_field, result


def mine_data(mine):
    if mine['type'] == MineType.PLAYER_FIELD:
        return dict(mine_type=1)

    if mine['type'] == MineType.MONSTER_FIELD:
        info = {}
        info['mine_type'] = 0
        info['stage_id'] = mine['stage_id']
        return info


def config_mine_ids(mtype):
    mids = {}
    for mid in game_configs.mine_config.keys():
        if game_configs.mine_config[mid].type == mtype:
            mids[mid] = game_configs.mine_config[mid].weight
    return mids


def gen_stone(num, odds_dict, limit, store, now_data):
    # 发放符文石
    if now_data >= limit:
        logger.error('gen_stone:%s >= %s', now_data, limit)
        return store
    for _ in range(0, num):
        stone_id = random_pick(odds_dict, sum(odds_dict.values()))
        if stone_id is None:
            continue
        stone_id = int(stone_id)
        if stone_id == 0:
            continue
        if stone_id not in store:
            store[stone_id] = 1
        else:
            store[stone_id] += 1
        now_data += 1
        if now_data >= limit:
            break
    return store


def dat(end, start, dur):
    return int((end-start) / (dur*60))


def check_mine(mine):
    for k in mine.keys():
        if not mine[k]:
            del mine[k]


class CharacterMine(Component):
    def __init__(self, owner):
        Component.__init__(self, owner)

        self._reset_day = 0  # 上次重置时间
        self._reset_times = 0  # 已重置次数
        self._tby = ''  # 玩家活跃度周期
        self._lively = 0  # 玩家活跃度，每两天刷新一次
        self._mine = {}  # 玩家当前搜索出的矿

    def init_data(self, character_info):
        # character_info = self.new_data()
        self._mine = character_info.get('mine')
        self._reset_day = character_info.get('reset_day')
        self._reset_times = character_info.get('reset_times')
        self._tby = character_info.get('day_before')
        self._lively = character_info.get('lively')
        check_mine(self._mine)
        # self.save_data()
        logger.debug('mine init data: %s', self._mine)

    def save_data(self):
        check_mine(self._mine)
        mine_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(mine=self._mine,
                    reset_day=self._reset_day,
                    reset_times=self._reset_times,
                    day_before=self._tby,
                    lively=self._lively)
        mine_obj.hmset(data)

    def new_data(self):
        mine = {}
        mine['uid'] = self.owner.base_info.id
        mine['type'] = MineType.USER_SELF
        mine['mine_id'] = config_mine_ids(1).keys()[0]
        mine['status'] = 1
        mine['nickname'] = self.owner.base_info.base_name
        mine['normal_harvest'] = time.time()
        mine['lucky_harvest'] = time.time()
        mine_item = game_configs.mine_config[mine['mine_id']]
        mine['normal'] = {}
        mine['lucky'] = {}
        mine['normal_end'] = -1
        mine['lucky_end'] = -1
        mine['increase'] = 0
        for nor_id in mine_item.group1.keys():
            if int(nor_id) != 0:
                mine['normal'][int(nor_id)] = 0
        for sp_id in mine_item.randomStoneId.keys():
            if int(sp_id) != 0:
                mine['lucky'][int(sp_id)] = 0

        self._mine = {}
        self._mine[0] = mine

        data = dict(mine=self._mine,
                    reset_day=self._reset_day,
                    reset_times=self._reset_times,
                    day_before=self._tby,
                    lively=self._lively)
        return data

    def reset_data(self):
        data = self.new_data()
        self._reset_day = 0
        self._reset_times = 0
        self._tby = ''
        self._lively = 0
        self._mine = data['mine']
        self.save_data()

    def if_have_shop(self):
        for mine in self._mine.values():
            if mine['type'] == MineType.SHOP:
                return True
        return False

    def _reset_everyday(self):
        """
        每日更新内容
        """
        now = time.strftime("%Y%m%d", time.localtime(time.time()))
        if now != self._reset_day:
            self._reset_times = 0
            self._reset_day = now
        _time = time.localtime(time.time() - 24*60*60*2)
        today_before_yestoday = time.strftime("%Y%m%d", _time)
        if today_before_yestoday != self._tby:
            self._tby = today_before_yestoday
            self._lively = 0

    @property
    def reset_times(self):
        self._reset_everyday()
        vip_add = self.owner.base_info.war_refresh_times
        return self._reset_times, 0, vip_add+0

    def add_lively(self, times):
        """ 设置活跃度 """
        self._reset_everyday()
        self._lively += times

    def can_search(self, position):
        """
        能否探索
        """
        num = game_configs.base_config['warFogStrongpointNum']
        if len(self._mine) >= num + 1:
            return False
        return True

    def can_reset_free(self):
        self._reset_everyday()

        if self._reset_times >= self.owner.base_info.war_refresh_times:
            logger.debug('war fog refresh time:%s-%s',
                         self._reset_times,
                         self.owner.base_info.war_refresh_times)
            return False
        if len(self._mine) < game_configs.base_config['warFogStrongpointNum']:
            logger.debug('war fog strong num:%s-%s',
                         len(self._mine),
                         game_configs.base_config['warFogStrongpointNum'])
            return False
        return True

    def can_reset(self):
        self._reset_everyday()
        vip_add = self.owner.base_info.war_refresh_times
        free_everyday = game_configs.base_config['totemRefreshFreeTimes']
        if self._reset_times >= vip_add + free_everyday:
            return False
        if len(self._mine) < game_configs.base_config['warFogStrongpointNum']:
            return False
        return True

    def reset_price(self):
        price_list = game_configs.base_config['warFogRefreshPrice']
        if len(price_list) <= self._reset_times:
            return price_list[-1]
        else:
            return price_list[self._reset_times]

    def reset_map(self):
        """
        可重置规则
        神秘商人，巨龙宝箱，副本
        自己的已枯竭的矿
        非自己的矿
        """
        uid = self.owner.base_info.id
        reset_pos = []
        for pos in self._mine.keys():
            _mine = detail_info(self._mine[pos])
            if _mine['type'] in [MineType.MONSTER_FIELD,
                                 MineType.SHOP,
                                 MineType.COPY,
                                 MineType.CHEST]:
                reset_pos.append(pos)
                del self._mine[pos]
            elif _mine['type'] == 1 and _mine['status'] == 3:
                reset_pos.append(pos)
                del self._mine[pos]
            elif _mine['type'] == 1 and _mine['uid'] != uid:
                reset_pos.append(pos)
                del self._mine[pos]

        self._reset_times += 1
        return reset_pos

    def search_mine(self, position):
        if position in self._mine:
            return self._mine[position]
        odds = game_configs.base_config['warFogStrongpointOdds']
        odds1 = game_configs.base_config['warFogStrongpointOdds2']
        lively = 0
        if self._lively >= 1:
            stype = random_pick(odds, sum(odds.values()))
            lively = 1
        else:
            stype = random_pick(odds1, sum(odds.values()))
        # if stype == MineType.COPY:
        #     num = get_num()
        #     if num >= game_configs.base_config['warFogBossCriServer']:
        #         stype = MineType.MONSTER_FIELD

        _uid = self.owner.base_info.id
        _nickname = self.owner.base_info.base_name
        _level = self.owner.base_info.level

        mine = {}

        logger.debug('mine type:%s', stype)
        if stype == MineType.PLAYER_FIELD:
            if not player_mine_create(mine, _uid, _nickname, _level, lively):
                stype = MineType.MONSTER_FIELD

            if 'seq' in mine and self.ifhave(mine['seq']):
                stype = MineType.MONSTER_FIELD

        if stype == MineType.CHEST:
            mine['type'] = MineType.CHEST

        if stype == MineType.SHOP:
            if self.if_have_shop():
                stype = MineType.MONSTER_FIELD
            else:
                mine['type'] = MineType.SHOP
                self.owner.shop.auto_refresh_items(7)
                self.owner.shop.save_data()

                response = self.owner.shop.build_response_shop_items(7)
                dynamic_id = self.owner.dynamic_id
                remote_gate.push_object_remote(508, response, dynamic_id)

        if stype == MineType.COPY:
            result = mine_boss()
            if not result:
                stype = MineType.MONSTER_FIELD
            else:
                mine['type'] = MineType.COPY

        if stype == MineType.MONSTER_FIELD:

            _mine_ids = config_mine_ids(2)
            mine['mine_id'] = random_pick(_mine_ids, sum(_mine_ids.values()))
            mine['type'] = MineType.MONSTER_FIELD
            mine['nickname'] = u"野怪"
            mine_item = game_configs.mine_config[mine['mine_id']]
            mine['gen_time'] = int(mine_item.timeLimitedR)

            normal = {}
            lucky = {}
            for nor_id in mine_item.group1.keys():
                if int(nor_id) != 0:
                    normal[int(nor_id)] = 0
            for sp_id in mine_item.randomStoneId.keys():
                if int(sp_id) != 0:
                    lucky[int(sp_id)] = 0
            stage_id = random.sample(mine_item.monster, 1)[0]
            mine['stage_id'] = stage_id
            mine['normal'] = normal
            mine['lucky'] = lucky

        logger.debug('create  %s', mine)
        self._mine[position] = mine
        return mine

    def ifhave(self, seq):
        for mine in self._mine.values():
            if mine['type'] == 1 and seq == mine['seq']:
                return True
        return False

    def mine_status(self):
        """ 查询所有矿点信息 """
        mine_infos = []

        for pos in self._mine.keys():
            logger.debug("mine pos %s" % pos)
            info = self.mine_info(pos)
            mine_infos.append(info)
        return mine_infos

    def mine_info(self, position):
        _uid = self.owner.base_info.id
        _nickname = self.owner.base_info.base_name
        mine = self._mine[position]

        if 'type' not in mine:
            logger.error('mine info not type!:%s', mine)

        if mine['type'] == MineType.PLAYER_FIELD:
            mine = tb_mine.hget(mine['seq'])

        info = {}
        info['uid'] = mine.get('uid', _uid)
        info['type'] = mine.get('type')
        info['status'] = mine.get('status', 1)
        info['nickname'] = mine.get('nickname', _nickname)
        info['last_time'] = mine.get('last_time', 0)
        info['gen_time'] = mine.get('gen_time', 0)
        info['seek_help'] = mine.get('seek_help', 0)
        info['mine_id'] = mine.get('mine_id', 0)

        info['position'] = position
        return info

    def harvest(self, position):
        """ 收获 """
        # print 'harvest', position
        uid = self.owner.base_info.id
        if position in self._mine:
            normal, lucky = draw_stones(self._mine[position], uid)
            # print 'harvest', normal, lucky
            return normal, lucky
        return {}, {}

    def shop_info(self, position):
        """ 查看神秘商店信息 """
        if position in self._mine:
            mine = self._mine[position]
            if mine['type'] != MineType.SHOP:
                return []
            return detail_info(mine)

    def reward(self, position):
        # 领取宝箱奖励
        uid = self.owner.base_info.id
        if position in self._mine:
            if draw_stones(self._mine[position], uid):
                # print 'reward123'
                return True
        return False

    def detail_info(self, position):
        """
        查看矿点详细信息，初始矿和野外矿
        """
        if position in self._mine:
            detail_data = detail_info(self._mine[position])
            # print 'detail_data', detail_data
            return detail_data
        return None

    def increase_mine(self):
        """
        增产
        """
        last_time = acc_mine(self._mine[0])
        return last_time

    def settle(self, position, result, hold):
        _uid = self.owner.base_info.id
        _nickname = self.owner.base_info.base_name
        mine, result = settle(self._mine[position], _uid,
                              result, _nickname, hold)

        # self._mine[position] = mine  # 更改本地信息
        self.save_data()
        return result

    def mid(self, position):
        return self._mine[position]['mine_id']

    def start(self, position):
        """
        true:can
        false:can not
        """
        # return self._mine[position].start_battle()
        return None

    def get_info(self, pos):
        """
        mine_type, 0 pve, 1 pvp
        stage_id
        """
        if pos in self._mine:
            return mine_data(self._mine[pos])
        return {}

    def is_pvp(self, pos):
        if pos in self._mine:
            return self._mine[pos]['type'] == MineType.PLAYER_FIELD
        return False

    def get_acc_time_gold(self, pos):
        if pos == 0 or pos not in self._mine:
            logger.error('acc time gold pos is error:%s', pos)
            return 0
        prices = game_configs.base_config.get('stoneReduceTimePrice')
        _mine = self._mine[pos]
        if _mine.get('accelerate_times', 0) >= len(prices):
            logger.error('accelerate time, over index:%s-%s',
                         prices,
                         _mine.get('accelerate_times', 0))
            return 0
        return prices[_mine.get('accelerate_times', 0)]

    def acc_mine_time(self, pos):
        if pos == 0 or pos not in self._mine:
            logger.error('acc time gold pos is error:%s', pos)
            return 0
        _uid = self.owner.base_info.id
        _mine = self._mine[pos]
        change_time = game_configs.base_config.get('stoneReduceTime') * 60
        result = remote_gate['world'].acc_mine_time_remote(_uid,
                                                           _mine['seq'],
                                                           change_time)
        if result:
            _mine['accelerate_times'] = _mine.get('accelerate_times', 0) + 1
            self.save_data()
        return result

    def seek_help(self, pos):
        if pos == 0 or pos not in self._mine:
            logger.error('acc time gold pos is error:%s', pos)
            return False
        _mine = self._mine[pos]
        if _mine['type'] != MineType.PLAYER_FIELD:
            return False
        mine = tb_mine.hget(_mine['seq'])
        if mine.get('seek_help'):
            return False

        _uid = self.owner.base_info.id
        _g_id = self.owner.guild.g_id
        result = remote_gate['world'].mine_seek_help_remote(_uid,
                                                            _mine['seq'],
                                                            _g_id)
        return result
