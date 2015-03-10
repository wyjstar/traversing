# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" list相关扩展方法
"""
import itertools


def contain(super_list, sub_list, equal=False):
    """
    判断super_list是否包含sublist所有元素，
    equal判断两个list包含的元素是否完全相同

    Example:
        contain([1, 2, 3], [1, 3, 2], equal=True)
        >> True
    """

    copy_super_list = super_list[:]
    for one in sub_list:
        if one not in copy_super_list:
            return False
        copy_super_list.remove(one)
    if equal:
        return len(copy_super_list) == 0
    else:
        return True


def divlist(ls, n):
    """
    把列表ls拆分为只存储n个元素的子列表，
    无法整除的情况下，最后一个存储剩余的元素

    Example:
        div_list([1, 2, 3, 4, 5], 2)
        >> [[1, 2], [3, 4], [5]]
    """
    sublists = []
    lslen = len(ls)
    subnum = lslen / n
    if subnum == 0:
        return [ls]
    for i in range(0, subnum):
        sublists.append(ls[i*n:(i+1)*n])
    if lslen % n != 0:
        sublists.append(ls[subnum*n:lslen])
    return sublists


def chainlist(ls, cut=None):
    """
    二级列表平面化
    @param cut: 截取后再拼接

    Example:
        chain_list([(1, 2), (3, 4)])
        >> [1, 2, 3, 4]
        chain_list([(1, 2), (3, 4)], cut=1)
        >> [1, 3]
    """
    if not cut:
        return list(itertools.chain(*ls))
    chain = []
    for l in ls:
        chain.extend(l[:cut] )
    return chain
