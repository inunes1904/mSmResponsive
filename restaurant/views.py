from django.shortcuts import render
from .utils import getAllitems

# Create your views here.
def restaurant(request):

    all_items = getAllitems()


    context = {
        'items' : all_items
    }
    
    return render(request, 'restaurant.html', context)