# -*- coding:utf-8 -*-
"""
created by server on 14-5-28下午4:41.
"""
from gfirefly.dbentrust.redis_manager import redis_manager
from gfirefly.dbentrust.redis_object import RedisObject
from gfirefly.dbentrust import util
import time


TIMEOUT = 1800


def _insert(args):
    record, pkname, mmname, cls = args
    pk = record[pkname]
    mm = cls(mmname + ':%s' % pk, pkname, data=record)
    mm.insert()
    return pk


class PKValueError(ValueError):
    def __init__(self, data):
        ValueError.__init__(self)
        self.data = data

    def __str__(self):
        return "new record has no 'PK': %s" % (self.data)


class MMode(RedisObject):
    """内存数据模型，最终对应到的是表中的一条记录
    """

    def __init__(self, name, pk, data={}):
        """
        """
        super(MMode, self).__init__(name, redis_manager)
        self._pk = pk
        self.data = data

    def update(self, key, values):
        return RedisObject.update(self, key, values)

    def update_multi(self, mapping):
        return RedisObject.update_multi(self, mapping)

    def get(self, key, default=None):
        value = RedisObject.get(self, key)
        if value is None and default is not None:
            return default
        return value

    def get_multi(self, keys):
        return RedisObject.get_multi(self, keys)

    def delete(self):
        return RedisObject.mdelete(self)

    def mdelete(self):
        RedisObject.mdelete(self)


class MFKMode(RedisObject):
    """外键内存数据模型
    """

    def __init__(self, name, pklist=[]):
        RedisObject.__init__(self, name, redis_manager)
        self.pklist = pklist


class MAdmin(RedisObject):
    """MMode对象管理，同一个MAdmin管理同一类的MMode，对应的是数据库中的某一种表
    """

    def __init__(self, name, pk, timeout=TIMEOUT, **kw):
        super(MAdmin, self).__init__(name, redis_manager)
        self._pk = pk

    def insert(self):
        RedisObject.insert(self)

    def load(self):
        mmname = self._name
        recordlist = util.ReadDataFromDB(mmname)
        for record in recordlist:
            pk = record[self._pk]
            mm = MMode(self._name + ':%s' % pk, self._pk)
            mm.loads(record)
            mm.insert()

    @property
    def madmininfo(self):
        """作为一个特性属性。可以获取这个madmin的相关信息
        """
        keys = self.__dict__.keys()
        info = self.get_multi(keys)
        return info

    def getAllPkByFk(self, fk):
        """根据外键获取主键列表
        """
        name = '%s_fk:%s' % (self._name, fk)
        fkmm = MFKMode(name)
        pklist = fkmm.pklist

        if pklist is not None:
            return pklist
        return None

    def getObj(self, pk):
        mm = MMode(self._name + ':%s' % pk, self._pk)
        return mm

    def getObjData(self, pk):
        # print pk,"pk++++++++++++++"
        mm = MMode(self._name + ':%s' % pk, self._pk)
        return mm

    def getObjList(self, pklist):
        """根据主键列表获取mmode对象的列表.\n
        >>> m = madmin.getObjList([1,2,3,4,5])
        """
        _pklist = []
        objlist = []

        for pk in pklist:
            mm = MMode(self._name + ':%s' % pk, self._pk)
            if mm.get('data'):
                objlist.append(mm)
            else:
                _pklist.append(pk)
        if _pklist:
            recordlist = util.GetRecordList(self._name, self._pk, _pklist)
            for record in recordlist:
                pk = record[self._pk]
                mm = MMode(self._name + ':%s' % pk, self._pk)
                mm.loads(record)
                mm.insert()
                objlist.append(mm)
        return objlist

    def deleteMode(self, pk):
        """根据主键删除内存中的某条记录信息.\n
        >>> m = madmin.deleteMode(1)
        """
        mm = self.getObj(pk)
        if mm:
            mm.delete()
        return True

    def new(self, data):
        """创建一个新的对象 """
        pk = data.get(self._pk)
        mm = MMode(self._name + ':%s' % pk, self._pk, data=data)
        mm.insert()
        return mm
