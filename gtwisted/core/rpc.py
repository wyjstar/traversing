# coding:utf8
'''
Created on 2014年2月22日
这里定义了两个服务之间进行接口调用的过程
@author:  lan (www.9miao.com)
'''
from gtwisted.core.protocols import BaseProtocol
from gtwisted.core.protocols import ClientFactory
from gtwisted.core.protocols import ServerFactory
from gtwisted.core.asyncresultfactory import AsyncResultFactory
from gtwisted.core.error import RPCDataTooLongError
from gevent.timeout import Timeout
from gevent.pool import Pool
from gfirefly.server.logobj import logger
import struct
import rpc_pb2
import marshal

ASK_SIGNAL = "ASK"  # 请求结果的信号
NOTICE_SIGNAL = "NOTICE"  # 仅做通知的信号，不要求返回值
ANSWER_SIGNAL = "ANSWER"  # 返回结果值的信号
DEFAULT_TIMEOUT = 60  # 默认的结果放回超时时间
RPC_DATA_MAX_LENGTH = 1024 * 1024  # rpc数据包允许的最大长度

GEVENT_POOL = Pool(500)


def _write_parameter(proto, arg):
    if isinstance(arg, str):
        proto.proto_param = arg
    elif isinstance(arg, bool):
        proto.bool_param = arg
    elif isinstance(arg, unicode):
        proto.string_param = arg
    elif isinstance(arg, int) or isinstance(arg, long):
        proto.int_param = arg
    elif isinstance(arg, float):
        proto.float_param = arg
    elif arg is None:
        proto.is_null = True
    elif isinstance(arg, list):
        for a in arg:
            p = proto.list.add()
            _write_parameter(p, a)
        else:
            proto.null_list = True
    elif isinstance(arg, tuple):
        for a in arg:
            p = proto.tuples.add()
            _write_parameter(p, a)
        else:
            proto.null_tuple = True
    elif isinstance(arg, dict):
        proto.python_param = marshal.dumps(arg)
    else:
        logger.error('error type:%s arg:%s', type(arg), arg)


def _read_parameter(proto):
    if len(proto.ListFields()) < 1:
        logger.error('error read para:%s', len(proto.ListFields()))
    desc, arg = proto.ListFields()[0]
    if desc.name == 'is_null':
        return None
    elif desc.name == 'null_list':
        return []
    elif desc.name == 'null_tuple':
        return ()
    elif desc.name == 'tuples':
        tt = ()
        for a in arg:
            tt = tt + (_read_parameter(a), )
        return tt
    elif desc.name == 'list':
        ll = []
        for a in arg:
            ll.append(_read_parameter(a))
        return ll
    elif desc.name == 'python_param':
        return marshal.loads(arg)
    else:
        return arg


class RemoteObject:
    """远程调用对象
    """

    def __init__(self, broker, timeout=DEFAULT_TIMEOUT):
        """
        """
        self.broker = broker
        self.timeout = timeout

    def callRemoteForResult(self, _name, *args, **kw):
        """执行远程调用,并等待结果
        @param _name: 调用的远程方法的名称
        @param timeout: int 结果返回的默认超时时间
        @param args: 远程方法需要的参数
        @param kw: 远程方法需要的默认参数
        """
        _key, result = AsyncResultFactory().createAsyncResult()
        self.broker._sendMessage(_key, _name, args, kw)
        return result.get(timeout=Timeout(self.timeout))

    def callRemoteNotForResult(self, _name, *args, **kw):
        """执行远程调用，不需要等待结果
        @param _name: 调用的远程方法的名称
        @param args: 远程方法需要的参数
        @param kw: 远程方法需要的默认参数
        """
        self.broker._sendMessage('', _name, args, kw)


class PBProtocl(BaseProtocol):
    """RPC协议处理
    """

    def __init__(self, transport, factory):
        BaseProtocol.__init__(self, transport, factory)
        self.buff = ""

    def getRootObject(self, timeout=DEFAULT_TIMEOUT):
        """获取远程调用对象
        """
        return RemoteObject(self, timeout=timeout)

    def _sendMessage(self, _key, _name, args, kw):
        """发送远程请求
        """
        # logger.debug('send:%s:%s', args, kw)
        if _key:
            _msgtype = ASK_SIGNAL
        else:
            _msgtype = NOTICE_SIGNAL
        request = rpc_pb2.RPCProtocol()
        request.msgType = _msgtype
        request.key = _key
        request.name = _name
        for arg in args:
            para = request.parameters.add()
            _write_parameter(para, arg)

        if kw:
            logger.error('rpc kw para:%s', kw)

        # request.args = str(args)
        # request.kw = str(kw)
        self.writeData(request.SerializePartialToString())

    def writeData(self, data):
        """发送数据的统一接口
        """
        _length = len(data)
        if _length > RPC_DATA_MAX_LENGTH:
            logger.error('length error:%s', _length)
            raise RPCDataTooLongError
        self.transport.sendall(struct.pack("!i", _length) + data)

    def dataReceived(self, data):
        """数据到达时的处理
        """
        self.buff += data
        while len(self.buff) >= 4:
            data_length, = struct.unpack('!i', self.buff[:4])
            if len(self.buff[4:]) < data_length:
                break
            else:
                request = self.buff[4:4 + data_length]
                self.buff = self.buff[4 + data_length:]
                # gevent.spawn(self.msgResolve, request)
                GEVENT_POOL.spawn(self.msgResolve, request)
                # self.msgResolve(request)

    def msgResolve(self, data):
        """消息解析
        """
        # logger.debug('process#message1')
        request = rpc_pb2.RPCProtocol()
        request.ParseFromString(data)
        _msgtype = request.msgType
        if _msgtype == ASK_SIGNAL or _msgtype == NOTICE_SIGNAL:
            self.askReceived(request)
        elif _msgtype == ANSWER_SIGNAL:
            self.answerReceived(request)
        # logger.debug('process#message2')

    def askReceived(self, request):
        """远程调用请求到达时的处理
        """
        _key = request.key
        _name = request.name
        _args = []  # eval(request.args)
        for para in request.parameters:
            _args.append(_read_parameter(para))

        _kw = {}  # eval(request.kw)
        method = self.getRemoteMethod(_name)
        # logger.debug('process:%s:%s', _args, _kw)
        result = self.callRemoteMethod(method, _args, _kw)
        if _key:
            response = rpc_pb2.RPCProtocol()
            response.msgType = ANSWER_SIGNAL
            response.key = _key
            _write_parameter(response.result, result)
            self.writeData(response.SerializePartialToString())

    def getRemoteMethod(self, _name):
        """获取远程调用的方法对象
        """
        method = getattr(self, "remote_%s" % _name)
        return method

    def callRemoteMethod(self, method, _args, _kw):
        """调用远程方法
        """
        return method(*_args, **_kw)

    def answerReceived(self, request):
        """请求的结果返回后的处理
        """
        _key = request.key
        aresult = AsyncResultFactory().popAsyncResult(_key)
        result = _read_parameter(request.result)
        aresult.set(result)


class PBServerProtocl(PBProtocl):
    pass


class PBServerFactory(ServerFactory):
    protocol = PBServerProtocl


class PBClientProtocl(PBProtocl):
    pass


class PBClientFactory(ClientFactory):
    protocol = PBClientProtocl

    def getRootObject(self, timeout=DEFAULT_TIMEOUT):
        """获取远程调用对象
        """
        return RemoteObject(self._protocol, timeout=timeout)
