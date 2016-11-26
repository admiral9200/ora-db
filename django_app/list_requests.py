from __future__ import print_function
from __future__ import unicode_literals

import cx_Oracle
from django.db import connections
from utils import _get_row_names, get_full_name
from errors import AccessDeniedError


def list_request(request, function_name, args=None):
    if args is None:
        args = []
    if request.COOKIES. has_key('connection'):
        current_connection = request.COOKIES['connection']
    else:
        current_connection = 'default'

    try:
        cursor = connections[current_connection].cursor()
        # print(connections[current_connection].connection.username)
        client_cursor = cursor.callfunc(get_full_name(function_name), cx_Oracle.CURSOR, args)

        data = client_cursor.fetchall()
        # print(len(data))
        row_names = _get_row_names(client_cursor.description)

        return row_names, data
    except cx_Oracle.DatabaseError:
        raise AccessDeniedError()
