from __future__ import generators
# -*- coding:utf-8 -*-
"""
created by server on 14-8-7下午5:53.
"""
import sys
def math_gen(n):    # Iterative function becomes a generator
    from math import sin
    while 1:
        yield n
        n = abs(sin(n))*31
# Jump targets not state-sensitive, only to simplify example
def jump_to(val):
    if    0 <= val < 10: return 'ONES'
    elif 10 <= val < 20: return 'TENS'
    elif 20 <= val < 30: return 'TWENTIES'
    else:                return 'OUT_OF_RANGE'
def get_ones(iter):
    global cargo
    while 1:
        print "\nONES State:      ",
        while jump_to(cargo)=='ONES':
            print "@ %2.1f  " % cargo,
            cargo = iter.next()
        yield (jump_to(cargo), cargo)
def get_tens(iter):
    global cargo
    while 1:
        print "\nTENS State:      ",
        while jump_to(cargo)=='TENS':
            print "#%2.1f  " % cargo,
            cargo = iter.next()
        yield (jump_to(cargo), cargo)
def get_twenties(iter):
    global cargo
    while 1:
        print "\nTWENTIES State:  ",
        while jump_to(cargo)=='TWENTIES':
            print "*%2.1f  " % cargo,
            cargo = iter.next()
        yield (jump_to(cargo), cargo)
def exit(iter):
    jump = raw_input('\n\n[co-routine for jump?] ').upper()
    print "...Jumping into middle of", jump
    yield (jump, iter.next())
    print "\nExiting from exit()..."
    sys.exit()
def scheduler(gendct, start):
    global cargo
    coroutine = start
    while 1:
        (coroutine, cargo) = gendct[coroutine].next()
if __name__ == "__main__":
    num_stream = math_gen(1)
    cargo = num_stream.next()
    gendct = {'ONES'        : get_ones(num_stream),
              'TENS'        : get_tens(num_stream),
              'TWENTIES'    : get_twenties(num_stream),
              'OUT_OF_RANGE': exit(num_stream)         }
    scheduler(gendct, jump_to(cargo))