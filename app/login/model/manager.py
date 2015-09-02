# -*- coding:utf-8 -*-
"""
created by sphinx on 18/9/14.
"""
import os
import json
import time

account_cache = {}


class ServerManager(object):
    def __init__(self):
        self._servers = {}
        self._is_static = False
        if os.path.exists('server_list.json'):
            sl = json.load(open('server_list.json'))
            self._is_static = True
            for _ in sl:
                self._servers[_['name']] = _
            print 'static server list:', self._servers

    def sync_server(self, name, ip, port, status, no):
        if not self._is_static:
            server = dict(name=name, ip=ip, port=port, status=status, no=no)

            for k, v in self._servers.items():
                if v.get('name') == name:
                    del self._servers[k]
                    self._servers[time.time()] = server
                    return True

            self._servers[time.time()] = server

    def get_server(self):
        if not self._is_static:
            for t in self._servers.keys():
                if time.time() - t > 180:
                    del self._servers[t]

        return self._servers.values()


server_manager = ServerManager()
