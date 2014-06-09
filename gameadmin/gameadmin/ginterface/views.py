#coding:utf8
# Create your views here.

import urllib2
import datetime
import time
import json
from xml.dom.minidom import Document
import xml.sax

from django.shortcuts import HttpResponse,render_to_response

from gameadmin.toolfunc import checkSecurity,checkMD5,MakeSecurityURL,checklogin,MakeLoginArgs
from gameadmin.serverinfo.models import ServerInfo,Operators,PropsInfo
from gameadmin.ginterface.models import Order,PropsOrder
from gameadmin.errormsg import *
from gameadmin.serverinfo.operaStr import operaStrDict


class XMLHandler(xml.sax.handler.ContentHandler): 
    def __init__(self): 
        self.buffer = ""                   
        self.mapping = {}                 
 
    def startElement(self, name, attributes): 
        self.buffer = ""                   
 
    def characters(self, data): 
        self.buffer += data                     
 
    def endElement(self, name): 
        self.mapping[name] = self.buffer          
 
    def getDict(self): 
        return self.mapping 

def produceXmlResponse(transIDO,hRet,message):

    doc = Document()
    response = doc.createElement('response') #创建根元素
    doc.appendChild(response)

    transIDO_node = doc.createElement('transIDO')
    transIDO_value = doc.createTextNode(str(transIDO))
    transIDO_node.appendChild(transIDO_value)
    response.appendChild(transIDO_node)
    
    hRet_node = doc.createElement('hRet')
    hRet_value = doc.createTextNode(str(hRet))
    hRet_node.appendChild(hRet_value)
    response.appendChild(hRet_node)
    
    message_node = doc.createElement('message')
    message_value = doc.createTextNode(str(message))
    message_node.appendChild(message_value)
    response.appendChild(message_node)
    
    return doc.toprettyxml(indent = '')


@checkSecurity
def recharge(request):
    """充值
    状态说明  1充值成功 -11
    """
    user_id = request.REQUEST["user_id"]
    server_id = request.REQUEST["server_id"]
    timestamp = request.REQUEST["timestamp"]
    amount =request.REQUEST["amount"]
    gamount = request.REQUEST["gamount"]
    ly = request.REQUEST["ly"]
    orderid = request.REQUEST["orderid"]
    sign = request.REQUEST["sign"]
    response = HttpResponse()
    try:#获取指定的运营商和服务器的信息
        server = ServerInfo.objects.get(id = int(server_id))
        operator = Operators.objects.get(id = int(ly))
    except:
        response.write(LOCAL_ARGS_ERROR)
        return response
    address = server.ip
    serverkey = server.privatekey
    privatekey = operator.privatekey
    port = server.webport
    #参数MD5检测
    result = checkMD5(user_id,server_id,timestamp,amount,gamount,ly,orderid,sign,privatekey)
    if not result:#MD5检测未通过
        response.write(LOCAL_MD5_ERROR)
        return response
    #重复订单号检测
    try:
        oldorder = Order.objects.get(orderid=orderid,lyid=operator)
    except:
        oldorder = None
    if oldorder:#如果存在重复的订单号
        response.write(LOCAL_REPEATED_ORDER)
        return response
    argsdir = [('user_id',user_id),
               ('server_id',server_id),
               ('timestamp',timestamp),
               ('amount',amount),
               ('gamount',gamount),
               ('ly',ly),('orderid',orderid)]
    callname = 'recharge'
    url = MakeSecurityURL(address,port,callname,serverkey,argsdir)
    urlresult = urllib2.urlopen(url)
    result = urlresult.read()
    try:
        rtime = datetime.datetime.fromtimestamp(eval(timestamp))
        ctime = datetime.datetime.now()
        state = 0
        if result==SUCCESS:
            state = 1
            response.write(SUCCESS)
        else:
            response.write(result)
        order = Order(uid=user_id,rbm=amount,zuan=gamount,
                          serverid=server,lyid=operator,rtime=rtime,
                          ctime=ctime,orderid=orderid,state = state)
        order.save()
    except:
        response.write(LOCAL_EXCEPTION)
        return response
    return response
    
@checkSecurity
def landed(request):
    """游戏登录
    """
    user_id = request.REQUEST["user_id"]
    server_id = request.REQUEST["server_id"]
    cm =request.REQUEST["cm"]
    timestamp = request.REQUEST["timestamp"]
    ly = request.REQUEST["ly"]
    sign = request.REQUEST["sign"]
    response = HttpResponse()
    try:#获取指定的运营商和服务器的信息
        server = ServerInfo.objects.get(id = int(server_id))
        operator = Operators.objects.get(id = int(ly))
    except:
        response.write(LOCAL_ARGS_ERROR)
        return response
    address = server.ip
    serverkey = server.privatekey
    privatekey = operator.privatekey
    port = server.loginport
    #参数MD5检测
    result = checkMD5(user_id,server_id,cm,timestamp,ly,sign,privatekey)
    if not result:#MD5检测未通过
        response.write(LOCAL_MD5_ERROR)
        return response
    argsdir = [('user_id',user_id),
               ('server_id',server_id),
               ('cm',cm),
               ('timestamp',timestamp),
               ('ly',ly)]
    args = MakeLoginArgs(serverkey, argsdir)
    result={'args':args,'port':port,'host':address}
    response.write(json.dumps(result))
    return response
    
