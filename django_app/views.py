from __future__ import print_function
from __future__ import unicode_literals

# Create your views here.
import cx_Oracle
from django.db import connection
from django.http import response, HttpResponseRedirect
from django.shortcuts import render
from django.core.urlresolvers import reverse


from utils import prettify_strings, _get_row_names, _row_names_and_types
from list_requests import list_request
from .forms import OrderIdForm

def get_all_clients(request):
    row_names, data = list_request('get_clients')
    return render(request, 'django_app/client_list.html',
                  {"headers": row_names, "clients": data})


def get_all_offices(request):
    row_names, data = list_request('get_offices')
    return render(request, 'django_app/offices_list.html',
                  {"headers": row_names, "offices": data})


def index(request):
    return render(request, 'django_app/index.html')


def get_order_info(request, order_id):
    row_names, data = list_request('get_order_info', [int(order_id)])

    is_ready_index = row_names.index('Is ready')
    for i, element in enumerate(data):
        data[i] = list(data[i])
        data[i][is_ready_index] = bool(element[is_ready_index])

    return render(request, 'django_app/order_status.html',
                  {"headers": row_names, "order": data})


def check_order(request):

    if request.method == 'POST':
        form = OrderIdForm(request.POST)
        if form.is_valid():
            order_id = form.cleaned_data['order_id']
            return HttpResponseRedirect(reverse('django_app:order', args=(order_id,)))
    else:
        form = OrderIdForm()
        return render(request, 'django_app/check_order.html', {"form" : form})


def get_all_orders(request):
    cursor = connection.cursor()
    # print dir(cursor)
    # result = cursor.execute("select * from order_view",)
    # names, types = _row_names_and_types(cursor.description)
    # all_data = result.fetchall()
    # return response.HttpResponse('&nbsp '.join(names)+ '<br>' + '<br>'.join(map(str, all_data)))

    #result = cursor.callfunc('get_client_orders', cx_Oracle.CURSOR,[42])
    result = cursor.callfunc('get_orders_by_worker_login', cx_Oracle.CURSOR, ['nexemjail'])
    row_names = result.description
    data = result.fetchall()
    result.close()
    print(data)
    print(dir(data[0]))
    print(row_names)
    return response.HttpResponse('</br>'.join(str(el) for el in data))
