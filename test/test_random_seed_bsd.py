# -*- coding:utf-8 -*-
"""
created by server on 14-7-30下午5:16.
"""
import array
import math

import random

# def bsd_rand(seed):
#     def rand():
#         rand.seed = (1103515245 * rand.seed + 12345) & 0x7fffffff
#         print type(rand)
#         return rand.seed
#
#     rand.seed = seed
#     return rand


# class Samples:
#     def __init__(self):
#         pass
#
#     def rand(self, num, seed=10):
#         m = math.pow(2, 32)
#         a = 214013
#         c = 2531011
#         i = 1
#         x_list = [0.]*num
#         print x_list
#         x = array.array.fromlist(x_list)
#         print x
#         x[0] = seed
#         while i < num:
#             x[i] = (a * x[i - 1] + c) % m
#             i += 1
#         return x


import math


def ran():
    X1 = 3.0
    X2 = 4.0
    A1 = 727595.0
    A2 = 798406.0
    D20 = 1048576.0
    D40 = 1099511627776.0
    U = X2 * A2
    V = (X1 * A2 + X2 * A1) % D20
    V = (V * D20 + U) % D40
    X1 = math.floor(V/D20)
    X2 = V - X1 * D20
    return V/D40


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
    rand_test = bsd_rand(3.0, 4.0)
    for i in range(10):
        print rand_test()

    print 4.0 * 798406.0