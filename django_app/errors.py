from cx_Oracle import DatabaseError


class AccessDeniedError(DatabaseError):
    pass