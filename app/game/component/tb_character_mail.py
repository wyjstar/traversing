# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:48.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_mail_info, tb_character_mails
from app.game.core.mail import Mail
from shared.db_opear.configs_data.game_configs import BigBagsConfig


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
            tb_mail_info.new(data)
            return

        mail_ids = character_mails.get('mail_ids')

        if not mail_ids:
            return

        for mail_id in mail_ids:
            mail = Mail(mail_id=mail_id)
            mail.init_data()
            self._mails[mail_id] = mail

    def add_mail(self, mail):
        self._mails[mail.mail_id] = mail
    
    def get_mails(self):
        """获取角色邮件列表
        """
        return self._mails.values()

    def get_mail(self, mail_id):
        """根据ID获取邮件"""
        return self._mails.get(mail_id)

    def delete_mail(self, mail_id):
        del self._mails[mail_id]
        self.save_data()
        tb_character_mails.deleteMode(mail_id)

    def delete_mails(self, mail_ids):
        """批量删除"""
        for mail_id in mail_ids:
            self.delete_mail(mail_id)

    def get_gives(self, mail_ids):
        player = self.owner
        for mail_id in mail_ids:
            player.stamina += 2

        self.delete_mails(mail_ids)
        player.save_data()

    def send_mail(self, receiver_id, mail_type, title, content):
        """发送邮件
        @param receiver_id: int 发送者的ID
        @param title: str 邮件的标题
        @param content: str 邮件的内容
        @param mail_type: int 邮件的类型
        """
        pass

    def save_data(self):
        mail_ids = []
        character_id = self.owner.base_info.id
        for mail_id in self._mails.keys():
            mail_ids.append(mail_id)
        character_heros = tb_character_mails.getObj(character_id)
        character_heros.update('mail_ids', mail_ids)