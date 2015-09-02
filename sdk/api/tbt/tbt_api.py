# coding: utf-8
from geventhttpclient import HTTPClient
from geventhttpclient.url import URL


TBT_URL = 'http://tgi.tongbu.com/api/LoginCheck.ashx?'

# AppId：150651
# AppKey：vF8Se3rBOlbJ#VL6vFSpe3BZObyI#Ki6


def verify_login(session, appid):
    """
    登陆校验
    """
    url = "%ssession=%s&appid=%s" % (TBT_URL, session, appid)

    url = URL(url)
    http = HTTPClient(url.host, port=url.port)
    response = eval(http.get(url.request_uri).read())
    http.close()
    return response
