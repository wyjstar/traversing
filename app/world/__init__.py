# -*- coding:utf-8 -*-
"""
created by server on 14-11-9下午5:11.
"""
import action
from shared.time_event_manager.te_manager import te_manager
from shared.utils.ranking import Ranking
import time
from gtwisted.core import reactor
from app.world.core.rank_helper import tick_rank, do_tick_rank
from app.world.core.limit_hero import tick_limit_hero
from app.world.core.hjqy_boss import hjqy_manager


# 初始化工会排行
Ranking.init('LevelRank1', 99999)
Ranking.init('LevelRank2', 99999)
Ranking.init('PowerRank1', 99999)
Ranking.init('PowerRank2', 99999)
Ranking.init('StarRank1', 99999)
Ranking.init('StarRank2', 99999)
Ranking.init('LimitHeroRank', 99999)


# do_tick_rank()
te_manager.add_event(24*60*60, 2, do_tick_rank)


te_manager.add_event(24*60*60, 2, hjqy_manager.send_rank_reward_mails)

tick_limit_hero()

te_manager.deal_event()
