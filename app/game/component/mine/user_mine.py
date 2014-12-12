# -*- coding:utf-8 -*-
'''
Created on 2014-11-24

@author: hack
'''
import random
from shared.db_opear.configs_data.game_configs import base_config, mine_config,\
    shop_config, mine_match_config
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
    PLAYER_FIELD = 1
    MONSTER_FIELD = 2
    SHOP = 3
    CHEST = 4
    COPY = 5
    _create = {
               PLAYER_FIELD:"PlayerField",
               MONSTER_FIELD:"MonsterField",
               CHEST:"Chest",
               SHOP:"Shop",
               COPY:"Copy"}
    @classmethod
    def create(cls, stype, uid, nickname):
        if stype in cls._create:
            mine = eval(cls._create[stype]).create(uid, nickname)
            print 'MineType.create', stype, uid, nickname, type(mine)
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
        doors = shop_config.get(7)
        for one in doors:
            if one.type == stype:
                sids[one.id]  = one.weight
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
        self._normal_end = -1 #普通符文石生产结束时间－1不限
        self._special_harvest = 0 # 特殊符文石最后一次收获时间
        self._special_end = -1 #特殊符文石生产结束时间－1 不限
        self._increase = 0 #增产时间
        self._normal = {} #符文石
        self._lucky = {} #幸运石
    @classmethod
    def create(cls, uid, nickname):
        user_mine = cls()
        user_mine._tid = uid
        user_mine._type = MineType.PLAYER_FIELD
        user_mine._mine_id = ConfigData.mine_ids(MineType.PLAYER_FIELD).keys()[0]
        user_mine._status = 1
        user_mine._nickname = nickname
        user_mine._normal_harvest = time.time()
        user_mine._special_harvest = time.time()
        mine = ConfigData.mine(user_mine._mine_id)
        for nor_id in mine.group1.keys():
            user_mine._normal[int(nor_id)] = 0
        for sp_id in mine.randomStoneId.keys():
            user_mine._lucky[int(sp_id)] = 0
        return user_mine
        
    def gen_stone(self, num, odds_dict, limit, store):
        #发放符文石
        now_data = sum(self._normal.values()) + sum(self._lucky.values())
        if now_data >= limit:
            return
        for _ in range(0, num):
            stone_id = random_pick(odds_dict, sum(odds_dict.values()))
            stone_id = int(stone_id)
            if stone_id not in store:
                store[stone_id] = 1
            else:
                store[stone_id] += 1
            now_data += 1
            if now_data >= limit:
                break
            
    def dat(self, end, start, dur):
        return int((end-start) / (dur*60))
        
    def compute(self, dur, per, now, harvest, harvest_end):
        print 'compute', dur, per, now, harvest, harvest_end
        num = 0 #产量
        if now > harvest_end and harvest_end != -1:
            now = harvest_end
        if harvest >= self._increase:
            #没有增产
            dat = self.dat(now, harvest, dur)
            print 'dat', dat
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
        if sum(self._normal.values()) + sum(self._lucky.values()) >= mine.outputLimited:
            return
        print 'get_cur', self.__dict__
        normal = self.compute(mine.timeGroup1, mine.outputGroup1, now, self._normal_harvest, self._normal_end)
        self.gen_stone(normal, mine.group1, mine.outputLimited, self._normal)
        
        special = self.compute(mine.timeGroupR, mine.outputGroupR, now, self._special_harvest, self._special_end)
        self.gen_stone(special, mine.randomStoneId, mine.outputLimited, self._lucky)
        print 'get_cur', self.__dict__
    
    def draw_stones(self):
        #领取产出
        stones = {}
        for k, v in self._normal.items():
            stones[k] = v
        for k, v in self._lucky.items():
            stones[k] = v

        return stones
    
    def mine_info(self):
        return Mine.mine_info(self)
        
    def detail_info(self):
        now = time.time()
        self.get_cur(now)
        if now >= self._increase:
            last_increase =  0
        else:
            last_increase = self._increase
        mine = ConfigData.mine(self._mine_id)
        return 0, '', last_increase, mine.outputLimited, self._normal, self._lucky, []  # ret, msg, last_increase, limit, normal, lucky, heros
    
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
        else:
            self._increase += mine.increasTime * 60
        return self._increase
    
