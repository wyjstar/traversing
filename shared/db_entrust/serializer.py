# -*- coding:utf-8 -*-
"""
created by server on 14-6-11下午4:09.
"""

import cPickle
from gfirefly.server.globalobject import GlobalObject


class SerializerMetaClass(type):

    def __call__(cls, *args, **kwargs):  # @NoSelf
        result = cls.__new__(cls, *args, **kwargs)
        if isinstance(result, cls):
            type(result).__init__(result, *args, **kwargs)
            if args:
                name_key = args[0].split(':')
                name = name_key[0]
            model_default_config = GlobalObject().json_model_default_config
            model_config = GlobalObject().json_model_config

            if model_default_config:
                for attr in model_default_config:
                    setattr(result, ('_%s' % attr), model_default_config[attr])
            if name in model_config:
                for attr in model_config[name]:
                    setattr(result, ('_%s' % attr), model_config[name][attr])

        return result


class Serializer(object):
    __metaclass__ = SerializerMetaClass

    def loads(self, data):
        """
        将一个dict转换成model对象实例
            data: dict对象
        """
        columns = self._def_attrs
        for attr in columns:
            if attr in data:
                if columns[attr] == "simple":
                    pass
                elif columns[attr] == "complex":
                    if data[attr]:
                        data[attr] = cPickle.loads(str(data[attr]))
                    else:
                        data[attr] = None
                else:
                    loads_func = getattr(self, columns[attr] + "_loads")
                    data[attr] = loads_func(data[attr])
        setattr(self, 'data', data)
        return data

    def dumps(self, data, shallow=False):

        columns = self._def_attrs
        for attr in columns:
            if attr in data:
                val = data[attr]
                if columns[attr] == "simple":
                    pass
                elif columns[attr] == "complex":
                    data[attr] = val if shallow else cPickle.dumps(val)
                else:
                    dumps_func = getattr(self, columns[attr] + "_dumps")
                    data[attr] = dumps_func(val)

        return data