# -*- coding:utf-8 -*-
"""
created by sphinx on 18/9/14.
"""
import time

account_cache = {}


class ServerManager(object):
    def __init__(self):
        self._servers = {}

    def sync_server(self, name, ip, port, status):
        server = dict(name=name, ip=ip, port=port, status=status)

        for k, v in self._servers.items():
            if v.get('name') == name:
                del self._servers[k]
                self._servers[time.time()] = server
                return True

        self._servers[time.time()] = server

    def get_server(self):
        return self._servers.values()


server_manager = ServerManager()