@checkSecurity
def getserverlist(request):
    """获取服务器列表
    """
    ly = int(request.REQUEST.get("operator",0))
    if not ly:
        serverlist = ServerInfo.objects.all()
    else:
        operator = Operators.objects.get(id=ly)
        serverlist = operator.serverinfo_set.all()
    result = []
    for server in serverlist:
        info = {}
        info['id'] = server.id
        info['name'] = server.name
        info['port'] = server.loginport
        info['state'] = server.state
        result.append(info)
    return HttpResponse(json.dumps(result))

@checklogin
def opearPlayer(request):
    """扶持账号操作
    """
    ly = int(request.REQUEST.get("operator",0))
    serverid = int(request.REQUEST.get("server",0))
    username = request.REQUEST.get("username",0)
    select_act = int(request.REQUEST.get("select_act",0))
    change_val = request.REQUEST.get("change_val",0)
    change_templateId = request.REQUEST.get("change_templateId",0)
    change_number = request.REQUEST.get("change_number",0)
    operatorlist = Operators.objects.all()
    if not ly:
        serverlist = ServerInfo.objects.all()
    else:
        operator = Operators.objects.get(id=ly)
        serverlist = operator.serverinfo_set.all()
    if username and select_act:
        if change_val and not change_templateId and not change_number:
            con_obj = operaStrDict.get(select_act)
            if con_obj:
                con_str = con_obj % change_val
                #con_str += "("+change_val+")"
                url = "http://localhost:2012/opera?username=" + username + "&opera_str=" + con_str
                urlresult = urllib2.urlopen(url)
                result = urlresult.read()
            else:
                result = u"无此操作！！！"
        elif change_templateId and change_number and not change_val:
            con_obj = operaStrDict.get(select_act)
            if con_obj:
                con_str = con_obj % (change_templateId,change_number)
                url = "http://localhost:2012/opera?username=" + username + "&opera_str=" + con_str
                urlresult = urllib2.urlopen(url)
                result = urlresult.read()
        else:
            result = None
    else:
        result = None
    return render_to_response('opearplayer.html',{'serverlist':serverlist,
                                                'operatorlist':operatorlist,
                                                'operator':ly,
                                                'server':serverid,
                                                'result':result,})
    

#@checkSecurity
def buyProps(request):
    """购买道具
    """
    requstdata = request.POST.keys()+['=']+request.POST.values()
    xmldata = ''.join(requstdata)
    xh = XMLHandler() 
    xml.sax.parseString(str(xmldata), xh) 
    ret = xh.getDict() 
    
    userId = ret.get("userId")
    cpServiceId = ret.get("cpServiceId")
    consumeCode = ret.get("consumeCode")
    cpParam = ret.get("cpParam")
    hRet = ret.get("hRet",'1')
    status = ret.get("status")
    versionId = ret.get("versionId",100)
    transIDO = ret.get("transIDO")
    response = HttpResponse(mimetype="application/xml")
    try:#获取指定的消费信息
        props = PropsInfo.objects.get(consume_code=consumeCode)
    except:
        props = None
    if not props:
        response.write(produceXmlResponse(transIDO,-1,"consume does not exist"))
        return response
    elif int(hRet):
        response.write(produceXmlResponse(transIDO,-1,"hRet failed"))
        return response
    #重复订单号检测
    try:
        oldorder = PropsOrder.objects.get(orderid=transIDO)
    except:
        oldorder = None
    if oldorder:#如果存在重复的订单号
        response.write(produceXmlResponse(transIDO,-1,"transIDO already exists"))
        return response
        
    server = props.server
    operator = server.lianyun
    address = server.ip
    serverkey = server.privatekey
    port = server.webport
    timestamp = time.time()
    amount = props.y_cnt
    gamount = props.gold_cnt
    argsdir = [('user_id',str(userId)),
               ('server_id',str(server.id)),
               ('timestamp','%d'%timestamp),
               ('amount',str(amount)),
               ('gamount',str(gamount)),
               ('ly',str(operator.id)),('orderid',transIDO)]
    callname = 'recharge'
    url = MakeSecurityURL(address,port,callname,serverkey,argsdir)
    urlresult = urllib2.urlopen(url)
    result = urlresult.read()
    try:
        rtime = datetime.datetime.fromtimestamp(timestamp)
        ctime = datetime.datetime.now()
        state = 0
        if result==SUCCESS:
            state = 1
            response.write(produceXmlResponse(transIDO,0,"SUCCESS"))
        else:
            response.write(produceXmlResponse(transIDO,-1,"userId does not exist"))
        order = PropsOrder(uid=userId,rbm=amount,zuan=gamount,
                          serverid=server,lyid=operator,rtime=rtime,
                          ctime=ctime,orderid=transIDO,state = state)
        order.save()
    except:
        response.write(LOCAL_EXCEPTION)
        return response
    return response
    
    
    
    
    
    
    