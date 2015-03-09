# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import gate
from shared.utils.const import const

if const.CHANNEL == "tencent":
    import login_Tencent
elif const.CHANNEL == "taiwan":
    import login_MA
