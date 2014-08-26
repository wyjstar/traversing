# -*- coding:utf-8 -*-
"""
created by server on 14-6-6上午11:05.
"""
from MySQLdb.cursors import DictCursor
import cPickle
from gfirefly.dbentrust.dbpool import dbpool
from shared.db_opear.configs_data.chip_config import ChipConfig
from shared.db_opear.configs_data.equipment.equipment_config import EquipmentConfig
from shared.db_opear.configs_data.equipment.equipment_strengthen_config import EquipmentStrengthenConfig
from shared.db_opear.configs_data.equipment.set_equipment_config import SetEquipmentConfig
from shared.db_opear.configs_data.hero_breakup_config import HeroBreakupConfig
from shared.db_opear.configs_data.item_config import ItemsConfig
from shared.db_opear.configs_data.link_config import LinkConfig
from shared.db_opear.configs_data.monster_config import MonsterConfig
from shared.db_opear.configs_data.monster_group_config import MonsterGroupConfig
from shared.db_opear.configs_data.pack.big_bag_config import BigBagsConfig
from shared.db_opear.configs_data.pack.small_bag_config import SmallBagsConfig
from shared.db_opear.configs_data.shop_config import ShopConfig
from shared.db_opear.configs_data.skill_buff_config import SkillBuffConfig
from shared.db_opear.configs_data.skill_config import SkillConfig
from shared.db_opear.configs_data.stage_config import StageConfig
from shared.db_opear.configs_data.soul_shop_config import SoulShopConfig
from shared.db_opear.configs_data.warriors_config import WarriorsConfig


print id(dbpool)
from shared.db_opear.configs_data.hero_config import HeroConfig
from shared.db_opear.configs_data.hero_exp_config import HeroExpConfig
from shared.db_opear.configs_data.base_config import BaseConfig
from shared.db_opear.configs_data.guild_config import GuildConfig


def init():
    hostname = "127.0.0.1"  #  要连接的数据库主机名
    user = "test"  #  要连接的数据库用户名
    password = "test"  #  要连接的数据库密码
    port = 8066  #  3306 是MySQL服务使用的TCP端口号，一般默认是3306
    dbname = "db_traversing"  #  要使用的数据库库名
    charset = "utf8"  #  要使用的数据库的编码
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)  ##firefly重新封装的连接数据库的方法，这一步就是初始化数据库连接池，这样你就可连接到你要使用的数据库了

init()


def get_config_value(config_key):
    """获取所有翻译信息
    """
    sql = "SELECT * FROM configs where config_key='%s';" % config_key
    conn = dbpool.connection()
    cursor = conn.cursor(cursorclass=DictCursor)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    if not result:
        return None
    data = {}
    for item in result:
        data[item['config_key']] = cPickle.loads(item['config_value'])
    return data

base_config = {}
hero_config = {}
hero_exp_config = {}
hero_breakup_config = {}
chip_config = {}
item_config = {}
small_bag_config = {}
big_bag_config = {}
equipment_config = {}  # 装备配置
equipment_strengthen_config = {}  # 装备强化等级消耗金币路线
set_equipment_config = {}
shop_config = {}
soul_shop_config = {}
link_config = {}
stage_config = {}
monster_config = {}
monster_group_config = {}
skill_config = {}
skill_buff_config = {}
guild_config = {}
warriors_config = {}


all_config_name = {
    'base_config': BaseConfig(),
    'hero_config': HeroConfig(),
    'hero_exp_config': HeroExpConfig(),
    'hero_breakup_config': HeroBreakupConfig(),
    'item_config': ItemsConfig(),
    'small_bag_config': SmallBagsConfig(),
    'big_bag_config': BigBagsConfig(),
    'equipment_config': EquipmentConfig(),
    'equipment_strengthen_config': EquipmentStrengthenConfig(),
    'set_equipment_config': SetEquipmentConfig(),
    'chip_config': ChipConfig(),
    'shop_config': ShopConfig(),
    'link_config': LinkConfig(),
    'stage_config': StageConfig(),
    'monster_config': MonsterConfig(),
    'monster_group_config': MonsterGroupConfig(),
    'skill_config': SkillConfig(),
    'skill_buff_config': SkillBuffConfig(),
    'guild_config': GuildConfig(),
    'soul_shop_config': SoulShopConfig(),
    'warriors_config': WarriorsConfig(),
}


class ConfigFactory(object):

    @classmethod
    def creat_config(cls, config_name, config_value):
        return all_config_name[config_name].parser(config_value)

for config_name in all_config_name.keys():
        game_conf = get_config_value(config_name)

        if not game_conf:
            continue
        objs = ConfigFactory.creat_config(config_name, game_conf[config_name])
        exec(config_name + '=objs')

if __name__ == '__main__':
    init()
    print warriors_config






