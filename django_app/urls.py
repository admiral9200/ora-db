from __future__ import unicode_literals
from django.conf.urls import url
import views

app_name = 'django_app'
urlpatterns = [
    url(r'clients', views.get_all_clients, name='clients'),
    url(r'offices', views.get_all_offices, name='offices'),
    url(r'order/([0-9]+)$', views.get_order_info, name='order'),
    url(r'check_order$', views.check_order, name='check_order'),
    url(r'$', views.index, name='index'),
]