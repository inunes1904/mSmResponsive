from django.shortcuts import render
from .utils import getAllitems

# Create your views here.
def restaurant(request):

    context = {}
    getAllitems()
    return render(request, 'restaurant.html', context)