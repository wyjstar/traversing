#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
get random with seed.
"""

import math
import random


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

rand = None
def init(X1, X2):
    global rand
    rand = bsd_rand(X1, X2)

def get_random_int(start, end):
    """docstring for get_random_int"""
    return random.randint(start, end)



if __name__ == '__main__':
    init(1.0, 2.0)
    print rand()



