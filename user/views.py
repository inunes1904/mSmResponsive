from django.shortcuts import redirect, render
from .utils import *
from django.contrib import messages
from django.contrib.auth.models import User
from django.contrib.auth import logout
from .models import Profile
from .forms import ProfileForm
from django.contrib.auth.decorators import login_required

# Create your views here.
def userlogin(request):
    context={}
    if request.method == 'POST':
        
        email = request.POST.get('email')
        user = request.POST.get('username')
        pwd = request.POST.get("pswd")
        pwdconfirm = request.POST.get("pswd2")

        if pwdconfirm == None or email == None:
            print("REALIZAR LOGIN")
            result = make_authentication(request, user, pwd)
            if not result:
                messages.error(request, "Nome de utilizador ou password incorretos")
            else:
                messages.success(request, "Login realizado com sucesso")
                return redirect('home', request.session['mesa'])
        else:
            print("REALIZAR REGISTO")
            if pwd == pwdconfirm:
                try:
                    new_user = User.objects.create_user(username=user, email=email,
                                                        password=pwd)
                    new_user.save()
                    messages.success(request, "Utilizador criado com sucesso")
                except:
                    messages.error(request, "Email ou Utilizador já existem")
                
            else:
                messages.error(request, "Passwords digitadas não são iguais")

    return render(request, 'login.html', context)


@login_required
def logout_user(request):
    mesa = request.session['mesa']
    logout(request)
    messages.info(request, 'Utilizador saiu com sucesso!')
    return redirect('home', mesa )


@login_required
def edit_profile(request):
    mesa = request.session['mesa']
    profile = request.user.profile
    form = ProfileForm(instance=profile)
    if request.method == 'POST':
        form = ProfileForm(request.POST, request.FILES, instance=profile)
        if form.is_valid():
            form.save()
            messages.success(request, 'Utilizador atualizado com sucesso!')
            return redirect('profile')
    context={ 
             'profile':profile,
             'form':form,
             'user': request.user,
             'mesa':mesa
             }
    return render(request, 'edit_profile.html', context)


@login_required
def profile(request):
    mesa = request.session['mesa']
    profile = request.user.profile
    context={ 
             'profile':profile,
             'user': request.user,
             'mesa':mesa
             }
    return render(request, 'profile.html', context)