# -*- coding:utf-8 -*-
'''
Created on 2015-5-2

@author: hack
'''
from gfirefly.utils.singleton import Singleton
from shared.db_opear.configs_data import game_configs
from shared.utils import xtime

from gfirefly.dbentrust.redis_mode import RedisObject
import random
from gfirefly.server.logobj import logger
import time

mine_obj = RedisObject('mineopt')

def random_pick(odds_dict, num_top=1):
    pick_result = None
    x = random.uniform(0, num_top)
    odds_cur = 0.0
    for item, item_odds in odds_dict.items():
        if item_odds == 0:
            continue
        odds_cur += item_odds
        if x <= odds_cur:
            pick_result = item
            break
    return pick_result


class MineType:
    USER_SELF = 0
    PLAYER_FIELD = 1
    MONSTER_FIELD = 2
    SHOP = 3
    CHEST = 4
    COPY = 5
    _create = {PLAYER_FIELD: "PlayerField",
               MONSTER_FIELD: "MonsterField",
               CHEST: "Chest",
               SHOP: "Shop",
               COPY: "Copy"}

    @classmethod
    def create(cls, stype, uid, nickname):
        if stype in cls._create:
            mine = eval(cls._create[stype]).create(uid, nickname)
            # print 'MineType.create', stype, uid, nickname, type(mine)
            return mine
        return None


class ConfigData(object):
    def __init__(self):
        pass

    @classmethod
    def mine_ids(cls, mtype):
        mids = {}
        for mid in game_configs.mine_config.keys():
            if game_configs.mine_config[mid].type == mtype:
                mids[mid] = game_configs.mine_config[mid].weight
        return mids

    @classmethod
    def mine(cls, mid):
        if mid in game_configs.mine_config:
            return game_configs.mine_config[mid]
        return None

    @classmethod
    def shopid_odds(cls, stype=7):
        sids = {}
        doors = game_configs.shop_config.get(7)
        for one in doors:
            if one.type == stype:
                sids[one.id] = one.weight
        return sids


class Mine(object):
    """
    生成矿点
    """
    def __init__(self):
        self._tid = 0
        self._type = 1  # 矿点类型 0玩家初始矿，1玩家占领的野怪矿，2野外矿，3神秘商人，4巨龙宝箱，5副本
        self._status = 1  # 矿点状态1生产中，2可收获，3已枯竭，4空闲，5已领取，6副本已进入
        self._nickname = ''  # 昵称
        self._last_time = 0  # 倒计时
        self._gen_time = 0

    def mine_info(self):
        info = {}
        info['type'] = self._type
        info['status'] = self._status
        info['nickname'] = self._nickname
        info['last_time'] = self._last_time
        info['gen_time'] = self._gen_time
        return info

    def can_reset(self, uid):
        """
        可重置规则
        神秘商人，巨龙宝箱，副本
        自己的已枯竭的矿
        非自己的矿
        """
        # print 'can_reset', self._status, self._type, self._tid, uid
        if self._type in [3, 4, 5] or (self._status == 3 and self._type == 1 and self._tid == uid)  or self._tid != uid:
            return True
        return False

    @classmethod
    def create(cls, uid, nickname):
        pass


def gen_stone(num, odds_dict, limit, store, now_data):
    # 发放符文石
    if now_data >= limit:
        logger.error('gen_stone:%s > %s', now_data, limit)
        return
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


def compute(mine_id, increase, dur, per, now, harvest, harvest_end):
    num = 0  # 产量
    start = 0

    if now > harvest_end and harvest_end != -1:
        now = harvest_end
    if harvest >= increase:
        # 没有增产
        data = dat(now, harvest, dur)
        # harvest += dat*(dur*60)
        start = harvest + data*(dur*60)
        num = data*per
    else:
        if now <= increase:
            # 增产还未结束，从上次结算到当前都在增产
            mine = ConfigData.mine(mine_id)
            ratio = mine.increase  # 增产比例
            data = dat(now, harvest, dur)
            # harvest += dat*(dur*60)
            start = harvest + data*(dur*60)
            num = int(data * per * ratio)
        else:
            mine = ConfigData.mine(mine_id)
            ratio = mine.increase  # 增产比例
            incr_dat = dat(increase, harvest, dur)
            dat1 = int(incr_dat * per * ratio)  # 增产部分
            nor_dat = dat(now, increase, dur)
            dat2 = (nor_dat*per)  # 未增产部分
            num = dat1+dat2
            # harvest += int(num * (dur*60))
            start = harvest + int(num * (dur*60))

    return num, start


