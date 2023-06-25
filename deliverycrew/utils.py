from django.shortcuts import redirect
from django.contrib import messages

def check_user_delivery(function):
    def wrapper(request, *args, **kwargs):
        if request.user.groups.filter(name="delivery").exists():
            return function(request, *args, **kwargs)
        messages.info(request, 'Utilizador atualizado com sucesso!')
        redirect('home', request.session['mesa'])
    return wrapper
