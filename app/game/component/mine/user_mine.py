# -*- coding:utf-8 -*-
'''
Created on 2014-11-24

@author: hack
'''
import random
from shared.db_opear.configs_data.game_configs import base_config, mine_config,\
    shop_config
from app.game.component.Component import Component
import time
from app.game.redis_mode import tb_character_mine
import cPickle
from gfirefly.server.logobj import logger
from monster_mine import MineOpt


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
    PLAYER_SELF = 0
    PLAYER_FIELD = 1
    MONSTER_FIELD = 2
    CHEST = 3
    SHOP = 4
    COPY = 5
    _create = {PLAYER_SELF:"UserSelf",
               PLAYER_FIELD:"PlayerField",
               MONSTER_FIELD:"MonsterField",
               CHEST:"Chest",
               SHOP:"Shop",
               COPY:"Copy"}
    @classmethod
    def create(cls, stype, uid, nickname):
        if stype in cls._create:
            mine = eval(cls._create[stype])(uid, nickname)
            return mine
        return None
    
class ConfigData(object):
    def __init__(self):
        pass
        
    @classmethod
    def mine_ids(cls, mtype):
        mids = {}
        for mid in mine_config.keys():
            if mine_config[mid].type == mtype:
                mids[mid] = mine_config[mid].weight
        return mids
    
    @classmethod
    def mine(cls, mid):
        if mid in mine_config:
            return mine_config[mid]
        return None
    
    @classmethod
    def shopid_odds(cls, stype=7):
        sids = {}
        for sid in shop_config.keys():
            if shop_config[sid].type == stype:
                sids[sid]  = shop_config[sid].weight
        return sids

class Mine(object):
    """
    生成矿点
    """
    def __init__(self, tid=0):
        self._tid = tid
        self._type = 1 #矿点类型 1玩家初始矿，2野外矿，3神秘商人，4巨龙宝箱，5副本
        self._status = 1 #矿点状态1生产中，2可收获，3已枯竭，4空闲，5已领取，6副本已进入
        self._nickname = '' #昵称
        self._last_time = 0 #倒计时
        
    def mine_info(self):
        info = {}
        info['type'] = self._type
        info['status'] = self._status
        info['nickname'] = self._nickname
        return info
        
    def can_reset(self, uid):
        """
        可重置规则
        神秘商人，巨龙宝箱，副本
        自己的已枯竭的矿
        非自己的矿
        """
        if self._type in [3,4,5] or (self._status == 3 and self._type == 2 and self._tid == uid)  or self._tid != uid:
            return True
        return False
    
    @classmethod
    def create(cls, uid, nickname):
        pass
    
