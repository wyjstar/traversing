#coding:utf8
from django.db import models
from django.contrib import admin
import hashlib

# Create your models here.
class AdminUser(models.Model):
    """管理员信息
    """
    PASS_KEY = "seanlan"
    SEX = (
    (1,u'男'),
    (2,u'女'),
    )
    
    name = models.CharField(max_length=30,verbose_name="用户名",unique = True)
    sex = models.IntegerField(choices=SEX,max_length=10,verbose_name="性别",default=1,null=True)
    email = models.EmailField(max_length=50,verbose_name="电子邮箱")
    password = models.CharField(max_length=64,verbose_name="用户密码",default='123456',null=True)
    
    def serializable_password(self):
        '''加密密码
        '''
        sha = hashlib.sha256()
        sha.update(self.password+self.PASS_KEY+self.name)
        self.password = sha.hexdigest().upper()
        
    def check_password(self,password):
        '''检测密码
        '''
        sha = hashlib.sha256()
        sha.update(password+self.PASS_KEY+self.name)
        nowpassword = sha.hexdigest().upper()
        if nowpassword==self.password:
            return True
        return False
    
    def __unicode__(self):
        """
        """
        return self.name
    
    class Meta:
        verbose_name = "管理员信息"
        verbose_name_plural = "管理员信息"
        ordering = ('id',)
    
class UserAdmin(admin.ModelAdmin):
    list_display = ('name', 'email')
    
    def save_model(self, request, obj, form, change):
        """
        Given a model instance save it to the database.
        """
        obj.serializable_password()
        obj.save()
    
admin.site.register(AdminUser, UserAdmin)
