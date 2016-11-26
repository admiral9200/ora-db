from __future__ import unicode_literals

database_configuration = {
    'admin': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'orcldb',
        'USER': 'c##nexemjail',
        'PASSWORD': 'oraclepassword',
        'HOST': '',
        'PORT': '',
        'OPTIONS': {
            'threaded': True,
        }
    },
    'worker': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'orcldb',
        'USER': 'c##worker_connection',
        'PASSWORD': 'password',
        'HOST': '',
        'PORT': '',
        'OPTIONS': {
            'threaded': True,
        }
    },
    'user': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'orcldb',
        'USER': 'c##user_connection',
        'PASSWORD': 'password',
        'HOST': '',
        'PORT': '',
        'OPTIONS': {
            'threaded': True,
        }
    },
    'default': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'orcldb',
        'USER': 'c##guest_connection',
        'PASSWORD': 'password',
        'HOST': '',
        'PORT': '',
        'OPTIONS': {
            'threaded': True,
        }
    },
}

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
    ],
    'default': [
        'c##default_connection',
        'password'
    ]
}

default_user = 'c##nexemjail'
