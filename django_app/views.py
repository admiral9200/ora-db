from __future__ import print_function, unicode_literals
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.contrib import messages
from django.core.urlresolvers import reverse
from list_requests import list_request
from .forms import \
(
    OrderIdForm,
    ClientIdForm,
    LoginForm,
    RegistrationForm,
    OrderForm,
    OrderFormToValidate,
    ClientForm,
    ChangePasswordForm,
    CreateUserForm,
    BonusForm,
    DiscountForm,
    ServiceForm,
    OfficeForm
)
from .db_functions import \
(
    login as logging_in,
    register as register_in_db,
    insert_order,
    mark_order_returned as set_order_status_to_returned,
    set_order_ready,
    update_client as update_client_in_db,
    update_user_password,
    create_user_in_db,
    create_bonus_in_db,\
    call_procedure_in_db,
    call_function_in_db
)

from errors import AccessDeniedError, ACCESS_DENIED_MESSAGE
from utils import to_index_page, convert_to_type


def change_password(request):
    if request.method == 'POST':
        form = ChangePasswordForm(request.POST)
        if form.is_valid():
            if update_user_password(request, request.COOKIES['username'], form.cleaned_data['password_1']):
                messages.info(request, 'Password changed successfully')
                return to_index_page()
    else:
        form = ChangePasswordForm()
    return render(request, 'django_app/update_pass_form.html', {'form': form})


def get_clients(request):
    try:
        row_names, data = list_request(request, 'get_clients')
    except AccessDeniedError:
        messages.error(request, ACCESS_DENIED_MESSAGE)
        return render(request, 'django_app/client_list.html')
    return render(request, 'django_app/client_list.html',
                  {"headers": row_names, "data": data,
                   'extra_thing': {'url': 'django_app:update_client',
                                   'text': 'Update client'}})


def update_client(request, client_id):
    if request.method == 'POST':
        form = ClientForm(request.POST)
        if form.is_valid():
            if update_client_in_db(request,
                                   form.cleaned_data['first_name'],
                                   form.cleaned_data['last_name'],
                                   client_id):
                messages.info(request, 'Client updated successfully')
            else:
                messages.error(request, 'Error while updating')
            return to_index_page()
    else:
        row_names, record = list_request(request, 'client_info', [int(client_id)])
        client_id, first_name, last_name, best_client = record[0]
        form = ClientForm(data={'first_name': first_name, 'last_name': last_name, 'best_client': best_client})
    return render(request, 'django_app/client_form.html', {'form': form, 'id': client_id})


def client_info(request, client_id):
    try:
        row_names, data = list_request(request, 'client_info', [int(client_id)])
        is_ready_index = row_names.index('Best client')
        data = convert_to_type(data, bool, is_ready_index)

        return render(request, 'django_app/client_info.html',
                      {"headers": row_names, "data": data,
                       'extra_thing': {'url': 'django_app:update_client', 'text': 'Update client'}
                       })
    except AccessDeniedError:
        messages.error(request, ACCESS_DENIED_MESSAGE)
        return render(request, 'django_app/client_info.html')


def get_offices(request):
    try:
        row_names, data = list_request(request, 'get_offices')
        extra_thing = None
        if 'connection' in request.COOKIES and request.COOKIES['connection'] == 'admin':
            extra_thing = {'url': 'django_app:update_office', 'text': 'Update office'}
        return render(request, 'django_app/list_template.html',
                      {"headers": row_names, "data": data, 'extra_thing': extra_thing})
    except AccessDeniedError:
        messages.error(request, ACCESS_DENIED_MESSAGE)
        return render(request, 'django_app/list_template.html')


def update_office(request, office_id):
    if request.method == 'POST':
        form = OfficeForm(request.POST)
        if form.is_valid():
            if call_procedure_in_db(request, 'update_office_by_id',
                                    [int(office_id),
                                     form.cleaned_data['location'],
                                     form.cleaned_data['description']]):
                messages.info(request, 'Office updated!')
            else:
                messages.error(request, 'Error while updating')
            return to_index_page()
    else:
        row_names, record = list_request(request, 'get_office_by_id', [int(office_id)])
        _, loc, description = record[0]
        form = OfficeForm(data={'location': loc, 'description': description})
    return render(request, 'django_app/edit_form_template.html', {'form': form, 'id': office_id,
                                                                  'url_': 'django_app:update_office'})


