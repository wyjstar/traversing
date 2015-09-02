# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:20.
"""
from app.game.redis_mode import tb_character_info
import json
import cPickle


class Mail_old(object):
    """ 邮件 """
    def __init__(self, mail_id='', character_id=0, sender_id=-1,
                 sender_name='', sender_icon=0, title='', content=u'',
                 mail_type=1, is_readed=False, send_time=0, read_time=0,
                 prize=0):
        """初始化邮件信息
        """
        self._id = mail_id  # 邮件的ID
        self._character_id = character_id  # ID
        self._title = title  # 邮件的主题
        self._sender_id = sender_id  # 发送人id
        self._sender_name = sender_name   # 发送者的昵称
        self._sender_icon = sender_icon
        self._mail_type = mail_type  # 邮件的类型（1.赠送  2.领奖 3.公告 4.消息  ）
        self._content = content  # 邮件的内容
        self._is_readed = is_readed  # 是否已读
        self._send_time = send_time  # 发送时间
        self._read_time = read_time  # 读邮件时间
        self._prize = prize  # 邮件物品包裹

    def init_data(self, mail_prop):
        self._character_id = mail_prop.get("character_id")
        self._title = mail_prop.get("title")
        self._sender_id = mail_prop.get("sender_id")
        self._sender_name = mail_prop.get("sender_name")
        self._sender_icon = mail_prop.get("sender_icon")
        self._mail_type = mail_prop.get("mail_type")
        self._content = mail_prop.get("content")
        self._is_readed = mail_prop.get("is_readed")
        self._send_time = mail_prop.get("send_time")
        self._read_time = mail_prop.get("read_time")
        self._prize = cPickle.loads(mail_prop.get("prize"))

    @property
    def mail_id(self):
        return self._id

    @property
    def mail_type(self):
        return self._mail_type

    @property
    def title(self):
        return self._title

    @property
    def content(self):
        return self._content

    @property
    def sender_id(self):
        return self._sender_id

    @property
    def sender_name(self):
        return self._sender_name

    @property
    def sender_icon(self):
        return self._sender_icon

    @property
    def send_time(self):
        return self._send_time

    @property
    def is_readed(self):
        return self._is_readed

    @is_readed.setter
    def is_readed(self, value):
        self._is_readed = value

    @property
    def prize(self):
        return self._prize

    @property
    def read_time(self):
        return self._read_time

    @read_time.setter
    def read_time(self, value):
        self._read_time = value

    def update(self, mail_pb):
        mail_pb.mail_id = self._id
        mail_pb.sender_id = self._sender_id
        mail_pb.sender_name = self._sender_name
        mail_pb.sender_icon = self._sender_icon
        mail_pb.title = self._title
        mail_pb.content = self._content
        mail_pb.mail_type = self._mail_type
        mail_pb.send_time = self._send_time
        mail_pb.is_readed = self._is_readed
        mail_pb.prize = json.dumps(self._prize)

    def mail_proerty_dict(self):
        mail_property = {
            'mail_id': self._id,
            'character_id': self._character_id,
            'sender_id': self._sender_id,
            'sender_name': self._sender_name,
            'sender_icon': self._sender_icon,
            'mail_type': self._mail_type,
            'title': self._title,
            'content': self._content,
            'is_readed': self._is_readed,
            'send_time': self._send_time,
            'prize': cPickle.dumps(self._prize)
        }
        return mail_property

    def save_data(self):
        prop = self.mail_proerty_dict()
        char_obj = tb_character_info.getObj(self._character_id).getObj('mails')
        result = char_obj.hset(self._id, prop)
        if not result:
            logger.error('save mail error!:%s', self._id)

    def delete(self):
        char_obj = tb_character_info.getObj(self._character_id).getObj('mails')
        result = char_obj.hdel(self._id)
        if not result:
            logger.error('del mail error!:%s', self._id)