class UserSelf(Mine):
    """
    玩家矿
    """
    def __init__(self):
        self._mine_id = 0 #玩家矿和野外矿id
        self._normal_harvest = 0 #普通符文石最后一次收获时间
        self._special_harvest = 0 # 特殊符文石最后一次收获时间
        self._increase = 0 #增产时间
        self._stones = {} #当前产出符文石数量
    
    @classmethod
    def create(cls, uid, nickname):
        user_mine = cls()
        user_mine._tid = uid
        user_mine._type = MineType.PLAYER_FIELD
        user_mine._mine_id = ConfigData.mine_ids(MineType.PLAYER_FIELD).keys()[0]
        user_mine._status = 1
        user_mine._nickname = nickname
        user_mine._last_harvest = time.time()
        return user_mine
        
    def gen_stone(self, num, odds_dict, limit):
        #发放符文石
        now_data = sum(self._stones.values())
        if now_data >= limit:
            return
        for _ in range(0, num):
            stone_id = random_pick(odds_dict, sum(odds_dict.values()))
            if stone_id not in self._stones:
                self._stones[stone_id] = 1
            else:
                self._stones[stone_id] += 1
            now_data += 1
            if now_data >= limit:
                break
            
    def dat(self, end, start, dur):
        return int((end-start) / (dur*60))
        
    def compute(self, dur, per, now, harvest):
        num = 0 #产量
        if harvest >= self._increase:
            #没有增产
            dat = self.dat(now, harvest, dur)
            harvest += dat*(dur*60)
            num = dat*per
        else:
            if now <= self._increase:
                #增产还未结束，从上次结算到当前都在增产
                mine = ConfigData.mine(self._mine_id)
                ratio = mine.increase #增产比例
                dat = self.dat(now, harvest, dur)
                harvest += dat*(dur*60)
                num = int(dat * per * ratio)
            else:
                incr_dat = self.dat(self._increase, harvest, dur)
                dat1 = int(incr_dat * per * ratio) #增产部分
                nor_dat = self.dat(now, self._increase, dur)
                dat2 = (nor_dat*per) #未增产部分
                num = dat1+dat2
        return num
    
    def get_cur(self, now):
        #结算到当前的产出
        mine = ConfigData.mine(self._mine_id)
        if sum(self._stones.values()) >= mine.outputLimited:
            return self._stones
        normal = self.compute(mine.timeGroup1, mine.outputGroup1, now, self._normal_harvest)
        self.gen_stone(normal, mine.group1, mine.outputLimited)
        
        special = self.compute(mine.timeGroupR, mine.outputGroupR, now, self._special_harvest)
        self.gen_stone(special, mine.randomStoneId, mine.outputLimited)
        
        return self._stones
    
    def draw_stones(self):
        #领取产出
        stones = self._stones.copy()
        self._stones = {}
        return stones
    
    def mine_info(self):
        return Mine.mine_info(self)
        
    def detail_info(self):
        now = time.time()
        self.get_cur(now)
        if now >= self._increase:
            last_increase =  0
        else:
            last_increase = self._increase - now
        return 0, '', last_increase, self._stones, []  # ret, msg, last_increase, stones, heros
    
    def price(self):
        mine = ConfigData.mine(self._mine_id)
        return mine.increasePrice
    
    def acc_mine(self):
        #增产
        now = time.time()
        self.get_cur(now) #本次增产前结算之前的产出
        mine = ConfigData.mine(self._mine_id)
        if self._increase < now:
            self._increase = now + mine.increasTime * 60
            return mine.increasTime * 60
        else:
            self._increase += mine.increasTime * 60
            return self._increase - now
    
class PlayerField(Mine):
    """
    玩家占领的野外矿
    """
    def __init__(self):
        pass
    
    @classmethod
    def create(cls, uid, nickname, level=1):
        pass
    
    
class MonsterField(Mine):
    """
    野外矿
    """
    def __init__(self):
        self._mine_id = 0
        self._monster = []
        self._seq = 0
    
    @classmethod
    def create(cls, uid, nickname):
        monster_mine = cls()
        mine_ids = ConfigData.mine_ids(2)
        monster_mine._mine_id = random_pick(mine_ids, sum(mine_ids.values()))
        monster_mine._tid = uid
        monster_mine._type = MineType.MONSTER_FIELD
        monster_mine._status = 1
        monster_mine._nickname = "野怪"
        monster_mine._last_harvest = 0
        monster_mine._monster = ConfigData.mine(monster_mine._mine_id).monster
        monster_mine._seq = 'uid.%s' % time.time()
        return monster_mine
    
    def mine_info(self):
        pass
        
    def detail_info(self):
        pass
    
    def settle(self):
        MineOpt.add_mine(self._tid, self._seq, self)
    
class Chest(Mine):
    """
    宝箱
    """
    def __init__(self):
        pass
    
    @classmethod
    def create(cls, uid, nickname):
        user_mine = cls()
        user_mine._tid = uid
        user_mine._type = MineType.CHEST
        user_mine._status = 1
        user_mine._nickname = nickname
        return user_mine
        
    def mine_info(self):
        return Mine.mine_info(self)
    
    def draw_stones(self):
        if self._status == 1:
            self._status = 5
            return True
        return False
    
    def detail_info(self):
        info = {}
        return info
        
    
