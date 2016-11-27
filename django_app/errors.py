from __future__ import unicode_literals
from cx_Oracle import DatabaseError


ACCESS_DENIED_MESSAGE = 'Access denied!'


class AccessDeniedError(DatabaseError):
    pass