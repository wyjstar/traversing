#coding:utf8
from django.db import models
from django.contrib import admin
from gameadmin.serverinfo.models import ServerInfo,Operators

# Create your models here.
class Order(models.Model):
    """充值订单
    """
    STATE = ((0,u'失败'),
             (1,u'成功'),
                  )
    
    uid = models.CharField(max_length=30,verbose_name="用户ID")
    rbm = models.IntegerField(max_length=30,verbose_name="充值金额")
    zuan = models.IntegerField(max_length=30,verbose_name="充值元宝")
    serverid = models.ForeignKey(ServerInfo,verbose_name="指定服务器")
    lyid = models.ForeignKey(Operators,verbose_name="运营商")
    rtime = models.DateTimeField(max_length=30,verbose_name="充值时间")
    ctime = models.DateTimeField(max_length=30,verbose_name="记录时间")
    orderid = models.CharField(max_length=50,verbose_name="订单ID")
    state = models.IntegerField(choices=STATE,max_length=50,verbose_name="订单状态")
    
    def __unicode__(self):
        return "Order----%s"%self.orderid
    
    class Meta:
        verbose_name = "充值订单信息"
        verbose_name_plural = "充值订单信息"
        ordering = ('id',)
    
    @classmethod
    def goalsum(cls):
        """计算当前所以的充值总金额
        """
        temp = cls.objects.extra(select={'temp':'sum(rbm)'}).values('temp')
        return temp
    
class PropsOrder(models.Model):
    """道具订单
    """
    STATE = ((0,u'失败'),
             (1,u'成功'),
                  )
    uid = models.CharField(max_length=30,verbose_name="用户ID")
    rbm = models.IntegerField(max_length=30,verbose_name="充值金额")
    zuan = models.IntegerField(max_length=30,verbose_name="充值元宝")
    serverid = models.ForeignKey(ServerInfo,verbose_name="指定服务器")
    lyid = models.ForeignKey(Operators,verbose_name="运营商")
    rtime = models.DateTimeField(max_length=30,verbose_name="充值时间")
    ctime = models.DateTimeField(max_length=30,verbose_name="记录时间")
    orderid = models.CharField(max_length=50,verbose_name="订单ID")
    state = models.IntegerField(choices=STATE,max_length=50,verbose_name="订单状态")
    
    def __unicode__(self):
        return "PropsOrder----%s"%self.orderid
    
    class Meta:
        verbose_name = "道具订单信息"
        verbose_name_plural = "道具订单信息"
        ordering = ('id',)
        
admin.site.register(Order)
admin.site.register(PropsOrder)

