# -*- coding:utf-8 -*-
"""
created by server on 14-7-22上午12:13.
"""
from twisted.internet import reactor, protocol


class EchoClient(protocol.Protocol):
    def connectionMade(self):
        self.transport.write('fucking date')

    def dataReceived(self, data):
        self.transport.write('............')


class EchoFactory(protocol.ClientFactory):
    protocol = EchoClient

    def clientConnectionFailed(self, connector, reason):
        print "Connection failed - goodbye!"
        reactor.stop()

    def clientConnectionLost(self, connector, reason):
        print "Connection lost - goodbye!"
        reactor.stop()


# this connects the protocol to a server runing on port 8000
def main():

    HOST = 'localhost'
    PORT = 12345

    f = EchoFactory()
    reactor.connectTCP(HOST, PORT, f)
    reactor.run()

# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()