def get_order_info(request, order_id):
    try:
        row_names, data = list_request(request, 'get_order_info', [int(order_id)])
        is_ready_index = row_names.index('Is ready')

        data = convert_to_type(data, bool, is_ready_index)
        return render(request, 'django_app/order_status.html',
                      {"headers": row_names, "data": data})
    except AccessDeniedError:
        messages.error(request, ACCESS_DENIED_MESSAGE)
        return render(request, 'django_app/order_status.html')


def check_order(request):
    if request.method == 'POST':
        form = OrderIdForm(request.POST)
        if form.is_valid():
            return HttpResponseRedirect(reverse('django_app:order', args=(form.cleaned_data['order_id'],)))
    else:
        form = OrderIdForm()
    return render(request, 'django_app/check_order.html', {"form": form})


def client_orders(request, client_id):
    try:
        row_names, data = list_request(request, 'client_orders', [int(client_id)])
        is_ready_index = row_names.index('Is ready')
        data = convert_to_type(data, bool, is_ready_index)

        return render(request, 'django_app/client_orders_list.html',
                      {"headers": row_names, "data": data})
    except AccessDeniedError:
        messages.error(request, ACCESS_DENIED_MESSAGE)
        return render(request, 'django_app/client_orders_list.html')


def check_client_orders(request):
    if request.method == 'POST':
        form = ClientIdForm(request.POST)
        if form.is_valid():
            return HttpResponseRedirect(reverse('django_app:client_orders',
                                                args=(form.cleaned_data['client_id'],)))
    else:
        form = ClientIdForm()
    return render(request, 'django_app/check_client_orders.html', {"form": form})


def all_ready_not_returned_orders(request):
    try:
        row_names, data = list_request(request, 'get_ready_not_returned_orders')
        is_ready_index = row_names.index('Is ready')
        data = convert_to_type(data, bool, is_ready_index)

        extra_thing = None
        if 'connection' in request.COOKIES and request.COOKIES['connection'] == 'worker':
            extra_thing = {'url': 'django_app:return_order', 'text': 'Return'}
        return render(request, 'django_app/orders_ready_not_returned_list.html',
                      {"headers": row_names, "data": data, 'extra_thing': extra_thing})
    except AccessDeniedError:
        messages.error(request, ACCESS_DENIED_MESSAGE)
        return render(request, 'django_app/orders_ready_not_returned_list.html')


def client_orders_ready_not_returned(request, client_id):
    try:
        row_names, data = list_request(request, 'ready_not_returned', [int(client_id)])
        is_ready_index = row_names.index('Is ready')
        data = convert_to_type(data, bool, is_ready_index)

        extra_thing = None
        if 'connection' in request.COOKIES and request.COOKIES['connection'] == 'worker':
            extra_thing = {'url': 'django_app:return_order', 'text': 'Return'}
        return render(request, 'django_app/orders_ready_not_returned_list.html',
                      {"headers": row_names, "data": data, 'extra_thing': extra_thing})
    except AccessDeniedError:
        messages.error(request, ACCESS_DENIED_MESSAGE)

        return render(request, 'django_app/orders_ready_not_returned_list.html')


def check_client_orders_ready_not_returned(request):
    if request.method == 'POST':
        form = ClientIdForm(request.POST)
        if form.is_valid():
            return HttpResponseRedirect(reverse('django_app:ready_not_returned_orders',
                                                args=(form.cleaned_data['client_id'],)))
    else:
        form = ClientIdForm()
    return render(request, 'django_app/check_orders_ready_not_returned.html', {"form": form})


def check_client_info(request):
    if request.method == 'POST':
        form = ClientIdForm(request.POST)
        if form.is_valid():
            return HttpResponseRedirect(reverse('django_app:client_info',
                                                args=(form.cleaned_data['client_id'],)))
    else:
        form = ClientIdForm()
    return render(request, 'django_app/check_client_info.html', {"form": form})


def logout(request):
    resp = to_index_page()
    resp.delete_cookie('username')
    resp.delete_cookie('connection')
    resp.delete_cookie('client_id')
    return resp


def login(request):
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            login_successful, cookie_values = logging_in(form.cleaned_data['login'],
                                                         form.cleaned_data['password'])
            if login_successful:
                messages.info(request, 'Login successful')
                resp = to_index_page()
                resp.set_cookie('username', cookie_values['username'])
                resp.set_cookie('connection', cookie_values['connection'])
                resp.set_cookie('client_id', cookie_values['client_id'])
                return resp
            messages.error(request,  'Login failed')
        else:
            messages.error(request, 'Invalid form')
        return render(request, 'django_app/login_form.html', {"form": form})
    else:
        form = LoginForm()
    return render(request, 'django_app/login_form.html', {"form": form})


