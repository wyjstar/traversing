# -*- coding:utf-8 -*-
from shared.utils.mail_helper import deal_mail
from app.game.action.root import netforwarding
from gfirefly.server.logobj import logger
import traceback


def send_mail(**args):
    mail_data, receive_id = deal_mail(**args)
    if not netforwarding.push_message('receive_mail_remote',
                                      receive_id, mail_data):
        logger.error('mail push message fail')
        traceback.print_stack()
