# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
@remoteserviceHandle('gate')
def create_guild_801(data, player):
    """创建公会 """
    args = CreateGuildRequest()
    args.ParseFromString(data)
    g_name = args.name
    response = GuildCommonResponse()
    p_id = player.base_info.id
    g_id = player.guild.g_id

    if base_config.get('create_level') > player.level.level:
        response.result = False
        response.message = "等级不够"
        return response.SerializeToString()

    if base_config.get('create_money') > player.finance.gold:
        response.result = False
        response.message = "元宝不足"
        return response.SerializeToString()

    if g_id != 0:
        response.result = False
        response.message = "您已加入公会"
        return response.SerializeToString()

    if not g_name:
        response.result = False
        response.message = "公会名不能为空"
        return response.SerializeToString()

    match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]', unicode(g_name, "utf-8"))
    if match:
        response.result = False
        response.message = "公会名不合法"
        return response.SerializeToString()

    if trie_tree.check.replace_bad_word(g_name).encode("utf-8") != g_name:
        response.result = False
        response.message = "公会名不合法"
        return response.SerializeToString()

    if len(g_name) > 18:
        response.result = False
        response.message = "名称超过字数限制"
        return response.SerializeToString()

    # 判断有没有重名
    guild_name_data = tb_guild_name.getObjData(g_name)
    if guild_name_data:
        response.result = False
        response.message = "此名已存在"
        return response.SerializeToString()

    # 创建公会
    guild_obj = Guild()
    guild_obj.create_guild(p_id, g_name)

    add_guild_to_rank(guild_obj.g_id, 1)

    data = {'g_name': g_name,
            'g_id': guild_obj.g_id}
    tb_guild_name.new(data)

    player.guild.g_id = guild_obj.g_id
    player.guild.worship = 0
    player.guild.worship_time = 1
    player.guild.contribution = 0
    player.guild.all_contribution = 0
    player.guild.k_num = 0
    player.guild.position = 1
    player.guild.save_data()
    guild_obj.save_data()
    player.finance.gold -= base_config.get('create_money')
    player.finance.save_data()

    # 加入公会聊天
    login_guild_chat(player.guild.g_id)

    response.result = True
    return response.SerializeToString()