def register(request):
    if request.method == 'POST':
        form = RegistrationForm(request.POST)
        if form.is_valid():
            if register_in_db(form.cleaned_data['login'],
                              form.cleaned_data['password'],
                              form.cleaned_data['client_id']):
                messages.info(request, 'Registration was successfull. You can login now')
                return to_index_page()
        messages.error(request, 'Form in invalid. Try again')
        return render(request, 'django_app/registration_form.html', {"form": form})
    else:
        form = RegistrationForm()
    return render(request, 'django_app/registration_form.html', {"form": form})


def update_service(request, service_id):
    if request.method == 'POST':
        form = ServiceForm(request.POST)
        if form.is_valid():
            if call_procedure_in_db(request, 'update_service_by_id',
                                    [int(service_id),
                                     form.cleaned_data['name'],
                                     form.cleaned_data['price']]):
                messages.info(request, 'Service updated')
            else:
                messages.error(request, 'Service update error')
            return to_index_page()
    else:
        row_names, record = list_request(request, 'get_service_by_id', [int(service_id)])
        _, name, price = record[0]
        form = ServiceForm(data={'name': name, 'price': price})
    return render(request, 'django_app/edit_form_template.html', {'form': form, 'id': service_id,
                                                                  'url_': 'django_app:update_service'})


def services(request):
    row_names, data = list_request(request, 'get_service_types')
    extra_thing = None
    if 'connection' in request.COOKIES and request.COOKIES['connection'] == 'admin':
        extra_thing = {'url': 'django_app:update_service', 'text': 'Edit service'}
    return render(request, 'django_app/service_types_list.html',
                  {"headers": row_names, "data": data, "extra_thing": extra_thing})


def order(request):
    if request.method == 'POST':
        form = OrderFormToValidate(request.POST)
        if form.is_valid():
            if insert_order(request,
                            form.cleaned_data['client_id'],
                            form.cleaned_data['service_type_id'],
                            form.cleaned_data['service_bonus_id'] or None,
                            form.cleaned_data['office_id'],
                            request.COOKIES['username'],
                            form.cleaned_data['amount'],
                            form.cleaned_data['discount_type_id'] or None):
                messages.info(request, 'Order added')
                return to_index_page()
        else:
            form = OrderForm(request=request, data=form.data)
            messages.error(request, 'Invalid form data')
    else:
        form = OrderForm(request=request)
    return render(request, 'django_app/order_form.html', {"form": form})


def all_orders(request):
    row_names, data = list_request(request, 'get_orders')
    return render(request, 'django_app/orders_list.html', {'data': data, 'headers': row_names})


def set_order_ready_status(request, order_id):
    order_id = int(order_id)
    if set_order_ready(request, order_id):
        messages.info(request, 'Status READY set')
        return HttpResponseRedirect(reverse('django_app:all_orders'),)
    messages.error(request, 'Error while setting status to READY')
    return to_index_page()


def return_order(request, order_id):
    order_id = int(order_id)
    if set_order_status_to_returned(request, order_id):
        messages.info(request, messages.INFO, 'Status RETURNED set')
    else:
        messages.error(request, "Error while setting status to order")
    return to_index_page()


def create_user(request):
    if request.method == 'POST':
        form = CreateUserForm(request.POST, request=request)
        if form.is_valid():
            if create_user_in_db(request, form.cleaned_data['login'],
                                 form.cleaned_data['password'],
                                 form.cleaned_data['role']):
                messages.info(request,  'User created')
            else:
                messages.error(request, "Error while creating a user")
            return to_index_page()
        messages.error(request, 'Form is invalid')
    else:
        form = CreateUserForm(request=request)
    return render(request, 'django_app/create_user_form.html', {'form': form})


def create_bonus(request):
    if request.method == 'POST':
        form = BonusForm(request.POST)
        if form.is_valid():
            if create_bonus_in_db(request,
                                  form.cleaned_data['type'],
                                  form.cleaned_data['value']):
                messages.info(request, 'Bonus created')
            else:
                messages.error(request, 'Error while creating a bonus')
            return to_index_page()
        messages.error(request, 'Form is invalid')
    else:
        form = BonusForm()
    return render(request, 'django_app/bonus_form.html', {'form': form})


def get_bonuses(request):
    row_names, data = list_request(request, 'get_bonuses')
    extra_thing = None
    if 'connection' in request.COOKIES and request.COOKIES['connection'] == 'admin':
        extra_thing = {'url': 'django_app:update_bonus', 'text': 'Update bonus'}
    return render(request, 'django_app/list_template.html', {'data': data, 'headers': row_names,
                                                             'extra_thing': extra_thing})


