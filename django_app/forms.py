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
        id_[i], data[i] = element[0], element[1:]
    return id_, data


class OrderForm(forms.Form):
    client_id = forms.ChoiceField(label='Client ', required=True)
    service_type_id = forms.ChoiceField(label='Service type ', required=True)
    service_bonus_id = forms.ChoiceField(label='Service bonus', required=False)
    amount = forms.IntegerField(label='Amount ', min_value=1, required=True)
    office_id = forms.ChoiceField(label='Office', required=True)
    discount_type_id = forms.ChoiceField(label='Discount ', required=False)

    def __init__(self, *args, **kwargs):
        if 'request' in kwargs.keys():
            request = kwargs['request']
            del kwargs['request']
        else:
            return
        super(OrderForm, self).__init__(*args, **kwargs)
        _, data = list_request(request, 'get_service_types')
        self.fields['service_type_id'].choices = [(int(element[0]),
                                                   ' '.join(map(str, element[1:]))) for element in data]

        _, data = list_request(request, 'get_bonuses')
        self.fields['service_bonus_id'].choices = [(int(element[0]),
                                                    ' '.join(map(str, element[1:]))) for element in data]\
                                                  + [(None, "None")]

        _, data = list_request(request, 'get_clients')
        self.fields['client_id'].choices = [(int(element[0]),
                                             ' '.join(map(str, element[1:]))) for element in data]

        _, data = list_request(request, 'get_discount_types')
        self.fields['discount_type_id'].choices = [(int(element[0]),
                                                    ' '.join(map(str, element[1:]))) for element in data]\
                                                + [(None, "None")]

        _, data = list_request(request, 'get_offices')
        self.fields['office_id'].choices = [(int(element[0]), ' '.join(map(str, element[1:]))) for element in data]


class OrderFormToValidate(forms.Form):
    client_id = forms.IntegerField(label='Client ', required=True)
    service_type_id = forms.IntegerField(label='Service type ', required=True)
    service_bonus_id = forms.IntegerField(label='Service bonus', required=False)
    amount = forms.IntegerField(label='Amount ', min_value=1, required=True)
    office_id = forms.IntegerField(label='Office', required=True)
    discount_type_id = forms.IntegerField(label='Discount ', required=False, min_value=1)


class ClientForm(forms.Form):
    first_name = forms.CharField(label='First Name', required=True)
    last_name = forms.CharField(label='Last name', required=True)


class ChangePasswordForm(forms.Form):
    password_1 = forms.CharField(widget=forms.PasswordInput, label='Password new')
    password_2 = forms.CharField(widget=forms.PasswordInput, label='Password new')


    def clean(self):
        if self.cleaned_data['password_1'] != self.cleaned_data['password_2']:
            raise forms.ValidationError('Passwords must match!')
        return self.cleaned_data


class CreateUserForm(forms.Form):
    login = forms.CharField(required=True)
    password = forms.CharField(widget=forms.PasswordInput, required=True)
    role = forms.ChoiceField(required=True)

    def __init__(self, *args, **kwargs):
        if 'request' in kwargs.keys():
            request = kwargs['request']
            del kwargs['request']
        else:
            return
        super(CreateUserForm, self).__init__(*args, **kwargs)
        _, roles = list_request(request, 'get_roles')
        roles_as_list = map(lambda x: x[0], roles)
        self.fields['role'].choices = zip(roles_as_list, roles_as_list)


class BonusForm(forms.Form):
    type = forms.CharField(required=True, label='Type ')
    value = forms.FloatField(min_value=0, max_value=100, label='Bonus value', required=True)


class DiscountForm(forms.Form):
    description = forms.CharField(required=True, label='Type ')
    value = forms.FloatField(min_value=0, max_value=100, label='Discount value', required=True)


class ServiceForm(forms.Form):
    name = forms.CharField(required=True, label='Name ')
    price = forms.FloatField(min_value=0, label='Base price ', required=True)


class OfficeForm(forms.Form):
    location = forms.CharField(required=True, label='Location ')
    description = forms.CharField(label='Description ', required=True)