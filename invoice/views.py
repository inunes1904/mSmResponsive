from datetime import datetime
from django.shortcuts import render
from .utils import base64ToString
from django.contrib.auth.models import User
from restaurant.models import Pedido

# Create your views here.
def invoice(request, user_id, invoice_id):

    id_user = base64ToString(user_id)
    numero_transacao = base64ToString(invoice_id)

    user_client = User.objects.get(pk=id_user)
    pedido_user = Pedido.objects.get(numero_transacao=numero_transacao)

    

    context = {
        'client': user_client,
        'pedido': pedido_user,
        'date': datetime.now().strftime("%d/%m/%Y"),
    }

    return render(request, 'invoice.html', context)