def update_bonus(request, bonus_id):
    if request.method == 'POST':
        form = BonusForm(request.POST)
        if form.is_valid():
            if call_procedure_in_db(request, 'update_bonus_by_id',
                                    [int(bonus_id),
                                     form.cleaned_data['type'],
                                     form.cleaned_data['value']]
                                    ):
                messages.info(request, 'Bonus updated')
            else:
                messages.error(request, 'Error while updating')
            return to_index_page()
    else:
        row_names, record = list_request(request, 'get_bonus_by_id', [int(bonus_id)])
        _, type_, value = record[0]
        form = BonusForm(data={'type': type_, 'value': value})
    return render(request, 'django_app/edit_form_template.html', {'form': form, 'id': bonus_id,
                                                                      'url_': 'django_app:update_bonus'})


def create_discount(request):
    if request.method == 'POST':
        form = DiscountForm(request.POST)
        if form.is_valid():
            if call_procedure_in_db(request, 'insert_discount_type',
                                    [form.cleaned_data['description'], form.cleaned_data['value']]):
                messages.info(request, 'Discount created')
            else:
                messages.error(request, 'Error while creating a discount')
            return to_index_page()
        messages.error(request, 'Form is invalid')
    else:
        form = DiscountForm()
    return render(request, 'django_app/form_template.html',
                  {'form': form, 'url_': 'django_app:create_discount'})


def get_discounts(request):
    row_names, data = list_request(request, 'get_discount_types')
    extra_thing = None
    if 'connection' in request.COOKIES and request.COOKIES['connection'] == 'admin':
        extra_thing = {'url': 'django_app:update_discount', 'text': 'Update discount'}
    return render(request, 'django_app/list_template.html', {'data': data, 'headers': row_names,
                                                             'extra_thing': extra_thing})


def update_discount(request, discount_id):
    if request.method == 'POST':
        form = DiscountForm(request.POST)
        if form.is_valid():
            if call_procedure_in_db(request, 'update_discount_by_id',
                                    [int(discount_id),
                                     form.cleaned_data['description'],
                                     form.cleaned_data['value']]):
                messages.info(request, 'Discount updated')
            else:
                messages.error(request, 'Error while updating a discount')
            return to_index_page()
    else:
        row_names, record = list_request(request, 'get_discount_by_id', [int(discount_id)])
        _, desr, val = record[0]
        form = DiscountForm(data={'description': desr, 'value': val})
    return render(request, 'django_app/edit_form_template.html', {'form': form, 'id': discount_id,
                                                                  'url_': 'django_app:update_discount'})


def create_service(request):
    if request.method == 'POST':
        form = ServiceForm(request.POST)
        if form.is_valid():
            if call_procedure_in_db(request, 'insert_service_type',
                                    [form.cleaned_data['name'],
                                     form.cleaned_data['price']]):
                messages.info(request, 'Service created')
            else:
                messages.error(request, 'Error while creating a service')
            return to_index_page()
        messages.error(request, 'Form is invalid')
    else:
        form = ServiceForm()
    return render(request, 'django_app/form_template.html',
                  {'form': form, 'url_': 'django_app:create_service'})


def create_office(request):
    if request.method == 'POST':
        form = OfficeForm(request.POST)
        if form.is_valid():
            if call_procedure_in_db(request, 'insert_office',
                                    [form.cleaned_data['location'],
                                     form.cleaned_data['description']]):
                messages.info(request, 'Office created')
            else:
                messages.error(request, 'Error while creating an office')
            return to_index_page()
        messages.error(request, 'Form is invalid')
    else:
        form = OfficeForm()
    return render(request, 'django_app/form_template.html',
                  {'form': form, 'url_': 'django_app:create_office'})


def create_client(request):
    if request.method == 'POST':
        form = ClientForm(request.POST)
        if form.is_valid():
            value = call_function_in_db(request, 'insert_client_v2',
                                    args=[form.cleaned_data['first_name'],
                                          form.cleaned_data['last_name'],
                                          0])
            if value and int(value) > 0:
                messages.info(request, 'Client created with id: {} '.format(value))
            else:
                messages.error(request, 'Error occurred while creating a client')
            return to_index_page()
        messages.error(request, 'Form is invalid')
    else:
        form = ClientForm()
    return render(request, 'django_app/form_template.html',
                  {'form': form, 'url_': 'django_app:create_client'})