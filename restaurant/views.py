import datetime
import json
from django.http import HttpResponse, JsonResponse
from django.shortcuts import redirect, render
from .utils import getAllitems
from .models import Restaurante, Item, Pedido, ItemPedido
from django.contrib.auth.models import User
from user.models import Profile
from django.db.models import Q


# Create your views here.

def home(request, nmesa):

    user = request.user
    print(request.user.groups.filter(name="delivery").exists())
    if request.user.groups.filter(name="delivery").exists():
        redirect('home_delivery_crew') 
    try:
        user_obj = User.objects.get(pk=request.user.id)
        
        if user_obj.groups.filter(name='admin').exists() or \
                user_obj.groups.filter(name='rest_admin').exists() or \
                user_obj.is_superuser:
            result = True
    except:
        print('No user')
    restaurantes = Restaurante.objects.all()  
    result = False

    if request.GET.get('mySearch'):
        search_query = request.GET.get('mySearch')   
        if not search_query.isdigit():
            restaurantes = Restaurante.objects.distinct().filter(Q(nome__icontains=search_query) |
                                                        Q(tipo__icontains=search_query) |
                                                        Q(descricao__icontains=search_query) 
                                                        )
        else:
            restaurantes = Restaurante.objects.distinct().filter(
                                                        Q(rating__gte=search_query)
                                                        )
    request.session['mesa'] = nmesa
    context={
        'restaurantes' : restaurantes,
        'mesa' : nmesa,
        'authorized': result,
        'user': str(user)
    }
    
    return render(request, 'index.html', context)

def restaurant(request, rest_id):
    
    user = request.user

    nmesa = request.session['mesa']
    all_items = ""
     
    rest_to_check = Restaurante.objects.get(pk=rest_id)

    restapi = False
    
    if rest_to_check.api is None:
        try:
            all_items = Item.objects.filter(restaurante=rest_to_check)
            if request.GET.get('filter'):
                search_query = request.GET.get('filter')   
                print(search_query)
                if not search_query.isdigit():
                    all_items = Item.objects.distinct().filter(Q(item_tipo=search_query) 
                                                               & Q(restaurante=rest_to_check) )    
        except Exception as e:
            print(e)
            print("No items")
        
    else:
        restapi = True
        all_items = getAllitems(rest_to_check)
    
    

    context = {
        'items' : all_items,
        'mesa' : nmesa,
        'restapi' : restapi,
        'restaurante' : rest_to_check,
        'user' : str(user)
    }
    
    return render(request, 'restaurant.html', context)


def cart(request):

    user = request.user

    nmesa = request.session['mesa']
    all_items_in_cart = ""
    pedido = None

    if request.user.is_authenticated:
        cliente = Profile.objects.get(user=request.user.id)
        pedido, criado = Pedido.objects.get_or_create(cliente=cliente, finalizado=False, 
                                                      pedido_pago=False, mesa=nmesa)
        all_items_in_cart = pedido.itempedido_set.all()


    context = {
        'items' : all_items_in_cart,
        'mesa' : nmesa,
        'pedido' : pedido,
        'user' : str(user)
    }
    
    return render(request, 'cart.html', context)



def checkout(request):

    user = request.user

    nmesa = request.session['mesa']
    all_items_in_cart = ""
    pedido = None

    if request.user.is_authenticated:
        cliente = Profile.objects.get(user=request.user.id)
        pedido, criado = Pedido.objects.get_or_create(cliente=cliente, finalizado=False,
                                                      pedido_pago=False,)
        all_items_in_cart = pedido.itempedido_set.all()


    context = {
        'items' : all_items_in_cart,
        'mesa' : nmesa,
        'pedido' : pedido,
        'user' : str(user),
        'profile' : request.user.profile
    }
    
    return render(request, 'checkout.html', context)


def delivery(request):

    user = request.user
    nmesa = request.session['mesa']
    all_items_in_cart = ""
    pedidos = None

    if request.user.is_authenticated:
        cliente = Profile.objects.get(user=user)
        try:
            pedidos = Pedido.objects.filter(cliente=cliente, finalizado=False,
                                        pedido_pago=True, pedido_entregue=False)
        except:
            pedidos = Pedido.objects.filter(cliente=cliente, finalizado=False,
                                        pedido_pago=True, pedido_entregue=True)

    print(len(pedidos))
    for ped in pedidos:
        print(ped)

    context = {
        'mesa' : nmesa,
        'pedidos' : pedidos,
        'user' : str(user),
        'profile' : request.user.profile
    }
    
    return render(request, 'waiting_delivery.html', context)


def update_item(request):

    data = json.loads(request.body)
    print(data)
    item_id = data['itemId']
    action = data['action']
    cliente = request.user.profile
    item = Item.objects.get(id=item_id)
    
    pedido, created = Pedido.objects.get_or_create(cliente=cliente, finalizado=False,
                                                    mesa=request.session['mesa'], pedido_pago=False)
    
    item_pedido, created = ItemPedido.objects.get_or_create(pedido=pedido, item=item)
    
    if action == 'add':
        item_pedido.quantidade = (item_pedido.quantidade + 1)
    
    elif action == 'remove':
        item_pedido.quantidade = (item_pedido.quantidade - 1)
    item_pedido.save()
   
    if item_pedido.quantidade <= 0:
        item_pedido.delete()
    return JsonResponse('Item foi adicionado ou atualizado', safe=False)


def process_order(request):
    # cria o id da transação
    numero_transacao = datetime.datetime.now().timestamp()
    data = json.loads(request.body)

    if request.user.is_authenticated:
        cliente = request.user.profile
        pedido, created = Pedido.objects.get_or_create(cliente=cliente, 
                                                       finalizado=False, pedido_pago=False)

    total = float(data['form']['total'])
    pedido.numero_transacao = numero_transacao
    
  
    if total == float(pedido.get_total):
        pedido.pedido_pago = True
        # TODO enviar emails
        # sendEmail(request, pedido)
   
    pedido.save()
    
    return JsonResponse('Payment submitted.', safe=False)

