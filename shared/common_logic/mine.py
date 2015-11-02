# -*- coding:utf-8 -*-
"""
Created on 2015-10-29

@author: sphinx
"""
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
import random


def random_pick(odds_dict, num_top=1):
    x = random.uniform(0, num_top)
    odds_cur = 0.0
    for item, item_odds in odds_dict.items():
        if item_odds == 0:
            continue
        odds_cur += item_odds
        if x <= odds_cur:
            return item
    return None


def gen_stone(num, odds_dict, limit, store, now_data):
    # 发放符文石
    if now_data >= limit:
        logger.debug('gen_stone:%s >= %s', now_data, limit)
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
            mine = game_configs.mine_config[mine_id]
            ratio = mine.increase  # 增产比例
            data = dat(now, harvest, dur)
            # harvest += dat*(dur*60)
            start = harvest + data*(dur*60)
            num = int(data * per * (1+ratio))
        else:
            mine = game_configs.mine_config[mine_id]
            ratio = mine.increase  # 增产比例
            incr_dat = dat(increase, harvest, dur)
            dat1 = int(incr_dat * per * (1+ratio))  # 增产部分
            nor_dat = dat(now, increase, dur)
            dat2 = (nor_dat*per)  # 未增产部分
            num = dat1+dat2
            # harvest += int(num * (dur*60))
            start = harvest + int(num * (dur*60))

    return num, start


def get_cur(mine_id, now_data, harvest, start, end, now, increase, stype):
    # 结算到当前的产出
    mine = game_configs.mine_config.get(mine_id)
    now_data = min(now_data, mine.outputLimited)
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


def get_cur_data(mine, now):
    now_data = sum(mine['normal'].values()) + sum(mine['lucky'].values())
    last, stone = get_cur(mine['mine_id'],
                          now_data,
                          mine['normal'],
                          mine['normal_harvest'],
                          mine['normal_end'],
                          now,
                          mine.get('increase', 0),
                          1)
    mine['normal_harvest'] = last
    mine['normal'] = stone
    now_data = sum(mine['normal'].values()) + sum(mine['lucky'].values())
    last, stone = get_cur(mine['mine_id'],
                          now_data,
                          mine['lucky'],
                          mine['lucky_harvest'],
                          mine['lucky_end'],
                          now,
                          mine.get('increase', 0),
                          2)
    mine['lucky_harvest'] = last
    mine['lucky'] = stone