def get_cur(mine_id, now_data, harvest, start, end, now, increase, stype):
    # 结算到当前的产出
    mine = ConfigData.mine(mine_id)
    if now_data >= mine.outputLimited:
        logger.debug('get_cur:%s > %s', now_data, mine.outputLimited)
        now_data = mine.outputLimited
    if stype == 1:
        num, last = compute(mine_id,
                            increase,
                            mine.timeGroup1,
                            mine.outputGroup1,
                            now,
                            start,
                            end)
        stone = gen_stone(num,
                          mine.group1,
                          mine.outputLimited,
                          harvest,
                          now_data)
    else:
        num, last = compute(mine_id,
                            increase,
                            mine.timeGroupR,
                            mine.outputGroupR,
                            now,
                            start,
                            end)
        stone = gen_stone(num,
                          mine.randomStoneId,
                          mine.outputLimited,
                          harvest,
                          now_data)
    return last, stone


class PlayerField(Mine):
    """ 玩家占领的野外矿 """
    def __init__(self):
        Mine.__init__(self)
        self._seq = 0
        self._lineup = None
        self._guard_time = 0  # 保护时间
        self._mine_id = 0  # 玩家矿和野外矿id
        self._normal_harvest = 0  # 普通符文石最后一次收获时间
        self._normal_end = -1  # 普通符文石生产结束时间－1不限
        self._lucky_harvest = 0  # 特殊符文石最后一次收获时间
        self._lucky_end = -1  # 特殊符文石生产结束时间－1 不限
        self._increase = 0  # 增产时间
        self._normal = {}  # 符文石
        self._lucky = {}  # 幸运石
        self._gen_time = 0
        self._seek_help = 0

    def save_info(self):
#         print 'save_info self.lineup', self._lineup
        info = {'seq': self._seq,
                'uid': self._tid,
                'type': self._type,
                'status': self._status,
                'nickname': self._nickname,
                'lineup':  self._lineup,
                'guard_time': self._guard_time,
                'mine_id': self._mine_id,
                'normal_harvest': self._normal_harvest,
                'lucky_harvest': self._lucky_harvest,
                'normal_end': self._normal_end,
                'lucky_end': self._lucky_end,
                'normal': self._normal,
                'seek_help': self._seek_help,
                'lucky': self._lucky
                }
#         print info['lineup']
        return info

    def update_info(self, info):
        # print type(info)
        # print 'update_info', info['seq']
        self._seq = info.get('seq', -1)
        self._tid = info.get('uid', -1)
        self._type = info.get('type')
        self._status = info.get('status')
        self._nickname = info.get('nickname')
        self._lineup = info.get('lineup')
        self._guard_time = info.get('guard_time')
        self._mine_id = info.get('mine_id')
        self._normal_harvest = info.get('normal_harvest')
        self._lucky_harvest = info.get('lucky_harvest')
        self._normal_end = info.get('normal_end')
        self._lucky_end = info.get('lucky_end')
        self._normal = info.get('normal')
        self._lucky = info.get('lucky')
        self._seek_help = info.get('seek_help')
        self._last_time = self._normal_end
        mine = ConfigData.mine(self._mine_id)
        # print 'update_info', self._mine_id
        for nor_id in mine.group1.keys():
            if int(nor_id) == 0:
                continue
            if int(nor_id) in self._normal:
                continue
            self._normal[int(nor_id)] = 0
        for sp_id in mine.randomStoneId.keys():
            if int(sp_id) == 0:
                continue
            if int(sp_id) in self._lucky:
                continue
            self._lucky[int(sp_id)] = 0

    def get_cur_data(self, now):
        now_data = sum(self._normal.values()) + sum(self._lucky.values())
        # print 'get_cur_data', self._mine_id, now_data, self._normal, self._normal_harvest, self._normal_end, now, self._increase
        last, stone = get_cur(self._mine_id,
                              now_data,
                              self._normal,
                              self._normal_harvest,
                              self._normal_end,
                              now,
                              self._increase, 1)
        self._normal_harvest = last
        self._normal = stone
        now_data = sum(self._normal.values()) + sum(self._lucky.values())
        # print 'get_cur_data', self._mine_id, now_data, self._lucky, self._lucky_harvest, self._lucky_end, now, self._increase
        last, stone = get_cur(self._mine_id,
                              now_data,
                              self._lucky,
                              self._lucky_harvest,
                              self._lucky_end,
                              now,
                              self._increase, 2)
        self._lucky_harvest = last
        self._lucky = stone

    def update_mine(self):
        now = int(time.time())
        self.get_cur_data(now)

    def mine_info(self):
        self.update_mine()
        return Mine.mine_info(self)

    def detail_info(self):
        """
        查看玩家占领的野怪矿详情
        """
        self.update_mine()
