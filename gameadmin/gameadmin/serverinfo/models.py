#coding:utf8
from django.db import models
from django.contrib import admin

# Create your models here.

class Operators(models.Model):
    """运营商信息
    """
    name = models.CharField(max_length=30,verbose_name="运营商名称",unique = True)
    privatekey=models.CharField(max_length=32,verbose_name="运营商私钥")
    email = models.EmailField(max_length=50,verbose_name="联营商邮箱",null=True)
    
    class Meta:
        verbose_name = "运营商信息"
        verbose_name_plural = "运营商信息"
        ordering = ('id',)
        
    def __unicode__(self):
        return self.name
    
    
    
class ServerInfo(models.Model):
    """服务器信息
    """
    name = models.CharField(max_length=30,verbose_name=u"服务器名称",unique = True)
    ip = models.IPAddressField(max_length=30,verbose_name=u"服务器IP",null = False)
    lianyun = models.ForeignKey(Operators,verbose_name="联营商",)
    loginport = models.IntegerField(verbose_name="登陆端口")
    webport = models.IntegerField(verbose_name="WEB端口")
    createtime = models.DateField(verbose_name="开服时间")
    privatekey=models.CharField(max_length=32,verbose_name=u"接口私钥")
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        verbose_name = "服务器信息"
        verbose_name_plural = "服务器信息"
        ordering = ('id',)
        
    @property
    def started(self):
        """服务器是否开放
        """
        from gameadmin.toolfunc import ping
        ip = self.ip
        port = self.loginport
        return ping(ip,port)
    
    @property
    def state(self):
        """状态 1新开  2通畅 3爆满
        """
        return 1
    
class PropsInfo(models.Model):
    """收费道具信息
    """
    consume_code = models.CharField(max_length=30,verbose_name="消费代码",unique = True)
    name = models.CharField(max_length=30,verbose_name="道具名称",unique = True)
    props_desc = models.TextField(max_length=30,verbose_name="道具说明",null = False)
    server = models.ForeignKey(ServerInfo,verbose_name="所属服务器",)
    gold_cnt = models.IntegerField(verbose_name="元宝数量")
    y_cnt = models.IntegerField(verbose_name="人民币数量")
    
    def __unicode__(self):
        """
        """
        return self.name
    
    class Meta:
        verbose_name = "收费道具信息"
        verbose_name_plural = "收费道具信息"
        ordering = ('id',)
    
class PropsInfoAdmin(admin.ModelAdmin):
    list_display = ('id','consume_code','name', 'props_desc')
    
# class OperaStr(models.Model):
#     '''修改角色信息脚本
#     '''
#     name = models.CharField(max_length=30,verbose_name="脚本名称",unique = True)
#     content = models.CharField(max_length=230,verbose_name="脚本内容",null = False)
#     
#     def __unicode__(self):
#         return self.name
#     
#     class Meta:
#         verbose_name = u"操作脚本"
#         verbose_name_plural = u"操作脚本"
#         ordering = ('id',)
    

        
class WhiteList(models.Model):
    """白名单信息
    """
    PERMISSION = ((1,u'低'),
                  (2,u'中'),
                  (3,u'高'),
                  )
    name = models.CharField(max_length=30,verbose_name="服务器名称",unique = True)
    ip = models.IPAddressField(max_length=30,verbose_name="服务器IP",null = False)
    desc = models.TextField(max_length=30,verbose_name="名单说明",null = False)
    plevel = models.IntegerField(choices=PERMISSION,max_length=30,verbose_name="安全等级",default=2)
    createtime = models.DateField(max_length=30,verbose_name="添加时间")
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        verbose_name = u"白名单信息"
        verbose_name_plural = u"白名单信息"
        ordering = ('id',)
    
class ServerInfoAdmin(admin.ModelAdmin):
    list_display = ('id','name', 'ip')
    
class OperatorsAdmin(admin.ModelAdmin):
    list_display = ('id','name', 'email')
    
class WhiteListAdmin(admin.ModelAdmin):
    list_display = ('id','name', 'ip')
    
# class OperaStrAdmin(admin.ModelAdmin):
#     list_display = ('id','name', 'content')
    
admin.site.register(ServerInfo, ServerInfoAdmin)
admin.site.register(Operators, OperatorsAdmin)
admin.site.register(WhiteList,WhiteListAdmin)
admin.site.register(PropsInfo,PropsInfoAdmin)
# admin.site.register(OperaStr,OperaStrAdmin)
