from __future__ import print_function
from __future__ import unicode_literals

# Create your views here.
import cx_Oracle
from django.db import connection
from django.http import response, HttpResponseRedirect
from django.shortcuts import render
from django.core.urlresolvers import reverse
from django.db.transaction import connections
from utils import prettify_strings, _get_row_names, _row_names_and_types
from list_requests import list_request
from .forms import OrderIdForm, ClientIdForm, LoginForm
from login import login as logging_in
from errors import AccessDeniedError


def get_clients(request):
    try:
        row_names, data = list_request('get_clients')
    except AccessDeniedError:
        return render(request, 'django_app/client_list.html',
                  {"error": True})
    return render(request, 'django_app/client_list.html',
                  {"headers": row_names, "data": data, "error" : False})


def get_offices(request):
    try:
        row_names, data = list_request('get_offices')
        return render(request, 'django_app/offices_list.html',
                      {"headers": row_names, "data": data})
    except AccessDeniedError:
        return render(request, 'django_app/offices_list.html',
                      {"error": True})


def index(request):
    return render(request, 'django_app/index.html')


def get_order_info(request, order_id):
    try:
        row_names, data = list_request('get_order_info', [int(order_id)])
        is_ready_index = row_names.index('Is ready')
        for i, element in enumerate(data):
            data[i] = list(data[i])
            data[i][is_ready_index] = bool(element[is_ready_index])

        return render(request, 'django_app/order_status.html',
                      {"headers": row_names, "data": data})
    except AccessDeniedError:
        return render(request, 'django_app/order_status.html',
                      {"error" : True})


def check_order(request):
    if request.method == 'POST':
        form = OrderIdForm(request.POST)
        if form.is_valid():
            order_id = form.cleaned_data['order_id']
            return HttpResponseRedirect(reverse('django_app:order', args=(order_id,)))
    else:
        form = OrderIdForm()
        return render(request, 'django_app/check_order.html', {"form": form})


def client_orders(request, client_id):
    try:
        row_names, data = list_request('client_orders', [int(client_id)])
        is_ready_index = row_names.index('Is ready')
        for i, element in enumerate(data):
            data[i] = list(data[i])
            data[i][is_ready_index] = bool(element[is_ready_index])

        return render(request, 'django_app/client_orders_list.html',
                      {"headers": row_names, "data": data})
    except AccessDeniedError:
        return render(request, 'django_app/client_orders_list.html',
                      {"error": True})


def check_client_orders(request):
    if request.method == 'POST':
        form = ClientIdForm(request.POST)
        if form.is_valid():
            client_id = form.cleaned_data['client_id']
            return HttpResponseRedirect(reverse('django_app:client_orders', args=(client_id,)))
    else:
        form = ClientIdForm()
        return render(request, 'django_app/check_client_orders.html', {"form": form})


def client_orders_ready_not_returned(request, client_id):
    try:

        row_names, data = list_request('ready_not_returned', [int(client_id)])
        is_ready_index = row_names.index('Is ready')
        for i, element in enumerate(data):
            data[i] = list(data[i])
            data[i][is_ready_index] = bool(element[is_ready_index])

        return render(request, 'django_app/orders_ready_not_returned_list.html',
                      {"headers": row_names, "data": data})
    except AccessDeniedError:
        return render(request, 'django_app/orders_ready_not_returned_list.html',
                      {"error": True})


def check_client_orders_ready_not_returned(request):
    if request.method == 'POST':
        form = ClientIdForm(request.POST)
        if form.is_valid():
            client_id = form.cleaned_data['client_id']
            return HttpResponseRedirect(reverse('django_app:ready_not_returned_orders', args=(client_id,)))
    else:
        form = ClientIdForm()
        return render(request, 'django_app/check_orders_ready_not_returned.html', {"form": form})


def client_info(request, client_id):
    try:
        row_names, data = list_request('client_info', [int(client_id)])
        is_ready_index = row_names.index('Best client')
        for i, element in enumerate(data):
            data[i] = list(data[i])
            data[i][is_ready_index] = bool(element[is_ready_index])

        return render(request, 'django_app/client_info.html',
                      {"headers": row_names, "data": data})
    except AccessDeniedError:
        return render(request, 'django_app/client_info.html',
                      {"error": True})


def check_client_info(request):
    if request.method == 'POST':
        form = ClientIdForm(request.POST)
        if form.is_valid():
            client_id = form.cleaned_data['client_id']
            return HttpResponseRedirect(reverse('django_app:client_info', args=(client_id,)))
    else:
        form = ClientIdForm()
        return render(request, 'django_app/check_client_info.html', {"form": form})


def login(request):
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            login_ = form.cleaned_data['login']
            password = form.cleaned_data['password']
            if logging_in(login_, password):
                return render(request, 'django_app/index.html')
            else:
                return render(request, 'django_app/login_form.html', {"form": form, "message": 'Invalid login'})
    else:
        form = LoginForm()
        return render(request, 'django_app/login_form.html', {"form": form, "message": None})