#         now = time.time()
#         self.get_cur(now)
#         if now >= self._increase:
#             last_increase =  0
#         else:
#             last_increase = self._increase
        mine = ConfigData.mine(self._mine_id)
        # print 'detail_info', self._normal, self._lucky, self._guard_time, self._seq
#         limit, _ = compute(self._mine_id, 0, mine.timeGroupR, mine.outputGroupR, self._normal_end, self._normal_harvest, self._normal_end)
        return 0, 1, 0, mine.outputLimited, self._normal, self._lucky, self._lineup, self._guard_time  # ret,last_increase, limit, normal, lucky, heros

    def acc_mine_time(self, change_time):
        self._normal_harvest -= change_time
        self._lucky_harvest -= change_time
        self._normal_end -= change_time
        self._lucky_end -= change_time
        self._last_time -= change_time
        return True

"""
label = 'mine.%s' % uid
        rdobj = tb_rank.getObj(label)
        rdobj.hset(mid, 1)

        label = 'mine'
        rdobj = tb_rank.getObj(label)
        rdobj.hset(mid, data)
"""


class MineData(object):
    """
    符文秘境操作
    """

    __metaclass__ = Singleton

    def __init__(self):
        self.mines = {}
        self.users = {}
        self.lock = {}

    def save_data(self, seq, lineup=None):
        label = 'mine'
        rdobj = mine_obj.getObj(label)
        if lineup != None:
            self.mines[seq]._lineup = lineup
        print 'save data', self.mines[seq].save_info()
        rdobj.hset(seq, self.mines[seq].save_info())

    def get_data(self, seq):
        label = 'mine'
        rdobj = mine_obj.getObj(label)
        info = rdobj.hget(seq)
        mine = PlayerField()
        mine.update_info(info)
        mine.detail_info()
        self.mines[seq] = mine

    def get_detail_info(self, seq):
        if seq in self.mines.keys():
            data = self.mines[seq].detail_info()
            self.save_data(seq)
            return data
        else:
            self.get_data(seq)
            return self.get_detail_info(seq)

    def get_info(self, seq):
        if seq in self.mines.keys():
            data = self.mines[seq].mine_info()
            self.save_data(seq)
            return data
        else:
            self.get_data(seq)
            return self.get_info(seq)

    def add_field(self, uid, seq, data):
        if uid in self.users:
            self.users[uid][seq] = 1
        else:
            self.users[uid]={seq:1}

        label = 'mine.%s' % uid
        rdobj = mine_obj.getObj(label)
        rdobj.hset(seq, 1)

        mine = PlayerField()
        mine.update_info(data)
        self.mines[seq] = mine

        label = 'mine'
        rdobj = mine_obj.getObj(label)
        rdobj.hset(seq, data)
        return True

    def get_lock(self, seq):
        label = 'mine.lock'
        mine_obj.getObj(label)
