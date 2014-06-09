#coding:utf8
'''
Created on 2013-6-8

@author: lan (www.9miao.com)
'''
from django.shortcuts import render_to_response,HttpResponseRedirect

from gameadmin.errormsg import *

from gameadmin.adminuser.models import AdminUser


def login_no_user(request):
    '''没有用户的登陆情况
    '''
    print 111111111
    return render_to_response('login.html',{'errormsg':'123456789'})

def login_check_user(request):
    '''验证用户
    '''
    username = request.POST['username']
    password = request.POST['password']
    try:
        theuser = AdminUser.objects.get(name=username)
    except Exception:
        theuser = None
    if not theuser:
        return render_to_response('login.html',{'errormsg':USER_ERROR})
    if not theuser.check_password(password):
        return render_to_response('login.html',{'errormsg':PASSWORD_ERROR})
    response = HttpResponseRedirect("/main")
    response.set_cookie('login_user', username,max_age=600)
    return response

