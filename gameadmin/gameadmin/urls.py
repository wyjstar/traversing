# coding:utf-8
from django.conf.urls import patterns
from django.conf.urls import include
from django.conf.urls import url
from adminuser.views import login, main, loginout
from ginterface.views import recharge, opearPlayer, getserverlist, landed, buyProps
from serverinfo.views import serverlist, GetDayRecored
# Uncomment the next two lines to enable the admin:
from django.contrib import admin
from gameadmin import settings
from error_view import *
# admin.autodiscover()

urlpatterns = patterns('',
                       # Examples:
                       # url(r'^$', 'gameadmin.views.home', name='home'),
                       # url(r'^gameadmin/', include('gameadmin.foo.urls')),

                       # Uncomment the admin/doc line below to enable admin documentation:
                       # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

                       #     Uncomment the next line to enable the admin:
                       url(r'^admin/', include(admin.site.urls)),
                       (r'^static/(?P<path>.*)$', 'django.views.static.serve',
                        {'document_root': settings.STATICFILES_DIRS[0], 'show_indexes': True}),
                       (r'^$', login),
                       (r'login', login),
                       (r'loginout', loginout),
                       (r'main', main),
                       (r'recharge', recharge),
                       (r'getserverlist', getserverlist),
                       (r'serverlist', serverlist),
                       (r'dayrecord', GetDayRecored),
                       (r'opearplayer', opearPlayer),
                       (r'land', landed),
                       (r'buyprops', buyProps),
)
handler404 = Error_404
handler500 = Error_500