# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:48.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_mail_info, tb_character_mails
from app.game.core.mail import Mail
from shared.db_opear.configs_data.game_configs import BigBagsConfig
from shared.utils.pyuuid import get_uuid
import time


class CharacterMailComponent(Component):
    """角色邮件列表组件"""

    def __init__(self, owner):
        """
        @param owner: 当前玩家
        """
        super(CharacterMailComponent, self).__init__(owner)
        self._mails = {}

    def init_data(self):
        pid = self.owner.base_info.id
        character_mails = tb_character_mails.getObjData(pid)
        if not character_mails:
            # 没有邮件列表数据
            data = {
                'id': pid,
                'mail_ids': [],
            }
            tb_character_mails.new(data)
            return

        mail_ids = character_mails.get('mail_ids')

        if not mail_ids:
            return

        for mail_id in mail_ids:
            mail = Mail(mail_id=mail_id)
            mail.init_data()
            self._mails[mail_id] = mail

    def new_mail_data(self, mail):
        character_id = self.owner.base_info.id
        mail_property = mail.mail_proerty_dict()

        data = {
            'id': mail.mail_id,
            'character_id': character_id,
            'property': mail_property
        }
        tb_mail_info.new(data)

    def add_exist_mail(self, mail):
        self._mails[mail.mail_id] = mail

    def add_mail(self, sender_id, sender_name, title, content, mail_type, send_time, bag):
        """添加邮件"""
        mail_id = get_uuid()
        character_id = self.owner.base_info.id

        mail = Mail(mail_id=mail_id, character_id=character_id,
                    sender_id=sender_id, sender_name=sender_name,
                    title=title, content=content,
                    mail_type=mail_type, send_time=send_time, bag=bag)
        self._mails[mail_id] = mail
        self.new_mail_data(mail)
        self.save_data()

    def get_mails(self):
        """获取角色邮件列表
        """
        return self._mails.values()

    def get_mail(self, mail_id):
        """根据ID获取邮件"""
        return self._mails.get(mail_id)

    def delete_mail(self, mail_id):
        if not mail_id in self._mails:
            return
        del self._mails[mail_id]
        self.save_data()
        tb_character_mails.deleteMode(mail_id)

    def delete_mails(self, mail_ids):
        """批量删除"""
        for mail_id in mail_ids:
            self.delete_mail(mail_id)

    def save_data(self):
        mail_ids = []
        character_id = self.owner.base_info.id
        for mail_id in self._mails.keys():
            mail_ids.append(mail_id)
        character_mails = tb_character_mails.getObj(character_id)
        character_mails.update('mail_ids', mail_ids)