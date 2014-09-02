# -*- coding:utf-8 -*-
"""
created by server on 14-8-21下午2:45.
"""

import struct
import inspect
from twisted.internet import protocol


def build_data(send_str, command_id):
    HEAD_0 = chr(0)
    HEAD_1 = chr(0)
    HEAD_2 = chr(0)
    HEAD_3 = chr(0)
    ProtoVersion = chr(0)
    ServerVersion = 0
    send_str = send_str
    data = struct.pack('!sssss3I',
                       HEAD_0, HEAD_1, HEAD_2, HEAD_3,
                       ProtoVersion,
                       ServerVersion,
                       len(send_str) + 4,
                       command_id)
    result_data = data + send_str
    return result_data


def parse_data(data):
    ud = struct.unpack('!sssss3I', data[:17])
    lenght = ud[6]
    command = ud[7]
    message = data[17:17 + lenght]
    return command, message


class RobotBase(protocol.Protocol):
    def __init__(self):
        self.on_command_error = None
        self.on_connection_lost = None
        self.on_connection_made = None
        self.on_command_finish = None

        self._distributor = {}
        self._commands = []
        self._command_args = []
        for attr in dir(self):
            key = attr.split('_')
            if key[0] == 'command':
                self._commands.append(attr)
                fun = getattr(self, attr)
                self._command_args.append(inspect.getargspec(fun)[0])
            if key[-1].isdigit():
                self._distributor[key[-1]] = attr

        # print self._commands
        # print self._distributor

    @property
    def commands(self):
        return self._commands

    @property
    def commands_args(self):
        return self._command_args

    def send_message(self, argument, command_id):
        if argument:
            data = build_data(argument.SerializeToString(), command_id)
        else:
            data = build_data('', command_id)
        self.transport.write(data)

    def connectionMade(self):
        self.on_connection_made()

    def dataReceived(self, data):
        command, message = parse_data(data)
        # print command
        fun = getattr(self, self._distributor[str(command)])
        if fun:
            fun(message)
        else:
            self.on_command_error()
            print 'cant find processor by command:', command

    def connectionLost(self, reason):
        print 'connection fail'
        self.on_connection_lost()
