# -*- coding:utf-8 -*-
"""
created by server on 14-8-27下午4:16.
"""

try:
    from scribe import scribe
    from thrift.transport import TTransport, TSocket
    from thrift.protocol import TBinaryProtocol
    SCRIBE_AVAILABLE = True    # 检查scribe相关库正常，不要影响业务系统
except ImportError, e:
    print '<------->'
    print e
    SCRIBE_AVAILABLE = False

class Singleton(type):
    '''this is a meta class for Singleton，just ommit it '''
    def __init__(cls, name, bases, dic):
        super(Singleton, cls).__init__(name, bases, dic)
        cls.instance = None

    def __call__(cls, *args, **kwargs):  # @NoSelf
        if cls.instance is None:
            cls.instance = super(Singleton, cls).__call__(*args, **kwargs)
        return cls.instance

class _Transport(object):
    '''
    use this class as a raw socket
    '''
    def __init__(self, host, port, timeout=None, unix_socket=None):
        self.host = host
        self.port = port
        self.timeout = timeout # ms
        self._unix_socket = unix_socket
        self._socket = TSocket.TSocket(self.host, self.port, self._unix_socket)
        self._transport = TTransport.TFramedTransport(self._socket)

    def __del__(self):
        self._socket.close()

    def connect(self):
        try:
            if self.timeout:
                self._socket.settimeout(self.timeout)

            if not self._transport.isOpen():
                self._transport.open()
            else:
                pass
        except Exception, e:
            self.close()

    def isOpen(self):
        return self._transport.isOpen()

    def get_trans(self):
        return self._transport

    def close(self):
        self._transport.close()

import time
class ScribeClient(object):
    '''a simple scribe client'''
    __metaclass__ = Singleton

    def __init__(self, host, port, timeout=None, unix_socket=None):
        self._transObj = _Transport(host, port, timeout=timeout, unix_socket=unix_socket)
        self._protocol = TBinaryProtocol.TBinaryProtocol(trans=self._transObj.get_trans(), strictRead=False, strictWrite=False)
        self.client = scribe.Client(iprot=self._protocol, oprot=self._protocol)
        self._transObj.connect()


    def log(self, category, message):
        '''specify a category and send the message'''
        message = time.strftime('%H:%M:%S') + '\t' + message # add timestamp before log
        log_entry = scribe.LogEntry(category=category, message=message)
        try:
            self.client.Log([log_entry])
        except Exception, e:
            self._transObj.close()
            self._transObj.connect()
            if self._transObj.isOpen():
                self.client.Log([log_entry])
            else:
                pass

    @classmethod
    def instance(cls):
        '''create a Scribe Client'''
        if not hasattr(cls, '_instance'):
            cls._instance = cls()
