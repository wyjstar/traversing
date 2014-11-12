# -*- coding:utf-8 -*-
"""
created by server on 14-6-17下午5:29.
"""


class BaseConfig(object):

    def parser(self, config_value):
        def convert_keystr2num(d):
            for k in d.keys():
                nk = None
                v = d[k]
                try:
                    nk = eval(k)
                except:
                    pass
                if nk is not None:
                    del d[k]
                    d[nk] = v
                if isinstance(v, dict):
                    convert_keystr2num(v)

        for k, v in config_value.items():
            if isinstance(v, dict):
                convert_keystr2num(v)
        return config_value