#         print 'mine_obj', mine_obj
        val = mine_obj.get(seq)
        if val == None:
            val = 0
        self.lock[seq] = int(val)
        return int(val)

    def lock_mine(self, uid, seq):
        if seq in self.lock:
            lock = self.lock.get(seq)
            if lock:
                return False
            else:
                self.lock[seq] = uid
                label = 'mine.lock'
                mine_obj.getObj(label)
                mine_obj.set(seq, uid)
            return True
        else:
            self.get_lock(seq)
            return self.lock_mine(uid, seq)

    def unlock_mine(self, uid, seq):
        self.lock[seq] = 0
        label = 'mine.lock'
        mine_obj.getObj(label)
        mine_obj.set(seq, 0)
        return True

    def settle(self, seq, result, uid=None, nickname=None, hold=1):
        logger.debug('settle %s %s %s %s %s', seq, result, uid, nickname, hold)
        warFogLootRatio = game_configs.base_config['warFogLootRatio']
        ret = PlayerField()
        harvest_a_nor = {}
        harvest_a_luc = {}
        harvest_a = {}
        harvest_b = {}

        self.get_detail_info(seq)
        tid = self.mines[seq]._tid
        srcname = self.mines[seq]._nickname
        ret.update_info(self.mines[seq].save_info())
        harvest_stone = {}
        harvest_stone.update(self.mines[seq]._normal)
        harvest_stone.update(self.mines[seq]._lucky)
        if self.mines[seq]._status == 2 or (self.mines[seq]._status == 1 and time.time() > self.mines[seq]._last_time):
            if result == True:
                self.mines[seq]._status = 3
        if result == True:
            if hold:
                self.mines[seq]._tid = uid
                self.mines[seq]._nickname = nickname

            for k, v in self.mines[seq]._normal.items():
                if v > 0:
                    harvest_a_nor[k] = int(v*warFogLootRatio)
                    self.mines[seq]._normal[k] = v - int(v*warFogLootRatio)
                    ret._normal = harvest_a_nor
                    harvest_b[k] = int(v*warFogLootRatio)
                    harvest_a[k] = v - int(v*warFogLootRatio)

            for k, v in self.mines[seq]._lucky.items():
                if v > 0:
                    harvest_a_luc[k] = int(v*warFogLootRatio)
                    self.mines[seq]._lucky[k] = v - int(v*warFogLootRatio)
                    ret._lucky = harvest_a_luc
                    harvest_b[k] = int(v*warFogLootRatio)
                    harvest_a[k] = v - int(v*warFogLootRatio)
            prize = []
            for k, v in harvest_a.items():
                if v > 0:
                    prize.append({108: [v, v, k]})
            logger.debug('pvp mine total:%s a:%s b:%s prize:%s',
                         harvest_stone, harvest_a, harvest_b, prize)
        self.save_data(seq)
        self.unlock_mine(uid, seq)

        ret.update_info(self.mines[seq].save_info())
        return ret.save_info(), tid, srcname

    def guard(self, uid, seq, nickname, data):
        self.get_info(seq)
        lock = self.lock_mine(uid, seq)
        if not lock:
            return 12440

        if self.mines[seq]._nickname!= nickname:
            self.unlock_mine(uid, seq)
            return 12441
        self.unlock_mine(uid, seq)
        self.save_data(seq, data)
        return 0

    def harvest(self, uid, seq):
        self.get_cur_data(now)
        self.get_detail_info(seq)
        normal = {}
        lucky = {}
        # print self._normal, self._lucky
        for k, v in self.mines[seq]._normal.items():
            normal[k] = v
            self.mines[seq]._normal[k] = 0
        for k, v in self.mines[seq]._lucky.items():
            lucky[k] = v
            self.mines[seq]._lucky[k] = 0

        self.mines[seq]._status = 3
        self.save_data(seq)

        return True, normal, lucky

    def get_toupdata(self, seq):
        self.get_detail_info(seq)
        data = self.mines[seq].save_info()

    def acc_mine_time(self, uid, seq, change_time):
        result = self.mines[seq].acc_mine_time(change_time)
        self.save_data(seq)
        return result
