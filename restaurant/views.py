from django.http import HttpResponse
from django.shortcuts import redirect, render
from .utils import getAllitems
from .models import Restaurante, Item, Pedido
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
        'user': user
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
        'user' : user
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
        'user' : user
    }
    
    return render(request, 'cart.html', context)


