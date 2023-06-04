from django.shortcuts import redirect, render
from .utils import *
from django.contrib import messages
from django.contrib.auth.models import User

# Create your views here.
def login(request):

    context={}

    if request.method == 'POST':
        
        email = request.POST.get('email')
        user = request.POST.get('username')
        pwd = request.POST.get("pswd")
        pwdconfirm = request.POST.get("pswd2")
        
        print(email,user, pwd, pwdconfirm)

        if pwdconfirm == None or email == None:
            print("REALIZAR LOGIN")
            result = make_authentication(request.POST["username"],
                                         request.POST["pswd"])
            if not result:
                messages.error(request, "Nome de utilizador ou password incorretos")
            else:
                messages.success(request, "Login realizado com sucesso")
                return redirect('/')

        else:
            print("REALIZAR REGISTO")
            if pwd == pwdconfirm:
                try:
                    new_user = User.objects.create_user(username=user, email=email,
                                                        password=pwd)
                    messages.success(request, "Utilizador criado com sucesso")
                except:
                    messages.error(request, "Email ou Utilizador já existem")
                
            else:
                messages.error(request, "Passwords digitadas não são iguais")

    return render(request, 'login.html', context)