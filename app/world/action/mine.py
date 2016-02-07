# -*- coding:utf-8 -*-
"""
created by spinx on 15-11-2
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
from shared.common_logic.mine import get_cur_data
import cPickle
import time

tb_mine = RedisObject('tb_mine')

seq_index = 1

user_mine = {}
rdobj = tb_mine.hgetall()
for k, v in rdobj.items():
    seq = int(k)
    seq_index = max(seq, seq_index)
    user_mine[seq] = v

print seq_index
print 'load mine', user_mine


@rootserviceHandle
def mine_add_field_remote(uid, data):
    """
    玩家攻占野怪矿
    @param nickname: 昵称
    """
    global seq_index
    seq_index += 1
    seq = seq_index

    logger.debug('add mine remote:%s', seq)

    if seq in user_mine:
        logger.error('seq is exist:%s', seq)
        return 0

    user_mine[int(seq)] = data

    tb_mine.hset(seq, data)
    return seq


@rootserviceHandle
def mine_settle_remote(uid, seq, fight_result, nickname, hold):
    result = {'result': True, 'normal': {}, 'lucky': {}}

    logger.debug('settle %s %s %s %s %s',
                 seq, fight_result, uid, nickname, hold)

    if seq not in user_mine:
        print 'not in ', seq, type(seq)
        for s in user_mine:
            print '__', s, type(s)
    _mine = user_mine[int(seq)]

    if uid == _mine['uid']:
        logger.error('mine settle remote uid is same: %s-%s',
                     uid, _mine['uid'])

        result['result'] = False
        return cPickle.dumps(result)

    result['old_uid'] = _mine['uid']
    result['old_nickname'] = _mine['nickname']
    result['uid'] = uid
    result['nickname'] = nickname

    if fight_result is True:
        if hold:
            _mine['uid'] = uid
            _mine['nickname'] = nickname

        get_cur_data(_mine, int(time.time()))
        for k, v in _mine['normal'].items():
            result['normal'][k] = v
            _mine['normal'][k] = 0
        for k, v in _mine['lucky'].items():
            result['lucky'][k] = v
            _mine['lucky'][k] = 0

        if time.time() > _mine['last_time']:
            _mine['status'] = 3

        tb_mine.hset(seq, _mine)

    print _mine, result

    return cPickle.dumps(result)


@rootserviceHandle
def mine_harvest_remote(uid, seq):
    result = {'result': True, 'normal': {}, 'lucky': {}}

    _mine = user_mine[int(seq)]

    if uid != _mine['uid']:
        logger.error('mine harvest remote uid changed:%s-%s',
                     uid, _mine['uid'])
        result['result'] = False
        return cPickle.dumps(result)

    get_cur_data(_mine, int(time.time()))
    for k, v in _mine['normal'].items():
        result['normal'][k] = v
        _mine['normal'][k] = 0
    for k, v in _mine['lucky'].items():
        result['lucky'][k] = v
        _mine['lucky'][k] = 0

    _mine['status'] = 3

    tb_mine.hset(seq, _mine)

    return cPickle.dumps(result)


@rootserviceHandle
def acc_mine_time_remote(uid, seq, change_time):
    _mine = user_mine[int(seq)]

    if uid != _mine['uid']:
        logger.error('acc mine time uid changed:%s-%s',
                     uid, _mine['uid'])
        return False

    acc_mine_time(seq, _mine, change_time)
    return True


def guild_seek_help(seq, uid):
    if type(seq) is unicode:
        seq = seq.encode('utf-8')

    _mine = user_mine.get(seq)

    if not _mine or uid != _mine['uid']:
        logger.error('acc mine time uid changed:%s-%s',
                     uid, _mine['uid'])
        return False
    if _mine['seek_help']:
        return False

    _mine['seek_help'] = 1
    tb_mine.hset(seq, _mine)
    return True


def check_guild_seek_help(seq, uid):
    if type(seq) is unicode:
        seq = seq.encode('utf-8')

    _mine = user_mine.get(seq)

    if not _mine or uid != _mine['uid']:
        logger.error('acc mine time uid changed:%s-%s',
                     uid, _mine['uid'])
        return False
    if time.time() >= _mine['last_time']:
        return False
    return True


def guild_help(seq, uid, pid, shorten_time):  # uid矿主人ID，pid帮助人ID
    if type(seq) is unicode:
        seq = seq.encode('utf-8')

    _mine = user_mine.get(seq)

    if not _mine or uid != _mine['uid']:
        logger.error('acc mine time uid changed:%s-%s',
                     uid, _mine['uid'])
        return False
    if time.time() >= _mine['last_time']:
        return False
    # 加速
    acc_mine_time(seq, _mine, shorten_time)
    return True


def acc_mine_time(seq, mine, change_time):
    print change_time, '=================bbb1'
    mine['normal_harvest'] -= change_time
    mine['lucky_harvest'] -= change_time
    mine['normal_end'] -= change_time
    mine['lucky_end'] -= change_time
    mine['last_time'] -= change_time
    tb_mine.hset(seq, mine)