class Shop(Mine):
    """
    神秘商店
    """
    def __init__(self):
        self._shops = {}
        num = base_config['warFogShopItemNum']
        shopids = ConfigData.shopid_odds()
        for _ in range(num):
            shop_id = random_pick(shopids, sum(shopids.values()))
            self._shops[shop_id] = 0
            del shopids[shop_id]
            
    @classmethod
    def create(cls, uid, nickname):
        user_mine = cls()
        user_mine._tid = uid
        user_mine._type = MineType.SHOP
        user_mine._status = 1
        user_mine._nickname = nickname
        return user_mine
    
    def mine_info(self):
        return Mine.mine_info(self)
    
    def detail_info(self):
        return self._shops
    
    def draw_stones(self, shop_id):
        self._shops[shop_id] = 1
        
    def has_item(self, shop_id):
        if shop_id not in self._shops:
            return 12483, u"没有该商品"
        if self._shops[shop_id] == 1:
            return 12484, u"商品已购买"
        return 0, ""
    
class Copy(Mine):
    """
    秘境副本
    """
    def __init__(self):
        pass
    
    @classmethod
    def create(cls, uid, nickname):
        user_mine = cls()
        user_mine._tid = uid
        user_mine._type = MineType.COPY
        user_mine._status = 1
        user_mine._nickname = nickname
        return user_mine
    
    def mine_info(self):
        return Mine.mine_info(self)
    
    def detail_info(self):
        info = {}
        return info
        
    def draw_stones(self):
        self._status = 6
        return True
    
def get_num():
    pass

