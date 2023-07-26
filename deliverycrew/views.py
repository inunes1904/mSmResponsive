import json
from django.http import JsonResponse
from django.shortcuts import render
from restaurant.models import Pedido, Profile
from .utils import check_user_delivery

# Create your views here.
@check_user_delivery
def home_delivery_crew(request):

    user = request.user
    pedidos =  Pedido.objects.all().filter(pedido_pago=True, pedido_entregue=False)
    meus_pedidos = Pedido.objects.all().filter(pedido_pago=True, pedido_entregue=True, 
                                               entregador = user.profile)
    context = {
        'pedidos' : pedidos,
        'pedidos_entregues': meus_pedidos,
        'mesa' : 0,
        'user' : str(user),
        'profile' : user.profile
    }

    for pedido in meus_pedidos:
        if pedido.pedido_pago == True and pedido.pedido_entregue == True:
            pedido.end_pedido
            pedido.save()

    return render(request, 'delivery_crew.html', context)

def make_delivery(request):

    data = json.loads(request.body)
    action = data['action']
    id_pedido = data['id_pedido']
    pedido = Pedido.objects.get(pk=id_pedido)
   
    if action == 'recolher':
        
        pedido.entregador = request.user.profile
    elif action == 'entregar':
        pedido.pedido_entregue = True
    
    pedido.save()

    return JsonResponse('Pedido foi edido com sucesso.', safe=False)