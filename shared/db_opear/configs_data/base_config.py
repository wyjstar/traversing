# -*- coding:utf-8 -*-
"""
created by server on 14-6-17下午5:29.
"""
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class BaseConfig(object):

    def parser(self, config_value):
        for k, v in config_value.items():
            if isinstance(v, dict):
                convert_keystr2num(v)

        cw = config_value.get('cookingWineOutputCrit')
        for d in cw.values():
            count = 0
            for k, v in d.items():
                count += v
                d[k] = count

        world_boss = dict(
                open_level = config_value.get("worldboss_open_level"),
                free_fight_times = config_value.get("worldbossFightTimes"),
                rank_rewards = config_value.get("hurt_rewards_worldboss_rank"),
                hurt_rank_rewards = config_value.get("worldbossHurtRankRewards"),
                accumulated_rewards = config_value.get("worldbossHurtReward"),
                kill_rewards = config_value.get("kill_rewards_worldboss"),
                last_kill_rewards = config_value.get("worldbossKillRewards"),
                time_to_upgrade = config_value.get("time_kill_worldboss_to_upgrade"),
                lucky_hero_1 = config_value.get("lucky_hero_1"),
                lucky_hero_2 = config_value.get("lucky_hero_2"),
                lucky_hero_3 = config_value.get("lucky_hero_3"),
                lucky_hero_1_num = config_value.get("lucky_hero_1_num"),
                lucky_hero_2_num = config_value.get("lucky_hero_2_num"),
                lucky_hero_3_num = config_value.get("lucky_hero_3_num"),
                debuff_skill = config_value.get("debuff_skill"),

                coin_inspire_atk = config_value.get("worldbossInspireAtk"),
                coin_inspire_price = config_value.get("goldcoin_inspire_price"),
                coin_inspire_price_multi = config_value.get("goldcoin_inspire_price_multiple"),
                coin_inspire_limit = config_value.get("goldcoinInspireLimited"),
                coin_inspire_cd = config_value.get("goldcoin_inspire_CD"),

                gold_inspire_atk = config_value.get("worldbossInspireAtkMoney"),
                gold_inspire_price = config_value.get("money_inspire_price"),
                gold_inspire_price_multi = config_value.get("money_inspire_price_multiple"),
                gold_inspire_limit = config_value.get("moneyInspireLimited"),
                gold_inspire_cd = config_value.get("money_inspire_CD"),

                free_relive_time = config_value.get("free_relive_time"),
                gold_relive_price = config_value.get("money_relive_price"),
                in_rewards = config_value.get("worldbossParticipationRewards"),
                )
        config_value["world_boss"] = world_boss

        mine_boss = dict(
                open_level = config_value.get("warFogBossOpenLevel"),
                free_fight_times = config_value.get("warFogBossFightTimes"),
                rank_rewards = config_value.get("warFogBossHurtRewardsRank"),
                kill_rewards = config_value.get("warFogBossKillRewards"),
                lucky_hero_1 = config_value.get("warFogBossLuckyHero_1"),
                lucky_hero_2 = config_value.get("warFogBossLuckyHero_2"),
                lucky_hero_3 = config_value.get("warFogBossLuckyHero_3"),
                lucky_hero_1_num = config_value.get("warFogBossLuckyHeroNum1"),
                lucky_hero_2_num = config_value.get("warFogBossLuckyHeroNum2"),
                lucky_hero_3_num = config_value.get("warFogBossLuckyHeroNum3"),
                debuff_skill = config_value.get("warFogBossDebuffSkill"),

                coin_inspire_atk = config_value.get("warFogBossInspireAtk"),
                coin_inspire_price = config_value.get("warFogBossGoldcoinInspirePrice"),
                coin_inspire_price_multi = config_value.get("warFogBossGoldcoinInspirePriceMultiple"),
                coin_inspire_limit = config_value.get("warFogBossGoldcoinInspireLimited"),
                coin_inspire_cd = config_value.get("warFogBossGoldcoinInspireCD"),

                gold_inspire_atk = config_value.get("warFogBossInspireAtkMoney"),
                gold_inspire_price = config_value.get("warFogBossMoneyInspirePirce"),
                gold_inspire_price_multi = config_value.get("warFogBossMoneyInspirePirceMultiple"),
                gold_inspire_limit = config_value.get("warFogBossMoneyInspireLimited"),
                gold_inspire_cd = config_value.get("warFogBossMoneyInspireCD"),

                free_relive_time = config_value.get("warFogBossFreeReliveTime"),
                gold_relive_price = config_value.get("warFogBossMoneyRelivePrice")
                )
        config_value["mine_boss"] = mine_boss

        config_value['arena_times_buy_price'] = parse(config_value['arena_times_buy_price'])


        # modify equipment prefix
        equPrefix = {}
        for _, v in config_value.get("equPrefix").items():
            if v[0] not in equPrefix:
                equPrefix[v[0]] = []
            equPrefix[v[0]].append(v[1:])
        config_value["equPrefix"] = equPrefix
        config_value["guildContribution"] = parse(config_value["guildContribution"])
        config_value["AnimalOpenConsume"] = parse(config_value["AnimalOpenConsume"])
        config_value["Worship2"] = parse(config_value["Worship2"])
        config_value["AreWorship2"] = parse(config_value["AreWorship2"])
        config_value["indianaIteam"] = parse(config_value["indianaIteam"])
        config_value["indianaTrucePrice"] = parse(config_value["indianaTrucePrice"])
        config_value["indianaConsume"] = parse(config_value["indianaConsume"])
        config_value["stonesynthesis"] = parse(config_value["stonesynthesis"])
        config_value["CoinCardFirst"] = parse(config_value["CoinCardFirst"])
        config_value["travelExpend"] = parse(config_value["travelExpend"])
        config_value["CardTimeCumulate"] = parse(config_value["CardTimeCumulate"])
        config_value["CardFirst"] = parse(config_value["CardFirst"])
        config_value["sweepNeedItem"] = parse(config_value["sweepNeedItem"])
        config_value["arena_win_points"] = parse(config_value["arena_win_points"])
        config_value["arenaRankUpRewards"] = parse(config_value["arenaRankUpRewards"])
        config_value["arenaRevengeRewards"] = parse(config_value["arenaRevengeRewards"])
        config_value["price_sweep"] = parse(config_value["price_sweep"])
        config_value["totemRefreshItem"] = parse(config_value["totemRefreshItem"])
        config_value["arenaConsume"] = parse(config_value["arenaConsume"])
        #config_value["CoinCardCumulateTimes"] = parse(config_value["CoinCardCumulateTimes"])
        config_value["CoinCardCumulate"] = parse(config_value["CoinCardCumulate"])
        #config_value["CardCumulateTimes"] = parse(config_value["CardCumulateTimes"])
        config_value["CardCumulate"] = parse(config_value["CardCumulate"])

        # modify cook data
        cooking_data = config_value['cookingWinePrice']
        for k, v in cooking_data.items():
            cooking_data[k] = [parse(_) for _ in v]

        # 小伙伴支援价格
        supportPrice = {}
        supportPriceMax = 0
        for k, v in config_value["supportPrice"].items():
            supportPrice[k] = parse(v)
            if supportPrice[k] > supportPriceMax:
                supportPriceMax = supportPrice[k]

        config_value["supportPrice"] = supportPrice
        config_value["supportPriceMax"] = supportPriceMax

        overcome_rewars = config_value['ggzjReward']
        rewards = {}
        for k, v in overcome_rewars.items():
            rewards[k] = parse(v)
        config_value['ggzjReward'] = rewards

        return config_value
