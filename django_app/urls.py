from __future__ import unicode_literals
from django.conf.urls import url
import views

app_name = 'django_app'
urlpatterns = [
    url(r'clients', views.get_clients, name='clients'),
    url(r'offices', views.get_offices, name='offices'),
    url(r'order/([0-9]+)$', views.get_order_info, name='order'),
    url(r'check_order$', views.check_order, name='check_order'),
    url(r'client_orders/([0-9]+)$', views.client_orders, name='client_orders'),
    url(r'check_client_order$', views.check_client_orders, name='check_client_orders'),
    url(r'client_orders_ready_not_returned/([0-9]+)$',
        views.client_orders_ready_not_returned, name='ready_not_returned_orders'),
    url(r'check_order_ready_not_returned$', views.check_client_orders_ready_not_returned,
        name='check_client_orders_ready_not_returned'),
    url(r'client_info/([0-9]+)$',
        views.client_info, name='client_info'),
    url(r'check_client_info$', views.check_client_info,
        name='check_client_info'),
    url(r'logout$', views.logout, name='logout'),
    url(r'login$', views.login, name='login'),
    url(r'register$', views.register, name='register'),
    url(r'services$', views.services, name='services'),
    url(r'add_order$', views.order, name='add_order'),
    url(r'$', views.index, name='index'),
]