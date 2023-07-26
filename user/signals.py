from django.db.models.signals import post_save

from django.contrib.auth.models import User
from .models import Profile
from django.core.mail import send_mail
from django.conf import settings



def create_profile(sender, instance, created, **kwargs):
    if created:
        user = instance
        profile = Profile.objects.create(
            user=user, 
            nome="Escreva aqui o seu nome",
            role="utilizador"
        )
        subject = 'Bem vindo a plataforma MallSafeMeals'
        msg = 'Estamos muito contentes que seja nosso cliente\n' \
                    +'iremos procurar mantê-lo pois para nós\n' \
                    +'você é importante!\n\n\nObrigado pela confiança!'
                
        send_mail(
            subject,
            msg,
            settings.EMAIL_HOST_USER,
            [user.email],
            fail_silently=False,
        )

post_save.connect(create_profile, sender=User)
