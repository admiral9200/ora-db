from django.conf import settings
from django.db import connections


def _get_ith_element(collection, element_index=0):
    return [el[element_index] for el in collection]


def prettify_strings(string_list):
    return [s.lower().replace('_', ' ').capitalize() for s in string_list]


def _row_names_and_types(description):
    return _get_ith_element(description, 0), _get_ith_element(description, 1)


def _get_row_names(description):
    return prettify_strings(_get_ith_element(description, 0))


def get_full_name(func_name):
    return settings.DEFAULT_USER + '.' + func_name


def get_cursor(request):
    current_connection = request.COOKIES['connection']
    connections[current_connection].connect()
    return connections[current_connection].cursor()

