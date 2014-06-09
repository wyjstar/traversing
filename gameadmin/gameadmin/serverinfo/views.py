#coding:utf8
# Create your views here.
from gameadmin.toolfunc import checkSecurity,checkMD5,MakeSecurityURL,checklogin
from gameadmin.serverinfo.models import ServerInfo,Operators
from gameadmin.errormsg import *
from django.shortcuts import HttpResponse,render_to_response
import urllib2,datetime,json


@checklogin
def GetDayRecored(request):
    """获取每日
    """
    ly = int(request.REQUEST.get("operator",0))
    serverid = int(request.REQUEST.get("server",0))
    index = int(request.REQUEST.get("index",1))
    operatorlist = Operators.objects.all()
    if not ly:
        serverlist = ServerInfo.objects.all()
    else:
        operator = Operators.objects.get(id=ly)
        serverlist = operator.serverinfo_set.all()
    datalist = []
    goaldata = {}
    if serverid:
        server = ServerInfo.objects.get(id=serverid)
        address = server.ip
        #port = server.webport
        port = server.loginport
        if server.started:
            call = 'dayrecored'
            urls = "http://%s:%s/%s?index=%s"%(address,port,call,index)
            urls2= "http://%s:%s/statistics"%(address,port)
            urlresult = urllib2.urlopen(urls)
            urlresult2 = urllib2.urlopen(urls2)
            result = urlresult.read()
            result2 = urlresult2.read()
            datalist = json.loads(result)
            goaldata = json.loads(result2)
    return render_to_response('dayrecord.html',{'serverlist':serverlist,
                                                'operatorlist':operatorlist,
                                                'operator':ly,
                                                'server':serverid,
                                                'datalist':datalist,
                                                'goaldata':goaldata,
                                                'index':index})
    
@checklogin
def serverlist(request):
    """获取服务器列表信息
    """
    LIMIT = 10
    ly = int(request.REQUEST.get("operator",0))
    serverid = int(request.REQUEST.get("server",0))
    index = int(request.REQUEST.get("index",1))
    operatorlist = Operators.objects.all()
    if not ly:
        serverlist = ServerInfo.objects.all()
    else:
        operator = Operators.objects.get(id=ly)
        operatorlist = [operator]
        serverlist = operator.serverinfo_set.all()
    start = (index-1)*LIMIT
    end = (index)*LIMIT
    return render_to_response('serverlist.html',{'serverlist':serverlist[start:end],
                                                 'operatorlist':operatorlist,
                                                 'operator':ly,
                                                  'server':serverid,
                                                  'index':index})
    
    
    