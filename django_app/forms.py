from django import forms


class OrderIdForm(forms.Form):
    order_id = forms.IntegerField(label='Order id' , min_value=1)
