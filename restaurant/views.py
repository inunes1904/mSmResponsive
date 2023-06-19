import json
from django.http import HttpResponse, JsonResponse
from django.shortcuts import redirect, render
from .utils import getAllitems
from .models import Restaurante, Item, Pedido, ItemPedido
from django.contrib.auth.models import User
from user.models import Profile


# Create your views here.

def home(request, nmesa):

    user = request.user
    print(user)

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
        pedido, criado = Pedido.objects.get_or_create(cliente=cliente, finalizado=False)
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
        pedido, criado = Pedido.objects.get_or_create(cliente=cliente, finalizado=False)
        all_items_in_cart = pedido.itempedido_set.all()


    context = {
        'items' : all_items_in_cart,
        'mesa' : nmesa,
        'pedido' : pedido,
        'user' : str(user)
    }
    
    return render(request, 'checkout.html', context)


def update_item(request):
    print("\n\nCHEGUEI\n\n")
    data = json.loads(request.body)
    print(data)
    item_id = data['itemId']
    action = data['action']
    cliente = request.user.profile
    item = Item.objects.get(id=item_id)
    pedido, created = Pedido.objects.get_or_create(cliente=cliente, finalizado=False)

    item_pedido, created = ItemPedido.objects.get_or_create(pedido=pedido, item=item)

    # Se a acao for igual a add adiciona o item a order
    if action == 'add':
        item_pedido.quantidade = (item_pedido.quantidade + 1)
    # Se a acao for igual a remove, remove o item a order
    elif action == 'remove':
        item_pedido.quantidade = (item_pedido.quantidade - 1)
    item_pedido.save()
    # caso o orderitem tenha quantidade negativa queremos removelo da order
    if item_pedido.quantidade <= 0:
        item_pedido.delete()
    return JsonResponse('Item foi adicionado ou atualizado', safe=False)