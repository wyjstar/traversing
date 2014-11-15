# coding: utf-8
# Created on 2014-10-24
# Author: jiang

from app.game.component.Component import Component

class MailComponent(Component):
    """ 邮件组件
    """
    TYPE_PRESENT = 1
    TYPE_AWARD = 2
    TYPE_ANNOUCEMENT = 3
    TYPE_MESSAGE = 4