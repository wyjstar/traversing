#coding:utf8

# Create your views here.
from django.shortcuts import render_to_response,HttpResponseRedirect,HttpResponse

import admin
import datetime
from gameadmin.toolfunc import checkSecurity


@checkSecurity
def login(request):
    '''用户登录页面'''
    if request.method == "POST":
        print 11111111111111111
        return admin.login_check_user(request)
    else:
        print 22222222222222
        return admin.login_no_user(request)
    
@checkSecurity
@checklogin
def main(request):
    username = request.COOKIES.get("login_user")
    return render_to_response('main.html',{'usernaem':username,
                                           'nowdate':datetime.date.today()})

@checkSecurity
@checklogin
def loginout(request):
    '''注销
    '''
    response = HttpResponseRedirect("/login")
    response.delete_cookie('login_user')
    return response