class UserMine(Component):
    def __init__(self, owner):
        self._update = True
        Component.__init__(self, owner)
        
        self._reset_day = '' #上次重置时间
        self._reset_times = 0 #已重置次数
        
        self._tby = '' #玩家活跃度周期
        self._lively = 0 #玩家活跃度，每两天刷新一次
        
        self._mine = {} #玩家当前搜索出的矿
        
    def init_data(self):
        mine_data = tb_character_mine.getObjData(self.owner.base_info.id)

        if mine_data:
            mine = mine_data.get('mine')
            all_mine = mine.get('1')
            if all_mine:
                self._mine = cPickle.loads(all_mine)
            else:
                self._mine = {}
            if 0 not in self._mine:
                self._mine[0] = UserSelf.create(self.owner.base_info.id, self.owner.base_info.base_name)
            self._reset_day = mine_data.get('reset_day', '')
            self._reset_times = mine_data.get('reset_times')
            self._tby = mine_data.get('day_before')
            self._lively = mine_data.get('lively')
        else:
            data = dict(id=self.owner.base_info.id,
                        mine={'1':cPickle.dumps(self._mine)},
                        reset_day=self._reset_day,
                        reset_times=self._reset_times,
                        day_before=self._tby,
                        lively=self._lively)
            tb_character_mine.new(data)
            
    def save_data(self):
        mine_obj = tb_character_mine.getObj(self.owner.base_info.id)
        if mine_obj:
            data = {'mine': {'1':cPickle.dumps(self._mine)},
                    'reset_day':self._reset_day,
                    'reset_times': self._reset_times,
                    'day_before':self._tby,
                    'lively':self._lively}
            mine_obj.update_multi(data)
        else:
            logger.error('cant find mine:%s', self.owner.base_info.id)
            
    def _reset_everyday(self):
        """
        每日更新内容
        """
        now = time.strftime("%Y%m%d", time.localtime(time.time()))
        if now != self._reset_day:
            self._reset_times = 0
            self._reset_day = now
            self._update = True
        today_before_yestoday = time.strftime("%Y%m%d", time.localtime(time.time() - 24*60*60*2))
        if today_before_yestoday != self._tby:
            self._tby = today_before_yestoday
            self._lively = 0
            self._update = True
            
    @property
    def reset_times(self):
        self._reset_everyday()
        vip_add = self.owner.vip_component.war_refresh_times
        free_everyday = base_config['totemRefreshFreeTimes']
        return vip_add + free_everyday - self._reset_times
    
    def add_lively(self, times):
        """
        设置活跃度
        """
        self._reset_everyday()
        self._lively += times
        self._update = True
        
    def can_search(self, position):
        """
        能否探索
        """
        num = base_config['warFogStrongpointNum']
        if len(self._mine) >= num or position in self._mine:
            return False
        return True
    
    def can_reset_free(self):
        self._reset_everyday()
        free_everyday = base_config['totemRefreshFreeTimes']
        if self._reset_times >= free_everyday:
            return False
        if len(self._mine) < base_config['warFogStrongpointNum']:
            return False
        return True
    
    def can_reset(self):
        self._reset_everyday()
        vip_add = self.owner.vip_component.war_refresh_times
        free_everyday = base_config['totemRefreshFreeTimes']
        if self._reset_times >= vip_add + free_everyday:
            return False
        if len(self._mine) < base_config['warFogStrongpointNum']:
            return False
        return True
    
    def reset_price(self):
        price_list = base_config['warFogRefreshPrice']
        if len(price_list) > self._reset_times:
            return price_list[-1]
        else:
            return price_list[self._reset_times]
        
    def reset_map(self):
        """
        重置地图
        """
        for pos in self._mine.keys():
            if self._mine[pos].can_reset(self.owner.base_info.id):
                del self._mine[pos]
                self._update = True
    
    def search_mine(self, position):
        odds = base_config['warFogStrongpointOdds']
        odds1 = base_config['warFogStrongpointOdds2']
        lively = False
        if self._lively >= 1:
            stype = random_pick(odds, sum(odds.values()))
            lively = True
        else:
            stype = random_pick(odds1, sum(odds.values()))
        if stype == MineType.COPY:
            num = get_num()
            if num >= base_config['warFogBossCriServer']:
                stype = MineType.MONSTER_FIELD
        if stype == MineType.PLAYER_FIELD:
            mine = MineType.create(stype, self.owner.base_info.id, self.owner.base_info.base_name, self.owner.level.level, lively)
        else:
            mine = MineType.create(stype, self.owner.base_info.id, self.owner.base_info.base_name)
        if not mine:
            mine = MineType.create(MineType.MONSTER_FIELD, self.owner.base_info.id, self.owner.base_info.base_name)
        self._mine[position] = mine
        return mine
    
    def mine_status(self):
        """
        查询所有矿点信息
        """
        mine_infos = []
        #self._mine[0] = UserSelf.create(self.owner.base_info.id, self.owner.base_info.base_name)
        for pos in self._mine.keys():
            mine_info = self._mine[pos].mine_info()
            mine_info['position'] = pos
            mine_infos.append(mine_info)
        return mine_infos
    
    def harvest(self, position):
        """
        收获
        """
        if position in self._mine:
            stones = self._mine[position].draw_stones()
            if stones:
                self._update = True
                return stones
        return None
    
    def shop_info(self, position):
        """
        查看神秘商店信息
        """
        if position in self._mine:
            mine = self._mine[position]
            if mine._type != MineType.SHOP:
                return []
            return mine.detail_info()
        
    def can_buy(self, position, shop_id):
        if position not in self._mine:
            return 12481, u"矿点不存在"
        if self._mine[position]._type != MineType.SHOP:
            return 12482, u"非神秘商店矿"
        ret = self._mine[position].has_item(shop_id)
        return ret
    
    def buy_shop(self, position, shop_id):
        """
        设置商店商品已购买
        """
        self._mine[position].draw_stones(shop_id)
        self._update = True
        
    def reward(self, position):
        #领取宝箱奖励
        if position in self._mine:
            if self._mine[position].draw_stones():
                self._update = True
                return True
            
    def detail_info(self, position):
        """
        查看矿点详细信息，初始矿和野外矿
        """
        if position in self._mine:
            detail_data =  self._mine[position].detail_info()
            self._update = True
            return detail_data
        return 12430, u"矿点不存在", 0, {}, []
    
    def price(self, position):
        return self._mine[position].price()
    
    def acc_mine(self):
        """
        增产
        """
        last_time = self._mine[0].acc_mine()
        self._update = True
        return last_time
    
    def settle(self, position):
        self._mine[position].setttle()