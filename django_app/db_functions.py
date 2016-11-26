from __future__ import print_function
from __future__ import unicode_literals

import cx_Oracle
from django.db import connections

from utils import get_full_name, get_cursor
import logging


def login(username, password):
    # TODO: check for returning user ib db
    # connection_name = request.session.get('connection', 'default')
    cookie_dict = {}
    cursor = connections['default'].cursor()
    user_exists = cursor.callfunc(get_full_name('check_user_in_db'), cx_Oracle.BOOLEAN, [username, password])
    if user_exists:
        role_name = cursor.callfunc(get_full_name('get_user_role'),
                                    cx_Oracle.FIXED_CHAR, [username, password])
        role_name = role_name.strip()
        cookie_dict['username'] = username
        cookie_dict['connection'] = role_name
        connections['default'].close()
        connections[role_name].connect()
        cursor = connections[role_name].cursor()
        client_id = int(cursor.callfunc(get_full_name('get_client_id'), cx_Oracle.NUMBER, [username]))
        if client_id == 0:
            cookie_dict['client_id'] = None
        else:
            cookie_dict['client_id'] = client_id
        return True, cookie_dict
    return False, None


def register(username, password, client_id):

    cursor = connections['default'].cursor()

    registration_successful = cursor.callfunc(get_full_name('register_user'), cx_Oracle.BOOLEAN, [username, password, client_id])

    if registration_successful:
        return True
    else:
        return False


def insert_order(request, client_id, service_type_id, service_bonus_id, office_id,
                 worker_login, amount,discount_type_id= None, acceptance_date=None):
    # current_connection = request.COOKIES['connection']
    # connections[current_connection].connect()
    # cursor = connections[current_connection].cursor()
    # try:
    #     cursor.callproc(get_full_name('insert_order'),
    #                     [client_id, service_type_id, service_bonus_id,
    #                         office_id, worker_login,discount_type_id,
    #                         amount, acceptance_date])
    #     return True
    # except cx_Oracle.DatabaseError:
    #     return False
    return call_procedure_in_db(request, 'insert_order', [client_id, service_type_id, service_bonus_id,
                            office_id, worker_login,discount_type_id,
                            amount, acceptance_date])


def mark_order_returned(request, order_id):
    # current_connection = request.COOKIES['connection']
    # connections[current_connection].connect()
    # cursor = connections[current_connection].cursor()
    # try:
    #     cursor.callproc(get_full_name('update_order_return_date'), [int(order_id)])
    #     return True
    # except cx_Oracle.DatabaseError:
    #     return False
    return call_procedure_in_db(request, 'update_order_return_date', [int(order_id)])


def set_order_ready(request, order_id):
    # current_connection = request.COOKIES['connection']
    # connections[current_connection].connect()
    # cursor = connections[current_connection].cursor()
    # try:
    #     cursor.callproc(get_full_name('UPDATE_ORDER_READY_STATUS'), [int(order_id), 1])
    #     return True
    # except cx_Oracle.DatabaseError:
    #     return False
    return call_procedure_in_db(request, 'UPDATE_ORDER_READY_STATUS', [int(order_id), 1])


def update_client(request,first_name, last_name, client_id):
    # current_connection = request.COOKIES['connection']
    # connections[current_connection].connect()
    # cursor = connections[current_connection].cursor()
    # try:
    #     cursor.callproc(get_full_name('UPDATE_CLIENT_INFO'), [first_name, last_name, int(client_id)])
    #     return True
    # except cx_Oracle.DatabaseError:
    #     return False
    return call_procedure_in_db(request, 'UPDATE_CLIENT_INFO', [first_name, last_name, int(client_id)])


def update_user_password(request, username, password):
    # current_connection = request.COOKIES['connection']
    # connections[current_connection].connect()
    # cursor = connections[current_connection].cursor()
    # try:
    #     cursor.callproc(get_full_name('update_user_password'), [username, password])
    #     return True
    # except cx_Oracle.DatabaseError:
    #     return False
    return call_procedure_in_db(request, 'update_user_password', [username, password])


def create_user_in_db(request, login, password, role):
    # current_connection = request.COOKIES['connection']
    # connections[current_connection].connect()
    # cursor = connections[current_connection].cursor()
    # try:
    #     role_id = cursor.callfunc(get_full_name('get_role_id_by_name'), cx_Oracle.NUMBER, [role])
    #     cursor.callproc(get_full_name('insert_user'), [login, password, int(role_id), None])
    #     return True
    # except cx_Oracle.DatabaseError as e:
    #     print(e)
    #     return False
    role_id = call_function_in_db(request, 'get_role_id_by_name', args=[role])
    return call_procedure_in_db(request, 'insert_user', [login, password, int(role_id), None])


def create_bonus_in_db(request, type_, value):
    # current_connection = request.COOKIES['connection']
    # connections[current_connection].connect()
    # cursor = connections[current_connection].cursor()
    # try:
    #     cursor.callproc(get_full_name('insert_bonus'), [type, value])
    #     return True
    # except cx_Oracle.DatabaseError as e:
    #     print(e)
    #     return False
    return call_procedure_in_db(request, 'insert_bonus', [type_, value])


def call_function_in_db(request, func_name, return_type=cx_Oracle.NUMBER, args=None, cast_func=None):
    """
    Call db function
    :param request: need to extract connection date
    :param func_name: name of function to call
    :param return_type: cx_Oracle type of result
    :param args: arguments to call function
    :param cast_func: optional function to cast the result.
     Specify it to the desired return type or you will get string
    :return:
    """
    cursor = get_cursor(request)
    try:
        result = cursor.callfunc(get_full_name(func_name), return_type, args)
        return result if cast_func is None else cast_func(result)
    except cx_Oracle.DatabaseError as e:
        logging.error('Error at call db  function {}: {}'.format(func_name, str(e)))
        return None


def call_procedure_in_db(request, proc_name, args=None):
    cursor = get_cursor(request)
    try:
        cursor.callproc(get_full_name(proc_name), args)
        return True
    except cx_Oracle.DatabaseError as e:
        logging.error('Error at call db  procedure {}{: {}'.format(proc_name, str(e)))
        return False
