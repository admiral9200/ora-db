from __future__ import print_function
from __future__ import unicode_literals

import cx_Oracle
from django.db import connections

from utils import execute_function

current_connection = 'default'


def get_current_connection():
    return current_connection


def build_connection_string(username, password):
    return username + '/' + password + '@localhost:1521/oracledb'


def logout(request):
    del request.COOKIES['connection']
    del request.COOKIES['username']
    del request.COOKIES['client_id']
    return True


def login(username, password):
    # TODO: check for returning user ib db
    # connection_name = request.session.get('connection', 'default')
    cookie_dict = {}
    cursor = connections['default'].cursor()
    user_exists = cursor.callfunc(execute_function('check_user_in_db'), cx_Oracle.BOOLEAN, [username, password])
    if user_exists:
        role_name = cursor.callfunc(execute_function('get_user_role'),
                                    cx_Oracle.FIXED_CHAR, [username, password])
        role_name = role_name.strip()
        cookie_dict['username'] = username
        cookie_dict['connection'] = role_name
        connections['default'].close()
        connections[role_name].connect()
        cursor = connections[role_name].cursor()
        client_id = int(cursor.callfunc(execute_function('get_client_id'), cx_Oracle.NUMBER, [username]))
        if client_id == 0:
            cookie_dict['client_id'] = None
        else:
            cookie_dict['client_id'] = client_id
        return True, cookie_dict
    return False, None


def register(username, password, client_id):

    cursor = connections['default'].cursor()

    registration_successful = cursor.callfunc(execute_function('register_user'), cx_Oracle.BOOLEAN, [username, password, client_id])

    if registration_successful:
        return True
    else:
        return False


def insert_order(request, client_id, service_type_id, service_bonus_id, office_id,
                 worker_login, amount,discount_type_id= None, acceptance_date=None):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        cursor.callproc(execute_function('insert_order'),
                        [client_id, service_type_id, service_bonus_id,
                            office_id, worker_login,discount_type_id,
                            amount, acceptance_date])
        return True
    except cx_Oracle.DatabaseError:
        return False


def return_order(request, order_id):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        cursor.callproc(execute_function('update_order_return_date'), [int(order_id)])
        return True
    except cx_Oracle.DatabaseError:
        return False


def set_order_ready(request, order_id):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        cursor.callproc(execute_function('UPDATE_ORDER_READY_STATUS'), [int(order_id), 1])
        return True
    except cx_Oracle.DatabaseError:
        return False


def update_client(request,first_name, last_name, client_id):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        cursor.callproc(execute_function('UPDATE_CLIENT_INFO'), [first_name, last_name, int(client_id)])
        return True
    except cx_Oracle.DatabaseError:
        return False


def update_user_password(request, username, password):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        cursor.callproc(execute_function('update_user_password'), [username, password])
        return True
    except cx_Oracle.DatabaseError:
        return False


def create_user_in_db(request, login, password, role):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        role_id = cursor.callfunc(execute_function('get_role_id_by_name'), cx_Oracle.NUMBER, [role])
        cursor.callproc(execute_function('insert_user'), [login, password, int(role_id), None])
        return True
    except cx_Oracle.DatabaseError as e:
        print(e)
        return False


def create_bonus_in_db(request, type, value):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        cursor.callproc(execute_function('insert_bonus'), [type, value])
        return True
    except cx_Oracle.DatabaseError as e:
        print(e)
        return False


def call_function_in_db(request, func_name, args = None):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        return cursor.callfunc(execute_function(func_name), args)
    except cx_Oracle.DatabaseError as e:
        return False


def call_procedure_in_db(request, func_name, args = None):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    cursor = connections[current_connection].cursor()
    try:
        cursor.callproc(execute_function(func_name), args)
        return True
    except cx_Oracle.DatabaseError as e:
        return False
