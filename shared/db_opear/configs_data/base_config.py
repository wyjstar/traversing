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
                kill_rewards = config_value.get("kill_rewards_worldboss"),
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
                gold_relive_price = config_value.get("money_relive_price")
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
        config_value["CardFirst"] = parse(config_value["CardFirst"])

        # modify cook data
        cooking_data = config_value['cookingWinePrice']
        for k, v in cooking_data.items():
            cooking_data[k] = [parse(_) for _ in v]

        return config_value
