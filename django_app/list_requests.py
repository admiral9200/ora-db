from __future__ import print_function
from __future__ import unicode_literals

import cx_Oracle
from django.db import connection
from utils import prettify_strings, _get_row_names, _row_names_and_types


def list_request(function_name, args = None):
    cursor = connection.cursor()
    client_cursor = cursor.callfunc(function_name, cx_Oracle.CURSOR, args)

    data = client_cursor.fetchall()
    # print(len(data))
    row_names = _get_row_names(client_cursor.description)

    return row_names, data