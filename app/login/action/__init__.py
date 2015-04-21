# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import gate
from shared.utils.const import const
from gfirefly.server.globalobject import GlobalObject

if GlobalObject().allconfig["deploy"]["channel"]== "tencent":
    import login_Tencent
elif GlobalObject().allconfig["deploy"]["channel"]== "taiwan":
    import login_MA
