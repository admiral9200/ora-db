from __future__ import unicode_literals
from django import forms
from list_requests import list_request


class OrderIdForm(forms.Form):
    order_id = forms.IntegerField(label='Order id\n', min_value=1)


class ClientIdForm(forms.Form):
    client_id = forms.IntegerField(label='Client id\n', min_value=1)


class LoginForm(forms.Form):
    login = forms.CharField(label='Login ', required=True)
    password = forms.CharField(widget=forms.PasswordInput, label='Password ')


class RegistrationForm(forms.Form):
    login = forms.CharField(label='Login ', required=True)
    password = forms.CharField(widget=forms.PasswordInput, label='Password ', required=True)
    client_id = forms.IntegerField(label='Client ID ', min_value=1, required=True)


def split_id(data):
    id_ = []
    for i, element in enumerate(data):
        data[i] = element[1:]
        id_[i] = element[0]
    return id_, data


class OrderForm(forms.Form):
    client_id = forms.ChoiceField(label='Client ', required=True)
    service_type_id = forms.ChoiceField(label='Service type ', required=True)
    service_bonus_id = forms.ChoiceField(label='Service bonus', required=False)
    amount = forms.IntegerField(label='Amount ', min_value=1, required=True)
    office_id = forms.ChoiceField(label='Office', required=True)
    discount_type_id = forms.ChoiceField(label='Discount ', required=True)

    def __init__(self, *args, **kwargs):
        request = None
        if 'request' in kwargs.keys():
            request = kwargs['request']
            del kwargs['request']
        super(OrderForm, self).__init__(*args, **kwargs)
        if request:

            _, data = list_request(request, 'get_service_types')
            self.fields['service_type_id'].choices = [(int(element[0]), ' '.join(map(str, element[1:]))) for element in data]

            _, data = list_request(request, 'get_bonuses')
            self.fields['service_bonus_id'].choices = [(int(element[0]), ' '.join(map(str, element[1:]))) for element in data] + [(None, "None")]

            _, data = list_request(request, 'get_clients')
            self.fields['client_id'].choices = [(int(element[0]), ' '.join(map(str, element[1:]))) for element in data]

            _, data = list_request(request, 'get_discount_types')
            self.fields['discount_type_id'].choices = [(int(element[0]), ' '.join(map(str, element[1:]))) for element in data]  + [(None, "None")]

            _, data = list_request(request, 'get_offices')
            self.fields['office_id'].choices = [(int(element[0]), ' '.join(map(str, element[1:]))) for element in data]


class OrderFormToValidate(forms.Form):
    client_id = forms.IntegerField(label='Client ', required=True)
    service_type_id = forms.IntegerField(label='Service type ', required=True)
    service_bonus_id = forms.IntegerField(label='Service bonus', required=False)
    amount = forms.IntegerField(label='Amount ', min_value=1, required=True)
    office_id = forms.IntegerField(label='Office', required=True)
    discount_type_id = forms.IntegerField(label='Discount ', required=False, min_value=1)
