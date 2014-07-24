# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午7:50.
"""

# !/usr/bin/env python

# Copyright (c) Twisted Matrix Laboratories.
# See LICENSE for details.

from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor

### Protocol Implementation

# This is just about the simplest possible protocol


class Echo(Protocol):

    def dataReceived(self, data):
        """
        As soon as any data is received, write it back.
        """
        print data
        self.transport.write(data)


def main():
    f = Factory()
    f.protocol = Echo
    reactor.listenTCP(12345, f)
    reactor.run()

if __name__ == '__main__':
    main()