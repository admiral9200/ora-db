from __future__ import unicode_literals
from django import forms


class OrderIdForm(forms.Form):
    order_id = forms.IntegerField(label='Order id\n', min_value=1)


class ClientIdForm(forms.Form):
    client_id = forms.IntegerField(label='Client id\n', min_value=1)


class LoginForm(forms.Form):
    login = forms.CharField(label='Login ', required=True)
    password = forms.CharField(widget=forms.PasswordInput, label='Password ')

