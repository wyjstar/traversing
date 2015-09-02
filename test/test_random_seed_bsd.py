# -*- coding:utf-8 -*-
"""
created by server on 14-7-30下午5:16.
"""
import math


def bsd_rand(X1, X2):
    def rand():
        # print rand.X1, rand.X2
        A1, A2, D20, D40 = 727595.0, 798405.0, 1048576.0, 1099511627776.0
        U = rand.X2 * A2
        V = (rand.X1 * A2 + rand.X2 * A1) % D20
        V = (V * D20 + U) % D40

        # print 'U,V:', U,V

        rand.X1 = math.floor(V/D20)
        rand.X2 = V - rand.X1 * D20
        return V/D40
    rand.X1 = X1
    rand.X2 = X2
    return rand


if __name__ == '__main__':
    rand_test = bsd_rand(2.0, 3.0)
    map_rand = {}
    for i in range(10000):
        r = int(rand_test() * 100)
        if r in map_rand:
            map_rand[r] += 1
        else:
            map_rand[r] = 1

    for k, v in map_rand.items():
        print k, v
