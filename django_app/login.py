from __future__ import print_function
from __future__ import unicode_literals

import cx_Oracle
from django.db import connections, connection
from utils import execute_function

current_connection = 'default'


def get_current_connection():
    return current_connection

role_connection_dict = {
    'admin': [
        'c##nexemjail',
        'oraclepassword'
    ],
    'worker': [
        'c##worker_connection',
        'password'
    ],
    'user': [
        'c##user_connection',
        'password'
    ]

}


def build_connection_string(username, password):
    return username + '/' + password + '@localhost:1521/oracledb'


def login(username, password):
    cursor = connections['default'].cursor()
    user_exists = cursor.callfunc(execute_function('check_user_exists'), cx_Oracle.BOOLEAN, [username, password])
    print(user_exists)
    if user_exists:
        print('user exists')
        role_name = cursor.callfunc(execute_function('get_user_role'), cx_Oracle.FIXED_CHAR, [username, password])
        role_name = role_name.strip()
        if current_connection != role_name:
            print(role_connection_dict[role_name])
            global current_connection
            connections[current_connection].close()
            connections[role_name].connect()
            current_connection = role_name
            print(connections[role_name].connection.username)
            return True
        else:
            return True
    return False

