from django.db import models
from django.contrib.auth.models import User


# Create your models here.
class Profile(models.Model):
    user = models.OneToOneField(User, null=True, blank=True, on_delete=models.CASCADE)
    nome = models.CharField(max_length=250, default='Escreva o nome')
    role = models.CharField(max_length=50, null=False, default='utilizador')
    morada = models.CharField(max_length=250, null=True, blank=True,)
    contribuinte = models.CharField(max_length=9, null=True, blank=True,)
    profile_imagem = models.ImageField(null=True, blank=True, upload_to="user/", default="user/user-default.png")
    
    def __str__(self):
        return self.nome