class PlayerField(UserSelf):
    """
    玩家占领的野外矿
    """
    def __init__(self):
        self._seq = 0
        self._lineup = None
        self._guard_time = 0 #保护时间
        self._mine_id = 0 #玩家矿和野外矿id
        self._normal_harvest = 0 #普通符文石最后一次收获时间
        self._normal_end = -1 #普通符文石生产结束时间－1不限
        self._special_harvest = 0 # 特殊符文石最后一次收获时间
        self._special_end = -1 #特殊符文石生产结束时间－1 不限
        self._increase = 0 #增产时间
        self._normal = {} #符文石
        self._lucky = {} #幸运石
    
    @classmethod
    def create(cls, uid, nickname, level, lively, sword):
        item = None
        for _,v in mine_match_config.keys():
            if lively == v.playerActivity and level >= v.playerLevel[0] and level <= v.playerLevel[1]:
                item = v
        rule_id = random_pick(item.proRule, sum(item.proRule.values()))
        rule = item.Rule[rule_id]
        if len(rule) < 8:
            return MonsterField.create(uid, nickname)
        else:
            isplayer, _, lowlevel, highlevel, minus, add, lowswordrate, highswordrate = rule
            if isplayer == 0:
                return MonsterField.create(uid, nickname)
            else:
                front = level - minus if level - minus >= lowlevel else lowlevel
                back = level + add if level + add <= highlevel else highlevel
                uids = MineOpt.rand_user("user_level", uid, front, back) #取玩家等级附近的玩家
                match_users = []
                for one_user in uids: #取战力匹配的玩家
                    user_sword = MineOpt.get_user("sword", one_user)
                    if user_sword < sword * lowswordrate or user_sword > highswordrate * sword:
                        continue
                    match_users.append(one_user)
                if not match_users:#没有匹配的玩家生成野怪矿
                    return  MonsterField.create(uid, nickname)
                match_mine = None
                for one_user in match_users:#随机玩家占领的野怪矿
                    mids = MineOpt.get_user_mines(one_user)
                    if mids:
                        mid = random.sample(mids,1)
                        if not mid:
                            continue
                        match_mine = MineOpt.get_mine(one_user, mid)
                        if not match_mine:
                            continue
                if not match_mine:#没有随到玩家占领的野怪矿，生成野怪矿
                    return MonsterField.create(uid, nickname)
                
    def start_battle(self):
        lock = MineOpt.lock(self._seq)
        if lock == 1:
            return True
        return False
    
    def settle(self):
        MineOpt.add_mine(self._tid, self._seq, self)
        MineOpt.unlock(self._seq)
        
    def upt(self):
        mine = MineOpt.get_mine(self._seq)
    
    def mine_info(self):
        self._upt()
        return UserSelf.mine_info(self)
    
    def detail_info(self):
        self.upt()
        return UserSelf.detail_info(self)
    
    def get_bule(self):
        return self._type, None
    
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
        print 'MonsterField'
        monster_mine = cls()
        mine_ids = ConfigData.mine_ids(2)
        print 'mine_ids', mine_ids
        monster_mine._mine_id = random_pick(mine_ids, sum(mine_ids.values()))
        monster_mine._tid = -1
        monster_mine._type = MineType.MONSTER_FIELD
        monster_mine._status = 1
        monster_mine._nickname = u"野怪"
        monster_mine._last_harvest = 0
        print 'create'
        #monster_mine._monster = ConfigData.mine(monster_mine._mine_id).monster
        monster_mine._seq = 'uid.%s' % time.time()
        print 'ret', monster_mine.__dict__
        return monster_mine
    
    def mine_info(self):
        return Mine.mine_info(self)
        
    def detail_info(self):
        pass
    
    def settle(self):
        mine = ConfigData.mine(self._mine_id)
        player_field = PlayerField()
        player_field._mine_id = self._mine_id #玩家矿和野外矿id
        self._normal_harvest = time.time() #普通符文石最后一次收获时间
        self._normal_end = self._normal_harvest + mine.timeLimited1 * 60 #普通符文石生产结束时间－1不限
        self._special_harvest = time.time() # 特殊符文石最后一次收获时间
        self._special_end = self._special_harvest + mine.timeLimitedR * 60 #特殊符文石生产结束时间－1 不限
        self._increase = 0 #增产时间
        self._stones = {} #当前产出符文石数量
        MineOpt.add_mine(self._tid, self._seq, player_field)
        return player_field
        
    def get_bule(self):
        return self._type, self._monster
    
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
        print 'Chest.draw_stones'
        print 'self._status', self._status
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
        print 'save_data', mine_obj
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
        return self._reset_times, free_everyday, vip_add+free_everyday
    
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
        if len(self._mine) >= num + 1:
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
        self._reset_times += 1       
    
    def search_mine(self, position):
        if position in self._mine:
            return self._mine[position]
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
        
        print 'stype', 3
        if stype == 1:
            stype = 2
        stype = 4
        if stype == MineType.PLAYER_FIELD:
            sword = 0
            mine = MineType.create(stype, self.owner.base_info.id, self.owner.base_info.base_name, self.owner.level.level, lively, sword)
        else:
            mine = MineType.create(stype, self.owner.base_info.id, self.owner.base_info.base_name)
        if not mine:
            mine = MineType.create(MineType.MONSTER_FIELD, self.owner.base_info.id, self.owner.base_info.base_name)
        self._mine[position] = mine
        print 'search_mine', position, mine.__dict__
        self._update = True
        return mine
    
    def mine_status(self):
        """
        查询所有矿点信息
        """
        mine_infos = []
        self._mine[0] = UserSelf.create(self.owner.base_info.id, self.owner.base_info.base_name)
        for pos in self._mine.keys():
            mine_info = self._mine[pos].mine_info()
            mine_info['position'] = pos
            mine_infos.append(mine_info)
        return mine_infos
    
    def mine_info(self, position):
        info = self._mine[position].mine_info()
        info['position'] = position
        return info
    
    def harvest(self, position):
        """
        收获
        """
        print 'harvest', position
        if position in self._mine:
            print '1111'
            stones = self._mine[position].draw_stones()
            print stones
            if stones:
                self._update = True
                return stones
        return {}
    
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
        print 'reward', position, self._mine.keys()
        if position in self._mine:
            print 'self._mine[position]', self._mine[position].__dict__
            if self._mine[position].draw_stones():
                self._update = True
                print 'reward123'
                return True
        print 'reward123123'
            
            
    def detail_info(self, position):
        """
        查看矿点详细信息，初始矿和野外矿
        """
        if position in self._mine:
            detail_data =  self._mine[position].detail_info()
            self._update = True
            return detail_data
        return 12430, u"矿点不存在", 0, 0, {}, {}, []
    
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
        
    def get_blue(self, position):
        if position in self._mine:
            self._mine[position].get_blue()
        return -1, None
    
    def mid(self, position):
        return self._mine[position]._mine_id