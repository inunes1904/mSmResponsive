from django.shortcuts import render
from restaurant.models import Pedido, Profile
from .utils import check_user_delivery

# Create your views here.
@check_user_delivery
def home_delivery_crew(request):

    user = request.user


    context = {
        'items' : "all_items_in_cart",
        'mesa' : 0,
        'pedido' : "pedido",
        'user' : str(user),
        'profile' : "request.user.profile"
    }

    return render(request, 'delivery_crew.html', context)